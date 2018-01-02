From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH for sg3_utils 2/4] configure.ac: Only link with the pthread library if required
Date: Tue,  2 Jan 2018 10:13:39 -0800
Message-ID: <20180102181341.13435-3-bart.vanassche@wdc.com>
References: <20180102181341.13435-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:36146 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751238AbeABSNo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2018 13:13:44 -0500
In-Reply-To: <20180102181341.13435-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: Hannes Reinecke <hare@suse.com>, Bean Huo <beanhuo@micron.com>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Let the configure script detect whether pthread functions occur in the
pthread library (all platforms except Android) or in the C library
(Android). From the autoconf manual:

  action-if-found is a list of shell commands to run if the link with the
  library succeeds; action-if-not-found is a list of shell commands to run
  if the link fails. If action-if-found is not specified, the default action
  prepends -llibrary to LIBS and defines 'HAVE_LIBlibrary' (in all capitals).

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 Makefile.in         |  1 +
 config.h.in         |  4 +--
 configure           | 94 +++++++++++++++--------------------------------------
 configure.ac        | 10 ++++--
 doc/Makefile.in     |  1 +
 include/Makefile.in |  1 +
 lib/Makefile.in     |  1 +
 scripts/Makefile.in |  1 +
 src/Makefile.am     |  2 +-
 src/Makefile.in     |  3 +-
 10 files changed, 45 insertions(+), 73 deletions(-)

diff --git a/Makefile.in b/Makefile.in
index 0054cfe62bd6..4e2b06453f28 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -261,6 +261,7 @@ PACKAGE_TARNAME = @PACKAGE_TARNAME@
 PACKAGE_URL = @PACKAGE_URL@
 PACKAGE_VERSION = @PACKAGE_VERSION@
 PATH_SEPARATOR = @PATH_SEPARATOR@
+PTHREAD_LIB = @PTHREAD_LIB@
 RANLIB = @RANLIB@
 SED = @SED@
 SET_MAKE = @SET_MAKE@
diff --git a/config.h.in b/config.h.in
index b33212f47d27..b5c6715ade05 100644
--- a/config.h.in
+++ b/config.h.in
@@ -36,10 +36,10 @@
 /* Define to 1 if you have the `posix_memalign' function. */
 #undef HAVE_POSIX_MEMALIGN
 
-/* Found pthread_cancel */
+/* Define to 1 if you have the `pthread_cancel' function. */
 #undef HAVE_PTHREAD_CANCEL
 
-/* Found pthread_kill */
+/* Define to 1 if you have the `pthread_kill' function. */
 #undef HAVE_PTHREAD_KILL
 
 /* Define to 1 if you have the <stdint.h> header file. */
diff --git a/configure b/configure
index 5fe9a187a373..59b01f4fdf5b 100755
--- a/configure
+++ b/configure
@@ -652,6 +652,7 @@ OS_FREEBSD_TRUE
 os_libs
 os_cflags
 GETOPT_O_FILES
+PTHREAD_LIB
 CPP
 LT_SYS_LIBRARY_PATH
 OTOOL64
@@ -12332,9 +12333,10 @@ _ACEOF
 fi
 done
 
-{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for library containing pthread_cancel" >&5
-$as_echo_n "checking for library containing pthread_cancel... " >&6; }
-if ${ac_cv_search_pthread_cancel+:} false; then :
+SAVED_LIBS=$LIBS
+{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for library containing pthread_create" >&5
+$as_echo_n "checking for library containing pthread_create... " >&6; }
+if ${ac_cv_search_pthread_create+:} false; then :
   $as_echo_n "(cached) " >&6
 else
   ac_func_search_save_LIBS=$LIBS
@@ -12347,11 +12349,11 @@ cat confdefs.h - <<_ACEOF >conftest.$ac_ext
 #ifdef __cplusplus
 extern "C"
 #endif
-char pthread_cancel ();
+char pthread_create ();
 int
 main ()
 {
-return pthread_cancel ();
+return pthread_create ();
   ;
   return 0;
 }
@@ -12364,89 +12366,47 @@ for ac_lib in '' pthread; do
     LIBS="-l$ac_lib  $ac_func_search_save_LIBS"
   fi
   if ac_fn_c_try_link "$LINENO"; then :
-  ac_cv_search_pthread_cancel=$ac_res
+  ac_cv_search_pthread_create=$ac_res
 fi
 rm -f core conftest.err conftest.$ac_objext \
     conftest$ac_exeext
-  if ${ac_cv_search_pthread_cancel+:} false; then :
+  if ${ac_cv_search_pthread_create+:} false; then :
   break
 fi
 done
-if ${ac_cv_search_pthread_cancel+:} false; then :
+if ${ac_cv_search_pthread_create+:} false; then :
 
 else
