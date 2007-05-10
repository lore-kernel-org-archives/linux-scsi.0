From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 1/4] stex: fix id mapping issue
Date: Wed, 9 May 2007 20:50:33 -0800
Message-ID: <NONAMEB29nIvX6bxu8Y00001141@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:49214 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754883AbXEJDse (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2007 23:48:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, hch <hch@infradead.org>, promise_linux <promise_linux@promise.com>


The correct internal mapping of stex controllers should be:
id:0~15, lun:0~7 (st_shasta)
id:0, lun:0~127 (st_yosemite)
id:0~127, lun:0 (st_vsc and st_vsc1)

This patch reports the internal mapping to scsi mid layer,  eliminating
the translation between scsi mid layer and firmware. To achieve this
goal, we also need to:
-- fail the REPORT_LUNS command for st_shasta because the
   firmware is known to not report all actual luns
-- add an entry in scsi_devindo.c to force sequential lun scan
   (for st_shasta controllers)
-- fail the REPORT_LUNS command for console device
-- remove special handling of REPORT_LUNS command for
   st_yosemite, as there is no translation mapping now

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index ce63044..18dd5cc 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -209,6 +209,7 @@ static struct {
 	{"PIONEER", "CD-ROM DRM-602X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-604X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
+	{"Promise", "", NULL, BLIST_SPARSELUN},
 	{"REGAL", "CDC-4X", NULL, BLIST_MAX5LUN | BLIST_SINGLELUN},
 	{"SanDisk", "ImageMate CF-SD1", NULL, BLIST_FORCELUN},
 	{"SEAGATE", "ST34555N", "0930", BLIST_NOTQ},	/* Chokes on tagged INQUIRY */
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 69be132..96dcbac 100644
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
@@ -586,7 +582,7 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 	u16 tag;
 	host = cmd->device->host;
 	id = cmd->device->id;
-	lun = cmd->device->channel; /* firmware lun issue work around */
+	lun = cmd->device->lun;
 	hba = (struct st_hba *) &host->hostdata[0];
 
 	switch (cmd->cmnd[0]) {
@@ -605,8 +601,19 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 			stex_invalid_field(cmd, done);
 		return 0;
 	}
+	case REPORT_LUNS:
+		/*
+		 * The shasta firmware does not report actual luns in the
+		 * target, so fail the command to force sequential lun scan.
+		 * Also, the console device does not support this command.
+		 */
+		if (hba->cardtype == st_shasta || id == host->max_id - 1) {
+			stex_invalid_field(cmd, done);
+			return 0;
+		}
+		break;
 	case INQUIRY:
-		if (id != ST_MAX_ARRAY_SUPPORTED)
+		if (id != host->max_id - 1)
 			break;
 		if (lun == 0 && (cmd->cmnd[1] & INQUIRY_EVPD) == 0) {
 			stex_direct_copy(cmd, console_inq_page,
@@ -624,7 +631,7 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 			ver.oem = ST_OEM;
 			ver.build = ST_BUILD_VER;
 			ver.signature[0] = PASSTHRU_SIGNATURE;
-			ver.console_id = ST_MAX_ARRAY_SUPPORTED;
+			ver.console_id = host->max_id - 1;
 			ver.host_no = hba->host->host_no;
 			cmd->result = stex_direct_copy(cmd, &ver, sizeof(ver)) ?
 				DID_OK << 16 | COMMAND_COMPLETE << 8 :
@@ -645,13 +652,8 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 
 	req = stex_alloc_req(hba);
 
-	if (hba->cardtype == st_yosemite) {
-		req->lun = lun * (ST_MAX_TARGET_NUM - 1) + id;
-		req->target = 0;
-	} else {
-		req->lun = lun;
-		req->target = id;
-	}
+	req->lun = lun;
+	req->target = id;
 
 	/* cdb */
 	memcpy(req->cdb, cmd->cmnd, STEX_CDB_LENGTH);
@@ -767,18 +769,6 @@ static void stex_ys_commands(struct st_h
 			ccb->srb_status = SRB_STATUS_SELECTION_TIMEOUT;
 		else
 			ccb->srb_status = SRB_STATUS_SUCCESS;
-	} else if (ccb->cmd->cmnd[0] == REPORT_LUNS) {
-		u8 *report_lun_data = (u8 *)hba->copy_buffer;
-
-		count = STEX_EXTRA_SIZE;
-		stex_internal_copy(ccb->cmd, report_lun_data,
-			&count, ccb->sg_count, ST_FROM_CMD);
-		if (report_lun_data[2] || report_lun_data[3]) {
-			report_lun_data[2] = 0x00;
-			report_lun_data[3] = 0x08;
-			stex_internal_copy(ccb->cmd, report_lun_data,
-				&count, ccb->sg_count, ST_TO_CMD);
-		}
 	}
 }
 
@@ -1229,12 +1219,18 @@ stex_probe(struct pci_dev *pdev, const s
 	hba->copy_buffer = hba->dma_mem + MU_BUFFER_SIZE;
 	hba->mu_status = MU_STATE_STARTING;
 
-	/* firmware uses id/lun pair for a logical drive, but lun would be
-	   always 0 if CONFIG_SCSI_MULTI_LUN not configured, so we use
-	   channel to map lun here */
-	host->max_channel = ST_MAX_LUN_PER_TARGET - 1;
-	host->max_id = ST_MAX_TARGET_NUM;
-	host->max_lun = 1;
+	if (hba->cardtype == st_shasta) {
+		host->max_lun = 8;
+		host->max_id = 16 + 1;
+	} else if (hba->cardtype == st_yosemite) {
+		host->max_lun = 128;
+		host->max_id = 1 + 1;
+	} else {
+		/* st_vsc and st_vsc1 */
+		host->max_lun = 1;
+		host->max_id = 128 + 1;
+	}
+	host->max_channel = 0;
 	host->unique_id = host->host_no;
 	host->max_cmd_len = STEX_CDB_LENGTH;
 


