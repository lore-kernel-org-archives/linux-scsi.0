Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C6E0C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 11:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353054AbiELLNJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 07:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353030AbiELLM6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 07:12:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A9C633A3
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 04:12:53 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 5C96821CBB;
        Thu, 12 May 2022 11:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652353966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J7TI3+bf9LpiHCzggYX3FTk3v608IENQKvvDLEp1dg8=;
        b=re/tTjVL4imCne2yjZX9+GKDr9+QpZ3PzBUGcTzkjpeLRp3saW3xH4cnrg8ynYAkz83sxN
        v/6IgkABeJCeT9MlJhW14Miws9RHCi03dPRGD+n2GUaDJJ/1qO2TRxLPOxxR4j1UKFlcVK
        TFl2ZksQ8c+lmn8Fbl9j0hrIismiH5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652353966;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J7TI3+bf9LpiHCzggYX3FTk3v608IENQKvvDLEp1dg8=;
        b=aF5N1ESl5wowTQclGdZpAcdZGCFOsenyDUFCvaJ3rY8Yw7fB620thQ66M9xXgayqRZuJq7
        tkaQ7gGgl0G/DADw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 4DDF42C153;
        Thu, 12 May 2022 11:12:46 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 180DA51943EC; Thu, 12 May 2022 13:12:46 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 10/20] fnic: use dedicated device reset command
Date:   Thu, 12 May 2022 13:12:26 +0200
Message-Id: <20220512111236.109851-11-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220512111236.109851-1-hare@suse.de>
References: <20220512111236.109851-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use a dedicated command to send a device reset instead of relying
on using the command which triggered the device failure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/fnic/fnic_main.c |   9 +++
 drivers/scsi/fnic/fnic_scsi.c | 132 ++++++++++------------------------
 2 files changed, 46 insertions(+), 95 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 9161bd2fd421..23a53aeb3ea3 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -831,6 +831,15 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_free_rq_buf;
 	}
 
+	/*
+	 * Hack alert:
+	 * Reduce can_queue by one after calling scsi_add_host()
+	 * to reserve the topmost command for TMF.
+	 * Should be replaced by using a reserved command once
+	 * support for that gets merged.
+	 */
+	lp->host->can_queue--;
+
 	/* Start local port initiatialization */
 
 	lp->link_up = 0;
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 3d64877bda8d..4f72fac583b7 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1998,7 +1998,6 @@ static inline int fnic_queue_dr_io_req(struct fnic *fnic,
 
 struct fnic_pending_aborts_iter_data {
 	struct fnic *fnic;
-	struct scsi_cmnd *lr_sc;
 	struct scsi_device *lun_dev;
 	int ret;
 };
@@ -2017,7 +2016,7 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc,
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 	enum fnic_ioreq_state old_ioreq_state;
 
-	if (sc == iter_data->lr_sc || sc->device != lun_dev)
+	if (abt_tag == (fnic->fnic_max_tag_id - 1) || sc->device != lun_dev)
 		return true;
 	if (reserved)
 		return true;
@@ -2122,17 +2121,11 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc,
 		return false;
 	}
 	fnic_priv(sc)->state = FNIC_IOREQ_ABTS_COMPLETE;
-
-	/* original sc used for lr is handled by dev reset code */
-	if (sc != iter_data->lr_sc)
-		fnic_priv(sc)->io_req = NULL;
+	fnic_priv(sc)->io_req = NULL;
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
@@ -2152,8 +2145,7 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc,
  * successfully aborted, 1 otherwise
  */
 static int fnic_clean_pending_aborts(struct fnic *fnic,
-				     struct scsi_cmnd *lr_sc,
-				     bool new_sc)
+				     struct scsi_cmnd *lr_sc)
 
 {
 	int ret = SUCCESS;
@@ -2163,9 +2155,6 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 		.ret = SUCCESS,
 	};
 
-	if (new_sc)
-		iter_data.lr_sc = lr_sc;
-
 	scsi_host_busy_iter(fnic->lport->host,
 			    fnic_pending_aborts_iter, &iter_data);
 	if (iter_data.ret == FAILED) {
@@ -2182,39 +2171,6 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 	return ret;
 }
 
-/*
- * fnic_scsi_host_start_tag
- * Allocates tagid from host's tag list
- **/
-static inline int
-fnic_scsi_host_start_tag(struct fnic *fnic, struct scsi_cmnd *sc)
-{
-	struct request *rq = scsi_cmd_to_rq(sc);
-	struct request_queue *q = rq->q;
-	struct request *dummy;
-
-	dummy = blk_mq_alloc_request(q, REQ_OP_WRITE, BLK_MQ_REQ_NOWAIT);
-	if (IS_ERR(dummy))
-		return SCSI_NO_TAG;
-
-	rq->tag = dummy->tag;
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
@@ -2222,7 +2178,7 @@ fnic_scsi_host_end_tag(struct fnic *fnic, struct scsi_cmnd *sc)
  */
 int fnic_device_reset(struct scsi_cmnd *sc)
 {
-	struct request *rq = scsi_cmd_to_rq(sc);
+	struct scsi_device *sdev = sc->device;
 	struct fc_lport *lp;
 	struct fnic *fnic;
 	struct fnic_io_req *io_req = NULL;
@@ -2235,16 +2191,17 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	struct scsi_lun fc_lun;
 	struct fnic_stats *fnic_stats;
 	struct reset_stats *reset_stats;
-	int tag = rq->tag;
+	int tag;
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
@@ -2252,10 +2209,9 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 
 	atomic64_inc(&reset_stats->device_resets);
 
-	rport = starget_to_rport(scsi_target(sc->device));
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-		      "Device reset called FCID 0x%x, LUN 0x%llx sc 0x%p\n",
-		      rport->port_id, sc->device->lun, sc);
+		      "Device reset called FCID 0x%x, LUN 0x%llx\n",
+		      rport->port_id, sdev->lun);
 
 	if (lp->state != LPORT_ST_READY || !(lp->link_up))
 		goto fnic_device_reset_end;
