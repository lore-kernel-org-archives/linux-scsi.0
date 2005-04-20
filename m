From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 01/05] scsi: make blk layer set REQ_SOFTBARRIER
 when a request is dispatched
Date: Wed, 20 Apr 2005 15:44:44 +0900
Message-ID: <4265FA5C.8030801@gmail.com>
References: <20050419231435.D85F89C0@htj.dyndns.org> <20050419231435.2DEBE102@htj.dyndns.org> <20050420063009.GB9371@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.201]:64938 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261352AbVDTGov (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 02:44:51 -0400
Received: by rproxy.gmail.com with SMTP id a41so45891rng
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2005 23:44:51 -0700 (PDT)
In-Reply-To: <20050420063009.GB9371@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James.Bottomley@steeleye.com, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Apr 20 2005, Tejun Heo wrote:
> 
>>01_scsi_blk_make_started_requests_ordered.patch
>>
>>	Reordering already started requests is without any real
>>	benefit and causes problems if the request has its
>>	driver-specific resources allocated (as in SCSI).  This patch
>>	makes elv_next_request() set REQ_SOFTBARRIER automatically
>>	when a request is dispatched.
>>
>>	As both as and cfq schedulers don't allow passing requeued
>>	requests, the only behavior change is that requests deferred
>>	by prep_fn won't be passed by other requests.  This change
>>	shouldn't cause any problem.  The only affected driver other
>>	than SCSI is i2o_block.
>>
>>Signed-off-by: Tejun Heo <htejun@gmail.com>
>>
>> elevator.c |    8 ++++----
>> 1 files changed, 4 insertions(+), 4 deletions(-)
>>
>>Index: scsi-reqfn-export/drivers/block/elevator.c
>>===================================================================
>>--- scsi-reqfn-export.orig/drivers/block/elevator.c	2005-04-20 08:13:01.000000000 +0900
>>+++ scsi-reqfn-export/drivers/block/elevator.c	2005-04-20 08:13:33.000000000 +0900
>>@@ -370,11 +370,11 @@ struct request *elv_next_request(request
>> 
>> 	while ((rq = __elv_next_request(q)) != NULL) {
>> 		/*
>>-		 * just mark as started even if we don't start it, a request
>>-		 * that has been delayed should not be passed by new incoming
>>-		 * requests
>>+		 * just mark as started even if we don't start it.
>>+		 * also, as a request that has been delayed should not
>>+		 * be passed by new incoming requests, set softbarrier.
>> 		 */
>>-		rq->flags |= REQ_STARTED;
>>+		rq->flags |= REQ_STARTED | REQ_SOFTBARRIER;
>> 
>> 		if (rq == q->last_merge)
>> 			q->last_merge = NULL;
> 
> 
> Do it on requeue, please - not on the initial spotting of the request.
> 

  The thing is that we also need to set REQ_SOFTBARRIER on 
BLKPREP_DEFER.  So, it will be two places - in elv_next_request and 
blk_requeue_request.  The end result will be the same.  Do you think 
doing on requeue paths is better?

-- 
tejun

