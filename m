From: Timothy Pearson <tpearson@raptorengineeringinc.com>
Subject: Re: [PATCH] mpt2sas: Abort initialization if no memory I/O resources,
 detected
Date: Tue, 16 Jun 2015 13:49:20 -0500
Message-ID: <55806FB0.7070706@raptorengineeringinc.com>
References: <557B578D.50706@raptorengineeringinc.com> <55804E9C.2030802@raptorengineeringinc.com> <55805FE8.7000806@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pearsoncomputing.net ([192.119.205.242]:61829 "EHLO
	mail.pearsoncomputing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbbFPStX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2015 14:49:23 -0400
In-Reply-To: <55805FE8.7000806@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org

On 06/16/2015 12:42 PM, Joe Lawrence wrote:
> On 06/16/2015 12:28 PM, Timothy Pearson wrote:
>> On 06/12/2015 05:05 PM, Timothy Pearson wrote:
>>> The mpt2sas driver crashes if the BIOS does not set up at least one
>>> memory I/O resource. This failure can happen if the device is too
>>> slow to respond during POST and is missed by the BIOS, but Linux
>>> then detects the device later in the boot process.
>>>
>>> This patch aborts initialization and prints a warning if no memory I/O
>>> resources are found.
>>>
>>> Signed-off-by: Timothy Pearson<tpearson@raptorengineeringinc.com>
>>> Tested-by: Timothy Pearson<tpearson@raptorengineeringinc.com>
>>> ---
>>> drivers/scsi/mpt2sas/mpt2sas_base.c | 9 +++++++++
>>> 1 file changed, 9 insertions(+)
>>>
>>> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c
>>> b/drivers/scsi/mpt2sas/mpt2sas_base.c
>>> index 11248de..15c9504 100644
>>> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
>>> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
>>> @@ -6,6 +6,8 @@
>>> * Copyright (C) 2007-2014 LSI Corporation
>>> * Copyright (C) 20013-2014 Avago Technologies
>>> * (mailto: MPT-FusionLinux.pdl@avagotech.com)
>>> + * Copyright (C) 2015 Raptor Engineering
>>> + * (mailto: support@araptorengineeringinc.com)
>>> *
>>> * This program is free software; you can redistribute it and/or
>>> * modify it under the terms of the GNU General Public License
>>> @@ -1582,6 +1584,13 @@ mpt2sas_base_map_resources(struct MPT2SAS_ADAPTER
>>> *ioc)
>>> }
>>> }
>>>
>>> + if (ioc->chip == NULL) {
>>> + printk(MPT2SAS_ERR_FMT "unable to map "
>>> + "adapter memory (resource not found)!\n", ioc->name);
>>> + r = -EINVAL;
>>> + goto out_fail;
>>> + }
>>> +
>>> _base_mask_interrupts(ioc);
>>>
>>> r = _base_get_ioc_facts(ioc, CAN_SLEEP);
>>
>> Just following up on this patch as I have not yet received any response.
>>
>> Thanks!
>
> Hi Tim -- just curious, why was the similar check on ioc->chip just a
> few lines above the one added by the patch insufficient?
>
> That loop block sets memap_sz when it finds an IORESOURCE_MEM so that it
> only sets ioc->chip once.  I wonder if the fix might be simpler if the
> existing ioc->chip check relocated entirely to where you put it (maybe
> also pulling the entire error text onto one line for easier grepping).
>
> Regards,
>
> -- Joe

If there are no IORESOURCE_MEM resources allocated by the BIOS (i.e. if 
the BIOS does not run resource allocation on the mpt2sas device) then 
the check you are referring to is not executed, and the driver attempts 
to perform operations on a null ioc->chip pointer.

I can relocate the check if desired.

-- 
Timothy Pearson
Raptor Engineering
+1 (415) 727-8645
http://www.raptorengineeringinc.com
