Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92340C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BEA160FA0
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239885AbhHQJSH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:18:07 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47670 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239493AbhHQJRU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:20 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 9A97B20027;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uHlO7ZvGSjc7jtOu9AADJUR+y0m7l2Y+9F765qIy0ZQ=;
        b=GGWZimCuvfzypWAR0XNykxCUYNmoyXQgokZmRkscFq8Iz4Z8ZBs/Vwk9/ruGvOn1b03rNN
        jGKWXgt2xulUjtskfvskPFH8l1ObLBEZ/tQZ2kGAjBI3huGmBmh059h87hUjvVdcb5oTWA
        xkHemaJG/d8Lzg2mLlJZbrBE1JTU1UA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uHlO7ZvGSjc7jtOu9AADJUR+y0m7l2Y+9F765qIy0ZQ=;
        b=Bo+4XhV8m7ZZJXlpTU2kuTI9DzhJm97bcpG9X3YfZdwwws3DXSlnrzu37pf7m0WuiAI2+E
        iEdxlf+o2xzpR5DQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 95072A3BB5;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 91E5C518CEAB; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 38/51] fnic: use dedicated device reset command
Date:   Tue, 17 Aug 2021 11:14:43 +0200
Message-Id: <20210817091456.73342-39-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use a dedicated command to send a device reset instead of relying
on using the command which triggered the device failure.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 127 +++++++++-------------------------
 1 file changed, 34 insertions(+), 93 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 60af6c7a1bc4..b133eb629fa2 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2014,7 +2014,6 @@ static inline int fnic_queue_dr_io_req(struct fnic *fnic,
 
 struct fnic_pending_aborts_iter_data {
 	struct fnic *fnic;
-	struct scsi_cmnd *lr_sc;
 	struct scsi_device *lun_dev;
 	int ret;
 };
@@ -2033,7 +2032,7 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc,
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 	enum fnic_ioreq_state old_ioreq_state;
 
-	if (sc == iter_data->lr_sc || sc->device != lun_dev)
+	if (abt_tag == (fnic->fnic_max_tag_id - 1) || sc->device != lun_dev)
 		return true;
 	if (reserved)
 		return true;
@@ -2138,17 +2137,11 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc,
 		return false;
 	}
 	CMD_STATE(sc) = FNIC_IOREQ_ABTS_COMPLETE;
-
-	/* original sc used for lr is handled by dev reset code */
-	if (sc != iter_data->lr_sc)
-		CMD_SP(sc) = NULL;
+	CMD_SP(sc) = NULL;
 	spin_unlock_irqrestore(io_lock, flags);
 
-	/* original sc used for lr is handled by dev reset code */
-	if (sc != iter_data->lr_sc) {
-		fnic_release_ioreq_buf(fnic, io_req, sc);
-		mempool_free(io_req, fnic->io_req_pool);
-	}
+	fnic_release_ioreq_buf(fnic, io_req, sc);
+	mempool_free(io_req, fnic->io_req_pool);
 
 	/*
 	 * Any IO is returned during reset, it needs to call scsi_done
@@ -2169,8 +2162,7 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc,
  * successfully aborted, 1 otherwise
  */
 static int fnic_clean_pending_aborts(struct fnic *fnic,
-				     struct scsi_cmnd *lr_sc,
-				     bool new_sc)
+				     struct scsi_cmnd *lr_sc)
 
 {
 	int ret = SUCCESS;
@@ -2180,9 +2172,6 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 		.ret = SUCCESS,
 	};
 
-	if (new_sc)
-		iter_data.lr_sc = lr_sc;
-
 	scsi_host_busy_iter(fnic->lport->host,
 			    fnic_pending_aborts_iter, &iter_data);
 	if (iter_data.ret == FAILED) {
@@ -2199,38 +2188,6 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 	return ret;
 }
 
-/*
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
-/*
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
@@ -2238,6 +2195,7 @@ fnic_scsi_host_end_tag(struct fnic *fnic, struct scsi_cmnd *sc)
  */
 int fnic_device_reset(struct scsi_cmnd *sc)
 {
+	struct scsi_device *sdev = sc->device;
 	struct fc_lport *lp;
 	struct fnic *fnic;
 	struct fnic_io_req *io_req = NULL;
@@ -2252,14 +2210,15 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	struct reset_stats *reset_stats;
 	int tag = 0;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
-	int tag_gen_flag = 0;   /*to track tags allocated by fnic driver*/
-	bool new_sc = 0;
 
 	/* Wait for rport to unblock */
-	fc_block_scsi_eh(sc);
+	rport = starget_to_rport(scsi_target(sdev));
+	ret = fc_block_rport(rport);
+	if (ret)
+		return ret;
 
 	/* Get local-port, check ready and link up */
-	lp = shost_priv(sc->device->host);
+	lp = shost_priv(sdev->host);
 
 	fnic = lport_priv(lp);
 	fnic_stats = &fnic->fnic_stats;
@@ -2267,54 +2226,41 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 
 	atomic64_inc(&reset_stats->device_resets);
 
-	rport = starget_to_rport(scsi_target(sc->device));
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-		      "Device reset called FCID 0x%x, LUN 0x%llx sc 0x%p\n",
-		      rport->port_id, sc->device->lun, sc);
+		      "Device reset called FCID 0x%x, LUN 0x%llx\n",
+		      rport->port_id, sdev->lun);
 
 	if (lp->state != LPORT_ST_READY || !(lp->link_up))
 		goto fnic_device_reset_end;
 
 	/* Check if remote port up */
