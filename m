From: Hiral Patel <hiralpat@cisco.com>
Subject: [PATCH 5/9] fnic: Hitting BUG_ON(io_req->abts_done) in fnic_rport_exch_reset
Date: Mon,  9 Sep 2013 13:31:49 -0700
Message-ID: <1378758713-22443-5-git-send-email-hiralpat@cisco.com>
References: <1378758713-22443-1-git-send-email-hiralpat@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-6.cisco.com ([173.37.86.77]:24198 "EHLO
	rcdn-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab3IIUgW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Sep 2013 16:36:22 -0400
In-Reply-To: <1378758713-22443-1-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Sesidhar Beddel <sebaddel@cisco.com>, Hiral Patel <hiralpat@cisco.com>

From: Sesidhar Beddel <sebaddel@cisco.com>

Hitting BUG_ON(io_req->abts_done) in fnic_rport_exch_reset in case of
timing issue and also to some extent locking issue where abts and terminate
is happening around same timing.

The code changes are intended to update CMD_STATE(sc) and
io_req->abts_done together.

Signed-off-by: Sesidhar Beddel <sebaddel@cisco.com>
Signed-off-by: Hiral Patel <hiralpat@cisco.com>
---
 drivers/scsi/fnic/fnic_scsi.c |   70 ++++++++++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index a09dd8d..100cdba 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -111,6 +111,12 @@ static inline spinlock_t *fnic_io_lock_hash(struct fnic *fnic,
 	return &fnic->io_req_lock[hash];
 }
 
+static inline spinlock_t *fnic_io_lock_tag(struct fnic *fnic,
+					    int tag)
+{
+	return &fnic->io_req_lock[tag & (FNIC_IO_LOCKS - 1)];
+}
+
 /*
  * Unmap the data buffer and sense buffer for an io_req,
  * also unmap and free the device-private scatter/gather list.
@@ -956,9 +962,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 			spin_unlock_irqrestore(io_lock, flags);
 			return;
 		}
-		CMD_STATE(sc) = FNIC_IOREQ_ABTS_COMPLETE;
 		CMD_ABTS_STATUS(sc) = hdr_status;
-
 		CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_DONE;
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 			      "abts cmpl recd. id %d status %s\n",
@@ -1116,7 +1120,7 @@ int fnic_wq_copy_cmpl_handler(struct fnic *fnic, int copy_work_to_do)
 
 static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
 {
-	unsigned int i;
+	int i;
 	struct fnic_io_req *io_req;
 	unsigned long flags = 0;
 	struct scsi_cmnd *sc;
@@ -1127,12 +1131,14 @@ static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
 		if (i == exclude_id)
 			continue;
 
+		io_lock = fnic_io_lock_tag(fnic, i);
+		spin_lock_irqsave(io_lock, flags);
 		sc = scsi_host_find_tag(fnic->lport->host, i);
-		if (!sc)
+		if (!sc) {
+			spin_unlock_irqrestore(io_lock, flags);
 			continue;
+		}
 
-		io_lock = fnic_io_lock_hash(fnic, sc);
-		spin_lock_irqsave(io_lock, flags);
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
 		if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
 			!(CMD_FLAGS(sc) & FNIC_DEV_RST_DONE)) {
@@ -1310,12 +1316,13 @@ static void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 
 	for (tag = 0; tag < FNIC_MAX_IO_REQ; tag++) {
 		abt_tag = tag;
+		io_lock = fnic_io_lock_tag(fnic, tag);
+		spin_lock_irqsave(io_lock, flags);
 		sc = scsi_host_find_tag(fnic->lport->host, tag);
-		if (!sc)
+		if (!sc) {
+			spin_unlock_irqrestore(io_lock, flags);
 			continue;
-
-		io_lock = fnic_io_lock_hash(fnic, sc);
-		spin_lock_irqsave(io_lock, flags);
+		}
 
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
 
@@ -1426,16 +1433,19 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 
 	for (tag = 0; tag < FNIC_MAX_IO_REQ; tag++) {
 		abt_tag = tag;
+		io_lock = fnic_io_lock_tag(fnic, tag);
+		spin_lock_irqsave(io_lock, flags);
 		sc = scsi_host_find_tag(fnic->lport->host, tag);
-		if (!sc)
+		if (!sc) {
+			spin_unlock_irqrestore(io_lock, flags);
 			continue;
+		}
 
 		cmd_rport = starget_to_rport(scsi_target(sc->device));
-		if (rport != cmd_rport)
+		if (rport != cmd_rport) {
+			spin_unlock_irqrestore(io_lock, flags);
 			continue;
-
-		io_lock = fnic_io_lock_hash(fnic, sc);
-		spin_lock_irqsave(io_lock, flags);
+		}
 
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
 
@@ -1648,13 +1658,15 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	io_req->abts_done = NULL;
 
 	/* fw did not complete abort, timed out */
-	if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING) {
+	if (CMD_ABTS_STATUS(sc) == FCPIO_INVALID_CODE) {
 		spin_unlock_irqrestore(io_lock, flags);
 		CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_TIMED_OUT;
 		ret = FAILED;
 		goto fnic_abort_cmd_end;
 	}
 
+	CMD_STATE(sc) = FNIC_IOREQ_ABTS_COMPLETE;
+
 	/*
 	 * firmware completed the abort, check the status,
 	 * free the io_req irrespective of failure or success
@@ -1753,16 +1765,17 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 	enum fnic_ioreq_state old_ioreq_state;
 
 	for (tag = 0; tag < FNIC_MAX_IO_REQ; tag++) {
+		io_lock = fnic_io_lock_tag(fnic, tag);
+		spin_lock_irqsave(io_lock, flags);
 		sc = scsi_host_find_tag(fnic->lport->host, tag);
 		/*
 		 * ignore this lun reset cmd or cmds that do not belong to
 		 * this lun
 		 */
-		if (!sc || sc == lr_sc || sc->device != lun_dev)
+		if (!sc || sc == lr_sc || sc->device != lun_dev) {
+			spin_unlock_irqrestore(io_lock, flags);
 			continue;
-
-		io_lock = fnic_io_lock_hash(fnic, sc);
-		spin_lock_irqsave(io_lock, flags);
+		}
 
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
 
@@ -1791,6 +1804,11 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 			spin_unlock_irqrestore(io_lock, flags);
 			continue;
 		}
