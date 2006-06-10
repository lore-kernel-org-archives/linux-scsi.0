From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove scsi_request infrastructure
Date: Sat, 10 Jun 2006 18:01:03 +0200
Message-ID: <20060610160103.GA11816@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:64986 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751193AbWFJQBJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 12:01:09 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

With Achim patch the last user (gdth) is switched away from scsi_request
so we an kill it now.  Also disables some code in i2o_scsi that was
broken since the sg driver stopped using scsi_requests.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/message/i2o/i2o_scsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/i2o/i2o_scsi.c	2006-06-10 17:11:14.000000000 +0200
+++ scsi-misc-2.6/drivers/message/i2o/i2o_scsi.c	2006-06-10 17:24:33.000000000 +0200
@@ -65,9 +65,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_request.h>
 #include <scsi/sg.h>
-#include <scsi/sg_request.h>
 
 #define OSM_NAME	"scsi-osm"
 #define OSM_VERSION	"1.316"
@@ -588,6 +586,7 @@
 
 	mptr = &msg->body[0];
 
+#if 0 /* this code can't work */
 #ifdef CONFIG_I2O_EXT_ADAPTEC
 	if (c->adaptec) {
 		u32 adpt_flags = 0;
@@ -625,6 +624,7 @@
 		*mptr++ = cpu_to_le32(adpt_flags | tid);
 	}
 #endif
+#endif
 
 	msg->u.head[1] = cpu_to_le32(cmd | HOST_TID << 12 | tid);
 	msg->u.s.icntxt = cpu_to_le32(i2o_scsi_driver.context);
Index: scsi-misc-2.6/drivers/scsi/constants.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/constants.c	2006-06-02 18:20:22.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/constants.c	2006-06-10 17:45:08.000000000 +0200
@@ -13,9 +13,9 @@
 #include <linux/kernel.h>
 
 #include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_request.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dbg.h>
 
@@ -1268,16 +1268,6 @@
 }
 EXPORT_SYMBOL(scsi_print_sense);
 
