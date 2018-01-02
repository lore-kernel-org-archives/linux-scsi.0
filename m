From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH for sg3_utils 4/4] configure.ac, Makefile.am: Use CFLAGS and LIBS instead of os_cflags and os_libs
Date: Tue,  2 Jan 2018 10:13:41 -0800
Message-ID: <20180102181341.13435-5-bart.vanassche@wdc.com>
References: <20180102181341.13435-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:36146 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751322AbeABSNq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2018 13:13:46 -0500
In-Reply-To: <20180102181341.13435-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: Hannes Reinecke <hare@suse.com>, Bean Huo <beanhuo@micron.com>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Instead of introducing variables for system-specific flags and libraries,
use CFLAGS and LIBS. This simplifies the Makefiles since automake appends
these automatically.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 Makefile.in         |   2 -
 configure           |  36 ++-----------
 configure.ac        |  22 ++------
 doc/Makefile.in     |   2 -
 include/Makefile.in |   2 -
 lib/Makefile.am     |   2 +-
 lib/Makefile.in     |   4 +-
 scripts/Makefile.in |   2 -
 src/Makefile.am     | 140 +++++++++++++++++++++++++-------------------------
 src/Makefile.in     | 144 +++++++++++++++++++++++++---------------------------
 10 files changed, 149 insertions(+), 207 deletions(-)

diff --git a/Makefile.in b/Makefile.in
index 4e2b06453f28..2b88c81c2615 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -308,8 +308,6 @@ localstatedir = @localstatedir@
 mandir = @mandir@
 mkdir_p = @mkdir_p@
 oldincludedir = @oldincludedir@
-os_cflags = @os_cflags@
-os_libs = @os_libs@
 pdfdir = @pdfdir@
 prefix = @prefix@
 program_transform_name = @program_transform_name@
diff --git a/configure b/configure
index ce82b6d23236..af2f7d07e70c 100755
--- a/configure
+++ b/configure
@@ -649,8 +649,6 @@ OS_LINUX_FALSE
 OS_LINUX_TRUE
 OS_FREEBSD_FALSE
 OS_FREEBSD_TRUE
-os_libs
-os_cflags
 GETOPT_O_FILES
 PTHREAD_LIB
 CPP
@@ -12464,10 +12462,6 @@ cat >>confdefs.h <<_ACEOF
 #define SG_LIB_LINUX 1
 _ACEOF
 
-                os_cflags=''
-
-                os_libs=''
-
 		check_for_linux_nvme_headers;;
         *-*-freebsd*|*-*-kfreebsd*-gnu*)
 
@@ -12478,40 +12472,26 @@ _ACEOF
 
 $as_echo "#define HAVE_NVME 1" >>confdefs.h
 
-                os_cflags=''
-
-                os_libs='-lcam'
-;;
+                LIBS="$LIBS -lcam";;
         *-*-solaris*)
 
 cat >>confdefs.h <<_ACEOF
 #define SG_LIB_SOLARIS 1
 _ACEOF
-
-                os_cflags=''
-
-                os_libs=''
 ;;
         *-*-osf*)
 
 cat >>confdefs.h <<_ACEOF
 #define SG_LIB_OSF1 1
 _ACEOF
-
-                os_cflags=''
-
-                os_libs=''
- ;;
+;;
         *-*-cygwin*)
 
 cat >>confdefs.h <<_ACEOF
 #define SG_LIB_WIN32 1
 _ACEOF
 
-                os_cflags='-Wno-char-subscripts'
-
-                os_libs=''
- ;;
+                CFLAGS="$CFLAGS -Wno-char-subscripts";;
         *-*-mingw*)
 
 cat >>confdefs.h <<_ACEOF
@@ -12522,21 +12502,13 @@ _ACEOF
 cat >>confdefs.h <<_ACEOF
 #define SG_LIB_MINGW 1
 _ACEOF
