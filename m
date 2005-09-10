From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] set error value when failing block pc commands in prep_fn
Date: Sat, 10 Sep 2005 13:59:09 -0500
Message-ID: <1126378749.2696.4.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:31921 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932209AbVIJS7O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Sep 2005 14:59:14 -0400
Received: from max (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j8AIxDrG019620
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 10 Sep 2005 13:59:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This patch is updated against scsi-rc-fixes which has
Alan's patch that fixes the places where we did not set
a error value in the request_fn.

But when we kill a block pc request in the prep function
the  errors value is still not getting set. And if scsi_init_io
returned BLKPREP_DEFER we missed the blk_plug_device code so
this patch just has it go to the defer label in that case.

Patch was made against scsi-rc-fixes.

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
@@ -1192,7 +1192,7 @@ static int scsi_prep_fn(struct request_q
 			
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
@@ -1290,6 +1295,10 @@ static int scsi_prep_fn(struct request_q
 	if (sdev->device_busy == 0)
 		blk_plug_device(q);
 	return BLKPREP_DEFER;
+ kill:
+	if (blk_pc_request(req))
+		req->errors = DID_NO_CONNECT << 16;
+	return BLKPREP_KILL;
 }
 
 /*