-	if (fc_remote_port_chkready(rport)) {
-		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
+	if (rport->port_state != FC_PORTSTATE_ONLINE &&
+	    rport->port_state != FC_PORTSTATE_MARGINAL) {
 		goto fnic_device_reset_end;
 	}
 
 	CMD_FLAGS(sc) = FNIC_DEVICE_RESET;
-	/* Allocate tag if not present */
-
-	tag = sc->request->tag;
-	if (unlikely(tag < 0)) {
+	/* The last tag is reserved for device reset */
+	sc = scsi_host_find_tag(sdev->host, fnic->fnic_max_tag_id - 1);
+	io_lock = fnic_io_lock_hash(fnic, sc);
+	spin_lock_irqsave(io_lock, flags);
+	if (CMD_SP(sc)) {
 		/*
-		 * Really should fix the midlayer to pass in a proper
-		 * request for ioctls...
+		 * Reset tag busy
 		 */
-		tag = fnic_scsi_host_start_tag(fnic, sc);
-		if (unlikely(tag == SCSI_NO_TAG))
-			goto fnic_device_reset_end;
-		tag_gen_flag = 1;
-		new_sc = 1;
+		spin_unlock_irqrestore(io_lock, flags);
+		goto fnic_device_reset_end;
 	}
-	io_lock = fnic_io_lock_hash(fnic, sc);
-	spin_lock_irqsave(io_lock, flags);
-	io_req = (struct fnic_io_req *)CMD_SP(sc);
-
-	/*
-	 * If there is a io_req attached to this command, then use it,
-	 * else allocate a new one.
-	 */
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
+	CMD_SP(sc) = (char *)io_req;
 	io_req->dr_done = &tm_done;
+	CMD_FLAGS(sc) = FNIC_DEVICE_RESET;
 	CMD_STATE(sc) = FNIC_IOREQ_CMD_PENDING;
 	CMD_LR_STATUS(sc) = FCPIO_INVALID_CODE;
 	spin_unlock_irqrestore(io_lock, flags);
@@ -2429,7 +2375,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	 * the lun reset cmd. If all cmds get cleaned, the lun reset
 	 * succeeds
 	 */
-	if (fnic_clean_pending_aborts(fnic, sc, new_sc)) {
+	if (fnic_clean_pending_aborts(fnic, sc)) {
 		spin_lock_irqsave(io_lock, flags);
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
@@ -2466,10 +2412,6 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		  (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
 		  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
 
-	/* free tag if it is allocated */
-	if (unlikely(tag_gen_flag))
-		fnic_scsi_host_end_tag(fnic, sc);
-
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 		      "Returning from device reset %s\n",
 		      (ret == SUCCESS) ?
@@ -2691,6 +2633,7 @@ static bool fnic_abts_pending_iter(struct scsi_cmnd *sc, void *data,
 {
 	struct fnic_pending_aborts_iter_data *iter_data = data;
 	struct fnic *fnic = iter_data->fnic;
+	int tag = sc->request->tag;
 	int cmd_state;
 	struct fnic_io_req *io_req;
 	spinlock_t *io_lock;
@@ -2700,7 +2643,7 @@ static bool fnic_abts_pending_iter(struct scsi_cmnd *sc, void *data,
 	 * ignore this lun reset cmd or cmds that do not belong to
 	 * this lun
 	 */
-	if (iter_data->lr_sc && sc == iter_data->lr_sc)
+	if (tag == (fnic->fnic_max_tag_id - 1))
 		return true;
 	if (iter_data->lun_dev && sc->device != iter_data->lun_dev)
 		return true;
@@ -2744,10 +2687,8 @@ int fnic_is_abts_pending(struct fnic *fnic, struct scsi_cmnd *lr_sc)
 		.ret = 0,
 	};
 
-	if (lr_sc) {
+	if (lr_sc)
 		iter_data.lun_dev = lr_sc->device;
-		iter_data.lr_sc = lr_sc;
-	}
 
 	/* walk again to check, if IOs are still pending in fw */
 	scsi_host_busy_iter(fnic->lport->host,
-- 
2.29.2

