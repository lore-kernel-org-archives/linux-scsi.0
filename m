Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7244FC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 08:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344972AbiCHIWQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 03:22:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344957AbiCHIWI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 03:22:08 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C133F331
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 00:21:09 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22881NIB019263
        for <linux-scsi@vger.kernel.org>; Tue, 8 Mar 2022 00:21:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=zB8tHO0GiroW/dy8x4/vBvmoO+w2NjjfZSN9Ezxemuk=;
 b=Cq3u7hb9kkZlR+hFfExpjVEJ8W6mC5G/DfzqEKtAk2ZzOv3ji+ejssx8XUL506k6qdYw
 Ho7vKzqhYCXty/IbFJCuHz4j88pLRjeaSoWv7CwLVcBvJ6WLe5vwO2U3Bsx9cLVkbrvc
 ncPTSc+m+lUByO0FSNaTg4NOopGW9JYkbNQ7f0sZFtT+Ddb9PeJJv/cZaN5MCc7eIgb9
 0kdBSqDHXUL9Vlt1z1melej+75sziipKOjN8lWW0rcJILD6ZfK7J+F1UJXk8pLbLaY4D
 MCgAADPy555ccTZ010KjGcDqpgmnZ79A1jp+aDfVg4nhH1ozcldyqYd7Ptfe6+kt8Aub jQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ep38p838b-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 08 Mar 2022 00:21:08 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Mar
 2022 00:21:05 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Mar 2022 00:21:05 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C5EBF5B6923;
        Tue,  8 Mar 2022 00:21:05 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 2288L5bf009825;
        Tue, 8 Mar 2022 00:21:05 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 2288L5Cb009824;
        Tue, 8 Mar 2022 00:21:05 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 04/13] qla2xxx: Fix missed DMA unmap for NVME ls requests
Date:   Tue, 8 Mar 2022 00:20:39 -0800
Message-ID: <20220308082048.9774-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220308082048.9774-1-njavali@marvell.com>
References: <20220308082048.9774-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: Pvp2kC2i2qPrSd8iW0T7Jr7X5E3A5A_G
X-Proofpoint-ORIG-GUID: Pvp2kC2i2qPrSd8iW0T7Jr7X5E3A5A_G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_03,2022-03-04_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

At NVME ELS request time, request structure is DMA mapped
and never unmapped. Fix this by calling the unmap on
ELS completion.

Cc: stable@vger.kernel.org
Fixes: e84067d74301 ("scsi: qla2xxx: Add FC-NVMe F/W initialization and transport registration")
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 3bf5cbd754a7..794a95b2e3b4 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -175,6 +175,18 @@ static void qla_nvme_release_fcp_cmd_kref(struct kref *kref)
 	qla2xxx_rel_qpair_sp(sp->qpair, sp);
 }
 
+static void qla_nvme_ls_unmap(struct srb *sp, struct nvmefc_ls_req *fd)
+{
+	if (sp->flags & SRB_DMA_VALID) {
+		struct srb_iocb *nvme = &sp->u.iocb_cmd;
+		struct qla_hw_data *ha = sp->fcport->vha->hw;
+
+		dma_unmap_single(&ha->pdev->dev, nvme->u.nvme.cmd_dma,
+				 fd->rqstlen, DMA_TO_DEVICE);
+		sp->flags &= ~SRB_DMA_VALID;
+	}
+}
+
 static void qla_nvme_release_ls_cmd_kref(struct kref *kref)
 {
 	struct srb *sp = container_of(kref, struct srb, cmd_kref);
@@ -191,6 +203,8 @@ static void qla_nvme_release_ls_cmd_kref(struct kref *kref)
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
 	fd = priv->fd;
+
+	qla_nvme_ls_unmap(sp, fd);
 	fd->done(fd, priv->comp_status);
 out:
 	qla2x00_rel_sp(sp);
@@ -361,6 +375,8 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
 	dma_sync_single_for_device(&ha->pdev->dev, nvme->u.nvme.cmd_dma,
 	    fd->rqstlen, DMA_TO_DEVICE);
 
+	sp->flags |= SRB_DMA_VALID;
+
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x700e,
@@ -368,6 +384,7 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
 		wake_up(&sp->nvme_ls_waitq);
 		sp->priv = NULL;
 		priv->sp = NULL;
+		qla_nvme_ls_unmap(sp, fd);
 		qla2x00_rel_sp(sp);
 		return rval;
 	}
-- 
2.19.0.rc0

