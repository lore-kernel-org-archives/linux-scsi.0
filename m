From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] 2.5.x alternate add back missing scsi_queue_next_request calls
Date: Fri, 21 Mar 2003 14:15:25 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030321141525.A8134@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Luben Tuikov <luben@splentec.com>, linux-scsi@vger.kernel.org

Alternate version of the patch. I prefer the previous version. Posting to
clarify the coding issues.

The change to use a pool for scsi_cmnd allocations removed some
scsi_queue_next_request calls, this patch restores the calls, and
exports scsi_put_command and scsi_get_command.

The extra scsi_queue_next_request calls are needed to handle non-block
device IO completion (char devices and scsi scanning).

This patch applies cleanly on top of the previous "starved" patch, but
should apply with offsets to the current 2.5.x tree.

diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/aha152x.c put_cmd_v2-25/drivers/scsi/aha152x.c
--- starve-25/drivers/scsi/aha152x.c	Wed Mar 19 11:52:21 2003
+++ put_cmd_v2-25/drivers/scsi/aha152x.c	Fri Mar 21 14:03:48 2003
@@ -1668,6 +1668,7 @@ int aha152x_device_reset(Scsi_Cmnd * SCp
 	struct timer_list timer;
 	Scsi_Cmnd *cmd;
 	int ret;
+	struct request_queue *q;
 
 #if defined(AHA152X_DEBUG)
 	if(HOSTDATA(shpnt)->debug & debug_eh) {
@@ -1714,7 +1715,9 @@ int aha152x_device_reset(Scsi_Cmnd * SCp
 		ret = FAILED;
 	}
 
+	q = cmd->device->request_queue;
 	scsi_put_command(cmd);
+	scsi_queue_next_request(q, NULL);
 	spin_lock_irq(shpnt->host_lock);
 	return ret;
 }
diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/cpqfcTSinit.c put_cmd_v2-25/drivers/scsi/cpqfcTSinit.c
--- starve-25/drivers/scsi/cpqfcTSinit.c	Wed Mar 19 11:52:22 2003
+++ put_cmd_v2-25/drivers/scsi/cpqfcTSinit.c	Fri Mar 21 11:57:39 2003
@@ -1588,6 +1588,7 @@ int cpqfcTS_TargetDeviceReset( Scsi_Devi
   int result;
   Scsi_Cmnd * SCpnt;
   Scsi_Device * SDpnt;
+  struct request_queue *q;
 
 // FIXME, cpqfcTS_TargetDeviceReset needs to be fixed 
 // similarly to how the passthrough ioctl was fixed 
@@ -1653,7 +1654,9 @@ return -ENOTSUPP;
   result = SCpnt->result;
 
   SDpnt = SCpnt->device;
+  q = SCpnt->device->request_queue;
   scsi_put_command(SCpnt);
+  scsi_queue_next_request(q, NULL);
   SCpnt = NULL;
 
   // if (!SDpnt->was_reset && SDpnt->scsi_request_fn)
diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/gdth.c put_cmd_v2-25/drivers/scsi/gdth.c
--- starve-25/drivers/scsi/gdth.c	Wed Mar 19 11:52:22 2003
+++ put_cmd_v2-25/drivers/scsi/gdth.c	Fri Mar 21 11:58:53 2003
@@ -4625,6 +4625,7 @@ static void gdth_flush(int hanum)
 #if LINUX_VERSION_CODE >= 0x020322
     Scsi_Cmnd       *scp;
     Scsi_Device     *sdev;
+    struct request_queue *q;
 #else
     Scsi_Cmnd       scp;
     Scsi_Device     sdev;
@@ -4665,7 +4666,9 @@ static void gdth_flush(int hanum)
         }
     }
 #if LINUX_VERSION_CODE >= 0x020322
+    q = SCpnt->device->request_queue;
     scsi_put_command(scp);
+    scsi_queue_next_request(q, NULL);
     scsi_free_host_dev(sdev);
 #endif
 }
