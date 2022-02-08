Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E71C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384253AbiBHR0a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384238AbiBHR01 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:26:27 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C745DC061576
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:26 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id qe15so7503194pjb.3
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W1pC80Exri3gPwcY1gnR6YH7GdpzGiizheBMlfilvVc=;
        b=TKRqAdN0EyDHjZV9lNkeF4FWOSwp177Hbw/2Ri3roTQK9SoIRN0hKt5eCmvgLHzktq
         R4sijScDH0iCJHM3S33NufQRIpVWA+KmIjl/lbvKaWgaziMzCYhrTwxmGx/0ffF/8J4j
         idOYUvSE4CUkrH10hSWQoSYurSxVXC8T+aRdBRf6SfVCnTxuPPGQavo1BIaJKlEFIc/v
         IhRiJ9dsvZ+FwlRYQWHjbo6gHrG65eH4m2e1u7T0jqmwBCiJTAfsI2Mx+36s2mvnIJYh
         Qw4R83epK+UKLV1pGGWvlKlyH7eUcSj+b0cUIwj0lPFqxDnD/RsZN0/m7Cq+wFcbJsSr
         cHqg==
X-Gm-Message-State: AOAM532/6i0Dzpxdgrkh0i9VBzWL2ccEMXs+00TbSws1O4LxmDL+Zid+
        hXjW+HWFltOhFrmktBRfYjo=
X-Google-Smtp-Source: ABdhPJxYUmsbQVf8r50lUkzOi/l4yz6szSmVZJC7EE6G0rvHrulFSYpJWtPzeKm64Rnha6Pr+Gl+AQ==
X-Received: by 2002:a17:90a:5503:: with SMTP id b3mr2514067pji.169.1644341186129;
        Tue, 08 Feb 2022 09:26:26 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:25 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v2 24/44] libfc: Stop using the SCSI pointer
Date:   Tue,  8 Feb 2022 09:24:54 -0800
Message-Id: <20220208172514.3481-25-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the fc_fcp_pkt pointer, the residual length and the SCSI status into
the new data structure libfc_cmd_priv. This patch prepares for removal of
the SCSI pointer from struct scsi_cmnd.

The libfc users have been identified as follows:

$ git grep -lw 'libfc_host_alloc' | grep -v /libfc
drivers/scsi/bnx2fc/bnx2fc_fcoe.c
drivers/scsi/fcoe/fcoe.c
drivers/scsi/fnic/fnic_main.c
drivers/scsi/qedf/qedf_main.c

Cc: Hannes Reinecke <hare@suse.de>
Cc: Saurav Kashyap <skashyap@marvell.com>
Cc: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bnx2fc/bnx2fc.h      | 10 ++++++++--
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |  1 +
 drivers/scsi/bnx2fc/bnx2fc_io.c   | 20 ++++++++++----------
 drivers/scsi/fcoe/fcoe.c          |  1 +
 drivers/scsi/fnic/fnic.h          |  1 +
 drivers/scsi/libfc/fc_fcp.c       | 26 +++++++++++---------------
 drivers/scsi/qedf/qedf.h          | 11 ++++++++++-
 drivers/scsi/qedf/qedf_io.c       | 16 ++++++++--------
 drivers/scsi/qedf/qedf_main.c     |  3 ++-
 include/scsi/libfc.h              | 11 +++++++++++
 10 files changed, 63 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index b4cea8b06ea1..08deed26c51e 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -137,8 +137,6 @@
 #define BNX2FC_FW_TIMEOUT		(3 * HZ)
 #define PORT_MAX			2
 
-#define CMD_SCSI_STATUS(Cmnd)		((Cmnd)->SCp.Status)
-
 /* FC FCP Status */
 #define	FC_GOOD				0
 
@@ -493,7 +491,15 @@ struct bnx2fc_unsol_els {
 	struct work_struct unsol_els_work;
 };
 
+struct bnx2fc_priv {
+	struct libfc_cmd_priv libfc_data; /* must be the first member */
+	struct bnx2fc_cmd *io_req;
+};
 