-void scsi_print_req_sense(const char *devclass, struct scsi_request *sreq)
-{
-	const char *name = devclass;
-
-	if (sreq->sr_request->rq_disk)
-		name = sreq->sr_request->rq_disk->disk_name;
-	__scsi_print_sense(name, sreq->sr_sense_buffer, SCSI_SENSE_BUFFERSIZE);
-}
-EXPORT_SYMBOL(scsi_print_req_sense);
-
 void scsi_print_command(struct scsi_cmnd *cmd)
 {
 	/* Assume appended output (i.e. not at start of line) */
Index: scsi-misc-2.6/drivers/scsi/gdth.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/gdth.c	2006-06-10 17:08:11.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/gdth.c	2006-06-10 17:37:56.000000000 +0200
@@ -716,8 +716,8 @@
 {
     TRACE2(("gdth_scsi_done()\n"));
 
-    if (scp->sc_request)
-        complete((struct completion *)scp->sc_request);
+    if (scp->request)
+        complete((struct completion *)scp->request);
 }
 
 int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
@@ -732,8 +732,8 @@
         return -ENOMEM;
     memset(scp, 0, sizeof(*scp));
     scp->device = sdev;
-    /* use sc_request field to save the ptr. to completion struct. */   
-    scp->sc_request = (struct scsi_request *)&wait;
+    /* use request field to save the ptr. to completion struct. */
+    scp->request = (struct request *)&wait;
     scp->timeout_per_command = timeout*HZ;
     scp->request_buffer = gdtcmd;
     scp->cmd_len = 12;
Index: scsi-misc-2.6/drivers/scsi/ipr.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/ipr.c	2006-06-02 18:20:22.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/ipr.c	2006-06-10 17:19:36.000000000 +0200
@@ -79,7 +79,6 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_request.h>
 #include "ipr.h"
 
 /*
Index: scsi-misc-2.6/drivers/scsi/libata-scsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/libata-scsi.c	2006-06-10 17:00:39.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/libata-scsi.c	2006-06-10 17:43:08.000000000 +0200
@@ -38,9 +38,9 @@
 #include <linux/spinlock.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_device.h>
-#include <scsi/scsi_request.h>
 #include <scsi/scsi_transport.h>
 #include <linux/libata.h>
 #include <linux/hdreg.h>
Index: scsi-misc-2.6/drivers/scsi/qlogicpti.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/qlogicpti.c	2006-06-02 18:20:23.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/qlogicpti.c	2006-06-10 17:19:43.000000000 +0200
@@ -43,7 +43,6 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_eh.h>
-#include <scsi/scsi_request.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_host.h>
 
Index: scsi-misc-2.6/drivers/scsi/scsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi.c	2006-06-10 16:59:29.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi.c	2006-06-10 17:22:08.000000000 +0200
@@ -63,7 +63,6 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
-#include <scsi/scsi_request.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -116,79 +115,6 @@
 };
 EXPORT_SYMBOL(scsi_device_types);
 
-/*
- * Function:    scsi_allocate_request
- *
- * Purpose:     Allocate a request descriptor.
- *
- * Arguments:   device		- device for which we want a request
- *		gfp_mask	- allocation flags passed to kmalloc
- *
- * Lock status: No locks assumed to be held.  This function is SMP-safe.
- *
- * Returns:     Pointer to request block.
- */
-struct scsi_request *scsi_allocate_request(struct scsi_device *sdev,
-					   gfp_t gfp_mask)
-{
-	const int offset = ALIGN(sizeof(struct scsi_request), 4);
-	const int size = offset + sizeof(struct request);
-	struct scsi_request *sreq;
-  
-	sreq = kzalloc(size, gfp_mask);
-	if (likely(sreq != NULL)) {
-		sreq->sr_request = (struct request *)(((char *)sreq) + offset);
-		sreq->sr_device = sdev;
-		sreq->sr_host = sdev->host;
-		sreq->sr_magic = SCSI_REQ_MAGIC;
-		sreq->sr_data_direction = DMA_BIDIRECTIONAL;
-	}
-
-	return sreq;
-}
-EXPORT_SYMBOL(scsi_allocate_request);
-
-void __scsi_release_request(struct scsi_request *sreq)
-{
-	struct request *req = sreq->sr_request;
-
-	/* unlikely because the tag was usually ended earlier by the
-	 * mid-layer. However, for layering reasons ULD's don't end
-	 * the tag of commands they generate. */
-	if (unlikely(blk_rq_tagged(req))) {
-		unsigned long flags;
-		struct request_queue *q = req->q;
-
-		spin_lock_irqsave(q->queue_lock, flags);
-		blk_queue_end_tag(q, req);
-		spin_unlock_irqrestore(q->queue_lock, flags);
-	}
-
-
-	if (likely(sreq->sr_command != NULL)) {
-		struct scsi_cmnd *cmd = sreq->sr_command;
-
-		sreq->sr_command = NULL;
-		scsi_next_command(cmd);
-	}
-}
-
-/*
- * Function:    scsi_release_request
- *
- * Purpose:     Release a request descriptor.
- *
- * Arguments:   sreq    - request to release
- *
- * Lock status: No locks assumed to be held.  This function is SMP-safe.
- */
-void scsi_release_request(struct scsi_request *sreq)
-{
-	__scsi_release_request(sreq);
-	kfree(sreq);
-}
-EXPORT_SYMBOL(scsi_release_request);
-
 struct scsi_host_cmd_pool {
 	kmem_cache_t	*slab;
 	unsigned int	users;
@@ -646,73 +572,6 @@
 	return rtn;
 }
 
-/*
- * Function:    scsi_init_cmd_from_req
- *
- * Purpose:     Queue a SCSI command
- * Purpose:     Initialize a struct scsi_cmnd from a struct scsi_request
- *
- * Arguments:   cmd       - command descriptor.
- *              sreq      - Request from the queue.
- *
- * Lock status: None needed.
- *
- * Returns:     Nothing.
- *
- * Notes:       Mainly transfer data from the request structure to the
- *              command structure.  The request structure is allocated
- *              using the normal memory allocator, and requests can pile
- *              up to more or less any depth.  The command structure represents
- *              a consumable resource, as these are allocated into a pool
- *              when the SCSI subsystem initializes.  The preallocation is
- *              required so that in low-memory situations a disk I/O request
- *              won't cause the memory manager to try and write out a page.
- *              The request structure is generally used by ioctls and character
- *              devices.
- */
-void scsi_init_cmd_from_req(struct scsi_cmnd *cmd, struct scsi_request *sreq)
-{
-	sreq->sr_command = cmd;
-
-	cmd->cmd_len = sreq->sr_cmd_len;
-	cmd->use_sg = sreq->sr_use_sg;
-
-	cmd->request = sreq->sr_request;
-	memcpy(cmd->data_cmnd, sreq->sr_cmnd, sizeof(cmd->data_cmnd));
-	cmd->serial_number = 0;
-	cmd->bufflen = sreq->sr_bufflen;
-	cmd->buffer = sreq->sr_buffer;
-	cmd->retries = 0;
-	cmd->allowed = sreq->sr_allowed;
-	cmd->done = sreq->sr_done;
-	cmd->timeout_per_command = sreq->sr_timeout_per_command;
-	cmd->sc_data_direction = sreq->sr_data_direction;
-	cmd->sglist_len = sreq->sr_sglist_len;
-	cmd->underflow = sreq->sr_underflow;
-	cmd->sc_request = sreq;
-	memcpy(cmd->cmnd, sreq->sr_cmnd, sizeof(sreq->sr_cmnd));
-
-	/*
-	 * Zero the sense buffer.  Some host adapters automatically request
-	 * sense on error.  0 is not a valid sense code.
-	 */
-	memset(cmd->sense_buffer, 0, sizeof(sreq->sr_sense_buffer));
-	cmd->request_buffer = sreq->sr_buffer;
-	cmd->request_bufflen = sreq->sr_bufflen;
-	cmd->old_use_sg = cmd->use_sg;
-	if (cmd->cmd_len == 0)
-		cmd->cmd_len = COMMAND_SIZE(cmd->cmnd[0]);
-	cmd->old_cmd_len = cmd->cmd_len;
-	cmd->sc_old_data_direction = cmd->sc_data_direction;
-	cmd->old_underflow = cmd->underflow;
-
-	/*
-	 * Start the timer ticking.
-	 */
-	cmd->result = 0;
-
-	SCSI_LOG_MLQUEUE(3, printk("Leaving scsi_init_cmd_from_req()\n"));
-}
 
 /*
  * Per-CPU I/O completion queue.
@@ -809,7 +668,6 @@
 {
 	struct scsi_device *sdev = cmd->device;
 	struct Scsi_Host *shost = sdev->host;
-	struct scsi_request *sreq;
 
 	scsi_device_unbusy(sdev);
 
@@ -839,21 +697,6 @@
 	 * We can get here with use_sg=0, causing a panic in the upper level
 	 */
 	cmd->use_sg = cmd->old_use_sg;
-
-	/*
-	 * If there is an associated request structure, copy the data over
-	 * before we call the completion function.
-	 */
-	sreq = cmd->sc_request;
-	if (sreq) {
-	       sreq->sr_result = sreq->sr_command->result;
-	       if (sreq->sr_result) {
-		       memcpy(sreq->sr_sense_buffer,
-			      sreq->sr_command->sense_buffer,
-			      sizeof(sreq->sr_sense_buffer));
-	       }
-	}
-
 	cmd->done(cmd);
 }
 EXPORT_SYMBOL(scsi_finish_command);
