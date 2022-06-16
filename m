Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B06FC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 05:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358613AbiFPFfQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 01:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358557AbiFPFfO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 01:35:14 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C755A08B
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:13 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FN9uIG014684
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=xgXhoth0GVJyC/K0gfma2HOZ6oMCsWh2iXr8xxvryvI=;
 b=J/6rnyb+OPnusWTd6G+4Abj0bREnXIjEy9M8HHefeAGD0R8irgmT9qMiWRSTGCZqMvC2
 weC3sroyit96kaDT5xDxzAjGuh0K2yNUeHhxUeLkujU2zT1/8agP8u9rVXivlleWYyLX
 pM3aPIbP1sebnJCMrV/Cgrkx1oWqyW2iNQb7YSWKLOUHnMv2qkw0eltndtRhqvxRw2/u
 PvgDt62+LxLWhKjQfPlAEgxt5Vt/Eu6zanzEh7Eox847pOKclpBtxnZA52jiYtuMqNw6
 +5dVaOhlS3jEgxskBRnrjbvGFHqHMSfEm7XP1ZZm9UUmBsFsXp7FdqGLE2lTk/inDlNY Rw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3gqruu977u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:13 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 15 Jun
 2022 22:35:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 15 Jun 2022 22:35:11 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 977723F7073;
        Wed, 15 Jun 2022 22:35:11 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 02/11] qla2xxx: Add a new v2 dport diagnostic feature
Date:   Wed, 15 Jun 2022 22:34:59 -0700
Message-ID: <20220616053508.27186-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220616053508.27186-1-njavali@marvell.com>
References: <20220616053508.27186-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: xzRThcc-JhM6Z7XttMzLdz0wgwLd7s6r
X-Proofpoint-GUID: xzRThcc-JhM6Z7XttMzLdz0wgwLd7s6r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_02,2022-06-15_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bikash Hazarika <bhazarika@marvell.com>

FW requires minimum 72 bytes buffer size for
D_port result. Buffer size 1024 is mentioned in the
FW spec so buffer size is increased to 1024.
Re-write the logic to handle START/RESTART command from SDMAPI.

Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c  | 86 +++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_bsg.h  | 15 ++++++
 drivers/scsi/qla2xxx/qla_def.h  | 10 ++++
 drivers/scsi/qla2xxx/qla_gbl.h  |  4 ++
 drivers/scsi/qla2xxx/qla_init.c |  3 ++
 drivers/scsi/qla2xxx/qla_isr.c  |  3 ++
 drivers/scsi/qla2xxx/qla_mbx.c  | 48 ++++++++++++++++++
 7 files changed, 169 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index c2f00f076f79..606474ae4419 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2424,6 +2424,89 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_job)
 	return 0;
 }
 
