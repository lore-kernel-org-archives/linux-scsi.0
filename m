From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: [PATCH] add request prep functions to SCSI
Date: Wed, 06 Nov 2002 17:18:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211062218.gA6MI2t04813@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_10688416380"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA10619
	for <linux-scsi@vger.kernel.org>; Wed, 6 Nov 2002 14:18:11 -0800
Received: from localhost.localdomain (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id OAA10198
	for <linux-scsi@vger.kernel.org>; Wed, 6 Nov 2002 14:18:03 -0800
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id gA6MI2t04813
	for <linux-scsi@vger.kernel.org>; Wed, 6 Nov 2002 17:18:02 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multipart MIME message.

--==_Exmh_10688416380
Content-Type: text/plain; charset=us-ascii

This patch adds request prep functions to the mid-layer.  At the moment, its a single request prep function for all of SCSI.  I've altered the logic in scsi_request_fn so that we now do early preparation (this should improve throughput slightly in the untagged case with only a single command block).

The prep function also cannot drop the queue lock, so the calling assumptions for scsi_init_io and the upper layer driver init_commands have changed to be that the lock is now held and they cannot drop it.  I think this means that we have no callers of scsi_init_io that aren't atomic, so perhaps I can just take the if out.

I've hammered this in my usual set up, but other testers would be welcome.

James


--==_Exmh_10688416380
Content-Type: text/plain ; name="tmp.diff"; charset=us-ascii
Content-Description: tmp.diff
Content-Disposition: attachment; filename="tmp.diff"

===== drivers/scsi/scsi.c 1.56 vs edited =====
--- 1.56/drivers/scsi/scsi.c	Wed Nov  6 15:12:50 2002
+++ edited/drivers/scsi/scsi.c	Wed Nov  6 15:30:27 2002
@@ -226,6 +226,8 @@
 
 	if (!SHpnt->use_clustering)
 		clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
+
+        blk_queue_prep_rq(q, scsi_prep_fn);
 }
 
 #ifdef MODULE
===== drivers/scsi/scsi.h 1.34 vs edited =====
--- 1.34/drivers/scsi/scsi.h	Tue Nov  5 11:26:24 2002
+++ edited/drivers/scsi/scsi.h	Wed Nov  6 15:30:28 2002
@@ -455,6 +455,7 @@
 extern void scsi_io_completion(Scsi_Cmnd * SCpnt, int good_sectors,
 			       int block_sectors);
 extern void scsi_queue_next_request(request_queue_t * q, Scsi_Cmnd * SCpnt);
+extern int scsi_prep_fn(struct request_queue *q, struct request *req);
 extern void scsi_request_fn(request_queue_t * q);
 extern int scsi_starvation_completion(Scsi_Device * SDpnt);
 
===== drivers/scsi/scsi_lib.c 1.44 vs edited =====
--- 1.44/drivers/scsi/scsi_lib.c	Fri Nov  1 06:28:12 2002
+++ edited/drivers/scsi/scsi_lib.c	Wed Nov  6 16:11:13 2002
@@ -102,6 +102,13 @@
 {
 	request_queue_t *q = &SRpnt->sr_device->request_queue;
 
+	/* This is used to insert SRpnt specials.  Because users of
+	 * this function are apt to reuse requests with no modification,
+	 * we have to sanitise the request flags here
+	 */
+
+	SRpnt->sr_request->flags &= ~REQ_DONTPREP;
+
 	blk_insert_request(q, SRpnt->sr_request, at_head, SRpnt);
 	return 0;
 }
@@ -240,6 +247,12 @@
 		SCpnt->request->special = (void *) SCpnt;
 		if(blk_rq_tagged(SCpnt->request))
 			blk_queue_end_tag(q, SCpnt->request);
+		/* set REQ_SPECIAL - we have a command
+		 * clear REQ_DONTPREP - we assume the sg table has been 
+		 *	nuked so we need to set it up again.
+		 */
+		SCpnt->request->flags |= REQ_SPECIAL;
+		SCpnt->request->flags &= ~REQ_DONTPREP;
 		__elv_add_request(q, SCpnt->request, 0, 0);
 	}
 
@@ -741,7 +754,7 @@
 	SCpnt->use_sg = req->nr_phys_segments;
 
 	gfp_mask = GFP_NOIO;
-	if (in_interrupt()) {
+	if (likely(in_atomic())) {
 		gfp_mask &= ~__GFP_WAIT;
 		gfp_mask |= __GFP_HIGH;
 	}
@@ -788,6 +801,116 @@
 	return 0;
 }
 
