From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3 of 4] sd: Allow sd_print_sense_hdr to be called outside of
	sd.c
Date: Tue, 17 Jun 2008 12:47:33 -0400
Message-ID: <d480137d801899d727b2.1213721253@sermon.lab.mkp.net>
References: <patchbomb.1213721250@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:41668 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbYFQQ61 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jun 2008 12:58:27 -0400
In-Reply-To: <patchbomb.1213721250@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
2 files changed, 3 insertions(+), 3 deletions(-)
drivers/scsi/sd.c |    4 +---
drivers/scsi/sd.h |    2 ++



diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -96,7 +96,6 @@ static int sd_done(struct scsi_cmnd *);
 static int sd_done(struct scsi_cmnd *);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct device *cdev);
-static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
 static void sd_print_result(struct scsi_disk *, int);
 
 static DEFINE_IDR(sd_index_idr);
@@ -1929,8 +1928,7 @@ module_init(init_sd);
 module_init(init_sd);
 module_exit(exit_sd);
 
-static void sd_print_sense_hdr(struct scsi_disk *sdkp,
-			       struct scsi_sense_hdr *sshdr)
+void sd_print_sense_hdr(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 {
 	sd_printk(KERN_INFO, sdkp, "");
 	scsi_show_sense_hdr(sshdr);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -48,6 +48,8 @@ struct scsi_disk {
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
+extern void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
+
 #define sd_printk(prefix, sdsk, fmt, a...)				\
         (sdsk)->disk ?							\
 	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\


