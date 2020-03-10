Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D714C10F27
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D64FA20727
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgCJQaw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:30:52 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35840 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726891AbgCJQau (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 12:30:50 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0E58D62E74A60E8AFCD6;
        Wed, 11 Mar 2020 00:30:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 11 Mar 2020 00:30:26 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hch@infradead.org>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH RFC v2 09/24] fnic: use reserved commands
Date:   Wed, 11 Mar 2020 00:25:35 +0800
Message-ID: <1583857550-12049-10-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

Remove hack to get tag for the reset command by using reserved
commands.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 377 ++++++++++++++++------------------
 1 file changed, 172 insertions(+), 205 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index b60795893994..e96c4bbf2374 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2118,165 +2118,174 @@ static inline int fnic_queue_dr_io_req(struct fnic *fnic,
 	return ret;
 }
 
-/*
- * Clean up any pending aborts on the lun
- * For each outstanding IO on this lun, whose abort is not completed by fw,
- * issue a local abort. Wait for abort to complete. Return 0 if all commands
- * successfully aborted, 1 otherwise
- */
-static int fnic_clean_pending_aborts(struct fnic *fnic,
-				     struct scsi_cmnd *lr_sc,
-					 bool new_sc)
+struct fnic_pending_aborts_iter_data {
+	struct fnic *fnic;
+	struct scsi_device *lun_dev;
+	int ret;
+};
 
+static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc,
+				     void *data, bool reserved)
 {
-	int tag, abt_tag;
+	struct fnic_pending_aborts_iter_data *iter_data = data;
+	struct fnic *fnic = iter_data->fnic;
+	struct scsi_device *lun_dev = iter_data->lun_dev;
+	int abt_tag = sc->request->tag;
 	struct fnic_io_req *io_req;
 	spinlock_t *io_lock;
 	unsigned long flags;
-	int ret = 0;
-	struct scsi_cmnd *sc;
 	struct scsi_lun fc_lun;
-	struct scsi_device *lun_dev = lr_sc->device;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 	enum fnic_ioreq_state old_ioreq_state;
 
-	for (tag = 0; tag < fnic->fnic_max_tag_id; tag++) {
-		io_lock = fnic_io_lock_tag(fnic, tag);
-		spin_lock_irqsave(io_lock, flags);
-		sc = scsi_host_find_tag(fnic->lport->host, tag);
-		/*
-		 * ignore this lun reset cmd if issued using new SC
-		 * or cmds that do not belong to this lun
-		 */
-		if (!sc || ((sc == lr_sc) && new_sc) || sc->device != lun_dev) {
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
-
-		io_req = (struct fnic_io_req *)CMD_SP(sc);
+	if (sc->device != lun_dev)
+		return true;
+	if (reserved)
+		return true;
 
-		if (!io_req || sc->device != lun_dev) {
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
-
-		/*
-		 * Found IO that is still pending with firmware and
-		 * belongs to the LUN that we are resetting
-		 */
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "Found IO in %s on lun\n",
-			      fnic_ioreq_state_to_str(CMD_STATE(sc)));
-
-		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING) {
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
-		if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
-			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
-			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
-				"%s dev rst not pending sc 0x%p\n", __func__,
-				sc);
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
+	io_lock = fnic_io_lock_tag(fnic, abt_tag);
+	spin_lock_irqsave(io_lock, flags);
+	io_req = (struct fnic_io_req *)CMD_SP(sc);
+	if (!io_req) {
+		spin_unlock_irqrestore(io_lock, flags);
+		return true;
+	}
 
-		if (io_req->abts_done)
-			shost_printk(KERN_ERR, fnic->lport->host,
-			  "%s: io_req->abts_done is set state is %s\n",
-			  __func__, fnic_ioreq_state_to_str(CMD_STATE(sc)));
-		old_ioreq_state = CMD_STATE(sc);
-		/*
-		 * Any pending IO issued prior to reset is expected to be
-		 * in abts pending state, if not we need to set
-		 * FNIC_IOREQ_ABTS_PENDING to indicate the IO is abort pending.
-		 * When IO is completed, the IO will be handed over and
-		 * handled in this function.
-		 */
-		CMD_STATE(sc) = FNIC_IOREQ_ABTS_PENDING;
+	/*
+	 * Found IO that is still pending with firmware and
+	 * belongs to the LUN that we are resetting
+	 */
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		      "Found IO in %s on lun\n",
+		      fnic_ioreq_state_to_str(CMD_STATE(sc)));
 
-		BUG_ON(io_req->abts_done);
+	if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING) {
+		spin_unlock_irqrestore(io_lock, flags);
+		return true;
+	}
+	if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
+	    (!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
+		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
+			      "%s dev rst not pending sc 0x%p\n", __func__,
+			      sc);
+		spin_unlock_irqrestore(io_lock, flags);
+		return true;
+	}
 