-
-                os_cflags=''
-
-                os_libs=''
- ;;
+;;
         *-*-linux-gnu* | *-*-linux* | *)
 
 cat >>confdefs.h <<_ACEOF
 #define SG_LIB_LINUX 1
 _ACEOF
 
-                os_cflags=''
-
-                os_libs=''
-
                 check_for_linux_nvme_headers;;
 esac
 
diff --git a/configure.ac b/configure.ac
index 70cf98456339..8dffdc51c437 100644
--- a/configure.ac
+++ b/configure.ac
@@ -52,35 +52,23 @@ case "${host}" in
 	*-*-android*)
 		AC_DEFINE_UNQUOTED(SG_LIB_ANDROID, 1, [sg3_utils on android])
 		AC_DEFINE_UNQUOTED(SG_LIB_LINUX, 1, [sg3_utils on linux])
-                AC_SUBST([os_cflags], [''])
-                AC_SUBST([os_libs], [''])
 		check_for_linux_nvme_headers;;
         *-*-freebsd*|*-*-kfreebsd*-gnu*)
 		AC_DEFINE_UNQUOTED(SG_LIB_FREEBSD, 1, [sg3_utils on FreeBSD])
 		AC_DEFINE(HAVE_NVME, 1, [Found NVMe])
-                AC_SUBST([os_cflags], [''])
-                AC_SUBST([os_libs], ['-lcam']);;
+                LIBS="$LIBS -lcam";;
         *-*-solaris*)
-		AC_DEFINE_UNQUOTED(SG_LIB_SOLARIS, 1, [sg3_utils on Solaris])
-                AC_SUBST([os_cflags], [''])
-                AC_SUBST([os_libs], ['']);;
+		AC_DEFINE_UNQUOTED(SG_LIB_SOLARIS, 1, [sg3_utils on Solaris]);;
         *-*-osf*)
-		AC_DEFINE_UNQUOTED(SG_LIB_OSF1, 1, [sg3_utils on Tru64 UNIX])
-                AC_SUBST([os_cflags], [''])
-                AC_SUBST([os_libs], ['']) ;;
+		AC_DEFINE_UNQUOTED(SG_LIB_OSF1, 1, [sg3_utils on Tru64 UNIX]);;
         *-*-cygwin*)
 		AC_DEFINE_UNQUOTED(SG_LIB_WIN32, 1, [sg3_utils on Win32])
-                AC_SUBST([os_cflags], ['-Wno-char-subscripts'])
-                AC_SUBST([os_libs], ['']) ;;
+                CFLAGS="$CFLAGS -Wno-char-subscripts";;
         *-*-mingw*)
 		AC_DEFINE_UNQUOTED(SG_LIB_WIN32, 1, [sg3_utils on Win32])
-		AC_DEFINE_UNQUOTED(SG_LIB_MINGW, 1, [also MinGW environment])
-                AC_SUBST([os_cflags], [''])
-                AC_SUBST([os_libs], ['']) ;;
+		AC_DEFINE_UNQUOTED(SG_LIB_MINGW, 1, [also MinGW environment]);;
         *-*-linux-gnu* | *-*-linux* | *)
                 AC_DEFINE_UNQUOTED(SG_LIB_LINUX, 1, [sg3_utils on linux])
-                AC_SUBST([os_cflags], [''])
-                AC_SUBST([os_libs], [''])
                 check_for_linux_nvme_headers;;
 esac
 
diff --git a/doc/Makefile.in b/doc/Makefile.in
index 5b3f009554af..e4605ac68e45 100644
--- a/doc/Makefile.in
+++ b/doc/Makefile.in
@@ -266,8 +266,6 @@ localstatedir = @localstatedir@
 mandir = @mandir@
 mkdir_p = @mkdir_p@
 oldincludedir = @oldincludedir@
-os_cflags = @os_cflags@
-os_libs = @os_libs@
 pdfdir = @pdfdir@
 prefix = @prefix@
 program_transform_name = @program_transform_name@
