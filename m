From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 2/2] stex: add new device (id 0x8650) support
Date: Wed, 27 Sep 2006 19:23:41 +0800
Message-ID: <NONAMEBCF1HkikieqXI000003ce@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:6451 "EHLO
	nonameb.ptu.promise.com") by vger.kernel.org with ESMTP
	id S965575AbWI0LYO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Sep 2006 07:24:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>


A new device (id 0x8650, nickname 'yosemite') support is added.
It's basically the same, except for following items:
- mapping of id and lun by firmware
- special handling for some commands in interrupt routine
- change of internal copy function for these special commands
- different reset handling code
- different shutdown notification command

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index cfb2971..a54e6c1 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -11,7 +11,7 @@
  *	Written By:
  *		Ed Lin <promise_linux@promise.com>
  *
- *	Version: 2.9.0.13
+ *	Version: 3.0.0.1
  *
  */
 
@@ -37,11 +37,11 @@ #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 
 #define DRV_NAME "stex"
-#define ST_DRIVER_VERSION "2.9.0.13"
-#define ST_VER_MAJOR 		2
-#define ST_VER_MINOR 		9
+#define ST_DRIVER_VERSION "3.0.0.1"
+#define ST_VER_MAJOR 		3
+#define ST_VER_MINOR 		0
 #define ST_OEM 			0
