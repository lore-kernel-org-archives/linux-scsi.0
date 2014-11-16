From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.18-rc4
Date: Sun, 16 Nov 2014 08:17:32 -0800
Message-ID: <1416154652.22472.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of six fixes and a MAINTAINER update. The fixes are two
multipath (one in Test Unit Ready handling for the path checkers and one
in the section of code that sends a start unit after failover; both of
these were perturbed by the scsi-mq update), a CD-ROM door locking fix
that was likewise introduced by scsi-mq and three driver fixes for a
previous code update in cxgb4i, megaraid_sas and bnx2fc.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Anish Bhatt (2):
      cxgb4i: send abort_rpl correctly
      cxgbi: add maintainer for cxgb3i/cxgb4i

Christoph Hellwig (2):
      scsi: call device handler for failed TUR command
      scsi: only re-lock door after EH on devices that were reset

Jiang Liu (1):
      megaraid_sas: fix bug in handling return value of pci_enable_msix_range()

Maurizio Lombardi (1):
      bnx2fc: fix tgt spinlock locking

wenxiong@linux.vnet.ibm.com (1):
      scsi: TUR path is down after adapter gets reset with multipath

And the diffstat:

 MAINTAINERS                                | 14 ++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_els.c           |  2 --
 drivers/scsi/bnx2fc/bnx2fc_io.c            | 19 ++++++++++---------
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c         | 15 +++++++++------
 drivers/scsi/cxgbi/libcxgbi.c              | 18 ++++++++----------
 drivers/scsi/device_handler/scsi_dh_alua.c |  7 +++++++
 drivers/scsi/megaraid/megaraid_sas_base.c  |  2 +-
 drivers/scsi/scsi_error.c                  | 20 +++++++++++---------
 8 files changed, 60 insertions(+), 37 deletions(-)

With full diff below

James

---

diff --git a/MAINTAINERS b/MAINTAINERS
index ea4d005..84d9c5d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2744,6 +2744,13 @@ W:	http://www.chelsio.com
 S:	Supported
 F:	drivers/net/ethernet/chelsio/cxgb3/
 
+CXGB3 ISCSI DRIVER (CXGB3I)
+M:      Karen Xie <kxie@chelsio.com>
+L:      linux-scsi@vger.kernel.org
+W:      http://www.chelsio.com
+S:      Supported
+F:      drivers/scsi/cxgbi/cxgb3i
+
 CXGB3 IWARP RNIC DRIVER (IW_CXGB3)
 M:	Steve Wise <swise@chelsio.com>
 L:	linux-rdma@vger.kernel.org
@@ -2758,6 +2765,13 @@ W:	http://www.chelsio.com
 S:	Supported
 F:	drivers/net/ethernet/chelsio/cxgb4/
 
+CXGB4 ISCSI DRIVER (CXGB4I)
+M:      Karen Xie <kxie@chelsio.com>
+L:      linux-scsi@vger.kernel.org
+W:      http://www.chelsio.com
+S:      Supported
+F:      drivers/scsi/cxgbi/cxgb4i
+
 CXGB4 IWARP RNIC DRIVER (IW_CXGB4)
 M:	Steve Wise <swise@chelsio.com>
 L:	linux-rdma@vger.kernel.org
diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2fc_els.c
index ca75c7c..ef355c1 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -480,9 +480,7 @@ void bnx2fc_rec_compl(struct bnx2fc_els_cb_arg *cb_arg)
 			bnx2fc_initiate_cleanup(orig_io_req);
 			/* Post a new IO req with the same sc_cmd */
 			BNX2FC_IO_DBG(rec_req, "Post IO request again\n");
-			spin_unlock_bh(&tgt->tgt_lock);
 			rc = bnx2fc_post_io_req(tgt, new_io_req);
-			spin_lock_bh(&tgt->tgt_lock);
 			if (!rc)
 				goto free_frame;
 			BNX2FC_IO_DBG(rec_req, "REC: io post err\n");
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 0679782..5b99844 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1894,18 +1894,24 @@ int bnx2fc_queuecommand(struct Scsi_Host *host,
 			goto exit_qcmd;
 		}
 	}
