From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] block: unexport blk_rq_append_bio
Date: Thu, 12 Feb 2009 10:24:42 +0200
Message-ID: <4993DCCA.8080508@panasas.com>
References: <20090212010454J.fujita.tomonori@lab.ntt.co.jp>	<1234369838.3295.31.camel@localhost.localdomain>	<49931113.3090701@panasas.com> <20090212103112M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:30903 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750711AbZBLIYw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Feb 2009 03:24:52 -0500
In-Reply-To: <20090212103112M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> On Wed, 11 Feb 2009 19:55:31 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>>> Part of the problem, I think, is that a typical filesystem either works
>>> with pages (ext3) or bios (btrfs) and puts them in block at the top.
>>> Block then accumulates the pages to bios, elevates the bios into
>>> requests and spits those out to SCSI ... this is why we want to
>>> eliminate bio handlers from SCSI.
>>>
>> You are too fast for me, sorry, I did not get that: "... this is why" logical jump.
>> I thought we where getting read of scatter-gather handlers from SCSI. We never
>> had any bio handlers in scsi, did we?
>>
>>> Your problem is that you phrase your osd fs/pnfs in terms of bios, so
>>> then you need to emulate the block bio handlers internally (because
>>> you're bypassing block) in your ULD.  However, what we're saying is if
>>> you speak pages instead, you can utilise the standard block pc handlers,
>>> which are designed to speak pages, without reinventing the bio handling
>>> infrastructure.
>> I did not know I was reinventing the bio handling infrastructure, I thought
> 
> I think that we call something like the following reinventing the bio
> handling infrastructure:
> 
> static void _abort_unexecuted_bios(struct request *rq)
> {
> 	struct bio *bio;
> 
> 	while ((bio = rq->bio) != NULL) {
> 		rq->bio = bio->bi_next;
> 		bio_endio(bio, 0);
> 	}
> }
> 

No TOMO! The above is because I can start mapping a request even with simple map_kern
and then fail and do not execute the request. If so, when I do a put_request() with a
bio I'm leaking the bio. The above should be put inside put_request() so not
to leak bios, but until then It's here.

It has nothing to do with our discussion.

> 
>> I was using it with all available glory, and exported API. I let different users
> 
> include/blkdev.h says:
> 
> /*
>  * Temporary export, until SCSI gets fixed up.
>  */
> extern int blk_rq_append_bio(struct request_queue *q, struct request *rq,
> 			     struct bio *bio);
> 
> 
> blk_rq_append_bio is not an exported API. We finally fixed SCSI but
> you broke it again.
> 

Fine, but I have a very legitimate need, which is:

Scatter-Gather Memory information was collected in a bio. At
some stage I need to make it a request. How?

> 
>> collect their memory information inside a bio, then in one simple call
>> the bio is elevated to a request and the request is submitted, block_pc style.
>>
>> Actually I just started to code using blk_rq_map_user(), and setting of all
>> struct rq_map_data information, and that feels a little like bio code duplication.
>> Because I need a collection (link-list) of them. struct rq_map_data assumes linear memory
>> which I do not have. Also I will need that blk_rq_map_user() will append bios like the change
>> you proposed to blk_rq_map_kern(), I guess it is doable, only it's lots of more work.
>> (And that awful blk_rq_unmap_user() which forces me to know if I sent via map_usr or map_kern ...)
> 
> I think that having something like blk_rq_map_kern_page with James'
> extension is another option.
> 

That is a very good option. I will need a way to specify a page_max_count to pre-allocate
the right size bio, so no bio re-allocations occurs.

Should I send a proposal for this?

[And yet there is such an exported API at bio level why not just open-code above, Linux Kernel
 style]

> 
>> I have one question. If bio API is only to be used by block layer internal, why is it
>> exported at all? Seems a bio has nice API for collecting memory information and is used
> 
> As I wrote, you use API that should not be exported. And I really
> don't think that SCSI ULD needs to play with bio. As James wrote, you
> reinvent and duplicate some of the block layer. That's a design that
> we should avoid.
> 

And as I wrote, I do not! Show me where? There is not a single line of duplication. I'm serving
complex file systems with their crazy memory needs. I need some structure to hold 
scatter-gather information. The best API around that does just that, with nice stuff like
slab pools and pre-allocations, is readily available at bio level. What you are asking me
is to duplicate all that. So it is opposite of what you say, you are asking me to duplicate
code I'm trying to re-use block layer code.

> 
>> by all kind of block users like filesystems, DM, MD, data integrity and others. I would
>> not mind a:
>> 	struct requst *blk_pc_make_request(bio);
>> Of sorts, to make it official, same as generic_make_request() but for block_pc users.

TOMO James please answer my question.
What is bad with bio usage as a memory crier? Why can filesystems, diff-engines, DM, MD,
you name it, use a bio, only OSD cannot? what is the reason? You say duplication of code?
what code in OSD? which code is it duplicating?

Boaz