-#define ST_BUILD_VER 		13
+#define ST_BUILD_VER 		1
 
 enum {
 	/* MU register offset */
@@ -120,12 +120,18 @@ enum {
 
 	st_shasta				= 0,
 	st_vsc					= 1,
+	st_yosemite				= 2,
 
 	PASSTHRU_REQ_TYPE			= 0x00000001,
 	PASSTHRU_REQ_NO_WAKEUP			= 0x00000100,
 	ST_INTERNAL_TIMEOUT			= 30,
 
+	ST_TO_CMD				= 0,
+	ST_FROM_CMD				= 1,
+
 	/* vendor specific commands of Promise */
+	MGT_CMD					= 0xd8,
+	SINBAND_MGT_CMD				= 0xd9,
 	ARRAY_CMD				= 0xe0,
 	CONTROLLER_CMD				= 0xe1,
 	DEBUGGING_CMD				= 0xe2,
@@ -133,14 +139,48 @@ enum {
 
 	PASSTHRU_GET_ADAPTER			= 0x05,
 	PASSTHRU_GET_DRVVER			= 0x10,
+
+	CTLR_CONFIG_CMD				= 0x03,
+	CTLR_SHUTDOWN				= 0x0d,
+
 	CTLR_POWER_STATE_CHANGE			= 0x0e,
 	CTLR_POWER_SAVING			= 0x01,
 
 	PASSTHRU_SIGNATURE			= 0x4e415041,
+	MGT_CMD_SIGNATURE			= 0xba,
 
 	INQUIRY_EVPD				= 0x01,
 };
 
+/* SCSI inquiry data */
+typedef struct st_inq {
+	u8 DeviceType			:5;
+	u8 DeviceTypeQualifier		:3;
+	u8 DeviceTypeModifier		:7;
+	u8 RemovableMedia		:1;
+	u8 Versions;
+	u8 ResponseDataFormat		:4;
+	u8 HiSupport			:1;
+	u8 NormACA			:1;
+	u8 ReservedBit			:1;
+	u8 AERC				:1;
+	u8 AdditionalLength;
+	u8 Reserved[2];
+	u8 SoftReset			:1;
+	u8 CommandQueue			:1;
+	u8 Reserved2			:1;
+	u8 LinkedCommands		:1;
+	u8 Synchronous			:1;
+	u8 Wide16Bit			:1;
+	u8 Wide32Bit			:1;
+	u8 RelativeAddressing		:1;
+	u8 VendorId[8];
+	u8 ProductId[16];
+	u8 ProductRevisionLevel[4];
+	u8 VendorSpecific[20];
+	u8 Reserved3[40];
+} ST_INQ;
+
 struct st_sgitem {
 	u8 ctrl;	/* SG_CF_xxx */
 	u8 reserved[3];
@@ -242,7 +282,8 @@ struct st_drvver {
 #define MU_REQ_BUFFER_SIZE	(MU_REQ_COUNT * sizeof(struct req_msg))
 #define MU_STATUS_BUFFER_SIZE	(MU_STATUS_COUNT * sizeof(struct status_msg))
 #define MU_BUFFER_SIZE		(MU_REQ_BUFFER_SIZE + MU_STATUS_BUFFER_SIZE)
-#define STEX_BUFFER_SIZE	(MU_BUFFER_SIZE + sizeof(struct st_frame))
+#define STEX_EXTRA_SIZE		max(sizeof(struct st_frame), sizeof(ST_INQ))
+#define STEX_BUFFER_SIZE	(MU_BUFFER_SIZE + STEX_EXTRA_SIZE)
 
 struct st_ccb {
 	struct req_msg *req;
@@ -403,7 +444,7 @@ static int stex_map_sg(struct st_hba *hb
 }
 
 static void stex_internal_copy(struct scsi_cmnd *cmd,
-	const void *src, size_t *count, int sg_count)
+	const void *src, size_t *count, int sg_count, int direction)
 {
 	size_t lcount;
 	size_t len;
@@ -427,7 +468,10 @@ static void stex_internal_copy(struct sc
 		} else
 			d = cmd->request_buffer;
 
-		memcpy(d, s, len);
+		if (direction == ST_TO_CMD)
+			memcpy(d, s, len);
+		else
+			memcpy(s, d, len);
 
 		lcount -= len;
 		if (cmd->use_sg)
@@ -449,7 +493,7 @@ static int stex_direct_copy(struct scsi_
 			return 0;
 	}
 
-	stex_internal_copy(cmd, src, &cp_len, n_elem);
+	stex_internal_copy(cmd, src, &cp_len, n_elem, ST_TO_CMD);
 
 	if (cmd->use_sg)
 		pci_unmap_sg(hba->pdev, cmd->request_buffer,
@@ -480,7 +524,7 @@ static void stex_controller_info(struct 
 	p->subid =
 		hba->pdev->subsystem_vendor << 16 | hba->pdev->subsystem_device;
 
-	stex_internal_copy(ccb->cmd, p, &count, ccb->sg_count);
+	stex_internal_copy(ccb->cmd, p, &count, ccb->sg_count, ST_TO_CMD);
 }
 
 static void
@@ -594,8 +638,14 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 		return SCSI_MLQUEUE_HOST_BUSY;
 
 	req = stex_alloc_req(hba);
-	req->lun = lun;
-	req->target = id;
+
+	if (hba->cardtype == st_yosemite) {
+		req->lun = lun * (ST_MAX_TARGET_NUM - 1) + id;
+		req->target = 0;
+	} else {
+		req->lun = lun;
+		req->target = id;
+	}
 
 	/* cdb */
 	memcpy(req->cdb, cmd->cmnd, STEX_CDB_LENGTH);
@@ -679,7 +729,51 @@ static void stex_copy_data(struct st_ccb
 
 	if (ccb->cmd == NULL)
 		return;
-	stex_internal_copy(ccb->cmd, resp->variable, &count, ccb->sg_count);
+	stex_internal_copy(ccb->cmd,
+		resp->variable, &count, ccb->sg_count, ST_TO_CMD);
+}
+
+static void stex_ys_commands(struct st_hba *hba,
+	struct st_ccb *ccb, struct status_msg *resp)
+{
+	size_t count;
+
+	if (ccb->cmd->cmnd[0] == MGT_CMD &&
+		resp->scsi_status != SAM_STAT_CHECK_CONDITION) {
+		ccb->cmd->request_bufflen =
+			le32_to_cpu(*(__le32 *)&resp->variable[0]);
+		return;
+	}
+
+	if (resp->srb_status != 0)
+		return;
+
+	/* determine inquiry command status by DeviceTypeQualifier */
+	if (ccb->cmd->cmnd[0] == INQUIRY &&
+		resp->scsi_status == SAM_STAT_GOOD) {
+		ST_INQ *inq_data;
+
+		count = STEX_EXTRA_SIZE;
+		stex_internal_copy(ccb->cmd, hba->copy_buffer,
+			&count, ccb->sg_count, ST_FROM_CMD);
+		inq_data = (ST_INQ *)hba->copy_buffer;
+		if (inq_data->DeviceTypeQualifier != 0)
+			ccb->srb_status = SRB_STATUS_SELECTION_TIMEOUT;
+		else
+			ccb->srb_status = SRB_STATUS_SUCCESS;
+	} else if (ccb->cmd->cmnd[0] == REPORT_LUNS) {
+		u8 *report_lun_data = (u8 *)hba->copy_buffer;
+
+		count = STEX_EXTRA_SIZE;
+		stex_internal_copy(ccb->cmd, report_lun_data,
+			&count, ccb->sg_count, ST_FROM_CMD);
+		if (report_lun_data[2] || report_lun_data[3]) {
+			report_lun_data[2] = 0x00;
+			report_lun_data[3] = 0x08;
+			stex_internal_copy(ccb->cmd, report_lun_data,
+				&count, ccb->sg_count, ST_TO_CMD);
+		}
+	}
 }
 
 static void stex_mu_intr(struct st_hba *hba, u32 doorbell)
@@ -701,8 +795,17 @@ static void stex_mu_intr(struct st_hba *
 		return;
 	}
 
-	if (unlikely(hba->mu_status != MU_STATE_STARTED ||
-		hba->out_req_cnt <= 0)) {
+	/*
+	 * it's not a valid status payload if:
+	 * 1. there are no pending requests(e.g. during init stage)
+	 * 2. there are some pending requests, but the controller is in
+	 *     reset status, and its type is not st_yosemite
+	 * firmware of st_yosemite in reset status will return pending requests
+	 * to driver, so we allow it to pass
+	 */
+	if (unlikely(hba->out_req_cnt <= 0 ||
+			(hba->mu_status == MU_STATE_RESETTING &&
+			 hba->cardtype != st_yosemite))) {
 		hba->status_tail = hba->status_head;
 		goto update_status;
 	}
@@ -722,6 +825,7 @@ static void stex_mu_intr(struct st_hba *
 		if (unlikely(ccb->req == NULL)) {
 			printk(KERN_WARNING DRV_NAME
 				"(%s): lagging req\n", pci_name(hba->pdev));
+			hba->out_req_cnt--;
 			continue;
 		}
 
@@ -740,9 +844,13 @@ static void stex_mu_intr(struct st_hba *
 		ccb->scsi_status = resp->scsi_status;
 
 		if (likely(ccb->cmd != NULL)) {
+			if (hba->cardtype == st_yosemite)
+				stex_ys_commands(hba, ccb, resp);
+
 			if (unlikely(ccb->cmd->cmnd[0] == PASSTHRU_CMD &&
 				ccb->cmd->cmnd[1] == PASSTHRU_GET_ADAPTER))
 				stex_controller_info(hba, ccb);
+
 			stex_unmap_sg(hba, ccb->cmd);
 			stex_scsi_done(ccb);
 			hba->out_req_cnt--;
@@ -947,6 +1055,7 @@ static int stex_reset(struct scsi_cmnd *
 {
 	struct st_hba *hba;
 	unsigned long flags;
+	unsigned long before;
 	hba = (struct st_hba *) &cmd->device->host->hostdata[0];
 
 	hba->mu_status = MU_STATE_RESETTING;
@@ -954,20 +1063,37 @@ static int stex_reset(struct scsi_cmnd *
 	if (hba->cardtype == st_shasta)
 		stex_hard_reset(hba);
 
-	if (stex_handshake(hba)) {
-		printk(KERN_WARNING DRV_NAME
-			"(%s): resetting: handshake failed\n",
-			pci_name(hba->pdev));
-		return FAILED;
+	if (hba->cardtype != st_yosemite) {
+		if (stex_handshake(hba)) {
+			printk(KERN_WARNING DRV_NAME
+				"(%s): resetting: handshake failed\n",
+				pci_name(hba->pdev));
+			return FAILED;
+		}
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		hba->req_head = 0;
+		hba->req_tail = 0;
+		hba->status_head = 0;
+		hba->status_tail = 0;
+		hba->out_req_cnt = 0;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		return SUCCESS;
 	}
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->req_head = 0;
-	hba->req_tail = 0;
-	hba->status_head = 0;
-	hba->status_tail = 0;
-	hba->out_req_cnt = 0;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	/* st_yosemite */
+	writel(MU_INBOUND_DOORBELL_RESET, hba->mmio_base + IDBL);
+	readl(hba->mmio_base + IDBL); /* flush */
+	before = jiffies;
+	while (hba->out_req_cnt > 0) {
+		if (time_after(jiffies, before + ST_INTERNAL_TIMEOUT * HZ)) {
+			printk(KERN_WARNING DRV_NAME
+				"(%s): reset timeout\n", pci_name(hba->pdev));
+			return FAILED;
+		}
+		msleep(1);
+	}
+
+	hba->mu_status = MU_STATE_STARTED;
 	return SUCCESS;
 }
 
@@ -1155,9 +1281,16 @@ static void stex_hba_stop(struct st_hba 
 	req = stex_alloc_req(hba);
 	memset(req->cdb, 0, STEX_CDB_LENGTH);
 
-	req->cdb[0] = CONTROLLER_CMD;
-	req->cdb[1] = CTLR_POWER_STATE_CHANGE;
-	req->cdb[2] = CTLR_POWER_SAVING;
+	if (hba->cardtype == st_yosemite) {
+		req->cdb[0] = MGT_CMD;
+		req->cdb[1] = MGT_CMD_SIGNATURE;
+		req->cdb[2] = CTLR_CONFIG_CMD;
+		req->cdb[3] = CTLR_SHUTDOWN;
+	} else {
+		req->cdb[0] = CONTROLLER_CMD;
+		req->cdb[1] = CTLR_POWER_STATE_CHANGE;
+		req->cdb[2] = CTLR_POWER_SAVING;
+	}
 
 	hba->ccb[tag].cmd = NULL;
 	hba->ccb[tag].sg_count = 0;
@@ -1221,6 +1354,7 @@ static struct pci_device_id stex_pci_tbl
 	{ 0x105a, 0x8301, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_shasta },
 	{ 0x105a, 0x8302, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_shasta },
 	{ 0x1725, 0x7250, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_vsc },
+	{ 0x105a, 0x8650, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_yosemite },
 	{ }	/* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, stex_pci_tbl);

