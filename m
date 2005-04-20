From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 01/05] scsi: make blk layer set	REQ_SOFTBARRIER
 when a request is dispatched
Date: Wed, 20 Apr 2005 17:37:11 +0900
Message-ID: <426614B7.5010204@gmail.com>
References: <20050419231435.D85F89C0@htj.dyndns.org>	 <20050419231435.2DEBE102@htj.dyndns.org> <20050420063009.GB9371@suse.de>	 <20050420074026.GA11228@htj.dyndns.org> <1113983899.5074.111.camel@npiggin-nld.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.199]:47029 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261329AbVDTIhT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 04:37:19 -0400
Received: by rproxy.gmail.com with SMTP id a41so60297rng
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2005 01:37:18 -0700 (PDT)
In-Reply-To: <1113983899.5074.111.camel@npiggin-nld.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jens Axboe <axboe@suse.de>, James.Bottomley@steeleye.com, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>

Nick Piggin wrote:
> On Wed, 2005-04-20 at 16:40 +0900, Tejun Heo wrote:
> 
>> Hello, Jens.
>>
>>On Wed, Apr 20, 2005 at 08:30:10AM +0200, Jens Axboe wrote:
>>
>>>Do it on requeue, please - not on the initial spotting of the request.
>>
>> This is the reworked version of the patch.  It sets REQ_SOFTBARRIER
>>in two places - in elv_next_request() on BLKPREP_DEFER and in
>>blk_requeue_request().
>>
>> Other patches apply cleanly with this patch or the original one and
>>the end result is the same, so take your pick.  :-)
>>
> 
> 
> I'm not sure that you need *either* one.
> 
> As far as I'm aware, REQ_SOFTBARRIER is used when feeding requests
> into the top of the block layer, and is used to guarantee the device
> driver gets the requests in a specific ordering.
> 
> When dealing with the requests at the other end (ie.
> elevator_next_req_fn, blk_requeue_request), then ordering does not
> change.
> 
> That is - if you call elevator_next_req_fn and don't dequeue the
> request, then that's the same request you'll get next time.
> 
> And blk_requeue_request will push the request back onto the end of
> the queue in a LIFO manner.
> 
> So I think adding barriers, apart from not doing anything, confuses
> the issue because it suggests there *could* be reordering without
> them.
> 
> Or am I completely wrong? It's been a while since I last got into
> the code.

 Well, yeah, all schedulers have dispatch queue (noop has only the
dispatch queue) and use them to defer/requeue, so no reordering will
happen, but I'm not sure they are required to be like this or just
happen to be implemented so.

 Hmm, well, it seems that setting REQ_SOFTBARRIER on requeue path isn't
necessary as we have INSERT_FRONT policy on requeue, and if
elv_next_req_fn() is required to return the same request when the
request isn't dequeued, you're right and we don't need this patch at
all.  We are guaranteed that all requeued requests are served in LIFO
manner.

 BTW, the same un-dequeued request rule is sort of already broken as
INSERT_FRONT request passes a returned but un-dequeued request, but,
then again, we need this behavior as we have to favor fully-prepped
requests over partially-prepped one.

-- 
tejun