diff --git a/include/Makefile.in b/include/Makefile.in
index 0016be3edf15..d2ddfb9a541b 100644
--- a/include/Makefile.in
+++ b/include/Makefile.in
@@ -286,8 +286,6 @@ localstatedir = @localstatedir@
 mandir = @mandir@
 mkdir_p = @mkdir_p@
 oldincludedir = @oldincludedir@
-os_cflags = @os_cflags@
-os_libs = @os_libs@
 pdfdir = @pdfdir@
 prefix = @prefix@
 program_transform_name = @program_transform_name@
diff --git a/lib/Makefile.am b/lib/Makefile.am
index 24d3c9591353..6364abad4a30 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -52,7 +52,7 @@ lib_LTLIBRARIES = libsgutils2.la
 
 libsgutils2_la_LDFLAGS = -version-info 2:0:0 -no-undefined
 
-libsgutils2_la_LIBADD = @GETOPT_O_FILES@ @os_libs@
+libsgutils2_la_LIBADD = @GETOPT_O_FILES@
 libsgutils2_la_DEPENDENCIES = @GETOPT_O_FILES@
 
 
diff --git a/lib/Makefile.in b/lib/Makefile.in
index 35d83c1d3dd6..8dce9336a983 100644
--- a/lib/Makefile.in
+++ b/lib/Makefile.in
@@ -330,8 +330,6 @@ localstatedir = @localstatedir@
 mandir = @mandir@
 mkdir_p = @mkdir_p@
 oldincludedir = @oldincludedir@
-os_cflags = @os_cflags@
-os_libs = @os_libs@
 pdfdir = @pdfdir@
 prefix = @prefix@
 program_transform_name = @program_transform_name@
@@ -360,7 +358,7 @@ AM_CFLAGS = -Wall -W
 # AM_CFLAGS = -Wall -W -pedantic -std=c++14
 lib_LTLIBRARIES = libsgutils2.la
 libsgutils2_la_LDFLAGS = -version-info 2:0:0 -no-undefined
-libsgutils2_la_LIBADD = @GETOPT_O_FILES@ @os_libs@
+libsgutils2_la_LIBADD = @GETOPT_O_FILES@
 libsgutils2_la_DEPENDENCIES = @GETOPT_O_FILES@
 all: all-am
 
diff --git a/scripts/Makefile.in b/scripts/Makefile.in
index 1daa3818f5cb..7a0c0e1f7738 100644
--- a/scripts/Makefile.in
+++ b/scripts/Makefile.in
@@ -255,8 +255,6 @@ localstatedir = @localstatedir@
 mandir = @mandir@
 mkdir_p = @mkdir_p@
 oldincludedir = @oldincludedir@
-os_cflags = @os_cflags@
-os_libs = @os_libs@
 pdfdir = @pdfdir@
 prefix = @prefix@
 program_transform_name = @program_transform_name@
diff --git a/src/Makefile.am b/src/Makefile.am
index 33c7be515b8d..494623be50cf 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -42,142 +42,138 @@ endif
 # -std=<s> can be c99, c11, gnu11, etc. Default is gnu89 (gnu90 is the same)
 # -Wall is no longer all warnings. Add -W (since renamed to -Wextra) for more
 AM_CPPFLAGS = -iquote ${top_srcdir}/include -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
-AM_CFLAGS = -Wall -W @os_cflags@
-# AM_CFLAGS = -Wall -W @os_cflags@ -pedantic -std=c11
-# AM_CFLAGS = -Wall -W @os_cflags@ -pedantic -std=c11 --analyze
-# AM_CFLAGS = -Wall -W @os_cflags@ -pedantic -std=c++14
+AM_CFLAGS = -Wall -W
+# AM_CFLAGS = -Wall -W -pedantic -std=c11
+# AM_CFLAGS = -Wall -W -pedantic -std=c11 --analyze
+# AM_CFLAGS = -Wall -W -pedantic -std=c++14
 
-sg_bg_ctl_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_bg_ctl_LDADD = ../lib/libsgutils2.la
 
