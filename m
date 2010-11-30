From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patch] scsi/osd: checking NULL instead of ERR_PTR()
Date: Tue, 30 Nov 2010 12:22:47 +0200
Message-ID: <4CF4D077.8070004@panasas.com>
References: <20101112043146.GC3533@bicker> <4CDFE6A9.10704@panasas.com> <4CE8F510.3090801@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:4189 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab0K3KWu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2010 05:22:50 -0500
In-Reply-To: <4CE8F510.3090801@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Dan Carpenter <error27@gmail.com>, Benny Halevy <bhalevy@panasas.com>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On 11/21/2010 12:31 PM, Boaz Harrosh wrote:
> On 11/14/2010 03:39 PM, Boaz Harrosh wrote:
>> On 11/12/2010 06:31 AM, Dan Carpenter wrote:
>>> bio_map_kern() returns ERR_PTRs on failure and never returns NULL.
>>>
>>> Signed-off-by: Dan Carpenter <error27@gmail.com>
>>>
>>
>> Acked-by: Boaz Harrosh <bharrosh@panasas.com>
>>
> 
> James! Please submit this patch for scsi-rc-fixes. It is an important
> fix for code that went into this merge window.
> 
> Thanks
> Boaz
> 

James, ping?

>>> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
>>> index 0433ea6..b798919 100644
>>> --- a/drivers/scsi/osd/osd_initiator.c
>>> +++ b/drivers/scsi/osd/osd_initiator.c
>>> @@ -951,8 +951,8 @@ static int _osd_req_finalize_cdb_cont(struct osd_request *or, const u8 *cap_key)
>>>  	/* create a bio for continuation segment */
>>>  	bio = bio_map_kern(req_q, or->cdb_cont.buff, or->cdb_cont.total_bytes,
>>>  			   GFP_KERNEL);
>>> -	if (unlikely(!bio))
>>> -		return -ENOMEM;
>>> +	if (unlikely(IS_ERR(bio)))
>>> +		return PTR_ERR(bio);
>>>  
>>>  	bio->bi_rw |= REQ_WRITE;
>>>  
>>
>> Wahoo, good catch, thanks! This is new code in 2.6.37-rc1. It should be pushed
>> for current Kernel.
>>
>> James: please apply to scsi-rc-fixes for the next round of fixes?
>>
>> Thanks
>> Boaz
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

