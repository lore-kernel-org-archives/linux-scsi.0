From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] 2.5.x 3rd version add missing scsi_queue_next_request calls
Date: Fri, 21 Mar 2003 16:40:22 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030321164022.A9578@beaverton.ibm.com>
References: <20030321141525.A8134@beaverton.ibm.com> <3E7B97A0.4010204@splentec.com> <20030321162421.A9398@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030321162421.A9398@beaverton.ibm.com>; from patmans@us.ibm.com on Fri, Mar 21, 2003 at 04:24:21PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

3rd version, patched against a recent 2.5.x bk, applies cleanly on top of
the earlier starved patch..

Add missing scsi_queue_next_request calls.

Add missing scsi_put_command and scsi_get_command exports.

diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/scsi.h put_cmd_v3-25/drivers/scsi/scsi.h
--- starve-25/drivers/scsi/scsi.h	Fri Mar 21 11:21:28 2003
+++ put_cmd_v3-25/drivers/scsi/scsi.h	Fri Mar 21 15:55:02 2003
@@ -417,6 +417,7 @@ extern void scsi_setup_cmd_retry(Scsi_Cm
 extern void scsi_io_completion(Scsi_Cmnd * SCpnt, int good_sectors,
 			       int block_sectors);
 extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
+extern void scsi_queue_next_request(request_queue_t *q, struct scsi_cmnd *cmd);
 extern request_queue_t *scsi_alloc_queue(struct Scsi_Host *shost);
 extern void scsi_free_queue(request_queue_t *q);
 extern int scsi_init_queue(void);
diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/scsi_error.c put_cmd_v3-25/drivers/scsi/scsi_error.c
--- starve-25/drivers/scsi/scsi_error.c	Wed Mar 19 11:52:25 2003
+++ put_cmd_v3-25/drivers/scsi/scsi_error.c	Fri Mar 21 15:55:02 2003
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
diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/scsi_lib.c put_cmd_v3-25/drivers/scsi/scsi_lib.c
--- starve-25/drivers/scsi/scsi_lib.c	Fri Mar 21 11:21:28 2003
+++ put_cmd_v3-25/drivers/scsi/scsi_lib.c	Fri Mar 21 15:55:02 2003
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
diff -purN -X /home/patman/dontdiff starve-25/drivers/scsi/scsi_syms.c put_cmd_v3-25/drivers/scsi/scsi_syms.c
--- starve-25/drivers/scsi/scsi_syms.c	Wed Mar 19 11:52:25 2003
+++ put_cmd_v3-25/drivers/scsi/scsi_syms.c	Fri Mar 21 15:55:39 2003
@@ -60,6 +60,8 @@ EXPORT_SYMBOL(scsi_allocate_request);
 EXPORT_SYMBOL(scsi_release_request);
 EXPORT_SYMBOL(scsi_wait_req);
 EXPORT_SYMBOL(scsi_do_req);
+EXPORT_SYMBOL(scsi_get_command);
+EXPORT_SYMBOL(scsi_put_command);
 
 EXPORT_SYMBOL(scsi_report_bus_reset);
 EXPORT_SYMBOL(scsi_block_requests);

-- Patrick Mansfield
