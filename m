From: Pat LaVarre <p.lavarre@ieee.org>
Subject: /dev/hd* in sg_scan
Date: 27 Oct 2003 17:09:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067299763.3469.6.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:56529 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263675AbTJ0XJp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2003 18:09:45 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 4499C1E19
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2003 16:09:44 -0700 (MST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> http://tldp.org/HOWTO/SCSI-Generic-HOWTO/open.html
> ... O_NONBLOCK ... ignored by ioctl(SG_IO)

As of 2.6, in fact we now need O_NONBLOCK if we want open O_RDONLY to
let us talk SG_IO to a DVD/CD with no disk present?  Also we discard the
history of passing thru less commands for O_RDONLY than for O_RDWR?

Reaching those conclusions inspired me to try the following trivial
inline patch for sg3_utils-1.05/sg_scan.c.  I see this patch brings much
of /dev/hd* to the notice of sg utils sg_scan.  However, this patch may
not be ready for prime-time, some of the code I flowed around I do not
understand.

Do we intend to make /dev/hd[a-z] available for passing ioctl SG_IO thru
to ATAPI DVD/CD, in 2.6?  Or for 2.6 do we recommend ab/using some other
device name?

Patched sg_scan success here looks like:

$ sudo sg_scan -i
/dev/hda: scsi0 channel=0 id=0 lun=0
/dev/hdc: scsi0 channel=0 id=0 lun=0 [em]
    LITE-ON   COMBO LTC-48161H  KH0K [wide=0 sync=0 cmdq=0 sftre=0 pq=0x0]
/dev/sg0: scsi0 channel=0 id=0 lun=0 [em]  type=5
    Iomega    RRD               01.U [wide=0 sync=0 cmdq=0 sftre=0 pq=0x0]
$

Perhaps the soft bridge from SCSI to ATA HDD in Linux, like some
FireWire HDD, is an apparently SCSI device that does not support op x12
Inquiry.

Pat LaVarre

P.S. Before now I see no hits in:

http://groups.google.com/groups?q=sg_scan+dev+hdc

diff -Nur sg3_utils-1.05/sg_scan.c sg3_utils/sg_scan.c
--- sg3_utils-1.05/sg_scan.c	2003-05-29 02:55:48.000000000 -0600
+++ sg3_utils/sg_scan.c	2003-10-27 16:55:09.085283256 -0700
@@ -43,6 +43,8 @@
 
 #define NUMERIC_SCAN_DEF 1   /* change to 0 to make alpha scan default */
 
+#define DEV_HD_SCAN 26 /* change to 4 to scan only /dev/hd[abcd] */
+
 #define OFF sizeof(struct sg_header)
 #define INQ_REPLY_LEN 96        /* logic assumes >= sizeof(inqCmdBlk) */
 #define INQ_CMD_LEN 6
@@ -101,6 +103,14 @@
     char buff[64];
     int  big,little;
 
+    if (0 <= k) {
+            if (k < DEV_HD_SCAN) {
+                sprintf(fname, "/dev/hd%c", ('a' + k));
+                return;
+            }
+            k -= DEV_HD_SCAN;
+    }
+
     strcpy(fname, "/dev/sg");
     if (do_numeric) {
         sprintf(buff, "%d", k);
@@ -202,8 +212,10 @@
             }
             else if ((ENODEV == errno) || (ENOENT == errno) ||
                      (ENXIO == errno)) {
-                ++num_errors;
-                ++num_silent;
+                if (DEV_HD_SCAN <= k) {
+                    ++num_errors;
+                    ++num_silent;
+                }
                 continue;
             }
             else {
@@ -216,7 +228,7 @@
             }
         }
         res = ioctl(sg_fd, SCSI_IOCTL_GET_IDLUN, &my_idlun);
-        if (res < 0) {
+        if ((res < 0) && (DEV_HD_SCAN <= k)) {
             snprintf(ebuff, EBUFF_SZ,
                      ME "device %s failed on scsi ioctl, skip", fname);
             perror(ebuff);
@@ -224,7 +236,7 @@
             continue;
         }
         res = ioctl(sg_fd, SCSI_IOCTL_GET_BUS_NUMBER, &host_no);
-        if (res < 0) {
+        if ((res < 0) && (DEV_HD_SCAN <= k)) {
             snprintf(ebuff, EBUFF_SZ, ME "device %s failed on scsi "
                      "ioctl(2), skip", fname);
             perror(ebuff);
@@ -233,7 +245,7 @@
         }
 #ifdef SG_EMULATED_HOST
         res = ioctl(sg_fd, SG_EMULATED_HOST, &emul);
-        if (res < 0) {
+        if ((res < 0) && (DEV_HD_SCAN <= k)) {
             snprintf(ebuff, EBUFF_SZ, 
                      ME "device %s failed on sg ioctl(3), skip", fname);
             perror(ebuff);
@@ -252,7 +264,9 @@
         printf(", huid=%d", my_idlun.host_unique_id);
 #endif
 #ifdef SG_GET_RESERVED_SIZE
-        {
+        if (k < DEV_HD_SCAN) {
+            printf("\n");
+        } else {
             My_sg_scsi_id m_id; /* compatible with sg_scsi_id_t in sg.h */
 
             res = ioctl(sg_fd, SG_GET_SCSI_ID, &m_id);
@@ -282,6 +296,9 @@
             continue;
         }
 #endif
+        if (k < DEV_HD_SCAN) {
+            continue;
+        }
         memset(isghp, 0, sizeof(struct sg_header));
         isghp->reply_len = inqOutLen;
         memcpy(inqBuff + OFF, inqCmdBlk, INQ_CMD_LEN);


