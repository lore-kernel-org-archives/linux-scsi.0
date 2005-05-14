From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 04/04] scsi: remove unnecessary scsi_wait_req_end_io()
Date: Sat, 14 May 2005 22:57:54 +0900 (KST)
Message-ID: <20050514135610.50606F9C@htj.dyndns.org>
References: <20050514135610.81030F26@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.206]:29392 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262764AbVENN56 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 May 2005 09:57:58 -0400
Received: by wproxy.gmail.com with SMTP id 49so742215wri
        for <linux-scsi@vger.kernel.org>; Sat, 14 May 2005 06:57:58 -0700 (PDT)
In-Reply-To: <20050514135610.81030F26@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

04_scsi_reqfn_remove_wait_req_end_io.patch

	As all requests are now terminated via scsi midlayer, we don't
	need to set end_io for special reqs, remove it.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi_lib.c |   11 -----------
 1 files changed, 11 deletions(-)

Index: scsi-reqfn-export/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi_lib.c	2005-05-14 22:35:19.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi_lib.c	2005-05-14 22:35:19.000000000 +0900
@@ -265,16 +265,6 @@ static void scsi_wait_done(struct scsi_c
 		complete(req->waiting);
 }
 
-/* This is the end routine we get to if a command was never attached
- * to the request.  Simply complete the request without changing
- * rq_status; this will cause a DRIVER_ERROR. */
-static void scsi_wait_req_end_io(struct request *req)
-{
-	BUG_ON(!req->waiting);
-
-	complete(req->waiting);
-}
-
 void scsi_wait_req(struct scsi_request *sreq, const void *cmnd, void *buffer,
 		   unsigned bufflen, int timeout, int retries)
 {
@@ -282,7 +272,6 @@ void scsi_wait_req(struct scsi_request *
 	
 	sreq->sr_request->waiting = &wait;
 	sreq->sr_request->rq_status = RQ_SCSI_BUSY;
-	sreq->sr_request->end_io = scsi_wait_req_end_io;
 	scsi_do_req(sreq, cmnd, buffer, bufflen, scsi_wait_done,
 			timeout, retries);
 	wait_for_completion(&wait);

