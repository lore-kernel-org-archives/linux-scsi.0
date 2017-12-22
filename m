From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: [RFC] sg3_utils: sgp_dd: work around on pthread_cancel for android
Date: Fri, 22 Dec 2017 17:00:06 +0000
Message-ID: <e5c8b6616ea7487d83087da7623576ae@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:37029 "EHLO
        mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754212AbdLVRAS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Dec 2017 12:00:18 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>, "hare@suse.de" <hare@suse.de>, "Bean Huo (beanhuo)" <beanhuo@micron.com>

pthread_cancel is not supported by Android Bionic C library
pthread. Based on my searched information online, pthread_cancel
sometimes is likely to lead to memory leaks and dead locks.
If we use android NDK or standalone toolchain to cross complile
sg3_utils, below failure appeared.

    "....aarch64-linux-android/bin/ld: cannot find -lpthread
    collect2: error: ld returned 1 exit status
    Makefile:990: recipe for target 'sgp_dd' failed"

This patch is using signal to replace the cancel call when host_os is
android system.

Signed-off-by: beanhuo <beanhuo@micron.com>
---
 configure       | 30 ++++++++++++++++++++++++++++++
 configure.ac    |  6 ++++++
 src/Makefile.am |  4 ++++
 src/sgp_dd.c    | 17 +++++++++++++++++
 4 files changed, 57 insertions(+)

diff --git a/configure b/configure
index 9958be2..d9f23f2 100755
--- a/configure
+++ b/configure
@@ -635,6 +635,8 @@ ac_subst_vars='am__EXEEXT_FALSE
 am__EXEEXT_TRUE
 LTLIBOBJS
 LIBOBJS
+OS_ANDROID_FALSE
+OS_ANDROID_TRUE
 OS_WIN32_CYGWIN_FALSE
 OS_WIN32_CYGWIN_TRUE
 OS_WIN32_MINGW_FALSE
@@ -12292,6 +12294,21 @@ _ACEOF
 
 
 case "${host}" in
+        *-*-android*)
+
+cat >>confdefs.h <<_ACEOF
+#define SG_ON_ANDROID 1
+_ACEOF
+
+
+cat >>confdefs.h <<_ACEOF
+#define SG_LIB_LINUX 1
+_ACEOF
+
+                os_cflags=''
+
+                os_libs=''
+ ;;
         *-*-linux-gnu*)
 
 cat >>confdefs.h <<_ACEOF
@@ -12428,6 +12445,14 @@ else
   OS_WIN32_CYGWIN_FALSE=
 fi
 
+ if echo $host_os | grep 'android' > /dev/null; then
+  OS_ANDROID_TRUE=
+  OS_ANDROID_FALSE='#'
+else
+  OS_ANDROID_TRUE='#'
+  OS_ANDROID_FALSE=
+fi
+
 
 # Check whether --enable-linuxbsg was given.
 if test "${enable_linuxbsg+set}" = set; then :
@@ -12624,6 +12649,10 @@ if test -z "${OS_WIN32_CYGWIN_TRUE}" && test -z "${OS_WIN32_CYGWIN_FALSE}"; then
   as_fn_error $? "conditional \"OS_WIN32_CYGWIN\" was never defined.
 Usually this means the macro was only invoked conditionally." "$LINENO" 5
 fi
+if test -z "${OS_ANDROID_TRUE}" && test -z "${OS_ANDROID_FALSE}"; then
+  as_fn_error $? "conditional \"OS_ANDROID\" was never defined.
+Usually this means the macro was only invoked conditionally." "$LINENO" 5
+fi
 
 : "${CONFIG_STATUS=./config.status}"
 ac_write_fail=0
@@ -14211,6 +14240,7 @@ $as_echo X"$file" |
     cat <<_LT_EOF >> "$cfgfile"
 #! $SHELL
 # Generated automatically by $as_me ($PACKAGE) $VERSION
+# Libtool was configured on host `(hostname || uname -n) 2>/dev/null | sed 1q`:
 # NOTE: Changes made to this file will be lost: look at ltmain.sh.
 
 # Provide generalized library-building support services.
