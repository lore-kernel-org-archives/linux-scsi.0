Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98ADAC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387760AbiEBVmg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387728AbiEBVmH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:42:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52444E0C4
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:38:37 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 026EE1F750;
        Mon,  2 May 2022 21:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651527513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Du3QIx4TdS0ctD8wpU1SXBbDASahmtvSo53jPhEF5s=;
        b=VtduO+H4d4wSYmOH158zmYRT7JYkfrL4gwazPNpccbcvtaucRJyM0oj0XzRcNtOv3uMiaL
        dpYFq49dnrmm5F3WdX1497KAkWXIY1um5j0S5NivsKVpF6YMPjUw8+7jR4szrejJ9eDDLM
        9ebrlWs26Z+SMbiakfbJJF2UCK3K0zI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651527513;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Du3QIx4TdS0ctD8wpU1SXBbDASahmtvSo53jPhEF5s=;
        b=VhAupw7KDTpwddChJ/2BlN+CczrMpbAQBHVGpXUWGxwsn9NIYyw91iIrok0sxEeqZGpySj
        kV6hmqjD71NLNNAA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id F0FC52C15A;
        Mon,  2 May 2022 21:38:32 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id EDC86519410A; Mon,  2 May 2022 23:38:32 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 11/24] fnic: use dedicated device reset command
Date:   Mon,  2 May 2022 23:38:07 +0200
Message-Id: <20220502213820.3187-12-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502213820.3187-1-hare@suse.de>
References: <20220502213820.3187-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use a dedicated command to send a device reset instead of relying
on using the command which triggered the device failure.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 131 ++++++++++------------------------
 1 file changed, 36 insertions(+), 95 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 3d64877bda8d..b2ba731b67de 100644
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
@@ -2266,39 +2222,28 @@ int fnic_device_reset(struct scsi_cmnd *sc)
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
@@ -2332,7 +2277,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	if (!io_req) {
 		spin_unlock_irqrestore(io_lock, flags);
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-				"io_req is null tag 0x%x sc 0x%p\n", tag, sc);
+				"io_req is null tag 0x%x\n", tag);
 		goto fnic_device_reset_end;
 	}
 	io_req->dr_done = NULL;
@@ -2375,7 +2320,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 				spin_unlock_irqrestore(io_lock, flags);
 				FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 				"Abort and terminate issued on Device reset "
-				"tag 0x%x sc 0x%p\n", tag, sc);
+				"tag 0x%x\n", tag);
 				break;
 			}
 		}
@@ -2413,7 +2358,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	 * the lun reset cmd. If all cmds get cleaned, the lun reset
 	 * succeeds
 	 */
-	if (fnic_clean_pending_aborts(fnic, sc, new_sc)) {
+	if (fnic_clean_pending_aborts(fnic, sc)) {
 		spin_lock_irqsave(io_lock, flags);
 		io_req = fnic_priv(sc)->io_req;
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
@@ -2442,17 +2387,14 @@ int fnic_device_reset(struct scsi_cmnd *sc)
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
@@ -2675,6 +2617,7 @@ static bool fnic_abts_pending_iter(struct scsi_cmnd *sc, void *data,
 {
 	struct fnic_pending_aborts_iter_data *iter_data = data;
 	struct fnic *fnic = iter_data->fnic;
+	int tag = scsi_cmd_to_rq(sc)->tag;
 	int cmd_state;
 	struct fnic_io_req *io_req;
 	spinlock_t *io_lock;
@@ -2684,7 +2627,7 @@ static bool fnic_abts_pending_iter(struct scsi_cmnd *sc, void *data,
 	 * ignore this lun reset cmd or cmds that do not belong to
 	 * this lun
 	 */
-	if (iter_data->lr_sc && sc == iter_data->lr_sc)
+	if (tag == (fnic->fnic_max_tag_id - 1))
 		return true;
 	if (iter_data->lun_dev && sc->device != iter_data->lun_dev)
 		return true;
@@ -2728,10 +2671,8 @@ int fnic_is_abts_pending(struct fnic *fnic, struct scsi_cmnd *lr_sc)
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

