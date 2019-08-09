Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 717D4C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47E14216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405306AbfHIDDm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:42 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33270 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405025AbfHIDDl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:41 -0400
Received: by mail-pg1-f193.google.com with SMTP id n190so4289360pgn.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UNYhQxkuKDNEHgZQKQL07o119WUj/E8C9qcU2zYxAGc=;
        b=szJpyd46nebrmLeWA04Cvy0ZgWd1JxgwOuoJtxCOsePuvcj4uLwxYuuzwTP6qnemjW
         q0Bue9qy3rFLrn3qmV9pETnRvZQ2owWXA59oNKR0dD36oSdUKrldplwr+BQvTtjrJmBh
         bHhdJy6kOcH6/d9xmZdFyttYthfrNhpCtc1cA0CaALUoiTPid76x97p4KknZvzqAo2HQ
         kG1e1O2pyaaZod6tpMuL5HsyWGk165147mTDZ5mu4IPnt6Vju9ZVLbCJYBHQAz/Mv6Jb
         XtHmot2BzQtmAw+VcEvzreUHPa6BQzelESIeGQq4k5GkoeNrYkuMOjv5sGKgVmiU5to6
         qDlA==
X-Gm-Message-State: APjAAAVIbIf5D9uEBE1fPlxRpn5XXHyZvcgakhXAA4ctU+mw+duDHvmF
        +fzNSw0He+0cHth4wDNIIMM=
X-Google-Smtp-Source: APXvYqyUQVdBxSrMPfmBUHMuqVBLNaCf8HURHhh3+aSR6B+CGSP+oBjieMwavqZS5MWKXxE+wQKICA==
X-Received: by 2002:a17:90a:710c:: with SMTP id h12mr7096125pjk.36.1565319820616;
        Thu, 08 Aug 2019 20:03:40 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 48/58] qla2xxx: Introduce qla2xxx_get_next_handle()
Date:   Thu,  8 Aug 2019 20:02:09 -0700
Message-Id: <20190809030219.11296-49-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch reduces code duplication.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |   1 +
 drivers/scsi/qla2xxx/qla_iocb.c | 128 +++++++++-----------------------
 drivers/scsi/qla2xxx/qla_mr.c   |  13 +---
 drivers/scsi/qla2xxx/qla_nvme.c |  14 +---
 4 files changed, 42 insertions(+), 114 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index bbfbe3a34a7e..6b914942fad3 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -272,6 +272,7 @@ extern void qla2x00_build_scsi_iocbs_32(srb_t *, cmd_entry_t *, uint16_t);
 extern void qla2x00_build_scsi_iocbs_64(srb_t *, cmd_entry_t *, uint16_t);
 extern void qla24xx_build_scsi_iocbs(srb_t *, struct cmd_type_7 *,
 	uint16_t, struct req_que *);
+extern uint32_t qla2xxx_get_next_handle(struct req_que *req);
 extern int qla2x00_start_scsi(srb_t *sp);
 extern int qla24xx_start_scsi(srb_t *sp);
 int qla2x00_marker(struct scsi_qla_host *, struct qla_qpair *,
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 59a0a778d31c..22d875222321 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -292,6 +292,26 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 	}
 }
 
+/*
+ * Find the first handle that is not in use, starting from
+ * req->current_outstanding_cmd + 1. The caller must hold the lock that is
+ * associated with @req.
+ */
+uint32_t qla2xxx_get_next_handle(struct req_que *req)
+{
+	uint32_t index, handle = req->current_outstanding_cmd;
+
+	for (index = 1; index < req->num_outstanding_cmds; index++) {
+		handle++;
+		if (handle == req->num_outstanding_cmds)
+			handle = 1;
+		if (!req->outstanding_cmds[handle])
+			return handle;
+	}
+
+	return 0;
+}
+
 /**
  * qla2x00_start_scsi() - Send a SCSI command to the ISP
  * @sp: command to send to the ISP
@@ -306,7 +326,6 @@ qla2x00_start_scsi(srb_t *sp)
 	scsi_qla_host_t	*vha;
 	struct scsi_cmnd *cmd;
 	uint32_t	*clr_ptr;
-	uint32_t        index;
 	uint32_t	handle;
 	cmd_entry_t	*cmd_pkt;
 	uint16_t	cnt;
@@ -339,16 +358,8 @@ qla2x00_start_scsi(srb_t *sp)
 	/* Acquire ring specific lock */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	/* Check for room in outstanding command list. */
