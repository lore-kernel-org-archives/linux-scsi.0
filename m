From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH RFC 1/2] scatterlist: add mempool based chained SG
	alloc/free api
Date: Wed, 16 Mar 2016 09:23:39 +0100
Message-ID: <20160316082339.GA6203@lst.de>
References: <1458081569-30953-1-git-send-email-mlin@kernel.org> <1458081569-30953-2-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458081569-30953-2-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

>  /*
> + * The maximum number of SG segments that we will put inside a
> + * scatterlist.
> + *
> + * XXX: what's the best number?
> + */
> +#define SG_MAX_SEGMENTS			128

The important part here is that it's the amount we fit into a single
scatterlist chunk.  So I think naming it SG_CHUNK_SIZE  or similar
would be a better idea (the name in SCSI is from the days before
we supported chained S/G lists).

It would also be good to =E2=85=BAring over the comments from
SCSI_MAX_SG_SEGMENTS.

We'll also need a symbol like SCSI_MAX_SG_CHAIN_SEGMENTS that contains
the absolute limit, and we need the CONFIG_ARCH_HAS_SG_CHAIN magic
around it for now as we still have architetures that do not support
S/G chanining in their dma_map_sg implementation.  I plan to fix that
up in a merge window or two, though.  My name suggestion for that
would be SG_MAX_SEGMENTS.

> +#define SG_MEMPOOL_NR		ARRAY_SIZE(sg_pools)

We can defintively kill this one.

> +#define SG_MEMPOOL_SIZE		2
> +
> +struct sg_mempool {

I'd keep this as struct sg_pool, similar to SCSI.

> +/**
> + * sg_free_chained - Free a previously mapped sg table
> + * @table:	The sg table header to use
> + * @first_chunk: was first_chunk not NULL in sg_alloc_chained?
> + *
> + *  Description:
> + *    Free an sg table previously allocated and setup with
> + *    sg_alloc_chained().
> + *
> + **/
> +void sg_free_chained(struct sg_table *table, bool first_chunk)

Can we call this sg_free_table_chained to be similar to sg_table_free?
Same for the alloc side.

> +static __init int sg_mempool_init(void)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < SG_MEMPOOL_NR; i++) {
> +		struct sg_mempool *sgp =3D sg_pools + i;
> +		int size =3D sgp->size * sizeof(struct scatterlist);
> +
> +		sgp->slab =3D kmem_cache_create(sgp->name, size, 0,
> +				SLAB_HWCACHE_ALIGN, NULL);

Having these mempoools around in every kernel will make some embedded
developers rather unhappy.  We could either not create them at
runtime, which would require either a check in the fast path, or
an init call in every driver, or just move the functions you
added into a separe file, which will be compiled only based on a Kconfi=
g
symbol, and could even be potentially modular.  I think that
second option might be easier.
