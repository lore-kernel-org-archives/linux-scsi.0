From: Hiral Patel <hiralpat@cisco.com>
Subject: [PATCH 06/10] fnic: New debug flags and debug log messages
Date: Tue, 29 Jan 2013 16:05:19 -0800
Message-ID: <1359504323-14453-4-git-send-email-hiralpat@cisco.com>
References: <1359504323-14453-1-git-send-email-hiralpat@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtv-iport-1.cisco.com ([173.36.130.12]:36759 "EHLO
	mtv-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3A3AU3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jan 2013 19:20:29 -0500
In-Reply-To: <1359504323-14453-1-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, JBottomley@Parallels.com
Cc: Hiral Patel <hiralpat@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>

Added new fnic debug flags for identifying IO state at every stage of IO while debugging
and also added more log messages for better debugging capability.

Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
Signed-off-by: Hiral Patel <hiralpat@cisco.com>
---
 drivers/scsi/fnic/fnic.h      |   31 ++++++++---
 drivers/scsi/fnic/fnic_io.h   |    4 +-
 drivers/scsi/fnic/fnic_scsi.c |  121 +++++++++++++++++++++++++++++++++++++----
 3 files changed, 135 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index b8e6644..9c95a1a 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -59,14 +59,29 @@
  * Command flags to identify the type of command and for other future
  * use.
  */
-#define FNIC_NO_FLAGS			0
-#define FNIC_CDB_REQ			BIT(1)	/* All IOs with a valid CDB */
-#define FNIC_BLOCKING_REQ		BIT(2)	/* All blocking Requests */
-#define FNIC_DEVICE_RESET		BIT(3)	/* Device reset request */
-#define FNIC_DEV_RST_PENDING		BIT(4)	/* Device reset pending */
-#define FNIC_DEV_RST_TIMED_OUT		BIT(5)	/* Device reset timed out */
-#define FNIC_DEV_RST_TERM_ISSUED	BIT(6)	/* Device reset terminate */
-#define FNIC_DEV_RST_DONE		BIT(7)	/* Device reset done */
+#define FNIC_NO_FLAGS                   0
+#define FNIC_IO_INITIALIZED             BIT(0)
+#define FNIC_IO_ISSUED                  BIT(1)
+#define FNIC_IO_DONE                    BIT(2)
+#define FNIC_IO_REQ_NULL                BIT(3)
+#define FNIC_IO_ABTS_PENDING            BIT(4)
+#define FNIC_IO_ABORTED                 BIT(5)
+#define FNIC_IO_ABTS_ISSUED             BIT(6)
+#define FNIC_IO_TERM_ISSUED             BIT(7)
+#define FNIC_IO_INTERNAL_TERM_ISSUED    BIT(8)
+#define FNIC_IO_ABT_TERM_DONE           BIT(9)
+#define FNIC_IO_ABT_TERM_REQ_NULL       BIT(10)
+#define FNIC_IO_ABT_TERM_TIMED_OUT      BIT(11)
+#define FNIC_DEVICE_RESET               BIT(12)  /* Device reset request */
+#define FNIC_DEV_RST_ISSUED             BIT(13)
+#define FNIC_DEV_RST_TIMED_OUT          BIT(14)
+#define FNIC_DEV_RST_ABTS_ISSUED        BIT(15)
+#define FNIC_DEV_RST_TERM_ISSUED        BIT(16)
+#define FNIC_DEV_RST_DONE               BIT(17)
+#define FNIC_DEV_RST_REQ_NULL           BIT(18)
+#define FNIC_DEV_RST_ABTS_DONE          BIT(19)
+#define FNIC_DEV_RST_TERM_DONE          BIT(20)
+#define FNIC_DEV_RST_ABTS_PENDING       BIT(21)
 
 /*
  * Usage of the scsi_cmnd scratchpad.
diff --git a/drivers/scsi/fnic/fnic_io.h b/drivers/scsi/fnic/fnic_io.h
index 3455c34..c35b8f1 100644
--- a/drivers/scsi/fnic/fnic_io.h
+++ b/drivers/scsi/fnic/fnic_io.h
@@ -45,7 +45,8 @@ enum fnic_sgl_list_type {
 };
 
 enum fnic_ioreq_state {
-	FNIC_IOREQ_CMD_PENDING = 0,
+	FNIC_IOREQ_NOT_INITED = 0,
+	FNIC_IOREQ_CMD_PENDING,
 	FNIC_IOREQ_ABTS_PENDING,
 	FNIC_IOREQ_ABTS_COMPLETE,
 	FNIC_IOREQ_CMD_COMPLETE,
@@ -60,6 +61,7 @@ struct fnic_io_req {
 	u8 sgl_type; /* device DMA descriptor list type */
 	u8 io_completed:1; /* set to 1 when fw completes IO */
 	u32 port_id; /* remote port DID */
+	unsigned long start_time; /* in jiffies */
 	struct completion *abts_done; /* completion for abts */
 	struct completion *dr_done; /* completion for device reset */
 };
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 6483081..661efa4 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -47,6 +47,7 @@ const char *fnic_state_str[] = {
 };
 
 static const char *fnic_ioreq_state_str[] = {
+	[FNIC_IOREQ_NOT_INITED] = "FNIC_IOREQ_NOT_INITED",
 	[FNIC_IOREQ_CMD_PENDING] = "FNIC_IOREQ_CMD_PENDING",
 	[FNIC_IOREQ_ABTS_PENDING] = "FNIC_IOREQ_ABTS_PENDING",
 	[FNIC_IOREQ_ABTS_COMPLETE] = "FNIC_IOREQ_ABTS_COMPLETE",
@@ -349,6 +350,8 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 
 	if (unlikely(!vnic_wq_copy_desc_avail(wq))) {
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[0], intr_flags);
+		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
+			  "fnic_queue_wq_copy_desc failure - no descriptors\n");
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -420,7 +423,8 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	 * caller disabling them.
 	 */
 	spin_unlock(lp->host->host_lock);
