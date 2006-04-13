From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] dc395x: dynamically map scatter-gather for PIO (take 2)
Date: Thu, 13 Apr 2006 13:29:32 -0700
Message-ID: <20060413132932.31871824.rdunlap@xenotime.net>
References: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:32703 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S964976AbWDMU1G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 16:27:06 -0400
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2006 13:27:05 -0700
In-Reply-To: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, Sebastian@schnapsleichen.de, roubert@df.lth.se, lenehan@twibble.org

On Sun, 2 Apr 2006 21:57:43 +0200 (CEST) Guennadi Liakhovetski wrote:

> Hello all,
> 
> This time I really mean it:-)

Hi Guennadi,
James pointed me at this patch since I have aha152x also having
problems with using page_address() while trying to do PIO.
I see a NULL pointer during a data-out phase.  I'll attempt
to use the kmap_atomic() support that you have added in the
aha152x driver.

I have a few small patch comments below.

> diff -u a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> --- a/drivers/scsi/scsi_lib.c	30 Mar 2006 19:19:08 -0000
> +++ b/drivers/scsi/scsi_lib.c	2 Apr 2006 19:13:12 -0000
> @@ -2307,3 +2307,60 @@
>  	return 1;
>  }
>  EXPORT_SYMBOL_GPL(scsi_execute_in_process_context);
> +
> +/**
> + * scsi_kmap_atomic_sg - find and atomically map an sg-elemnt

s/elemnt/element/

> + * @sg:		scatter-gather list
> + * @sg_count:	number of segments in sg
> + * @offset:	offset in bytes into sg, on return offset into the mapped area
> + * @len:	bytes to map, on return number of bytes mapped
> + *
> + * Returns virtual address of the start of the mapped page
> + */
> +void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
> +			  size_t *offset, size_t *len)
> +{
> +	int i;
> +	size_t sg_len = 0, len_complete = 0;
> +	struct page *page;
> +
> +	for (i = 0; i < sg_count; i++) {
> +		len_complete = sg_len; /* Complete sg-entries */
> +		sg_len += sg[i].length;
> +		if (sg_len > *offset)
> +			break;
> +	}
> +
> +	if (i == sg_count) {
> +		printk(KERN_ERR "%s: Bytes in sg: %u, requested offset %u, elements %d\n",
> +		       __FUNCTION__, sg_len, *offset, sg_count);
> +		WARN_ON(1);
> +		return NULL;
> +	}
> +
> +	/* Offset starting from the beginning of first page in this sg-entry */
> +	*offset = *offset - len_complete + sg[i].offset;
> +
> +	/* Assumption: contiguous pages can be accessed as "page + i" */
> +	page = nth_page(sg[i].page, (*offset >> PAGE_SHIFT));
> +	*offset &= ~PAGE_MASK;
> +
> +	/* Bytes in this sg-entry from *offset to the end of the page */
> +	sg_len = PAGE_SIZE - *offset;
> +	if (*len > sg_len)
> +		*len = sg_len;
> +
> +	return kmap_atomic(page, KM_BIO_SRC_IRQ);
> +}
> +EXPORT_SYMBOL(scsi_kmap_atomic_sg);
> +
> +/**
> + * scsi_kunmap_atomic_sg - atomically unmap a virtual address, previously
> + *			   mapped with scsi_kmap_atomic_sg

First line of function kernel-doc must be just one line long.  Sorry.  :(
You can add more descriptive text after the parameter(s) plus one
blank line if you want to do it that way.

> + * @virt:	virtual address to be unmapped
> + */
> +void scsi_kunmap_atomic_sg(void *virt)
> +{
> +	kunmap_atomic(virt, KM_BIO_SRC_IRQ);
> +}
> +EXPORT_SYMBOL(scsi_kunmap_atomic_sg);


Thanks,
---
~Randy