Index: scsi-misc-2.6/drivers/scsi/scsi.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi.h	2006-06-02 18:20:23.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi.h	2006-06-10 17:21:07.000000000 +0200
@@ -25,7 +25,6 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_eh.h>
-#include <scsi/scsi_request.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi.h>
 
Index: scsi-misc-2.6/drivers/scsi/scsi_error.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_error.c	2006-06-10 16:59:29.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_error.c	2006-06-10 17:45:59.000000000 +0200
@@ -26,13 +26,13 @@
 #include <linux/delay.h>
 
 #include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
-#include <scsi/scsi_request.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -1671,8 +1671,6 @@
 	scmd->cmd_len			= 0;
 
 	scmd->sc_data_direction		= DMA_BIDIRECTIONAL;
-	scmd->sc_request		= NULL;
-	scmd->sc_magic			= SCSI_CMND_MAGIC;
 
 	init_timer(&scmd->eh_timeout);
 
@@ -1769,14 +1767,6 @@
 }
 EXPORT_SYMBOL(scsi_normalize_sense);
 
-int scsi_request_normalize_sense(struct scsi_request *sreq,
-				 struct scsi_sense_hdr *sshdr)
-{
-	return scsi_normalize_sense(sreq->sr_sense_buffer,
-			sizeof(sreq->sr_sense_buffer), sshdr);
-}
-EXPORT_SYMBOL(scsi_request_normalize_sense);
-
 int scsi_command_normalize_sense(struct scsi_cmnd *cmd,
 				 struct scsi_sense_hdr *sshdr)
 {
Index: scsi-misc-2.6/drivers/scsi/scsi_ioctl.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_ioctl.c	2006-06-02 18:20:23.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_ioctl.c	2006-06-10 17:44:18.000000000 +0200
@@ -15,11 +15,11 @@
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
-#include <scsi/scsi_request.h>
 #include <scsi/sg.h>
 #include <scsi/scsi_dbg.h>
 
Index: scsi-misc-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_lib.c	2006-06-10 16:59:29.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_lib.c	2006-06-10 17:46:59.000000000 +0200
@@ -19,12 +19,12 @@
 #include <linux/hardirq.h>
 
 #include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_request.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -83,7 +83,7 @@
 	struct scsi_cmnd *cmd = req->special;
 
 	req->flags &= ~REQ_DONTPREP;
-	req->special = (req->flags & REQ_SPECIAL) ? cmd->sc_request : NULL;
+	req->special = NULL;
 
 	scsi_put_command(cmd);
 }