-sg_compare_and_write_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_compare_and_write_LDADD = ../lib/libsgutils2.la
 
-sg_copy_results_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_copy_results_LDADD = ../lib/libsgutils2.la
 
-sg_dd_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_dd_LDADD = ../lib/libsgutils2.la
 
-sg_decode_sense_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_decode_sense_LDADD = ../lib/libsgutils2.la
 
-sg_emc_trespass_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_emc_trespass_LDADD = ../lib/libsgutils2.la
 
-sg_format_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_format_LDADD = ../lib/libsgutils2.la
 
-sg_get_config_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_get_config_LDADD = ../lib/libsgutils2.la
 
-sg_get_lba_status_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_get_lba_status_LDADD = ../lib/libsgutils2.la
 
-sg_ident_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_ident_LDADD = ../lib/libsgutils2.la
 
-sginfo_LDADD = ../lib/libsgutils2.la @os_libs@
+sginfo_LDADD = ../lib/libsgutils2.la
 
 sg_inq_SOURCES = sg_inq.c sg_inq_data.c
-sg_inq_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_inq_LDADD = ../lib/libsgutils2.la
 
-sg_logs_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_logs_LDADD = ../lib/libsgutils2.la
 
-sg_luns_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_luns_LDADD = ../lib/libsgutils2.la
 
-sg_map26_LDADD = @os_libs@
+sg_map_LDADD = ../lib/libsgutils2.la
 
-sg_map_LDADD = ../lib/libsgutils2.la @os_libs@
+sgm_dd_LDADD = ../lib/libsgutils2.la
 
-sgm_dd_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_modes_LDADD = ../lib/libsgutils2.la
 
-sg_modes_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_opcodes_LDADD = ../lib/libsgutils2.la
 
-sg_opcodes_LDADD = ../lib/libsgutils2.la @os_libs@
+sgp_dd_LDADD = ../lib/libsgutils2.la @PTHREAD_LIB@
 
-sgp_dd_LDADD = ../lib/libsgutils2.la @os_libs@ @PTHREAD_LIB@
+sg_persist_LDADD = ../lib/libsgutils2.la
 
-sg_persist_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_prevent_LDADD = ../lib/libsgutils2.la
 
-sg_prevent_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_raw_LDADD = ../lib/libsgutils2.la
 
-sg_raw_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_rbuf_LDADD = ../lib/libsgutils2.la
 
-sg_rbuf_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_rdac_LDADD = ../lib/libsgutils2.la
 
-sg_rdac_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_read_LDADD = ../lib/libsgutils2.la
 
-sg_read_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_read_attr_LDADD = ../lib/libsgutils2.la
 
-sg_read_attr_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_readcap_LDADD = ../lib/libsgutils2.la
 
-sg_readcap_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_read_block_limits_LDADD = ../lib/libsgutils2.la
 
-sg_read_block_limits_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_read_buffer_LDADD = ../lib/libsgutils2.la
 
-sg_read_buffer_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_read_long_LDADD = ../lib/libsgutils2.la
 
-sg_read_long_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_reassign_LDADD = ../lib/libsgutils2.la
 
-sg_reassign_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_requests_LDADD = ../lib/libsgutils2.la
 
-sg_requests_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_referrals_LDADD = ../lib/libsgutils2.la
 
-sg_referrals_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_rep_zones_LDADD = ../lib/libsgutils2.la
 
-sg_rep_zones_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_reset_wp_LDADD = ../lib/libsgutils2.la
 
-sg_reset_LDADD = @os_libs@
+sg_rmsn_LDADD = ../lib/libsgutils2.la
 
-sg_reset_wp_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_rtpg_LDADD = ../lib/libsgutils2.la
 
-sg_rmsn_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_safte_LDADD = ../lib/libsgutils2.la
 
-sg_rtpg_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_sanitize_LDADD = ../lib/libsgutils2.la
 
