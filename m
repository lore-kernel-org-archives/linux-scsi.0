From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/41] block: remove spurious uses of
	REQ_HARDBARRIER
Date: Fri,  3 Sep 2010 12:29:20 +0200
Message-ID: <1283509796-1510-6-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Peter Osterlund <petero2@telia.com>
List-Id: linux-scsi@vger.kernel.org

REQ_HARDBARRIER is deprecated.  Remove spurious uses in the following
users.  Please note that other than osdblk, all other uses were
already spurious before deprecation.

* osdblk: osdblk_rq_fn() won't receive any request with
  REQ_HARDBARRIER set.  Remove the test for it.

* pktcdvd: use of REQ_HARDBARRIER in pkt_generic_packet() doesn't mean
  anything.  Removed.

* aic7xxx_old: Setting MSG_ORDERED_Q_TAG on REQ_HARDBARRIER is
  spurious.  Removed.

* sas_scsi_host: Setting TASK_ATTR_ORDERED on REQ_HARDBARRIER is
  spurious.  Removed.

* scsi_tcq: The ordered tag path wasn't being used anyway.  Removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: Peter Osterlund <petero2@telia.com>
---
 drivers/block/osdblk.c              |    3 +--
 drivers/block/pktcdvd.c             |    1 -
 drivers/scsi/aic7xxx_old.c          |   21 ++-------------------
 drivers/scsi/libsas/sas_scsi_host.c |   13 +------------
 include/scsi/scsi_tcq.h             |    6 +-----
 5 files changed, 5 insertions(+), 39 deletions(-)

diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index 72d6246..87311eb 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -310,8 +310,7 @@ static void osdblk_rq_fn(struct request_queue *q)
 			break;
 
 		/* filter out block requests we don't understand */
-		if (rq->cmd_type != REQ_TYPE_FS &&
-		    !(rq->cmd_flags & REQ_HARDBARRIER)) {
+		if (rq->cmd_type != REQ_TYPE_FS) {
 			blk_end_request_all(rq, 0);
 			continue;
 		}
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index b1cbeb5..0166ea1 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -753,7 +753,6 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 
 	rq->timeout = 60*HZ;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->cmd_flags |= REQ_HARDBARRIER;
 	if (cgc->quiet)
 		rq->cmd_flags |= REQ_QUIET;
 
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 93984c9..e1cd606 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -2850,12 +2850,6 @@ aic7xxx_done(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
       aic_dev->r_total++;
       ptr = aic_dev->r_bins;
     }
-    if(cmd->device->simple_tags && cmd->request->cmd_flags & REQ_HARDBARRIER)
-    {
-      aic_dev->barrier_total++;
-      if(scb->tag_action == MSG_ORDERED_Q_TAG)
-        aic_dev->ordered_total++;
-    }
     x = scb->sg_length;
     x >>= 10;
     for(i=0; i<6; i++)
@@ -10144,19 +10138,8 @@ static void aic7xxx_buildscb(struct aic7xxx_host *p, struct scsi_cmnd *cmd,
     /* We always force TEST_UNIT_READY to untagged */
     if (cmd->cmnd[0] != TEST_UNIT_READY && sdptr->simple_tags)
     {
-      if (req->cmd_flags & REQ_HARDBARRIER)
-      {
-	if(sdptr->ordered_tags)
-	{
-          hscb->control |= MSG_ORDERED_Q_TAG;
-          scb->tag_action = MSG_ORDERED_Q_TAG;
-	}
-      }
-      else
-      {
-        hscb->control |= MSG_SIMPLE_Q_TAG;
-        scb->tag_action = MSG_SIMPLE_Q_TAG;
-      }
+      hscb->control |= MSG_SIMPLE_Q_TAG;
+      scb->tag_action = MSG_SIMPLE_Q_TAG;
     }
   }
   if ( !(aic_dev->dtr_pending) &&
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index f0cfba9..535085c 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -130,17 +130,6 @@ static void sas_scsi_task_done(struct sas_task *task)
 	sc->scsi_done(sc);
 }
 
-static enum task_attribute sas_scsi_get_task_attr(struct scsi_cmnd *cmd)
-{
-	enum task_attribute ta = TASK_ATTR_SIMPLE;
-	if (cmd->request && blk_rq_tagged(cmd->request)) {
-		if (cmd->device->ordered_tags &&
-		    (cmd->request->cmd_flags & REQ_HARDBARRIER))
-			ta = TASK_ATTR_ORDERED;
-	}
-	return ta;
-}
-
 static struct sas_task *sas_create_task(struct scsi_cmnd *cmd,
 					       struct domain_device *dev,
 					       gfp_t gfp_flags)
@@ -160,7 +149,7 @@ static struct sas_task *sas_create_task(struct scsi_cmnd *cmd,
 	task->ssp_task.retry_count = 1;
 	int_to_scsilun(cmd->device->lun, &lun);
 	memcpy(task->ssp_task.LUN, &lun.scsi_lun, 8);
-	task->ssp_task.task_attr = sas_scsi_get_task_attr(cmd);
+	task->ssp_task.task_attr = TASK_ATTR_SIMPLE;
 	memcpy(task->ssp_task.cdb, cmd->cmnd, 16);
 
 	task->scatter = scsi_sglist(cmd);
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index 1723138..d6e7994 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -97,13 +97,9 @@ static inline void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
 static inline int scsi_populate_tag_msg(struct scsi_cmnd *cmd, char *msg)
 {
         struct request *req = cmd->request;
-	struct scsi_device *sdev = cmd->device;
 
         if (blk_rq_tagged(req)) {
-		if (sdev->ordered_tags && req->cmd_flags & REQ_HARDBARRIER)
-        	        *msg++ = MSG_ORDERED_TAG;
-        	else
-        	        *msg++ = MSG_SIMPLE_TAG;
+		*msg++ = MSG_SIMPLE_TAG;
         	*msg++ = req->tag;
         	return 2;
 	}
-- 
1.7.1
