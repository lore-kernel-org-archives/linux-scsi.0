Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BBFC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 10:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A0D2225AC
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 10:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbhAEKlb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 05:41:31 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39276 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729244AbhAEKlb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 05:41:31 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 105AeUMc014314
        for <linux-scsi@vger.kernel.org>; Tue, 5 Jan 2021 02:40:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=bGHnXvU74vwF9VvmGzpA/pTeEAD/sQQlmIwzsPZ5SH0=;
 b=azVZZQjctsTKtzuu0mC5RNGZkdqIZyshwWTlo52k5gLkq01htjcRAfkGGX1Gm7uLHxcx
 hijU10UF9KeoV5BGUiEtfF1ICXJ8s5CzBJeDxDiW0lTe5uJfmH45Wv/oYqyPbH9qYMy8
 jtZ0eSxMTEBJHZzPYgUBAiOXRgrz5cxMf1OFZTP5N4a0EKzrsWEi/7ITw64K80nTbdH0
 kf+SgYcldAqBFgGSfLcOsaaTnS5W/3M9O1eqDGmqRY5Vd3+KdDceRp2EDfr87Yf8KiKi
 QVogeQCiN/uXAxAzuHRXSfTee0mEYImh2EKEy4gxkbaZrw9bpP31ewcQ1gr7XFoqlJwS BA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 35tq2ue6x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jan 2021 02:40:50 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 5 Jan
 2021 02:40:49 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 5 Jan
 2021 02:40:48 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 5 Jan 2021 02:40:48 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 527423F7048;
        Tue,  5 Jan 2021 02:40:48 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 105Aemmd025210;
        Tue, 5 Jan 2021 02:40:48 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 105AemJH025201;
        Tue, 5 Jan 2021 02:40:48 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 4/7] qla2xxx: Wait for ABTS response on I/O timeouts for NVMe
Date:   Tue, 5 Jan 2021 02:38:44 -0800
Message-ID: <20210105103847.25041-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210105103847.25041-1-njavali@marvell.com>
References: <20210105103847.25041-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_01:2021-01-05,2021-01-05 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bikash Hazarika <bhazarika@marvell.com>

