Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6EF3C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238287AbiBRTxQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:53:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238476AbiBRTwt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:52:49 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0C4291F84
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:31 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id w20so7953553plq.12
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JeUQe5FDJRxmW50xHeAOCcCpvsUW/ypA2QSHC8x+Jr8=;
        b=oWCAJkyb0BX3acMMZcK4g2P5ZwEa+KbQ9bo1XV7AOrWF6nQxjHt1nL7wpG9ffWRoPY
         nLTG1KTgFUZcd6pyGfqnDAPMZFcXATFaoFoe2TFXay6i1fRqkI/eY7Cqk1cplUnjkoDf
         8letIemHnLJaMAVXZJE4/xOMB8Pbgy0oub2UC4sHsmLr5ZDNqbi9glS2EQbBJDRvl7dJ
         JZUDNGySdHXAXX87zk3doui/JEbtjPo2zySkgqt8zIPe+fkyU2DMiW7t9OSpDhwBC8pQ
         1E4i4O8Irky543bAEL/Do6PLusY/x1SrtenpnsTpDR8Wern3x8utyt5OJR7xH2s87iQf
         zPPg==
X-Gm-Message-State: AOAM530J6QhFdoMXr/bURshcMe7Y8PGNsUoujua/aOP/oGHQYcGXZ6Iv
        9j+vtKlSSXNIU4ACphaTEjs=
X-Google-Smtp-Source: ABdhPJyt8zt/7ql3tpNWC+UkNRvMOgJ7MVXhpfWU5VJF3GBuX2mBLccA5l26XYsEt2Mq/OyhQcEcdA==
X-Received: by 2002:a17:90b:2098:b0:1bb:c650:8418 with SMTP id hb24-20020a17090b209800b001bbc6508418mr7926137pjb.135.1645213950693;
        Fri, 18 Feb 2022 11:52:30 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:52:29 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 29/49] scsi: qedf: Stop using the SCSI pointer
Date:   Fri, 18 Feb 2022 11:50:57 -0800
Message-Id: <20220218195117.25689-30-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. Remove the CMD_SCSI_STATUS() assignment because the
assigned value is not used.