-	CMD_FLAGS(sc) = FNIC_CDB_REQ;
+	CMD_STATE(sc) = FNIC_IOREQ_NOT_INITED;
+	CMD_FLAGS(sc) = FNIC_NO_FLAGS;
 
 	/* Get a new io_req for this SCSI IO */
 	io_req = mempool_alloc(fnic->io_req_pool, GFP_ATOMIC);
@@ -467,8 +471,10 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 
 	/* initialize rest of io_req */
 	io_req->port_id = rport->port_id;
+	io_req->start_time = jiffies;
 	CMD_STATE(sc) = FNIC_IOREQ_CMD_PENDING;
 	CMD_SP(sc) = (char *)io_req;
+	CMD_FLAGS(sc) |= FNIC_IO_INITIALIZED;
 	sc->scsi_done = done;
 
 	/* create copy wq desc and enqueue it */
@@ -490,6 +496,9 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 			fnic_release_ioreq_buf(fnic, io_req, sc);
 			mempool_free(io_req, fnic->io_req_pool);
 		}
+	} else {
+		/* REVISIT: Use per IO lock in the final code */
+		CMD_FLAGS(sc) |= FNIC_IO_ISSUED;
 	}
 out:
 	atomic_dec(&fnic->in_flight);
@@ -694,10 +703,12 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 	struct scsi_cmnd *sc;
 	unsigned long flags;
 	spinlock_t *io_lock;
+	unsigned long start_time;
 
 	/* Decode the cmpl description to get the io_req id */
 	fcpio_header_dec(&desc->hdr, &type, &hdr_status, &tag);
 	fcpio_tag_id_dec(&tag, &id);
