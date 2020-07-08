Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE20C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5ADC2065C
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LCrk/nSz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbgGHMCw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729132AbgGHMCv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:02:51 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181DAC08E6DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:02:51 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f7so45653932wrw.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mg1YIIvkYpJ6DUGLzmprsP3AfdbwaW1FuT6nykJ+1c8=;
        b=LCrk/nSzhh3HJrkDfqz+itjwOmKDQt+wE4yNjJsNxAsaUwpZcAd8GvEsdgkSOYZo5z
         7o+qf/aO49+PXFe2utcWGOXXG8AVO5/NNCMCP9khiGMcEvIdvCgN3bn19Tj7KerBvYqB
         r8czN1UsnVANue88UlwzxhWlnb/tl79HP7K46oFbedCPQVyiDSQ7Ml+gHIoFz4Zu8tMD
         nDx1nIB3izsFsriHXCbA1/rl/bkcdxpe4yoy4vxcCx5AJ2Xx/l+0FPcY+hXIDI9I6xo9
         rYbgqyizh1DJ2wjdPwAQ1mdF+/V1JaToAJffXoaoqixqo9MN86cCENjku61wPbtojt4S
         Ivjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mg1YIIvkYpJ6DUGLzmprsP3AfdbwaW1FuT6nykJ+1c8=;
        b=TRiiy7iJil+7Pn6w4JeIRyPPw9/QMDHe9s3T46LdRz1GV+wrNsDtu8VRu0gE8YZb0t
         zX3PIdlEhROWaM3QQwJp3LZudi8n1Ba7FFltuTUE4PLk+AJ/5nwZ2LCUpUxC5jyl218j
         w7vTb+hOfijIv2cvvLZeqDFDO4igTUtJYCJ8apjEE0Fdl5CVZSpfYVTSnGCs+wF8yc8a
         SPLd9tPbqLhaK1wgZ2jfWPEjtXhbXtubDNHpl4nqIHHpzhNdMQRfpUmAag9/erNAq1jU
         fMtYmbX+8/sQ8Wq05LMWwJH8l3Q5keQ7+RdY+tGwQDXCyCG9b/A3GUEvQ6GGqG4c6dvi
         KWDw==
X-Gm-Message-State: AOAM533F9ZxaQrdxHL8uLM96UY72YdPca959nqfQbTlSKSC6jvBrPMr6
        /a6YbiAmkU0noQqIK5LAbcoNfQ==
X-Google-Smtp-Source: ABdhPJwhhxqJF147mUsqw6o/BenIIvNwA62KuHnCS4OdSXjaxmLCDXQYWSiRFnAiEKbwmJWrlgErmQ==
X-Received: by 2002:a5d:4b4f:: with SMTP id w15mr56943748wrs.84.1594209769710;
        Wed, 08 Jul 2020 05:02:49 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:48 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@cavium.com
Subject: [PATCH 17/30] scsi: qedf: qedf_io: Remove a whole host of unused variables
Date:   Wed,  8 Jul 2020 13:02:08 +0100
Message-Id: <20200708120221.3386672-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qedf/qedf_io.c: In function ‘qedf_cmd_timeout’:
 drivers/scsi/qedf/qedf_io.c:25:5: warning: variable ‘op’ set but not used [-Wunused-but-set-variable]
 25 | u8 op = 0;
 | ^~
 drivers/scsi/qedf/qedf_io.c: In function ‘qedf_map_sg’:
 drivers/scsi/qedf/qedf_io.c:490:12: warning: variable ‘end_addr’ set but not used [-Wunused-but-set-variable]
 490 | u64 addr, end_addr;
 | ^~~~~~~~
 drivers/scsi/qedf/qedf_io.c: In function ‘qedf_post_io_req’:
 drivers/scsi/qedf/qedf_io.c:863:22: warning: variable ‘req_type’ set but not used [-Wunused-but-set-variable]
 863 | enum fcoe_task_type req_type = 0;
 | ^~~~~~~~
 drivers/scsi/qedf/qedf_io.c: In function ‘qedf_scsi_completion’:
 drivers/scsi/qedf/qedf_io.c:1134:31: warning: variable ‘task_ctx’ set but not used [-Wunused-but-set-variable]
 1134 | struct e4_fcoe_task_context *task_ctx;
 | ^~~~~~~~
 drivers/scsi/qedf/qedf_io.c: In function ‘qedf_scsi_done’:
 drivers/scsi/qedf/qedf_io.c:1345:6: warning: variable ‘xid’ set but not used [-Wunused-but-set-variable]
 1345 | u16 xid;
 | ^~~
 drivers/scsi/qedf/qedf_io.c: In function ‘qedf_initiate_abts’:
 drivers/scsi/qedf/qedf_io.c:1866:6: warning: variable ‘r_a_tov’ set but not used [-Wunused-but-set-variable]
 1866 | u32 r_a_tov = 0;
 | ^~~~~~~
 drivers/scsi/qedf/qedf_io.c: In function ‘qedf_process_abts_compl’:
 drivers/scsi/qedf/qedf_io.c:1967:11: warning: variable ‘xid’ set but not used [-Wunused-but-set-variable]
 1967 | uint16_t xid;
 | ^~~
 drivers/scsi/qedf/qedf_io.c: In function ‘qedf_initiate_cleanup’:
 drivers/scsi/qedf/qedf_io.c:2163:31: warning: variable ‘task’ set but not used [-Wunused-but-set-variable]
 2163 | struct e4_fcoe_task_context *task;
 | ^~~~
 drivers/scsi/qedf/qedf_io.c: In function ‘qedf_process_unsol_compl’:
 drivers/scsi/qedf/qedf_io.c:2534:11: warning: variable ‘tmp’ set but not used [-Wunused-but-set-variable]
 2534 | uint16_t tmp;
 | ^~~

