From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 30/35] bnx2fc: Do not rely on a scsi command when issueing lun or target reset
Date: Fri, 23 Jun 2017 15:02:50 +0200
Message-ID: <1498222975-71858-31-git-send-email-hare@suse.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32861 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751186AbdFWNDd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 09:03:33 -0400
In-Reply-To: <1498222975-71858-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When a LUN or target reset is issued we should not rely on a scsi
command to be present; this isn't very reliable and is going away
with the next patch anyway.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h     |  1 +
 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 14 ++++---
 drivers/scsi/bnx2fc/bnx2fc_io.c  | 89 +++++++++++++++++++---------------------
 3 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 9c5adee..d250d86 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -385,6 +385,7 @@ struct bnx2fc_rport {
 };
 
 struct bnx2fc_mp_req {
+	u64 tm_lun;
 	u8 tm_flags;
 
 	u32 req_len;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 5ff9f89..2b6ff3c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -1690,7 +1690,8 @@ void bnx2fc_init_task(struct bnx2fc_cmd *io_req,
 	struct fcoe_cached_sge_ctx *cached_sge;
 	struct fcoe_ext_mul_sges_ctx *sgl;
 	int dev_type = tgt->dev_type;
-	u64 *fcp_cmnd;
+	struct fcp_cmnd *fcp_cmnd;
+	u64 *raw_fcp_cmnd;
 	u64 tmp_fcp_cmnd[4];
 	u32 context_id;
 	int cnt, i;
@@ -1759,16 +1760,19 @@ void bnx2fc_init_task(struct bnx2fc_cmd *io_req,
 	task->txwr_rxrd.union_ctx.tx_seq.ctx.seq_cnt = 1;
 
 	/* Fill FCP_CMND IU */
-	fcp_cmnd = (u64 *)
+	fcp_cmnd = (struct fcp_cmnd *)&tmp_fcp_cmnd;
+	bnx2fc_build_fcp_cmnd(io_req, fcp_cmnd);
+	int_to_scsilun(sc_cmd->device->lun, &fcp_cmnd->fc_lun);
+	memcpy(fcp_cmnd->fc_cdb, sc_cmd->cmnd, sc_cmd->cmd_len);
+	raw_fcp_cmnd = (u64 *)
 		    task->txwr_rxrd.union_ctx.fcp_cmd.opaque;
-	bnx2fc_build_fcp_cmnd(io_req, (struct fcp_cmnd *)&tmp_fcp_cmnd);
 
 	/* swap fcp_cmnd */
 	cnt = sizeof(struct fcp_cmnd) / sizeof(u64);
 
 	for (i = 0; i < cnt; i++) {
-		*fcp_cmnd = cpu_to_be64(tmp_fcp_cmnd[i]);
-		fcp_cmnd++;
+		*raw_fcp_cmnd = cpu_to_be64(tmp_fcp_cmnd[i]);
+		raw_fcp_cmnd++;
 	}
 
 	/* Rx Write Tx Read */
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 3883022..ac4b13b 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -657,10 +657,9 @@ int bnx2fc_init_mp_req(struct bnx2fc_cmd *io_req)
 	return SUCCESS;
 }
 
-static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
+static int bnx2fc_initiate_tmf(struct fc_lport *lport, struct fc_rport *rport,
+			       u64 tm_lun, u8 tm_flags)
 {
-	struct fc_lport *lport;
-	struct fc_rport *rport;
 	struct fc_rport_libfc_priv *rp;
 	struct fcoe_port *port;
 	struct bnx2fc_interface *interface;
@@ -669,7 +668,6 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 	struct bnx2fc_mp_req *tm_req;
 	struct fcoe_task_ctx_entry *task;
 	struct fcoe_task_ctx_entry *task_page;
-	struct Scsi_Host *host = sc_cmd->device->host;
 	struct fc_frame_header *fc_hdr;
 	struct fcp_cmnd *fcp_cmnd;
 	int task_idx, index;
@@ -678,8 +676,6 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 	u32 sid, did;
 	unsigned long start = jiffies;
 
-	lport = shost_priv(host);
-	rport = starget_to_rport(scsi_target(sc_cmd->device));
 	port = lport_priv(lport);
 	interface = port->priv;
 
@@ -719,7 +715,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 		goto retry_tmf;
 	}
 	/* Initialize rest of io_req fields */
-	io_req->sc_cmd = sc_cmd;
+	io_req->sc_cmd = NULL;
 	io_req->port = port;
 	io_req->tgt = tgt;
 
@@ -737,11 +733,13 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 	/* Set TM flags */
 	io_req->io_req_flags = 0;
 	tm_req->tm_flags = tm_flags;
+	tm_req->tm_lun = tm_lun;
 
 	/* Fill FCP_CMND */
 	bnx2fc_build_fcp_cmnd(io_req, (struct fcp_cmnd *)tm_req->req_buf);
 	fcp_cmnd = (struct fcp_cmnd *)tm_req->req_buf;
-	memset(fcp_cmnd->fc_cdb, 0,  sc_cmd->cmd_len);
+	int_to_scsilun(tm_lun, &fcp_cmnd->fc_lun);
+	memset(fcp_cmnd->fc_cdb, 0,  BNX2FC_MAX_CMD_LEN);
 	fcp_cmnd->fc_dl = 0;
 
 	/* Fill FC header */
@@ -764,8 +762,6 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 	task = &(task_page[index]);
 	bnx2fc_init_mp_task(io_req, task);
 
-	sc_cmd->SCp.ptr = (char *)io_req;
-
 	/* Obtain free SQ entry */
 	spin_lock_bh(&tgt->tgt_lock);
 	bnx2fc_add_2_sq(tgt, xid);
@@ -1063,7 +1059,10 @@ int bnx2fc_initiate_cleanup(struct bnx2fc_cmd *io_req)
  */
 int bnx2fc_eh_target_reset(struct scsi_cmnd *sc_cmd)
 {
-	return bnx2fc_initiate_tmf(sc_cmd, FCP_TMF_TGT_RESET);
+	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
+	struct fc_lport *lport = shost_priv(rport_to_shost(rport));
+
+	return bnx2fc_initiate_tmf(lport, rport, 0, FCP_TMF_TGT_RESET);
 }
 
 /**
@@ -1076,7 +1075,11 @@ int bnx2fc_eh_target_reset(struct scsi_cmnd *sc_cmd)
  */
 int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 {
-	return bnx2fc_initiate_tmf(sc_cmd, FCP_TMF_LUN_RESET);
+	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
+	struct fc_lport *lport = shost_priv(rport_to_shost(rport));
+
+	return bnx2fc_initiate_tmf(lport, rport, sc_cmd->device->lun,
+				   FCP_TMF_LUN_RESET);
 }
 
 static int bnx2fc_abts_cleanup(struct bnx2fc_cmd *io_req)
@@ -1398,10 +1401,9 @@ void bnx2fc_process_abts_compl(struct bnx2fc_cmd *io_req,
 
 static void bnx2fc_lun_reset_cmpl(struct bnx2fc_cmd *io_req)
 {
-	struct scsi_cmnd *sc_cmd = io_req->sc_cmd;
 	struct bnx2fc_rport *tgt = io_req->tgt;
 	struct bnx2fc_cmd *cmd, *tmp;
-	u64 tm_lun = sc_cmd->device->lun;
+	struct bnx2fc_mp_req *tm_req = &io_req->mp_req;
 	u64 lun;
 	int rc = 0;
 
@@ -1413,8 +1415,10 @@ static void bnx2fc_lun_reset_cmpl(struct bnx2fc_cmd *io_req)
 	 */
 	list_for_each_entry_safe(cmd, tmp, &tgt->active_cmd_queue, link) {
 		BNX2FC_TGT_DBG(tgt, "LUN RST cmpl: scan for pending IOs\n");
+		if (!cmd->sc_cmd)
+			continue;
 		lun = cmd->sc_cmd->device->lun;
-		if (lun == tm_lun) {
+		if (lun == tm_req->tm_lun) {
 			/* Initiate ABTS on this cmd */
 			if (!test_and_set_bit(BNX2FC_FLAG_ISSUE_ABTS,
 					      &cmd->req_flags)) {
@@ -1517,32 +1521,32 @@ void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_req,
 		printk(KERN_ERR PFX "tmf's fc_hdr r_ctl = 0x%x\n",
 			fc_hdr->fh_r_ctl);
 	}
-	if (!sc_cmd->SCp.ptr) {
-		printk(KERN_ERR PFX "tm_compl: SCp.ptr is NULL\n");
-		return;
-	}
-	switch (io_req->fcp_status) {
-	case FC_GOOD:
-		if (io_req->cdb_status == 0) {
-			/* Good IO completion */
-			sc_cmd->result = DID_OK << 16;
-		} else {
-			/* Transport status is good, SCSI status not good */
-			sc_cmd->result = (DID_OK << 16) | io_req->cdb_status;
+	if (sc_cmd && sc_cmd->SCp.ptr) {
+		switch (io_req->fcp_status) {
+		case FC_GOOD:
+			if (io_req->cdb_status == 0) {
+				/* Good IO completion */
+				sc_cmd->result = DID_OK << 16;
+			} else {
+				/* Transport status is good, SCSI status not good */
+				sc_cmd->result = (DID_OK << 16) | io_req->cdb_status;
+			}
+			if (io_req->fcp_resid)
+				scsi_set_resid(sc_cmd, io_req->fcp_resid);
+			break;
+
+		default:
+			BNX2FC_IO_DBG(io_req, "process_tm_compl: fcp_status = %d\n",
+				      io_req->fcp_status);
+			break;
 		}
-		if (io_req->fcp_resid)
-			scsi_set_resid(sc_cmd, io_req->fcp_resid);
-		break;
 
-	default:
-		BNX2FC_IO_DBG(io_req, "process_tm_compl: fcp_status = %d\n",
-			   io_req->fcp_status);
-		break;
-	}
-
-	sc_cmd = io_req->sc_cmd;
-	io_req->sc_cmd = NULL;
+		sc_cmd = io_req->sc_cmd;
+		io_req->sc_cmd = NULL;
 
+		sc_cmd->SCp.ptr = NULL;
+		sc_cmd->scsi_done(sc_cmd);
+	}
 	/* check if the io_req exists in tgt's tmf_q */
 	if (io_req->on_tmf_queue) {
 
@@ -1554,9 +1558,6 @@ void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_req,
 		return;
 	}
 
-	sc_cmd->SCp.ptr = NULL;
-	sc_cmd->scsi_done(sc_cmd);
-
 	kref_put(&io_req->refcount, bnx2fc_cmd_release);
 	if (io_req->wait_for_comp) {
 		BNX2FC_IO_DBG(io_req, "tm_compl - wake up the waiter\n");
@@ -1674,15 +1675,9 @@ static void bnx2fc_unmap_sg_list(struct bnx2fc_cmd *io_req)
 void bnx2fc_build_fcp_cmnd(struct bnx2fc_cmd *io_req,
 				  struct fcp_cmnd *fcp_cmnd)
 {
-	struct scsi_cmnd *sc_cmd = io_req->sc_cmd;
-
 	memset(fcp_cmnd, 0, sizeof(struct fcp_cmnd));
 
-	int_to_scsilun(sc_cmd->device->lun, &fcp_cmnd->fc_lun);
-
 	fcp_cmnd->fc_dl = htonl(io_req->data_xfer_len);
-	memcpy(fcp_cmnd->fc_cdb, sc_cmd->cmnd, sc_cmd->cmd_len);
-
 	fcp_cmnd->fc_cmdref = 0;
 	fcp_cmnd->fc_pri_ta = 0;
 	fcp_cmnd->fc_tm_flags = io_req->mp_req.tm_flags;
-- 
1.8.5.6
