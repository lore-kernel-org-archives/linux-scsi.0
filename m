From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 01/05] scsi: make blk layer set	REQ_SOFTBARRIER
 when a request is dispatched
Date: Thu, 21 Apr 2005 07:58:59 +0900
Message-ID: <4266DEB3.4020502@gmail.com>
References: <20050419231435.D85F89C0@htj.dyndns.org> <20050419231435.2DEBE102@htj.dyndns.org> <20050420063009.GB9371@suse.de> <20050420074026.GA11228@htj.dyndns.org> <1113983899.5074.111.camel@npiggin-nld.site> <426614B7.5010204@gmail.com> <20050420083853.GB6558@suse.de> <42661B2C.1020100@yahoo.com.au> <20050420091428.GH6558@suse.de> <42661FDB.7030409@yahoo.com.au> <20050420094417.GI6558@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.207]:36071 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261723AbVDTW7H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 18:59:07 -0400
Received: by rproxy.gmail.com with SMTP id z35so289033rne
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2005 15:59:06 -0700 (PDT)
In-Reply-To: <20050420094417.GI6558@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, James.Bottomley@steeleye.com, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>


  Hello, guys.

Jens Axboe wrote:
> On Wed, Apr 20 2005, Nick Piggin wrote:
> 
>>Jens Axboe wrote:
>>
>>>On Wed, Apr 20 2005, Nick Piggin wrote:
>>>
>>
>>>>I guess this could be one use of 'reordering' after a requeue.
>>>
>>>
>>>Yeah, or perhaps the io scheduler might determine that a request has
>>>higher prio than a requeued one.  I'm not sure what semantics to place
>>
>>I guess this is possible. It is often only a single request
>>that is on the dispatch list though, so I don't know if it
>>would make sense to reorder it by priority again.
> 
> 
> Depends entirely on the io scheduler. CFQ may put several on the
> dispatch list.
> 
> 
>>>on soft-barrier, I've always taken it to mean 'maintain ordering if
>>>convenient' where the hard-barrier must be followed.
>>>
>>
>>I've thought it was SOFTBARRIER ensures the device driver (and
>>hardware?) sees the request in this order, and HARDBARRIER ensures
>>it reaches stable storage in this order.
>>
>>Not exactly sure why you would want a softbarrier and not a
>>hardbarrier. Maybe for special commands.
> 
> 
> It is the cleaner interpretation. CFQ marks requests as requeued
> internally and gives preference to them for reissue, but it may return
> another first (actually, I think it even checks for ->requeued on
> dispatch sort, so it wont right now).
> 
> 
>>>>I'm not sure this would need a REQ_SOFTBARRIER either though, really.
>>>>
>>>>Your basic io scheduler framework - ie. a FIFO dispatch list which
>>>>can have requests requeued on the front models pretty well what the
>>>>block layer needs of the elevator.
>>>>
>>>>Considering all requeues and all elv_next_request but not dequeued
>>>>requests would have this REQ_SOFTBARRIER bit set, any other model
>>>>that theoretically would allow reordering would degenerate to this
>>>>dispatch list behaviour, right?
>>>
>>>
>>>Not sure I follow this - I don't want REQ_SOFTBARRIER set automatically
>>>on elv_next_request() return, it should only happen on requeues.
>>>REQ_STARTED implies that you should not pass this request, since the io
>>>scheduler is required to return this request again until dequeue is
>>>called. But the result is the same, correct.
>>>
>>
>>OK - but I'm wondering would it ever make sense to do it any
>>other way? I would have thought no, in which case we can document
>>that requests seen by 'elv_next_request', and those requeued back
>>into the device will not be reordered, and so Tejun does not need
>>to set REQ_SOFTBARRIER.
>>
>>But I'm not so sure now... it isn't really that big a deal ;)
>>So whatever you're happy with is fine. Sorry for the nose.
> 
> 
> It's not noise, it would be nice to have this entirely documented so
> that there isn't any confusion on what is guaranteed vs what currently
> happens in most places.
> 
> But I don't want to document that they are never reordered. For requeues
> it make sense to maintain ordering in most cases, but it also may make
> sense to reorder for higher priority io. If the driver does _not_ want a
> particular request reordered for data integrity reasons, then that needs
> to be explicitly specified.
> 

  So, I guess this is settled now.  James, what do you think about the 
rest of this patchset?  If you're okay, I think we can proceed merging 
as there doesn't seem to be any issue left.  Do we put this into the 
SCSI tree?  Or separate out blk and SCSI changes?

  Once we're done merging this patchset, I'll regenerate & repost the 
reqfn reimpl patchset.

  Thanks a lot. :-)

-- 
tejun

