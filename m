Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8C2C48BE8
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 09:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4F3C60230
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 09:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhFRJvu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 05:51:50 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63250 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229915AbhFRJvt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 05:51:49 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15I9l6Up009976
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jun 2021 02:49:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=1WnrflljSdl1gnKx8Uf1dEbkkfM3ScHgIkf1BNUrInc=;
 b=bpyaicN6Ne3jyGfA4Mvm7UlH0Mg0AcH5WxU66IV1QiMQL46LtQXTCXnH7r80QGsgeB5n
 oP8zJyDLlKNflkFErYEZoML9BJDh0wFUKcoV1b+snMkTbxTtV5wJIWIY5/CaNSv5laY9
 u+y4x2Z/9GVn27GdJfNOqiEXLNPfmsEkpSHtUcoLiJ1HHb7j/zlOEsx/2eIHU6kPNAN8
 u33/hj9iI0954s5rrOOVwZtaeeA7IRotq/u3AQO7WoOH5Xocvzao1MokIDHnSyRGF2e/
 wtMR+DS3iPYNnPNSVWkOVV5t/5q8PRPhndWNSmcoTgdXz8GZ7y/3j284h92L2R8DC/uF fQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 397udry29j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jun 2021 02:49:40 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 18 Jun
 2021 02:49:37 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 18 Jun 2021 02:49:37 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 7B77A5B6993;
        Fri, 18 Jun 2021 02:49:35 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 15I9nZso020420;
        Fri, 18 Jun 2021 02:49:35 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 15I9nZP9020411;
        Fri, 18 Jun 2021 02:49:35 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH] qla2xxx: add heartbeat check
Date:   Fri, 18 Jun 2021 02:49:11 -0700
Message-ID: <20210618094911.20377-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: dPVmCxI7BVzpt99yrucbXo3dQQTIEgKS
X-Proofpoint-GUID: dPVmCxI7BVzpt99yrucbXo3dQQTIEgKS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-18_04:2021-06-15,2021-06-18 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Use 'no-op' mailbox command to check and see if FW is still responsive.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  4 ++
 drivers/scsi/qla2xxx/qla_gbl.h  |  1 +
 drivers/scsi/qla2xxx/qla_init.c |  6 ++-
 drivers/scsi/qla2xxx/qla_iocb.c |  4 ++
 drivers/scsi/qla2xxx/qla_isr.c  |  4 ++
 drivers/scsi/qla2xxx/qla_mbx.c  | 27 +++++++++++++
 drivers/scsi/qla2xxx/qla_nvme.c |  4 ++
 drivers/scsi/qla2xxx/qla_os.c   | 68 +++++++++++++++++++++++++++++++++
 8 files changed, 117 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index def4d99f80e9..2f67ec1df3e6 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3660,6 +3660,8 @@ struct qla_qpair {
 	struct qla_tgt_counters tgt_counters;
 	uint16_t cpuid;
 	struct qla_fw_resources fwres ____cacheline_aligned;
+	u32	cmd_cnt;
+	u32	cmd_completion_cnt;
 };
 
 /* Place holder for FW buffer parameters */
@@ -4616,6 +4618,7 @@ struct qla_hw_data {
 
 	struct qla_hw_data_stat stat;
 	pci_error_state_t pci_error_state;
+	u64 prev_cmd_cnt;
 };
 
 struct active_regions {
@@ -4743,6 +4746,7 @@ typedef struct scsi_qla_host {
 #define SET_ZIO_THRESHOLD_NEEDED 32
 #define ISP_ABORT_TO_ROM	33
 #define VPORT_DELETE		34
+#define HEARTBEAT_CHK		38
 
 #define PROCESS_PUREX_IOCB	63
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index fae5cae6f0a8..70b7cda0a25a 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -551,6 +551,7 @@ extern int qla2xxx_read_remote_register(scsi_qla_host_t *, uint32_t,
     uint32_t *);
 extern int qla2xxx_write_remote_register(scsi_qla_host_t *, uint32_t,
     uint32_t);
+void qla_no_op_mb(struct scsi_qla_host *vha);
 
 /*
  * Global Function Prototypes in qla_isr.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index eb825318e3f5..f8f471157109 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -6870,10 +6870,14 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 	ha->flags.fw_init_done = 0;
 	ha->chip_reset++;
 	ha->base_qpair->chip_reset = ha->chip_reset;
+	ha->base_qpair->cmd_cnt = ha->base_qpair->cmd_completion_cnt = 0;
 	for (i = 0; i < ha->max_qpairs; i++) {
-		if (ha->queue_pair_map[i])
+		if (ha->queue_pair_map[i]) {
 			ha->queue_pair_map[i]->chip_reset =
 				ha->base_qpair->chip_reset;
+			ha->queue_pair_map[i]->cmd_cnt =
+			    ha->queue_pair_map[i]->cmd_completion_cnt = 0;
+		}
 	}
 
 	/* purge MBox commands */
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 38b5bdde2405..d0ee843f6b04 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1710,6 +1710,7 @@ qla24xx_start_scsi(srb_t *sp)
 	} else
 		req->ring_ptr++;
 
+	sp->qpair->cmd_cnt++;
 	sp->flags |= SRB_DMA_VALID;
 
 	/* Set chip new ring index. */
@@ -1912,6 +1913,7 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	} else
 		req->ring_ptr++;
 
+	sp->qpair->cmd_cnt++;
 	/* Set chip new ring index. */
 	wrt_reg_dword(req->req_q_in, req->ring_index);
 
@@ -2068,6 +2070,7 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	} else
 		req->ring_ptr++;
 