+
+	spin_lock_bh(&tgt->tgt_lock);
+
 	io_req = bnx2fc_cmd_alloc(tgt);
 	if (!io_req) {
 		rc = SCSI_MLQUEUE_HOST_BUSY;
-		goto exit_qcmd;
+		goto exit_qcmd_tgtlock;
 	}
 	io_req->sc_cmd = sc_cmd;
 
 	if (bnx2fc_post_io_req(tgt, io_req)) {
 		printk(KERN_ERR PFX "Unable to post io_req\n");
 		rc = SCSI_MLQUEUE_HOST_BUSY;
-		goto exit_qcmd;
+		goto exit_qcmd_tgtlock;
 	}
+
+exit_qcmd_tgtlock:
+	spin_unlock_bh(&tgt->tgt_lock);
 exit_qcmd:
 	return rc;
 }
@@ -2020,6 +2026,8 @@ int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
 	int task_idx, index;
 	u16 xid;
 
+	/* bnx2fc_post_io_req() is called with the tgt_lock held */
+
 	/* Initialize rest of io_req fields */
 	io_req->cmd_type = BNX2FC_SCSI_CMD;
 	io_req->port = port;
@@ -2047,9 +2055,7 @@ int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
 	/* Build buffer descriptor list for firmware from sg list */
 	if (bnx2fc_build_bd_list_from_sg(io_req)) {
 		printk(KERN_ERR PFX "BD list creation failed\n");
-		spin_lock_bh(&tgt->tgt_lock);
 		kref_put(&io_req->refcount, bnx2fc_cmd_release);
-		spin_unlock_bh(&tgt->tgt_lock);
 		return -EAGAIN;
 	}
 
@@ -2061,19 +2067,15 @@ int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
 	task = &(task_page[index]);
 	bnx2fc_init_task(io_req, task);
 
-	spin_lock_bh(&tgt->tgt_lock);
-
 	if (tgt->flush_in_prog) {
 		printk(KERN_ERR PFX "Flush in progress..Host Busy\n");
 		kref_put(&io_req->refcount, bnx2fc_cmd_release);
-		spin_unlock_bh(&tgt->tgt_lock);
 		return -EAGAIN;
 	}
 
 	if (!test_bit(BNX2FC_FLAG_SESSION_READY, &tgt->flags)) {
 		printk(KERN_ERR PFX "Session not ready...post_io\n");
 		kref_put(&io_req->refcount, bnx2fc_cmd_release);
-		spin_unlock_bh(&tgt->tgt_lock);
 		return -EAGAIN;
 	}
 
@@ -2091,6 +2093,5 @@ int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
 
 	/* Ring doorbell */
 	bnx2fc_ring_doorbell(tgt);
-	spin_unlock_bh(&tgt->tgt_lock);
 	return 0;
 }
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 3e0a0d3..81bb3bd 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -936,20 +936,23 @@ static void do_abort_req_rss(struct cxgbi_device *cdev, struct sk_buff *skb)
 	cxgbi_sock_get(csk);
 	spin_lock_bh(&csk->lock);
 
