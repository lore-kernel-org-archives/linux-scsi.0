From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Addition of generic block tag command queuing to the mid-layer (2/3)
Date: Mon, 10 Jun 2002 23:04:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206110304.g5B34QF07119@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_2087190120"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id UAA06842
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jun 2002 20:04:30 -0700
Received: from localhost.localdomain (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id UAA06703
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jun 2002 20:04:27 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g5B34QF07119
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jun 2002 23:04:26 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multipart MIME message.

--==_Exmh_2087190120
Content-Type: text/plain; charset=us-ascii

Note: in addition to the block layer tag changes, you also need the patch sent 
to this list separately under

[PATCH 2.5.17] Making SCSI not copy the request structure

To make all this work.

The essential features of this are:

Extra functions to:
- Find a tag given the Scsi_Device
- find a scsi device given the host, pun and lun

Should process generic tags correctly in the requests.

Adds a use_blk_tcq flag in the host structure to turn on using the generic tcq 
functions.

comments welcome.

James Bottomley

PS I have this up and running on my build system and it seems stable.  
However, there were a lot of subtle (and data eating) errors getting to this 
stage so use at your own risk.



--==_Exmh_2087190120
Content-Type: text/plain ; name="scsi-blk-tag-2.5.21.diff"; charset=us-ascii
Content-Description: scsi-blk-tag-2.5.21.diff
Content-Disposition: attachment; filename="scsi-blk-tag-2.5.21.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.583   -> 1.585  
#	drivers/scsi/hosts.c	1.8     -> 1.9    
#	 drivers/scsi/scsi.h	1.13    -> 1.15   
#	drivers/scsi/hosts.h	1.8     -> 1.10   
#	drivers/scsi/scsi_lib.c	1.23    -> 1.25   
#	 drivers/scsi/scsi.c	1.29    -> 1.30   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 02/06/02	jejb@mulgrave.(none)	1.584
# Initial support (mid-layer) for generic TCQ
# --------------------------------------------
# 02/06/09	jejb@mulgrave.(none)	1.369.88.2
# [SCSI 53c700] bux fix in tag starvation, cosmetic cleanup of set_depth
# --------------------------------------------
# 02/06/09	jejb@mulgrave.(none)	1.369.88.3
# [SCSI 53c700] update version to 2.8
# --------------------------------------------
# 02/06/10	jejb@mulgrave.(none)	1.585
# [SCSI mid-layer]
# 
# Add support for generic blk layer TCQ (needs blk_queue_find_tag
# function)
# --------------------------------------------
#
diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Mon Jun 10 22:51:46 2002
+++ b/drivers/scsi/hosts.c	Mon Jun 10 22:51:46 2002
@@ -230,6 +230,7 @@
 
     retval->select_queue_depths = tpnt->select_queue_depths;
     retval->max_sectors = tpnt->max_sectors;
+    retval->use_blk_tcq = tpnt->use_blk_tcq;
 
     if(!scsi_hostlist)
 	scsi_hostlist = retval;
diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
--- a/drivers/scsi/hosts.h	Mon Jun 10 22:51:46 2002
+++ b/drivers/scsi/hosts.h	Mon Jun 10 22:51:46 2002
@@ -286,6 +286,12 @@
 
     unsigned highmem_io:1;
 
+    /* 
+     * True if the driver wishes to use the generic block layer
+     * tag queueing functions
+     */
+    unsigned use_blk_tcq:1;
+
     /*
      * Name of proc directory
      */
@@ -386,6 +392,7 @@
     unsigned unchecked_isa_dma:1;
     unsigned use_clustering:1;
     unsigned highmem_io:1;
+    unsigned use_blk_tcq:1;
 
     /*
      * Host has rejected a command because it was busy.
@@ -555,6 +562,26 @@
 #define SD_EXTRA_DEVS CONFIG_SD_EXTRA_DEVS
 #define SR_EXTRA_DEVS CONFIG_SR_EXTRA_DEVS
 
+
+/**
+ * scsi_find_device - find a device given the host
+ * @channel:	SCSI channel (zero if only one channel)
+ * @pun:	SCSI target number (physical unit number)
+ * @lun:	SCSI Logical Unit Number
+ **/
+static inline Scsi_Device *scsi_find_device(struct Scsi_Host *host,
+                                            int channel, int pun, int lun) {
+        Scsi_Device *SDpnt;
+
+        for(SDpnt = host->host_queue;
+            SDpnt != NULL;
+            SDpnt = SDpnt->next)
+                if(SDpnt->channel == channel && SDpnt->id == pun
+                   && SDpnt->lun ==lun)
+                        break;
+        return SDpnt;
+}
+    
 #endif
 /*
  * Overrides for Emacs so that we follow Linus's tabbing style.
diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Mon Jun 10 22:51:46 2002
+++ b/drivers/scsi/scsi.c	Mon Jun 10 22:51:46 2002
@@ -254,10 +254,19 @@
  
 static void scsi_wait_done(Scsi_Cmnd * SCpnt)
 {
-	struct request *req;
+	struct request *req = SCpnt->request;
+        struct request_queue *q = &SCpnt->device->request_queue;
+        unsigned long flags;
 
-	req = SCpnt->request;
+        ASSERT_LOCK(q->queue_lock, 0);
 	req->rq_status = RQ_SCSI_DONE;	/* Busy, but indicate request done */
+
+        spin_lock_irqsave(q->queue_lock, flags);
+
+        if(blk_rq_tagged(req))
+                blk_queue_end_tag(q, req);
+
+        spin_unlock_irqrestore(q->queue_lock, flags);
 
 	if (req->waiting)
 		complete(req->waiting);
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Mon Jun 10 22:51:46 2002
+++ b/drivers/scsi/scsi.h	Mon Jun 10 22:51:46 2002
@@ -560,6 +560,7 @@
         atomic_t                device_active; /* commands checked out for device */
 	volatile unsigned short device_busy;	/* commands actually active on low-level */
 	Scsi_Cmnd *device_queue;	/* queue of SCSI Command structures */
+        Scsi_Cmnd *current_cmnd;	/* currently active command */
 
 	unsigned int id, lun, channel;
 
@@ -849,6 +850,89 @@
 #define SCSI_TRY_RESET_HOST	3
 
 extern int scsi_reset_provider(Scsi_Device *, int);
+
+/**
+ * scsi_activate_tcq - turn on tag command queueing
+ * @SDpnt:	device to turn on TCQ for
+ * @depth:	queue depth
+ *
+ * Notes:
+ *	Eventually, I hope depth would be the maximum depth
+ *	the device could cope with and the real queue depth
+ *	would be adjustable from 0 to depth.
+ **/
+static inline void scsi_activate_tcq(Scsi_Device *SDpnt, int depth) {
+        request_queue_t *q = &SDpnt->request_queue;
+
+        if(SDpnt->tagged_supported && !blk_queue_tagged(q)) {
+                blk_queue_init_tags(q, depth);
+                SDpnt->tagged_queue = 1;
+        }
+}
+
+/**
+ * scsi_deactivate_tcq - turn off tag command queueing
+ * @SDpnt:	device to turn off TCQ for
+ **/
+static inline void scsi_deactivate_tcq(Scsi_Device *SDpnt) {
+        blk_queue_free_tags(&SDpnt->request_queue);
+        SDpnt->tagged_queue = 0;
+}
+#define MSG_SIMPLE_TAG	0x20
+#define MSG_HEAD_TAG	0x21
+#define MSG_ORDERED_TAG	0x22
+
+#define SCSI_NO_TAG	(-1)    /* identify no tag in use */
+
+/**
+ * scsi_populate_tag_msg - place a tag message in a buffer
+ * @SCpnt:	pointer to the Scsi_Cmnd for the tag
+ * @msg:	pointer to the area to place the tag
+ *
+ * Notes:
+ *	designed to create the correct type of tag message for the 
+ *	particular request.  Returns the size of the tag message.
+ *	May return 0 if TCQ is disabled for this device.
+ **/
+static inline int scsi_populate_tag_msg(Scsi_Cmnd *SCpnt, char *msg) {
+        struct request *req = SCpnt->request;
+
+        if(!blk_rq_tagged(req))
+                return 0;
+    
+        if(req->flags & REQ_BARRIER)
+                *msg++ = MSG_ORDERED_TAG;
+        else
+                *msg++ = MSG_SIMPLE_TAG;
+
+        *msg++ = SCpnt->request->tag;
+
+        return 2;
+}
+
+/**
+ * scsi_find_tag - find a tagged command by device
+ * @SDpnt:	pointer to the ScSI device
+ * @tag:	the tag number
+ *
+ * Notes:
+ *	Only works with tags allocated by the generic blk layer.
+ **/
+static inline Scsi_Cmnd *scsi_find_tag(Scsi_Device *SDpnt, int tag) {
+
+        struct request *req;
+
+        if(tag == SCSI_NO_TAG)
+                /* single command, look in space */
+                return SDpnt->current_cmnd;
+
+        req = blk_queue_find_tag(&SDpnt->request_queue, tag);
+
+        if(req == NULL)
+                return NULL;
+
+        return (Scsi_Cmnd *)req->special;
+}
 
 #endif
 
diff -Nru a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Mon Jun 10 22:51:46 2002
+++ b/drivers/scsi/scsi_lib.c	Mon Jun 10 22:51:46 2002
@@ -76,7 +76,8 @@
 	 * must not attempt merges on this) and that it acts as a soft
 	 * barrier
 	 */