+int scsi_prep_fn(struct request_queue *q, struct request *req)
+{
+	struct Scsi_Device_Template *STpnt;
+	Scsi_Cmnd *SCpnt;
+	Scsi_Device *SDpnt;
+
+	SDpnt = (Scsi_Device *) q->queuedata;
+	BUG_ON(!SDpnt);
+
+	/*
+	 * Find the actual device driver associated with this command.
+	 * The SPECIAL requests are things like character device or
+	 * ioctls, which did not originate from ll_rw_blk.  Note that
+	 * the special field is also used to indicate the SCpnt for
+	 * the remainder of a partially fulfilled request that can 
+	 * come up when there is a medium error.  We have to treat
+	 * these two cases differently.  We differentiate by looking
+	 * at request->cmd, as this tells us the real story.
+	 */
+	if (req->flags & REQ_SPECIAL) {
+		Scsi_Request *SRpnt;
+
+		STpnt = NULL;
+		SCpnt = (Scsi_Cmnd *) req->special;
+		SRpnt = (Scsi_Request *) req->special;
+		
+		if( SRpnt->sr_magic == SCSI_REQ_MAGIC ) {
+			SCpnt = scsi_allocate_device(SRpnt->sr_device, 
+						     FALSE, FALSE);
+			if (!SCpnt)
+				return BLKPREP_DEFER;
+			scsi_init_cmd_from_req(SCpnt, SRpnt);
+		}
+		
+	} else if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
+		/*
+		 * Now try and find a command block that we can use.
+		 */
+		if (req->special) {
+				SCpnt = (Scsi_Cmnd *) req->special;
+		} else {
+			SCpnt = scsi_allocate_device(SDpnt, FALSE, FALSE);
+		}
+		/*
+		 * if command allocation failure, wait a bit
+		 */
+		if (unlikely(!SCpnt))
+			return BLKPREP_DEFER;
+		
+		/* pull a tag out of the request if we have one */
+		SCpnt->tag = req->tag;
+	} else {
+		blk_dump_rq_flags(req, "SCSI bad req");
+		return BLKPREP_KILL;
+	}
+	
+	/* note the overloading of req->special.  When the tag
+	 * is active it always means SCpnt.  If the tag goes
+	 * back for re-queueing, it may be reset */
+	req->special = SCpnt;
+	SCpnt->request = req;
+	
+	/*
+	 * FIXME: drop the lock here because the functions below
+	 * expect to be called without the queue lock held.  Also,
+	 * previously, we dequeued the request before dropping the
+	 * lock.  We hope REQ_STARTED prevents anything untoward from
+	 * happening now.
+	 */
+
+	if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
+		/*
+		 * This will do a couple of things:
+		 *  1) Fill in the actual SCSI command.
+		 *  2) Fill in any other upper-level specific fields
+		 * (timeout).
+		 *
+		 * If this returns 0, it means that the request failed
+		 * (reading past end of disk, reading offline device,
+		 * etc).   This won't actually talk to the device, but
+		 * some kinds of consistency checking may cause the	
+		 * request to be rejected immediately.
+		 */
+		STpnt = scsi_get_request_dev(req);
+		BUG_ON(!STpnt);
+
+		/* 
+		 * This sets up the scatter-gather table (allocating if
+		 * required).
+		 */
+		if (!scsi_init_io(SCpnt)) {
+			/* Mark it as special --- We already have an
+			 * allocated command associated with it */
+			req->flags |= REQ_SPECIAL;
+			return BLKPREP_DEFER;
+		}
+		
+		/*
+		 * Initialize the actual SCSI command for this request.
+		 */
+		if (!STpnt->init_command(SCpnt)) {
+			scsi_release_buffers(SCpnt);
+			return BLKPREP_KILL;
+		}
+	}
+	/* The request is now prepped, no need to come back here */
+	req->flags |= REQ_DONTPREP;
+	return BLKPREP_OK;
+}
+
 /*
  * Function:    scsi_request_fn()
  *
@@ -811,10 +934,8 @@
 {
 	struct request *req;
 	Scsi_Cmnd *SCpnt;
-	Scsi_Request *SRpnt;
 	Scsi_Device *SDpnt;
 	struct Scsi_Host *SHpnt;
-	struct Scsi_Device_Template *STpnt;
 
 	ASSERT_LOCK(q->queue_lock, 1);
 
@@ -837,6 +958,14 @@
 		if (SHpnt->in_recovery || blk_queue_plugged(q))
 			return;
 
+		/*
+		 * get next queueable request.  We do this early to make sure
+		 * that the request is fully prepared even if we cannot 
+		 * accept it.  If there is no request, we'll detect this
+		 * lower down.
+		 */
+		req = elv_next_request(q);
+
 		if(SHpnt->host_busy == 0 && SHpnt->host_blocked) {
 			/* unblock after host_blocked iterates to zero */
 			if(--SHpnt->host_blocked == 0) {
@@ -888,141 +1017,40 @@
 		if (blk_queue_empty(q))
 			break;
 
-		/*
-		 * get next queueable request.
-		 */
-		req = elv_next_request(q);
-
-		/*
-		 * Find the actual device driver associated with this command.
-		 * The SPECIAL requests are things like character device or
-		 * ioctls, which did not originate from ll_rw_blk.  Note that
-		 * the special field is also used to indicate the SCpnt for
-		 * the remainder of a partially fulfilled request that can 
-		 * come up when there is a medium error.  We have to treat
-		 * these two cases differently.  We differentiate by looking
-		 * at request->cmd, as this tells us the real story.
-		 */
-		if (req->flags & REQ_SPECIAL) {
-			STpnt = NULL;
-			SCpnt = (Scsi_Cmnd *) req->special;
-			SRpnt = (Scsi_Request *) req->special;
-
-			if( SRpnt->sr_magic == SCSI_REQ_MAGIC ) {
-				SCpnt = scsi_allocate_device(SRpnt->sr_device, 
-							     FALSE, FALSE);
-				if (!SCpnt)
-					break;
-				scsi_init_cmd_from_req(SCpnt, SRpnt);
-			}
-
-		} else if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
-			SRpnt = NULL;
-			STpnt = scsi_get_request_dev(req);
-			if (!STpnt) {
-				panic("Unable to find device associated with request");
-			}
-			/*
-			 * Now try and find a command block that we can use.
-			 */
-			if (req->special) {
-				SCpnt = (Scsi_Cmnd *) req->special;
-			} else {
-				SCpnt = scsi_allocate_device(SDpnt, FALSE, FALSE);
-			}
-			/*
-			 * If so, we are ready to do something.  Bump the count
-			 * while the queue is locked and then break out of the
-			 * loop. Otherwise loop around and try another request.
-			 */
-			if (!SCpnt)
-				break;
-
-			/* pull a tag out of the request if we have one */
-			SCpnt->tag = req->tag;
-		} else {
-			blk_dump_rq_flags(req, "SCSI bad req");
+		if(!req) {
+			/* can happen if the prep fails 
+			 * FIXME: elv_next_request() should be plugging the
+			 * queue */
+			blk_plug_device(q);
 			break;
 		}
 
-		/*
-		 * Now bump the usage count for both the host and the
-		 * device.
+		SCpnt = (struct scsi_cmnd *)req->special;
+
+		/* Should be impossible for a correctly prepared request
+		 * please mail the stack trace to linux-scsi@vger.kernel.org
 		 */
-		SHpnt->host_busy++;
-		SDpnt->device_busy++;
+		BUG_ON(!SCpnt);
 
 		/*
 		 * Finally, before we release the lock, we copy the
 		 * request to the command block, and remove the
-		 * request from the request list.   Note that we always
+		 * request from the request list.  Note that we always
 		 * operate on the queue head - there is absolutely no
-		 * reason to search the list, because all of the commands
-		 * in this queue are for the same device.
+		 * reason to search the list, because all of the
+		 * commands in this queue are for the same device.
 		 */
 		if(!(blk_queue_tagged(q) && (blk_queue_start_tag(q, req) == 0)))
 			blkdev_dequeue_request(req);
-
-		/* note the overloading of req->special.  When the tag
-		 * is active it always means SCpnt.  If the tag goes
-		 * back for re-queueing, it may be reset */
-		req->special = SCpnt;
-		SCpnt->request = req;
-
+	
 		/*
-		 * Now it is finally safe to release the lock.  We are
-		 * not going to noodle the request list until this
-		 * request has been queued and we loop back to queue
-		 * another.  
+		 * Now bump the usage count for both the host and the
+		 * device.
 		 */
-		req = NULL;
+		SHpnt->host_busy++;
+		SDpnt->device_busy++;
 		spin_unlock_irq(q->queue_lock);
 
-		if (!(SCpnt->request->flags & REQ_DONTPREP)
-		    && (SCpnt->request->flags & (REQ_CMD | REQ_BLOCK_PC))) {
-			/*
-			 * This will do a couple of things:
-			 *  1) Fill in the actual SCSI command.
-			 *  2) Fill in any other upper-level specific fields
-			 * (timeout).
-			 *
-			 * If this returns 0, it means that the request failed
-			 * (reading past end of disk, reading offline device,
-			 * etc).   This won't actually talk to the device, but
-			 * some kinds of consistency checking may cause the	
-			 * request to be rejected immediately.
-			 */
-			if (STpnt == NULL)
-				STpnt = scsi_get_request_dev(SCpnt->request);
-
-			/* 
-			 * This sets up the scatter-gather table (allocating if
-			 * required).
-			 */
-			if (!scsi_init_io(SCpnt)) {
-				scsi_mlqueue_insert(SCpnt, SCSI_MLQUEUE_DEVICE_BUSY);
-				spin_lock_irq(q->queue_lock);
-				break;
-			}
-
-			/*
-			 * Initialize the actual SCSI command for this request.
-			 */
-			if (!STpnt->init_command(SCpnt)) {
-				scsi_release_buffers(SCpnt);
-				SCpnt = __scsi_end_request(SCpnt, 0, 
-							   SCpnt->request->nr_sectors, 0, 0);
-				if( SCpnt != NULL )
-				{
-					panic("Should not have leftover blocks\n");
-				}
-				spin_lock_irq(q->queue_lock);
-				SHpnt->host_busy--;
-				SDpnt->device_busy--;
-				continue;
-			}
-		}
-		SCpnt->request->flags |= REQ_DONTPREP;
 		/*
 		 * Finally, initialize any error handling parameters, and set up
 		 * the timers for timeouts.

--==_Exmh_10688416380--


