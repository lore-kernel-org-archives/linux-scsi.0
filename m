Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46610C43461
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 15:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A4786121D
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 15:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhECPEk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 11:04:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:40678 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230084AbhECPEi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 May 2021 11:04:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5B000B15B;
        Mon,  3 May 2021 15:03:44 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/18] fnic: use internal commands
Date:   Mon,  3 May 2021 17:03:19 +0200
Message-Id: <20210503150333.130310-5-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210503150333.130310-1-hare@suse.de>
References: <20210503150333.130310-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove hack to get tag for the reset command by using internal
commands.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/fnic/fnic_scsi.c | 111 +++++++++++++++-------------------
 1 file changed, 48 insertions(+), 63 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 762cc8bd2653..77a85fff8fa1 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2169,20 +2169,16 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc,
  * successfully aborted, 1 otherwise
  */
 static int fnic_clean_pending_aborts(struct fnic *fnic,
-				     struct scsi_cmnd *lr_sc,
-				     bool new_sc)
-
+				     struct scsi_cmnd *lr_sc)
 {
 	int ret = SUCCESS;
 	struct fnic_pending_aborts_iter_data iter_data = {
 		.fnic = fnic,
 		.lun_dev = lr_sc->device,
+		.lr_sc = lr_sc,
 		.ret = SUCCESS,
 	};
 
-	if (new_sc)
-		iter_data.lr_sc = lr_sc;
-
 	scsi_host_busy_iter(fnic->lport->host,
 			    fnic_pending_aborts_iter, &iter_data);
 	if (iter_data.ret == FAILED) {
@@ -2247,19 +2243,19 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	spinlock_t *io_lock;
 	unsigned long flags;
 	unsigned long start_time = 0;
+	struct scsi_device *sdev = sc->device;
 	struct scsi_lun fc_lun;
 	struct fnic_stats *fnic_stats;
 	struct reset_stats *reset_stats;
 	int tag = 0;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
-	int tag_gen_flag = 0;   /*to track tags allocated by fnic driver*/
-	bool new_sc = 0;
+	struct scsi_cmnd *reset_sc = NULL;
 
 	/* Wait for rport to unblock */
 	fc_block_scsi_eh(sc);
 
 	/* Get local-port, check ready and link up */
-	lp = shost_priv(sc->device->host);
+	lp = shost_priv(sdev->host);
 
 	fnic = lport_priv(lp);
 	fnic_stats = &fnic->fnic_stats;
@@ -2267,10 +2263,10 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 
 	atomic64_inc(&reset_stats->device_resets);
 
-	rport = starget_to_rport(scsi_target(sc->device));
+	rport = starget_to_rport(scsi_target(sdev));
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 		      "Device reset called FCID 0x%x, LUN 0x%llx sc 0x%p\n",
-		      rport->port_id, sc->device->lun, sc);
+		      rport->port_id, sdev->lun, sc);
 
 	if (lp->state != LPORT_ST_READY || !(lp->link_up))
 		goto fnic_device_reset_end;
@@ -2281,42 +2277,31 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		goto fnic_device_reset_end;
 	}
 
-	CMD_FLAGS(sc) = FNIC_DEVICE_RESET;
-	/* Allocate tag if not present */
+	reset_sc = scsi_get_internal_cmd(sdev, REQ_OP_SCSI_IN,
+					 BLK_MQ_REQ_NOWAIT);
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
 
 	/*
-	 * If there is a io_req attached to this command, then use it,
-	 * else allocate a new one.
+	 * Allocate a new io_req.
 	 */
+	io_req = mempool_alloc(fnic->io_req_pool, GFP_ATOMIC);
 	if (!io_req) {
-		io_req = mempool_alloc(fnic->io_req_pool, GFP_ATOMIC);
-		if (!io_req) {
-			spin_unlock_irqrestore(io_lock, flags);
-			goto fnic_device_reset_end;
-		}
-		memset(io_req, 0, sizeof(*io_req));
-		io_req->port_id = rport->port_id;
-		CMD_SP(sc) = (char *)io_req;
+		spin_unlock_irqrestore(io_lock, flags);
+		goto fnic_device_reset_end;
 	}
