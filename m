From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg_scan -i /dev/sg[0123] /dev/hd[abcd] /dev/scd[0123]
Date: 11 Dec 2003 13:02:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1071172941.2868.26.camel@patibmrh9>
References: <1070670440.3056.7.camel@patibmrh9>
	 <3FD43229.7070708@torque.net>  <1070906283.2263.101.camel@patibmrh9>
	 <1070908146.2263.121.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:50894 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265223AbTLKUC2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2003 15:02:28 -0500
In-Reply-To: <1070908146.2263.121.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Doug G:

Thank you, I see sg_scan now lets me name the devices to scan, including
lk 2.6 block devices:

The inline patch of this e-mail then also omits and scans past the
"Stopping because there are too many error" message in configurations
with few devices present, for example:

$ cd sg3_utils-1.06
$
$ grep Ch CHANGELOG | head -1
Changelog for sg3_utils-1.06 [20031210]
$
$ sudo ./sg_scan -i /dev/hd[abcd] /dev/scd[0123]
sg_scan: device /dev/hda failed on scsi ioctl, skip: Invalid argument
/dev/hdc: scsi0 channel=0 id=0 lun=0 [em]
    LITE-ON   COMBO LTC-48161H  KH0K [wide=0 sync=0 cmdq=0 sftre=0 pq=0x0]
/dev/hdd: scsi0 channel=0 id=0 lun=0 [em]
    Iomega    RRD               11.A [wide=0 sync=0 cmdq=0 sftre=0 pq=0x0]
/dev/scd0: scsi0 channel=0 id=0 lun=0 [em]
    Iomega    RRD               11.U [wide=0 sync=0 cmdq=0 sftre=0 pq=0x0]
/dev/scd1: scsi1 channel=0 id=0 lun=0 [em]
    Iomega    RRD               11.U [wide=0 sync=0 cmdq=0 sftre=0 pq=0x0]
Stopping because there are too many error
$

Pat LaVarre

diff -Nurp sg3_utils-1.06/sg_scan.c sg3_utils/sg_scan.c
--- sg3_utils-1.06/sg_scan.c	2003-12-09 20:24:21.000000000 -0700
+++ sg3_utils/sg_scan.c	2003-12-11 12:56:09.956934904 -0700
@@ -187,7 +187,7 @@ int main(int argc, char * argv[])
     flags = writeable ? O_RDWR : O_RDONLY;
 
     for (k = 0, res = 0, j = 0; 
-	 (k < max_file_args)  && (num_errors < MAX_ERRORS);
+	 (k < max_file_args)  && (has_file_args || (num_errors < MAX_ERRORS));
          ++k, res = (sg_fd >= 0) ? close(sg_fd) : 0) {
         if (res < 0) {
             snprintf(ebuff, EBUFF_SZ, ME "Error closing %s ", fname);
@@ -283,7 +283,8 @@ int main(int argc, char * argv[])
                 res = sg3_inq(sg_fd, inqBuff, do_extra);
         }
     }
-    if ((num_errors >= MAX_ERRORS) && (num_silent < num_errors)) {
+    if ((num_errors >= MAX_ERRORS) && (num_silent < num_errors) &&
+            !has_file_args) {
         printf("Stopping because there are too many error\n");
         if (eacces_err)
             printf("    root access may be required\n");