-	rq->flags = REQ_SPECIAL | REQ_BARRIER;
+	rq->flags &= REQ_QUEUED;
+	rq->flags |= REQ_SPECIAL | REQ_BARRIER;
 
 	rq->special = data;
 
@@ -87,6 +88,9 @@
 	 * device, or a host that is unable to accept a particular command.
 	 */
 	spin_lock_irqsave(q->queue_lock, flags);
+	/* If command is tagged, release the tag */
+	if(blk_rq_tagged(rq))
+		blk_queue_end_tag(q, rq);
 	_elv_add_request(q, rq, !at_head, 0);
 	q->request_fn(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
@@ -378,6 +382,9 @@
 
 	add_blkdev_randomness(major(req->rq_dev));
 
+	if(blk_rq_tagged(req))
+		blk_queue_end_tag(q, req);
+
 	end_that_request_last(req);
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
@@ -924,8 +931,13 @@
 		 * reason to search the list, because all of the commands
 		 * in this queue are for the same device.
 		 */
-		blkdev_dequeue_request(req);
+		if(!(blk_queue_tagged(q) && (blk_queue_start_tag(q, req) == 0)))
+			blkdev_dequeue_request(req);
 
+		/* note the overloading of req->special.  When the tag
+		 * is active it always means SCpnt.  If the tag goes
+		 * back for re-queueing, it may be reset */
+		req->special = SCpnt;
 		SCpnt->request = req;
 
 		/*

--==_Exmh_2087190120--


