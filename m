From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 12/20] qla2xxx: Remove Marker type IOCB logic for ISPFX00.
Date: Fri, 13 Dec 2013 15:03:52 -0500
Message-ID: <1386965040-20611-13-git-send-email-saurav.kashyap@qlogic.com>
References: <1386965040-20611-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:23570 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192Ab3LMUgs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 15:36:48 -0500
In-Reply-To: <1386965040-20611-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |   11 +----------
 drivers/scsi/qla2xxx/qla_mr.c   |   12 ------------
 drivers/scsi/qla2xxx/qla_mr.h   |   24 ------------------------
 3 files changed, 1 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 5e6ac6c..0aad5e4 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -524,7 +524,6 @@ __qla2x00_marker(struct scsi_qla_host *vha, struct req_que *req,
 {
 	mrk_entry_t *mrk;
 	struct mrk_entry_24xx *mrk24 = NULL;
-	struct mrk_entry_fx00 *mrkfx = NULL;
 
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
@@ -541,15 +540,7 @@ __qla2x00_marker(struct scsi_qla_host *vha, struct req_que *req,
 	mrk->entry_type = MARKER_TYPE;
 	mrk->modifier = type;
 	if (type != MK_SYNC_ALL) {
-		if (IS_QLAFX00(ha)) {
-			mrkfx = (struct mrk_entry_fx00 *) mrk;
-			mrkfx->handle = MAKE_HANDLE(req->id, mrkfx->handle);
-			mrkfx->handle_hi = 0;
-			mrkfx->tgt_id = cpu_to_le16(loop_id);
-			mrkfx->lun[1] = LSB(lun);
-			mrkfx->lun[2] = MSB(lun);
-			host_to_fcp_swap(mrkfx->lun, sizeof(mrkfx->lun));
-		} else if (IS_FWI2_CAPABLE(ha)) {
+		if (IS_FWI2_CAPABLE(ha)) {
 			mrk24 = (struct mrk_entry_24xx *) mrk;
 			mrk24->nport_handle = cpu_to_le16(loop_id);
 			mrk24->lun[1] = LSB(lun);
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index a9b5cf4..893e56d 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2140,7 +2140,6 @@ qlafx00_initialize_adapter(scsi_qla_host_t *vha)
 	vha->device_flags = DFLG_NO_CABLE;
 	vha->dpc_flags = 0;
 	vha->flags.management_server_logged_in = 0;
-	vha->marker_needed = 0;
 	ha->isp_abort_cnt = 0;
 	ha->beacon_blink_led = 0;
 
@@ -3213,17 +3212,6 @@ qlafx00_start_scsi(srb_t *sp)
 	/* So we know we haven't pci_map'ed anything yet */
 	tot_dsds = 0;
 
-	/* Forcing marker needed for now */
-	vha->marker_needed = 0;
-
-	/* Send marker if required */
-	if (vha->marker_needed != 0) {
-		if (qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL) !=
-		    QLA_SUCCESS)
-			return QLA_FUNCTION_FAILED;
-		vha->marker_needed = 0;
-	}
-
 	/* Acquire ring specific lock */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.h
index 5f3ed8b..1e60ca2 100644
--- a/drivers/scsi/qla2xxx/qla_mr.h
+++ b/drivers/scsi/qla2xxx/qla_mr.h
@@ -47,30 +47,6 @@ struct cmd_type_7_fx00 {
 	uint32_t dseg_0_len;		/* Data segment 0 length. */
 };
 
-/*
- * ISP queue - marker entry structure definition.
- */
-struct mrk_entry_fx00 {
-	uint8_t entry_type;		/* Entry type. */
-	uint8_t entry_count;		/* Entry count. */
-	uint8_t handle_count;		/* Handle count. */
-	uint8_t entry_status;		/* Entry Status. */
-
-	uint32_t handle;		/* System handle. */
-	uint32_t handle_hi;		/* System handle. */
-
-	uint16_t tgt_id;		/* Target ID. */
-
-	uint8_t modifier;		/* Modifier (7-0). */
-	uint8_t reserved_1;
-
-	uint8_t reserved_2[5];
-
-	uint8_t lun[8];			/* FCP LUN (BE). */
-	uint8_t reserved_3[36];
-};
-
-
 #define	STATUS_TYPE_FX00	0x01		/* Status entry. */
 struct sts_entry_fx00 {
 	uint8_t entry_type;		/* Entry type. */
-- 
1.7.7

