Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D38CC77B60
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 07:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345452AbjD1Hy0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 03:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjD1HyV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 03:54:21 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840FC26B3
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 00:53:50 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33S4FLoi032403
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 00:53:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=L1kI2lklFC5zMuBa38fYmSZf0J2mwnBVpxElhlQf3uo=;
 b=EPZRnxzOm2gTJVVEzWEKj8n7X5A2bVP9p7q1CfjluEz1h4WAP8U9mVkB/LiY5zYSzzi3
 sPEF5AY/1VppJkSFX7Jn3ERdJOVdcRkYcFafhPjhVr9sTVXyw5HaUbqtLND7/xtXwwXP
 h7iCzOBOVoVmV6WuFLKN5iMFNrdbqhxLqw8/0HW1A2t+UethpS8aWUKwkVxZsIvi2pDK
 G3yaHuC5c89EhjMEydlu7fjDGylsl06/ylJT5kU9Z3xecMepU496mvCC7raXW3vf2/Ki
 vbgiYjthdDqxRrwYEAVl+0rvSxHam4oovb8ba9FsI5zVDYhButxE+FXa3jTx1KwSZAjc qw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q85x60va8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 00:53:47 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 28 Apr
 2023 00:53:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 28 Apr 2023 00:53:46 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 6133D5B6936;
        Fri, 28 Apr 2023 00:53:45 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 3/7] qla2xxx: Fix task management cmd fail due to unavailable resource
Date:   Fri, 28 Apr 2023 00:53:35 -0700
Message-ID: <20230428075339.32551-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20230428075339.32551-1-njavali@marvell.com>
References: <20230428075339.32551-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 4MBJXrlOC76Lu44qHhloScJeclguKewR
X-Proofpoint-ORIG-GUID: 4MBJXrlOC76Lu44qHhloScJeclguKewR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-28_02,2023-04-27_01,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Task management command failed with status 2Ch which is
a result of too many task management commands sent
to the same target. Hence limit task management commands
to 8 per target.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202304271952.NKNmoFzv-lkp@intel.com/
Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
v2:
- Fix warning reported by kernel robot.

 drivers/scsi/qla2xxx/qla_def.h  |  3 ++
 drivers/scsi/qla2xxx/qla_init.c | 63 ++++++++++++++++++++++++++++++---
 2 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 0437e0150a50..0971150953a9 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2543,6 +2543,7 @@ enum rscn_addr_format {
 typedef struct fc_port {
 	struct list_head list;
 	struct scsi_qla_host *vha;
+	struct list_head tmf_pending;
 
 	unsigned int conf_compl_supported:1;
 	unsigned int deleted:2;
@@ -2563,6 +2564,8 @@ typedef struct fc_port {
 	unsigned int do_prli_nvme:1;
 
 	uint8_t nvme_flag;
+	uint8_t active_tmf;
+#define MAX_ACTIVE_TMF 8
 
 	uint8_t node_name[WWN_SIZE];
 	uint8_t port_name[WWN_SIZE];
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2402b1402e0d..17649cf9c39d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2149,6 +2149,54 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
 	return rval;
 }
 
+static void qla_put_tmf(fc_port_t *fcport)
+{
+	struct scsi_qla_host *vha = fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+	fcport->active_tmf--;
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+}
+
+static
+int qla_get_tmf(fc_port_t *fcport)
+{
+	struct scsi_qla_host *vha = fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags;
+	int rc = 0;
+	LIST_HEAD(tmf_elem);
+
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+	list_add_tail(&tmf_elem, &fcport->tmf_pending);
+
+	while (fcport->active_tmf >= MAX_ACTIVE_TMF) {
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+
+		msleep(1);
+
+		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+		if (fcport->deleted) {
+			rc = EIO;
+			break;
+		}
+		if (fcport->active_tmf < MAX_ACTIVE_TMF &&
+		    list_is_first(&tmf_elem, &fcport->tmf_pending))
+			break;
+	}
+
+	list_del(&tmf_elem);
+
+	if (!rc)
+		fcport->active_tmf++;
+
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+
+	return rc;
+}
+
 int
 qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint64_t lun,
 		     uint32_t tag)
@@ -2156,18 +2204,19 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint64_t lun,
 	struct scsi_qla_host *vha = fcport->vha;
 	struct qla_qpair *qpair;
 	struct tmf_arg a;
-	struct completion comp;
 	int i, rval;
 
-	init_completion(&comp);
 	a.vha = fcport->vha;
 	a.fcport = fcport;
 	a.lun = lun;
-
-	if (flags & (TCF_LUN_RESET|TCF_ABORT_TASK_SET| TCF_CLEAR_TASK_SET|TCF_CLEAR_ACA))
+	if (flags & (TCF_LUN_RESET|TCF_ABORT_TASK_SET| TCF_CLEAR_TASK_SET|TCF_CLEAR_ACA)) {
 		a.modifier = MK_SYNC_ID_LUN;
-	else
+
+		if (qla_get_tmf(fcport))
+			return QLA_FUNCTION_FAILED;
+	} else {
 		a.modifier = MK_SYNC_ID;
+	}
 
 	if (vha->hw->mqenable) {
 		for (i = 0; i < vha->hw->num_qpairs; i++) {
@@ -2186,6 +2235,9 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint64_t lun,
 	a.flags = flags;
 	rval = __qla2x00_async_tm_cmd(&a);
 
+	if (a.modifier == MK_SYNC_ID_LUN)
+		qla_put_tmf(fcport);
+
 	return rval;
 }
 
@@ -5400,6 +5452,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 	INIT_WORK(&fcport->reg_work, qla_register_fcport_fn);
 	INIT_LIST_HEAD(&fcport->gnl_entry);
 	INIT_LIST_HEAD(&fcport->list);
+	INIT_LIST_HEAD(&fcport->tmf_pending);
 
 	INIT_LIST_HEAD(&fcport->sess_cmd_list);
 	spin_lock_init(&fcport->sess_cmd_lock);
-- 
2.23.1

