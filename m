From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 00/10] sg buffer copy helper functions
Date: Wed, 12 Mar 2008 12:04:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0803121202150.4595-100000@iolanthe.rowland.org>
References: <20080312092856P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52420 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751596AbYCLQE0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2008 12:04:26 -0400
In-Reply-To: <20080312092856P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tomof@acm.org, bharrosh@panasas.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dougg@torque.net, Geert.Uytterhoeven@sonycom.com, tony.luck@intel.com, Mark_Salyzyn@adaptec.com, ed.lin@promise.com, linuxraid@amcc.com, linux-usb@vger.kernel.org

On Wed, 12 Mar 2008, FUJITA Tomonori wrote:

> It enables us to simplify usb_stor_access_xfer_buf like this, I think
> (it's not tested).
> 
> diff --git a/drivers/usb/storage/protocol.c b/drivers/usb/storage/protocol.c
> index b9b8ede..0992809 100644
> --- a/drivers/usb/storage/protocol.c
> +++ b/drivers/usb/storage/protocol.c
> @@ -156,70 +156,11 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
>  	unsigned int buflen, struct scsi_cmnd *srb, struct scatterlist **sgptr,
>  	unsigned int *offset, enum xfer_buf_dir dir)
>  {
> -	unsigned int cnt;
> -	struct scatterlist *sg = *sgptr;
> -
> -	/* We have to go through the list one entry
> -	 * at a time.  Each s-g entry contains some number of pages, and
> -	 * each page has to be kmap()'ed separately.  If the page is already
> -	 * in kernel-addressable memory then kmap() will return its address.
> -	 * If the page is not directly accessible -- such as a user buffer
> -	 * located in high memory -- then kmap() will map it to a temporary
> -	 * position in the kernel's virtual address space.
> -	 */
> -
> -	if (!sg)
> -		sg = scsi_sglist(srb);
> +	if (!*sgptr)
> +		*sgptr = scsi_sglist(srb);
>  
> -	/* This loop handles a single s-g list entry, which may
> -	 * include multiple pages.  Find the initial page structure
> -	 * and the starting offset within the page, and update
> -	 * the *offset and **sgptr values for the next loop.
> -	 */
> -	cnt = 0;
> -	while (cnt < buflen && sg) {
> -		struct page *page = sg_page(sg) +
> -				((sg->offset + *offset) >> PAGE_SHIFT);
> -		unsigned int poff = (sg->offset + *offset) & (PAGE_SIZE-1);
> -		unsigned int sglen = sg->length - *offset;
> -
> -		if (sglen > buflen - cnt) {
> -
> -			/* Transfer ends within this s-g entry */
> -			sglen = buflen - cnt;
> -			*offset += sglen;
> -		} else {
> -
> -			/* Transfer continues to next s-g entry */
> -			*offset = 0;
> -			sg = sg_next(sg);
> -		}
> -
> -		/* Transfer the data for all the pages in this
> -			* s-g entry.  For each page: call kmap(), do the
> -			* transfer, and call kunmap() immediately after. */
> -		while (sglen > 0) {
> -			unsigned int plen = min(sglen, (unsigned int)
> -					PAGE_SIZE - poff);
> -			unsigned char *ptr = kmap(page);
> -
> -			if (dir == TO_XFER_BUF)
> -				memcpy(ptr + poff, buffer + cnt, plen);
> -			else
> -				memcpy(buffer + cnt, ptr + poff, plen);
> -			kunmap(page);
> -
> -			/* Start at the beginning of the next page */
> -			poff = 0;
> -			++page;
> -			cnt += plen;
> -			sglen -= plen;
> -		}
> -	}
> -	*sgptr = sg;
> -
> -	/* Return the amount actually transferred */
> -	return cnt;
> +	return sg_copy_buffer(sgptr, scsi_sg_count(srb),
> +			      offset, buffer, buflen, dir != TO_XFER_BUF);
>  }

It's a big simplification!

There are two problems.  One is the types of the arguments and return 
value.  The other is that local interrupts need to be disabled.

Alan Stern

