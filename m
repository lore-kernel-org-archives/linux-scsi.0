Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B7AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 16:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 190D461157
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 16:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352338AbhIHQtA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 12:49:00 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53684 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352281AbhIHQs4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 12:48:56 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1889r43x000993;
        Wed, 8 Sep 2021 09:47:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=b7Ke4B96jnYoF7BMtFZe19wD0pmV9AeTaLXIEZTyQA4=;
 b=LIEyNiYyT+p0Bzj4wL4qkgeGKOhNxPSH+HEito22vMJ9tHWvw8dSGEwxYmWqz4O3TIgz
 NCRZz5nZl6yBhhJ/3R7RrD+/ARjxMiQscKMaoP6O9CdnFTG0NOCMmuYm/wzaQLi8gimn
 YZiKAGKa94kEnbejlpblGdnvQo1ZgM9+wKGC4vrCFW3HPhP2Idjnxayw7n39eI1SaJvx
 9jdP8fj8gpthNjN3jYxxFnaf1qk2Ftb6+zNSU1HLq9GAIr9aMyk20RDrAjFjXkJEN4Vy
 jVFAkRdahcAsd1nJyb28bwfUGFM4nTrngoJf6x074HTyJZnPe02opznwl1hKyjP8b0tD Ug== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3axtxc1kh3-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 09:47:41 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Sep
 2021 09:47:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 8 Sep 2021 09:47:39 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B2CD53F70A9;
        Wed,  8 Sep 2021 09:47:38 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 188GlcDM019315;
        Wed, 8 Sep 2021 09:47:38 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 188Glc7T019314;
        Wed, 8 Sep 2021 09:47:38 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <djeffery@redhat.com>,
        <loberman@redhat.com>
Subject: [PATCH v2 08/10] qla2xxx: Move heart beat handling from dpc thread to workqueue
Date:   Wed, 8 Sep 2021 09:46:20 -0700
Message-ID: <20210908164622.19240-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210908164622.19240-1-njavali@marvell.com>
References: <20210908164622.19240-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Q56rP7FTpPY0E_mJp2DTf4_FbvgPIxN2
X-Proofpoint-GUID: Q56rP7FTpPY0E_mJp2DTf4_FbvgPIxN2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-08_06,2021-09-07_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Manish Rangankar <mrangankar@marvell.com>

DPC thread gets restricted due to a no-op mailbox, which is a blocking call
and has a high execution frequency. To free up the DPC thread we move no-op
handling to the workqueue. Also, modified qla_do_hb to send no-op MBC if
we don’t have any active interrupts, but there are still IOs outstanding
with firmware.

Fixes: d94d8158e184 ("scsi: qla2xxx: Add heartbeat check")
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  4 +-
 drivers/scsi/qla2xxx/qla_init.c |  2 +
 drivers/scsi/qla2xxx/qla_os.c   | 78 +++++++++++++++------------------
 3 files changed, 40 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index be2eb75ee1a3..8924eeb9367d 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3750,6 +3750,7 @@ struct qla_qpair {
 	struct qla_fw_resources fwres ____cacheline_aligned;
 	u32	cmd_cnt;
 	u32	cmd_completion_cnt;
+	u32	prev_completion_cnt;
 };
 
 /* Place holder for FW buffer parameters */
