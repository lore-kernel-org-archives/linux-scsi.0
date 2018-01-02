From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH for sg3_utils 3/4] configure.ac: Avoid code duplication
Date: Tue,  2 Jan 2018 10:13:40 -0800
Message-ID: <20180102181341.13435-4-bart.vanassche@wdc.com>
References: <20180102181341.13435-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:47620 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750985AbeABSNp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2018 13:13:45 -0500
In-Reply-To: <20180102181341.13435-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: Hannes Reinecke <hare@suse.com>, Bean Huo <beanhuo@micron.com>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Ensure that the code for checking the Linux NVMe headers occurs once.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 config.h.in  |   2 +-
 configure    | 124 ++++-------------------------------------------------------
 configure.ac |  45 ++++++----------------
 3 files changed, 21 insertions(+), 150 deletions(-)

diff --git a/config.h.in b/config.h.in
index b5c6715ade05..6050d85dfc1c 100644
--- a/config.h.in
+++ b/config.h.in
@@ -105,7 +105,7 @@
 /* sg3_utils on FreeBSD */
 #undef SG_LIB_FREEBSD
 
-/* assume sg3_utils on linux */
+/* sg3_utils on linux */
 #undef SG_LIB_LINUX
 
 /* also MinGW environment */
diff --git a/configure b/configure
index 59b01f4fdf5b..ce82b6d23236 100755
--- a/configure
+++ b/configure
@@ -12418,18 +12418,8 @@ cat >>confdefs.h <<_ACEOF
 _ACEOF
 
 
-case "${host}" in
-        *-*-linux-gnu*)
-
-cat >>confdefs.h <<_ACEOF
-#define SG_LIB_LINUX 1
-_ACEOF
-
-                os_cflags=''
-
-                os_libs=''
-
-		for ac_header in linux/nvme_ioctl.h
+check_for_linux_nvme_headers() {
+	for ac_header in linux/nvme_ioctl.h
 do :
   ac_fn_c_check_header_mongrel "$LINENO" "linux/nvme_ioctl.h" "ac_cv_header_linux_nvme_ioctl_h" "$ac_includes_default"
 if test "x$ac_cv_header_linux_nvme_ioctl_h" = xyes; then :
@@ -12443,7 +12433,7 @@ fi
 
 done
 
-		for ac_header in linux/types.h linux/bsg.h linux/kdev_t.h
+	for ac_header in linux/types.h linux/bsg.h linux/kdev_t.h
 do :
   as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
 ac_fn_c_check_header_compile "$LINENO" "$ac_header" "$as_ac_Header" "#ifdef HAVE_LINUX_TYPES_H
@@ -12459,48 +12449,10 @@ _ACEOF
 fi
 
 done
- ;;
-        *-*-linux*)
-
-cat >>confdefs.h <<_ACEOF
-#define SG_LIB_LINUX 1
-_ACEOF
-
-                os_cflags=''
-
-                os_libs=''
-
-		for ac_header in linux/nvme_ioctl.h
-do :
-  ac_fn_c_check_header_mongrel "$LINENO" "linux/nvme_ioctl.h" "ac_cv_header_linux_nvme_ioctl_h" "$ac_includes_default"
-if test "x$ac_cv_header_linux_nvme_ioctl_h" = xyes; then :
-  cat >>confdefs.h <<_ACEOF
-#define HAVE_LINUX_NVME_IOCTL_H 1
-_ACEOF
-
-$as_echo "#define HAVE_NVME 1" >>confdefs.h
-
-fi
-
-done
-
-		for ac_header in linux/types.h linux/bsg.h linux/kdev_t.h
-do :
-  as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
-ac_fn_c_check_header_compile "$LINENO" "$ac_header" "$as_ac_Header" "#ifdef HAVE_LINUX_TYPES_H
-		     # include <linux/types.h>
-		     #endif
 
-"
-if eval test \"x\$"$as_ac_Header"\" = x"yes"; then :
-  cat >>confdefs.h <<_ACEOF
-#define `$as_echo "HAVE_$ac_header" | $as_tr_cpp` 1
-_ACEOF
-
-fi
+}
 