+	icmnd_cmpl = &desc->u.icmnd_cmpl;
 
 	if (id >= FNIC_MAX_IO_REQ) {
 		shost_printk(KERN_ERR, fnic->lport->host,
@@ -708,17 +719,28 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 
 	sc = scsi_host_find_tag(fnic->lport->host, id);
 	WARN_ON_ONCE(!sc);
-	if (!sc)
+	if (!sc) {
+		shost_printk(KERN_ERR, fnic->lport->host,
+			  "icmnd_cmpl sc is null - "
+			  "hdr status = %s tag = 0x%x desc = 0x%p\n",
+			  fnic_fcpio_status_to_str(hdr_status), id, desc);
 		return;
+	}
 
 	io_lock = fnic_io_lock_hash(fnic, sc);
 	spin_lock_irqsave(io_lock, flags);
 	io_req = (struct fnic_io_req *)CMD_SP(sc);
 	WARN_ON_ONCE(!io_req);
 	if (!io_req) {
+		CMD_FLAGS(sc) |= FNIC_IO_REQ_NULL;
 		spin_unlock_irqrestore(io_lock, flags);
+		shost_printk(KERN_ERR, fnic->lport->host,
+			  "icmnd_cmpl io_req is null - "
+			  "hdr status = %s tag = 0x%x sc 0x%p\n",
+			  fnic_fcpio_status_to_str(hdr_status), id, sc);
 		return;
 	}
+	start_time = io_req->start_time;
 
 	/* firmware completed the io */
 	io_req->io_completed = 1;
@@ -729,6 +751,31 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 	 */
 	if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING) {
 		spin_unlock_irqrestore(io_lock, flags);
+		CMD_FLAGS(sc) |= FNIC_IO_ABTS_PENDING;
+		switch (hdr_status) {
+		case FCPIO_SUCCESS:
+			CMD_FLAGS(sc) |= FNIC_IO_DONE;
+			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
+				  "icmnd_cmpl ABTS pending hdr status = %s "
+				  "sc  0x%p scsi_status %x  residual %d\n",
+				  fnic_fcpio_status_to_str(hdr_status), sc,
+				  icmnd_cmpl->scsi_status,
+				  icmnd_cmpl->residual);
+			break;
+		case FCPIO_ABORTED:
+			CMD_FLAGS(sc) |= FNIC_IO_ABORTED;
+			break;
+		default:
+			if (hdr_status != FCPIO_SUCCESS ||
+				  hdr_status != FCPIO_ABORTED) {
+				FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
+					  "icmnd_cmpl abts pending "
+					  "hdr status = %s tag = 0x%x sc = 0x%p\n",
+					  fnic_fcpio_status_to_str(hdr_status),
+					  id, sc);
+			}
+			break;
+		}
 		return;
 	}
 
@@ -812,6 +859,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 
 	/* Break link with the SCSI command */
 	CMD_SP(sc) = NULL;
+	CMD_FLAGS(sc) |= FNIC_IO_DONE;
 
 	spin_unlock_irqrestore(io_lock, flags);
 
@@ -848,6 +896,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 	struct fnic_io_req *io_req;
 	unsigned long flags;
 	spinlock_t *io_lock;
+	unsigned long start_time;
 
 	fcpio_header_dec(&desc->hdr, &type, &hdr_status, &tag);
 	fcpio_tag_id_dec(&tag, &id);
@@ -861,17 +910,26 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 
 	sc = scsi_host_find_tag(fnic->lport->host, id & FNIC_TAG_MASK);
 	WARN_ON_ONCE(!sc);
-	if (!sc)
+	if (!sc) {
+		shost_printk(KERN_ERR, fnic->lport->host,
+			  "itmf_cmpl sc is null - hdr status = %s tag = 0x%x\n",
+			  fnic_fcpio_status_to_str(hdr_status), id);
 		return;
-
+	}
 	io_lock = fnic_io_lock_hash(fnic, sc);
 	spin_lock_irqsave(io_lock, flags);
 	io_req = (struct fnic_io_req *)CMD_SP(sc);
 	WARN_ON_ONCE(!io_req);
 	if (!io_req) {
 		spin_unlock_irqrestore(io_lock, flags);
+		CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_REQ_NULL;
+		shost_printk(KERN_ERR, fnic->lport->host,
+			  "itmf_cmpl io_req is null - "
+			  "hdr status = %s tag = 0x%x sc 0x%p\n",
+			  fnic_fcpio_status_to_str(hdr_status), id, sc);
 		return;
 	}