@@ -4607,6 +4608,7 @@ struct qla_hw_data {
 	struct qla_chip_state_84xx *cs84xx;
 	struct isp_operations *isp_ops;
 	struct workqueue_struct *wq;
+	struct work_struct heartbeat_work;
 	struct qlfc_fw fw_buf;
 
 	/* FCP_CMND priority support */
@@ -4708,7 +4710,6 @@ struct qla_hw_data {
 
 	struct qla_hw_data_stat stat;
 	pci_error_state_t pci_error_state;
-	u64 prev_cmd_cnt;
 	struct dma_pool *purex_dma_pool;
 	struct btree_head32 host_map;
 
@@ -4854,7 +4855,6 @@ typedef struct scsi_qla_host {
 #define SET_ZIO_THRESHOLD_NEEDED 32
 #define ISP_ABORT_TO_ROM	33
 #define VPORT_DELETE		34
-#define HEARTBEAT_CHK		38
 
 #define PROCESS_PUREX_IOCB	63
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c6b3d0e7489e..a9a4243cb15a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7025,12 +7025,14 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 	ha->chip_reset++;
 	ha->base_qpair->chip_reset = ha->chip_reset;
 	ha->base_qpair->cmd_cnt = ha->base_qpair->cmd_completion_cnt = 0;
+	ha->base_qpair->prev_completion_cnt = 0;
 	for (i = 0; i < ha->max_qpairs; i++) {
 		if (ha->queue_pair_map[i]) {
 			ha->queue_pair_map[i]->chip_reset =
 				ha->base_qpair->chip_reset;
 			ha->queue_pair_map[i]->cmd_cnt =
 			    ha->queue_pair_map[i]->cmd_completion_cnt = 0;
+			ha->base_qpair->prev_completion_cnt = 0;
 		}
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a1e861ecfc01..0c446438dcd3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2794,6 +2794,16 @@ qla2xxx_scan_finished(struct Scsi_Host *shost, unsigned long time)
 	return atomic_read(&vha->loop_state) == LOOP_READY;
 }
 
+static void qla_heartbeat_work_fn(struct work_struct *work)
+{
+	struct qla_hw_data *ha = container_of(work,
+		struct qla_hw_data, heartbeat_work);
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
+
+	if (!ha->flags.mbox_busy && base_vha->flags.init_done)
+		qla_no_op_mb(base_vha);
+}
+
 static void qla2x00_iocb_work_fn(struct work_struct *work)
 {
 	struct scsi_qla_host *vha = container_of(work,
@@ -3232,6 +3242,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    host->transportt, sht->vendor_id);
 
 	INIT_WORK(&base_vha->iocb_work, qla2x00_iocb_work_fn);
+	INIT_WORK(&ha->heartbeat_work, qla_heartbeat_work_fn);
 
 	/* Set up the irqs */
 	ret = qla2x00_request_irqs(ha, rsp);
@@ -7118,17 +7129,6 @@ qla2x00_do_dpc(void *data)
 			qla2x00_lip_reset(base_vha);
 		}
 
-		if (test_bit(HEARTBEAT_CHK, &base_vha->dpc_flags)) {
-			/*
-			 * if there is a mb in progress then that's
-			 * enough of a check to see if fw is still ticking.
-			 */
-			if (!ha->flags.mbox_busy && base_vha->flags.init_done)
-				qla_no_op_mb(base_vha);
-
-			clear_bit(HEARTBEAT_CHK, &base_vha->dpc_flags);
-		}
-
 		ha->dpc_active = 0;
 end_loop:
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -7187,57 +7187,51 @@ qla2x00_rst_aen(scsi_qla_host_t *vha)
 
 static bool qla_do_heartbeat(struct scsi_qla_host *vha)
 {
-	u64 cmd_cnt, prev_cmd_cnt;
-	bool do_hb = false;
 	struct qla_hw_data *ha = vha->hw;
-	int i;
+	u32 cmpl_cnt;
+	u16 i;
+	bool do_heartbeat = false;
 
-	/* if cmds are still pending down in fw, then do hb */
-	if (ha->base_qpair->cmd_cnt != ha->base_qpair->cmd_completion_cnt) {
-		do_hb = true;
+	/*
+	 * Allow do_heartbeat only if we don’t have any active interrupts,
+	 * but there are still IOs outstanding with firmware.
+	 */
+	cmpl_cnt = ha->base_qpair->cmd_completion_cnt;
+	if (cmpl_cnt == ha->base_qpair->prev_completion_cnt &&
+	    cmpl_cnt != ha->base_qpair->cmd_cnt) {
+		do_heartbeat = true;
 		goto skip;
 	}
+	ha->base_qpair->prev_completion_cnt = cmpl_cnt;
 
 	for (i = 0; i < ha->max_qpairs; i++) {
-		if (ha->queue_pair_map[i] &&
-		    ha->queue_pair_map[i]->cmd_cnt !=
-		    ha->queue_pair_map[i]->cmd_completion_cnt) {
-			do_hb = true;
-			break;
+		if (ha->queue_pair_map[i]) {
+			cmpl_cnt = ha->queue_pair_map[i]->cmd_completion_cnt;
+			if (cmpl_cnt == ha->queue_pair_map[i]->prev_completion_cnt &&
+			    cmpl_cnt != ha->queue_pair_map[i]->cmd_cnt) {
+				do_heartbeat = true;
+				break;
+			}
+			ha->queue_pair_map[i]->prev_completion_cnt = cmpl_cnt;
 		}
 	}
 
 skip:
-	prev_cmd_cnt = ha->prev_cmd_cnt;
-	cmd_cnt = ha->base_qpair->cmd_cnt;
-	for (i = 0; i < ha->max_qpairs; i++) {
-		if (ha->queue_pair_map[i])
-			cmd_cnt += ha->queue_pair_map[i]->cmd_cnt;
-	}
-	ha->prev_cmd_cnt = cmd_cnt;
-
-	if (!do_hb && ((cmd_cnt - prev_cmd_cnt) > 50))
-		/*
-		 * IOs are completing before periodic hb check.
-		 * IOs seems to be running, do hb for sanity check.
-		 */
-		do_hb = true;
-
-	return do_hb;
+	return do_heartbeat;
 }
 
 static void qla_heart_beat(struct scsi_qla_host *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
+
 	if (vha->vp_idx)
 		return;
 
 	if (vha->hw->flags.eeh_busy || qla2x00_chip_is_down(vha))
 		return;
 
-	if (qla_do_heartbeat(vha)) {
-		set_bit(HEARTBEAT_CHK, &vha->dpc_flags);
-		qla2xxx_wake_dpc(vha);
-	}
+	if (qla_do_heartbeat(vha))
+		queue_work(ha->wq, &ha->heartbeat_work);
 }
 
 /**************************************************************************
-- 
2.19.0.rc0

