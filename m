From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 35/47] fnic: use dedicated device reset command
Date: Wed, 28 Jun 2017 10:33:01 +0200
Message-ID: <1498638793-44672-36-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53898 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751744AbdF1Id0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:26 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Use a dedicated command to send a device reset instead of relying
on using the command which triggered the device failure.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fnic/fnic_main.c |  2 ++
 drivers/scsi/fnic/fnic_scsi.c | 78 +++++++++++++------------------------------
 2 files changed, 26 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index aacadbf..22fd37c 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -706,6 +706,8 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 					fnic->config.io_throttle_count));
 	}
 	fnic->fnic_max_tag_id = host->can_queue;
+	/* Reserve the last tag for device reset */
+	host->can_queue--;
 
 	host->max_lun = fnic->config.luns_per_tgt;
 	host->max_id = FNIC_MAX_FCP_TARGET;
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 731ec87..acf7d1d 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2106,9 +2106,7 @@ static inline int fnic_queue_dr_io_req(struct fnic *fnic,
  * successfully aborted, 1 otherwise
  */
 static int fnic_clean_pending_aborts(struct fnic *fnic,
-				     struct scsi_cmnd *lr_sc,
-					 bool new_sc)
-
+				     struct scsi_cmnd *lr_sc)
 {
 	int tag, abt_tag;
 	struct fnic_io_req *io_req;
@@ -2129,7 +2127,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 		 * ignore this lun reset cmd if issued using new SC
 		 * or cmds that do not belong to this lun
 		 */
-		if (!sc || ((sc == lr_sc) && new_sc) || sc->device != lun_dev) {
+		if (!sc || sc == lr_sc || sc->device != lun_dev) {
 			spin_unlock_irqrestore(io_lock, flags);
 			continue;
 		}
@@ -2334,6 +2332,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
  */
 int fnic_device_reset(struct scsi_cmnd *sc)
 {
+	struct scsi_device *sdev = sc->device;
 	struct fc_lport *lp;
 	struct fnic *fnic;
 	struct fnic_io_req *io_req = NULL;
@@ -2348,18 +2347,16 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	struct reset_stats *reset_stats;
 	int tag = 0;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
-	int tag_gen_flag = 0;   /*to track tags allocated by fnic driver*/
-	bool new_sc = 0;
 
 	/* Wait for rport to unblock */
-	rport = starget_to_rport(scsi_target(sc->device));
+	rport = starget_to_rport(scsi_target(sdev));
 	ret = fc_block_scsi_eh(rport);
 	if (ret)
 		return ret;
 
 	ret = FAILED;
 	/* Get local-port, check ready and link up */
-	lp = shost_priv(sc->device->host);
+	lp = shost_priv(sdev->host);
 
 	fnic = lport_priv(lp);
 	fnic_stats = &fnic->fnic_stats;
@@ -2368,8 +2365,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	atomic64_inc(&reset_stats->device_resets);
 
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-		      "Device reset called FCID 0x%x, LUN 0x%llx sc 0x%p\n",
-		      rport->port_id, sc->device->lun, sc);
+		      "Device reset called FCID 0x%x, LUN 0x%llx\n",
+		      rport->port_id, sdev->lun);
 
 	if (lp->state != LPORT_ST_READY || !(lp->link_up))
 		goto fnic_device_reset_end;
@@ -2379,51 +2376,28 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
 		goto fnic_device_reset_end;
 	}
-
-	CMD_FLAGS(sc) = FNIC_DEVICE_RESET;
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
-		 * XXX(hch): current the midlayer fakes up a struct
-		 * request for the explicit reset ioctls, and those
-		 * don't have a tag allocated to them.  The below
-		 * code pokes into midlayer structures to paper over
-		 * this design issue, but that won't work for blk-mq.
-		 *
-		 * Either someone who can actually test the hardware
-		 * will have to come up with a similar hack for the
-		 * blk-mq case, or we'll have to bite the bullet and
-		 * fix the way the EH ioctls work for real, but until
-		 * that happens we fail these explicit requests here.
+		 * Reset tag busy
 		 */
-
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
+
+	CMD_FLAGS(sc) = FNIC_DEVICE_RESET;
 	CMD_STATE(sc) = FNIC_IOREQ_CMD_PENDING;
 	CMD_LR_STATUS(sc) = FCPIO_INVALID_CODE;
 	spin_unlock_irqrestore(io_lock, flags);
@@ -2538,7 +2512,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	 * the lun reset cmd. If all cmds get cleaned, the lun reset
 	 * succeeds
 	 */
-	if (fnic_clean_pending_aborts(fnic, sc, new_sc)) {
+	if (fnic_clean_pending_aborts(fnic, sc)) {
 		spin_lock_irqsave(io_lock, flags);
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
@@ -2575,10 +2549,6 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		  (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
 		  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
 
-	/* free tag if it is allocated */
-	if (unlikely(tag_gen_flag))
-		fnic_scsi_host_end_tag(fnic, sc);
-
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 		      "Returning from device reset %s\n",
 		      (ret == SUCCESS) ?
-- 
1.8.5.6
