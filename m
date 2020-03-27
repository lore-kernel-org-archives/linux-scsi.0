Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36B6C2D0EF
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 16:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A00E120B80
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 16:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgC0Qrz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 12:47:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:41790 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727716AbgC0Qry (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 12:47:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E9056AED8;
        Fri, 27 Mar 2020 16:47:51 +0000 (UTC)
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arun Easi <aeasi@marvell.com>, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Daniel Wagner <dwagner@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 4/5] scsi: qla2xxx: avoid sending iocbs when firmware is stopped
Date:   Fri, 27 Mar 2020 17:47:10 +0100
Message-Id: <20200327164711.5358-5-mwilck@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200327164711.5358-1-mwilck@suse.com>
References: <20200327164711.5358-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Since commit 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip"),
it is possible that FC commands are scheduled after the adapter firmware
has been shut down. IO sent to the firmware in this situation hangs.
Avoid starting iocbs in this situation.

Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/qla2xxx/qla_inline.h |  3 +++
 drivers/scsi/qla2xxx/qla_iocb.c   | 23 +++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_nvme.c   |  3 +++
 3 files changed, 29 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 364b3db..f4352f1 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -322,6 +322,9 @@ qla_83xx_start_iocbs(struct qla_qpair *qpair)
 {
 	struct req_que *req = qpair->req;
 
+	if (!qpair->vha->hw->flags.fw_started)
+		return;
+
 	req->ring_index++;
 	if (req->ring_index == req->length) {
 		req->ring_index = 0;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 182bd68c..587ba35 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -459,6 +459,9 @@ qla2x00_start_iocbs(struct scsi_qla_host *vha, struct req_que *req)
 	struct qla_hw_data *ha = vha->hw;
 	device_reg_t *reg = ISP_QUE_REG(ha, req->id);
 
+	if (!ha->flags.fw_started)
+		return;
+
 	if (IS_P3P_TYPE(ha)) {
 		qla82xx_start_iocbs(vha);
 	} else {
@@ -1603,6 +1606,9 @@ qla24xx_start_scsi(srb_t *sp)
 	struct scsi_qla_host *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (!ha->flags.fw_started)
+		return QLA_FUNCTION_FAILED;
+
 	/* Setup device pointers. */
 	req = vha->req;
 
@@ -1740,6 +1746,9 @@ qla24xx_dif_start_scsi(srb_t *sp)
 
 #define QDSS_GOT_Q_SPACE	BIT_0
 
+	if (!ha->flags.fw_started)
+		return QLA_FUNCTION_FAILED;
+
 	/* Only process protection or >16 cdb in this routine */
 	if (scsi_get_prot_op(cmd) == SCSI_PROT_NORMAL) {
 		if (cmd->cmd_len <= 16)
@@ -1921,6 +1930,9 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_qpair *qpair = sp->qpair;
 
+	if (!ha->flags.fw_started)
+		return QLA_FUNCTION_FAILED;
+
 	/* Acquire qpair specific lock */
 	spin_lock_irqsave(&qpair->qp_lock, flags);
 
@@ -2062,6 +2074,11 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 
 #define QDSS_GOT_Q_SPACE	BIT_0
 
+	if (!ha->flags.fw_started) {
+		cmd->result = DID_NO_CONNECT << 16;
+		return QLA_FUNCTION_FAILED;
+	}
+
 	/* Check for host side state */
 	if (!qpair->online) {
 		cmd->result = DID_NO_CONNECT << 16;
@@ -3224,6 +3241,9 @@ qla82xx_start_scsi(srb_t *sp)
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
 
+	if (!ha->flags.fw_started)
+		return QLA_FUNCTION_FAILED;
+
 	/* Setup device pointers. */
 	reg = &ha->iobase->isp82;
 	cmd = GET_CMD_SP(sp);
@@ -3676,6 +3696,9 @@ qla2x00_start_sp(srb_t *sp)
 	void *pkt;
 	unsigned long flags;
 
+	if (!ha->flags.fw_started)
+		return QLA_FUNCTION_FAILED;
+
 	spin_lock_irqsave(qp->qp_lock_ptr, flags);
 	pkt = __qla2x00_alloc_iocbs(sp->qpair, sp);
 	if (!pkt) {
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 84e2a980..4f36e73 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -369,6 +369,9 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	struct nvmefc_fcp_req *fd = nvme->u.nvme.desc;
 	uint32_t        rval = QLA_SUCCESS;
 
+	if (!ha->flags.fw_started)
+		return QLA_FUNCTION_FAILED;
+
 	/* Setup qpair pointers */
 	req = qpair->req;
 	tot_dsds = fd->sg_cnt;
-- 
2.25.1