@@ -4683,6 +4686,7 @@ void gdth_halt(void)
 #if LINUX_VERSION_CODE >= 0x020322
     Scsi_Cmnd       *scp;
     Scsi_Device     *sdev;
+    struct request_queue *q;
 #else
     Scsi_Cmnd       scp;
     Scsi_Device     sdev;
@@ -4728,7 +4732,9 @@ void gdth_halt(void)
         TRACE2(("gdth_halt(): reset controller %d\n", hanum));
 #if LINUX_VERSION_CODE >= 0x020322
         gdth_do_cmd(scp, &gdtcmd, cmnd, 10);
+        q = SCpnt->device->request_queue;
         scsi_put_command(scp);
+        scsi_queue_next_request(q, NULL);
         scsi_free_host_dev(sdev);
 #else
         gdth_do_cmd(&scp, &gdtcmd, cmnd, 10);
diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/gdth_proc.c put_cmd_v2-25/drivers/scsi/gdth_proc.c
--- starve-25/drivers/scsi/gdth_proc.c	Wed Mar 19 11:52:22 2003
+++ put_cmd_v2-25/drivers/scsi/gdth_proc.c	Fri Mar 21 12:00:25 2003
@@ -37,6 +37,7 @@ static int gdth_set_info(char *buffer,in
 #if LINUX_VERSION_CODE >= 0x020322
     Scsi_Cmnd       *scp;
     Scsi_Device     *sdev;
+    struct request_queue *q;
 #else
     Scsi_Cmnd       scp;
     Scsi_Device     sdev;
@@ -81,7 +82,9 @@ static int gdth_set_info(char *buffer,in
         ret_val = -EINVAL;
     }
 #if LINUX_VERSION_CODE >= 0x020322
+    q = SCpnt->device->request_queue;
     scsi_put_command(scp);
+    scsi_queue_next_request(q, NULL);
     scsi_free_host_dev(sdev);
 #endif
     return ret_val;
@@ -1234,7 +1237,9 @@ static int gdth_get_info(char *buffer,ch
 
 stop_output:
 #if LINUX_VERSION_CODE >= 0x020322
+    q = SCpnt->device->request_queue;
     scsi_put_command(scp);
+    scsi_queue_next_request(q, NULL);
     scsi_free_host_dev(sdev);
 #endif
     *start = buffer +(offset-begin);
diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/scsi.c put_cmd_v2-25/drivers/scsi/scsi.c
--- starve-25/drivers/scsi/scsi.c	Wed Mar 19 11:54:28 2003
+++ put_cmd_v2-25/drivers/scsi/scsi.c	Fri Mar 21 12:05:27 2003
@@ -222,9 +222,13 @@ Scsi_Request *scsi_allocate_request(Scsi
  */
 void scsi_release_request(Scsi_Request * req)
 {
+	struct request_queue *q;
+
 	if( req->sr_command != NULL )
 	{
+		q = req->sr_command->device->request_queue;
 		scsi_put_command(req->sr_command);
+		scsi_queue_next_request(q, NULL);
 		req->sr_command = NULL;
 	}
 
diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/scsi.h put_cmd_v2-25/drivers/scsi/scsi.h
--- starve-25/drivers/scsi/scsi.h	Fri Mar 21 11:21:28 2003
+++ put_cmd_v2-25/drivers/scsi/scsi.h	Fri Mar 21 12:06:26 2003
@@ -417,6 +417,7 @@ extern void scsi_setup_cmd_retry(Scsi_Cm
 extern void scsi_io_completion(Scsi_Cmnd * SCpnt, int good_sectors,
 			       int block_sectors);
 extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
+extern void scsi_queue_next_request(request_queue_t *q, struct scsi_cmnd *cmd);
 extern request_queue_t *scsi_alloc_queue(struct Scsi_Host *shost);
 extern void scsi_free_queue(request_queue_t *q);
 extern int scsi_init_queue(void);
diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/scsi_error.c put_cmd_v2-25/drivers/scsi/scsi_error.c
--- starve-25/drivers/scsi/scsi_error.c	Wed Mar 19 11:52:25 2003
+++ put_cmd_v2-25/drivers/scsi/scsi_error.c	Fri Mar 21 12:08:03 2003
@@ -1681,6 +1681,7 @@ scsi_reset_provider(struct scsi_device *
 	struct scsi_cmnd *scmd = scsi_get_command(dev, GFP_KERNEL);
 	struct request req;
 	int rtn;
+	struct request_queue *q;
 
 	scmd->request = &req;
 	memset(&scmd->eh_timeout, 0, sizeof(scmd->eh_timeout));
@@ -1735,6 +1736,8 @@ scsi_reset_provider(struct scsi_device *
 	}
 
 	scsi_delete_timer(scmd);
+	q = scmd->device->request_queue;
 	scsi_put_command(scmd);
+	scsi_queue_next_request(q, NULL);
 	return rtn;
 }
diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/scsi_lib.c put_cmd_v2-25/drivers/scsi/scsi_lib.c
--- starve-25/drivers/scsi/scsi_lib.c	Fri Mar 21 11:21:28 2003
+++ put_cmd_v2-25/drivers/scsi/scsi_lib.c	Fri Mar 21 12:56:04 2003
@@ -174,14 +174,18 @@ void scsi_do_req(struct scsi_request *sr
 		 void (*done)(struct scsi_cmnd *),
 		 int timeout, int retries)
 {
+	struct request_queue *q;
+
 	/*
 	 * If the upper level driver is reusing these things, then
 	 * we should release the low-level block now.  Another one will
 	 * be allocated later when this request is getting queued.
 	 */
 	if (sreq->sr_command) {
+		q = sreq->sr_command->device->request_queue;
 		scsi_put_command(sreq->sr_command);
 		sreq->sr_command = NULL;
+		scsi_queue_next_request(q, NULL);
 	}
 
 	/*
@@ -228,6 +232,7 @@ static void scsi_wait_done(struct scsi_c
 void scsi_wait_req(struct scsi_request *sreq, const void *cmnd, void *buffer,
 		   unsigned bufflen, int timeout, int retries)
 {
+	struct request_queue *q;
 	DECLARE_COMPLETION(wait);
 	
 	sreq->sr_request->waiting = &wait;
@@ -239,7 +244,9 @@ void scsi_wait_req(struct scsi_request *
 	sreq->sr_request->waiting = NULL;
 
 	if (sreq->sr_command) {
+		q = sreq->sr_command->device->request_queue;
 		scsi_put_command(sreq->sr_command);
+		scsi_queue_next_request(q, NULL);
 		sreq->sr_command = NULL;
 	}
 }
@@ -351,7 +358,7 @@ void scsi_setup_cmd_retry(struct scsi_cm
  *		permutations grows as 2**N, and if too many more special cases
  *		get added, we start to get screwed.
  */
-static void scsi_queue_next_request(request_queue_t *q, struct scsi_cmnd *cmd)
+void scsi_queue_next_request(request_queue_t *q, struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev, *sdev2;
 	struct Scsi_Host *shost;
diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/scsi_syms.c put_cmd_v2-25/drivers/scsi/scsi_syms.c
--- starve-25/drivers/scsi/scsi_syms.c	Wed Mar 19 11:52:25 2003
+++ put_cmd_v2-25/drivers/scsi/scsi_syms.c	Fri Mar 21 11:53:46 2003
@@ -60,6 +60,9 @@ EXPORT_SYMBOL(scsi_allocate_request);
 EXPORT_SYMBOL(scsi_release_request);
 EXPORT_SYMBOL(scsi_wait_req);
 EXPORT_SYMBOL(scsi_do_req);
+EXPORT_SYMBOL(scsi_get_command);
+EXPORT_SYMBOL(scsi_put_command);
+EXPORT_SYMBOL(scsi_queue_next_request);
 
 EXPORT_SYMBOL(scsi_report_bus_reset);
 EXPORT_SYMBOL(scsi_block_requests);

-- Patrick Mansfield
