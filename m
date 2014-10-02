From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/5] vmw_pvscsi: fixup tagging
Date: Thu,  2 Oct 2014 12:43:11 +0200
Message-ID: <1412246593-107001-4-git-send-email-hare@suse.de>
References: <1412246593-107001-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbaJBKnQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2014 06:43:16 -0400
In-Reply-To: <1412246593-107001-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Webb Scales <webbnh@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The request (and SCSI command) tag is the tag number assigned
by the generic block-tagging code, not the SCSI-II tag messages.
Those are represented by the device flags 'tagged_supported',
'simple_tags', and 'ordered_tags'.
(The SCSI midlayer doesn't use HEAD_OF_QUEUE tags).
So fixup vmw_pvscsi to assign the correct tag type.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/vmw_pvscsi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 598f65e..d18df8c 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -724,9 +724,8 @@ static int pvscsi_queue_ring(struct pvscsi_adapter *adapter,
 
 	e->tag = SIMPLE_QUEUE_TAG;
 	if (sdev->tagged_supported &&
-	    (cmd->tag == HEAD_OF_QUEUE_TAG ||
-	     cmd->tag == ORDERED_QUEUE_TAG))
-		e->tag = cmd->tag;
+	    sdev->ordered_tags)
+		e->tag = ORDERED_QUEUE_TAG;
 
 	if (cmd->sc_data_direction == DMA_FROM_DEVICE)
 		e->flags = PVSCSI_FLAG_CMD_DIR_TOHOST;
-- 
1.8.5.2

