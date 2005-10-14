From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] Fix leak of Scsi_Cmnds
Date: Fri, 14 Oct 2005 11:23:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0510141110250.5552-100000@iolanthe.rowland.org>
References: <4342A502.6010204@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:65242 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1750761AbVJNPX2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 11:23:28 -0400
In-Reply-To: <4342A502.6010204@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, SCSI development list <linux-scsi@vger.kernel.org>

James:

When a request is deferred in scsi_init_io because the sg table could not
be allocated, the associated scsi_cmnd is not released and the request is
not marked with REQ_DONTPREP.  When the command is retried, if
scsi_prep_fn decides to kill it then the scsi_cmnd will never be released.

This patch (as573) changes scsi_init_io so that it calls scsi_put_command 
before deferring a request.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

It may still be too soon to apply this patch.  I don't know how it will 
interact with the old scsi_request mechanism (if that is still being 
used).

Also, at some stage you will want to delete the code paths in scsi_prep_fn 
that assign cmd = req->special, because unprepared requests will _never_ 
have an already-associated scsi_cmnd.



Index: usb-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_lib.c
+++ usb-2.6/drivers/scsi/scsi_lib.c
@@ -97,7 +97,6 @@ int scsi_insert_special_req(struct scsi_
 }
 
 static void scsi_run_queue(struct request_queue *q);
-static void scsi_release_buffers(struct scsi_cmnd *cmd);
 
 /*
  * Function:	scsi_unprep_request()
@@ -1040,8 +1039,10 @@ static int scsi_init_io(struct scsi_cmnd
 	 * if sg table allocation fails, requeue request later.
 	 */
 	sgpnt = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
-	if (unlikely(!sgpnt))
+	if (unlikely(!sgpnt)) {
+		scsi_unprep_request(req);
 		return BLKPREP_DEFER;
+	}
 
 	cmd->request_buffer = (char *) sgpnt;
 	cmd->request_bufflen = req->nr_sectors << 9;
@@ -1245,8 +1246,8 @@ static int scsi_prep_fn(struct request_q
 		 */
 		ret = scsi_init_io(cmd);
 		switch(ret) {
+			/* For BLKPREP_KILL/DEFER the cmd was released */
 		case BLKPREP_KILL:
-			/* BLKPREP_KILL return also releases the command */
 			goto kill;
 		case BLKPREP_DEFER:
 			goto defer;