-		abt_tag = tag;
-		if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
-			abt_tag |= FNIC_TAG_DEV_RST;
-			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
-				  "%s: dev rst sc 0x%p\n", __func__, sc);
-		}
+	if (io_req->abts_done)
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "%s: io_req->abts_done is set state is %s\n",
+			     __func__, fnic_ioreq_state_to_str(CMD_STATE(sc)));
+	old_ioreq_state = CMD_STATE(sc);
+	/*
+	 * Any pending IO issued prior to reset is expected to be
+	 * in abts pending state, if not we need to set
+	 * FNIC_IOREQ_ABTS_PENDING to indicate the IO is abort pending.
+	 * When IO is completed, the IO will be handed over and
+	 * handled in this function.
+	 */
+	CMD_STATE(sc) = FNIC_IOREQ_ABTS_PENDING;
 
-		CMD_ABTS_STATUS(sc) = FCPIO_INVALID_CODE;
-		io_req->abts_done = &tm_done;
-		spin_unlock_irqrestore(io_lock, flags);
+	BUG_ON(io_req->abts_done);
 
-		/* Now queue the abort command to firmware */
-		int_to_scsilun(sc->device->lun, &fc_lun);
+	if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
+		abt_tag |= FNIC_TAG_DEV_RST;
+		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
+			      "%s: dev rst sc 0x%p\n", __func__, sc);
+	}
 
-		if (fnic_queue_abort_io_req(fnic, abt_tag,
-					    FCPIO_ITMF_ABT_TASK_TERM,
-					    fc_lun.scsi_lun, io_req)) {
-			spin_lock_irqsave(io_lock, flags);
-			io_req = (struct fnic_io_req *)CMD_SP(sc);
-			if (io_req)
-				io_req->abts_done = NULL;
-			if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING)
-				CMD_STATE(sc) = old_ioreq_state;
-			spin_unlock_irqrestore(io_lock, flags);
-			ret = 1;
-			goto clean_pending_aborts_end;
-		} else {
-			spin_lock_irqsave(io_lock, flags);
-			if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET)
-				CMD_FLAGS(sc) |= FNIC_DEV_RST_TERM_ISSUED;
-			spin_unlock_irqrestore(io_lock, flags);
-		}
-		CMD_FLAGS(sc) |= FNIC_IO_INTERNAL_TERM_ISSUED;
+	CMD_ABTS_STATUS(sc) = FCPIO_INVALID_CODE;
+	io_req->abts_done = &tm_done;
+	spin_unlock_irqrestore(io_lock, flags);
 
-		wait_for_completion_timeout(&tm_done,
-					    msecs_to_jiffies
-					    (fnic->config.ed_tov));
+	/* Now queue the abort command to firmware */
+	int_to_scsilun(sc->device->lun, &fc_lun);
 
-		/* Recheck cmd state to check if it is now aborted */
+	if (fnic_queue_abort_io_req(fnic, abt_tag,
+				    FCPIO_ITMF_ABT_TASK_TERM,
+				    fc_lun.scsi_lun, io_req)) {
 		spin_lock_irqsave(io_lock, flags);
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
-		if (!io_req) {
-			spin_unlock_irqrestore(io_lock, flags);
-			CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_REQ_NULL;
-			continue;
-		}
+		if (io_req)
+			io_req->abts_done = NULL;
+		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING)
+			CMD_STATE(sc) = old_ioreq_state;
+		spin_unlock_irqrestore(io_lock, flags);
+		return false;
+	} else {
+		spin_lock_irqsave(io_lock, flags);
+		if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET)
+			CMD_FLAGS(sc) |= FNIC_DEV_RST_TERM_ISSUED;
+		spin_unlock_irqrestore(io_lock, flags);
+	}
+	CMD_FLAGS(sc) |= FNIC_IO_INTERNAL_TERM_ISSUED;
 
-		io_req->abts_done = NULL;
+	wait_for_completion_timeout(&tm_done, msecs_to_jiffies
+				    (fnic->config.ed_tov));
 
