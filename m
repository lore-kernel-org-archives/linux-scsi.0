From: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH] Get rid of scsi_cmnd->done
Date: Tue, 25 Sep 2007 12:42:04 -0400
Message-ID: <11907385242390-git-send-email-willy@linux.intel.com>
References: <1190738524460-git-send-email-willy@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:51658 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbXIYQmH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 12:42:07 -0400
In-Reply-To: <1190738524460-git-send-email-willy@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

From: Matthew Wilcox <matthew@wil.cx>

The ULD ->done callback moves into the scsi_driver.  By moving the call
to scsi_io_completion() from scsi_blk_pc_done() to scsi_finish_command(),
we can eliminate the latter entirely.  By returning 'good_bytes' from
the ->done callback (rather than invoking scsi_io_completion()), we can
stop exporting scsi_io_completion().

Also move the prototypes from sd.h to sd.c as they're all internal anyway.
Rename sd_rw_intr to sd_done and rw_intr to sr_done.

Inspired-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/scsi.c        |   20 +++++++++++++++++---
 drivers/scsi/scsi_error.c  |    1 -
 drivers/scsi/scsi_lib.c    |   14 --------------
 drivers/scsi/scsi_priv.h   |    1 +
 drivers/scsi/sd.c          |   28 ++++++++++++++++++----------
 drivers/scsi/sr.c          |   21 ++++++---------------
 include/scsi/scsi_cmnd.h   |    2 --
 include/scsi/scsi_driver.h |    1 +
 include/scsi/sd.h          |   13 -------------
 9 files changed, 43 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index a5de1a8..60799ff 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -59,6 +59,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
@@ -367,9 +368,8 @@ void scsi_log_send(struct scsi_cmnd *cmd)
 			scsi_print_command(cmd);
 			if (level > 3) {
 				printk(KERN_INFO "buffer = 0x%p, bufflen = %d,"
-				       " done = 0x%p, queuecommand 0x%p\n",
+				       " queuecommand 0x%p\n",
 					scsi_sglist(cmd), scsi_bufflen(cmd),
-					cmd->done,
 					cmd->device->host->hostt->queuecommand);
 
 			}
@@ -658,6 +658,12 @@ void __scsi_done(struct scsi_cmnd *cmd)
 	blk_complete_request(rq);
 }
 
+/* Move this to a header if it becomes more generally useful */
+static struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
+{
+	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
+}
+
 /*
  * Function:    scsi_finish_command
  *
@@ -669,6 +675,8 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
 	struct Scsi_Host *shost = sdev->host;
+	struct scsi_driver *drv;
+	unsigned int good_bytes;
 
 	scsi_device_unbusy(sdev);
 
@@ -694,7 +702,13 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 				"Notifying upper driver of completion "
 				"(result %x)\n", cmd->result));
 
-	cmd->done(cmd);
+	good_bytes = cmd->request_bufflen;
+        if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
+		drv = scsi_cmd_to_driver(cmd);
+		if (drv->done)
+			good_bytes = drv->done(cmd);
+	}
+	scsi_io_completion(cmd, good_bytes);
 }
 EXPORT_SYMBOL(scsi_finish_command);
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c05d020..10f6acc 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1671,7 +1671,6 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	memset(&scmd->cmnd, '\0', sizeof(scmd->cmnd));
     
 	scmd->scsi_done		= scsi_reset_provider_done_command;
-	scmd->done			= NULL;
 	scmd->request_buffer		= NULL;
 	scmd->request_bufflen		= 0;
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 94d82cb..cb8a577 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -982,7 +982,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	}
 	scsi_end_request(cmd, 0, this_count, !result);
 }
-EXPORT_SYMBOL(scsi_io_completion);
 
 /*
  * Function:    scsi_init_io()
@@ -1063,18 +1062,6 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 	return cmd;
 }
 
-static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
-{
-	BUG_ON(!blk_pc_request(cmd->request));
-	/*
-	 * This will complete the whole command with uptodate=1 so
-	 * as far as the block layer is concerned the command completed
-	 * successfully. Since this is a REQ_BLOCK_PC command the
-	 * caller should check the request's errors value
-	 */
-	scsi_io_completion(cmd, cmd->request_bufflen);
-}
-
 int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 {
 	struct scsi_cmnd *cmd;
@@ -1124,7 +1111,6 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 	cmd->transfersize = req->data_len;
 	cmd->allowed = req->retries;
 	cmd->timeout_per_command = req->timeout;
-	cmd->done = scsi_blk_pc_done;
 	return BLKPREP_OK;
 }
 EXPORT_SYMBOL(scsi_setup_blk_pc_cmnd);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index ee8efe8..eff0059 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -68,6 +68,7 @@ extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
 extern void scsi_device_unbusy(struct scsi_device *sdev);
 extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
 extern void scsi_next_command(struct scsi_cmnd *cmd);
+extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
 extern void scsi_free_queue(struct request_queue *q);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 38a4141..0a3a528 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -86,6 +86,19 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_DISK);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 
+static int  sd_revalidate_disk(struct gendisk *);
+static int  sd_probe(struct device *);
+static int  sd_remove(struct device *);
+static void sd_shutdown(struct device *);
+static int sd_suspend(struct device *, pm_message_t state);
+static int sd_resume(struct device *);
+static void sd_rescan(struct device *);
+static int sd_done(struct scsi_cmnd *);
+static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
+static void scsi_disk_release(struct class_device *cdev);
+static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
+static void sd_print_result(struct scsi_disk *, int);
+
 static DEFINE_IDR(sd_index_idr);
 static DEFINE_SPINLOCK(sd_index_lock);
 
@@ -240,6 +253,7 @@ static struct scsi_driver sd_template = {
 		.shutdown	= sd_shutdown,
 	},
 	.rescan			= sd_rescan,
+	.done			= sd_done,
 };
 
 /*
@@ -509,12 +523,6 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	SCpnt->timeout_per_command = timeout;
 
 	/*
-	 * This is the completion routine we use.  This is matched in terms
-	 * of capability to this function.
-	 */
-	SCpnt->done = sd_rw_intr;
-
-	/*
 	 * This indicates that the command is ready from our end to be
 	 * queued.
 	 */
@@ -908,13 +916,13 @@ static struct block_device_operations sd_fops = {
 };
 
 /**
- *	sd_rw_intr - bottom half handler: called when the lower level
+ *	sd_done - bottom half handler: called when the lower level
  *	driver has completed (successfully or otherwise) a scsi command.
  *	@SCpnt: mid-level's per command structure.
  *
  *	Note: potentially run from within an ISR. Must not block.
  **/
-static void sd_rw_intr(struct scsi_cmnd * SCpnt)
+static int sd_done(struct scsi_cmnd *SCpnt)
 {
 	int result = SCpnt->result;
  	unsigned int xfer_size = SCpnt->request_bufflen;
@@ -935,7 +943,7 @@ static void sd_rw_intr(struct scsi_cmnd * SCpnt)
 	SCSI_LOG_HLCOMPLETE(1, scsi_print_result(SCpnt));
 	if (sense_valid) {
 		SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, SCpnt,
-						   "sd_rw_intr: sb[respc,sk,asc,"
+						   "sd_done: sb[respc,sk,asc,"
 						   "ascq]=%x,%x,%x,%x\n",
 						   sshdr.response_code,
 						   sshdr.sense_key, sshdr.asc,
@@ -1007,7 +1015,7 @@ static void sd_rw_intr(struct scsi_cmnd * SCpnt)
 		break;
 	}
  out:
-	scsi_io_completion(SCpnt, good_bytes);
+	return good_bytes;
 }
 
 static int media_not_present(struct scsi_disk *sdkp,
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a0c4e13..c619990 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -78,6 +78,7 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
 
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
+static int sr_done(struct scsi_cmnd *);
 
 static struct scsi_driver sr_template = {
 	.owner			= THIS_MODULE,
@@ -86,6 +87,7 @@ static struct scsi_driver sr_template = {
 		.probe		= sr_probe,
 		.remove		= sr_remove,
 	},
+	.done			= sr_done,
 };
 
 static unsigned long sr_index_bits[SR_DISKS / BITS_PER_LONG];
@@ -208,12 +210,12 @@ static int sr_media_change(struct cdrom_device_info *cdi, int slot)
 }
  
 /*
- * rw_intr is the interrupt routine for the device driver.
+ * sr_done is the interrupt routine for the device driver.
  *
- * It will be notified on the end of a SCSI read / write, and will take on
+ * It will be notified on the end of a SCSI read / write, and will take one
  * of several actions based on success or failure.
  */
