From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 00/10] sg buffer copy helper functions
Date: Thu, 13 Mar 2008 09:03:26 +0900
Message-ID: <20080313090258Z.tomof@acm.org>
References: <20080312092856P.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.44L0.0803121202150.4595-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0803121202150.4595-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: fujita.tomonori@lab.ntt.co.jp, tomof@acm.org, bharrosh@panasas.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dougg@torque.net, Geert.Uytterhoeven@sonycom.com, tony.luck@intel.com, Mark_Salyzyn@adaptec.com, ed.lin@promise.com, linuxraid@amcc.com, linux-usb@vger.kernel.orgfujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Wed, 12 Mar 2008 12:04:26 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 12 Mar 2008, FUJITA Tomonori wrote:
> 
> > It enables us to simplify usb_stor_access_xfer_buf like this, I think
> > (it's not tested).
> > 
> > diff --git a/drivers/usb/storage/protocol.c b/drivers/usb/storage/protocol.c
> > index b9b8ede..0992809 100644
> > --- a/drivers/usb/storage/protocol.c
> > +++ b/drivers/usb/storage/protocol.c
> > @@ -156,70 +156,11 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
> >  	unsigned int buflen, struct scsi_cmnd *srb, struct scatterlist **sgptr,
> >  	unsigned int *offset, enum xfer_buf_dir dir)
> >  {
> > -	unsigned int cnt;
> > -	struct scatterlist *sg = *sgptr;
> > -
> > -	/* We have to go through the list one entry
> > -	 * at a time.  Each s-g entry contains some number of pages, and
> > -	 * each page has to be kmap()'ed separately.  If the page is already
> > -	 * in kernel-addressable memory then kmap() will return its address.
> > -	 * If the page is not directly accessible -- such as a user buffer
> > -	 * located in high memory -- then kmap() will map it to a temporary
> > -	 * position in the kernel's virtual address space.
> > -	 */
> > -
> > -	if (!sg)
> > -		sg = scsi_sglist(srb);
> > +	if (!*sgptr)
> > +		*sgptr = scsi_sglist(srb);
> >  
> > -	/* This loop handles a single s-g list entry, which may
> > -	 * include multiple pages.  Find the initial page structure
> > -	 * and the starting offset within the page, and update
> > -	 * the *offset and **sgptr values for the next loop.
> > -	 */
> > -	cnt = 0;
> > -	while (cnt < buflen && sg) {
> > -		struct page *page = sg_page(sg) +
> > -				((sg->offset + *offset) >> PAGE_SHIFT);
> > -		unsigned int poff = (sg->offset + *offset) & (PAGE_SIZE-1);
> > -		unsigned int sglen = sg->length - *offset;
> > -
> > -		if (sglen > buflen - cnt) {
> > -
> > -			/* Transfer ends within this s-g entry */
> > -			sglen = buflen - cnt;
> > -			*offset += sglen;
> > -		} else {
> > -
> > -			/* Transfer continues to next s-g entry */
> > -			*offset = 0;
> > -			sg = sg_next(sg);
> > -		}
> > -
> > -		/* Transfer the data for all the pages in this
> > -			* s-g entry.  For each page: call kmap(), do the
> > -			* transfer, and call kunmap() immediately after. */
> > -		while (sglen > 0) {
> > -			unsigned int plen = min(sglen, (unsigned int)
> > -					PAGE_SIZE - poff);
> > -			unsigned char *ptr = kmap(page);
> > -
> > -			if (dir == TO_XFER_BUF)
> > -				memcpy(ptr + poff, buffer + cnt, plen);
> > -			else
> > -				memcpy(buffer + cnt, ptr + poff, plen);
> > -			kunmap(page);
> > -
> > -			/* Start at the beginning of the next page */
> > -			poff = 0;
> > -			++page;
> > -			cnt += plen;
> > -			sglen -= plen;
> > -		}
> > -	}
> > -	*sgptr = sg;
> > -
> > -	/* Return the amount actually transferred */
> > -	return cnt;
> > +	return sg_copy_buffer(sgptr, scsi_sg_count(srb),
> > +			      offset, buffer, buflen, dir != TO_XFER_BUF);
> >  }
> 
> It's a big simplification!
> 
> There are two problems.  One is the types of the arguments and return 
> value.

They should be ok with the updated patch.


> The other is that local interrupts need to be disabled.

Can you disable local interrupts here?

Basically, the APIs are used in queuecommand.