-		/* if abort is still pending with fw, fail */
-		if (CMD_ABTS_STATUS(sc) == FCPIO_INVALID_CODE) {
-			spin_unlock_irqrestore(io_lock, flags);
-			CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_DONE;
-			ret = 1;
-			goto clean_pending_aborts_end;
-		}
-		CMD_STATE(sc) = FNIC_IOREQ_ABTS_COMPLETE;
+	/* Recheck cmd state to check if it is now aborted */
+	spin_lock_irqsave(io_lock, flags);
+	io_req = (struct fnic_io_req *)CMD_SP(sc);
+	if (!io_req) {
+		spin_unlock_irqrestore(io_lock, flags);
+		CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_REQ_NULL;
+		return true;
+	}
 
-		/* original sc used for lr is handled by dev reset code */
-		if (sc != lr_sc)
-			CMD_SP(sc) = NULL;
+	io_req->abts_done = NULL;
+
+	/* if abort is still pending with fw, fail */
+	if (CMD_ABTS_STATUS(sc) == FCPIO_INVALID_CODE) {
 		spin_unlock_irqrestore(io_lock, flags);
+		CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_DONE;
+		iter_data->ret = FAILED;
+		return false;
+	}
+	CMD_STATE(sc) = FNIC_IOREQ_ABTS_COMPLETE;
 
-		/* original sc used for lr is handled by dev reset code */
-		if (sc != lr_sc) {
-			fnic_release_ioreq_buf(fnic, io_req, sc);
-			mempool_free(io_req, fnic->io_req_pool);
-		}
+	/* original sc used for lr is handled by dev reset code */
+	CMD_SP(sc) = NULL;
+	spin_unlock_irqrestore(io_lock, flags);
 
-		/*
-		 * Any IO is returned during reset, it needs to call scsi_done
-		 * to return the scsi_cmnd to upper layer.
-		 */
-		if (sc->scsi_done) {
-			/* Set result to let upper SCSI layer retry */
-			sc->result = DID_RESET << 16;
-			sc->scsi_done(sc);
-		}
+	/* original sc used for lr is handled by dev reset code */
+	fnic_release_ioreq_buf(fnic, io_req, sc);
+	mempool_free(io_req, fnic->io_req_pool);
+
+	/*
+	 * Any IO is returned during reset, it needs to call scsi_done
+	 * to return the scsi_cmnd to upper layer.
+	 */
+	if (sc->scsi_done) {
+		/* Set result to let upper SCSI layer retry */
+		sc->result = DID_RESET << 16;
+		sc->scsi_done(sc);
 	}
+	return true;
+}
+
+/*
+ * Clean up any pending aborts on the lun
+ * For each outstanding IO on this lun, whose abort is not completed by fw,
+ * issue a local abort. Wait for abort to complete. Return 0 if all commands
+ * successfully aborted, 1 otherwise
+ */
+static int fnic_clean_pending_aborts(struct fnic *fnic,
+				     struct scsi_cmnd *lr_sc)
 
+{
+	int ret = SUCCESS;
+	struct fnic_pending_aborts_iter_data iter_data = {
+		.fnic = fnic,
+		.lun_dev = lr_sc->device,
+		.ret = SUCCESS,
+	};
+
+	scsi_host_tagset_busy_iter(fnic->lport->host,
+				fnic_pending_aborts_iter, &iter_data);
+	if (iter_data.ret == FAILED) {
+		ret = iter_data.ret;
+		goto clean_pending_aborts_end;
+	}
 	schedule_timeout(msecs_to_jiffies(2 * fnic->config.ed_tov));
 
 	/* walk again to check, if IOs are still pending in fw */
@@ -2287,38 +2296,6 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 	return ret;
 }
 
-/**
- * fnic_scsi_host_start_tag
- * Allocates tagid from host's tag list
- **/
-static inline int
-fnic_scsi_host_start_tag(struct fnic *fnic, struct scsi_cmnd *sc)
-{
-	struct request_queue *q = sc->request->q;
-	struct request *dummy;
-
-	dummy = blk_mq_alloc_request(q, REQ_OP_WRITE, BLK_MQ_REQ_NOWAIT);
-	if (IS_ERR(dummy))
-		return SCSI_NO_TAG;
-
-	sc->tag = sc->request->tag = dummy->tag;
-	sc->host_scribble = (unsigned char *)dummy;
-
-	return dummy->tag;
-}
-
-/**
- * fnic_scsi_host_end_tag
- * frees tag allocated by fnic_scsi_host_start_tag.
- **/
-static inline void
-fnic_scsi_host_end_tag(struct fnic *fnic, struct scsi_cmnd *sc)
-{
-	struct request *dummy = (struct request *)sc->host_scribble;
-
-	blk_mq_free_request(dummy);
-}
-
 /*
  * SCSI Eh thread issues a Lun Reset when one or more commands on a LUN
  * fail to get aborted. It calls driver's eh_device_reset with a SCSI command
@@ -2340,8 +2317,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	struct reset_stats *reset_stats;
 	int tag = 0;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
-	int tag_gen_flag = 0;   /*to track tags allocated by fnic driver*/
-	bool new_sc = 0;
+	struct scsi_cmnd *reset_sc = NULL;
+	struct Scsi_Host *shost = sc->device->host;
 
 	/* Wait for rport to unblock */
 	fc_block_scsi_eh(sc);