-sg_safte_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_sat_identify_LDADD = ../lib/libsgutils2.la
 
-sg_sanitize_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_sat_phy_event_LDADD = ../lib/libsgutils2.la
 
-sg_sat_identify_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_sat_read_gplog_LDADD = ../lib/libsgutils2.la
 
-sg_sat_phy_event_LDADD = ../lib/libsgutils2.la @os_libs@
-
-sg_sat_read_gplog_LDADD = ../lib/libsgutils2.la @os_libs@
-
-sg_sat_set_features_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_sat_set_features_LDADD = ../lib/libsgutils2.la
 
 # sg_scan_SOURCES list is already set above in the platform-specific sections
-sg_scan_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_scan_LDADD = ../lib/libsgutils2.la
 
-sg_senddiag_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_senddiag_LDADD = ../lib/libsgutils2.la
 
-sg_ses_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_ses_LDADD = ../lib/libsgutils2.la
 
-sg_ses_microcode_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_ses_microcode_LDADD = ../lib/libsgutils2.la
 
-sg_start_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_start_LDADD = ../lib/libsgutils2.la
 
-sg_stpg_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_stpg_LDADD = ../lib/libsgutils2.la
 
-sg_sync_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_sync_LDADD = ../lib/libsgutils2.la
 
-sg_test_rwbuf_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_test_rwbuf_LDADD = ../lib/libsgutils2.la
 
-sg_timestamp_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_timestamp_LDADD = ../lib/libsgutils2.la
 
-sg_turs_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_turs_LDADD = ../lib/libsgutils2.la
 
-sg_unmap_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_unmap_LDADD = ../lib/libsgutils2.la
 
-sg_verify_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_verify_LDADD = ../lib/libsgutils2.la
 
 sg_vpd_SOURCES = sg_vpd.c sg_vpd_vendor.c
-sg_vpd_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_vpd_LDADD = ../lib/libsgutils2.la
 
-sg_wr_mode_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_wr_mode_LDADD = ../lib/libsgutils2.la
 
-sg_write_buffer_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_write_buffer_LDADD = ../lib/libsgutils2.la
 
-sg_write_long_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_write_long_LDADD = ../lib/libsgutils2.la
 
-sg_write_same_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_write_same_LDADD = ../lib/libsgutils2.la
 
-sg_write_verify_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_write_verify_LDADD = ../lib/libsgutils2.la
 
-sg_write_x_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_write_x_LDADD = ../lib/libsgutils2.la
 
-sg_xcopy_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_xcopy_LDADD = ../lib/libsgutils2.la
 
-sg_zone_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_zone_LDADD = ../lib/libsgutils2.la
diff --git a/src/Makefile.in b/src/Makefile.in
index eec196432869..a2a6c17a9ead 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -188,7 +188,7 @@ sg_map_OBJECTS = sg_map.$(OBJEXT)
 sg_map_DEPENDENCIES = ../lib/libsgutils2.la
 sg_map26_SOURCES = sg_map26.c
 sg_map26_OBJECTS = sg_map26.$(OBJEXT)
-sg_map26_DEPENDENCIES =
+sg_map26_LDADD = $(LDADD)
 sg_modes_SOURCES = sg_modes.c
 sg_modes_OBJECTS = sg_modes.$(OBJEXT)
 sg_modes_DEPENDENCIES = ../lib/libsgutils2.la
@@ -242,7 +242,7 @@ sg_requests_OBJECTS = sg_requests.$(OBJEXT)
 sg_requests_DEPENDENCIES = ../lib/libsgutils2.la
 sg_reset_SOURCES = sg_reset.c
 sg_reset_OBJECTS = sg_reset.$(OBJEXT)
-sg_reset_DEPENDENCIES =
+sg_reset_LDADD = $(LDADD)
 sg_reset_wp_SOURCES = sg_reset_wp.c
 sg_reset_wp_OBJECTS = sg_reset_wp.$(OBJEXT)
 sg_reset_wp_DEPENDENCIES = ../lib/libsgutils2.la
