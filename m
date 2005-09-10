From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] set error value when failing block pc commands in
	prep_fn
Date: Sat, 10 Sep 2005 16:45:35 -0500
Message-ID: <1126388735.4656.3.camel@max>
References: <1126378749.2696.4.camel@max>
	 <1126382225.4813.63.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48561 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932331AbVIJVpk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Sep 2005 17:45:40 -0400
In-Reply-To: <1126382225.4813.63.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-09-10 at 14:57 -0500, James Bottomley wrote:
> On Sat, 2005-09-10 at 13:59 -0500, Mike Christie wrote:
> > This patch is updated against scsi-rc-fixes which has
> > Alan's patch that fixes the places where we did not set
> > a error value in the request_fn.
> > 
> > But when we kill a block pc request in the prep function
> > the  errors value is still not getting set. And if scsi_init_io
> > returned BLKPREP_DEFER we missed the blk_plug_device code so
> > this patch just has it go to the defer label in that case.
> > 
> > Patch was made against scsi-rc-fixes.
> 
> Is there a reason we shouldn't be setting the error in all cases?  I

I was not sure. __end_that_request_first() clears the errors value for
non block pc commands so it does not end up doing anything for normal
requests and seems safe.

> certainly can't think of one, in which case just set it globally.
> There's also a return BLKPREP_DEFER on line 1191:
> 
> 	if(unlikely(specials_only) && !(req->flags & REQ_SPECIAL)) {
> 		if(specials_only == SDEV_QUIESCE ||
> 				specials_only == SDEV_BLOCK)
> 			return BLKPREP_DEFER;
> 
> That needs to become a goto defer; for the same reasons as outlined
> above.

ok here is a patch with both fixes you requested.

Signed-Off-By: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1146,7 +1146,7 @@ static int scsi_prep_fn(struct request_q
 	if (unlikely(!scsi_device_online(sdev))) {
 		printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to offline device\n",
 		       sdev->host->host_no, sdev->id, sdev->lun);
-		return BLKPREP_KILL;
+		goto kill;
 	}
 	if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
 		/* OK, we're not in a running state don't prep
@@ -1156,7 +1156,7 @@ static int scsi_prep_fn(struct request_q
 			 * at all allowed down */
 			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to dead device\n",
 			       sdev->host->host_no, sdev->id, sdev->lun);
-			return BLKPREP_KILL;
+			goto kill;
 		}
 		/* OK, we only allow special commands (i.e. not
 		 * user initiated ones */
@@ -1188,11 +1188,11 @@ static int scsi_prep_fn(struct request_q
 		if(unlikely(specials_only) && !(req->flags & REQ_SPECIAL)) {
 			if(specials_only == SDEV_QUIESCE ||
 					specials_only == SDEV_BLOCK)
-				return BLKPREP_DEFER;
+				goto defer;
 			
 			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to device being removed\n",
 			       sdev->host->host_no, sdev->id, sdev->lun);
-			return BLKPREP_KILL;
+			goto kill;
 		}
 			
 			
@@ -1210,7 +1210,7 @@ static int scsi_prep_fn(struct request_q
 		cmd->tag = req->tag;
 	} else {
 		blk_dump_rq_flags(req, "SCSI bad req");
-		return BLKPREP_KILL;
+		goto kill;
 	}
 	
 	/* note the overloading of req->special.  When the tag
@@ -1248,8 +1248,13 @@ static int scsi_prep_fn(struct request_q
 		 * required).
 		 */
 		ret = scsi_init_io(cmd);
-		if (ret)	/* BLKPREP_KILL return also releases the command */
-			return ret;
+		switch(ret) {
+		case BLKPREP_KILL:
+			/* BLKPREP_KILL return also releases the command */
+			goto kill;
+		case BLKPREP_DEFER:
+			goto defer;
+		}
 		
 		/*
 		 * Initialize the actual SCSI command for this request.
@@ -1259,7 +1264,7 @@ static int scsi_prep_fn(struct request_q
 			if (unlikely(!drv->init_command(cmd))) {
 				scsi_release_buffers(cmd);
 				scsi_put_command(cmd);
-				return BLKPREP_KILL;
+				goto kill;
 			}
 		} else {
 			memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
@@ -1290,6 +1295,9 @@ static int scsi_prep_fn(struct request_q
 	if (sdev->device_busy == 0)
 		blk_plug_device(q);
 	return BLKPREP_DEFER;
+ kill:
+	req->errors = DID_NO_CONNECT << 16;
+	return BLKPREP_KILL;
 }
 
 /*