+static inline struct bnx2fc_priv *bnx2fc_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
 
 struct bnx2fc_cmd *bnx2fc_cmd_alloc(struct bnx2fc_rport *tgt);
 struct bnx2fc_cmd *bnx2fc_elstm_alloc(struct bnx2fc_rport *tgt, int type);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index a826456c6075..2d5c71967ee3 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2975,6 +2975,7 @@ static struct scsi_host_template bnx2fc_shost_template = {
 	.track_queue_depth	= 1,
 	.slave_configure	= bnx2fc_slave_configure,
 	.shost_groups		= bnx2fc_host_groups,
+	.cmd_size		= sizeof(struct bnx2fc_priv),
 };
 
 static struct libfc_function_template bnx2fc_libfc_fcn_templ = {
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index b9114113ee73..a1d0f7d34466 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -204,7 +204,7 @@ static void bnx2fc_scsi_done(struct bnx2fc_cmd *io_req, int err_code)
 		sc_cmd, host_byte(sc_cmd->result), sc_cmd->retries,
 		sc_cmd->allowed);
 	scsi_set_resid(sc_cmd, scsi_bufflen(sc_cmd));
-	sc_cmd->SCp.ptr = NULL;
+	bnx2fc_priv(sc_cmd)->io_req = NULL;
 	scsi_done(sc_cmd);
 }
 
@@ -765,7 +765,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 	task = &(task_page[index]);
 	bnx2fc_init_mp_task(io_req, task);
 
-	sc_cmd->SCp.ptr = (char *)io_req;
+	bnx2fc_priv(sc_cmd)->io_req = io_req;
 
 	/* Obtain free SQ entry */
 	spin_lock_bh(&tgt->tgt_lock);
@@ -1147,7 +1147,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	BNX2FC_TGT_DBG(tgt, "Entered bnx2fc_eh_abort\n");
 
 	spin_lock_bh(&tgt->tgt_lock);
-	io_req = (struct bnx2fc_cmd *)sc_cmd->SCp.ptr;
+	io_req = bnx2fc_priv(sc_cmd)->io_req;
 	if (!io_req) {
 		/* Command might have just completed */
 		printk(KERN_ERR PFX "eh_abort: io_req is NULL\n");
@@ -1572,7 +1572,7 @@ void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_req,
 		printk(KERN_ERR PFX "tmf's fc_hdr r_ctl = 0x%x\n",
 			fc_hdr->fh_r_ctl);
 	}
-	if (!sc_cmd->SCp.ptr) {
+	if (!bnx2fc_priv(sc_cmd)->io_req) {
 		printk(KERN_ERR PFX "tm_compl: SCp.ptr is NULL\n");
 		return;
 	}
@@ -1609,7 +1609,7 @@ void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_req,
 		return;
 	}
 
-	sc_cmd->SCp.ptr = NULL;
+	bnx2fc_priv(sc_cmd)->io_req = NULL;
 	scsi_done(sc_cmd);
 
 	kref_put(&io_req->refcount, bnx2fc_cmd_release);
@@ -1773,8 +1773,8 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
 		io_req->fcp_resid = fcp_rsp->fcp_resid;
 
 	io_req->scsi_comp_flags = rsp_flags;
-	CMD_SCSI_STATUS(sc_cmd) = io_req->cdb_status =
-				fcp_rsp->scsi_status_code;
+	bnx2fc_priv(sc_cmd)->libfc_data.status = io_req->cdb_status =
+		fcp_rsp->scsi_status_code;
 
 	/* Fetch fcp_rsp_info and fcp_sns_info if available */
 	if (num_rq) {
@@ -1946,7 +1946,7 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 	/* parse fcp_rsp and obtain sense data from RQ if available */
 	bnx2fc_parse_fcp_rsp(io_req, fcp_rsp, num_rq, rq_data);
 
-	if (!sc_cmd->SCp.ptr) {
+	if (!bnx2fc_priv(sc_cmd)->io_req) {
 		printk(KERN_ERR PFX "SCp.ptr is NULL\n");
 		return;
 	}
@@ -2018,7 +2018,7 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 			io_req->fcp_status);
 		break;
 	}
-	sc_cmd->SCp.ptr = NULL;
+	bnx2fc_priv(sc_cmd)->io_req = NULL;
 	scsi_done(sc_cmd);
 	kref_put(&io_req->refcount, bnx2fc_cmd_release);
 }
@@ -2044,7 +2044,7 @@ int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
 	io_req->port = port;
 	io_req->tgt = tgt;
 	io_req->data_xfer_len = scsi_bufflen(sc_cmd);