+
+		if (io_req->abts_done)
+			shost_printk(KERN_ERR, fnic->lport->host,
+			  "%s: io_req->abts_done is set state is %s\n",
+			  __func__, fnic_ioreq_state_to_str(CMD_STATE(sc)));
 		old_ioreq_state = CMD_STATE(sc);
 		/*
 		 * Any pending IO issued prior to reset is expected to be
@@ -1801,11 +1819,6 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 		 */
 		CMD_STATE(sc) = FNIC_IOREQ_ABTS_PENDING;
 
-		if (io_req->abts_done)
-			shost_printk(KERN_ERR, fnic->lport->host,
-			  "%s: io_req->abts_done is set state is %s\n",
-			  __func__, fnic_ioreq_state_to_str(CMD_STATE(sc)));
-
 		BUG_ON(io_req->abts_done);
 
 		abt_tag = tag;
@@ -1858,12 +1871,13 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 		io_req->abts_done = NULL;
 
 		/* if abort is still pending with fw, fail */
-		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING) {
+		if (CMD_ABTS_STATUS(sc) == FCPIO_INVALID_CODE) {
 			spin_unlock_irqrestore(io_lock, flags);
 			CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_DONE;
 			ret = 1;
 			goto clean_pending_aborts_end;
 		}
+		CMD_STATE(sc) = FNIC_IOREQ_ABTS_COMPLETE;
 		CMD_SP(sc) = NULL;
 		spin_unlock_irqrestore(io_lock, flags);
 
@@ -2061,8 +2075,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		spin_unlock_irqrestore(io_lock, flags);
 		int_to_scsilun(sc->device->lun, &fc_lun);
 		/*
-		 * Issue abort and terminate on the device reset request.
-		 * If q'ing of the abort fails, retry issue it after a delay.
+		 * Issue abort and terminate on device reset request.
+		 * If q'ing of terminate fails, retry it after a delay.
 		 */
 		while (1) {
 			spin_lock_irqsave(io_lock, flags);
-- 
1.7.10.4

