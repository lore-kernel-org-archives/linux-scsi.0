From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi: zero per-cmd driver data before each I/O
Date: Mon, 20 Feb 2017 17:52:39 +0100
Message-ID: <20170220165239.25669-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43965 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752118AbdBTQwq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2017 11:52:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com
Cc: decui@microsoft.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

Without this drivers that don't clear the state themselves can see off
effects.  For example Hyper-V VMs using the storvsc driver will often
hang during boot due to uncleared Test Unit Ready failures.

Fixes: e9c787e6 ("scsi: allocate scsi_cmnd structures as part of struct request")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Dexuan Cui <decui@microsoft.com>
Tested-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/scsi/scsi_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 90f65c8f487a..daced9db8af8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1167,6 +1167,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 	/* zero out the cmd, except for the embedded scsi_request */
 	memset((char *)cmd + sizeof(cmd->req), 0,
 		sizeof(*cmd) - sizeof(cmd->req));
+	memset((char *)(cmd + 1), 0, dev->host->hostt->cmd_size);
 
 	cmd->device = dev;
 	cmd->sense_buffer = buf;
-- 
2.11.0
