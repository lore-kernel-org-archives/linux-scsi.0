From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 01/04] scsi: consolidate error handling out of scsi_init_io() into scsi_prep_fn()
Date: Sat, 14 May 2005 22:57:38 +0900 (KST)
Message-ID: <20050514135610.536D5170@htj.dyndns.org>
References: <20050514135610.81030F26@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.199]:23971 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262649AbVENN5n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 May 2005 09:57:43 -0400
Received: by rproxy.gmail.com with SMTP id i8so326376rne
        for <linux-scsi@vger.kernel.org>; Sat, 14 May 2005 06:57:43 -0700 (PDT)
In-Reply-To: <20050514135610.81030F26@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

01_scsi_reqfn_consolidate_error_handling.patch

	This patch fixes a queue stall bug which occurred when sgtable
	allocation failed and device_busy == 0.  When scsi_init_io()
	returns BLKPREP_DEFER or BLKPREP_KILL, it's supposed to free
	resources itself.  This patch consolidates defer and kill
	handling into scsi_prep_fn().

	Note that this patch doesn't consolidate state defer/kill
	handlings in scsi_prep_fn() as all state checks will be moved
	into scsi_reques_fn() by the following reqfn_reimpl patch.

	ret value checking was changed to switch() as in James's
	patch.  Also, kill: comment is copied from James's patch.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi_lib.c |   40 ++++++++++++++++++++++++++++------------
 1 files changed, 28 insertions(+), 12 deletions(-)

Index: scsi-reqfn-export/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi_lib.c	2005-05-14 22:35:18.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi_lib.c	2005-05-14 22:35:18.000000000 +0900
@@ -977,9 +977,6 @@ static int scsi_init_io(struct scsi_cmnd
 	printk(KERN_ERR "req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors,
 			req->current_nr_sectors);
 
-	/* release the command and kill it */
-	scsi_release_buffers(cmd);
-	scsi_put_command(cmd);
 	return BLKPREP_KILL;
 }
 
@@ -1147,18 +1144,24 @@ static int scsi_prep_fn(struct request_q
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
@@ -1168,12 +1171,25 @@ static int scsi_prep_fn(struct request_q
 	return BLKPREP_OK;
 
  defer:
-	/* If we defer, the elv_next_request() returns NULL, but the
+	/*
+	 * If we defer, the elv_next_request() returns NULL, but the
 	 * queue must be restarted, so we plug here if no returning
-	 * command will automatically do that. */
+	 * command will automatically do that.
+	 */
 	if (sdev->device_busy == 0)
 		blk_plug_device(q);
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

