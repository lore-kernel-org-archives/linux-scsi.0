From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/3] block: unexport blk_rq_append_bio
Date: Thu, 12 Feb 2009 01:04:34 +0900
Message-ID: <20090212010454J.fujita.tomonori@lab.ntt.co.jp>
References: <4992E9A4.9080303@panasas.com>
	<20090212002105A.fujita.tomonori@lab.ntt.co.jp>
	<4992F1AF.9060702@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:49919 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbZBKQEw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2009 11:04:52 -0500
In-Reply-To: <4992F1AF.9060702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

On Wed, 11 Feb 2009 17:41:35 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> FUJITA Tomonori wrote:
> > On Wed, 11 Feb 2009 17:07:16 +0200
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> >>>
> >>>
> >> Sure it can pass pages to ULD but then how ULD maks a request out of
> >> pages?
> > 
> > If you extend blk_rq_map_kern as James did, your ULD make a request
> > out of passed pages, that is, the block layer properly builds a
> > request with bio(s).
> 
> What? I don't understand?
> blk_rq_map_kern takes a kernel-pointer and length, how to pass array
> of page* ?

You can call it multiple times. But I guess that you need something
new since you need to handle user pages.


> > I think that another possible option is adding a new mapping function
> > that can handle multiple bios for kernel buffers (as Mike extended
> > blk_rq_map_user).
> > 
> 
> Yes adding a new mapping function can help. Please note I need to
> add (append) pages same as bio_add_pc_page() but on request level.

I think that what you need already exists.

See how st uses blk_rq_map_user() in scsi-misc (keywords: rq_map_data
and null_mapped). Please read it before saying something like 'we need
to handle kernel buffer'.


> And yet we had an entry that did exactly that, blk_rq_append_bio(), no?

Using blk_rq_append_bio in SCSI is unacceptable.


> >> And it gets more complicated then that (above multiple times)
> > 
> > I don't think so. If you don't have time to work on it, please let me
> > know. I'll fix OSD ULD.
> 
> I have all the time in the world, And yes what James did with blk_rq_map_kern
> will help with appending other osd segments on top of data.
> 
> If you propose the appropriate new API for block request level I can implement
> that in block, and also in OSD. What other entry you want to add/change that solve
> my need?

If you have time, how about making a proposal. ;)

But as I wrote above, I think that blk_rq_map_user() works for you.
