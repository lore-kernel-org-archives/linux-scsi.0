Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06276C77B61
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Apr 2023 08:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243242AbjD0IEV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Apr 2023 04:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243226AbjD0IEJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Apr 2023 04:04:09 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C5D3A9A
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 01:04:06 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33R7CHrF006786
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 01:04:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=JJgpwq9SoRin7Kg1AZVNOmglZ9PaHr8ui65LdB/nGsU=;
 b=LZVlKgAD/zlQePwUe9UYhAjsHW5gnKQ54/K9hqQiM5d0TRyUMWfMDuV1cXUNj0hTpO8z
 xZBubug+BP6IiKwucdoG5PLiDiy7c+XdrGpbrtyMPZzO2xtTGaepRIBdcsH0Uzhh7y4V
 J/bvR/iwkAjkWN4MT9e6x6LyW3YIVkfov6rwAQYMff6aMimirsUPUsaBnQ6c/cZ5NH3I
 S2ZmGP74lf5x1baiJ0dFjpYne4rypDaS9YUAG6Z0CSg+nvKgieOKEu/fheMMOPcGX6o2
 +fuoTEDhBqhghPVrDAgjuZR/ugCbb974GmDA/ChvbEH/79gjAmHCGuoMhScoBeCbKHBh Hg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q7apa2khg-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 01:04:06 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 27 Apr
 2023 01:04:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 27 Apr 2023 01:04:03 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 1E8843F70B5;
        Thu, 27 Apr 2023 01:04:03 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 5/7] qla2xxx: Fix mem access after free
Date:   Thu, 27 Apr 2023 01:03:49 -0700
Message-ID: <20230427080351.9889-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20230427080351.9889-1-njavali@marvell.com>
References: <20230427080351.9889-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: tsm3pYNCu30tIAKxhoOJGlyLIfsSTmI9
X-Proofpoint-GUID: tsm3pYNCu30tIAKxhoOJGlyLIfsSTmI9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_05,2023-04-26_03,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

System crash, where driver is accessing scsi layer's
memory (scsi_cmnd->device->host) to search for a well known internal
pointer (vha). The scsi_cmnd was released back to upper layer which
could be freed, but the driver is still accessing it.

7 [ffffa8e8d2c3f8d0] page_fault at ffffffff86c010fe
  [exception RIP: __qla2x00_eh_wait_for_pending_commands+240]
  RIP: ffffffffc0642350  RSP: ffffa8e8d2c3f988  RFLAGS: 00010286
  RAX: 0000000000000165  RBX: 0000000000000002  RCX: 00000000000036d8
  RDX: 0000000000000000  RSI: ffff9c5c56535188  RDI: 0000000000000286
  RBP: ffff9c5bf7aa4a58   R8: ffff9c589aecdb70   R9: 00000000000003d1
  R10: 0000000000000001  R11: 0000000000380000 R12: ffff9c5c5392bc78
  R13: ffff9c57044ff5c0 R14: ffff9c56b5a3aa00  R15: 00000000000006db
  ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
8 [ffffa8e8d2c3f9c8] qla2x00_eh_wait_for_pending_commands at ffffffffc0646dd5 [qla2xxx]
9 [ffffa8e8d2c3fa00] __qla2x00_async_tm_cmd at ffffffffc0658094 [qla2xxx]

Remove access of freed memory. Currently the driver was checking to see if
scsi_done was called by seeing if the sp->type has changed. Instead,
check to see if the command has left the  oustanding_cmds[] array as
sign of scsi_done was called.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |  38 ++++++++--
 drivers/scsi/qla2xxx/qla_os.c  | 130 ++++++++++++++++-----------------
 2 files changed, 95 insertions(+), 73 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index f3107508cf12..a07c010b0843 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1862,9 +1862,9 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
 	}
 }
 
-srb_t *
-qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
-    struct req_que *req, void *iocb)
+static srb_t *
+qla_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
+		       struct req_que *req, void *iocb, u16 *ret_index)
 {
 	struct qla_hw_data *ha = vha->hw;
 	sts_entry_t *pkt = iocb;
@@ -1899,12 +1899,25 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
 		return NULL;
 	}
 
-	req->outstanding_cmds[index] = NULL;
-
+	*ret_index = index;
 	qla_put_fw_resources(sp->qpair, &sp->iores);
 	return sp;
 }
 
+srb_t *
+qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
+			   struct req_que *req, void *iocb)
+{
+	uint16_t index;
+	srb_t *sp;
+
+	sp = qla_get_sp_from_handle(vha, func, req, iocb, &index);
+	if (sp)
+		req->outstanding_cmds[index] = NULL;
+
+	return sp;
+}
+
 static void
 qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
     struct mbx_entry *mbx)
@@ -3237,13 +3250,13 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		return;
 	}
 
-	req->outstanding_cmds[handle] = NULL;
 	cp = GET_CMD_SP(sp);
 	if (cp == NULL) {
 		ql_dbg(ql_dbg_io, vha, 0x3018,
 		    "Command already returned (0x%x/%p).\n",
 		    sts->handle, sp);
 
+		req->outstanding_cmds[handle] = NULL;
 		return;
 	}
 
@@ -3514,6 +3527,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 	if (rsp->status_srb == NULL)
 		sp->done(sp, res);
