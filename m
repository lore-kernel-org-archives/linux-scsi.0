From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 3/3] cxlflash: Virtual LUN support
Date: Thu, 30 Jul 2015 16:00:15 -0500
Message-ID: <55BA905F.5030001@linux.vnet.ibm.com>
References: <1437089217-52200-1-git-send-email-mrochs@linux.vnet.ibm.com> <55B13B1D.60804@linux.vnet.ibm.com> <20150729181309.Horde.6ofK41kNBwHDWXDMz0bHhw1@ltc.linux.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:44138 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbbG3U7w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2015 16:59:52 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Thu, 30 Jul 2015 14:59:52 -0600
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id D002619D8042
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2015 14:50:45 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t6UKxlpO56754404
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2015 13:59:47 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t6UKxjk0002545
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2015 14:59:47 -0600
In-Reply-To: <20150729181309.Horde.6ofK41kNBwHDWXDMz0bHhw1@ltc.linux.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com, mrochs@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com
Cc: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com

Wendy:

Thanks for taking the time to review this patch. Comments inline below.

- Manoj Kumar

On 7/29/2015 5:13 PM, wenxiong@linux.vnet.ibm.com wrote:
>> +    /* Update the free_curr_idx */
>> +    if (bit_pos == 63)
>> +        lun_info->free_curr_idx = bit_word + 1;
>
> Predefined Macros for 63 and 64?

Good point. We will add definitions to indicate that the bit_word is 8 
bytes.

>> +/**
>> + * ba_clone() - frees a block from the block allocator
>> + * @ba_lun:    Block allocator from which to allocate a block.
>> + * @to_free:    Block to free.
>> + *
>> + * Return: 0 on success, -1 on failure
>> + */
>
> More accurate description about ba_clone() function.

Good catch. Will correct in the next version of this patch (v3).

>> +    rc = ba_init(&blka->ba_lun);
>
> init_ba() and ba_init(). Probably one of them needs more accurate name.

Agreed. We will disambiguate in v3.

> free cmd_buf and sense_buf?

Same issue that Brian had pointed out. We had already corrected earlier. 
You will see it in our next submission.

>> +    mutex_unlock(&blka->mutex);
>> +
>
> Should hold the lock for lightwight sync?
>
>> +    /*
>> +     * The following sequence is prescribed in the SISlite spec
>> +     * for syncing up with the AFU when adding LXT entries.
>> +     */
>> +    dma_wmb(); /* Make LXT updates are visible */
>> +
>> +    rhte->lxt_start = lxt;
>> +    dma_wmb(); /* Make RHT entry's LXT table update visible */
>> +
>> +    rhte->lxt_cnt = my_new_size;
>> +    dma_wmb(); /* Make RHT entry's LXT table size update visible */
>> +
>> +    cxlflash_afu_sync(afu, ctxid, rhndl, AFU_LW_SYNC);
>> +

cxlflash_afu_sync() does ensure that only one of these SYNC commands is 
outstanding at one time. No additional serialization is required.

> Should hold the lock for lightwight sync?
>
>> +    cxlflash_afu_sync(afu, ctxid, rhndl, AFU_HW_SYNC);

Same issue as the one discussed above. No additional serialization 
should be necessary.

>> +        /* Setup the LUN table on the first call */
>> +        rc = init_lun_table(cfg, lli);
>> +        if (rc) {
>> +            pr_err("%s: call to init_lun_table failed rc=%d!\n",
>> +                   __func__, rc);
>> +            goto out;
>> +        }
>> +
>> +        rc = init_ba(lli);
>> +        if (rc) {
>> +            pr_err("%s: call to init_ba failed rc=%d!\n",
>> +                   __func__, rc);
>> +            rc = -ENOMEM;
>
> Do you need to remove the entry you create in init_lun_table() if
> init_ba() fails?

The LUN table is global to the adapter. If there are two threads 
creating two virtual LUNs concurrently, the first one inserts the LUN 
into the table. Cannot have that table entry be deleted, even if 
init_ba() fails, as the other thread could be using it.



