From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.2-rc6
Date: Fri, 14 Aug 2015 21:44:32 -0700
Message-ID: <1439613872.16713.28.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch consists of 2 libfc fixes causing rare crashes, one iscsi one
causing a potential hang on shutdown, an I/O blocksize issue which
caused a regression and a memory leak in scsi-mq.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (2):
      libfc: Fix fc_fcp_cleanup_each_cmd()
      libfc: Fix fc_exch_recv_req() error path

John Soni Jose (1):
      libiscsi: Fix host busy blocking during connection teardown

Martin K. Petersen (1):
      sd: Fix maximum I/O size for BLOCK_PC requests

Tony Battersby (1):
      scsi: fix memory leak with scsi-mq

And the diffstat:

 block/blk-settings.c         |  4 ++--
 drivers/scsi/libfc/fc_exch.c |  8 ++++----
 drivers/scsi/libfc/fc_fcp.c  | 19 +++++++++++++++++--
 drivers/scsi/libiscsi.c      | 25 ++-----------------------
 drivers/scsi/scsi_error.c    |  2 +-
 drivers/scsi/scsi_lib.c      |  6 +++---
 drivers/scsi/sd.c            |  6 +++---
 7 files changed, 32 insertions(+), 38 deletions(-)

With full diff below.

James

---

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 12600bf..e0057d0 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -241,8 +241,8 @@ EXPORT_SYMBOL(blk_queue_bounce_limit);
  * Description:
  *    Enables a low level driver to set a hard upper limit,
  *    max_hw_sectors, on the size of requests.  max_hw_sectors is set by
- *    the device driver based upon the combined capabilities of I/O
- *    controller and storage device.
+ *    the device driver based upon the capabilities of the I/O
+ *    controller.
  *
  *    max_sectors is a soft limit imposed by the block layer for
  *    filesystem type requests.  This value can be overridden on a
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 1b3a094..30f9ef0 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -733,8 +733,6 @@ static bool fc_invoke_resp(struct fc_exch *ep, struct fc_seq *sp,
 	if (resp) {
 		resp(sp, fp, arg);
 		res = true;
-	} else if (!IS_ERR(fp)) {
-		fc_frame_free(fp);
 	}
 
 	spin_lock_bh(&ep->ex_lock);
@@ -1596,7 +1594,8 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	 * If new exch resp handler is valid then call that
 	 * first.
 	 */
-	fc_invoke_resp(ep, sp, fp);
+	if (!fc_invoke_resp(ep, sp, fp))
+		fc_frame_free(fp);
 
 	fc_exch_release(ep);
 	return;
@@ -1695,7 +1694,8 @@ static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
 	fc_exch_hold(ep);
 	if (!rc)
 		fc_exch_delete(ep);
-	fc_invoke_resp(ep, sp, fp);
+	if (!fc_invoke_resp(ep, sp, fp))
+		fc_frame_free(fp);
 	if (has_rec)
 		fc_exch_timer_set(ep, ep->r_a_tov);
 	fc_exch_release(ep);
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index c679594..2d5909c 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1039,11 +1039,26 @@ restart:
 		fc_fcp_pkt_hold(fsp);
 		spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
 
-		if (!fc_fcp_lock_pkt(fsp)) {
+		spin_lock_bh(&fsp->scsi_pkt_lock);
+		if (!(fsp->state & FC_SRB_COMPL)) {
+			fsp->state |= FC_SRB_COMPL;
+			/*
+			 * TODO: dropping scsi_pkt_lock and then reacquiring
+			 * again around fc_fcp_cleanup_cmd() is required,
+			 * since fc_fcp_cleanup_cmd() calls into
+			 * fc_seq_set_resp() and that func preempts cpu using
+			 * schedule. May be schedule and related code should be
+			 * removed instead of unlocking here to avoid scheduling
+			 * while atomic bug.
+			 */
+			spin_unlock_bh(&fsp->scsi_pkt_lock);
+
 			fc_fcp_cleanup_cmd(fsp, error);
+
+			spin_lock_bh(&fsp->scsi_pkt_lock);
 			fc_io_compl(fsp);
-			fc_fcp_unlock_pkt(fsp);
 		}
+		spin_unlock_bh(&fsp->scsi_pkt_lock);
 
 		fc_fcp_pkt_release(fsp);
 		spin_lock_irqsave(&si->scsi_queue_lock, flags);
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 8053f24..98d9bb6 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2941,10 +2941,10 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_session *session = conn->session;
-	unsigned long flags;
 
 	del_timer_sync(&conn->transport_timer);
 
+	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->frwd_lock);
 	conn->c_stage = ISCSI_CONN_CLEANUP_WAIT;
 	if (session->leadconn == conn) {
@@ -2956,28 +2956,6 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	}
 	spin_unlock_bh(&session->frwd_lock);
 
-	/*
-	 * Block until all in-progress commands for this connection
-	 * time out or fail.
-	 */
-	for (;;) {
-		spin_lock_irqsave(session->host->host_lock, flags);
-		if (!atomic_read(&session->host->host_busy)) { /* OK for ERL == 0 */
-			spin_unlock_irqrestore(session->host->host_lock, flags);
-			break;
-		}
-		spin_unlock_irqrestore(session->host->host_lock, flags);
-		msleep_interruptible(500);
-		iscsi_conn_printk(KERN_INFO, conn, "iscsi conn_destroy(): "
-				  "host_busy %d host_failed %d\n",
-				  atomic_read(&session->host->host_busy),
-				  session->host->host_failed);
-		/*
-		 * force eh_abort() to unblock
-		 */
-		wake_up(&conn->ehwait);
-	}
-
 	/* flush queued up work because we free the connection below */
 	iscsi_suspend_tx(conn);
 
@@ -2994,6 +2972,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
 	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&session->eh_mutex);
 
 	iscsi_destroy_conn(cls_conn);
 }
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 106884a..cfadcce 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -944,7 +944,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 			    scmd->sdb.length);
 		scmd->sdb.table.sgl = &ses->sense_sgl;
 		scmd->sc_data_direction = DMA_FROM_DEVICE;