+static int
+qla2x00_do_dport_diagnostics_v2(struct bsg_job *bsg_job)
+{
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
+	scsi_qla_host_t *vha = shost_priv(host);
+	int rval;
+	struct qla_dport_diag_v2 *dd;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	uint16_t options;
+
+	if (!IS_DPORT_CAPABLE(vha->hw))
+		return -EPERM;
+
+	dd = kzalloc(sizeof(*dd), GFP_KERNEL);
+	if (!dd)
+		return -ENOMEM;
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+			bsg_job->request_payload.sg_cnt, dd, sizeof(*dd));
+
+	options  = dd->options;
+
+	/*  Check dport Test in progress */
+	if (options == QLA_GET_DPORT_RESULT_V2 &&
+	    vha->dport_status & DPORT_DIAG_IN_PROGRESS) {
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+					EXT_STATUS_DPORT_DIAG_IN_PROCESS;
+		goto dportcomplete;
+	}
+
+	/*  Check chip reset in progress and start/restart requests arrive */
+	if (vha->dport_status & DPORT_DIAG_CHIP_RESET_IN_PROGRESS &&
+	    (options == QLA_START_DPORT_TEST_V2 ||
+	     options == QLA_RESTART_DPORT_TEST_V2)) {
+		vha->dport_status &= ~DPORT_DIAG_CHIP_RESET_IN_PROGRESS;
+	}
+
+	/*  Check chip reset in progress and get result request arrive */
+	if (vha->dport_status & DPORT_DIAG_CHIP_RESET_IN_PROGRESS &&
+	    options == QLA_GET_DPORT_RESULT_V2) {
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+					EXT_STATUS_DPORT_DIAG_NOT_RUNNING;
+		goto dportcomplete;
+	}
+
+	rval = qla26xx_dport_diagnostics_v2(vha, dd, mcp);
+
+	if (rval == QLA_SUCCESS) {
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+					EXT_STATUS_OK;
+		if (options == QLA_START_DPORT_TEST_V2 ||
+		    options == QLA_RESTART_DPORT_TEST_V2) {
+			dd->mbx1 = mcp->mb[0];
+			dd->mbx2 = mcp->mb[1];
+			vha->dport_status |=  DPORT_DIAG_IN_PROGRESS;
+		} else if (options == QLA_GET_DPORT_RESULT_V2) {
+			dd->mbx1 = vha->dport_data[1];
+			dd->mbx2 = vha->dport_data[2];
+		}
+	} else {
+		dd->mbx1 = mcp->mb[0];
+		dd->mbx2 = mcp->mb[1];
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+				EXT_STATUS_DPORT_DIAG_ERR;
+	}
+
+dportcomplete:
+	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+			    bsg_job->reply_payload.sg_cnt, dd, sizeof(*dd));
+
+	bsg_reply->reply_payload_rcv_len = sizeof(*dd);
+	bsg_job->reply_len = sizeof(*bsg_reply);
+	bsg_reply->result = DID_OK << 16;
+	bsg_job_done(bsg_job, bsg_reply->result,
+		     bsg_reply->reply_payload_rcv_len);
+
+	kfree(dd);
+
+	return 0;
+}
+
 static int
 qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
 {
@@ -2860,6 +2943,9 @@ qla2x00_process_vendor_specific(struct scsi_qla_host *vha, struct bsg_job *bsg_j
 	case QL_VND_DPORT_DIAGNOSTICS:
 		return qla2x00_do_dport_diagnostics(bsg_job);
 
+	case QL_VND_DPORT_DIAGNOSTICS_V2:
+		return qla2x00_do_dport_diagnostics_v2(bsg_job);
+
 	case QL_VND_EDIF_MGMT:
 		return qla_edif_app_mgmt(bsg_job);
 
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index 6d2b0a7436c1..bb64b9c5a74b 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -37,6 +37,7 @@
 #define QL_VND_GET_TGT_STATS		0x25
 #define QL_VND_MANAGE_HOST_PORT		0x26
 #define QL_VND_MBX_PASSTHRU		0x2B
+#define QL_VND_DPORT_DIAGNOSTICS_V2	0x2C
 
 /* BSG Vendor specific subcode returns */
 #define EXT_STATUS_OK			0
@@ -60,6 +61,9 @@
 #define EXT_STATUS_TIMEOUT		30
 #define EXT_STATUS_THREAD_FAILED	31
 #define EXT_STATUS_DATA_CMP_FAILED	32
+#define EXT_STATUS_DPORT_DIAG_ERR	40
+#define EXT_STATUS_DPORT_DIAG_IN_PROCESS	41
+#define EXT_STATUS_DPORT_DIAG_NOT_RUNNING	42
 
 /* BSG definations for interpreting CommandSent field */
 #define INT_DEF_LB_LOOPBACK_CMD         0
@@ -288,6 +292,17 @@ struct qla_dport_diag {
 	uint8_t  unused[62];
 } __packed;
 
+#define QLA_GET_DPORT_RESULT_V2		0  /* Get Result */
+#define QLA_RESTART_DPORT_TEST_V2	1  /* Restart test */
+#define QLA_START_DPORT_TEST_V2		2  /* Start test */
+struct qla_dport_diag_v2 {
+	uint16_t options;
+	uint16_t mbx1;
+	uint16_t mbx2;
+	uint8_t  unused[58];
+	uint8_t buf[1024]; /* Test Result */
+} __packed;
+
 /* D_Port options */
 #define QLA_DPORT_RESULT	0x0
 #define QLA_DPORT_START		0x2
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f064dcdbb975..5888362cf8d1 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1173,6 +1173,12 @@ static inline bool qla2xxx_is_valid_mbs(unsigned int mbs)
 
 /* ISP mailbox loopback echo diagnostic error code */
 #define MBS_LB_RESET	0x17
+
+/* AEN mailbox Port Diagnostics test */
+#define AEN_START_DIAG_TEST		0x0	/* start the diagnostics */
+#define AEN_DONE_DIAG_TEST_WITH_NOERR	0x1	/* Done with no errors */
+#define AEN_DONE_DIAG_TEST_WITH_ERR	0x2	/* Done with error.*/
+
 /*
  * Firmware options 1, 2, 3.
  */
@@ -5019,6 +5025,10 @@ typedef struct scsi_qla_host {
 	u64 short_link_down_cnt;
 	struct edif_dbell e_dbell;
 	struct pur_core pur_cinfo;
+
+#define DPORT_DIAG_IN_PROGRESS                 BIT_0
+#define DPORT_DIAG_CHIP_RESET_IN_PROGRESS      BIT_1
+	uint16_t dport_status;
 } scsi_qla_host_t;
 
 struct qla27xx_image_status {
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 08103efa170f..3674b35196b0 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -555,6 +555,10 @@ qla2x00_dump_mctp_data(scsi_qla_host_t *, dma_addr_t, uint32_t, uint32_t);
 extern int
 qla26xx_dport_diagnostics(scsi_qla_host_t *, void *, uint, uint);
 
+extern int
+qla26xx_dport_diagnostics_v2(scsi_qla_host_t *,
+			     struct qla_dport_diag_v2 *,  mbx_cmd_t *);
+
 int qla24xx_send_mb_cmd(struct scsi_qla_host *, mbx_cmd_t *);
 int qla24xx_gpdb_wait(struct scsi_qla_host *, fc_port_t *, u8);
 int qla24xx_gidlist_wait(struct scsi_qla_host *, void *, dma_addr_t,
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6070834104f6..e4db1c1f3f6b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7208,6 +7208,9 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 	if (vha->flags.online) {
 		qla2x00_abort_isp_cleanup(vha);
 
+		vha->dport_status |= DPORT_DIAG_CHIP_RESET_IN_PROGRESS;
+		vha->dport_status &= ~DPORT_DIAG_IN_PROGRESS;
+
 		if (vha->hw->flags.port_isolated)
 			return status;
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 9ca20eafe433..9af9b35edc27 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1761,6 +1761,9 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		break;
 
 	case MBA_DPORT_DIAGNOSTICS:
+		if ((mb[1] & 0xF) == AEN_DONE_DIAG_TEST_WITH_NOERR ||
+		    (mb[1] & 0xF) == AEN_DONE_DIAG_TEST_WITH_ERR)
+			vha->dport_status &= ~DPORT_DIAG_IN_PROGRESS;
 		ql_dbg(ql_dbg_async, vha, 0x5052,
 		    "D-Port Diagnostics: %04x %04x %04x %04x\n",
 		    mb[0], mb[1], mb[2], mb[3]);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 892caf2475df..16a736a7130d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -6471,6 +6471,54 @@ qla26xx_dport_diagnostics(scsi_qla_host_t *vha,
 	return rval;
 }
 
+int
+qla26xx_dport_diagnostics_v2(scsi_qla_host_t *vha,
+			     struct qla_dport_diag_v2 *dd,  mbx_cmd_t *mcp)
+{
+	int rval;
+	dma_addr_t dd_dma;
+	uint size = sizeof(dd->buf);
+	uint16_t options = dd->options;
+
+	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x119f,
+	       "Entered %s.\n", __func__);
+
+	dd_dma = dma_map_single(&vha->hw->pdev->dev,
+				dd->buf, size, DMA_FROM_DEVICE);
+	if (dma_mapping_error(&vha->hw->pdev->dev, dd_dma)) {
+		ql_log(ql_log_warn, vha, 0x1194,
+		       "Failed to map dma buffer.\n");
+		return QLA_MEMORY_ALLOC_FAILED;
+	}
+
+	memset(dd->buf, 0, size);
+
+	mcp->mb[0] = MBC_DPORT_DIAGNOSTICS;
+	mcp->mb[1] = options;
+	mcp->mb[2] = MSW(LSD(dd_dma));
+	mcp->mb[3] = LSW(LSD(dd_dma));
+	mcp->mb[6] = MSW(MSD(dd_dma));
+	mcp->mb[7] = LSW(MSD(dd_dma));
+	mcp->mb[8] = size;
+	mcp->out_mb = MBX_8 | MBX_7 | MBX_6 | MBX_3 | MBX_2 | MBX_1 | MBX_0;
+	mcp->in_mb = MBX_3 | MBX_2 | MBX_1 | MBX_0;
+	mcp->buf_size = size;
+	mcp->flags = MBX_DMA_IN;
+	mcp->tov = MBX_TOV_SECONDS * 4;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0x1195, "Failed=%x.\n", rval);
+	} else {
+		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1196,
+		       "Done %s.\n", __func__);
+	}
+
+	dma_unmap_single(&vha->hw->pdev->dev, dd_dma, size, DMA_FROM_DEVICE);
+
+	return rval;
+}
+
 static void qla2x00_async_mb_sp_done(srb_t *sp, int res)
 {
 	sp->u.iocb_cmd.u.mbx.rc = res;
-- 
2.19.0.rc0

