From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/7] block: move REQ_TYPE_ATA_TASKFILE and REQ_TYPE_ATA_PC to ide.h
Date: Fri, 17 Apr 2015 22:37:17 +0200
Message-ID: <1429303042-12078-3-git-send-email-hch@lst.de>
References: <1429303042-12078-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35367 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbbDQUiX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2015 16:38:23 -0400
In-Reply-To: <1429303042-12078-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org

These values are only used by the IDE driver, so move them into it
by allowing drivers to take cmd_type values after the first private
one.  Note that we have to turn cmd_type into a plain unsigned integer
so that gcc doesn't complain about mismatching enum types.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/blkdev.h | 11 ++---------
 include/linux/ide.h    |  7 +++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 98c9027..9cb4d80 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -79,14 +79,7 @@ enum rq_cmd_type_bits {
 	REQ_TYPE_PM_SUSPEND,		/* suspend request */
 	REQ_TYPE_PM_RESUME,		/* resume request */
 	REQ_TYPE_PM_SHUTDOWN,		/* shutdown request */
-	REQ_TYPE_DRV_PRIV,		/* driver defined type */
-	/*
-	 * for ATA/ATAPI devices. this really doesn't belong here, ide should
-	 * use REQ_TYPE_DRV_PRIV and use rq->cmd[0] with the range of driver
-	 * private REQ_LB opcodes to differentiate what type of request this is
-	 */
-	REQ_TYPE_ATA_TASKFILE,
-	REQ_TYPE_ATA_PC,
+	REQ_TYPE_DRV_PRIV,		/* driver defined types from here */
 };
 
 #define BLK_MAX_CDB	16
@@ -108,7 +101,7 @@ struct request {
 	struct blk_mq_ctx *mq_ctx;
 
 	u64 cmd_flags;
-	enum rq_cmd_type_bits cmd_type;
+	unsigned cmd_type;
 	unsigned long atomic_flags;
 
 	int cpu;
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 93b5ca7..62ac399 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -39,6 +39,12 @@
 
 struct device;
 
+/* IDE-specific values for req->cmd_type */
+enum ata_cmd_type_bits {
+	REQ_TYPE_ATA_TASKFILE = REQ_TYPE_DRV_PRIV + 1,
+	REQ_TYPE_ATA_PC,
+};
+
 /* Error codes returned in rq->errors to the higher part of the driver. */
 enum {
 	IDE_DRV_ERROR_GENERAL	= 101,
@@ -1551,4 +1557,5 @@ static inline void ide_set_drivedata(ide_drive_t *drive, void *data)
 #define ide_host_for_each_port(i, port, host) \
 	for ((i) = 0; ((port) = (host)->ports[i]) || (i) < MAX_HOST_PORTS; (i)++)
 
+
 #endif /* _IDE_H */
-- 
1.9.1

