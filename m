From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 1/4] stex: fix id mapping issue(v3)
Date: Wed, 4 Apr 2007 16:56:26 -0700
Message-ID: <NONAMEB8v5DkoQ4qcm500000733@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:45923 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752871AbXDDXyu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Apr 2007 19:54:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>


The correct internal mapping of stex controllers should be:
id:0~15, lun:0~7 (st_shasta)
id:0, lun:0~127 (st_yosemite)
id:0~127, lun:0 (st_vsc and st_vsc1)

Unfortunately we can not use the internal id/lun as scsi
mid layer id/lun. The Linux kernel has a config option
CONFIG_SCSI_MULTI_LUN. This option is not selected
in some major Linux releases. If it is not selected,
then st_shasta can expose 16 LDs(logical drive)
at most, while st_yosemite can expose only one LD.
This is clearly unacceptable.

This patch is a workaround for this issue.  Since every
LD is 'normal', and should be ignored/skipped in no
circumstances, we report that the max_id for LD is
128, then when commands are sent out by scsi
mid layer, we map id/lun pair based on controller type.

Please consider the situation, and apply the patch.
Thanks.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 69be132..d114e4c 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -113,10 +113,6 @@ enum {
 	SG_CF_64B				= 0x40,	/* 64 bit item */
 	SG_CF_HOST				= 0x20,	/* sg in host memory */
 
-	ST_MAX_ARRAY_SUPPORTED			= 16,
-	ST_MAX_TARGET_NUM			= (ST_MAX_ARRAY_SUPPORTED+1),
-	ST_MAX_LUN_PER_TARGET			= 16,
-
 	st_shasta				= 0,
 	st_vsc					= 1,
 	st_vsc1					= 2,
@@ -581,12 +577,11 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 {
 	struct st_hba *hba;
 	struct Scsi_Host *host;
-	unsigned int id,lun;
+	unsigned int id;
 	struct req_msg *req;
 	u16 tag;
 	host = cmd->device->host;
 	id = cmd->device->id;
-	lun = cmd->device->channel; /* firmware lun issue work around */
 	hba = (struct st_hba *) &host->hostdata[0];
 
 	switch (cmd->cmnd[0]) {
@@ -606,9 +601,9 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 		return 0;
 	}
 	case INQUIRY:
-		if (id != ST_MAX_ARRAY_SUPPORTED)
+		if (id != host->max_id - 1)
 			break;
-		if (lun == 0 && (cmd->cmnd[1] & INQUIRY_EVPD) == 0) {
+		if ((cmd->cmnd[1] & INQUIRY_EVPD) == 0) {
 			stex_direct_copy(cmd, console_inq_page,
 				sizeof(console_inq_page));
 			cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
@@ -624,7 +619,7 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 			ver.oem = ST_OEM;
 			ver.build = ST_BUILD_VER;
 			ver.signature[0] = PASSTHRU_SIGNATURE;
-			ver.console_id = ST_MAX_ARRAY_SUPPORTED;
+			ver.console_id = host->max_id - 1;
 			ver.host_no = hba->host->host_no;
 			cmd->result = stex_direct_copy(cmd, &ver, sizeof(ver)) ?
 				DID_OK << 16 | COMMAND_COMPLETE << 8 :
@@ -645,11 +640,15 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 
 	req = stex_alloc_req(hba);
 
-	if (hba->cardtype == st_yosemite) {
-		req->lun = lun * (ST_MAX_TARGET_NUM - 1) + id;
+	if (hba->cardtype == st_shasta) {
+ 		req->lun = id % 8;
+ 		req->target = id / 8;
+	} else if (hba->cardtype == st_yosemite){
+		req->lun = id;
 		req->target = 0;
 	} else {
-		req->lun = lun;
+		/* st_vsc and st_vsc1 */
+		req->lun = 0;
 		req->target = id;
 	}
 
@@ -1229,11 +1228,8 @@ stex_probe(struct pci_dev *pdev, const s
 	hba->copy_buffer = hba->dma_mem + MU_BUFFER_SIZE;
 	hba->mu_status = MU_STATE_STARTING;
 
-	/* firmware uses id/lun pair for a logical drive, but lun would be
-	   always 0 if CONFIG_SCSI_MULTI_LUN not configured, so we use
-	   channel to map lun here */
-	host->max_channel = ST_MAX_LUN_PER_TARGET - 1;
-	host->max_id = ST_MAX_TARGET_NUM;
+	host->max_channel = 0;
+	host->max_id = 128 + 1;
 	host->max_lun = 1;
 	host->unique_id = host->host_no;
 	host->max_cmd_len = STEX_CDB_LENGTH;