+	start_time = io_req->start_time;
 
 	if ((id & FNIC_TAG_ABORT) && (id & FNIC_TAG_DEV_RST)) {
 		/* Abort and terminate completion of device reset req */
@@ -895,6 +953,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 		CMD_STATE(sc) = FNIC_IOREQ_ABTS_COMPLETE;
 		CMD_ABTS_STATUS(sc) = hdr_status;
 
+		CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_DONE;
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 			      "abts cmpl recd. id %d status %s\n",
 			      (int)(id & FNIC_TAG_MASK),
@@ -927,6 +986,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 		CMD_LR_STATUS(sc) = hdr_status;
 		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING) {
 			spin_unlock_irqrestore(io_lock, flags);
+			CMD_FLAGS(sc) |= FNIC_DEV_RST_ABTS_PENDING;
 			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 				"Terminate pending "
 				"dev reset cmpl recd. id %d status %s\n",
@@ -1032,6 +1092,7 @@ static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
 	unsigned long flags = 0;
 	struct scsi_cmnd *sc;
 	spinlock_t *io_lock;
+	unsigned long start_time = 0;
 
 	for (i = 0; i < FNIC_MAX_IO_REQ; i++) {
 		if (i == exclude_id)
@@ -1074,6 +1135,7 @@ static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
 		 * If there is a scsi_cmnd associated with this io_req, then
 		 * free the corresponding state
 		 */
+		start_time = io_req->start_time;
 		fnic_release_ioreq_buf(fnic, io_req, sc);
 		mempool_free(io_req, fnic->io_req_pool);
 
@@ -1097,6 +1159,7 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
 	struct scsi_cmnd *sc;
 	unsigned long flags;
 	spinlock_t *io_lock;
+	unsigned long start_time = 0;
 
 	/* get the tag reference */
 	fcpio_tag_id_dec(&desc->hdr.tag, &id);
@@ -1126,6 +1189,7 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
 
 	spin_unlock_irqrestore(io_lock, flags);
 
+	start_time = io_req->start_time;
 	fnic_release_ioreq_buf(fnic, io_req, sc);
 	mempool_free(io_req, fnic->io_req_pool);
 
@@ -1163,7 +1227,7 @@ static inline int fnic_queue_abort_io_req(struct fnic *fnic, int tag,
 	if (!vnic_wq_copy_desc_avail(wq)) {
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[0], flags);
 		atomic_dec(&fnic->in_flight);
-		shost_printk(KERN_DEBUG, fnic->lport->host,
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 			"fnic_queue_abort_io_req: failure: no descriptors\n");
 		return 1;
 	}
@@ -1213,7 +1277,7 @@ static void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 		}
 
 		if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
-			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_PENDING))) {
+			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
 			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 			"fnic_rport_exch_reset dev rst not pending sc 0x%p\n",
 			sc);
@@ -1236,6 +1300,13 @@ static void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 			fnic_ioreq_state_to_str(CMD_STATE(sc)));
 		}
 
+		if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED)) {
+			shost_printk(KERN_ERR, fnic->lport->host,
+				  "rport_exch_reset "
+				  "IO not yet issued %p tag 0x%x flags "
+				  "%x state %d\n",
+				  sc, tag, CMD_FLAGS(sc), CMD_STATE(sc));
+		}
 		old_ioreq_state = CMD_STATE(sc);
 		CMD_STATE(sc) = FNIC_IOREQ_ABTS_PENDING;
 		CMD_ABTS_STATUS(sc) = FCPIO_INVALID_CODE;
@@ -1273,6 +1344,8 @@ static void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 			spin_lock_irqsave(io_lock, flags);
 			if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET)
 				CMD_FLAGS(sc) |= FNIC_DEV_RST_TERM_ISSUED;
+			else
+				CMD_FLAGS(sc) |= FNIC_IO_INTERNAL_TERM_ISSUED;
 			spin_unlock_irqrestore(io_lock, flags);
 		}
 	}
@@ -1324,7 +1397,7 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 		}
 
 		if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
-			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_PENDING))) {
+			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
 			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 			"fnic_terminate_rport_io dev rst not pending sc 0x%p\n",
 			sc);
@@ -1345,6 +1418,13 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 			"state is %s\n",
 			fnic_ioreq_state_to_str(CMD_STATE(sc)));
 		}
+		if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED)) {
+			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
+				  "fnic_terminate_rport_io "
+				  "IO not yet issued %p tag 0x%x flags "
+				  "%x state %d\n",
+				  sc, tag, CMD_FLAGS(sc), CMD_STATE(sc));
+		}
 		old_ioreq_state = CMD_STATE(sc);
 		CMD_STATE(sc) = FNIC_IOREQ_ABTS_PENDING;
 		CMD_ABTS_STATUS(sc) = FCPIO_INVALID_CODE;
@@ -1382,6 +1462,8 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 			spin_lock_irqsave(io_lock, flags);
 			if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET)
 				CMD_FLAGS(sc) |= FNIC_DEV_RST_TERM_ISSUED;
+			else
+				CMD_FLAGS(sc) |= FNIC_IO_INTERNAL_TERM_ISSUED;
 			spin_unlock_irqrestore(io_lock, flags);
 		}
 	}
@@ -1401,8 +1483,9 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	struct fc_rport *rport;
 	spinlock_t *io_lock;
 	unsigned long flags;
+	unsigned long start_time = 0;
 	int ret = SUCCESS;
-	u32 task_req;
+	u32 task_req = 0;
 	struct scsi_lun fc_lun;
 	int tag;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
