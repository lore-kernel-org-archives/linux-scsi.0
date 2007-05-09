From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Wed, 09 May 2007 09:55:13 -0500
Message-ID: <1178722514.3695.23.camel@mulgrave.il.steeleye.com>
References: <4640C724.8030409@panasas.com>
	 <1178654497.3737.81.camel@mulgrave.il.steeleye.com>
	 <46417C5A.1090707@panasas.com>
	 <200705091052.l49Aqano009015@mbox.iij4u.or.jp>
	 <4641D380.8050100@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34629 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752892AbXEIOzw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2007 10:55:52 -0400
In-Reply-To: <4641D380.8050100@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

On Wed, 2007-05-09 at 16:58 +0300, Boaz Harrosh wrote:
> >> 1. An sgtable is a single allocation with an sgtable header type
> >>    at the begining and a veriable size array of struct scatterlist.
> >>    something like:
> >>    struct sgtable {
> >>    	struct sgtable_header {
> >> 		unsigned sg_count, sglist_len, length;
> >> 		struct sgtable* next; //for Jens's big io
> >>    	} hdr;
> >> 	struct scatterlist sglist[];
> >>    }
> > 
> > Can we have more simple sgtable?
> > 
> > struct sgtable {
> > 	unsigned use_sg;
> > 	unsigned length;
> > 	unsigned sglist_len;
> > 	struct scatterlist sglist[0];
> > };
> > 
> Yes sure. It was just an example.
> One comment, use_sg => sg_count.
> By the way I have forgotten some fields so it should be:
> 
> struct sgtable {
>  	unsigned short sg_count;
>  	unsigned short sg_pool; /* note that this is the pool index and not the actual count */
>  	unsigned length;
>  	unsigned resid;
>  	struct scatterlist sglist[0];
> };
> 
> resid/length together with request->data_len can be optimized, this is the current system.

Actually, the first order of business is to use accessors on the command
pointers in the drivers to free them from the internal layout of the
structure (and where it is allocated).

> > 
> > Then we could do something like this:
> > 
> > struct scsi_host_sgtable_pool {
> > 	size_t size;
> > 	char *name;
> > 	struct kmem_cache *slab;
> > 	mempool_t *pool;
> > };
> > 
> > int __init scsi_init_queue(void)
> > {
> > 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
> > 		struct scsi_host_sgtable_pool *sgtbp = scsi_sgtable_pools + i;
> > 		int size = sizeof(struct sgtable) + sgp->size * sizeof(struct scatterlist);
> > 
> > 		sgp->slab = kmem_cache_create(sgp->name, size, 0,
> > 				SLAB_HWCACHE_ALIGN, NULL, NULL);
> > 		if (!sgp->slab) {
> > 			printk(KERN_ERR "SCSI: can't init sg slab %s\n",
> > 					sgp->name);
> > 		}
> > 
> > 		sgp->pool = mempool_create_slab_pool(SG_MEMPOOL_SIZE,
> > 						     sgp->slab);
> > 
> > 
> I think we can do a better job here by fitting exactly the number of scatterlist
> entries that will take up full pages including the header. This is sizes
> dependent and can be compile-time calculated. For example in x86_64, with header,
> 145 scatterlist will fit in a page so this is kind of magic number for this arch.
> 
> could someone explain why we need scatterlist-max-count a base-2 number?

Power of 2 is the most efficient way to manage space vs pool number in
an arbitrarily sized system.  This, too, can be accessor abstracted ...

> > Jens' chaining sg lists adds sg->next so we don't need
> > sgtable->next. We can just add __use_sg to struct sgtable.
> > 
> Yes but it uses the last struct scatterlist for the ->next, this way it is saved.
> On the other hand it wastes a pointer in small IOs. So I guess this is Jens's
> call.
> If the "->next" in both cases will point to a struct sgtable above than we don't need
> __use_sg since sg_pool(sglist_len) holds the pool this came from. If not __use_sg
> must be added to struct sgtable.
> 
> It looks like proposed change races with Jens's work so it's better be done after
> his. It could be nice if he incorporates some of the constrains from here before
> hand.
> 
> > 
> >> 2. The way we can do this in stages: Meaning put up code that has
> >>    both sets of API, Transfer drivers one-by-one to new API, deprecate
> >>    old API for a kernel cycle or two. Than submit last piece of
> >>    code that removes the old API.
> >>    It can be done. We just need to copy sgtable_header fields
> >>    to the old fields, and let them stick around for a while.
> > 
> > That's not bad, but can we convert all the LLDs all at once?

No, that's why you do the accessors.  Convert all of the common drivers
to accessors on the current structure, then throw the switch to convert
to the new structure (whatever form is finally settled on).  Then any
unconverted drivers break and people fix the ones they care about.

> > The changes to scsi mid-layer are almost done. Probabaly, you can just
> > add sgtable stuff (and scsi_dma_map/scsi_dma_unmap helper functions
> > that Christoph proposed long ago) to my previous patch. It can be done
> > for several hours. So you have enough time for the LLDs' changes.
> I am here to do any work needed. I will wait to see what is decided.
> 
> I already have a 2.6.20 tree with all llds converted to things like
> "scsi_uni(cmd)->sg" where scsi_uni() was pointing to:
> struct scsi_data_buffer {
>  	unsigned short sg_count;
>  	unsigned short sg_pool; /* note that this is the pool index and not the actual count */
>  	unsigned length;
>  	unsigned resid;
>  	struct scatterlist *sg;
> };
> as part of my old bidi work. So a simple search and replace can be done to the new API/names.
> > 
> > 
> >> 3. The second bidi sgtable will hang on request->next_rq->special.
> > 
> > I think so.

James


