From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 01/05] scsi: make blk layer set REQ_SOFTBARRIER when a request is dispatched
Date: Wed, 20 Apr 2005 16:40:26 +0900
Message-ID: <20050420074026.GA11228@htj.dyndns.org>
References: <20050419231435.D85F89C0@htj.dyndns.org> <20050419231435.2DEBE102@htj.dyndns.org> <20050420063009.GB9371@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.203]:62541 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261322AbVDTHkc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 03:40:32 -0400
Received: by rproxy.gmail.com with SMTP id z35so69826rne
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2005 00:40:31 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20050420063009.GB9371@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James.Bottomley@steeleye.com, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 Hello, Jens.

On Wed, Apr 20, 2005 at 08:30:10AM +0200, Jens Axboe wrote:
> Do it on requeue, please - not on the initial spotting of the request.

 This is the reworked version of the patch.  It sets REQ_SOFTBARRIER
in two places - in elv_next_request() on BLKPREP_DEFER and in
blk_requeue_request().

 Other patches apply cleanly with this patch or the original one and
the end result is the same, so take your pick.  :-)


 Signed-off-by: Tejun Heo <htejun@gmail.com>


Index: scsi-reqfn-export/drivers/block/elevator.c
===================================================================
--- scsi-reqfn-export.orig/drivers/block/elevator.c	2005-04-20 16:24:26.000000000 +0900
+++ scsi-reqfn-export/drivers/block/elevator.c	2005-04-20 16:31:36.000000000 +0900
@@ -291,6 +291,13 @@ void elv_requeue_request(request_queue_t
 	}
 
 	/*
+	 * the request is prepped and may have some resources allocated.
+	 * allowing unprepped requests to pass this one may cause resource
+	 * deadlock.  turn on softbarrier.
+	 */
+	rq->flags |= REQ_SOFTBARRIER;
+
+	/*
 	 * if iosched has an explicit requeue hook, then use that. otherwise
 	 * just put the request at the front of the queue
 	 */
@@ -386,6 +393,12 @@ struct request *elv_next_request(request
 		if (ret == BLKPREP_OK) {
 			break;
 		} else if (ret == BLKPREP_DEFER) {
+			/*
+			 * the request may have been (partially) prepped.
+			 * we need to keep this request in the front to
+			 * avoid resource deadlock.  turn on softbarrier.
+			 */
+			rq->flags |= REQ_SOFTBARRIER;
 			rq = NULL;
 			break;
 		} else if (ret == BLKPREP_KILL) {