-	sc_cmd->SCp.ptr = (char *)io_req;
+	bnx2fc_priv(sc_cmd)->io_req = io_req;
 
 	stats = per_cpu_ptr(lport->stats, get_cpu());
 	if (sc_cmd->sc_data_direction == DMA_FROM_DEVICE) {
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 6415f88738ad..44ca6110213c 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -277,6 +277,7 @@ static struct scsi_host_template fcoe_shost_template = {
 	.sg_tablesize = SG_ALL,
 	.max_sectors = 0xffff,
 	.track_queue_depth = 1,
+	.cmd_size = sizeof(struct libfc_cmd_priv),
 };
 
 /**
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index aa07189fb5fb..6ab444650f02 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -93,6 +93,7 @@
  * These fields are locked by the hashed io_req_lock.
  */
 struct fnic_cmd_priv {
+	struct libfc_cmd_priv libfc_data; /* must be the first member */
 	struct fnic_io_req *io_req;
 	enum fnic_ioreq_state state;
 	u32 flags;
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 871b11edb586..bce90eb56c9c 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -45,14 +45,10 @@ static struct kmem_cache *scsi_pkt_cachep;
 #define FC_SRB_READ		(1 << 1)
 #define FC_SRB_WRITE		(1 << 0)
 
-/*
- * The SCp.ptr should be tested and set under the scsi_pkt_queue lock
- */
-#define CMD_SP(Cmnd)		    ((struct fc_fcp_pkt *)(Cmnd)->SCp.ptr)
-#define CMD_ENTRY_STATUS(Cmnd)	    ((Cmnd)->SCp.have_data_in)
-#define CMD_COMPL_STATUS(Cmnd)	    ((Cmnd)->SCp.this_residual)
-#define CMD_SCSI_STATUS(Cmnd)	    ((Cmnd)->SCp.Status)
-#define CMD_RESID_LEN(Cmnd)	    ((Cmnd)->SCp.buffers_residual)
+static struct libfc_cmd_priv *libfc_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
 
 /**
  * struct fc_fcp_internal - FCP layer internal data
@@ -1137,7 +1133,7 @@ static int fc_fcp_pkt_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp)
 	unsigned long flags;
 	int rc;
 
-	fsp->cmd->SCp.ptr = (char *)fsp;
+	libfc_priv(fsp->cmd)->fsp = fsp;
 	fsp->cdb_cmd.fc_dl = htonl(fsp->data_len);
 	fsp->cdb_cmd.fc_flags = fsp->req_flags & ~FCP_CFL_LEN_MASK;
 
@@ -1150,7 +1146,7 @@ static int fc_fcp_pkt_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp)
 	rc = lport->tt.fcp_cmd_send(lport, fsp, fc_fcp_recv);
 	if (unlikely(rc)) {
 		spin_lock_irqsave(&si->scsi_queue_lock, flags);
-		fsp->cmd->SCp.ptr = NULL;
+		libfc_priv(fsp->cmd)->fsp = NULL;
 		list_del(&fsp->list);
 		spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
 	}
@@ -1983,7 +1979,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 		fc_fcp_can_queue_ramp_up(lport);
 
 	sc_cmd = fsp->cmd;
-	CMD_SCSI_STATUS(sc_cmd) = fsp->cdb_status;
+	libfc_priv(sc_cmd)->status = fsp->cdb_status;
 	switch (fsp->status_code) {
 	case FC_COMPLETE:
 		if (fsp->cdb_status == 0) {
@@ -1992,7 +1988,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 			 */
 			sc_cmd->result = DID_OK << 16;
 			if (fsp->scsi_resid)
-				CMD_RESID_LEN(sc_cmd) = fsp->scsi_resid;
+				libfc_priv(sc_cmd)->resid_len = fsp->scsi_resid;
 		} else {
 			/*
 			 * transport level I/O was ok but scsi
@@ -2025,7 +2021,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 			 */
 			FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml "
 				   "due to FC_DATA_UNDRUN (scsi)\n");
-			CMD_RESID_LEN(sc_cmd) = fsp->scsi_resid;
+			libfc_priv(sc_cmd)->resid_len = fsp->scsi_resid;
 			sc_cmd->result = (DID_ERROR << 16) | fsp->cdb_status;
 		}
 		break;
@@ -2085,7 +2081,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 
 	spin_lock_irqsave(&si->scsi_queue_lock, flags);
 	list_del(&fsp->list);
-	sc_cmd->SCp.ptr = NULL;
+	libfc_priv(sc_cmd)->fsp = NULL;
 	spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
 	scsi_done(sc_cmd);
 