diff --git a/configure.ac b/configure.ac
index 6c35d1a..cef0686 100644
--- a/configure.ac
+++ b/configure.ac
@@ -37,6 +37,11 @@ AC_CANONICAL_HOST
 AC_DEFINE_UNQUOTED(SG_LIB_BUILD_HOST, "${host}", [sg3_utils Build Host])
 
 case "${host}" in
+        *-*-android*)
+		AC_DEFINE_UNQUOTED(SG_ON_ANDROID, 1, [sg3_utils on android])
+		AC_DEFINE_UNQUOTED(SG_LIB_LINUX, 1, [sg3_utils on linux])
+                AC_SUBST([os_cflags], [''])
+                AC_SUBST([os_libs], ['']) ;;
         *-*-linux-gnu*)
 		AC_DEFINE_UNQUOTED(SG_LIB_LINUX, 1, [sg3_utils on linux])
                 AC_SUBST([os_cflags], [''])
@@ -79,6 +84,7 @@ AM_CONDITIONAL(OS_OSF, [echo $host_os | grep '^osf' > /dev/null])
 AM_CONDITIONAL(OS_SOLARIS, [echo $host_os | grep '^solaris' > /dev/null])
 AM_CONDITIONAL(OS_WIN32_MINGW, [echo $host_os | grep '^mingw' > /dev/null])
 AM_CONDITIONAL(OS_WIN32_CYGWIN, [echo $host_os | grep '^cygwin' > /dev/null])
+AM_CONDITIONAL(OS_ANDROID, [echo $host_os | grep 'android' > /dev/null])
 
 AC_ARG_ENABLE([linuxbsg],
   AC_HELP_STRING([--disable-linuxbsg], [ignore linux bsg (sgv4) if present]),
diff --git a/src/Makefile.am b/src/Makefile.am
index 1012a78..daada79 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -86,7 +86,11 @@ sg_modes_LDADD = ../lib/libsgutils2.la @os_libs@
 
 sg_opcodes_LDADD = ../lib/libsgutils2.la @os_libs@
 
+if OS_ANDROID
+sgp_dd_LDADD = ../lib/libsgutils2.la @os_libs@
+else
 sgp_dd_LDADD = ../lib/libsgutils2.la @os_libs@ -lpthread
+endif
 
 sg_persist_LDADD = ../lib/libsgutils2.la @os_libs@
 
diff --git a/src/sgp_dd.c b/src/sgp_dd.c
index e154555..d59167c 100644
--- a/src/sgp_dd.c
+++ b/src/sgp_dd.c
@@ -1121,6 +1121,11 @@ process_flags(const char * arg, struct flags_t * fp)
     return 0;
 }
 
+void
+thread_exit_handler(int sig)
+{
+    pthread_exit(0);
+}
 
 #define STR_SZ 1024
 #define INOUTF_SZ 512
@@ -1147,6 +1152,14 @@ main(int argc, char * argv[])
     int in_sect_sz, out_sect_sz, status, n, flags;
     void * vp;
     char ebuff[EBUFF_SZ];
+#if SG_ON_ANDROID
+    struct sigaction actions;
+    memset(&actions, 0, sizeof(actions));
+    sigemptyset(&actions.sa_mask);
+    actions.sa_flags = 0;
+    actions.sa_handler = thread_exit_handler;
+    sigaction(SIGUSR1,&actions,NULL);
+#endif
 
     memset(&rcoll, 0, sizeof(Rq_coll));
     rcoll.bpt = DEF_BLOCKS_PER_TRANSFER;
@@ -1629,7 +1642,11 @@ main(int argc, char * argv[])
         }
     }
 
+#if SG_ON_ANDROID
+    status = pthread_kill(sig_listen_thread_id, SIGUSR1);
+#else
     status = pthread_cancel(sig_listen_thread_id);
+#endif
     if (0 != status) err_exit(status, "pthread_cancel");
     if (STDIN_FILENO != rcoll.infd)
         close(rcoll.infd);
-- 
2.7.4