@@ -161,72 +161,6 @@
 	return 0;
 }
 
-/*
- * Function:    scsi_do_req
- *
- * Purpose:     Queue a SCSI request
- *
- * Arguments:   sreq	  - command descriptor.
- *              cmnd      - actual SCSI command to be performed.
- *              buffer    - data buffer.
- *              bufflen   - size of data buffer.
- *              done      - completion function to be run.
- *              timeout   - how long to let it run before timeout.
- *              retries   - number of retries we allow.
- *
- * Lock status: No locks held upon entry.
- *
- * Returns:     Nothing.
- *
- * Notes:	This function is only used for queueing requests for things
- *		like ioctls and character device requests - this is because
- *		we essentially just inject a request into the queue for the
- *		device.
- *
- *		In order to support the scsi_device_quiesce function, we
- *		now inject requests on the *head* of the device queue
- *		rather than the tail.
- */
-void scsi_do_req(struct scsi_request *sreq, const void *cmnd,
-		 void *buffer, unsigned bufflen,
-		 void (*done)(struct scsi_cmnd *),
-		 int timeout, int retries)
-{
-	/*
-	 * If the upper level driver is reusing these things, then
-	 * we should release the low-level block now.  Another one will
-	 * be allocated later when this request is getting queued.
-	 */
-	__scsi_release_request(sreq);
-
-	/*
-	 * Our own function scsi_done (which marks the host as not busy,
-	 * disables the timeout counter, etc) will be called by us or by the
-	 * scsi_hosts[host].queuecommand() function needs to also call
-	 * the completion function for the high level driver.
-	 */
-	memcpy(sreq->sr_cmnd, cmnd, sizeof(sreq->sr_cmnd));
-	sreq->sr_bufflen = bufflen;
-	sreq->sr_buffer = buffer;
-	sreq->sr_allowed = retries;
-	sreq->sr_done = done;
-	sreq->sr_timeout_per_command = timeout;
-
-	if (sreq->sr_cmd_len == 0)
-		sreq->sr_cmd_len = COMMAND_SIZE(sreq->sr_cmnd[0]);
-
-	/*
-	 * head injection *required* here otherwise quiesce won't work
-	 *
-	 * Because users of this function are apt to reuse requests with no
-	 * modification, we have to sanitise the request flags here
-	 */
-	sreq->sr_request->flags &= ~REQ_DONTPREP;
-	blk_insert_request(sreq->sr_device->request_queue, sreq->sr_request,
-		       	   1, sreq);
-}
-EXPORT_SYMBOL(scsi_do_req);
-
 /**
  * scsi_execute - insert request and wait for the result
  * @sdev:	scsi device
@@ -1287,15 +1221,7 @@
 	 * at request->cmd, as this tells us the real story.
 	 */
 	if (req->flags & REQ_SPECIAL && req->special) {
-		struct scsi_request *sreq = req->special;
-
-		if (sreq->sr_magic == SCSI_REQ_MAGIC) {
-			cmd = scsi_get_command(sreq->sr_device, GFP_ATOMIC);
-			if (unlikely(!cmd))
-				goto defer;
-			scsi_init_cmd_from_req(cmd, sreq);
-		} else
-			cmd = req->special;
+		cmd = req->special;
 	} else if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
 
 		if(unlikely(specials_only) && !(req->flags & REQ_SPECIAL)) {
Index: scsi-misc-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_priv.h	2006-06-10 16:59:29.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_priv.h	2006-06-10 17:29:58.000000000 +0200
@@ -8,17 +8,10 @@
 struct scsi_cmnd;
 struct scsi_device;
 struct scsi_host_template;
-struct scsi_request;
 struct Scsi_Host;
 
 
 /*
- * Magic values for certain scsi structs. Shouldn't ever be used.
- */
-#define SCSI_CMND_MAGIC		0xE25C23A5
-#define SCSI_REQ_MAGIC		0x75F6D354
-
-/*
  * Scsi Error Handler Flags
  */
 #define SCSI_EH_CANCEL_CMD	0x0001	/* Cancel this cmd */
@@ -34,9 +27,6 @@
 extern int scsi_dispatch_cmd(struct scsi_cmnd *cmd);
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
-extern void scsi_init_cmd_from_req(struct scsi_cmnd *cmd,
-		struct scsi_request *sreq);
-extern void __scsi_release_request(struct scsi_request *sreq);
 extern void __scsi_done(struct scsi_cmnd *cmd);
 extern int scsi_retry_command(struct scsi_cmnd *cmd);
 #ifdef CONFIG_SCSI_LOGGING
Index: scsi-misc-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_scan.c	2006-06-02 18:20:23.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_scan.c	2006-06-10 17:47:44.000000000 +0200
@@ -33,11 +33,11 @@
 #include <asm/semaphore.h>
 
 #include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_request.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_eh.h>
 
Index: scsi-misc-2.6/drivers/scsi/scsi_typedefs.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_typedefs.h	2006-06-02 18:20:23.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_typedefs.h	2006-06-10 17:09:42.000000000 +0200
@@ -1,3 +1,2 @@
 
 typedef struct scsi_cmnd Scsi_Cmnd;
-typedef struct scsi_request Scsi_Request;
Index: scsi-misc-2.6/include/scsi/scsi_cmnd.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_cmnd.h	2006-06-10 16:59:29.000000000 +0200
+++ scsi-misc-2.6/include/scsi/scsi_cmnd.h	2006-06-10 17:39:10.000000000 +0200
@@ -9,7 +9,6 @@
 struct request;
 struct scatterlist;
 struct scsi_device;
-struct scsi_request;
 
 
 /* embedded in scsi_cmnd */
@@ -29,13 +28,8 @@
 };
 
 struct scsi_cmnd {
-	int     sc_magic;
-
 	struct scsi_device *device;
-	struct scsi_request *sc_request;
-
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
-
 	struct list_head eh_entry; /* entry for the host eh_cmd_q */
 	int eh_eflags;		/* Used by error handlr */
 	void (*done) (struct scsi_cmnd *);	/* Mid-level done function */
Index: scsi-misc-2.6/include/scsi/scsi_dbg.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_dbg.h	2006-06-02 18:20:36.000000000 +0200
+++ scsi-misc-2.6/include/scsi/scsi_dbg.h	2006-06-10 17:23:15.000000000 +0200
@@ -2,14 +2,12 @@
 #define _SCSI_SCSI_DBG_H
 
 struct scsi_cmnd;
-struct scsi_request;
 struct scsi_sense_hdr;
 
 extern void scsi_print_command(struct scsi_cmnd *);
 extern void scsi_print_sense_hdr(const char *, struct scsi_sense_hdr *);
 extern void __scsi_print_command(unsigned char *);
 extern void scsi_print_sense(const char *, struct scsi_cmnd *);
-extern void scsi_print_req_sense(const char *, struct scsi_request *);
 extern void __scsi_print_sense(const char *name,
 			       const unsigned char *sense_buffer,
 			       int sense_len);
Index: scsi-misc-2.6/include/scsi/scsi_eh.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_eh.h	2006-06-02 18:20:36.000000000 +0200
+++ scsi-misc-2.6/include/scsi/scsi_eh.h	2006-06-10 17:23:22.000000000 +0200
@@ -3,7 +3,6 @@
 
 struct scsi_cmnd;
 struct scsi_device;
-struct scsi_request;
 struct Scsi_Host;
 
 /*
@@ -43,8 +42,6 @@
 extern int scsi_block_when_processing_errors(struct scsi_device *);
 extern int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 		struct scsi_sense_hdr *sshdr);
-extern int scsi_request_normalize_sense(struct scsi_request *sreq,
-		struct scsi_sense_hdr *sshdr);
 extern int scsi_command_normalize_sense(struct scsi_cmnd *cmd,
 		struct scsi_sense_hdr *sshdr);
 
Index: scsi-misc-2.6/include/scsi/scsi_request.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_request.h	2006-06-02 18:20:36.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,54 +0,0 @@
-#ifndef _SCSI_SCSI_REQUEST_H
-#define _SCSI_SCSI_REQUEST_H
-
-#include <scsi/scsi_cmnd.h>
-
-struct request;
-struct scsi_cmnd;
-struct scsi_device;
-struct Scsi_Host;
-
-
-/*
- * This is essentially a slimmed down version of Scsi_Cmnd.  The point of
- * having this is that requests that are injected into the queue as result
- * of things like ioctls and character devices shouldn't be using a
- * Scsi_Cmnd until such a time that the command is actually at the head
- * of the queue and being sent to the driver.
- */
-struct scsi_request {
-	int     sr_magic;
-	int     sr_result;	/* Status code from lower level driver */
-	unsigned char sr_sense_buffer[SCSI_SENSE_BUFFERSIZE];		/* obtained by REQUEST SENSE
-						 * when CHECK CONDITION is
-						 * received on original command 
-						 * (auto-sense) */
-
-	struct Scsi_Host *sr_host;
-	struct scsi_device *sr_device;
-	struct scsi_cmnd *sr_command;
-	struct request *sr_request;	/* A copy of the command we are
-				   working on */
-	unsigned sr_bufflen;	/* Size of data buffer */
-	void *sr_buffer;		/* Data buffer */
-	int sr_allowed;
-	enum dma_data_direction sr_data_direction;
-	unsigned char sr_cmd_len;
-	unsigned char sr_cmnd[MAX_COMMAND_SIZE];
-	void (*sr_done) (struct scsi_cmnd *);	/* Mid-level done function */
-	int sr_timeout_per_command;
-	unsigned short sr_use_sg;	/* Number of pieces of scatter-gather */
-	unsigned short sr_sglist_len;	/* size of malloc'd scatter-gather list */
-	unsigned sr_underflow;	/* Return error if less than
-				   this amount is transferred */
- 	void *upper_private_data;	/* reserved for owner (usually upper
- 					   level driver) of this request */
-};
-
-extern struct scsi_request *scsi_allocate_request(struct scsi_device *, gfp_t);
-extern void scsi_release_request(struct scsi_request *);
-extern void scsi_do_req(struct scsi_request *, const void *cmnd,
-			void *buffer, unsigned bufflen,
-			void (*done) (struct scsi_cmnd *),
-			int timeout, int retries);
-#endif /* _SCSI_SCSI_REQUEST_H */
Index: scsi-misc-2.6/include/scsi/sg_request.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/sg_request.h	2006-06-02 18:20:36.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,26 +0,0 @@
-typedef struct scsi_request Scsi_Request;
-
-static Scsi_Request *dummy_cmdp;	/* only used for sizeof */
-
-typedef struct sg_scatter_hold { /* holding area for scsi scatter gather info */
-	unsigned short k_use_sg; /* Count of kernel scatter-gather pieces */
-	unsigned short sglist_len; /* size of malloc'd scatter-gather list ++ */
-	unsigned bufflen;	/* Size of (aggregate) data buffer */
-	unsigned b_malloc_len;	/* actual len malloc'ed in buffer */
-	void *buffer;		/* Data buffer or scatter list (k_use_sg>0) */
-	char dio_in_use;	/* 0->indirect IO (or mmap), 1->dio */
-	unsigned char cmd_opcode; /* first byte of command */
-} Sg_scatter_hold;
-
-typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
-	Scsi_Request *my_cmdp;	/* != 0  when request with lower levels */
-	struct sg_request *nextrp;	/* NULL -> tail request (slist) */
-	struct sg_fd *parentfp;	/* NULL -> not in use */
-	Sg_scatter_hold data;	/* hold buffer, perhaps scatter list */
-	sg_io_hdr_t header;	/* scsi command+info, see <scsi/sg.h> */
-	unsigned char sense_b[sizeof (dummy_cmdp->sr_sense_buffer)];
-	char res_used;		/* 1 -> using reserve buffer, 0 -> not ... */
-	char orphan;		/* 1 -> drop on sight, 0 -> normal */
-	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
-	volatile char done;	/* 0->before bh, 1->before read, 2->read */
-} Sg_request;