FW needs to wait for an ABTS response before completing the I/O

Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  | 12 +++++
 drivers/scsi/qla2xxx/qla_fw.h   | 27 ++++++++--
 drivers/scsi/qla2xxx/qla_gbl.h  |  6 +++
 drivers/scsi/qla2xxx/qla_init.c |  4 ++
 drivers/scsi/qla2xxx/qla_iocb.c |  6 +++
 drivers/scsi/qla2xxx/qla_isr.c  |  8 +++
 drivers/scsi/qla2xxx/qla_mbx.c  |  6 +++
 drivers/scsi/qla2xxx/qla_nvme.c | 90 ++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_os.c   |  5 ++
 9 files changed, 159 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f2f1b0231033..17da6b436e74 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2101,6 +2101,7 @@ typedef struct {
 #define CS_COMPLETE_CHKCOND	0x30	/* Error? */
 #define CS_IOCB_ERROR		0x31	/* Generic error for IOCB request
 					   failure */
+#define CS_REJECT_RECEIVED	0x4E	/* Reject received */
 #define CS_BAD_PAYLOAD		0x80	/* Driver defined */
 #define CS_UNKNOWN		0x81	/* Driver defined */
 #define CS_RETRY		0x82	/* Driver defined */
@@ -4150,6 +4151,17 @@ struct qla_hw_data {
 /* Bit 21 of fw_attributes decides the MCTP capabilities */
 #define IS_MCTP_CAPABLE(ha)	(IS_QLA2031(ha) && \
 				((ha)->fw_attributes_ext[0] & BIT_0))
+#define QLA_ABTS_FW_ENABLED(_ha)       ((_ha)->fw_attributes_ext[0] & BIT_14)
+#define QLA_SRB_NVME_LS(_sp) ((_sp)->type == SRB_NVME_LS)
+#define QLA_SRB_NVME_CMD(_sp) ((_sp)->type == SRB_NVME_CMD)
+#define QLA_NVME_IOS(_sp) (QLA_SRB_NVME_CMD(_sp) || QLA_SRB_NVME_LS(_sp))
+#define QLA_LS_ABTS_WAIT_ENABLED(_sp) \
+	(QLA_SRB_NVME_LS(_sp) && QLA_ABTS_FW_ENABLED(_sp->fcport->vha->hw))
+#define QLA_CMD_ABTS_WAIT_ENABLED(_sp) \
+	(QLA_SRB_NVME_CMD(_sp) && QLA_ABTS_FW_ENABLED(_sp->fcport->vha->hw))
+#define QLA_ABTS_WAIT_ENABLED(_sp) \
+	(QLA_NVME_IOS(_sp) && QLA_ABTS_FW_ENABLED(_sp->fcport->vha->hw))
+
 #define IS_PI_UNINIT_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha))
 #define IS_PI_IPGUARD_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha))
 #define IS_PI_DIFB_DIX0_CAPABLE(ha)	(0)
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 12b689e32883..49df418030e4 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -982,11 +982,18 @@ struct abort_entry_24xx {
 
 	uint32_t handle;		/* System handle. */
 
-	__le16	nport_handle;		/* N_PORT handle. */
-					/* or Completion status. */
+	union {
+		__le16 nport_handle;            /* N_PORT handle. */
+		__le16 comp_status;             /* Completion status. */
+	};
 
 	__le16	options;		/* Options. */
 #define AOF_NO_ABTS		BIT_0	/* Do not send any ABTS. */
+#define AOF_NO_RRQ		BIT_1   /* Do not send RRQ. */
+#define AOF_ABTS_TIMEOUT	BIT_2   /* Disable logout on ABTS timeout. */
+#define AOF_ABTS_RTY_CNT	BIT_3   /* Use driver specified retry count. */
+#define AOF_RSP_TIMEOUT		BIT_4   /* Use specified response timeout. */
+
 
 	uint32_t handle_to_abort;	/* System handle to abort. */
 
@@ -995,8 +1002,20 @@ struct abort_entry_24xx {
 
 	uint8_t port_id[3];		/* PortID of destination port. */
 	uint8_t vp_index;
-
-	uint8_t reserved_2[12];
+	u8	reserved_2[4];
+	union {
+		struct {
+			__le16 abts_rty_cnt;
+			__le16 rsp_timeout;
+		} drv;
+		struct {
+			u8	ba_rjt_vendorUnique;
+			u8	ba_rjt_reasonCodeExpl;
+			u8	ba_rjt_reasonCode;
+			u8	reserved_3;
+		} fw;
+	};
+	u8	reserved_4[4];
 };
 
 #define ABTS_RCV_TYPE		0x54
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 708f82311b83..6486f97d649e 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -177,6 +177,7 @@ extern int ql2xexlogins;
 extern int ql2xdifbundlinginternalbuffers;
 extern int ql2xfulldump_on_mpifail;
 extern int ql2xenforce_iocb_limit;
+extern int ql2xabts_wait_nvme;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
@@ -941,6 +942,11 @@ int qla2x00_set_data_rate(scsi_qla_host_t *vha, uint16_t mode);
 extern void qla24xx_process_purex_list(struct purex_list *);
 extern void qla2x00_dfs_create_rport(scsi_qla_host_t *vha, struct fc_port *fp);
 extern void qla2x00_dfs_remove_rport(scsi_qla_host_t *vha, struct fc_port *fp);
+extern void qla_wait_nvme_release_cmd_kref(srb_t *sp);
+extern void qla_nvme_abort_set_option
+		(struct abort_entry_24xx *abt, srb_t *sp);
+extern void qla_nvme_abort_process_comp_status
+		(struct abort_entry_24xx *abt, srb_t *sp);
 
 /* nvme.c */
 void qla_nvme_unregister_remote_port(struct fc_port *fcport);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 221369cdf71f..a6ab2629b7cf 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -136,6 +136,10 @@ static void qla24xx_abort_iocb_timeout(void *data)
 static void qla24xx_abort_sp_done(srb_t *sp, int res)
 {
 	struct srb_iocb *abt = &sp->u.iocb_cmd;
+	srb_t *orig_sp = sp->cmd_sp;
+
+	if (orig_sp)
+		qla_wait_nvme_release_cmd_kref(orig_sp);
 
 	del_timer(&sp->u.iocb_cmd.timer);
 	if (sp->flags & SRB_WAKEUP_ON_COMP)
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index c532c74ca1ab..e27359b294d3 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3571,6 +3571,7 @@ qla24xx_abort_iocb(srb_t *sp, struct abort_entry_24xx *abt_iocb)
 	struct srb_iocb *aio = &sp->u.iocb_cmd;
 	scsi_qla_host_t *vha = sp->vha;
 	struct req_que *req = sp->qpair->req;
+	srb_t *orig_sp = sp->cmd_sp;
 
 	memset(abt_iocb, 0, sizeof(struct abort_entry_24xx));
 	abt_iocb->entry_type = ABORT_IOCB_TYPE;
@@ -3587,6 +3588,11 @@ qla24xx_abort_iocb(srb_t *sp, struct abort_entry_24xx *abt_iocb)
 			    aio->u.abt.cmd_hndl);
 	abt_iocb->vp_index = vha->vp_idx;
 	abt_iocb->req_que_no = aio->u.abt.req_que_no;
+
+	/* need to pass original sp */
+	if (orig_sp)
+		qla_nvme_abort_set_option(abt_iocb, orig_sp);
+
 	/* Send the command to the firmware */
 	wmb();
 }
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index bfc8bbaeea46..a4a52a2d724e 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -5,6 +5,7 @@
  */
 #include "qla_def.h"
 #include "qla_target.h"
+#include "qla_gbl.h"
 
 #include <linux/delay.h>
 #include <linux/slab.h>
@@ -3431,6 +3432,7 @@ qla24xx_abort_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 {
 	const char func[] = "ABT_IOCB";
 	srb_t *sp;
+	srb_t *orig_sp = NULL;
 	struct srb_iocb *abt;
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
@@ -3439,6 +3441,12 @@ qla24xx_abort_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 
 	abt = &sp->u.iocb_cmd;
 	abt->u.abt.comp_status = pkt->nport_handle;
+	abt->u.abt.comp_status = le16_to_cpu(pkt->comp_status);
+	orig_sp = sp->cmd_sp;
+	/* Need to pass original sp */
+	if (orig_sp)
+		qla_nvme_abort_process_comp_status(pkt, orig_sp);
+
 	sp->done(sp, 0);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index f438cdedca23..629af6fe8c55 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3243,6 +3243,8 @@ qla24xx_abort_command(srb_t *sp)
 	abt->vp_index = fcport->vha->vp_idx;
 
 	abt->req_que_no = cpu_to_le16(req->id);
+	/* Need to pass original sp */
+	qla_nvme_abort_set_option(abt, sp);
 
 	rval = qla2x00_issue_iocb(vha, abt, abt_dma, 0);
 	if (rval != QLA_SUCCESS) {
@@ -3265,6 +3267,10 @@ qla24xx_abort_command(srb_t *sp)
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1091,
 		    "Done %s.\n", __func__);
 	}
+	if (rval == QLA_SUCCESS)
+		qla_nvme_abort_process_comp_status(abt, sp);
+
+	qla_wait_nvme_release_cmd_kref(sp);
 
 	dma_pool_free(ha->s_dma_pool, abt, abt_dma);
 
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index eab559b3b257..1cdb7352d6db 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -245,6 +245,12 @@ static void qla_nvme_abort_work(struct work_struct *work)
 	    __func__, (rval != QLA_SUCCESS) ? "Failed to abort" : "Aborted",
 	    sp, sp->handle, fcport, rval);
 