-	handle = req->current_outstanding_cmd;
-	for (index = 1; index < req->num_outstanding_cmds; index++) {
-		handle++;
-		if (handle == req->num_outstanding_cmds)
-			handle = 1;
-		if (!req->outstanding_cmds[handle])
-			break;
-	}
-	if (index == req->num_outstanding_cmds)
+	handle = qla2xxx_get_next_handle(req);
+	if (handle == 0)
 		goto queuing_error;
 
 	/* Map the sg table so we have an accurate count of sg entries needed */
@@ -1584,7 +1595,6 @@ qla24xx_start_scsi(srb_t *sp)
 	int		nseg;
 	unsigned long   flags;
 	uint32_t	*clr_ptr;
-	uint32_t        index;
 	uint32_t	handle;
 	struct cmd_type_7 *cmd_pkt;
 	uint16_t	cnt;
@@ -1612,16 +1622,8 @@ qla24xx_start_scsi(srb_t *sp)
 	/* Acquire ring specific lock */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	/* Check for room in outstanding command list. */
-	handle = req->current_outstanding_cmd;
-	for (index = 1; index < req->num_outstanding_cmds; index++) {
-		handle++;
-		if (handle == req->num_outstanding_cmds)
-			handle = 1;
-		if (!req->outstanding_cmds[handle])
-			break;
-	}
-	if (index == req->num_outstanding_cmds)
+	handle = qla2xxx_get_next_handle(req);
+	if (handle == 0)
 		goto queuing_error;
 
 	/* Map the sg table so we have an accurate count of sg entries needed */
@@ -1724,7 +1726,6 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	int			nseg;
 	unsigned long		flags;
 	uint32_t		*clr_ptr;
-	uint32_t		index;
 	uint32_t		handle;
 	uint16_t		cnt;
 	uint16_t		req_cnt = 0;
@@ -1765,17 +1766,8 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	/* Acquire ring specific lock */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	/* Check for room in outstanding command list. */
-	handle = req->current_outstanding_cmd;
-	for (index = 1; index < req->num_outstanding_cmds; index++) {
-		handle++;
-		if (handle == req->num_outstanding_cmds)
-			handle = 1;
-		if (!req->outstanding_cmds[handle])
-			break;
-	}
-
-	if (index == req->num_outstanding_cmds)
+	handle = qla2xxx_get_next_handle(req);
+	if (handle == 0)
 		goto queuing_error;
 
 	/* Compute number of required data segments */
@@ -1920,7 +1912,6 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	int		nseg;
 	unsigned long   flags;
 	uint32_t	*clr_ptr;
-	uint32_t        index;
 	uint32_t	handle;
 	struct cmd_type_7 *cmd_pkt;
 	uint16_t	cnt;
@@ -1951,16 +1942,8 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 		vha->marker_needed = 0;
 	}
 
-	/* Check for room in outstanding command list. */
-	handle = req->current_outstanding_cmd;
-	for (index = 1; index < req->num_outstanding_cmds; index++) {
-		handle++;
-		if (handle == req->num_outstanding_cmds)
-			handle = 1;
-		if (!req->outstanding_cmds[handle])
-			break;
-	}
-	if (index == req->num_outstanding_cmds)
+	handle = qla2xxx_get_next_handle(req);
+	if (handle == 0)
 		goto queuing_error;
 
 	/* Map the sg table so we have an accurate count of sg entries needed */
@@ -2064,7 +2047,6 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 	int			nseg;
 	unsigned long		flags;
 	uint32_t		*clr_ptr;
-	uint32_t		index;
 	uint32_t		handle;
 	uint16_t		cnt;
 	uint16_t		req_cnt = 0;
@@ -2119,17 +2101,8 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 		vha->marker_needed = 0;
 	}
 
-	/* Check for room in outstanding command list. */
-	handle = req->current_outstanding_cmd;
-	for (index = 1; index < req->num_outstanding_cmds; index++) {
-		handle++;
-		if (handle == req->num_outstanding_cmds)
-			handle = 1;
-		if (!req->outstanding_cmds[handle])
-			break;
-	}
-
-	if (index == req->num_outstanding_cmds)
+	handle = qla2xxx_get_next_handle(req);
+	if (handle == 0)
 		goto queuing_error;
 
 	/* Compute number of required data segments */
@@ -2276,7 +2249,7 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = qpair->req;
 	device_reg_t *reg = ISP_QUE_REG(ha, req->id);
-	uint32_t index, handle;
+	uint32_t handle;
 	request_t *pkt;
 	uint16_t cnt, req_cnt;
 
