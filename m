From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 24/26] megaraid_mbox: drop duplicate bus reset and device reset function
Date: Fri, 25 Aug 2017 13:57:19 +0200
Message-ID: <1503662241-127788-25-git-send-email-hare@suse.de>
References: <1503662241-127788-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49614 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756521AbdHYL6F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 07:58:05 -0400
In-Reply-To: <1503662241-127788-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

megaraid_mbox only has one reset function, and that is a host reset.
So drop the duplicate bus reset and device reset functions.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/megaraid/megaraid_mbox.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 6d0bd3a..ec3c4385 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -341,8 +341,6 @@ static void megaraid_mbox_prepare_epthru(adapter_t *, scb_t *,
 	.proc_name			= "megaraid",
 	.queuecommand			= megaraid_queue_command,
 	.eh_abort_handler		= megaraid_abort_handler,
-	.eh_device_reset_handler	= megaraid_reset_handler,
-	.eh_bus_reset_handler		= megaraid_reset_handler,
 	.eh_host_reset_handler		= megaraid_reset_handler,
 	.change_queue_depth		= scsi_change_queue_depth,
 	.use_clustering			= ENABLE_CLUSTERING,
-- 
1.8.5.6