+	/* Returned before decreasing kref so that I/O requests
+	 * are waited until ABTS complete. This kref is decreased
+	 * at qla24xx_abort_sp_done function.
+	 */
+	if (ql2xabts_wait_nvme && QLA_ABTS_WAIT_ENABLED(sp))
+		return;
 out:
 	/* kref_get was done before work was schedule. */
 	kref_put(&sp->cmd_kref, sp->put_fn);
@@ -284,7 +290,6 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
 	struct qla_hw_data *ha;
 	srb_t           *sp;
 
-
 	if (!fcport || (fcport && fcport->deleted))
 		return rval;
 
@@ -591,6 +596,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 	sp->put_fn = qla_nvme_release_fcp_cmd_kref;
 	sp->qpair = qpair;
 	sp->vha = vha;
+	sp->cmd_sp = sp;
 	nvme = &sp->u.iocb_cmd;
 	nvme->u.nvme.desc = fd;
 
@@ -744,3 +750,85 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 
 	return ret;
 }
+
+void qla_nvme_abort_set_option(struct abort_entry_24xx *abt, srb_t *orig_sp)
+{
+	struct qla_hw_data *ha;
+
+	if (!(ql2xabts_wait_nvme && QLA_ABTS_WAIT_ENABLED(orig_sp)))
+		return;
+
+	ha = orig_sp->fcport->vha->hw;
+
+	WARN_ON_ONCE(abt->options & cpu_to_le16(BIT_0));
+	/* Use Driver Specified Retry Count */
+	abt->options |= cpu_to_le16(AOF_ABTS_RTY_CNT);
+	abt->drv.abts_rty_cnt = cpu_to_le16(2);
+	/* Use specified response timeout */
+	abt->options |= cpu_to_le16(AOF_RSP_TIMEOUT);
+	/* set it to 2 * r_a_tov in secs */
+	abt->drv.rsp_timeout = cpu_to_le16(2 * (ha->r_a_tov / 10));
+}
+
+void qla_nvme_abort_process_comp_status(struct abort_entry_24xx *abt, srb_t *orig_sp)
+{
+	u16	comp_status;
+	struct scsi_qla_host *vha;
+
+	if (!(ql2xabts_wait_nvme && QLA_ABTS_WAIT_ENABLED(orig_sp)))
+		return;
+
+	vha = orig_sp->fcport->vha;
+
+	comp_status = le16_to_cpu(abt->comp_status);
+	switch (comp_status) {
+	case CS_RESET:		/* reset event aborted */
+	case CS_ABORTED:	/* IOCB was cleaned */
+	/* N_Port handle is not currently logged in */
+	case CS_TIMEOUT:
+	/* N_Port handle was logged out while waiting for ABTS to complete */
+	case CS_PORT_UNAVAILABLE:
+	/* Firmware found that the port name changed */
+	case CS_PORT_LOGGED_OUT:
+	/* BA_RJT was received for the ABTS */
+	case CS_PORT_CONFIG_CHG:
+		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf09d,
+		       "Abort I/O IOCB completed with error, comp_status=%x\n",
+		comp_status);
+		break;
+
+	/* BA_RJT was received for the ABTS */
+	case CS_REJECT_RECEIVED:
+		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf09e,
+		       "BA_RJT was received for the ABTS rjt_vendorUnique = %u",
+			abt->fw.ba_rjt_vendorUnique);
+		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf09e,
+		       "ba_rjt_reasonCodeExpl = %u, ba_rjt_reasonCode = %u\n",
+		       abt->fw.ba_rjt_reasonCodeExpl, abt->fw.ba_rjt_reasonCode);
+		break;
+
+	case CS_COMPLETE:
+		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf09f,
+		       "IOCB request is completed successfully comp_status=%x\n",
+		comp_status);
+		break;
+
+	case CS_IOCB_ERROR:
+		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf0a0,
+		       "IOCB request is failed, comp_status=%x\n", comp_status);
+		break;
+
+	default:
+		ql_dbg(ql_dbg_async + ql_dbg_mbx, vha, 0xf0a1,
+		       "Invalid Abort IO IOCB Completion Status %x\n",
+		comp_status);
+		break;
+	}
+}
+
+inline void qla_wait_nvme_release_cmd_kref(srb_t *orig_sp)
+{
+	if (!(ql2xabts_wait_nvme && QLA_ABTS_WAIT_ENABLED(orig_sp)))
+		return;
+	kref_put(&orig_sp->cmd_kref, orig_sp->put_fn);
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a760cb38e487..3cfd83fce9c5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -327,6 +327,11 @@ MODULE_PARM_DESC(ql2xrdpenable,
 		"Enables RDP responses. "
 		"0 - no RDP responses (default). "
 		"1 - provide RDP responses.");
+int ql2xabts_wait_nvme = 1;
+module_param(ql2xabts_wait_nvme, int, 0444);
+MODULE_PARM_DESC(ql2xabts_wait_nvme,
+		 "To wait for ABTS response on I/O timeouts for NVMe. (default: 1)");
+
 
 static void qla2x00_clear_drv_active(struct qla_hw_data *);
 static void qla2x00_free_device(scsi_qla_host_t *);
-- 
2.19.0.rc0

