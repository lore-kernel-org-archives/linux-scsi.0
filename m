From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 7/7] aacraid: complete all commands during bus reset
Date: Fri, 30 Jun 2017 19:18:12 +0200
Message-ID: <1498843092-76285-8-git-send-email-hare@suse.de>
References: <1498843092-76285-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59990 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751810AbdF3RTn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 13:19:43 -0400
In-Reply-To: <1498843092-76285-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When issuing a bus reset we should complete all commands, not
just the command triggering the reset.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Raghava Aditya Renukunta  <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/linit.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index e5d2d91..a8dedc3 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1010,23 +1010,29 @@ static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
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