-done
- ;;
+case "${host}" in
 	*-*-android*)
 
 cat >>confdefs.h <<_ACEOF
@@ -12516,37 +12468,7 @@ _ACEOF
 
                 os_libs=''
 
-		for ac_header in linux/nvme_ioctl.h
-do :
-  ac_fn_c_check_header_mongrel "$LINENO" "linux/nvme_ioctl.h" "ac_cv_header_linux_nvme_ioctl_h" "$ac_includes_default"
-if test "x$ac_cv_header_linux_nvme_ioctl_h" = xyes; then :
-  cat >>confdefs.h <<_ACEOF
-#define HAVE_LINUX_NVME_IOCTL_H 1
-_ACEOF
-
-$as_echo "#define HAVE_NVME 1" >>confdefs.h
-
-fi
-
-done
-
-		for ac_header in linux/types.h linux/bsg.h linux/kdev_t.h
-do :
-  as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
-ac_fn_c_check_header_compile "$LINENO" "$ac_header" "$as_ac_Header" "#ifdef HAVE_LINUX_TYPES_H
-		     # include <linux/types.h>
-		     #endif
-
-"
-if eval test \"x\$"$as_ac_Header"\" = x"yes"; then :
-  cat >>confdefs.h <<_ACEOF
-#define `$as_echo "HAVE_$ac_header" | $as_tr_cpp` 1
-_ACEOF
-
-fi
-
-done
- ;;
+		check_for_linux_nvme_headers;;
         *-*-freebsd*|*-*-kfreebsd*-gnu*)
 
 cat >>confdefs.h <<_ACEOF
@@ -12605,7 +12527,7 @@ _ACEOF
 
                 os_libs=''
  ;;
-        *)
+        *-*-linux-gnu* | *-*-linux* | *)
 
 cat >>confdefs.h <<_ACEOF
 #define SG_LIB_LINUX 1
@@ -12615,37 +12537,7 @@ _ACEOF
 
                 os_libs=''
 
-		for ac_header in linux/nvme_ioctl.h
-do :
-  ac_fn_c_check_header_mongrel "$LINENO" "linux/nvme_ioctl.h" "ac_cv_header_linux_nvme_ioctl_h" "$ac_includes_default"
-if test "x$ac_cv_header_linux_nvme_ioctl_h" = xyes; then :
-  cat >>confdefs.h <<_ACEOF
-#define HAVE_LINUX_NVME_IOCTL_H 1
-_ACEOF
-
-$as_echo "#define HAVE_NVME 1" >>confdefs.h
-
-fi
-
-done
-
-		for ac_header in linux/types.h linux/bsg.h linux/kdev_t.h
-do :
-  as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
-ac_fn_c_check_header_compile "$LINENO" "$ac_header" "$as_ac_Header" "#ifdef HAVE_LINUX_TYPES_H
-		     # include <linux/types.h>
-		     #endif
-
-"
-if eval test \"x\$"$as_ac_Header"\" = x"yes"; then :
-  cat >>confdefs.h <<_ACEOF
-#define `$as_echo "HAVE_$ac_header" | $as_tr_cpp` 1
-_ACEOF
-
-fi
-
-done
- ;;
+                check_for_linux_nvme_headers;;
 esac
 
 # Define platform-specific symbol.
diff --git a/configure.ac b/configure.ac
index 6164850d0aa3..70cf98456339 100644
--- a/configure.ac
+++ b/configure.ac
@@ -39,41 +39,25 @@ AC_CANONICAL_HOST
 
 AC_DEFINE_UNQUOTED(SG_LIB_BUILD_HOST, "${host}", [sg3_utils Build Host])
 