@@ -546,8 +546,6 @@ localstatedir = @localstatedir@
 mandir = @mandir@
 mkdir_p = @mkdir_p@
 oldincludedir = @oldincludedir@
-os_cflags = @os_cflags@
-os_libs = @os_libs@
 pdfdir = @pdfdir@
 prefix = @prefix@
 program_transform_name = @program_transform_name@
@@ -567,80 +565,78 @@ sg_scan_SOURCES = $(am__append_2) $(am__append_4) $(am__append_6)
 # -std=<s> can be c99, c11, gnu11, etc. Default is gnu89 (gnu90 is the same)
 # -Wall is no longer all warnings. Add -W (since renamed to -Wextra) for more
 AM_CPPFLAGS = -iquote ${top_srcdir}/include -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
-AM_CFLAGS = -Wall -W @os_cflags@
-# AM_CFLAGS = -Wall -W @os_cflags@ -pedantic -std=c11
-# AM_CFLAGS = -Wall -W @os_cflags@ -pedantic -std=c11 --analyze
-# AM_CFLAGS = -Wall -W @os_cflags@ -pedantic -std=c++14
-sg_bg_ctl_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_compare_and_write_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_copy_results_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_dd_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_decode_sense_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_emc_trespass_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_format_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_get_config_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_get_lba_status_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_ident_LDADD = ../lib/libsgutils2.la @os_libs@
-sginfo_LDADD = ../lib/libsgutils2.la @os_libs@
+AM_CFLAGS = -Wall -W
+# AM_CFLAGS = -Wall -W -pedantic -std=c11
+# AM_CFLAGS = -Wall -W -pedantic -std=c11 --analyze
+# AM_CFLAGS = -Wall -W -pedantic -std=c++14
+sg_bg_ctl_LDADD = ../lib/libsgutils2.la
+sg_compare_and_write_LDADD = ../lib/libsgutils2.la
+sg_copy_results_LDADD = ../lib/libsgutils2.la
+sg_dd_LDADD = ../lib/libsgutils2.la
+sg_decode_sense_LDADD = ../lib/libsgutils2.la
+sg_emc_trespass_LDADD = ../lib/libsgutils2.la
+sg_format_LDADD = ../lib/libsgutils2.la
+sg_get_config_LDADD = ../lib/libsgutils2.la
+sg_get_lba_status_LDADD = ../lib/libsgutils2.la
+sg_ident_LDADD = ../lib/libsgutils2.la
+sginfo_LDADD = ../lib/libsgutils2.la
 sg_inq_SOURCES = sg_inq.c sg_inq_data.c
