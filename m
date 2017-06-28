From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/47] aacraid: complete all commands during bus reset
Date: Wed, 28 Jun 2017 10:32:33 +0200
Message-ID: <1498638793-44672-8-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53784 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751528AbdF1IdT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:19 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When issuing a bus reset we should complete all commands, not
just the command triggering the reset.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aacraid/linit.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 9b284a0..c26130e 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1007,23 +1007,29 @@ static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
 	struct Scsi_Host * host = dev->host;
 	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
 	int count;
-	u32 bus, cid;
+	u32 cmd_bus;
 	int status = 0;
 
 
-	bus = aac_logical_to_phys(scmd_channel(cmd));
-	cid = scmd_id(cmd);
-	if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS ||
-	    aac->hba_map[bus][cid].devtype != AAC_DEVTYPE_NATIVE_RAW) {
-		/* Mark the assoc. FIB to not complete, eh handler does this */
-		for (count = 0;
-			count < (host->can_queue + AAC_NUM_MGT_FIB);
-			++count) {
-			struct fib *fib = &aac->fibs[count];
-
-			if (fib->hw_fib_va->header.XferState &&
-				(fib->flags & FIB_CONTEXT_FLAG) &&
-				(fib->callback_data == cmd)) {
+	cmd_bus = aac_logical_to_phys(scmd_channel(cmd));
+	/* Mark the assoc. FIB to not complete, eh handler does this */
+	for (count = 0; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
+		struct fib *fib = &aac->fibs[count];
+
+		if (fib->hw_fib_va->header.XferState &&
+		    (fib->flags & FIB_CONTEXT_FLAG) &&
+		    (fib->flags & FIB_CONTEXT_FLAG_SCSI_CMD)) {
+			struct aac_hba_map_info *info;
+			u32 bus, cid;
+
+			cmd = (struct scsi_cmnd *)fib->callback_data;
+			bus = aac_logical_to_phys(scmd_channel(cmd));
+			if (bus != cmd_bus)
+				continue;
+			cid = scmd_id(cmd);
+			info = &aac->hba_map[bus][cid];
+			if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS ||
+			    info->devtype != AAC_DEVTYPE_NATIVE_RAW) {
 				fib->flags |= FIB_CONTEXT_FLAG_TIMED_OUT;
 				cmd->SCp.phase = AAC_OWNER_ERROR_HANDLER;
 			}
-- 
1.8.5.6