@@ -2369,24 +2346,15 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		goto fnic_device_reset_end;
 	}
 
-	CMD_FLAGS(sc) = FNIC_DEVICE_RESET;
-	/* Allocate tag if not present */
+	reset_sc = scsi_get_reserved_cmd(shost);
+	if (unlikely(!reset_sc))
+		goto fnic_device_reset_end;
 
-	tag = sc->request->tag;
-	if (unlikely(tag < 0)) {
-		/*
-		 * Really should fix the midlayer to pass in a proper
-		 * request for ioctls...
-		 */
-		tag = fnic_scsi_host_start_tag(fnic, sc);
-		if (unlikely(tag == SCSI_NO_TAG))
-			goto fnic_device_reset_end;
-		tag_gen_flag = 1;
-		new_sc = 1;
-	}
-	io_lock = fnic_io_lock_hash(fnic, sc);
+	CMD_FLAGS(reset_sc) = FNIC_DEVICE_RESET;
+	tag = reset_sc->request->tag;
+	io_lock = fnic_io_lock_hash(fnic, reset_sc);
 	spin_lock_irqsave(io_lock, flags);
-	io_req = (struct fnic_io_req *)CMD_SP(sc);
+	io_req = (struct fnic_io_req *)CMD_SP(reset_sc);
 
 	/*
 	 * If there is a io_req attached to this command, then use it,
@@ -2400,11 +2368,11 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		}
 		memset(io_req, 0, sizeof(*io_req));
 		io_req->port_id = rport->port_id;
-		CMD_SP(sc) = (char *)io_req;
+		CMD_SP(reset_sc) = (char *)io_req;
 	}
 	io_req->dr_done = &tm_done;
-	CMD_STATE(sc) = FNIC_IOREQ_CMD_PENDING;
-	CMD_LR_STATUS(sc) = FCPIO_INVALID_CODE;
+	CMD_STATE(reset_sc) = FNIC_IOREQ_CMD_PENDING;
+	CMD_LR_STATUS(reset_sc) = FCPIO_INVALID_CODE;
 	spin_unlock_irqrestore(io_lock, flags);
 
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, "TAG %x\n", tag);
@@ -2413,15 +2381,15 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	 * issue the device reset, if enqueue failed, clean up the ioreq
 	 * and break assoc with scsi cmd
 	 */
