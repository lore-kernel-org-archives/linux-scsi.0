From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/3] SG: Move functions to lib/scatterlist.c and add sg
 chaining allocator helpers
Date: Thu, 20 Dec 2007 16:21:52 +0200
Message-ID: <476A7A80.10504@panasas.com>
References: <200712201645.19035.rusty@rustcorp.com.au> <20071220160741K.fujita.tomonori@lab.ntt.co.jp> <200712201853.48643.rusty@rustcorp.com.au> <20071220075814.GH13958@kernel.dk> <476A743D.2080506@panasas.com> <476A7566.2040802@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:52300 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934033AbXLTOW6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Dec 2007 09:22:58 -0500
In-Reply-To: <476A7566.2040802@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dougg@torque.net

A small comment in body

On Thu, Dec 20 2007 at 16:00 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> Manually doing chained sg lists is not trivial, so add some helpers
> to make sure that drivers get it right.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  include/linux/scatterlist.h |  125 ++++---------------
>  lib/Makefile                |    2 +-
>  lib/scatterlist.c           |  281 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 307 insertions(+), 101 deletions(-)
>  create mode 100644 lib/scatterlist.c
> 
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index 416e000..c3ca848 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -7,6 +7,12 @@
>  #include <linux/string.h>
>  #include <asm/io.h>
>  
> +struct sg_table {
> +	struct scatterlist *sgl;	/* the list */
> +	unsigned int nents;		/* number of mapped entries */
> +	unsigned int orig_nents;	/* original size of list */
> +};
> +
>  /*
>   * Notes on SG table design.
>   *
> @@ -106,31 +112,6 @@ static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
>  	sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
>  }
>  
> -/**
> - * sg_next - return the next scatterlist entry in a list
> - * @sg:		The current sg entry
> - *
> - * Description:
> - *   Usually the next entry will be @sg@ + 1, but if this sg element is part
> - *   of a chained scatterlist, it could jump to the start of a new
> - *   scatterlist array.
> - *
> - **/
> -static inline struct scatterlist *sg_next(struct scatterlist *sg)
> -{
> -#ifdef CONFIG_DEBUG_SG
> -	BUG_ON(sg->sg_magic != SG_MAGIC);
> -#endif
> -	if (sg_is_last(sg))
> -		return NULL;
> -
> -	sg++;
> -	if (unlikely(sg_is_chain(sg)))
> -		sg = sg_chain_ptr(sg);
> -
> -	return sg;
> -}
> -
>  /*
>   * Loop over each sg element, following the pointer to a new list if necessary
>   */
> @@ -138,40 +119,6 @@ static inline struct scatterlist *sg_next(struct scatterlist *sg)
>  	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg = sg_next(sg))
>  
>  /**
> - * sg_last - return the last scatterlist entry in a list
> - * @sgl:	First entry in the scatterlist
> - * @nents:	Number of entries in the scatterlist
> - *
> - * Description:
> - *   Should only be used casually, it (currently) scan the entire list
> - *   to get the last entry.
> - *
> - *   Note that the @sgl@ pointer passed in need not be the first one,
> - *   the important bit is that @nents@ denotes the number of entries that
> - *   exist from @sgl@.
> - *
> - **/
> -static inline struct scatterlist *sg_last(struct scatterlist *sgl,
> -					  unsigned int nents)
> -{
> -#ifndef ARCH_HAS_SG_CHAIN
> -	struct scatterlist *ret = &sgl[nents - 1];
> -#else
> -	struct scatterlist *sg, *ret = NULL;
> -	unsigned int i;
> -
> -	for_each_sg(sgl, sg, nents, i)
> -		ret = sg;
> -
> -#endif
> -#ifdef CONFIG_DEBUG_SG
> -	BUG_ON(sgl[0].sg_magic != SG_MAGIC);
> -	BUG_ON(!sg_is_last(ret));
> -#endif
> -	return ret;
> -}
> -
> -/**
>   * sg_chain - Chain two sglists together
>   * @prv:	First scatterlist
>   * @prv_nents:	Number of entries in prv
> @@ -223,47 +170,6 @@ static inline void sg_mark_end(struct scatterlist *sg)
>  }
>  
>  /**
> - * sg_init_table - Initialize SG table
> - * @sgl:	   The SG table
> - * @nents:	   Number of entries in table
> - *
> - * Notes:
> - *   If this is part of a chained sg table, sg_mark_end() should be
> - *   used only on the last table part.
> - *
> - **/
> -static inline void sg_init_table(struct scatterlist *sgl, unsigned int nents)
> -{
> -	memset(sgl, 0, sizeof(*sgl) * nents);
> -#ifdef CONFIG_DEBUG_SG
> -	{
> -		unsigned int i;
> -		for (i = 0; i < nents; i++)
> -			sgl[i].sg_magic = SG_MAGIC;
> -	}
> -#endif
> -	sg_mark_end(&sgl[nents - 1]);
> -}
> -
> -/**
> - * sg_init_one - Initialize a single entry sg list
> - * @sg:		 SG entry
> - * @buf:	 Virtual address for IO
> - * @buflen:	 IO length
> - *
> - * Notes:
> - *   This should not be used on a single entry that is part of a larger
> - *   table. Use sg_init_table() for that.
> - *
> - **/
> -static inline void sg_init_one(struct scatterlist *sg, const void *buf,
> -			       unsigned int buflen)
> -{
> -	sg_init_table(sg, 1);
> -	sg_set_buf(sg, buf, buflen);
> -}
> -
> -/**
>   * sg_phys - Return physical address of an sg entry
>   * @sg:	     SG entry
>   *
> @@ -293,4 +199,23 @@ static inline void *sg_virt(struct scatterlist *sg)
>  	return page_address(sg_page(sg)) + sg->offset;
>  }
>  
> +struct scatterlist *sg_next(struct scatterlist *);
I don't like that this became exported. I would prefer if
it could stay inline. if at all possible?

> +struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
> +void sg_init_table(struct scatterlist *, unsigned int);
> +void sg_init_one(struct scatterlist *, const void *, unsigned int);
> +
> +typedef struct scatterlist *(sg_alloc_fn)(unsigned int, gfp_t);
> +typedef void (sg_free_fn)(struct scatterlist *, unsigned int);
> +
> +void __sg_free_table(struct sg_table *, sg_free_fn *);
> +void sg_free_table(struct sg_table *);
> +int __sg_alloc_table(struct sg_table *, unsigned int, gfp_t, sg_alloc_fn *);
> +int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
> +
> +/*
> + * Maximum number of entries that will be allocated in one piece, if
> + * a list larger than this is required then chaining will be utilized.
> + */
> +#define SG_MAX_SINGLE_ALLOC		(PAGE_SIZE / sizeof(struct scatterlist))
Yes this is a well needed calculation.