-	if (!cxgbi_sock_flag(csk, CTPF_ABORT_REQ_RCVD)) {
-		cxgbi_sock_set_flag(csk, CTPF_ABORT_REQ_RCVD);
-		cxgbi_sock_set_state(csk, CTP_ABORTING);
-		goto done;
+	cxgbi_sock_clear_flag(csk, CTPF_ABORT_REQ_RCVD);
+
+	if (!cxgbi_sock_flag(csk, CTPF_TX_DATA_SENT)) {
+		send_tx_flowc_wr(csk);
+		cxgbi_sock_set_flag(csk, CTPF_TX_DATA_SENT);
 	}
 
-	cxgbi_sock_clear_flag(csk, CTPF_ABORT_REQ_RCVD);
+	cxgbi_sock_set_flag(csk, CTPF_ABORT_REQ_RCVD);
+	cxgbi_sock_set_state(csk, CTP_ABORTING);
+
 	send_abort_rpl(csk, rst_status);
 
 	if (!cxgbi_sock_flag(csk, CTPF_ABORT_RPL_PENDING)) {
 		csk->err = abort_status_to_errno(csk, req->status, &rst_status);
 		cxgbi_sock_closed(csk);
 	}
-done:
+
 	spin_unlock_bh(&csk->lock);
 	cxgbi_sock_put(csk);
 rel_skb:
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 674d498..13d869a 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -905,18 +905,16 @@ void cxgbi_sock_rcv_abort_rpl(struct cxgbi_sock *csk)
 {
 	cxgbi_sock_get(csk);
 	spin_lock_bh(&csk->lock);
+
+	cxgbi_sock_set_flag(csk, CTPF_ABORT_RPL_RCVD);
 	if (cxgbi_sock_flag(csk, CTPF_ABORT_RPL_PENDING)) {
-		if (!cxgbi_sock_flag(csk, CTPF_ABORT_RPL_RCVD))
-			cxgbi_sock_set_flag(csk, CTPF_ABORT_RPL_RCVD);
-		else {
-			cxgbi_sock_clear_flag(csk, CTPF_ABORT_RPL_RCVD);
-			cxgbi_sock_clear_flag(csk, CTPF_ABORT_RPL_PENDING);
-			if (cxgbi_sock_flag(csk, CTPF_ABORT_REQ_RCVD))
-				pr_err("csk 0x%p,%u,0x%lx,%u,ABT_RPL_RSS.\n",
-					csk, csk->state, csk->flags, csk->tid);
-			cxgbi_sock_closed(csk);
-		}
+		cxgbi_sock_clear_flag(csk, CTPF_ABORT_RPL_PENDING);
+		if (cxgbi_sock_flag(csk, CTPF_ABORT_REQ_RCVD))
+			pr_err("csk 0x%p,%u,0x%lx,%u,ABT_RPL_RSS.\n",
+			       csk, csk->state, csk->flags, csk->tid);
+		cxgbi_sock_closed(csk);
 	}
+
 	spin_unlock_bh(&csk->lock);
 	cxgbi_sock_put(csk);
 }
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index e99507e..fd78bdc 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -474,6 +474,13 @@ static int alua_check_sense(struct scsi_device *sdev,
 			 * LUN Not Ready -- Offline
 			 */
 			return SUCCESS;
+		if (sdev->allow_restart &&
+		    sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x02)
+			/*
+			 * if the device is not started, we need to wake
+			 * the error handler to start the motor
+			 */
+			return FAILED;
 		break;
 	case UNIT_ATTENTION:
 		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f6a69a3..5640ad1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4453,7 +4453,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			instance->msixentry[i].entry = i;
 		i = pci_enable_msix_range(instance->pdev, instance->msixentry,
 					  1, instance->msix_vectors);
-		if (i)
+		if (i > 0)
 			instance->msix_vectors = i;
 		else
 			instance->msix_vectors = 0;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 9a6f846..bc5ff6f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -459,14 +459,6 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
 		return FAILED;	/* no valid sense data */
 
-	if (scmd->cmnd[0] == TEST_UNIT_READY && scmd->scsi_done != scsi_eh_done)
-		/*
-		 * nasty: for mid-layer issued TURs, we need to return the
-		 * actual sense data without any recovery attempt.  For eh
-		 * issued ones, we need to try to recover and interpret
-		 */
-		return SUCCESS;
-
 	scsi_report_sense(sdev, &sshdr);
 
 	if (scsi_sense_is_deferred(&sshdr))
@@ -482,6 +474,14 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		/* handler does not care. Drop down to default handling */
 	}
 
+	if (scmd->cmnd[0] == TEST_UNIT_READY && scmd->scsi_done != scsi_eh_done)
+		/*
+		 * nasty: for mid-layer issued TURs, we need to return the
+		 * actual sense data without any recovery attempt.  For eh
+		 * issued ones, we need to try to recover and interpret
+		 */
+		return SUCCESS;
+
 	/*
 	 * Previous logic looked for FILEMARK, EOM or ILI which are
 	 * mainly associated with tapes and returned SUCCESS.
@@ -2001,8 +2001,10 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
 	 * is no point trying to lock the door of an off-line device.
 	 */
 	shost_for_each_device(sdev, shost) {
-		if (scsi_device_online(sdev) && sdev->locked)
+		if (scsi_device_online(sdev) && sdev->was_reset && sdev->locked) {
 			scsi_eh_lock_door(sdev);
+			sdev->was_reset = 0;
+		}
 	}
 
 	/*
