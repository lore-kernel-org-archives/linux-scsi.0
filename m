From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH scsi-misc-2.6 01/05] scsi: make blk layer set
	REQ_SOFTBARRIER when a request is dispatched
Date: Wed, 20 Apr 2005 17:58:19 +1000
Message-ID: <1113983899.5074.111.camel@npiggin-nld.site>
References: <20050419231435.D85F89C0@htj.dyndns.org>
	 <20050419231435.2DEBE102@htj.dyndns.org> <20050420063009.GB9371@suse.de>
	 <20050420074026.GA11228@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp202.mail.sc5.yahoo.com ([216.136.129.92]:65159 "HELO
	smtp202.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261451AbVDTH61 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 03:58:27 -0400
In-Reply-To: <20050420074026.GA11228@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, James.Bottomley@steeleye.com, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>

On Wed, 2005-04-20 at 16:40 +0900, Tejun Heo wrote:
>  Hello, Jens.
> 
> On Wed, Apr 20, 2005 at 08:30:10AM +0200, Jens Axboe wrote:
> > Do it on requeue, please - not on the initial spotting of the request.
> 
>  This is the reworked version of the patch.  It sets REQ_SOFTBARRIER
> in two places - in elv_next_request() on BLKPREP_DEFER and in
> blk_requeue_request().
> 
>  Other patches apply cleanly with this patch or the original one and
> the end result is the same, so take your pick.  :-)
> 

I'm not sure that you need *either* one.

As far as I'm aware, REQ_SOFTBARRIER is used when feeding requests
into the top of the block layer, and is used to guarantee the device
driver gets the requests in a specific ordering.

When dealing with the requests at the other end (ie.
elevator_next_req_fn, blk_requeue_request), then ordering does not
change.

That is - if you call elevator_next_req_fn and don't dequeue the
request, then that's the same request you'll get next time.

And blk_requeue_request will push the request back onto the end of
the queue in a LIFO manner.

So I think adding barriers, apart from not doing anything, confuses
the issue because it suggests there *could* be reordering without
them.

Or am I completely wrong? It's been a while since I last got into
the code.


-- 
SUSE Labs, Novell Inc.



