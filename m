From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/5] make sg always send scatterlists take 2
Date: Fri, 16 Sep 2005 10:18:04 -0500
Message-ID: <432AE22C.4060702@cs.wisc.edu>
References: <1126845593.9276.43.camel@max> <20050916111005.GA27045@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:26317 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1161181AbVIPRSP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2005 13:18:15 -0400
In-Reply-To: <20050916111005.GA27045@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Sep 15, 2005 at 11:39:53PM -0500, Mike Christie wrote:
> 
>>Convert sg to always use scatterlists.
>>
>>I made the scsi api take scatterlists now so HighMem is supported
>>for DIO.
> 
> 
> Looks pretty nice.  There's lots of page_address() calls left, two

yeah I was going to change them to kmaps for Doug and Kai, but thought I 
should do that in another patch in case I mees up. I thought in the 
paths they use page_address are the indirect or mmap paths which 
allocate the pages from GFP_KERNEL or GFP_DMA.

> of them can be removed trivially and two were used to reimplement
> a rather odd kzalloc.  Also switch ->buffer to be a struct scatterlist *

Ok thanks. When I respin my patches, I will include this and I will send 
a kmap patch to allow the ULDs to use HighMem in the non-DIO paths.

> 
> 
> Index: linux-2.6/drivers/scsi/sg.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/sg.c	2005-09-16 11:15:43.000000000 +0200
> +++ linux-2.6/drivers/scsi/sg.c	2005-09-16 11:23:43.000000000 +0200
> @@ -120,7 +120,7 @@
>  	unsigned short sglist_len; /* size of malloc'd scatter-gather list ++ */
>  	unsigned bufflen;	/* Size of (aggregate) data buffer */
>  	unsigned b_malloc_len;	/* actual len malloc'ed in buffer */
> -	void *buffer;		/* scatter list */
> +	struct scatterlist *buffer;/* scatter list */
>  	char dio_in_use;	/* 0->indirect IO (or mmap), 1->dio */
>  	unsigned char cmd_opcode; /* first byte of command */
>  } Sg_scatter_hold;
> @@ -1148,7 +1148,6 @@
>  sg_rb_correct4mmap(Sg_scatter_hold * rsv_schp, int startFinish)
>  {
>  	struct scatterlist *sg = rsv_schp->buffer;
> -	void *page_ptr;
>  	struct page *page;
>  	int k, m;
>  
> @@ -1158,7 +1157,6 @@
>  	for (k = 0; k < rsv_schp->k_use_sg; ++k, ++sg) {
>  		for (m = PAGE_SIZE; m < sg->length; m += PAGE_SIZE) {
>  			page = sg->page;
> -			page_ptr = page_address(page) + m;
>  			if (startFinish)
>  				get_page(page);
>  			else {
> @@ -1174,7 +1172,6 @@
>  {
>  	Sg_fd *sfp;
>  	struct page *page = NOPAGE_SIGBUS;
> -	void *page_ptr = NULL;
>  	unsigned long offset, len, sa;
>  	Sg_scatter_hold *rsv_schp;
>  	struct scatterlist *sg;
> @@ -1196,7 +1193,6 @@
>  		len = (len < sg->length) ? len : sg->length;
>  		if (offset < len) {
>  			page = sg->page;
> -			page_ptr = page_address(page) + offset;
>  			get_page(page);	/* increment page count */
>  			break;
>  		}
> @@ -1689,26 +1685,22 @@
>  static int
>  sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
>  {
> -	int ret_sz;
> -	int elem_sz = sizeof (struct scatterlist);
> -	int sg_bufflen = tablesize * elem_sz;
> -	int mx_sc_elems = tablesize;
> +	int sg_bufflen = tablesize * sizeof(struct scatterlist);
> +	unsigned int gfp_flags = GFP_ATOMIC | __GFP_NOWARN;
>  
>  	/*
>  	 * TODO: test without low_dma, we should not need it since
>  	 * the block layer will bounce the buffer for us
> +	 *
> +	 * XXX(hch): we shouldn't need GFP_DMA for the actual S/G list.
>  	 */
> -	schp->buffer = page_address(sg_page_malloc(sg_bufflen, sfp->low_dma,
> -				    &ret_sz));
> +	if (sfp->low_dma)
> +		 gfp_flags |= GFP_DMA;
> +	schp->buffer = kzalloc(sg_bufflen, gfp_flags);
>  	if (!schp->buffer)
>  		return -ENOMEM;
> -	else if (ret_sz != sg_bufflen) {
> -		sg_bufflen = ret_sz;
> -		mx_sc_elems = sg_bufflen / elem_sz;
> -	}
>  	schp->sglist_len = sg_bufflen;
> -	memset(schp->buffer, 0, sg_bufflen);
> -	return mx_sc_elems;	/* number of scat_gath elements allocated */
> +	return tablesize;	/* number of scat_gath elements allocated */
>  }
>  
>  #ifdef SG_ALLOW_DIO_CODE
> @@ -2036,7 +2028,7 @@
>  				sg_page_free(sg->page, sg->length);
>  			}
>  		}
> -		sg_page_free(virt_to_page(schp->buffer), schp->sglist_len);
> +		kfree(schp->buffer);
>  	}
>  	memset(schp, 0, sizeof (*schp));
>  }
> @@ -2353,16 +2345,13 @@
>  static Sg_fd *
>  sg_add_sfp(Sg_device * sdp, int dev)
>  {
> -	struct page *p;
>  	Sg_fd *sfp;
>  	unsigned long iflags;
>  
> -	p = sg_page_malloc(sizeof (Sg_fd), 0, NULL);
> -	if (!p)
> +	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
> +	if (!sfp)
>  		return NULL;
>  
> -	sfp = (Sg_fd *) page_address(p);
> -	memset(sfp, 0, sizeof (Sg_fd));
>  	init_waitqueue_head(&sfp->read_wait);
>  	rwlock_init(&sfp->rq_list_lock);
>  
> @@ -2419,7 +2408,7 @@
>  	}
>  	sfp->parentdp = NULL;
>  	SCSI_LOG_TIMEOUT(6, printk("__sg_remove_sfp:    sfp=0x%p\n", sfp));
> -	sg_page_free(virt_to_page(sfp), sizeof (Sg_fd));
> +	kfree(sfp);
>  }
>  
>  /* Returns 0 in normal case, 1 when detached and sdp object removed */

