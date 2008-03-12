From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 00/10] sg buffer copy helper functions
Date: Wed, 12 Mar 2008 18:26:04 +0200
Message-ID: <47D8041C.5070400@panasas.com>
References: <Pine.LNX.4.44L0.0803121132210.4595-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:44538 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbYCLQ2Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2008 12:28:25 -0400
In-Reply-To: <Pine.LNX.4.44L0.0803121132210.4595-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dougg@torque.net, Geert.Uytterhoeven@sonycom.com, tony.luck@intel.com, Mark_Salyzyn@adaptec.com, ed.lin@promise.com, linuxraid@amcc.com, linux-usb@vger.kernel.org

On Wed, Mar 12 2008 at 18:01 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 12 Mar 2008, FUJITA Tomonori wrote:
> 
>> I fixed some minor issues (comments, warning, etc) and I've uploaded
>> the patchset:
> 
>> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git 
>> sg-copy
> 
> Sorry, I don't see it there yet in the gitweb interface.  Here are my
> comments on the parts you posted earlier.
> 
>> How about this?
>>
>> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
>> index a3d567a..8951e3c 100644
>> --- a/include/linux/scatterlist.h
>> +++ b/include/linux/scatterlist.h
>> @@ -213,6 +213,13 @@ int __sg_alloc_table(struct sg_table *, unsigned int, unsigned int, gfp_t,
>>  		     sg_alloc_fn *);
>>  int sg_alloc_table(struct sg_table *, unsigned int, gfp_t);
>>  
>> +int sg_copy_buffer(struct scatterlist **sgl, unsigned int nents,
>> +		   unsigned long *offset, void *buf, int buflen, int to_buffer);
>> +int sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
>> +			void *buf, int buflen);
>> +int sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
>> +		      void *buf, int buflen);
> 
> These routines probably should not return int.  Maybe unsigned int or 
> unsigned long.  If you really want to be picky, it should be size_t.
> 
> Same goes for the type of the buflen parameter.
> 
>> +int sg_copy_buffer(struct scatterlist **sgl, unsigned int nents,
>> +		   unsigned long *offset, void *buf, int buflen, int to_buffer)
>> +{
>> +	struct scatterlist *sg;
>> +	unsigned long buf_off = 0;
> 
> The type of buf_off should be the same as the function's return type.
> 
>> +	int i;
>> +
>> +	WARN_ON(!irqs_disabled());
>> +
>> +	for_each_sg(*sgl, sg, nents, i) {
> 
> Will there be a problem in subsequent calls if *sgl has been
> incremented but nents hasn't been changed?  Maybe nents needs to be a 
> pointer also.
> 
>> +		struct page *page;
>> +		int n = 0;
>> +		unsigned int sg_off = sg->offset;
>> +		unsigned int sg_copy = sg->length;
>> +
>> +		BUG_ON(*offset > sg_copy);
>> +
>> +		if (!buflen)
>> +			break;
>> +
>> +		sg_off += *offset;
>> +		n = sg_off >> PAGE_SHIFT;
>> +		sg_off &= ~PAGE_MASK;
>> +		sg_copy -= *offset;
>> +
>> +		if (sg_copy > buflen) {
>> +			sg_copy = buflen;
>> +			*offset += sg_copy;
>> +		} else
>> +			*offset = 0;
>> +
>> +		buflen -= sg_copy;
>> +
>> +		while (sg_copy > 0) {
>> +			unsigned int page_copy;
>> +			void *p;
>> +
>> +			page_copy = PAGE_SIZE - sg_off;
>> +			if (page_copy > sg_copy)
>> +				page_copy = sg_copy;
>> +
>> +			page = nth_page(sg_page(sg), n);
>> +			p = kmap_atomic(page, KM_BIO_SRC_IRQ);
>> +
>> +			if (to_buffer)
>> +				memcpy(buf + buf_off, p + sg_off, page_copy);
>> +			else {
>> +				memcpy(p + sg_off, buf + buf_off, page_copy);
>> +				flush_kernel_dcache_page(page);
>> +			}
>> +
>> +			kunmap_atomic(p, KM_BIO_SRC_IRQ);
>> +
>> +			buf_off += page_copy;
>> +			sg_off += page_copy;
>> +			if (sg_off == PAGE_SIZE) {
>> +				sg_off = 0;
>> +				n++;
>> +			}
>> +			sg_copy -= page_copy;
>> +		}
> 
> Here you need to add:
> 
> 		if (*offset)
> 			break;
> 
> Otherwise *sgl will be incremented wrongly if the transfer ends in the
> middle of an sg entry.
> 
>> +	}
>> +
>> +	*sgl = sg;
>> +
>> +	return buf_off;
>> +}
> 
>> +
>> +/**
>> + * sg_copy_from_buffer - Copy from liner buffer to an SG table
> 
> s/liner/linear/
> 
>> + * @sgl:		 The SG table
>> + * @nents:		 Number of SG entries
>> + * @buf:		 Where to copy from
>> + * @buflen:		 The number of bytes to copy
>> + *
>> + * Returns the number of copied byte.
> 
> s/byte/bytes/
> 
>> + *
>> + **/
>> +int sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
>> +			void *buf, int buflen)
>> +{
>> +	struct scatterlist *s = sgl;
>> +	unsigned long offset = 0;
>> +
>> +	return sg_copy_buffer(&s, nents, &offset, buf, buflen, 0);
> 
> You don't have to copy sgl into s.  Just pass &sgl directly.
> 
>> +}
>> +EXPORT_SYMBOL(sg_copy_from_buffer);
>> +
>> +/**
>> + * sg_copy_to_buffer - Copy from an SG table to liner buffer
> 
> s/liner/linear/
> 
>> + * @sgl:		 The SG table
>> + * @nents:		 Number of SG entries
>> + * @buf:		 Where to copy to
>> + * @buflen:		 The number of bytes to copy
>> + *
>> + * Returns the number of copied byte.
> 
> s/byte/bytes/
> 
>> + *
>> + **/
>> +int sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
>> +		      void *buf, int buflen)
>> +{
>> +	struct scatterlist *s = sgl;
>> +	unsigned long offset = 0;
>> +
>> +	return sg_copy_buffer(&s, nents, &offset, buf, buflen, 1);
> 
> Same thing here.
> 
>> +}
>> +EXPORT_SYMBOL(sg_copy_to_buffer);
> 
> On the whole it looks good.
> 
> Alan Stern
> 
> 

I agree with all your comments. I think I liked your original Idea of
putting all the sg_copy_buffer() parameters in a structure that is then
is easier for resubmission and future changes. It will not change TOMO's
patchset because the two wrappers stay the same and only USB is affected.

TOMO
could we not do better then that *disable interrupts* thing? I think it is
fair to say that we disallow the memory pointed-to by the sglist to share
cache lines with other concurrent IO. Is this not true already?

I mean, come on, a pure memory access like that, we must be able to do better?
No? 

Drivers that use this API can make sure to set their masks HW_CACHE_ALIGNED
and the block will bounce the buffers for them to make sure concurrent cache-line 
IO will not happen. No?

Thanks
Boaz
