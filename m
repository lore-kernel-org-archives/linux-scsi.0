From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] remove extra queue unplug calls
Date: Mon, 24 May 2004 19:04:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B2A9C7.2070300@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070207080807060907050105"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59912 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S264479AbUEYCE6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 May 2004 22:04:58 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, dougg@torque.net

This is a multi-part message in MIME format.
--------------070207080807060907050105
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

blk_insert_request will do the right thing and either unplug the queue or
call the request_fn, so users of scsi_do_req do not need to call
generic_unplug_device themselves. The attached patch just removes that
call from scsi_lib.c and the sg driver after they do a scsi_do_req.
It was built against 2.6.7-rc1

Mike

--------------070207080807060907050105
Content-Type: text/plain;
 name="rm-extra-unplugs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rm-extra-unplugs.patch"

diff -arup linux-2.6.7-rc1/drivers/scsi/scsi_lib.c linux-2.6.7-rc1-work/drivers/scsi/scsi_lib.c
--- linux-2.6.7-rc1/drivers/scsi/scsi_lib.c	2004-05-24 18:55:54.445045005 -0700
+++ linux-2.6.7-rc1-work/drivers/scsi/scsi_lib.c	2004-05-24 18:59:39.404883171 -0700
@@ -255,7 +255,6 @@ void scsi_wait_req(struct scsi_request *
 	sreq->sr_request->rq_status = RQ_SCSI_BUSY;
 	scsi_do_req(sreq, cmnd, buffer, bufflen, scsi_wait_done,
 			timeout, retries);
-	generic_unplug_device(sreq->sr_device->request_queue);
 	wait_for_completion(&wait);
 	sreq->sr_request->waiting = NULL;
 	if (sreq->sr_request->rq_status != RQ_SCSI_DONE)
diff -arup linux-2.6.7-rc1/drivers/scsi/sg.c linux-2.6.7-rc1-work/drivers/scsi/sg.c
--- linux-2.6.7-rc1/drivers/scsi/sg.c	2004-05-24 18:55:54.510036561 -0700
+++ linux-2.6.7-rc1-work/drivers/scsi/sg.c	2004-05-24 18:59:39.512869215 -0700
@@ -727,7 +727,6 @@ sg_common_write(Sg_fd * sfp, Sg_request 
 		    (void *) SRpnt->sr_buffer, hp->dxfer_len,
 		    sg_cmd_done, timeout, SG_DEFAULT_RETRIES);
 	/* dxfer_len overwrites SRpnt->sr_bufflen, hence need for b_malloc_len */
-	generic_unplug_device(q);
 	return 0;
 }
 

--------------070207080807060907050105--

