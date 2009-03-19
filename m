From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCHSET  0/2] Don't let blk_put_request leak BIOs
Date: Thu, 19 Mar 2009 14:45:01 +0100
Message-ID: <20090319134500.GO27476@kernel.dk>
References: <49C21C5A.6030105@panasas.com> <20090319113343.GF27476@kernel.dk> <49C24B55.3040609@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:40879 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbZCSNpD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Mar 2009 09:45:03 -0400
Content-Disposition: inline
In-Reply-To: <49C24B55.3040609@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

On Thu, Mar 19 2009, Boaz Harrosh wrote:
> Jens Axboe wrote:
> > On Thu, Mar 19 2009, Boaz Harrosh wrote:
> >> Hi Jens
> >>
> >> You never commented on these patches. Please have a look?
> >>
> >> The issue is that if we map some memory into a request but then
> >> do not execute it. Then calling blk_put_request() will leak the bio(s)
> >> unless one does an ugly code like:
> >> -	struct bio *bio;
> >> -
> >> -	while ((bio = rq->bio) != NULL) {
> >> -		rq->bio = bio->bi_next;
> >> -		bio_endio(bio, 0);
> >> -	}
> 
> This is the code I have today in osd_initiator.c (In scsi-misc tree)
> 
> > 
> > Sorry, I think this is a horrible design. blk_put_request() doesn't care
> > about any data attachments, in fact (if possible) it should go BUG() if
> > the request hasn't been completed in some way or other. It deals with
> > the deallocation part, blk_get_request() doesn't attach any data. The
> > end result with code like the above is an assymmetric API.
> > 
> >> This problem arise in OSD when we can fail to setup the write
> >> or the read side and then we must cleanup the other half.
> >> Same problem exist in bsg, on bidi commands. But there the bio
> >> is just leaked on the error path, it does not do the ugly loop above.
> > 
> > These drivers should just be fixed, then.
> > 
> > So if you have spotted this problem in eg bsg, then please send a patch
> > for that to Tomo!
> > 
> 
> Then the above code taken from today's osd_initiator is good? People where
> complaining that it is not good, because it is messing up with internal
> block structures.
> 
> What about just exporting an blk_rq_abort(struct request *req) that is
> the same as PATCH 1/2. But is not called from blk_put_request ?

Well no, the approach isn't that good either. How did you map these
request? Most logical API would have something to unmap them again.

-- 
Jens Axboe

