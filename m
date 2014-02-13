From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] modify sg_inq to read from hexdump
Date: Thu, 13 Feb 2014 13:49:57 +0100
Message-ID: <52FCBF75.3010805@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010105010809090707080801"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbaBMMt7 (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Thu, 13 Feb 2014 07:49:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jeremy Linton <jlinton@tributary.com>, James Bottomley <JBottomley@Parallels.com>, Linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010105010809090707080801
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi Doug,

and here's now the follow-up to my patchset 'Add EVPD pages to
sysfs'; with this small tweak sg_inq can read the EVPD dumps from
sysfs without any I/O.

So I guess we're good to go with just having the raw data for
the EVPD pages in sysfs, James.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

--------------010105010809090707080801
Content-Type: text/x-patch;
 name="0001-sg_inq-Read-hexdump-instead-of-using-SG_IO.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-sg_inq-Read-hexdump-instead-of-using-SG_IO.patch"

>From e95f4f11f2453c77204258b11beeb33adac53dc5 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Thu, 13 Feb 2014 13:43:31 +0100
Subject: [PATCH] sg_inq: Read hexdump instead of using SG_IO

Implement a flag '-D' which will try to read a file containing
a hexdump instead of a 'normal' file descriptor.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 include/sg_lib.h |  1 +
 lib/sg_lib.c     | 25 +++++++++++++++++++++++++
 src/sg_inq.c     | 32 +++++++++++++++++++++++---------
 3 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/include/sg_lib.h b/include/sg_lib.h
