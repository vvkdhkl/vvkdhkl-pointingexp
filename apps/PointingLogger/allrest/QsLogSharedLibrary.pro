# This pro file will build QsLog as a shared library
include(QsLog.pri)

TARGET = QsLog
VERSION = "2.1.0"
QT -= gui
CONFIG -= console
CONFIG -= app_bundle
CONFIG += shared
TEMPLATE = lib

QSLOG_DESTDIR=$$(QSLOG_DESTDIR)
!isEmpty(QSLOG_DESTDIR) {
    message(Will use $${QSLOG_DESTDIR} as destdir.)
    DESTDIR = $${QSLOG_DESTDIR}/bin
}

win32 {
    DEFINES += QSLOG_IS_SHARED_LIBRARY
}

unix:!macx {
    DISTRO = $$system(uname -a)

    # make install will install the shared object in the appropriate folders
    headers.files = QsLog.h QsLogDest.h QsLogLevel.h
    headers.path = /usr/include/$(QMAKE_TARGET)

    other_files.files = LICENSE.txt QsLogChanges.txt README.md
    other_files.path = /usr/local/share/$(QMAKE_TARGET)
    contains(DISTRO, .*ARCH): other_files.path = /usr/share/$(QMAKE_TARGET)

    contains(QT_ARCH, x86_64) {
        target.path = /usr/lib64
        contains(DISTRO, .*ARCH): target.path = /usr/lib
    } else {
        target.path = /usr/lib
    }

    INSTALLS += headers target other_files
}
