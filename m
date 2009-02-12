From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/3] block: unexport blk_rq_append_bio
Date: Thu, 12 Feb 2009 18:50:32 +0900
Message-ID: <20090212184208X.fujita.tomonori@lab.ntt.co.jp>
References: <4993DCCA.8080508@panasas.com>
	<20090212174124S.fujita.tomonori@lab.ntt.co.jp>
	<4993E85A.20805@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:41778 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787AbZBLJuu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2009 04:50:50 -0500
In-Reply-To: <4993E85A.20805@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

On Thu, 12 Feb 2009 11:14:02 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> FUJITA Tomonori wrote:
> > On Thu, 12 Feb 2009 10:24:42 +0200
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> >> FUJITA Tomonori wrote:
> >>> On Wed, 11 Feb 2009 19:55:31 +0200
> >>> Boaz Harrosh <bharrosh@panasas.com> wrote:
> >>> static void _abort_unexecuted_bios(struct request *rq)
> >>> {
> >>> 	struct bio *bio;
> >>>
> >>> 	while ((bio = rq->bio) != NULL) {
> >>> 		rq->bio = bio->bi_next;
> >>> 		bio_endio(bio, 0);
> >>> 	}
> >>> }
> >>>
> >> No TOMO! The above is because I can start mapping a request even with simple map_kern
> >> and then fail and do not execute the request. If so, when I do a put_request() with a
> >> bio I'm leaking the bio. The above should be put inside put_request() so not
> >> to leak bios, but until then It's here.
> >>
> >> It has nothing to do with our discussion.
> > 
> > Seem that you don't understand what I talk about (and James, I think).
> > 
> > Of course, I understand the reason why you need that function.
> > 
> > The point is that OSD should not know how a request links bios.
> > 
> > OSD ULD should focus on OSD protocol processing. It should not know
> > the details of requests, bio, etc. OSD ULD should use the proper
> > helper functions of the block layer if OSD ULD uses the block layer
> > service.
> > 
> 
> What? I'm talking about a BUG, here. What do you suggest that I leak bios
> until a fix to block is accepted?

Huh? What I said is something like the above function should live in
the block layer. Again, OSD ULD should not know about such.


> And again this is unrelated. Even if I do exactly as you suggest which is
> use block API minus append_bio I still have that BUG. That must be fixed.
> 
> Please stop talking about above code. This is a different thread, unrelated
> to blk_rq_append_bio() removal.
> 
> > 
> > OSD ULD should focus on OSD protocol processing.
> 
> Which is what it does exactly. You ask me to interfere at OSD level and
> set policy on memory structures. What I did is let osd_write/read just be
>
> a transparent pipe between the upper layer FS code and the low level block
> layer. Proof of that, any kind of implementation you suggested is that much
> more code at OSD level? Today it is dead simple.

Why is it so difficult for you to understand the meaning that OSD ULD
should not know how request links bios?
