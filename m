From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/7] mpt3sas: simplify ->change_queue_depth
Date: Thu, 13 Nov 2014 18:59:05 +0100
Message-ID: <1415901546-8006-7-git-send-email-hch@lst.de>
References: <1415901546-8006-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54681 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933559AbaKMR7M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2014 12:59:12 -0500
In-Reply-To: <1415901546-8006-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>

Merge two functions, and remove overly verbose debugging output that pokes
into mid-layer internal structures.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index de175b9..a2b6099 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1053,9 +1053,15 @@ _scsih_scsi_lookup_find_by_lun(struct MPT3SAS_ADAPTER *ioc, int id,
 	return found;
 }
 
-
-static void
-_scsih_adjust_queue_depth(struct scsi_device *sdev, int qdepth)
+/**
+ * _scsih_change_queue_depth - setting device queue depth
+ * @sdev: scsi device struct
+ * @qdepth: requested queue depth
+ *
+ * Returns queue depth.
+ */
+static int
+_scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
 	struct Scsi_Host *shost = sdev->host;
 	int max_depth;
@@ -1090,29 +1096,7 @@ _scsih_adjust_queue_depth(struct scsi_device *sdev, int qdepth)
 		max_depth = 1;
 	if (qdepth > max_depth)
 		qdepth = max_depth;
-	scsi_change_queue_depth(sdev, qdepth);
-}
-
-/**
- * _scsih_change_queue_depth - setting device queue depth
- * @sdev: scsi device struct
- * @qdepth: requested queue depth
- *
- * Returns queue depth.
- */
-static int
-_scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
-{
-	_scsih_adjust_queue_depth(sdev, qdepth);
-
-	if (sdev->inquiry_len > 7)
-		sdev_printk(KERN_INFO, sdev, "qdepth(%d), tagged(%d), " \
-		"simple(%d), scsi_level(%d), cmd_que(%d)\n",
-		sdev->queue_depth, sdev->tagged_supported, sdev->simple_tags,
-		sdev->scsi_level,
-		(sdev->inquiry[7] & 2) >> 1);
-
-	return sdev->queue_depth;
+	return scsi_change_queue_depth(sdev, qdepth);
 }
 
 /**
-- 
1.9.1