+	memset(io_req, 0, sizeof(*io_req));
+	io_req->port_id = rport->port_id;
+	CMD_SP(reset_sc) = (char *)io_req;
+
 	io_req->dr_done = &tm_done;
-	CMD_STATE(sc) = FNIC_IOREQ_CMD_PENDING;
-	CMD_LR_STATUS(sc) = FCPIO_INVALID_CODE;
+	CMD_STATE(reset_sc) = FNIC_IOREQ_CMD_PENDING;
+	CMD_LR_STATUS(reset_sc) = FCPIO_INVALID_CODE;
 	spin_unlock_irqrestore(io_lock, flags);
 
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, "TAG %x\n", tag);
@@ -2325,15 +2310,15 @@ int fnic_device_reset(struct scsi_cmnd *sc)
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
@@ -2344,16 +2329,16 @@ int fnic_device_reset(struct scsi_cmnd *sc)
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
@@ -2363,16 +2348,16 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		atomic64_inc(&reset_stats->device_reset_timeouts);
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 			      "Device reset timed out\n");
-		CMD_FLAGS(sc) |= FNIC_DEV_RST_TIMED_OUT;
+		CMD_FLAGS(reset_sc) |= FNIC_DEV_RST_TIMED_OUT;
 		spin_unlock_irqrestore(io_lock, flags);
-		int_to_scsilun(sc->device->lun, &fc_lun);
+		int_to_scsilun(sdev->lun, &fc_lun);
 		/*
 		 * Issue abort and terminate on device reset request.
 		 * If q'ing of terminate fails, retry it after a delay.
 		 */
 		while (1) {
 			spin_lock_irqsave(io_lock, flags);
-			if (CMD_FLAGS(sc) & FNIC_DEV_RST_TERM_ISSUED) {
+			if (CMD_FLAGS(reset_sc) & FNIC_DEV_RST_TERM_ISSUED) {
 				spin_unlock_irqrestore(io_lock, flags);
 				break;
 			}
@@ -2385,13 +2370,13 @@ int fnic_device_reset(struct scsi_cmnd *sc)
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
 				"Abort and terminate issued on Device reset "
-				"tag 0x%x sc 0x%p\n", tag, sc);
+				"tag 0x%x sc 0x%p\n", tag, reset_sc);
 				break;
 			}
 		}
@@ -2403,7 +2388,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 				msecs_to_jiffies(FNIC_LUN_RESET_TIMEOUT));
 				break;
 			} else {
-				io_req = (struct fnic_io_req *)CMD_SP(sc);
+				io_req = (struct fnic_io_req *)CMD_SP(reset_sc);
 				io_req->abts_done = NULL;
 				goto fnic_device_reset_clean;
 			}
@@ -2418,7 +2403,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		FNIC_SCSI_DBG(KERN_DEBUG,
 			      fnic->lport->host,
 			      "Device reset completed - failed\n");
-		io_req = (struct fnic_io_req *)CMD_SP(sc);
+		io_req = (struct fnic_io_req *)CMD_SP(reset_sc);
 		goto fnic_device_reset_clean;
 	}
 
@@ -2429,7 +2414,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	 * the lun reset cmd. If all cmds get cleaned, the lun reset
 	 * succeeds
 	 */
-	if (fnic_clean_pending_aborts(fnic, sc, new_sc)) {
+	if (fnic_clean_pending_aborts(fnic, reset_sc)) {
 		spin_lock_irqsave(io_lock, flags);
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
@@ -2440,35 +2425,35 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 
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
+	FNIC_TRACE(fnic_device_reset, sdev->host->host_no,
+		   reset_sc->request->tag, reset_sc,
 		  jiffies_to_msecs(jiffies - start_time),
-		  0, ((u64)sc->cmnd[0] << 32 |
+		  0, ((u64)reset_sc->cmnd[0] << 32 |
 		  (u64)sc->cmnd[2] << 24 | (u64)sc->cmnd[3] << 16 |
 		  (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
 		  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
 
-	/* free tag if it is allocated */
-	if (unlikely(tag_gen_flag))
-		fnic_scsi_host_end_tag(fnic, sc);
+	/* free internal command if it is allocated */
+	if (reset_sc)
+		scsi_put_internal_cmd(reset_sc);
 
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 		      "Returning from device reset %s\n",
-- 
2.29.2

