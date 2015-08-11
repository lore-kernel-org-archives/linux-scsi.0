From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 3/3] cxlflash: Virtual LUN support
Date: Tue, 11 Aug 2015 17:06:51 -0500
Message-ID: <55CA71FB.7090705@linux.vnet.ibm.com>
References: <1439226594-7944-1-git-send-email-mrochs@linux.vnet.ibm.com> <1439290473.28873.3.camel@neuling.org>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:46913 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbbHKWGx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2015 18:06:53 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Tue, 11 Aug 2015 16:06:53 -0600
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 8331419D8042
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 15:57:48 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7BM5tC950331734
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 15:05:55 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7BM6oE6015861
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 16:06:51 -0600
In-Reply-To: <1439290473.28873.3.camel@neuling.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Neuling <mikey@neuling.org>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com

Mikey: Thanks for your review. Comments inline below.

On 8/11/2015 5:54 AM, Michael Neuling wrote:
>
> I'm not keen on the numerous pr_err() in here.  I think it'll make the driver
> chatty especially with a badly behaving userspace.


Will look at all the pr_err() and limit them to errors that are 
indicative of a mis-behaving device, as opposed to a mis-behaving 
application.

>> -	.ioctl = cxlflash_ioctl,
 >
> Where are you hooking this in now?  This seems broken.

This was an error in splitting up the patch. Will correct in v5.

>>   	size = (MAX_RHT_PER_CONTEXT * sizeof(*ctxi->rht_lun));
>> +	size += (MAX_RHT_PER_CONTEXT * sizeof(*ctxi->rht_needs_ws));
>
> This needs to be cleaned up as per my comment on patch 2.  Make this a separate
> allocation.

Okay. Will split this into multiple allocations.


>> +	{sizeof(struct dk_cxlflash_clone), (sioctl)cxlflash_disk_clone},
>>   	{sizeof(struct dk_cxlflash_recover_afu), (sioctl)cxlflash_afu_recover},
>>   	{sizeof(struct dk_cxlflash_manage_lun), (sioctl)cxlflash_manage_lun},
>
> Does this actually work if we don't have this patch?  If the IOCTLS are sparse
> (like with only patch 2/3) won't this table be broken?

Agreed. Look for these ioctls being re-ordered in v5 to avoid sparseness 
in the individual patches.

>>   		switch (cmd) {
>> +		case DK_CXLFLASH_USER_VIRTUAL:
>> +		case DK_CXLFLASH_VLUN_RESIZE:
>>   		case DK_CXLFLASH_RELEASE:
>> +		case DK_CXLFLASH_CLONE:
>>   			pr_err("%s: %s not supported for lun_mode=%d\n",
>>   			       __func__, decode_ioctl(cmd), afu->internal_lun);
>>   			rc = -EINVAL;
>
> If someone creates an internal lun and then does this, then we are going to get
> a bunch of errors on the console.  I don't think that should happen.  Just
> return it to the caller.

Will remove the pr_err().


> Be good to do some clear sanity check the "struct dk_cxlflash_resize *resize"
> here.  It's passed from userspace but then gets propogated to a bunch of other
> things here like nsectors, get_context etc who will all now be responsible for
> handling any dodgy data passed in.
>
> Same with all the other ioctl calls.  Sanity check the parameters ASAP.  Don't
> propagate potentially dodgy values all over the code base.
>

The ioctls have a standard header structure, with version etc. that are 
sanity checked before we get here. The other fields are sanity checked 
where they are used, i.e. in get_context().

>> +	/*
>> +	 * The requested size (req_size) is always assumed to be in 4k blocks,
>> +	 * so we have to convert it here from 4k to chunk size.
>> +	 */
>> +	nsectors = (resize->req_size * CXLFLASH_BLOCK_SIZE) / gli->blk_len;
>> +	new_size = DIV_ROUND_UP(nsectors, MC_CHUNK_SIZE);
>
> Like here. resize->req_size => new_size => grow_lxt() now grow_lxt() need to
> sanity check new_size.


This is a best effort allocator. If an allocation request y, cannot be 
satisfied because of insufficient space in the LUN (i.e. only x amount 
of space is available), then the allocator returns the remaining space 
(x). This best effort allocation mechanism avoids having to sanity check 
the size parameter.


>> +	struct dk_cxlflash_uvirtual *virt = (struct dk_cxlflash_uvirtual *)arg;
>
> Again, this should be sanity checked.

Same as comment above.

>> +	/* Resize even if requested size is 0 */
>> +	marshal_virt_to_resize(virt, &resize);
>
> Virt has not been sanity checked.  So now resize can contain bad data.
>
>
>> +	resize.rsrc_handle = rsrc_handle;

Same as above. As mentioned earlier, the size is immaterial. The rest of 
the parameters are set here (rsrc_handle).


>> +	dma_wmb(); /* Make RHT entry's LXT table size update visible */
>
> Nice documentation here for the memory barriers!

Thank you!

>> +#define LXT_LUNIDX_SHIFT  8	/* LXT entry, shift for LUN index */
>> +#define LXT_PERM_SHIFT    4	/* LXT entry, shift for permission bits */
>
> What is LXT?

LXT = lun translation table. There is one LXT entry per set of 
contiguous blocks for a virtual LUN (known both to the host and to the 
AFU). Will clarify this with inline comments.

>> +
>> +#define BITS_PER_LONG     64
>
> Please use #include <asm/bitsperlong.h>

Will re-use this, instead of creating our own definition.

>
>> +#define BPL               BITS_PER_LONG
>
> Don't redefine this.  Make it harder for others to read.  No one wants to learn
> your TLAs.

Same as above.

>> +	void *ba_lun_handle;
>
> ba_lun_handle seems to be commonly cast to a struct ba_lun_info *.  Can it just
> be a pointer to that?

Good catch. Will change in v5.