Only now the SCSI part of the allocator is missing.
What is needed is the code a posted a while back that
automatically adjusts pools and sizes to this constant.
I will post that again soon.
(Note that this is a bug on current code since above is 256
in 32 bit code and scsi_lib is only ready for 128)

> +
>  #endif /* _LINUX_SCATTERLIST_H */
> diff --git a/lib/Makefile b/lib/Makefile
> index b6793ed..89841dc 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -6,7 +6,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
>  	 rbtree.o radix-tree.o dump_stack.o \
>  	 idr.o int_sqrt.o extable.o prio_tree.o \
>  	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
> -	 proportions.o prio_heap.o
> +	 proportions.o prio_heap.o scatterlist.o
>  
>  lib-$(CONFIG_MMU) += ioremap.o
>  lib-$(CONFIG_SMP) += cpumask.o
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> new file mode 100644
> index 0000000..02aaa27
> --- /dev/null
> +++ b/lib/scatterlist.c
> @@ -0,0 +1,281 @@
> +/*
> + * Copyright (C) 2007 Jens Axboe <jens.axboe@oracle.com>
> + *
> + * Scatterlist handling helpers.
> + *
> + * This source code is licensed under the GNU General Public License,
> + * Version 2. See the file COPYING for more details.
> + */
> +#include <linux/module.h>
> +#include <linux/scatterlist.h>
> +
> +/**
> + * sg_next - return the next scatterlist entry in a list
> + * @sg:		The current sg entry
> + *
> + * Description:
> + *   Usually the next entry will be @sg@ + 1, but if this sg element is part
> + *   of a chained scatterlist, it could jump to the start of a new
> + *   scatterlist array.
> + *
> + **/
> +struct scatterlist *sg_next(struct scatterlist *sg)
> +{
> +#ifdef CONFIG_DEBUG_SG
> +	BUG_ON(sg->sg_magic != SG_MAGIC);
> +#endif
> +	if (sg_is_last(sg))
> +		return NULL;
> +
> +	sg++;
> +	if (unlikely(sg_is_chain(sg)))
> +		sg = sg_chain_ptr(sg);
> +
> +	return sg;
> +}
> +EXPORT_SYMBOL(sg_next);
> +
> +/**
> + * sg_last - return the last scatterlist entry in a list
> + * @sgl:	First entry in the scatterlist
> + * @nents:	Number of entries in the scatterlist
> + *
> + * Description:
> + *   Should only be used casually, it (currently) scans the entire list
> + *   to get the last entry.
> + *
> + *   Note that the @sgl@ pointer passed in need not be the first one,
> + *   the important bit is that @nents@ denotes the number of entries that
> + *   exist from @sgl@.
> + *
> + **/
> +struct scatterlist *sg_last(struct scatterlist *sgl, unsigned int nents)
> +{
> +#ifndef ARCH_HAS_SG_CHAIN
> +	struct scatterlist *ret = &sgl[nents - 1];
> +#else
> +	struct scatterlist *sg, *ret = NULL;
> +	unsigned int i;
> +
> +	for_each_sg(sgl, sg, nents, i)
> +		ret = sg;
> +
> +#endif
> +#ifdef CONFIG_DEBUG_SG
> +	BUG_ON(sgl[0].sg_magic != SG_MAGIC);
> +	BUG_ON(!sg_is_last(ret));
> +#endif
> +	return ret;
> +}
> +EXPORT_SYMBOL(sg_last);
> +
> +/**
> + * sg_init_table - Initialize SG table
> + * @sgl:	   The SG table
> + * @nents:	   Number of entries in table
> + *
> + * Notes:
> + *   If this is part of a chained sg table, sg_mark_end() should be
> + *   used only on the last table part.
> + *
> + **/
> +void sg_init_table(struct scatterlist *sgl, unsigned int nents)
> +{
> +	memset(sgl, 0, sizeof(*sgl) * nents);
> +#ifdef CONFIG_DEBUG_SG
> +	{
> +		unsigned int i;
> +		for (i = 0; i < nents; i++)
> +			sgl[i].sg_magic = SG_MAGIC;
> +	}
> +#endif
> +	sg_mark_end(&sgl[nents - 1]);
> +}
> +EXPORT_SYMBOL(sg_init_table);
> +
> +/**
> + * sg_init_one - Initialize a single entry sg list
> + * @sg:		 SG entry
> + * @buf:	 Virtual address for IO
> + * @buflen:	 IO length
> + *
> + **/
> +void sg_init_one(struct scatterlist *sg, const void *buf, unsigned int buflen)
> +{
> +	sg_init_table(sg, 1);
> +	sg_set_buf(sg, buf, buflen);
> +}
> +EXPORT_SYMBOL(sg_init_one);
> +
> +/*
> + * The default behaviour of sg_alloc_table() is to use these kmalloc/kfree
> + * helpers.
> + */
> +static struct scatterlist *sg_kmalloc(unsigned int nents, gfp_t gfp_mask)
> +{
> +	if (nents == SG_MAX_SINGLE_ALLOC)
> +		return (struct scatterlist *) __get_free_page(gfp_mask);
> +	else
> +		return kmalloc(nents * sizeof(struct scatterlist), gfp_mask);
> +}
> +
> +static void sg_kfree(struct scatterlist *sg, unsigned int nents)
> +{
> +	if (nents == SG_MAX_SINGLE_ALLOC)
> +		free_page((unsigned long) sg);
> +	else
> +		kfree(sg);
> +}
> +
> +/**
> + * __sg_free_table - Free a previously mapped sg table
> + * @table:	The sg table header to use
> + * @free_fn:	Free function
> + *
> + *  Description:
> + *    Free an sg table previously allocated and setup with __sg_alloc_table().
> + *
> + **/
> +void __sg_free_table(struct sg_table *table, sg_free_fn *free_fn)
> +{
> +	struct scatterlist *sgl, *next;
> +
> +	if (unlikely(!table->sgl))
> +		return;
> +
> +	sgl = table->sgl;
> +	while (table->orig_nents) {
> +		unsigned int alloc_size = table->orig_nents;
> +		unsigned int sg_size;
> +
> +		/*
> +		 * If we have more than SG_MAX_SINGLE_ALLOC segments left,
> +		 * then assign 'next' to the sg table after the current one.
> +		 * sg_size is then one less than alloc size, since the last
> +		 * element is the chain pointer.
> +		 */
> +		if (alloc_size > SG_MAX_SINGLE_ALLOC) {
> +			next = sg_chain_ptr(&sgl[SG_MAX_SINGLE_ALLOC - 1]);
> +			alloc_size = SG_MAX_SINGLE_ALLOC;
> +			sg_size = alloc_size - 1;
> +		} else {
> +			sg_size = alloc_size;
> +			next = NULL;
> +		}
> +
> +		table->orig_nents -= sg_size;
> +		free_fn(sgl, alloc_size);
> +		sgl = next;
> +	}
> +
> +	table->sgl = NULL;
> +}
> +EXPORT_SYMBOL(__sg_free_table);
> +
> +/**
> + * sg_free_table - Free a previously allocated sg table
> + * @table:	The mapped sg table header
> + *
> + **/
> +void sg_free_table(struct sg_table *table)
> +{
> +	__sg_free_table(table, sg_kfree);
> +}
> +EXPORT_SYMBOL(sg_free_table);
> +
> +/**
> + * __sg_alloc_table - Allocate and initialize an sg table with given allocator
> + * @table:	The sg table header to use
> + * @nents:	Number of entries in sg list
> + * @gfp_mask:	GFP allocation mask
> + * @alloc_fn:	Allocator to use
> + *
> + * Notes:
> + *   If this function returns non-0 (eg failure), the caller must call
> + *   __sg_free_table() to cleanup any leftover allocations.
> + *
> + **/
> +int __sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask,
> +		     sg_alloc_fn *alloc_fn)
> +{
> +	struct scatterlist *sg, *prv;
> +	unsigned int left;
> +
> +#ifndef ARCH_HAS_SG_CHAIN
> +	BUG_ON(nents > SG_MAX_SINGLE_ALLOC);
> +#endif
> +
> +	memset(table, 0, sizeof(*table));
> +
> +	left = nents;
> +	prv = NULL;
> +	do {
> +		unsigned int sg_size, alloc_size = left;
> +
> +		if (alloc_size > SG_MAX_SINGLE_ALLOC) {
> +			alloc_size = SG_MAX_SINGLE_ALLOC;
> +			sg_size = alloc_size - 1;
> +		} else
> +			sg_size = alloc_size;
> +
> +		left -= sg_size;
> +
> +		sg = alloc_fn(alloc_size, gfp_mask);
> +		if (unlikely(!sg))
> +			return -ENOMEM;
> +
> +		sg_init_table(sg, alloc_size);
> +		table->nents = table->orig_nents += sg_size;
> +
> +		/*
> +		 * If this is the first mapping, assign the sg table header.
> +		 * If this is not the first mapping, chain previous part.
> +		 */
> +		if (prv)
> +			sg_chain(prv, SG_MAX_SINGLE_ALLOC, sg);
> +		else
> +			table->sgl = sg;
> +
> +		/*
> +		 * If no more entries after this one, mark the end
> +		 */
> +		if (!left)
> +			sg_mark_end(&sg[sg_size - 1]);
> +
> +		/*
> +		 * only really needed for mempool backed sg allocations (like
> +		 * SCSI), a possible improvement here would be to pass the
> +		 * table pointer into the allocator and let that clear these
> +		 * flags
> +		 */
> +		gfp_mask &= ~__GFP_WAIT;
> +		gfp_mask |= __GFP_HIGH;
> +		prv = sg;
> +	} while (left);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(__sg_alloc_table);
> +
> +/**
> + * sg_alloc_table - Allocate and initialize an sg table
> + * @table:	The sg table header to use
> + * @nents:	Number of entries in sg list
> + * @gfp_mask:	GFP allocation mask
> + *
> + *  Description:
> + *    Allocate and initialize an sg table. If @nents@ is larger than
> + *    SG_MAX_SINGLE_ALLOC a chained sg table will be setup.
> + *
> + **/
> +int sg_alloc_table(struct sg_table *table, unsigned int nents, gfp_t gfp_mask)
> +{
> +	int ret;
> +
> +	ret = __sg_alloc_table(table, nents, gfp_mask, sg_kmalloc);
> +	if (unlikely(ret))
> +		__sg_free_table(table, sg_kfree);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(sg_alloc_table);

Boaz