@@ -2121,7 +2117,7 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 
 	si = fc_get_scsi_internal(lport);
 	spin_lock_irqsave(&si->scsi_queue_lock, flags);
-	fsp = CMD_SP(sc_cmd);
+	fsp = libfc_priv(sc_cmd)->fsp;
 	if (!fsp) {
 		/* command completed while scsi eh was setting up */
 		spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index ca987451b17e..abb0c26da36e 100644
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
@@ -189,6 +188,16 @@ struct qedf_ioreq {
 	unsigned int alloc;
 };
 
+struct qedf_cmd_priv {
+	struct libfc_cmd_priv	libfc_data; /* must be the first member */
+	struct qedf_ioreq	*io_req;
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
index fab43dabe5b3..ed78a03a7e7c 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -857,7 +857,7 @@ int qedf_post_io_req(struct qedf_rport *fcport, struct qedf_ioreq *io_req)
 
 	/* Initialize rest of io_req fileds */
 	io_req->data_xfer_len = scsi_bufflen(sc_cmd);
-	sc_cmd->SCp.ptr = (char *)io_req;
+	qedf_priv(sc_cmd)->io_req = io_req;
 	io_req->sge_type = QEDF_IOREQ_FAST_SGE; /* Assume fast SGL by default */
 
 	/* Record which cpu this request is associated with */
@@ -1065,7 +1065,7 @@ static void qedf_parse_fcp_rsp(struct qedf_ioreq *io_req,
 		io_req->fcp_resid = fcp_rsp->fcp_resid;
 
 	io_req->scsi_comp_flags = rsp_flags;
-	CMD_SCSI_STATUS(sc_cmd) = io_req->cdb_status =
+	qedf_priv(sc_cmd)->libfc_data.status = io_req->cdb_status =
 	    fcp_rsp->scsi_status_code;
 
 	if (rsp_flags &
@@ -1150,7 +1150,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 		return;
 	}
 
-	if (!sc_cmd->SCp.ptr) {
+	if (!qedf_priv(sc_cmd)->io_req) {
 		QEDF_WARN(&(qedf->dbg_ctx), "SCp.ptr is NULL, returned in "
 		    "another context.\n");
 		return;
@@ -1312,7 +1312,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 	clear_bit(QEDF_CMD_OUTSTANDING, &io_req->flags);
 
 	io_req->sc_cmd = NULL;
-	sc_cmd->SCp.ptr =  NULL;
+	qedf_priv(sc_cmd)->io_req =  NULL;
 	scsi_done(sc_cmd);
 	kref_put(&io_req->refcount, qedf_release_cmd);
 }
@@ -1354,7 +1354,7 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 		goto bad_scsi_ptr;
 	}
 
-	if (!sc_cmd->SCp.ptr) {
+	if (!qedf_priv(sc_cmd)->io_req) {
 		QEDF_WARN(&(qedf->dbg_ctx), "SCp.ptr is NULL, returned in "
 		    "another context.\n");
 		return;
@@ -1409,7 +1409,7 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 		qedf_trace_io(io_req->fcport, io_req, QEDF_IO_TRACE_RSP);
 
 	io_req->sc_cmd = NULL;
-	sc_cmd->SCp.ptr = NULL;
+	qedf_priv(sc_cmd)->io_req = NULL;
 	scsi_done(sc_cmd);
 	kref_put(&io_req->refcount, qedf_release_cmd);
 	return;
@@ -2433,8 +2433,8 @@ int qedf_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
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
index 6ad28bc8e948..18dc68d577b6 100644
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
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index eeb8d689ff6b..5ae6d504e835 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -351,6 +351,15 @@ struct fc_fcp_pkt {
 	struct completion tm_done;
 } ____cacheline_aligned_in_smp;
 
+/*
+ * @fsp should be tested and set under the scsi_pkt_queue lock
+ */
+struct libfc_cmd_priv {
+	struct fc_fcp_pkt *fsp;
+	u32 resid_len;
+	u8 status;
+};
+
 /*
  * Structure and function definitions for managing Fibre Channel Exchanges
  * and Sequences
@@ -862,6 +871,8 @@ libfc_host_alloc(struct scsi_host_template *sht, int priv_size)
 	struct fc_lport *lport;
 	struct Scsi_Host *shost;
 
+	WARN_ON_ONCE(sht->cmd_size < sizeof(struct libfc_cmd_priv));
+
 	shost = scsi_host_alloc(sht, sizeof(*lport) + priv_size);
 	if (!shost)
 		return NULL;
