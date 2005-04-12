From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 01/04] scsi: consolidate error handling out of scsi_init_io() into scsi_prep_fn()
Date: Tue, 12 Apr 2005 19:32:53 +0900 (KST)
Message-ID: <20050412103128.450C4351@htj.dyndns.org>
References: <20050412103128.69172FEB@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262240AbVDLLYP@vger.kernel.org>
In-Reply-To: <20050412103128.69172FEB@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

01_scsi_reqfn_consolidate_error_handling.patch

	This patch fixes a queue stall bug which occurred when sgtable
	allocation failed and device_busy == 0.  When scsi_init_io()
	returns BLKPREP_DEFER or BLKPREP_KILL, it's supposed to free
	resources itself.  This patch consolidates defer and kill
	handling into scsi_prep_fn().

	Note that this patch doesn't consolidate state defer/kill
	handlings in scsi_prep_fn().  They were omitted as all state
	checks will be moved into scsi_reques_fn() by the following
	reqfn_reimpl patch.

	ret value checking was changed to switch() as in James's
	patch.  Also, kill: comment is copied from James's patch.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi_lib.c |   46 +++++++++++++++++++++++++++++++---------------
 1 files changed, 31 insertions(+), 15 deletions(-)

Index: scsi-reqfn-export/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi_lib.c	2005-04-12 19:27:55.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi_lib.c	2005-04-12 19:27:55.000000000 +0900
@@ -945,10 +945,8 @@ static int scsi_init_io(struct scsi_cmnd
 	 * if sg table allocation fails, requeue request later.
 	 */
 	sgpnt = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
-	if (unlikely(!sgpnt)) {
-		req->flags |= REQ_SOFTBARRIER;
+	if (unlikely(!sgpnt))
 		return BLKPREP_DEFER;
-	}
 
 	cmd->request_buffer = (char *) sgpnt;
 	cmd->request_bufflen = req->nr_sectors << 9;
@@ -975,9 +973,6 @@ static int scsi_init_io(struct scsi_cmnd
 	printk(KERN_ERR "req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors,
 			req->current_nr_sectors);
 
-	/* release the command and kill it */
-	scsi_release_buffers(cmd);
-	scsi_put_command(cmd);
 	return BLKPREP_KILL;
 }
 
@@ -1145,18 +1140,24 @@ static int scsi_prep_fn(struct request_q
 		 * required).
 		 */
 		ret = scsi_init_io(cmd);
-		if (ret)	/* BLKPREP_KILL return also releases the command */
-			return ret;
+		switch (ret) {
+		case 0:
+			/* Successful initialization. */
+			break;
+		case BLKPREP_DEFER:
+			goto defer;
+		default:
+			/* Unknown return value, fall through. */
+		case BLKPREP_KILL:
+			goto kill;
+		}
 		
 		/*
 		 * Initialize the actual SCSI command for this request.
 		 */
 		drv = *(struct scsi_driver **)req->rq_disk->private_data;
-		if (unlikely(!drv->init_command(cmd))) {
-			scsi_release_buffers(cmd);
-			scsi_put_command(cmd);
-			return BLKPREP_KILL;
-		}
+		if (unlikely(!drv->init_command(cmd)))
+			goto kill;
 	}
 
 	/*
@@ -1166,12 +1167,27 @@ static int scsi_prep_fn(struct request_q
 	return BLKPREP_OK;
 
  defer:
-	/* If we defer, the elv_next_request() returns NULL, but the
+	/*
+	 * If we defer, the elv_next_request() returns NULL, but the
 	 * queue must be restarted, so we plug here if no returning
-	 * command will automatically do that. */
+	 * command will automatically do that.  Also, the request may
+	 * have its cmd allocated, so we set REQ_SOFTBARRIER.
+	 */
 	if (sdev->device_busy == 0)
 		blk_plug_device(q);
+	req->flags |= REQ_SOFTBARRIER;
 	return BLKPREP_DEFER;
+
+ kill:
+	/*
+	 * Here we have to release every resource associated with the
+	 * request because this will complete at the request level
+	 * (req->end_io), not the scsi command level, so no scsi
+	 * routine will get to free the associated resources.
+	 */
+	scsi_release_buffers(cmd);
+	scsi_put_command(cmd);
+	return BLKPREP_KILL;
 }
 
 /*