+	sp->qpair->cmd_cnt++;
 	sp->flags |= SRB_DMA_VALID;
 
 	/* Set chip new ring index. */
@@ -2284,6 +2287,7 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 	} else
 		req->ring_ptr++;
 
+	sp->qpair->cmd_cnt++;
 	/* Set chip new ring index. */
 	wrt_reg_dword(req->req_q_in, req->ring_index);
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6e8f737a4af3..8a8e355f4a89 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2322,6 +2322,8 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 
 	if (unlikely(iocb->u.nvme.aen_op))
 		atomic_dec(&sp->vha->hw->nvme_active_aen_cnt);
+	else
+		sp->qpair->cmd_completion_cnt++;
 
 	if (unlikely(comp_status != CS_COMPLETE))
 		logit = 1;
@@ -2976,6 +2978,8 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		return;
 	}
 
+	sp->qpair->cmd_completion_cnt++;
+
 	/* Fast path completion. */
 	if (comp_status == CS_COMPLETE && scsi_status == 0) {
 		qla2x00_process_completed_request(vha, req, handle);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0bcd8afdc0ff..9f3ad8aa649c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -6939,3 +6939,30 @@ ql26xx_led_config(scsi_qla_host_t *vha, uint16_t options, uint16_t *led)
 
 	return rval;
 }
+
+/**
+ * qla_no_op_mb(): This MB is used to check if FW is still alive and
+ * able to generate an interrupt. Otherwise, a timeout will trigger
+ * FW dump + reset
+ * @vha: host adapter pointer
+ * Return: None
+ */
+void qla_no_op_mb(struct scsi_qla_host *vha)
+{
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	int rval;
+
+	memset(&mc, 0, sizeof(mc));
+	mcp->mb[0] = 0; // noop cmd= 0
+	mcp->out_mb = MBX_0;
+	mcp->in_mb = MBX_0;
+	mcp->tov = 5;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval) {
+		ql_dbg(ql_dbg_async, vha, 0x7071,
+			"Failed %s %x\n", __func__, rval);
+	}
+}
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index e119f8b24e33..3e5c70a1d969 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -536,6 +536,10 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 		req->ring_ptr++;
 	}
 
+	/* ignore nvme async cmd due to long timeout */
+	if (!nvme->u.nvme.aen_op)
+		sp->qpair->cmd_cnt++;
+
 	/* Set chip new ring index. */
 	wrt_reg_dword(req->req_q_in, req->ring_index);
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4eab564ea6a0..aa8581e07156 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6969,6 +6969,17 @@ qla2x00_do_dpc(void *data)
 			qla2x00_lip_reset(base_vha);
 		}
 
+		if (test_bit(HEARTBEAT_CHK, &base_vha->dpc_flags)) {
+			/*
+			 * if there is a mb in progress then that's
+			 * enough of a check to see if fw is still ticking.
+			 */
+			if (!ha->flags.mbox_busy && base_vha->flags.init_done)
+				qla_no_op_mb(base_vha);
+
+			clear_bit(HEARTBEAT_CHK, &base_vha->dpc_flags);
+		}
+
 		ha->dpc_active = 0;
 end_loop:
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -7025,6 +7036,61 @@ qla2x00_rst_aen(scsi_qla_host_t *vha)
 	}
 }
 
+static bool qla_do_hb(struct scsi_qla_host *vha)
+{
+	u64 cmd_cnt, prev_cmd_cnt;
+	bool do_hb = false;
+	struct qla_hw_data *ha = vha->hw;
+	int i;
+
+	/* if cmds are still pending down in fw, then do hb */
+	if (ha->base_qpair->cmd_cnt != ha->base_qpair->cmd_completion_cnt) {
+		do_hb = true;
+		goto skip;
+	}
+
+	for (i = 0; i < ha->max_qpairs; i++) {
+		if (ha->queue_pair_map[i] &&
+		    ha->queue_pair_map[i]->cmd_cnt !=
+		    ha->queue_pair_map[i]->cmd_completion_cnt) {
+			do_hb = true;
+			break;
+		}
+	}
+
+skip:
+	prev_cmd_cnt = ha->prev_cmd_cnt;
+	cmd_cnt = ha->base_qpair->cmd_cnt;
+	for (i = 0; i < ha->max_qpairs; i++) {
+		if (ha->queue_pair_map[i])
+			cmd_cnt += ha->queue_pair_map[i]->cmd_cnt;
+	}
+	ha->prev_cmd_cnt = cmd_cnt;
+
+	if (!do_hb && ((cmd_cnt - prev_cmd_cnt) > 50))
+		/*
+		 * IOs are completing before periodic hb check.
+		 * IOs seems to be running, do hb for sanity check.
+		 */
+		do_hb = true;
+
+	return do_hb;
+}
+
+static void qla_heart_beat(struct scsi_qla_host *vha)
+{
+	if (vha->vp_idx)
+		return;
+
+	if (vha->hw->flags.eeh_busy || qla2x00_chip_is_down(vha))
+		return;
+
+	if (qla_do_hb(vha)) {
+		set_bit(HEARTBEAT_CHK, &vha->dpc_flags);
+		qla2xxx_wake_dpc(vha);
+	}
+}
+
 /**************************************************************************
 *   qla2x00_timer
 *
@@ -7243,6 +7309,8 @@ qla2x00_timer(struct timer_list *t)
 		qla2xxx_wake_dpc(vha);
 	}
 
+	qla_heart_beat(vha);
+
 	qla2x00_restart_timer(vha, WATCH_INTERVAL);
 }
 
-- 
2.19.0.rc0

