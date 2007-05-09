From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Wed, 09 May 2007 23:54:40 +0900
Message-ID: <20070509235440Q.fujita.tomonori@lab.ntt.co.jp>
References: <46417C5A.1090707@panasas.com>
	<200705091052.l49Aqano009015@mbox.iij4u.or.jp>
	<4641D380.8050100@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:53031 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbXEIOzv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2007 10:55:51 -0400
In-Reply-To: <4641D380.8050100@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Wed, 09 May 2007 16:58:24 +0300

> FUJITA Tomonori wrote:
> > From: Boaz Harrosh <bharrosh@panasas.com>
> > Subject: Re: [PATCH v2] add bidi support for block pc requests
> > Date: Wed, 09 May 2007 10:46:34 +0300
> > 
> >>> Roll all the required sglist definitions (request_bufflen,
> >>> request_buffer, use_sg and sglist_len) into the sgtable pools.
> >>>
> >>> We're getting very close to the point where someone gets to sweep
> >>> through the drivers eliminating the now superfluous non-sg path in the
> >>> queuecommand.  When that happens the only cases become no transfer or SG
> >>> backed commands.  At this point we can do a consolidation of the struct
> >>> scsi_cmnd fields.  This does represent the ideal time to sweep the sg
> >>> list handling fields into the sgtable and simply have a single pointer
> >>> to struct sgtable in the scsi_cmnd (== NULL is the signal for a no
> >>> transfer command).
> >>>
> >> This is a grate Idea. Let me see if I understand what you mean.
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
> 
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

To let the slab allocater to do better job?

We can improve these issues later without disturbing LLDs. No need to
do this right now.


> > Jens' chaining sg lists adds sg->next so we don't need
> > sgtable->next. We can just add __use_sg to struct sgtable.
> > 
> Yes but it uses the last struct scatterlist for the ->next, this way
> it is saved.  On the other hand it wastes a pointer in small IOs. So
> I guess this is Jens's call.  If the "->next" in both cases will
> point to a struct sgtable above

I think that some non scsi stuff also need chaining sg. so sg needs a
chaining scheme; sg->next, crypto layer's hack (not to add sg->next),
etc. Instead of using sg's chaining, having stable->next is wrong.
