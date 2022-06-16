Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F325FC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 05:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358664AbiFPFf1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 01:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358594AbiFPFfQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 01:35:16 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE6B5932B
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:14 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FN9uII014684
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=monWPMQ3PAN+HrvMYQdymBKehNx0u2JHrnbxFsi1VZE=;
 b=fUT++5sDSzfVbj4xxrcW/TfYvGRs+1SRfMqW3f25Y5qvj6/KnJP8C1om+AsIJsLjEBnZ
 RWzh0C/utwZy3ikhhxINiECtOufcK387HSjZl8FHuL7dyd0vyCjsOlgJA9L7XamFSOpc
 oGt9aeSfJZlOwHKStoXYjlEgWnlD8yf3Yw4eeRJmH/5HAmNAv+rADgZnGcMGmFiWxgbX
 yO8bhmT/NEQE9VKvc1wiCFkGX++XoJqb7dMr9W9rw9Ph+GMs8JxgNC0dvjCTHHsQRlQw
 ILy3XBx1AhDafPFiTtKCkHRzQiHT3OrijjfM6omhS5KN/7NYvN5csHlTdA21WDrwwykU ZQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3gqruu977u-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 22:35:14 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 15 Jun
 2022 22:35:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 15 Jun 2022 22:35:12 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 24CC23F70B2;
        Wed, 15 Jun 2022 22:35:12 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 05/11] qla2xxx: Fix crash due to stale srb access around IO timeouts
Date:   Wed, 15 Jun 2022 22:35:02 -0700
Message-ID: <20220616053508.27186-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220616053508.27186-1-njavali@marvell.com>
References: <20220616053508.27186-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Wdz2BUc6SMMkWBZVacRiwYMTDl_jq19c
X-Proofpoint-GUID: Wdz2BUc6SMMkWBZVacRiwYMTDl_jq19c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_02,2022-06-15_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Ensure srb is returned during IO timeout error escalation. If that is
not possible fail the escalation path

Following crash stack was seen:

BUG: unable to handle kernel paging request at 0000002f56aa90f8
IP: qla_chk_edif_rx_sa_delete_pending+0x14/0x30 [qla2xxx]
Call Trace:
 ? qla2x00_status_entry+0x19f/0x1c50 [qla2xxx]
 ? qla2x00_start_sp+0x116/0x1170 [qla2xxx]
 ? dma_pool_alloc+0x1d6/0x210
 ? mempool_alloc+0x54/0x130
 ? qla24xx_process_response_queue+0x548/0x12b0 [qla2xxx]
 ? qla_do_work+0x2d/0x40 [qla2xxx]
 ? process_one_work+0x14c/0x390

Fixes: d74595278f4a ("scsi: qla2xxx: Add multiple queue pair functionality.)
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 43 +++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 210fb5c52421..1c7fb6484db2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1342,21 +1342,20 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 /*
  * Returns: QLA_SUCCESS or QLA_FUNCTION_FAILED.
  */
-int
-qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
-	uint64_t l, enum nexus_wait_type type)
+static int
+__qla2x00_eh_wait_for_pending_commands(struct qla_qpair *qpair, unsigned int t,
+				       uint64_t l, enum nexus_wait_type type)
 {
 	int cnt, match, status;
 	unsigned long flags;
-	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req;
+	scsi_qla_host_t *vha = qpair->vha;
+	struct req_que *req = qpair->req;
 	srb_t *sp;
 	struct scsi_cmnd *cmd;
 
 	status = QLA_SUCCESS;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	req = vha->req;
+	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	for (cnt = 1; status == QLA_SUCCESS &&
 		cnt < req->num_outstanding_cmds; cnt++) {
 		sp = req->outstanding_cmds[cnt];
@@ -1383,12 +1382,32 @@ qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
 		if (!match)
 			continue;
 
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 		status = qla2x00_eh_wait_on_command(cmd);
-		spin_lock_irqsave(&ha->hardware_lock, flags);
+		spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+
+	return status;
+}
+
+int
+qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
+				     uint64_t l, enum nexus_wait_type type)
+{
+	struct qla_qpair *qpair;
+	struct qla_hw_data *ha = vha->hw;
+	int i, status = QLA_SUCCESS;
 
+	status = __qla2x00_eh_wait_for_pending_commands(ha->base_qpair, t, l,
+							type);
+	for (i = 0; status == QLA_SUCCESS && i < ha->max_qpairs; i++) {
+		qpair = ha->queue_pair_map[i];
+		if (!qpair)
+			continue;
+		status = __qla2x00_eh_wait_for_pending_commands(qpair, t, l,
+								type);
+	}
 	return status;
 }
 
@@ -1425,7 +1444,7 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 		return err;
 
 	if (fcport->deleted)
-		return SUCCESS;
+		return FAILED;
 
 	ql_log(ql_log_info, vha, 0x8009,
 	    "DEVICE RESET ISSUED nexus=%ld:%d:%llu cmd=%p.\n", vha->host_no,
@@ -1493,7 +1512,7 @@ qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 		return err;
 
 	if (fcport->deleted)
-		return SUCCESS;
+		return FAILED;
 
 	ql_log(ql_log_info, vha, 0x8009,
 	    "TARGET RESET ISSUED nexus=%ld:%d cmd=%p.\n", vha->host_no,
-- 
2.19.0.rc0