-static void rw_intr(struct scsi_cmnd * SCpnt)
+static int sr_done(struct scsi_cmnd *SCpnt)
 {
 	int result = SCpnt->result;
 	int this_count = SCpnt->request_bufflen;
@@ -286,12 +288,7 @@ static void rw_intr(struct scsi_cmnd * SCpnt)
 		}
 	}
 
-	/*
-	 * This calls the generic completion function, now that we know
-	 * how many actual sectors finished, and how many sectors we need
-	 * to say have failed.
-	 */
-	scsi_io_completion(SCpnt, good_bytes);
+	return good_bytes;
 }
 
 static int sr_prep_fn(struct request_queue *q, struct request *rq)
@@ -428,12 +425,6 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 	SCpnt->timeout_per_command = timeout;
 
 	/*
-	 * This is the completion routine we use.  This is matched in terms
-	 * of capability to this function.
-	 */
-	SCpnt->done = rw_intr;
-
-	/*
 	 * This indicates that the command is ready from our end to be
 	 * queued.
 	 */
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 53e1705..b2888d7 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -33,7 +33,6 @@ struct scsi_cmnd {
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
 	struct list_head eh_entry; /* entry for the host eh_cmd_q */
 	int eh_eflags;		/* Used by error handlr */
-	void (*done) (struct scsi_cmnd *);	/* Mid-level done function */
 
 	/*
 	 * A SCSI Command is assigned a nonzero serial_number before passed
@@ -124,7 +123,6 @@ extern struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *, gfp_t);
 extern void scsi_put_command(struct scsi_cmnd *);
 extern void __scsi_put_command(struct Scsi_Host *, struct scsi_cmnd *,
 			       struct device *);
-extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 extern void scsi_req_abort_cmd(struct scsi_cmnd *cmd);
 
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 56a3047..1f5ca7f 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -15,6 +15,7 @@ struct scsi_driver {
 	struct device_driver	gendrv;
 
 	void (*rescan)(struct device *);
+	int (*done)(struct scsi_cmnd *);
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)
diff --git a/include/scsi/sd.h b/include/scsi/sd.h
index aa1e716..f751331 100644
--- a/include/scsi/sd.h
+++ b/include/scsi/sd.h
@@ -47,19 +47,6 @@ struct scsi_disk {
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,cdev)
 
-static int  sd_revalidate_disk(struct gendisk *disk);
-static void sd_rw_intr(struct scsi_cmnd * SCpnt);
-static int  sd_probe(struct device *);
-static int  sd_remove(struct device *);
-static void sd_shutdown(struct device *dev);
-static int sd_suspend(struct device *dev, pm_message_t state);
-static int sd_resume(struct device *dev);
-static void sd_rescan(struct device *);
-static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
-static void scsi_disk_release(struct class_device *cdev);
-static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
-static void sd_print_result(struct scsi_disk *, int);
-
 #define sd_printk(prefix, sdsk, fmt, a...)				\
         (sdsk)->disk ?							\
 	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\
-- 
1.5.3.1