@@ -2266,39 +2222,29 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		goto fnic_device_reset_end;
 	}
 
-	fnic_priv(sc)->flags = FNIC_DEVICE_RESET;
-	/* Allocate tag if not present */
+	/* The last tag is reserved for device reset */
+	sc = scsi_host_find_tag(sdev->host, fnic->fnic_max_tag_id - 1);
+	if (unlikely(!sc))
+		goto fnic_device_reset_end;
 
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
+	tag = scsi_cmd_to_rq(sc)->tag;
 	io_lock = fnic_io_lock_hash(fnic, sc);
 	spin_lock_irqsave(io_lock, flags);
 	io_req = fnic_priv(sc)->io_req;
+	if (io_req)
+		goto fnic_device_reset_end;
 
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
-		fnic_priv(sc)->io_req = io_req;
+		spin_unlock_irqrestore(io_lock, flags);
+		goto fnic_device_reset_end;
 	}
+	memset(io_req, 0, sizeof(*io_req));
+	io_req->port_id = rport->port_id;
+	fnic_priv(sc)->io_req = io_req;
+
 	io_req->dr_done = &tm_done;
+	fnic_priv(sc)->flags = FNIC_DEVICE_RESET;
 	fnic_priv(sc)->state = FNIC_IOREQ_CMD_PENDING;
 	fnic_priv(sc)->lr_status = FCPIO_INVALID_CODE;
 	spin_unlock_irqrestore(io_lock, flags);
@@ -2332,7 +2278,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	if (!io_req) {
 		spin_unlock_irqrestore(io_lock, flags);
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-				"io_req is null tag 0x%x sc 0x%p\n", tag, sc);
+				"io_req is null tag 0x%x\n", tag);
 		goto fnic_device_reset_end;
 	}
 	io_req->dr_done = NULL;
@@ -2375,7 +2321,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 				spin_unlock_irqrestore(io_lock, flags);
 				FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 				"Abort and terminate issued on Device reset "
-				"tag 0x%x sc 0x%p\n", tag, sc);
+				"tag 0x%x\n", tag);
 				break;
 			}
 		}
@@ -2413,7 +2359,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	 * the lun reset cmd. If all cmds get cleaned, the lun reset
 	 * succeeds
 	 */
-	if (fnic_clean_pending_aborts(fnic, sc, new_sc)) {
+	if (fnic_clean_pending_aborts(fnic, sc)) {
 		spin_lock_irqsave(io_lock, flags);
 		io_req = fnic_priv(sc)->io_req;
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
@@ -2442,17 +2388,14 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	}
 
 fnic_device_reset_end:
-	FNIC_TRACE(fnic_device_reset, sc->device->host->host_no, rq->tag, sc,
+	FNIC_TRACE(fnic_device_reset, sc->device->host->host_no,
+		  scsi_cmd_to_rq(sc)->tag, sc,
 		  jiffies_to_msecs(jiffies - start_time),
 		  0, ((u64)sc->cmnd[0] << 32 |
 		  (u64)sc->cmnd[2] << 24 | (u64)sc->cmnd[3] << 16 |
 		  (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
 		  fnic_flags_and_state(sc));
 
-	/* free tag if it is allocated */
-	if (unlikely(tag_gen_flag))
-		fnic_scsi_host_end_tag(fnic, sc);
-
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 		      "Returning from device reset %s\n",
 		      (ret == SUCCESS) ?
@@ -2675,6 +2618,7 @@ static bool fnic_abts_pending_iter(struct scsi_cmnd *sc, void *data,
 {
 	struct fnic_pending_aborts_iter_data *iter_data = data;
 	struct fnic *fnic = iter_data->fnic;
+	int tag = scsi_cmd_to_rq(sc)->tag;
 	int cmd_state;
 	struct fnic_io_req *io_req;
 	spinlock_t *io_lock;
@@ -2684,7 +2628,7 @@ static bool fnic_abts_pending_iter(struct scsi_cmnd *sc, void *data,
 	 * ignore this lun reset cmd or cmds that do not belong to
 	 * this lun
 	 */
-	if (iter_data->lr_sc && sc == iter_data->lr_sc)
+	if (tag == (fnic->fnic_max_tag_id - 1))
 		return true;
 	if (iter_data->lun_dev && sc->device != iter_data->lun_dev)
 		return true;
@@ -2728,10 +2672,8 @@ int fnic_is_abts_pending(struct fnic *fnic, struct scsi_cmnd *lr_sc)
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