-	if (fnic_queue_dr_io_req(fnic, sc, io_req)) {
+	if (fnic_queue_dr_io_req(fnic, reset_sc, io_req)) {
 		spin_lock_irqsave(io_lock, flags);
-		io_req = (struct fnic_io_req *)CMD_SP(sc);
+		io_req = (struct fnic_io_req *)CMD_SP(reset_sc);
 		if (io_req)
 			io_req->dr_done = NULL;
 		goto fnic_device_reset_clean;
 	}
 	spin_lock_irqsave(io_lock, flags);
-	CMD_FLAGS(sc) |= FNIC_DEV_RST_ISSUED;
+	CMD_FLAGS(reset_sc) |= FNIC_DEV_RST_ISSUED;
 	spin_unlock_irqrestore(io_lock, flags);
 
 	/*
@@ -2432,16 +2400,16 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 				    msecs_to_jiffies(FNIC_LUN_RESET_TIMEOUT));
 
 	spin_lock_irqsave(io_lock, flags);
-	io_req = (struct fnic_io_req *)CMD_SP(sc);
+	io_req = (struct fnic_io_req *)CMD_SP(reset_sc);
 	if (!io_req) {
 		spin_unlock_irqrestore(io_lock, flags);
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-				"io_req is null tag 0x%x sc 0x%p\n", tag, sc);
+				"io_req is null tag 0x%x sc 0x%p\n", tag, reset_sc);
 		goto fnic_device_reset_end;
 	}
 	io_req->dr_done = NULL;
 
-	status = CMD_LR_STATUS(sc);
+	status = CMD_LR_STATUS(reset_sc);
 
 	/*
 	 * If lun reset not completed, bail out with failed. io_req
@@ -2451,7 +2419,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		atomic64_inc(&reset_stats->device_reset_timeouts);
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 			      "Device reset timed out\n");
-		CMD_FLAGS(sc) |= FNIC_DEV_RST_TIMED_OUT;
+		CMD_FLAGS(reset_sc) |= FNIC_DEV_RST_TIMED_OUT;
 		spin_unlock_irqrestore(io_lock, flags);
 		int_to_scsilun(sc->device->lun, &fc_lun);
 		/*
@@ -2460,7 +2428,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		 */
 		while (1) {
 			spin_lock_irqsave(io_lock, flags);
-			if (CMD_FLAGS(sc) & FNIC_DEV_RST_TERM_ISSUED) {
+			if (CMD_FLAGS(reset_sc) & FNIC_DEV_RST_TERM_ISSUED) {
 				spin_unlock_irqrestore(io_lock, flags);
 				break;
 			}
@@ -2473,8 +2441,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 				msecs_to_jiffies(FNIC_ABT_TERM_DELAY_TIMEOUT));
 			} else {
 				spin_lock_irqsave(io_lock, flags);
-				CMD_FLAGS(sc) |= FNIC_DEV_RST_TERM_ISSUED;
-				CMD_STATE(sc) = FNIC_IOREQ_ABTS_PENDING;
+				CMD_FLAGS(reset_sc) |= FNIC_DEV_RST_TERM_ISSUED;
+				CMD_STATE(reset_sc) = FNIC_IOREQ_ABTS_PENDING;
 				io_req->abts_done = &tm_done;
 				spin_unlock_irqrestore(io_lock, flags);
 				FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
@@ -2491,7 +2459,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 				msecs_to_jiffies(FNIC_LUN_RESET_TIMEOUT));
 				break;
 			} else {
-				io_req = (struct fnic_io_req *)CMD_SP(sc);
+				io_req = (struct fnic_io_req *)CMD_SP(reset_sc);
 				io_req->abts_done = NULL;
 				goto fnic_device_reset_clean;
 			}
@@ -2506,7 +2474,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		FNIC_SCSI_DBG(KERN_DEBUG,
 			      fnic->lport->host,
 			      "Device reset completed - failed\n");
-		io_req = (struct fnic_io_req *)CMD_SP(sc);
+		io_req = (struct fnic_io_req *)CMD_SP(reset_sc);
 		goto fnic_device_reset_clean;
 	}
 
@@ -2517,7 +2485,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	 * the lun reset cmd. If all cmds get cleaned, the lun reset
 	 * succeeds
 	 */
-	if (fnic_clean_pending_aborts(fnic, sc, new_sc)) {
+	if (fnic_clean_pending_aborts(fnic, reset_sc)) {
 		spin_lock_irqsave(io_lock, flags);
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
@@ -2528,35 +2496,34 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 
 	/* Clean lun reset command */
 	spin_lock_irqsave(io_lock, flags);
-	io_req = (struct fnic_io_req *)CMD_SP(sc);
+	io_req = (struct fnic_io_req *)CMD_SP(reset_sc);
 	if (io_req)
 		/* Completed, and successful */
 		ret = SUCCESS;
 
 fnic_device_reset_clean:
 	if (io_req)
-		CMD_SP(sc) = NULL;
+		CMD_SP(reset_sc) = NULL;
 
 	spin_unlock_irqrestore(io_lock, flags);
 
 	if (io_req) {
 		start_time = io_req->start_time;
-		fnic_release_ioreq_buf(fnic, io_req, sc);
+		fnic_release_ioreq_buf(fnic, io_req, reset_sc);
 		mempool_free(io_req, fnic->io_req_pool);
 	}
 
 fnic_device_reset_end:
-	FNIC_TRACE(fnic_device_reset, sc->device->host->host_no,
-		  sc->request->tag, sc,
+	FNIC_TRACE(fnic_device_reset, reset_sc->device->host->host_no,
+		   reset_sc->request->tag, reset_sc,
 		  jiffies_to_msecs(jiffies - start_time),
-		  0, ((u64)sc->cmnd[0] << 32 |
+		  0, ((u64)reset_sc->cmnd[0] << 32 |
 		  (u64)sc->cmnd[2] << 24 | (u64)sc->cmnd[3] << 16 |
 		  (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
 		  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
 
 	/* free tag if it is allocated */
-	if (unlikely(tag_gen_flag))
-		fnic_scsi_host_end_tag(fnic, sc);
+	scsi_put_reserved_cmd(reset_sc);
 
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 		      "Returning from device reset %s\n",
-- 
2.17.1

