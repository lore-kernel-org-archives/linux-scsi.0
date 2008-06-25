From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 02 of 10] sd: Move scsi_disk() accessor function to sd.h
Date: Wed, 25 Jun 2008 11:22:41 -0400
Message-ID: <9dfbf13b10cd81bd07aa.1214407361@sermon.lab.mkp.net>
References: <patchbomb.1214407359@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:41039 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbYFYPZ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 11:25:26 -0400
In-Reply-To: <patchbomb.1214407359@sermon.lab.mkp.net>
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
@@ -293,11 +293,6 @@ static int sd_major(int major_idx)
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
@@ -48,6 +48,11 @@ struct scsi_disk {
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
+static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
+{
+	return container_of(disk->private_data, struct scsi_disk, driver);
+}
+
 #define sd_printk(prefix, sdsk, fmt, a...)				\
         (sdsk)->disk ?							\
 	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\