@@ -1489,6 +1572,10 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 		ret = FAILED;
 		goto fnic_abort_cmd_end;
 	}
+	if (task_req == FCPIO_ITMF_ABT_TASK)
+		CMD_FLAGS(sc) |= FNIC_IO_ABTS_ISSUED;
+	else
+		CMD_FLAGS(sc) |= FNIC_IO_TERM_ISSUED;
 
 	/*
 	 * We queued an abort IO, wait for its completion.
@@ -1507,6 +1594,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	io_req = (struct fnic_io_req *)CMD_SP(sc);
 	if (!io_req) {
 		spin_unlock_irqrestore(io_lock, flags);
+		CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_REQ_NULL;
 		ret = FAILED;
 		goto fnic_abort_cmd_end;
 	}
@@ -1515,6 +1603,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	/* fw did not complete abort, timed out */
 	if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING) {
 		spin_unlock_irqrestore(io_lock, flags);
+		CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_TIMED_OUT;
 		ret = FAILED;
 		goto fnic_abort_cmd_end;
 	}
@@ -1530,12 +1619,13 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 
 	spin_unlock_irqrestore(io_lock, flags);
 
+	start_time = io_req->start_time;
 	fnic_release_ioreq_buf(fnic, io_req, sc);
 	mempool_free(io_req, fnic->io_req_pool);
 
 fnic_abort_cmd_end:
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-		      "Returning from abort cmd %s\n",
+		      "Returning from abort cmd type %x %s\n", task_req,
 		      (ret == SUCCESS) ?
 		      "SUCCESS" : "FAILED");
 	return ret;
@@ -1566,6 +1656,8 @@ static inline int fnic_queue_dr_io_req(struct fnic *fnic,
 		free_wq_copy_descs(fnic, wq);
 
 	if (!vnic_wq_copy_desc_avail(wq)) {
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			  "queue_dr_io_req failure - no descriptors\n");
 		ret = -EAGAIN;
 		goto lr_io_req_end;
 	}
@@ -1637,7 +1729,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 			continue;
 		}
 		if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
-			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_PENDING))) {
+			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
 			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
 				"%s dev rst not pending sc 0x%p\n", __func__,
 				sc);
@@ -1693,6 +1785,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 				CMD_FLAGS(sc) |= FNIC_DEV_RST_TERM_ISSUED;
 			spin_unlock_irqrestore(io_lock, flags);
 		}
+		CMD_FLAGS(sc) |= FNIC_IO_INTERNAL_TERM_ISSUED;
 
 		wait_for_completion_timeout(&tm_done,
 					    msecs_to_jiffies
@@ -1703,6 +1796,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
 		if (!io_req) {
 			spin_unlock_irqrestore(io_lock, flags);
+			CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_REQ_NULL;
 			continue;
 		}
 
@@ -1711,6 +1805,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 		/* if abort is still pending with fw, fail */
 		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING) {
 			spin_unlock_irqrestore(io_lock, flags);
+			CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_DONE;
 			ret = 1;
 			goto clean_pending_aborts_end;
 		}
@@ -1805,6 +1900,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	int ret = FAILED;
 	spinlock_t *io_lock;
 	unsigned long flags;
+	unsigned long start_time = 0;
 	struct scsi_lun fc_lun;
 	int tag;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
@@ -1830,7 +1926,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	if (fc_remote_port_chkready(rport))
 		goto fnic_device_reset_end;
 
-	CMD_FLAGS(sc) = (FNIC_DEVICE_RESET | FNIC_BLOCKING_REQ);
+	CMD_FLAGS(sc) = FNIC_DEVICE_RESET;
 	/* Allocate tag if not present */
 
 	tag = sc->request->tag;
@@ -1877,7 +1973,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		goto fnic_device_reset_clean;
 	}
 	spin_lock_irqsave(io_lock, flags);
-	CMD_FLAGS(sc) |= FNIC_DEV_RST_PENDING;
+	CMD_FLAGS(sc) |= FNIC_DEV_RST_ISSUED;
 	spin_unlock_irqrestore(io_lock, flags);
 
 	/*
@@ -1995,6 +2091,7 @@ fnic_device_reset_clean:
 	spin_unlock_irqrestore(io_lock, flags);
 
 	if (io_req) {
+		start_time = io_req->start_time;
 		fnic_release_ioreq_buf(fnic, io_req, sc);
 		mempool_free(io_req, fnic->io_req_pool);
 	}
-- 
1.7.9.5