-		scmd->sdb.table.nents = 1;
+		scmd->sdb.table.nents = scmd->sdb.table.orig_nents = 1;
 		scmd->cmnd[0] = REQUEST_SENSE;
 		scmd->cmnd[4] = scmd->sdb.length;
 		scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b1a2631..448ebda 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -583,7 +583,7 @@ static struct scatterlist *scsi_sg_alloc(unsigned int nents, gfp_t gfp_mask)
 
 static void scsi_free_sgtable(struct scsi_data_buffer *sdb, bool mq)
 {
-	if (mq && sdb->table.nents <= SCSI_MAX_SG_SEGMENTS)
+	if (mq && sdb->table.orig_nents <= SCSI_MAX_SG_SEGMENTS)
 		return;
 	__sg_free_table(&sdb->table, SCSI_MAX_SG_SEGMENTS, mq, scsi_sg_free);
 }
@@ -597,8 +597,8 @@ static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents, bool mq)
 
 	if (mq) {
 		if (nents <= SCSI_MAX_SG_SEGMENTS) {
-			sdb->table.nents = nents;
-			sg_init_table(sdb->table.sgl, sdb->table.nents);
+			sdb->table.nents = sdb->table.orig_nents = nents;
+			sg_init_table(sdb->table.sgl, nents);
 			return 0;
 		}
 		first_chunk = sdb->table.sgl;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3b2fcb4..a20da8c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2770,9 +2770,9 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	max_xfer = sdkp->max_xfer_blocks;
 	max_xfer <<= ilog2(sdp->sector_size) - 9;
 
-	max_xfer = min_not_zero(queue_max_hw_sectors(sdkp->disk->queue),
-				max_xfer);
-	blk_queue_max_hw_sectors(sdkp->disk->queue, max_xfer);
+	sdkp->disk->queue->limits.max_sectors =
+		min_not_zero(queue_max_hw_sectors(sdkp->disk->queue), max_xfer);
+
 	set_capacity(disk, sdkp->capacity);
 	sd_config_write_same(sdkp);
 	kfree(buffer);