-sg_inq_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_logs_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_luns_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_map26_LDADD = @os_libs@
-sg_map_LDADD = ../lib/libsgutils2.la @os_libs@
-sgm_dd_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_modes_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_opcodes_LDADD = ../lib/libsgutils2.la @os_libs@
-sgp_dd_LDADD = ../lib/libsgutils2.la @os_libs@ @PTHREAD_LIB@
-sg_persist_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_prevent_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_raw_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_rbuf_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_rdac_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_read_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_read_attr_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_readcap_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_read_block_limits_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_read_buffer_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_read_long_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_reassign_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_requests_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_referrals_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_rep_zones_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_reset_LDADD = @os_libs@
-sg_reset_wp_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_rmsn_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_rtpg_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_safte_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_sanitize_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_sat_identify_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_sat_phy_event_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_sat_read_gplog_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_sat_set_features_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_inq_LDADD = ../lib/libsgutils2.la
+sg_logs_LDADD = ../lib/libsgutils2.la
+sg_luns_LDADD = ../lib/libsgutils2.la
+sg_map_LDADD = ../lib/libsgutils2.la
+sgm_dd_LDADD = ../lib/libsgutils2.la
+sg_modes_LDADD = ../lib/libsgutils2.la
+sg_opcodes_LDADD = ../lib/libsgutils2.la
+sgp_dd_LDADD = ../lib/libsgutils2.la @PTHREAD_LIB@
+sg_persist_LDADD = ../lib/libsgutils2.la
+sg_prevent_LDADD = ../lib/libsgutils2.la
+sg_raw_LDADD = ../lib/libsgutils2.la
+sg_rbuf_LDADD = ../lib/libsgutils2.la
+sg_rdac_LDADD = ../lib/libsgutils2.la
+sg_read_LDADD = ../lib/libsgutils2.la
+sg_read_attr_LDADD = ../lib/libsgutils2.la
+sg_readcap_LDADD = ../lib/libsgutils2.la
+sg_read_block_limits_LDADD = ../lib/libsgutils2.la
+sg_read_buffer_LDADD = ../lib/libsgutils2.la
+sg_read_long_LDADD = ../lib/libsgutils2.la
+sg_reassign_LDADD = ../lib/libsgutils2.la
+sg_requests_LDADD = ../lib/libsgutils2.la
+sg_referrals_LDADD = ../lib/libsgutils2.la
+sg_rep_zones_LDADD = ../lib/libsgutils2.la
+sg_reset_wp_LDADD = ../lib/libsgutils2.la
+sg_rmsn_LDADD = ../lib/libsgutils2.la
+sg_rtpg_LDADD = ../lib/libsgutils2.la
+sg_safte_LDADD = ../lib/libsgutils2.la
+sg_sanitize_LDADD = ../lib/libsgutils2.la
+sg_sat_identify_LDADD = ../lib/libsgutils2.la
+sg_sat_phy_event_LDADD = ../lib/libsgutils2.la
+sg_sat_read_gplog_LDADD = ../lib/libsgutils2.la
+sg_sat_set_features_LDADD = ../lib/libsgutils2.la
 
 # sg_scan_SOURCES list is already set above in the platform-specific sections
-sg_scan_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_senddiag_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_ses_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_ses_microcode_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_start_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_stpg_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_sync_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_test_rwbuf_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_timestamp_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_turs_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_unmap_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_verify_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_scan_LDADD = ../lib/libsgutils2.la
+sg_senddiag_LDADD = ../lib/libsgutils2.la
+sg_ses_LDADD = ../lib/libsgutils2.la
+sg_ses_microcode_LDADD = ../lib/libsgutils2.la
+sg_start_LDADD = ../lib/libsgutils2.la
+sg_stpg_LDADD = ../lib/libsgutils2.la
+sg_sync_LDADD = ../lib/libsgutils2.la
+sg_test_rwbuf_LDADD = ../lib/libsgutils2.la
+sg_timestamp_LDADD = ../lib/libsgutils2.la
+sg_turs_LDADD = ../lib/libsgutils2.la
+sg_unmap_LDADD = ../lib/libsgutils2.la
+sg_verify_LDADD = ../lib/libsgutils2.la
 sg_vpd_SOURCES = sg_vpd.c sg_vpd_vendor.c
-sg_vpd_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_wr_mode_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_write_buffer_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_write_long_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_write_same_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_write_verify_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_write_x_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_xcopy_LDADD = ../lib/libsgutils2.la @os_libs@
-sg_zone_LDADD = ../lib/libsgutils2.la @os_libs@
+sg_vpd_LDADD = ../lib/libsgutils2.la
+sg_wr_mode_LDADD = ../lib/libsgutils2.la
+sg_write_buffer_LDADD = ../lib/libsgutils2.la
+sg_write_long_LDADD = ../lib/libsgutils2.la
+sg_write_same_LDADD = ../lib/libsgutils2.la
+sg_write_verify_LDADD = ../lib/libsgutils2.la
+sg_write_x_LDADD = ../lib/libsgutils2.la
+sg_xcopy_LDADD = ../lib/libsgutils2.la
+sg_zone_LDADD = ../lib/libsgutils2.la
 all: all-am
 
 .SUFFIXES:
-- 
2.15.1
