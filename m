From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/17] scsi: avoid useless free_list lock roundtrips
Date: Wed, 05 Feb 2014 04:39:34 -0800
Message-ID: <20140205124019.577883829@bombadil.infradead.org>
References: <20140205123930.150608699@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53194 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaBEMkZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:40:25 -0500
Content-Disposition: inline; filename=0004-scsi-avoid-useless-free_list-lock-roundtrips.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

Avoid hitting the host-wide free_list lock unless we need to put a command
back onto the freelist.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ebcea6c..4139486 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -320,15 +320,16 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
 {
 	unsigned long flags;
 
-	/* changing locks here, don't need to restore the irq state */
-	spin_lock_irqsave(&shost->free_list_lock, flags);
 	if (unlikely(list_empty(&shost->free_list))) {
-		list_add(&cmd->list, &shost->free_list);
-		cmd = NULL;
+		spin_lock_irqsave(&shost->free_list_lock, flags);
+		if (list_empty(&shost->free_list)) {
+			list_add(&cmd->list, &shost->free_list);
+			cmd = NULL;
+		}
+		spin_unlock_irqrestore(&shost->free_list_lock, flags);
 	}
-	spin_unlock_irqrestore(&shost->free_list_lock, flags);
 
-	if (likely(cmd != NULL))
+	if (cmd)
 		scsi_pool_free_command(shost->cmd_pool, cmd);
 
 	put_device(dev);
-- 
1.7.10.4


