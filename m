From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESUBMIT 14/23] qla2xxx: Add changes in the IOCB structures to adjust driver source codes to ISPFX00 firmware spec.
Date: Wed, 26 Feb 2014 04:15:09 -0500
Message-ID: <1393406118-6586-15-git-send-email-saurav.kashyap@qlogic.com>
References: <1393406118-6586-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:52131 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224AbaBZJuv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Feb 2014 04:50:51 -0500
In-Reply-To: <1393406118-6586-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.c |   10 +++++-----
 drivers/scsi/qla2xxx/qla_mr.h |   26 +++++++++++++-------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 893e56d..03e2050 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2343,8 +2343,7 @@ qlafx00_ioctl_iosb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		fstatus.ioctl_flags = pkt->fw_iotcl_flags;
 		fstatus.ioctl_data = pkt->dataword_r;
 		fstatus.adapid = pkt->adapid;
-		fstatus.adapid_hi = pkt->adapid_hi;
-		fstatus.reserved_2 = pkt->reserved_1;
+		fstatus.reserved_2 = pkt->dataword_r_extra;
 		fstatus.res_count = pkt->residuallen;
 		fstatus.status = pkt->status;
 		fstatus.seq_number = pkt->seq_no;
@@ -3262,7 +3261,9 @@ qlafx00_start_scsi(srb_t *sp)
 	memset(&lcmd_pkt, 0, REQUEST_ENTRY_SIZE);
 
 	lcmd_pkt.handle = MAKE_HANDLE(req->id, sp->handle);
-	lcmd_pkt.handle_hi = 0;
+	lcmd_pkt.reserved_0 = 0;
+	lcmd_pkt.port_path_ctrl = 0;
+	lcmd_pkt.reserved_1 = 0;
 	lcmd_pkt.dseg_count = cpu_to_le16(tot_dsds);
 	lcmd_pkt.tgt_idx = cpu_to_le16(sp->fcport->tgt_id);
 
@@ -3342,8 +3343,7 @@ qlafx00_tm_iocb(srb_t *sp, struct tsk_mgmt_entry_fx00 *ptm_iocb)
 	tm_iocb.entry_type = TSK_MGMT_IOCB_TYPE_FX00;
 	tm_iocb.entry_count = 1;
 	tm_iocb.handle = cpu_to_le32(MAKE_HANDLE(req->id, sp->handle));
-	tm_iocb.handle_hi = 0;
-	tm_iocb.timeout = cpu_to_le16(qla2x00_get_async_timeout(vha) + 2);
+	tm_iocb.reserved_0 = 0;
 	tm_iocb.tgt_id = cpu_to_le16(sp->fcport->tgt_id);
 	tm_iocb.control_flags = cpu_to_le32(fxio->u.tmf.flags);
 	if (tm_iocb.control_flags == cpu_to_le32((uint32_t)TCF_LUN_RESET)) {
diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.h
index 1e60ca2..3cf5ddc 100644
--- a/drivers/scsi/qla2xxx/qla_mr.h
+++ b/drivers/scsi/qla2xxx/qla_mr.h
@@ -22,13 +22,16 @@ struct cmd_type_7_fx00 {
 	uint8_t entry_status;		/* Entry Status. */
 
 	uint32_t handle;		/* System handle. */
-	uint32_t handle_hi;
+	uint8_t reserved_0;
+	uint8_t port_path_ctrl;
+	uint16_t reserved_1;
 
 	__le16 tgt_idx;		/* Target Idx. */
 	uint16_t timeout;		/* Command timeout. */
 
 	__le16 dseg_count;		/* Data segment count. */
-	uint16_t scsi_rsp_dsd_len;
+	uint8_t	scsi_rsp_dsd_len;
+	uint8_t reserved_2;
 
 	struct scsi_lun lun;		/* LUN (LE). */
 
@@ -55,7 +58,7 @@ struct sts_entry_fx00 {
 	uint8_t entry_status;		/* Entry Status. */
 
 	uint32_t handle;		/* System handle. */
-	uint32_t handle_hi;		/* System handle. */
+	uint32_t reserved_3;		/* System handle. */
 
 	__le16 comp_status;		/* Completion status. */
 	uint16_t reserved_0;		/* OX_ID used by the firmware. */
@@ -78,7 +81,7 @@ struct sts_entry_fx00 {
 
 struct multi_sts_entry_fx00 {
 	uint8_t entry_type;		/* Entry type. */
-	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_count;		/* Entry count. */
 	uint8_t handle_count;
 	uint8_t entry_status;
 
@@ -94,15 +97,13 @@ struct tsk_mgmt_entry_fx00 {
 
 	__le32 handle;		/* System handle. */
 
-	uint32_t handle_hi;		/* System handle. */
+	uint32_t reserved_0;
 
 	__le16 tgt_id;		/* Target Idx. */
 
 	uint16_t reserved_1;
-
-	uint16_t delay;			/* Activity delay in seconds. */
-
-	__le16 timeout;		/* Command timeout. */
+	uint16_t reserved_3;
+	uint16_t reserved_4;
 
 	struct scsi_lun lun;		/* LUN (LE). */
 
@@ -120,13 +121,13 @@ struct abort_iocb_entry_fx00 {
 	uint8_t entry_status;		/* Entry Status. */
 
 	__le32 handle;		/* System handle. */
-	__le32 handle_hi;		/* System handle. */
+	__le32 reserved_0;
 
 	__le16 tgt_id_sts;		/* Completion status. */
 	__le16 options;
 
 	__le32 abort_handle;		/* System handle. */
-	__le32 abort_handle_hi;	/* System handle. */
+	__le32 reserved_2;
 
 	__le16 req_que_no;
 	uint8_t reserved_1[38];
@@ -147,8 +148,7 @@ struct ioctl_iocb_entry_fx00 {
 
 	__le32 dataword_r;		/* Data word returned */
 	uint32_t adapid;		/* Adapter ID */
-	uint32_t adapid_hi;		/* Adapter ID high */
-	uint32_t reserved_1;
+	uint32_t dataword_r_extra;
 
 	__le32 seq_no;
 	uint8_t reserved_2[20];
-- 
1.7.7

