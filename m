From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] make a few more routines private to scsi_lib.c
Date: Thu, 21 Nov 2002 00:41:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021121004153.C8517@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.44/drivers/scsi/scsi.h	Sun Nov 17 16:44:35 2002
+++ edited/drivers/scsi/scsi.h	Wed Nov 20 02:20:16 2002
@@ -445,10 +445,6 @@
  * Prototypes for functions in scsi_lib.c
  */
 extern int scsi_maybe_unblock_host(Scsi_Device * SDpnt);
-extern Scsi_Cmnd *scsi_end_request(Scsi_Cmnd * SCpnt, int uptodate,
-				   int sectors);
-extern struct Scsi_Device_Template *scsi_get_request_dev(struct request *);
-extern int scsi_init_cmd_errh(Scsi_Cmnd * SCpnt);
 extern void scsi_setup_cmd_retry(Scsi_Cmnd *SCpnt);
 extern int scsi_insert_special_cmd(Scsi_Cmnd * SCpnt, int);
 extern void scsi_io_completion(Scsi_Cmnd * SCpnt, int good_sectors,
--- 1.48/drivers/scsi/scsi_lib.c	Tue Nov 19 20:13:41 2002
+++ edited/drivers/scsi/scsi_lib.c	Wed Nov 20 02:20:16 2002
@@ -94,7 +94,7 @@
  *              fields related to error handling.   Typically this will
  *              be called once for each command, as required.
  */
-int scsi_init_cmd_errh(Scsi_Cmnd * SCpnt)
+static int scsi_init_cmd_errh(Scsi_Cmnd * SCpnt)
 {
 	SCpnt->owner = SCSI_OWNER_MIDLEVEL;
 	SCpnt->reset_chain = NULL;
@@ -305,11 +305,10 @@
  *		We are guaranteeing that the request queue will be goosed
  *		at some point during this call.
  */
-static Scsi_Cmnd *__scsi_end_request(Scsi_Cmnd * SCpnt, 
+static Scsi_Cmnd *scsi_end_request(Scsi_Cmnd * SCpnt, 
 				     int uptodate, 
 				     int sectors,
-				     int requeue,
-				     int frequeue)
+				     int requeue)
 {
 	request_queue_t *q = &SCpnt->device->request_queue;
 	struct request *req = SCpnt->request;
@@ -336,12 +335,9 @@
 	add_disk_randomness(req->rq_disk);
 
 	spin_lock_irqsave(q->queue_lock, flags);
-
 	if (blk_rq_tagged(req))
 		blk_queue_end_tag(q, req);
-
 	end_that_request_last(req);
-
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	/*
@@ -349,39 +345,11 @@
 	 * need to worry about launching another command.
 	 */
 	__scsi_release_command(SCpnt);
-
-	if (frequeue)
-		scsi_queue_next_request(q, NULL);
-
+	scsi_queue_next_request(q, NULL);
 	return NULL;
 }
 
 /*
- * Function:    scsi_end_request()
- *
- * Purpose:     Post-processing of completed commands called from interrupt
- *              handler or a bottom-half handler.
- *
- * Arguments:   SCpnt    - command that is complete.
- *              uptodate - 1 if I/O indicates success, 0 for I/O error.
- *              sectors  - number of sectors we want to mark.
- *
- * Lock status: Assumed that lock is not held upon entry.
- *
- * Returns:     Nothing
- *
- * Notes:       This is called for block device requests in order to
- *              mark some number of sectors as complete.
- * 
- *		We are guaranteeing that the request queue will be goosed
- *		at some point during this call.
- */
-Scsi_Cmnd *scsi_end_request(Scsi_Cmnd * SCpnt, int uptodate, int sectors)
-{
-	return __scsi_end_request(SCpnt, uptodate, sectors, 1, 1);
-}
-
-/*
  * Function:    scsi_release_buffers()
  *
  * Purpose:     Completion processing for block device I/O requests.
@@ -428,6 +396,29 @@
 }
 
 /*
+ * Function:    scsi_get_request_dev()
+ *
+ * Purpose:     Find the upper-level driver that is responsible for this
+ *              request
+ *
+ * Arguments:   request   - I/O request we are preparing to queue.
+ *
+ * Lock status: No locks assumed to be held, but as it happens the
+ *              q->queue_lock is held when this is called.
+ *
+ * Returns:     Nothing
+ *
+ * Notes:       The requests in the request queue may have originated
+ *              from any block device driver.  We need to find out which
+ *              one so that we can later form the appropriate command.
+ */
+static struct Scsi_Device_Template *scsi_get_request_dev(struct request *req)
+{
+	struct gendisk *p = req->rq_disk;
+	return p ? *(struct Scsi_Device_Template **)p->private_data : NULL;
+}
+
+/*
  * Function:    scsi_io_completion()
  *
  * Purpose:     Completion processing for block device I/O requests.
@@ -526,11 +517,7 @@
 		 * requeueing right here - we will requeue down below
 		 * when we handle the bad sectors.
 		 */
-		SCpnt = __scsi_end_request(SCpnt, 
-					   1, 
-					   good_sectors,
-					   result == 0,
-					   1);
+		SCpnt = scsi_end_request(SCpnt, 1, good_sectors, result == 0);
 
 		/*
 		 * If the command completed without error, then either finish off the
@@ -573,7 +560,8 @@
 					 * and quietly refuse further access.
 		 			 */
 					SCpnt->device->changed = 1;
-					SCpnt = scsi_end_request(SCpnt, 0, this_count);
+					SCpnt = scsi_end_request(SCpnt, 0,
+							this_count, 1);
 					return;
 				} else {
 					/*
@@ -605,14 +593,14 @@
 				scsi_queue_next_request(q, SCpnt);
 				result = 0;
 			} else {
-				SCpnt = scsi_end_request(SCpnt, 0, this_count);
+				SCpnt = scsi_end_request(SCpnt, 0, this_count, 1);
 				return;
 			}
 			break;
 		case NOT_READY:
 			printk(KERN_INFO "Device %s not ready.\n",
 			       req->rq_disk ? req->rq_disk->disk_name : "");
-			SCpnt = scsi_end_request(SCpnt, 0, this_count);
+			SCpnt = scsi_end_request(SCpnt, 0, this_count, 1);
 			return;
 			break;
 		case MEDIUM_ERROR:
@@ -622,7 +610,7 @@
 			       (int) SCpnt->target, (int) SCpnt->lun);
 			print_command(SCpnt->data_cmnd);
 			print_sense("sd", SCpnt);
-			SCpnt = scsi_end_request(SCpnt, 0, block_sectors);
+			SCpnt = scsi_end_request(SCpnt, 0, block_sectors, 1);
 			return;
 		default:
 			break;
@@ -655,35 +643,12 @@
 		 * We sometimes get this cruft in the event that a medium error
 		 * isn't properly reported.
 		 */
-		SCpnt = scsi_end_request(SCpnt, 0, req->current_nr_sectors);
+		SCpnt = scsi_end_request(SCpnt, 0, req->current_nr_sectors, 1);
 		return;
 	}
 }
 
 /*
- * Function:    scsi_get_request_dev()
- *
- * Purpose:     Find the upper-level driver that is responsible for this
- *              request
- *
- * Arguments:   request   - I/O request we are preparing to queue.
- *
- * Lock status: No locks assumed to be held, but as it happens the
- *              q->queue_lock is held when this is called.
- *
- * Returns:     Nothing
- *
- * Notes:       The requests in the request queue may have originated
- *              from any block device driver.  We need to find out which
- *              one so that we can later form the appropriate command.
- */
-struct Scsi_Device_Template *scsi_get_request_dev(struct request *req)
-{
-	struct gendisk *p = req->rq_disk;
-	return p ? *(struct Scsi_Device_Template **)p->private_data : NULL;
-}
-
-/*
  * Function:    scsi_init_io()
  *
  * Purpose:     SCSI I/O initialize function.
@@ -762,7 +727,7 @@
 	/*
 	 * kill it. there should be no leftover blocks in this request
 	 */
-	SCpnt = scsi_end_request(SCpnt, 0, req->nr_sectors);
+	SCpnt = scsi_end_request(SCpnt, 0, req->nr_sectors, 1);
 	BUG_ON(SCpnt);
 	ret = BLKPREP_KILL;
 out:
===== drivers/scsi/scsi_syms.c 1.19 vs edited =====
--- 1.19/drivers/scsi/scsi_syms.c	Sat Nov 16 20:26:02 2002
+++ edited/drivers/scsi/scsi_syms.c	Wed Nov 20 02:20:16 2002
@@ -75,7 +75,6 @@
 EXPORT_SYMBOL(scsi_sleep);
 
 EXPORT_SYMBOL(scsi_io_completion);
-EXPORT_SYMBOL(scsi_end_request);
 
 EXPORT_SYMBOL(scsi_register_blocked_host);
 EXPORT_SYMBOL(scsi_deregister_blocked_host);
