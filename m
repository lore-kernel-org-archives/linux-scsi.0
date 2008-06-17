From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4 of 4] sd: Move scsi_disk() accessor function to sd.h
Date: Tue, 17 Jun 2008 12:47:34 -0400
Message-ID: <cdd56df85eadd160090c.1213721254@sermon.lab.mkp.net>
References: <patchbomb.1213721250@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:41669 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624AbYFQQ61 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jun 2008 12:58:27 -0400
In-Reply-To: <patchbomb.1213721250@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
2 files changed, 5 insertions(+), 5 deletions(-)
drivers/scsi/sd.c |    5 -----
drivers/scsi/sd.h |    5 +++++



diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -292,11 +292,6 @@ static int sd_major(int major_idx)
 		BUG();
 		return 0;	/* shut up gcc */
 	}
-}
-
-static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
-{
-	return container_of(disk->private_data, struct scsi_disk, driver);
 }
 
 static struct scsi_disk *__scsi_disk_get(struct gendisk *disk)
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -50,6 +50,11 @@ struct scsi_disk {
 
 extern void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
 
+static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
+{
+	return container_of(disk->private_data, struct scsi_disk, driver);
+}
+
 #define sd_printk(prefix, sdsk, fmt, a...)				\
         (sdsk)->disk ?							\
 	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\