@@ -2316,16 +2289,8 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 		goto queuing_error;
 
 	if (sp) {
-		/* Check for room in outstanding command list. */
-		handle = req->current_outstanding_cmd;
-		for (index = 1; index < req->num_outstanding_cmds; index++) {
-			handle++;
-			if (handle == req->num_outstanding_cmds)
-				handle = 1;
-			if (!req->outstanding_cmds[handle])
-				break;
-		}
-		if (index == req->num_outstanding_cmds) {
+		handle = qla2xxx_get_next_handle(req);
+		if (handle == 0) {
 			ql_log(ql_log_warn, vha, 0x700b,
 			    "No room on outstanding cmd array.\n");
 			goto queuing_error;
@@ -3112,7 +3077,6 @@ qla82xx_start_scsi(srb_t *sp)
 	unsigned long   flags;
 	struct scsi_cmnd *cmd;
 	uint32_t	*clr_ptr;
-	uint32_t        index;
 	uint32_t	handle;
 	uint16_t	cnt;
 	uint16_t	req_cnt;
@@ -3152,16 +3116,8 @@ qla82xx_start_scsi(srb_t *sp)
 	/* Acquire ring specific lock */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	/* Check for room in outstanding command list. */
-	handle = req->current_outstanding_cmd;
-	for (index = 1; index < req->num_outstanding_cmds; index++) {
-		handle++;
-		if (handle == req->num_outstanding_cmds)
-			handle = 1;
-		if (!req->outstanding_cmds[handle])
-			break;
-	}
-	if (index == req->num_outstanding_cmds)
+	handle = qla2xxx_get_next_handle(req);
+	if (handle == 0)
 		goto queuing_error;
 
 	/* Map the sg table so we have an accurate count of sg entries needed */
@@ -3769,7 +3725,6 @@ qla2x00_start_bidir(srb_t *sp, struct scsi_qla_host *vha, uint32_t tot_dsds)
 	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags;
 	uint32_t handle;
-	uint32_t index;
 	uint16_t req_cnt;
 	uint16_t cnt;
 	uint32_t *clr_ptr;
@@ -3794,17 +3749,8 @@ qla2x00_start_bidir(srb_t *sp, struct scsi_qla_host *vha, uint32_t tot_dsds)
 	/* Acquire ring specific lock */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	/* Check for room in outstanding command list. */
-	handle = req->current_outstanding_cmd;
-	for (index = 1; index < req->num_outstanding_cmds; index++) {
-		handle++;
-		if (handle == req->num_outstanding_cmds)
-			handle = 1;
-		if (!req->outstanding_cmds[handle])
-			break;
-	}
-
-	if (index == req->num_outstanding_cmds) {
+	handle = qla2xxx_get_next_handle(req);
+	if (handle == 0) {
 		rval = EXT_STATUS_BUSY;
 		goto queuing_error;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index e8da3ec4db2c..06985b2d48eb 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -3071,7 +3071,6 @@ qlafx00_start_scsi(srb_t *sp)
 {
 	int		nseg;
 	unsigned long   flags;
-	uint32_t        index;
 	uint32_t	handle;
 	uint16_t	cnt;
 	uint16_t	req_cnt;
@@ -3095,16 +3094,8 @@ qlafx00_start_scsi(srb_t *sp)
 	/* Acquire ring specific lock */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	/* Check for room in outstanding command list. */
-	handle = req->current_outstanding_cmd;
-	for (index = 1; index < req->num_outstanding_cmds; index++) {
-		handle++;
-		if (handle == req->num_outstanding_cmds)
-			handle = 1;
-		if (!req->outstanding_cmds[handle])
-			break;
-	}
-	if (index == req->num_outstanding_cmds)
+	handle = qla2xxx_get_next_handle(req);
+	if (handle == 0)
 		goto queuing_error;
 
 	/* Map the sg table so we have an accurate count of sg entries needed */
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index af6b46777602..6cc19e060afc 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -353,7 +353,6 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 {
 	unsigned long   flags;
 	uint32_t        *clr_ptr;
-	uint32_t        index;
 	uint32_t        handle;
 	struct cmd_nvme *cmd_pkt;
 	uint16_t        cnt, i;
@@ -377,17 +376,8 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	/* Acquire qpair specific lock */
 	spin_lock_irqsave(&qpair->qp_lock, flags);
 
-	/* Check for room in outstanding command list. */
-	handle = req->current_outstanding_cmd;
-	for (index = 1; index < req->num_outstanding_cmds; index++) {
-		handle++;
-		if (handle == req->num_outstanding_cmds)
-			handle = 1;
-		if (!req->outstanding_cmds[handle])
-			break;
-	}
-
-	if (index == req->num_outstanding_cmds) {
+	handle = qla2xxx_get_next_handle(req);
+	if (handle == 0) {
 		rval = -EBUSY;
 		goto queuing_error;
 	}
-- 
2.22.0