-  ac_cv_search_pthread_cancel=no
+  ac_cv_search_pthread_create=no
 fi
 rm conftest.$ac_ext
 LIBS=$ac_func_search_save_LIBS
 fi
-{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_cv_search_pthread_cancel" >&5
-$as_echo "$ac_cv_search_pthread_cancel" >&6; }
-ac_res=$ac_cv_search_pthread_cancel
+{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_cv_search_pthread_create" >&5
+$as_echo "$ac_cv_search_pthread_create" >&6; }
+ac_res=$ac_cv_search_pthread_create
 if test "$ac_res" != no; then :
   test "$ac_res" = "none required" || LIBS="$ac_res $LIBS"
 
-$as_echo "#define HAVE_PTHREAD_CANCEL 1" >>confdefs.h
-
 fi
 
-{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for library containing pthread_kill" >&5
-$as_echo_n "checking for library containing pthread_kill... " >&6; }
-if ${ac_cv_search_pthread_kill+:} false; then :
-  $as_echo_n "(cached) " >&6
-else
-  ac_func_search_save_LIBS=$LIBS
-cat confdefs.h - <<_ACEOF >conftest.$ac_ext
-/* end confdefs.h.  */
-
-/* Override any GCC internal prototype to avoid an error.
-   Use char because int might match the return type of a GCC
-   builtin and then its argument prototype would still apply.  */
-#ifdef __cplusplus
-extern "C"
-#endif
-char pthread_kill ();
-int
-main ()
-{
-return pthread_kill ();
-  ;
-  return 0;
-}
+# AC_SEARCH_LIBS adds libraries at the start of $LIBS so remove $SAVED_LIBS
+# from the end of $LIBS.
+pthread_lib=${LIBS%${SAVED_LIBS}}
+for ac_func in pthread_cancel pthread_kill
+do :
+  as_ac_var=`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
+ac_fn_c_check_func "$LINENO" "$ac_func" "$as_ac_var"
+if eval test \"x\$"$as_ac_var"\" = x"yes"; then :
+  cat >>confdefs.h <<_ACEOF
+#define `$as_echo "HAVE_$ac_func" | $as_tr_cpp` 1
 _ACEOF
-for ac_lib in '' pthread; do
-  if test -z "$ac_lib"; then
-    ac_res="none required"
-  else
-    ac_res=-l$ac_lib
-    LIBS="-l$ac_lib  $ac_func_search_save_LIBS"
-  fi
-  if ac_fn_c_try_link "$LINENO"; then :
-  ac_cv_search_pthread_kill=$ac_res
-fi
-rm -f core conftest.err conftest.$ac_objext \
-    conftest$ac_exeext
-  if ${ac_cv_search_pthread_kill+:} false; then :
-  break
-fi
-done
-if ${ac_cv_search_pthread_kill+:} false; then :
 
-else
-  ac_cv_search_pthread_kill=no
-fi
-rm conftest.$ac_ext
-LIBS=$ac_func_search_save_LIBS
 fi
-{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_cv_search_pthread_kill" >&5
-$as_echo "$ac_cv_search_pthread_kill" >&6; }
-ac_res=$ac_cv_search_pthread_kill
-if test "$ac_res" != no; then :
-  test "$ac_res" = "none required" || LIBS="$ac_res $LIBS"
-
-$as_echo "#define HAVE_PTHREAD_KILL 1" >>confdefs.h
+done
 
-fi
+LIBS=$SAVED_LIBS
+PTHREAD_LIB=$pthread_lib
 
 
 
diff --git a/configure.ac b/configure.ac
index 129c2f9d4d4d..6164850d0aa3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -25,8 +25,14 @@ AC_CHECK_FUNCS(posix_fadvise)
 AC_CHECK_FUNCS(posix_memalign)
 AC_CHECK_FUNCS(sysconf)
 AC_CHECK_FUNCS(lseek64)
-AC_SEARCH_LIBS([pthread_cancel], [pthread], [AC_DEFINE(HAVE_PTHREAD_CANCEL, 1, [Found pthread_cancel])], [])
-AC_SEARCH_LIBS([pthread_kill], [pthread], [AC_DEFINE(HAVE_PTHREAD_KILL, 1, [Found pthread_kill])], [])
+SAVED_LIBS=$LIBS
+AC_SEARCH_LIBS([pthread_create], [pthread])
+# AC_SEARCH_LIBS adds libraries at the start of $LIBS so remove $SAVED_LIBS
+# from the end of $LIBS.
+pthread_lib=${LIBS%${SAVED_LIBS}}
+AC_CHECK_FUNCS([pthread_cancel pthread_kill])
+LIBS=$SAVED_LIBS
+AC_SUBST(PTHREAD_LIB, [$pthread_lib])
 AC_SUBST(GETOPT_O_FILES)
 
 AC_CANONICAL_HOST
diff --git a/doc/Makefile.in b/doc/Makefile.in
index 012c294ccf6b..5b3f009554af 100644
--- a/doc/Makefile.in
+++ b/doc/Makefile.in
@@ -219,6 +219,7 @@ PACKAGE_TARNAME = @PACKAGE_TARNAME@
 PACKAGE_URL = @PACKAGE_URL@
 PACKAGE_VERSION = @PACKAGE_VERSION@
 PATH_SEPARATOR = @PATH_SEPARATOR@
+PTHREAD_LIB = @PTHREAD_LIB@
 RANLIB = @RANLIB@
 SED = @SED@
 SET_MAKE = @SET_MAKE@
diff --git a/include/Makefile.in b/include/Makefile.in
index f0f4a2b17745..0016be3edf15 100644
--- a/include/Makefile.in
+++ b/include/Makefile.in
@@ -239,6 +239,7 @@ PACKAGE_TARNAME = @PACKAGE_TARNAME@
 PACKAGE_URL = @PACKAGE_URL@
 PACKAGE_VERSION = @PACKAGE_VERSION@
 PATH_SEPARATOR = @PATH_SEPARATOR@
+PTHREAD_LIB = @PTHREAD_LIB@
 RANLIB = @RANLIB@
 SED = @SED@
 SET_MAKE = @SET_MAKE@
diff --git a/lib/Makefile.in b/lib/Makefile.in
index 2594c724aa96..35d83c1d3dd6 100644
--- a/lib/Makefile.in
+++ b/lib/Makefile.in
@@ -283,6 +283,7 @@ PACKAGE_TARNAME = @PACKAGE_TARNAME@
 PACKAGE_URL = @PACKAGE_URL@
 PACKAGE_VERSION = @PACKAGE_VERSION@
 PATH_SEPARATOR = @PATH_SEPARATOR@
+PTHREAD_LIB = @PTHREAD_LIB@
 RANLIB = @RANLIB@
 SED = @SED@
 SET_MAKE = @SET_MAKE@
diff --git a/scripts/Makefile.in b/scripts/Makefile.in
index 0a81294b1d67..1daa3818f5cb 100644
--- a/scripts/Makefile.in
+++ b/scripts/Makefile.in
@@ -208,6 +208,7 @@ PACKAGE_TARNAME = @PACKAGE_TARNAME@
 PACKAGE_URL = @PACKAGE_URL@
 PACKAGE_VERSION = @PACKAGE_VERSION@
 PATH_SEPARATOR = @PATH_SEPARATOR@
+PTHREAD_LIB = @PTHREAD_LIB@
 RANLIB = @RANLIB@
 SED = @SED@
 SET_MAKE = @SET_MAKE@
diff --git a/src/Makefile.am b/src/Makefile.am
index 4c3bb1caff71..33c7be515b8d 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -86,7 +86,7 @@ sg_modes_LDADD = ../lib/libsgutils2.la @os_libs@
 
 sg_opcodes_LDADD = ../lib/libsgutils2.la @os_libs@
 
-sgp_dd_LDADD = ../lib/libsgutils2.la @os_libs@ -lpthread
+sgp_dd_LDADD = ../lib/libsgutils2.la @os_libs@ @PTHREAD_LIB@
 
 sg_persist_LDADD = ../lib/libsgutils2.la @os_libs@
 
diff --git a/src/Makefile.in b/src/Makefile.in
index 3117f2528d76..eec196432869 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -499,6 +499,7 @@ PACKAGE_TARNAME = @PACKAGE_TARNAME@
 PACKAGE_URL = @PACKAGE_URL@
 PACKAGE_VERSION = @PACKAGE_VERSION@
 PATH_SEPARATOR = @PATH_SEPARATOR@
+PTHREAD_LIB = @PTHREAD_LIB@
 RANLIB = @RANLIB@
 SED = @SED@
 SET_MAKE = @SET_MAKE@
@@ -590,7 +591,7 @@ sg_map_LDADD = ../lib/libsgutils2.la @os_libs@
 sgm_dd_LDADD = ../lib/libsgutils2.la @os_libs@
 sg_modes_LDADD = ../lib/libsgutils2.la @os_libs@
 sg_opcodes_LDADD = ../lib/libsgutils2.la @os_libs@
-sgp_dd_LDADD = ../lib/libsgutils2.la @os_libs@ -lpthread
+sgp_dd_LDADD = ../lib/libsgutils2.la @os_libs@ @PTHREAD_LIB@
 sg_persist_LDADD = ../lib/libsgutils2.la @os_libs@
 sg_prevent_LDADD = ../lib/libsgutils2.la @os_libs@
 sg_raw_LDADD = ../lib/libsgutils2.la @os_libs@
-- 
2.15.1