Cc: QLogic-Storage-Upstream@cavium.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qedf/qedf_io.c | 30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 0f6a15c1a04b3..acd9774a9387c 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -22,7 +22,6 @@ static void qedf_cmd_timeout(struct work_struct *work)
 	    container_of(work, struct qedf_ioreq, timeout_work.work);
 	struct qedf_ctx *qedf;
 	struct qedf_rport *fcport;
-	u8 op = 0;
 
 	if (io_req == NULL) {
 		QEDF_INFO(NULL, QEDF_LOG_IO, "io_req is NULL.\n");
@@ -89,7 +88,6 @@ static void qedf_cmd_timeout(struct work_struct *work)
 		io_req->event = QEDF_IOREQ_EV_ELS_TMO;
 		/* Call callback function to complete command */
 		if (io_req->cb_func && io_req->cb_arg) {
-			op = io_req->cb_arg->op;
 			io_req->cb_func(io_req->cb_arg);
 			io_req->cb_arg = NULL;
 		}
@@ -487,7 +485,7 @@ static int qedf_map_sg(struct qedf_ioreq *io_req)
 	int sg_count = 0;
 	int bd_count = 0;
 	u32 sg_len;
-	u64 addr, end_addr;
+	u64 addr;
 	int i = 0;
 
 	sg_count = dma_map_sg(&qedf->pdev->dev, scsi_sglist(sc),
@@ -502,10 +500,9 @@ static int qedf_map_sg(struct qedf_ioreq *io_req)
 	scsi_for_each_sg(sc, sg, sg_count, i) {
 		sg_len = (u32)sg_dma_len(sg);
 		addr = (u64)sg_dma_address(sg);
-		end_addr = (u64)(addr + sg_len);
 
 		/*
-		 * Intermediate s/g element so check if start and end address
+		 * Intermediate s/g element so check if start address
 		 * is page aligned.  Only required for writes and only if the
 		 * number of scatter/gather elements is 8 or more.
 		 */
@@ -860,7 +857,6 @@ int qedf_post_io_req(struct qedf_rport *fcport, struct qedf_ioreq *io_req)
 	struct qedf_ctx *qedf = lport_priv(lport);
 	struct e4_fcoe_task_context *task_ctx;
 	u16 xid;
-	enum fcoe_task_type req_type = 0;
 	struct fcoe_wqe *sqe;
 	u16 sqe_idx;
 
@@ -873,11 +869,9 @@ int qedf_post_io_req(struct qedf_rport *fcport, struct qedf_ioreq *io_req)
 	io_req->cpu = smp_processor_id();
 
 	if (sc_cmd->sc_data_direction == DMA_FROM_DEVICE) {
-		req_type = FCOE_TASK_TYPE_READ_INITIATOR;
 		io_req->io_req_flags = QEDF_READ;
 		qedf->input_requests++;
 	} else if (sc_cmd->sc_data_direction == DMA_TO_DEVICE) {
-		req_type = FCOE_TASK_TYPE_WRITE_INITIATOR;
 		io_req->io_req_flags = QEDF_WRITE;
 		qedf->output_requests++;
 	} else {
@@ -1130,8 +1124,6 @@ static void qedf_unmap_sg_list(struct qedf_ctx *qedf, struct qedf_ioreq *io_req)
 void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 	struct qedf_ioreq *io_req)
 {
-	u16 xid;
-	struct e4_fcoe_task_context *task_ctx;
 	struct scsi_cmnd *sc_cmd;
 	struct fcoe_cqe_rsp_info *fcp_rsp;
 	struct qedf_rport *fcport;
@@ -1155,8 +1147,6 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 		return;
 	}
 
-	xid = io_req->xid;
-	task_ctx = qedf_get_task_mem(&qedf->tasks, xid);
 	sc_cmd = io_req->sc_cmd;
 	fcp_rsp = &cqe->cqe_info.rsp_info;
 
@@ -1342,7 +1332,6 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 	int result)
 {
-	u16 xid;
 	struct scsi_cmnd *sc_cmd;
 	int refcount;
 
@@ -1364,7 +1353,6 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 	 */
 	clear_bit(QEDF_CMD_OUTSTANDING, &io_req->flags);
 
-	xid = io_req->xid;
 	sc_cmd = io_req->sc_cmd;
 
 	if (!sc_cmd) {
@@ -1863,7 +1851,6 @@ int qedf_initiate_abts(struct qedf_ioreq *io_req, bool return_scsi_cmd_on_abts)
 	struct fc_rport_priv *rdata;
 	struct qedf_ctx *qedf;
 	u16 xid;
-	u32 r_a_tov = 0;
 	int rc = 0;
 	unsigned long flags;
 	struct fcoe_wqe *sqe;
@@ -1886,7 +1873,6 @@ int qedf_initiate_abts(struct qedf_ioreq *io_req, bool return_scsi_cmd_on_abts)
 		goto out;
 	}
 
-	r_a_tov = rdata->r_a_tov;
 	lport = qedf->lport;
 
 	if (lport->state != LPORT_ST_READY || !(lport->link_up)) {
@@ -1964,14 +1950,12 @@ void qedf_process_abts_compl(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 	struct qedf_ioreq *io_req)
 {
 	uint32_t r_ctl;
-	uint16_t xid;
 	int rc;
 	struct qedf_rport *fcport = io_req->fcport;
 
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_SCSI_TM, "Entered with xid = "
 		   "0x%x cmd_type = %d\n", io_req->xid, io_req->cmd_type);
 
-	xid = io_req->xid;
 	r_ctl = cqe->cqe_info.abts_info.r_ctl;
 
 	/* This was added at a point when we were scheduling abts_compl &
@@ -2159,8 +2143,6 @@ int qedf_initiate_cleanup(struct qedf_ioreq *io_req,
 {
 	struct qedf_rport *fcport;
 	struct qedf_ctx *qedf;
-	uint16_t xid;
-	struct e4_fcoe_task_context *task;
 	int tmo = 0;
 	int rc = SUCCESS;
 	unsigned long flags;
@@ -2220,12 +2202,9 @@ int qedf_initiate_cleanup(struct qedf_ioreq *io_req,
 		  refcount, fcport, fcport->rdata->ids.port_id);
 
 	/* Cleanup cmds re-use the same TID as the original I/O */
-	xid = io_req->xid;
 	io_req->cmd_type = QEDF_CLEANUP;
 	io_req->return_scsi_cmd_on_abts = return_scsi_cmd_on_abts;
 
-	task = qedf_get_task_mem(&qedf->tasks, xid);
-
 	init_completion(&io_req->cleanup_done);
 
 	spin_lock_irqsave(&fcport->rport_lock, flags);
@@ -2531,7 +2510,6 @@ void qedf_process_unsol_compl(struct qedf_ctx *qedf, uint16_t que_idx,
 	struct fcoe_cqe *cqe)
 {
 	unsigned long flags;
-	uint16_t tmp;
 	uint16_t pktlen = cqe->cqe_info.unsolic_info.pkt_len;
 	u32 payload_len, crc;
 	struct fc_frame_header *fh;
@@ -2629,9 +2607,9 @@ void qedf_process_unsol_compl(struct qedf_ctx *qedf, uint16_t que_idx,
 		qedf->bdq_prod_idx = 0;
 
 	writew(qedf->bdq_prod_idx, qedf->bdq_primary_prod);
-	tmp = readw(qedf->bdq_primary_prod);
+	readw(qedf->bdq_primary_prod);
 	writew(qedf->bdq_prod_idx, qedf->bdq_secondary_prod);
-	tmp = readw(qedf->bdq_secondary_prod);
+	readw(qedf->bdq_secondary_prod);
 
 	spin_unlock_irqrestore(&qedf->hba_lock, flags);
 }
-- 
2.25.1