-case "${host}" in
-        *-*-linux-gnu*)
-		AC_DEFINE_UNQUOTED(SG_LIB_LINUX, 1, [sg3_utils on linux])
-                AC_SUBST([os_cflags], [''])
-                AC_SUBST([os_libs], [''])
-		AC_CHECK_HEADERS([linux/nvme_ioctl.h], [AC_DEFINE(HAVE_NVME, 1, [Found NVMe])], [], [])
-		AC_CHECK_HEADERS([linux/types.h linux/bsg.h linux/kdev_t.h], [], [],
-		     [[#ifdef HAVE_LINUX_TYPES_H
-		     # include <linux/types.h>
-		     #endif
-		     ]]) ;;
-        *-*-linux*)
-		AC_DEFINE_UNQUOTED(SG_LIB_LINUX, 1, [sg3_utils on linux])
-                AC_SUBST([os_cflags], [''])
-                AC_SUBST([os_libs], [''])
-		AC_CHECK_HEADERS([linux/nvme_ioctl.h], [AC_DEFINE(HAVE_NVME, 1, [Found NVMe])], [], [])
-		AC_CHECK_HEADERS([linux/types.h linux/bsg.h linux/kdev_t.h], [], [],
+check_for_linux_nvme_headers() {
+	AC_CHECK_HEADERS([linux/nvme_ioctl.h], [AC_DEFINE(HAVE_NVME, 1, [Found NVMe])], [], [])
+	AC_CHECK_HEADERS([linux/types.h linux/bsg.h linux/kdev_t.h], [], [],
 		     [[#ifdef HAVE_LINUX_TYPES_H
 		     # include <linux/types.h>
 		     #endif
-		     ]]) ;;
+		     ]])
+}
+
+case "${host}" in
 	*-*-android*)
 		AC_DEFINE_UNQUOTED(SG_LIB_ANDROID, 1, [sg3_utils on android])
 		AC_DEFINE_UNQUOTED(SG_LIB_LINUX, 1, [sg3_utils on linux])
                 AC_SUBST([os_cflags], [''])
                 AC_SUBST([os_libs], [''])
-		AC_CHECK_HEADERS([linux/nvme_ioctl.h], [AC_DEFINE(HAVE_NVME, 1, [Found NVMe])], [], [])
-		AC_CHECK_HEADERS([linux/types.h linux/bsg.h linux/kdev_t.h], [], [],
-		     [[#ifdef HAVE_LINUX_TYPES_H
-		     # include <linux/types.h>
-		     #endif
-		     ]]) ;;
+		check_for_linux_nvme_headers;;
         *-*-freebsd*|*-*-kfreebsd*-gnu*)
 		AC_DEFINE_UNQUOTED(SG_LIB_FREEBSD, 1, [sg3_utils on FreeBSD])
-		AC_DEFINE(HAVE_NVME, 1, ['Found NVMe'])
+		AC_DEFINE(HAVE_NVME, 1, [Found NVMe])
                 AC_SUBST([os_cflags], [''])
                 AC_SUBST([os_libs], ['-lcam']);;
         *-*-solaris*)
@@ -93,16 +77,11 @@ case "${host}" in
 		AC_DEFINE_UNQUOTED(SG_LIB_MINGW, 1, [also MinGW environment])
                 AC_SUBST([os_cflags], [''])
                 AC_SUBST([os_libs], ['']) ;;
-        *)
-		AC_DEFINE_UNQUOTED(SG_LIB_LINUX, 1, [assume sg3_utils on linux])
+        *-*-linux-gnu* | *-*-linux* | *)
+                AC_DEFINE_UNQUOTED(SG_LIB_LINUX, 1, [sg3_utils on linux])
                 AC_SUBST([os_cflags], [''])
                 AC_SUBST([os_libs], [''])
-		AC_CHECK_HEADERS([linux/nvme_ioctl.h], [AC_DEFINE(HAVE_NVME, 1, [Found NVMe])], [], [])
-		AC_CHECK_HEADERS([linux/types.h linux/bsg.h linux/kdev_t.h], [], [],
-		     [[#ifdef HAVE_LINUX_TYPES_H
-		     # include <linux/types.h>
-		     #endif
-		     ]]) ;;
+                check_for_linux_nvme_headers;;
 esac
 
 # Define platform-specific symbol.
-- 
2.15.1
