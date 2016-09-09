From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 5/5] hpsa: check for null devices in ioaccel submission patch
Date: Fri, 9 Sep 2016 16:30:42 -0500
Message-ID: <147345664240.19269.1463288670424335492.stgit@brunhilda>
References: <147345640313.19269.15042173861496542431.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0046.outbound.protection.outlook.com ([104.47.38.46]:18560
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752040AbcIIVbF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Sep 2016 17:31:05 -0400
In-Reply-To: <147345640313.19269.15042173861496542431.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Reviewed-by: Scott Benesh <scott.benest@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 06f5e1c..e4b3241 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2499,6 +2499,10 @@ static void complete_scsi_command(struct CommandList *cp)
 	}
 
 	dev = cmd->device->hostdata;
+	if (!dev) {
+		cmd->result = DID_NO_CONNECT << 16;
+		return hpsa_cmd_free_and_done(h, cp, cmd);
+	}
 	c2 = &h->ioaccel2_cmd_pool[cp->cmdindex];
 
 	scsi_dma_unmap(cmd); /* undo the DMA mappings */
@@ -4686,6 +4690,9 @@ static int hpsa_scsi_ioaccel_direct_map(struct ctlr_info *h,
 	struct scsi_cmnd *cmd = c->scsi_cmd;
 	struct hpsa_scsi_dev_t *dev = cmd->device->hostdata;
 
+	if (!dev)
+		return -1;
+
 	c->phys_disk = dev;
 
 	return hpsa_scsi_ioaccel_queue_command(h, c, dev->ioaccel_handle,
@@ -4762,6 +4769,12 @@ static int hpsa_scsi_ioaccel2_queue_command(struct ctlr_info *h,
 	u32 len;
 	u32 total_len = 0;
 
+	if (!cmd->device)
+		return -1;
+
+	if (!cmd->device->hostdata)
+		return -1;
+
 	BUG_ON(scsi_sg_count(cmd) > h->maxsgentries);
 
 	if (fixup_ioaccel_cdb(cdb, &cdb_len)) {
@@ -4870,6 +4883,12 @@ static int hpsa_scsi_ioaccel_queue_command(struct ctlr_info *h,
 	struct CommandList *c, u32 ioaccel_handle, u8 *cdb, int cdb_len,
 	u8 *scsi3addr, struct hpsa_scsi_dev_t *phys_disk)
 {
+	if (!c->scsi_cmd->device)
+		return -1;
+
+	if (!c->scsi_cmd->device->hostdata)
+		return -1;
+
 	/* Try to honor the device's queue depth */
 	if (atomic_inc_return(&phys_disk->ioaccel_cmds_out) >
 					phys_disk->queue_depth) {
@@ -4950,6 +4969,9 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 #endif
 	int offload_to_mirror;
 
+	if (!dev)
+		return -1;
+
 	/* check for valid opcode, get LBA and block count */
 	switch (cmd->cmnd[0]) {
 	case WRITE_6:
@@ -5362,6 +5384,9 @@ static int hpsa_ioaccel_submit(struct ctlr_info *h,
 	struct hpsa_scsi_dev_t *dev = cmd->device->hostdata;
 	int rc = IO_ACCEL_INELIGIBLE;
 
+	if (!dev)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	cmd->host_scribble = (unsigned char *) c;
 
 	if (dev->offload_enabled) {
@@ -5900,6 +5925,9 @@ static void setup_ioaccel2_abort_cmd(struct CommandList *c, struct ctlr_info *h,
 	struct scsi_cmnd *scmd = command_to_abort->scsi_cmd;
 	struct hpsa_scsi_dev_t *dev = scmd->device->hostdata;
 
+	if (!dev)
+		return;
+
 	/*
 	 * We're overlaying struct hpsa_tmf_struct on top of something which
 	 * was allocated as a struct io_accel2_cmd, so we better be sure it
@@ -6020,6 +6048,9 @@ static int hpsa_send_abort_ioaccel2(struct ctlr_info *h,
 	struct io_accel2_cmd *c2;
 
 	dev = abort->scsi_cmd->device->hostdata;
+	if (!dev)
+		return -1;
+
 	if (!dev->offload_enabled && !dev->hba_ioaccel_enabled)
 		return -1;
 

