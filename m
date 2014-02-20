From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/9] scsi: avoid useless free_list lock roundtrips
Date: Thu, 20 Feb 2014 14:20:53 -0800
Message-ID: <20140220222356.549889893@bombadil.infradead.org>
References: <20140220222052.717958451@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58127 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaBTWX5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 17:23:57 -0500
Content-Disposition: inline; filename=0001-scsi-avoid-useless-free_list-lock-roundtrips.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Avoid hitting the host-wide free_list lock unless we need to put a command
back onto the freelist.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d8afec8..fb86479 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -320,13 +320,14 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
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
 
 	if (likely(cmd != NULL))
 		scsi_pool_free_command(shost->cmd_pool, cmd);
-- 
1.7.10.4