index 03eb03c..722bdb9 100644
--- a/include/sg_lib.h
+++ b/include/sg_lib.h
@@ -293,6 +293,7 @@ int sg_vpd_dev_id_iter(const unsigned char * initial_desig_desc, int page_len,
  * If errnum is negative, flip its sign. */
 char * safe_strerror(int errnum);
 
+int sg_ll_read_hex(int sg_fd, unsigned char *str, int len);
 
 /* Print (to stdout) 'str' of bytes in hex, 16 bytes per line optionally
  * followed at the right hand side of the line with an ASCII interpretation.
diff --git a/lib/sg_lib.c b/lib/sg_lib.c
index 1f69980..5fe8be2 100644
--- a/lib/sg_lib.c
+++ b/lib/sg_lib.c
@@ -32,6 +32,7 @@
 #include <stdarg.h>
 #include <string.h>
 #include <ctype.h>
+#include <unistd.h>
 #define __STDC_FORMAT_MACROS 1
 #include <inttypes.h>
 
@@ -1404,6 +1405,30 @@ safe_strerror(int errnum)
     return errstr;
 }
 
+int
+sg_ll_read_hex(int sg_fd, unsigned char *str, int len)
+{
+    char buf[48];
+    unsigned int n;
+    int r = 0, off, bytes;
+
+    do {
+        off = 0;
+        bytes = read(sg_fd, buf, 48);
+        if (bytes < 0)
+            return -1;
+        while (off < bytes) {
+            if (sscanf(buf + off, "%x ", &n) != 1)
+                break;
+            if (n > 255)
+                break;
+            str[r] = n;
+            r++;
+            off += 3;
+        }
+    } while (bytes > 0 && r < len);
+    return 0;
+}
 
 /* Note the ASCII-hex output goes to stdout. [Most other output from functions
    in this file go to sg_warnings_strm (default stderr).]
diff --git a/src/sg_inq.c b/src/sg_inq.c
index 26bf3c3..cee8f5f 100644
--- a/src/sg_inq.c
+++ b/src/sg_inq.c
@@ -186,6 +186,7 @@ static struct option long_options[] = {
         {"block", required_argument, 0, 'B'},
         {"cmddt", no_argument, 0, 'c'},
         {"descriptors", no_argument, 0, 'd'},
+        {"hexdump", no_argument, 0, 'D'},
         {"export", no_argument, 0, 'u'},
         {"extended", no_argument, 0, 'x'},
         {"help", no_argument, 0, 'h'},
@@ -220,6 +221,7 @@ struct opts_t {
     int do_version;
     int do_decode;
     int do_vpd;
+    int hexdump;
     int resp_len;
     int page_num;
     int num_pages;
@@ -392,18 +394,18 @@ cl_new_process(struct opts_t * optsp, int argc, char * argv[])
 
 #ifdef SG_LIB_LINUX
 #ifdef SG_SCSI_STRINGS
-        c = getopt_long(argc, argv, "aB:cdeEhHil:m:NOp:rsuvVx", long_options,
+        c = getopt_long(argc, argv, "aB:cdDeEhHil:m:NOp:rsuvVx", long_options,
                         &option_index);
 #else
-        c = getopt_long(argc, argv, "B:cdeEhHil:m:p:rsuvVx", long_options,
+        c = getopt_long(argc, argv, "B:cdDeEhHil:m:p:rsuvVx", long_options,
                         &option_index);
 #endif /* SG_SCSI_STRINGS */
 #else  /* SG_LIB_LINUX */
 #ifdef SG_SCSI_STRINGS
-        c = getopt_long(argc, argv, "B:cdeEhHil:m:NOp:rsuvVx", long_options,
+        c = getopt_long(argc, argv, "B:cdDeEhHil:m:NOp:rsuvVx", long_options,
                         &option_index);
 #else
-        c = getopt_long(argc, argv, "B:cdeEhHil:m:p:rsuvVx", long_options,
+        c = getopt_long(argc, argv, "B:cdDeEhHil:m:p:rsuvVx", long_options,
                         &option_index);
 #endif /* SG_SCSI_STRINGS */
 #endif /* SG_LIB_LINUX */
@@ -436,6 +438,9 @@ cl_new_process(struct opts_t * optsp, int argc, char * argv[])
         case 'd':
             ++optsp->do_descriptors;
             break;
+        case 'D':
+            ++optsp->hexdump;
+            break;
         case 'e':
             ++optsp->do_vpd;
             break;
@@ -526,7 +531,7 @@ cl_new_process(struct opts_t * optsp, int argc, char * argv[])
 static int
 cl_old_process(struct opts_t * optsp, int argc, char * argv[])
 {
-    int k, jmp_out, plen, num, n;
+    int k, jmp_out, plen, n, num = 0;
     const char * cp;
 
     for (k = 1; k < argc; ++k) {
@@ -572,6 +577,9 @@ cl_old_process(struct opts_t * optsp, int argc, char * argv[])
                     ++optsp->do_descriptors;
                     ++optsp->do_decode;
                     break;
+                case 'D':
+                    ++optsp->hexdump;
+                    break;
                 case 'e':
                     ++optsp->do_vpd;
                     break;
@@ -2847,8 +2855,11 @@ decode_vpd(int sg_fd, const struct opts_t * optsp)
     case VPD_UNIT_SERIAL_NUM:
         if (! optsp->do_raw && ! optsp->do_export)
             printf("VPD INQUIRY: Unit serial number page\n");
-        res = sg_ll_inquiry(sg_fd, 0, 1, VPD_UNIT_SERIAL_NUM, rsp_buff,
-                            DEF_ALLOC_LEN, 1, optsp->do_verbose);
+        if (optsp->hexdump)
+            res = sg_ll_read_hex(sg_fd, rsp_buff, DEF_ALLOC_LEN);
+        else
+            res = sg_ll_inquiry(sg_fd, 0, 1, VPD_UNIT_SERIAL_NUM, rsp_buff,
+                                DEF_ALLOC_LEN, 1, optsp->do_verbose);
         if (0 == res) {
             len = ((rsp_buff[2] << 8) + rsp_buff[3]) + 4; /* spc4r25 */
             if (VPD_UNIT_SERIAL_NUM != rsp_buff[1]) {
@@ -2880,8 +2891,11 @@ decode_vpd(int sg_fd, const struct opts_t * optsp)
     case VPD_DEVICE_ID:
         if (! optsp->do_raw && ! optsp->do_export)
             printf("VPD INQUIRY: Device Identification page\n");
-        res = sg_ll_inquiry(sg_fd, 0, 1, VPD_DEVICE_ID, rsp_buff,
-                            DEF_ALLOC_LEN, 1, optsp->do_verbose);
+        if (optsp->hexdump)
+            res = sg_ll_read_hex(sg_fd, rsp_buff, DEF_ALLOC_LEN);
+        else
+            res = sg_ll_inquiry(sg_fd, 0, 1, VPD_DEVICE_ID, rsp_buff,
+                                DEF_ALLOC_LEN, 1, optsp->do_verbose);
         if (0 == res) {
             len = ((rsp_buff[2] << 8) + rsp_buff[3]) + 4;
             if (VPD_DEVICE_ID != rsp_buff[1]) {
-- 
1.8.1.4


--------------010105010809090707080801--
