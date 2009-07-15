From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/4] block: use the same failfast bits for bio and	request
Date: Wed, 15 Jul 2009 18:27:57 +0900
Message-ID: <4A5DA11D.90401@kernel.org>
References: <1246610898-22350-1-git-send-email-tj@kernel.org> <1246610898-22350-3-git-send-email-tj@kernel.org> <4A5071E5.8030908@panasas.com> <4A553DA4.4080408@kernel.org> <20090709133746.GA21929@infradead.org> <4A573FB9.2090202@kernel.org> <4A59D1AB.2040705@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:38814 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbZGOJ2S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jul 2009 05:28:18 -0400
In-Reply-To: <4A59D1AB.2040705@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Niel Lambrechts <niel.lambrechts@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>

Hello, Boaz.

Boaz Harrosh wrote:
>>> flags as bit positions generally only make sense if you use
>>> test/set/clear_bit, otherwise they just confuse things.
> 
> first please make a distinction between test/set/clear_bit and
> test/__set/__clear_bit the former is not an option since it's not what
> we need.

Block flags look like the way they do today because a while back they
were accessed with atomic bitops (the versions w/o the underbars).
Now that they're all inside spinlocks, it all became moot.

> What can be more clear then rq_set_flags(req, QUEUE_FLAG_QUEUED) then
> rq_clear_flags(req, QUEUE_FLAG_QUEUED) later.

req->cmd_flags |= QUEUE_FLAG_QUEUED / &= ~QUEUE_FLAG_QUEUED might not
be as clear but should be sufficient, I suppose.

> That's why I suggested the set/clear_flags() variable size macro
> which can  set/clear multiple bit-flags at same cost of masks, only
> that the compiler calculates the mask in compile time.
> 
> This can also be good for the greps above. .eg:
> test_flags(&rq->cmd_flags, REQ_FAILFAST_DEV, REQ_FAILFAST_TRANSPORT, REQ_FAILFAST_DRIVER);
...
> As said, yes, the the lower-case accessors for upper-case bits does nothing,
> but use __set/__clear/test is a different matter that can also replace the
> sugary need of these.

Heh.. I don't know.  What about things like flags & mask == mask2
test?  The vararg macros would work for most cases and I wouldn't be
violently against them if they were already in place but I don't see
much benefit of all those when people are already very accustomed to
using c bitops to handle flags.

Thanks.

-- 
tejun
