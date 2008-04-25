From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 10 of 16] Allow sd_print_sense_hdr to be called outside of sd.c
Date: Fri, 25 Apr 2008 19:12:12 -0400
Message-ID: <d13d7571165efb9cf0df.1209165132@sermon.lab.mkp.net>
References: <patchbomb.1209165122@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:44317 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759485AbYDYXR3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 19:17:29 -0400
In-Reply-To: <patchbomb.1209165122@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

2 files changed, 4 insertions(+), 3 deletions(-)
drivers/scsi/sd.c |    5 ++---
include/scsi/sd.h |    2 ++


Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r 7d9a353f8b7c -r d13d7571165e drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Fri Apr 25 17:39:29 2008 -0400
+++ b/drivers/scsi/sd.c	Fri Apr 25 17:39:29 2008 -0400
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
diff -r 7d9a353f8b7c -r d13d7571165e include/scsi/sd.h
--- a/include/scsi/sd.h	Fri Apr 25 17:39:29 2008 -0400
+++ b/include/scsi/sd.h	Fri Apr 25 17:39:29 2008 -0400
@@ -48,6 +48,8 @@
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
+extern void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
+
 #define sd_printk(prefix, sdsk, fmt, a...)				\
         (sdsk)->disk ?							\
 	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\


