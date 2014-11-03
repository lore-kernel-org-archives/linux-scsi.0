From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vmw_pvscsi: fixup tagging
Date: Mon, 3 Nov 2014 10:30:28 -0800
Message-ID: <20141103183028.GA18162@infradead.org>
References: <1412234501-78199-1-git-send-email-hare@suse.de>
 <20141017131651.GD16538@infradead.org>
 <41c186a1dcd04732a87f8bc47336a5d7@EX13-MBX-025.vmware.com>
 <5442A671.3080704@suse.de>
 <1690691e34434a6d9cb690a655897613@EX13-MBX-025.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34129 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaKCSai (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2014 13:30:38 -0500
Content-Disposition: inline
In-Reply-To: <1690691e34434a6d9cb690a655897613@EX13-MBX-025.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arvind Kumar <arvindkumar@vmware.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

FYI, I've updated the patch a bit in my tree to always set  e->tag to
SIMPLE_QUEUE_TAG.  The rationale for that is that we actually never set
MSG_ORDERED_TAG for other drivers since 2010, and fixing this up
properly in this driver makes it conflict less with my patch series to
fix up more mess in this area.

Updated patch below:

---
From: Hannes Reinecke <hare@suse.de>
Subject: vmw_pvscsi: fixup tagging

The request (and SCSI command) tag is the tag number assigned
by the generic block-tagging code, not the SCSI-II tag messages.
Those are represented by the device flags 'tagged_supported',
'simple_tags', and 'ordered_tags'.
(The SCSI midlayer doesn't use HEAD_OF_QUEUE tags).
So fixup vmw_pvscsi to assign the correct tag type.

[hch: fixed up to never set MSG_ORDERED_TAG]
Signed-off-by: Hannes Reinecke <hare@suse.de>
Acked-by: Arvind Kumar <arvindkumar@vmware.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/vmw_pvscsi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 598f65e..7dd4d17 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -723,10 +723,6 @@ static int pvscsi_queue_ring(struct pvscsi_adapter *adapter,
 	memcpy(e->cdb, cmd->cmnd, e->cdbLen);
 
 	e->tag = SIMPLE_QUEUE_TAG;
-	if (sdev->tagged_supported &&
-	    (cmd->tag == HEAD_OF_QUEUE_TAG ||
-	     cmd->tag == ORDERED_QUEUE_TAG))
-		e->tag = cmd->tag;
 
 	if (cmd->sc_data_direction == DMA_FROM_DEVICE)
 		e->flags = PVSCSI_FLAG_CMD_DIR_TOHOST;
-- 
1.9.1