This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qedf/qedf.h      | 10 +++++++++-
 drivers/scsi/qedf/qedf_io.c   | 25 ++++++++++++-------------
 drivers/scsi/qedf/qedf_main.c |  3 ++-
 3 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index ca987451b17e..c5c0bbdafc4e 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -91,7 +91,6 @@ enum qedf_ioreq_event {
 #define FC_GOOD		0
 #define FCOE_FCP_RSP_FLAGS_FCP_RESID_OVER	(0x1<<2)
 #define FCOE_FCP_RSP_FLAGS_FCP_RESID_UNDER	(0x1<<3)
-#define CMD_SCSI_STATUS(Cmnd)			((Cmnd)->SCp.Status)
 #define FCOE_FCP_RSP_FLAGS_FCP_RSP_LEN_VALID	(0x1<<0)
 #define FCOE_FCP_RSP_FLAGS_FCP_SNS_LEN_VALID	(0x1<<1)
 struct qedf_ioreq {
@@ -189,6 +188,15 @@ struct qedf_ioreq {
 	unsigned int alloc;
 };
 
+struct qedf_cmd_priv {
+	struct qedf_ioreq *io_req;
+};
+
+static inline struct qedf_cmd_priv *qedf_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
+
 extern struct workqueue_struct *qedf_io_wq;
 
 struct qedf_rport {
diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 99a56ca1fb16..81668cfcdd55 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -857,7 +857,7 @@ int qedf_post_io_req(struct qedf_rport *fcport, struct qedf_ioreq *io_req)
 
 	/* Initialize rest of io_req fileds */
 	io_req->data_xfer_len = scsi_bufflen(sc_cmd);
-	sc_cmd->SCp.ptr = (char *)io_req;
+	qedf_priv(sc_cmd)->io_req = io_req;
 	io_req->sge_type = QEDF_IOREQ_FAST_SGE; /* Assume fast SGL by default */
 
 	/* Record which cpu this request is associated with */
@@ -1065,8 +1065,7 @@ static void qedf_parse_fcp_rsp(struct qedf_ioreq *io_req,
 		io_req->fcp_resid = fcp_rsp->fcp_resid;
 
 	io_req->scsi_comp_flags = rsp_flags;
-	CMD_SCSI_STATUS(sc_cmd) = io_req->cdb_status =
-	    fcp_rsp->scsi_status_code;
+	io_req->cdb_status = fcp_rsp->scsi_status_code;
 
 	if (rsp_flags &
 	    FCOE_FCP_RSP_FLAGS_FCP_RSP_LEN_VALID)
@@ -1150,9 +1149,9 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 		return;
 	}
 
-	if (!sc_cmd->SCp.ptr) {
-		QEDF_WARN(&(qedf->dbg_ctx), "SCp.ptr is NULL, returned in "
-		    "another context.\n");
+	if (!qedf_priv(sc_cmd)->io_req) {
+		QEDF_WARN(&(qedf->dbg_ctx),
+			  "io_req is NULL, returned in another context.\n");
 		return;
 	}
 
@@ -1312,7 +1311,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 	clear_bit(QEDF_CMD_OUTSTANDING, &io_req->flags);
 
 	io_req->sc_cmd = NULL;
-	sc_cmd->SCp.ptr =  NULL;
+	qedf_priv(sc_cmd)->io_req =  NULL;
 	scsi_done(sc_cmd);
 	kref_put(&io_req->refcount, qedf_release_cmd);
 }
@@ -1354,9 +1353,9 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 		goto bad_scsi_ptr;
 	}
 
-	if (!sc_cmd->SCp.ptr) {
-		QEDF_WARN(&(qedf->dbg_ctx), "SCp.ptr is NULL, returned in "
-		    "another context.\n");
+	if (!qedf_priv(sc_cmd)->io_req) {
+		QEDF_WARN(&(qedf->dbg_ctx),
+			  "io_req is NULL, returned in another context.\n");
 		return;
 	}
 
@@ -1409,7 +1408,7 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 		qedf_trace_io(io_req->fcport, io_req, QEDF_IO_TRACE_RSP);
 
 	io_req->sc_cmd = NULL;
-	sc_cmd->SCp.ptr = NULL;
+	qedf_priv(sc_cmd)->io_req = NULL;
 	scsi_done(sc_cmd);
 	kref_put(&io_req->refcount, qedf_release_cmd);
 	return;
@@ -2432,8 +2431,8 @@ int qedf_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 		 (tm_flags == FCP_TMF_TGT_RESET) ? "TARGET RESET" :
 		 "LUN RESET");
 
-	if (sc_cmd->SCp.ptr) {
-		io_req = (struct qedf_ioreq *)sc_cmd->SCp.ptr;
+	if (qedf_priv(sc_cmd)->io_req) {
+		io_req = qedf_priv(sc_cmd)->io_req;
 		ref_cnt = kref_read(&io_req->refcount);
 		QEDF_ERR(NULL,
 			 "orig io_req = %p xid = 0x%x ref_cnt = %d.\n",
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index cdc66e2a9488..05b609a0e80d 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -740,7 +740,7 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
 	}
 
 
-	io_req = (struct qedf_ioreq *)sc_cmd->SCp.ptr;
+	io_req = qedf_priv(sc_cmd)->io_req;
 	if (!io_req) {
 		QEDF_ERR(&qedf->dbg_ctx,
 			 "sc_cmd not queued with lld, sc_cmd=%p op=0x%02x, port_id=%06x\n",
@@ -996,6 +996,7 @@ static struct scsi_host_template qedf_host_template = {
 	.sg_tablesize = QEDF_MAX_BDS_PER_CMD,
 	.can_queue = FCOE_PARAMS_NUM_TASKS,
 	.change_queue_depth = scsi_change_queue_depth,
+	.cmd_size = sizeof(struct qedf_cmd_priv),
 };
 
 static int qedf_get_paged_crc_eof(struct sk_buff *skb, int tlen)
