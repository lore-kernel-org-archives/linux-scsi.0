From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Wed, 09 May 2007 19:52:36 +0900
Message-ID: <200705091052.l49Aqano009015@mbox.iij4u.or.jp>
References: <4640C724.8030409@panasas.com>
	<1178654497.3737.81.camel@mulgrave.il.steeleye.com>
	<46417C5A.1090707@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:48891 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbXEIKxj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 May 2007 06:53:39 -0400
In-Reply-To: <46417C5A.1090707@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, bhalevy@panasas.com, jens.axboe@oracle.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Wed, 09 May 2007 10:46:34 +0300

> > Roll all the required sglist definitions (request_bufflen,
> > request_buffer, use_sg and sglist_len) into the sgtable pools.
> > 
> > We're getting very close to the point where someone gets to sweep
> > through the drivers eliminating the now superfluous non-sg path in the
> > queuecommand.  When that happens the only cases become no transfer or SG
> > backed commands.  At this point we can do a consolidation of the struct
> > scsi_cmnd fields.  This does represent the ideal time to sweep the sg
> > list handling fields into the sgtable and simply have a single pointer
> > to struct sgtable in the scsi_cmnd (== NULL is the signal for a no
> > transfer command).
> > 
> This is a grate Idea. Let me see if I understand what you mean.
> 1. An sgtable is a single allocation with an sgtable header type
>    at the begining and a veriable size array of struct scatterlist.
>    something like:
>    struct sgtable {
>    	struct sgtable_header {
> 		unsigned sg_count, sglist_len, length;
> 		struct sgtable* next; //for Jens's big io
>    	} hdr;
> 	struct scatterlist sglist[];
>    }

Can we have more simple sgtable?

struct sgtable {
	unsigned use_sg;
	unsigned length;
	unsigned sglist_len;
	struct scatterlist sglist[0];
};


Then we could do something like this:

struct scsi_host_sgtable_pool {
	size_t size;
	char *name;
	struct kmem_cache *slab;
	mempool_t *pool;
};

int __init scsi_init_queue(void)
{
	for (i = 0; i < SG_MEMPOOL_NR; i++) {
		struct scsi_host_sgtable_pool *sgtbp = scsi_sgtable_pools + i;
		int size = sizeof(struct sgtable) + sgp->size * sizeof(struct scatterlist);

		sgp->slab = kmem_cache_create(sgp->name, size, 0,
				SLAB_HWCACHE_ALIGN, NULL, NULL);
		if (!sgp->slab) {
			printk(KERN_ERR "SCSI: can't init sg slab %s\n",
					sgp->name);
		}

		sgp->pool = mempool_create_slab_pool(SG_MEMPOOL_SIZE,
						     sgp->slab);


Jens' chaining sg lists adds sg->next so we don't need
sgtable->next. We can just add __use_sg to struct sgtable.


> 2. The way we can do this in stages: Meaning put up code that has
>    both sets of API, Transfer drivers one-by-one to new API, deprecate
>    old API for a kernel cycle or two. Than submit last piece of
>    code that removes the old API.
>    It can be done. We just need to copy sgtable_header fields
>    to the old fields, and let them stick around for a while.

That's not bad, but can we convert all the LLDs all at once?

The changes to scsi mid-layer are almost done. Probabaly, you can just
add sgtable stuff (and scsi_dma_map/scsi_dma_unmap helper functions
that Christoph proposed long ago) to my previous patch. It can be done
for several hours. So you have enough time for the LLDs' changes.


> 3. The second bidi sgtable will hang on request->next_rq->special.

I think so.