+
+	/* for io's, clearing of outstanding_cmds[handle] means scsi_done was called */
+	req->outstanding_cmds[handle] = NULL;
 }
 
 /**
@@ -3590,6 +3606,7 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	uint16_t que = MSW(pkt->handle);
 	struct req_que *req = NULL;
 	int res = DID_ERROR << 16;
+	u16 index;
 
 	ql_dbg(ql_dbg_async, vha, 0x502a,
 	    "iocb type %xh with error status %xh, handle %xh, rspq id %d\n",
@@ -3608,7 +3625,6 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 
 	switch (pkt->entry_type) {
 	case NOTIFY_ACK_TYPE:
-	case STATUS_TYPE:
 	case STATUS_CONT_TYPE:
 	case LOGINOUT_PORT_IOCB_TYPE:
 	case CT_IOCB_TYPE:
@@ -3628,6 +3644,14 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	case CTIO_TYPE7:
 	case CTIO_CRC2:
 		return 1;
+	case STATUS_TYPE:
+		sp = qla_get_sp_from_handle(vha, func, req, pkt, &index);
+		if (sp) {
+			sp->done(sp, res);
+			req->outstanding_cmds[index] = NULL;
+			return 0;
+		}
+		break;
 	}
 fatal:
 	ql_log(ql_log_warn, vha, 0x5030,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d0cdbfe771a9..60734c569401 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1078,43 +1078,6 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 	return 0;
 }
 
-/*
- * qla2x00_eh_wait_on_command
- *    Waits for the command to be returned by the Firmware for some
- *    max time.
- *
- * Input:
- *    cmd = Scsi Command to wait on.
- *
- * Return:
- *    Completed in time : QLA_SUCCESS
- *    Did not complete in time : QLA_FUNCTION_FAILED
- */
-static int
-qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
-{
-#define ABORT_POLLING_PERIOD	1000
-#define ABORT_WAIT_ITER		((2 * 1000) / (ABORT_POLLING_PERIOD))
-	unsigned long wait_iter = ABORT_WAIT_ITER;
-	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
-	struct qla_hw_data *ha = vha->hw;
-	srb_t *sp = scsi_cmd_priv(cmd);
-	int ret = QLA_SUCCESS;
-
-	if (unlikely(pci_channel_offline(ha->pdev)) || ha->flags.eeh_busy) {
-		ql_dbg(ql_dbg_taskm, vha, 0x8005,
-		    "Return:eh_wait.\n");
-		return ret;
-	}
-
-	while (sp->type && wait_iter--)
-		msleep(ABORT_POLLING_PERIOD);
-	if (sp->type)
-		ret = QLA_FUNCTION_FAILED;
-
-	return ret;
-}
-
 /*
  * qla2x00_wait_for_hba_online
  *    Wait till the HBA is online after going through
@@ -1365,6 +1328,9 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	return ret;
 }
 
+#define ABORT_POLLING_PERIOD	1000
+#define ABORT_WAIT_ITER		((2 * 1000) / (ABORT_POLLING_PERIOD))
+
 /*
  * Returns: QLA_SUCCESS or QLA_FUNCTION_FAILED.
  */
@@ -1378,41 +1344,73 @@ __qla2x00_eh_wait_for_pending_commands(struct qla_qpair *qpair, unsigned int t,
 	struct req_que *req = qpair->req;
 	srb_t *sp;
 	struct scsi_cmnd *cmd;
+	unsigned long wait_iter = ABORT_WAIT_ITER;
+	bool found;
+	struct qla_hw_data *ha = vha->hw;
 
 	status = QLA_SUCCESS;
 
-	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
-	for (cnt = 1; status == QLA_SUCCESS &&
-		cnt < req->num_outstanding_cmds; cnt++) {
-		sp = req->outstanding_cmds[cnt];
-		if (!sp)
-			continue;
-		if (sp->type != SRB_SCSI_CMD)
-			continue;
-		if (vha->vp_idx != sp->vha->vp_idx)
-			continue;
-		match = 0;
-		cmd = GET_CMD_SP(sp);
-		switch (type) {
-		case WAIT_HOST:
-			match = 1;
-			break;
-		case WAIT_TARGET:
-			match = cmd->device->id == t;
-			break;
-		case WAIT_LUN:
-			match = (cmd->device->id == t &&
-				cmd->device->lun == l);
-			break;
-		}
-		if (!match)
-			continue;
+	while (wait_iter--) {
+		found = false;
 
-		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
-		status = qla2x00_eh_wait_on_command(cmd);
 		spin_lock_irqsave(qpair->qp_lock_ptr, flags);
+		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
+			sp = req->outstanding_cmds[cnt];
+			if (!sp)
+				continue;
+			if (sp->type != SRB_SCSI_CMD)
+				continue;
+			if (vha->vp_idx != sp->vha->vp_idx)
+				continue;
+			match = 0;
+			cmd = GET_CMD_SP(sp);
+			switch (type) {
+			case WAIT_HOST:
+				match = 1;
+				break;
+			case WAIT_TARGET:
+				if (sp->fcport)
+					match = sp->fcport->d_id.b24 == t;
+				else
+					match = 0;
+				break;
+			case WAIT_LUN:
+				if (sp->fcport)
+					match = (sp->fcport->d_id.b24 == t &&
+						cmd->device->lun == l);
+				else
+					match = 0;
+				break;
+			}
+			if (!match)
+				continue;
+
+			spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+
+			if (unlikely(pci_channel_offline(ha->pdev)) ||
+			    ha->flags.eeh_busy) {
+				ql_dbg(ql_dbg_taskm, vha, 0x8005,
+				    "Return:eh_wait.\n");
+				return status;
+			}
+
+			/*
+			 * SRB_SCSI_CMD is still in the outstanding_cmds array.
+			 * it means scsi_done has not called. Wait for it to
+			 * clear from outstanding_cmds.
+			 */
+			msleep(ABORT_POLLING_PERIOD);
+			spin_lock_irqsave(qpair->qp_lock_ptr, flags);
+			found = true;
+		}
+		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+
+		if (!found)
+			break;
 	}
-	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+
+	if (!wait_iter && found)
+		status = QLA_FUNCTION_FAILED;
 
 	return status;
 }
-- 
2.23.1

