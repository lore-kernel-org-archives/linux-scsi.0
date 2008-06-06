From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/3] sd: Allow sd_print_sense_hdr to be called outside of sd.c
Date: Fri, 06 Jun 2008 15:25:20 -0400
Message-ID: <yq1iqwml61r.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:17700 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbYFFTZ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 15:25:57 -0400
Received: from rgmgw1.us.oracle.com (rgmgw1.us.oracle.com [138.1.186.110])
	by rgminet01.oracle.com (Switch-3.2.4/Switch-3.1.6) with ESMTP id m56JPsZR012253
	for <linux-scsi@vger.kernel.org>; Fri, 6 Jun 2008 13:25:55 -0600
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by rgmgw1.us.oracle.com (Switch-3.2.4/Switch-3.2.4) with ESMTP id m56GWlPA011247
	for <linux-scsi@vger.kernel.org>; Fri, 6 Jun 2008 13:25:49 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


sd: Allow sd_print_sense_hdr to be called outside of sd.c

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r 431a96f963a6 drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Fri Apr 25 13:36:00 2008 -0400
+++ b/drivers/scsi/sd.c	Fri Apr 25 13:36:39 2008 -0400
@@ -96,7 +96,6 @@
 static int sd_done(struct scsi_cmnd *);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct device *cdev);
-static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
 static void sd_print_result(struct scsi_disk *, int);
 
 static DEFINE_IDR(sd_index_idr);
@@ -1930,14 +1929,14 @@
 module_init(init_sd);
 module_exit(exit_sd);
 
-static void sd_print_sense_hdr(struct scsi_disk *sdkp,
-			       struct scsi_sense_hdr *sshdr)
+void sd_print_sense_hdr(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 {
 	sd_printk(KERN_INFO, sdkp, "");
 	scsi_show_sense_hdr(sshdr);
 	sd_printk(KERN_INFO, sdkp, "");
 	scsi_show_extd_sense(sshdr->asc, sshdr->ascq);
 }
+EXPORT_SYMBOL(sd_print_sense_hdr);
 
 static void sd_print_result(struct scsi_disk *sdkp, int result)
 {
diff -r 431a96f963a6 drivers/scsi/sd.h
--- a/drivers/scsi/sd.h	Fri Apr 25 13:36:00 2008 -0400
+++ b/drivers/scsi/sd.h	Fri Apr 25 13:36:39 2008 -0400
@@ -48,6 +48,8 @@
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
+extern void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
+
 #define sd_printk(prefix, sdsk, fmt, a...)				\
         (sdsk)->disk ?							\
 	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\
