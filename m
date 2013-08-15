From: "Akinobu Mita" <mita@fixstars.com>
Subject: Re: [PATCH 10/10] ufs: fix DMA mask setting
Date: Thu, 15 Aug 2013 23:48:20 +0900
Message-ID: <25b5bfcac39abc7b9cc6f1cbccf53e7f.squirrel@webmail.fixstars.com>
References: <1372266575-3468-1-git-send-email-santoshsy@gmail.com>
    <1372266575-3468-11-git-send-email-santoshsy@gmail.com>
    <1372451836.1884.23.camel@dabdike>
    <CAD7r0yBAW2XWCkO_38u3GaUaL=kRFC84nqBXUoWLjaTRvUJ+ag@mail.gmail.com>
    <5205D8FA.8030605@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo.fixstars.hdemail.jp ([176.34.54.138]:53271 "EHLO
	mo.fixstars.hdemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087Ab3HOOwF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Aug 2013 10:52:05 -0400
In-Reply-To: <5205D8FA.8030605@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Akinobu Mita <mita@fixstars.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Santosh Y <santoshsy@gmail.com>, linux-scsi@vger.kernel.org, vinholikatti@gmail.com

> On 6/29/2013 11:10 AM, Akinobu Mita wrote:
>> 2013/6/29 James Bottomley <James.Bottomley@hansenpartnership.com>:
>>> On Wed, 2013-06-26 at 22:39 +0530, Santosh Y wrote:
>>>> index 19618c6..431ddb2 100644
>>>> --- a/drivers/scsi/ufs/ufshcd.c
>>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>>> @@ -1711,6 +1711,25 @@ void ufshcd_remove(struct ufs_hba *hba)
>>>>   EXPORT_SYMBOL_GPL(ufshcd_remove);
>>>>
>>>>   /**
>>>> + * ufshcd_set_dma_mask - Set dma mask based on the controller
>>>> + *                    addressing capability
>>>> + * @hba: per adapter instance
>>>> + *
>>>> + * Returns 0 for success, non-zero for failure
>>>> + */
>>>> +static int ufshcd_set_dma_mask(struct ufs_hba *hba)
>>>> +{
>>>> +     if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT) {
>>>> +             if (!dma_set_mask(hba->dev, DMA_BIT_MASK(64)) &&
>>>> +                 !dma_set_coherent_mask(hba->dev, DMA_BIT_MASK(64)))
>>>> +                     return 0;
>>>> +     }
>>>> +     dma_set_mask(hba->dev, DMA_BIT_MASK(32));
>>>> +
>>>> +     return dma_set_coherent_mask(hba->dev, DMA_BIT_MASK(32));
>>>> +}
>>>
>>> This isn't right per the API spec.  The guarantee is that if
>>> dma_set_mask() succeeds then dma_set_coherent_mask of the same mask
>>> will
>>> succeed,  so this should read
>>>
>>>          int err;
>>>
>>>          if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT) {
>>>                  if (!dma_set_mask(hba->dev, DMA_BIT_MASK(64))) {
>>>                          dma_set_coherent_mask(hba->dev,
>>> DMA_BIT_MASK(64)))
>>>                          return 0;
>>>                  }
>>>          }
>>>          err = dma_set_mask(hba->dev, DMA_BIT_MASK(32));
>>>          if (!err)
>>>                  dma_set_coherent_mask(hba->dev, DMA_BIT_MASK(32));
>>>          return err;
>>
>> Thanks for the explanation.  I agree that this is the correct definision
>> of ufshcd_set_dma_mask().
>>
>> The reason that I omitted the error check on
>> dma_set_mask(DMA_BIT_MASK(32))
>> in the patch was that I was seeing that error due to the luck of
>> valid dev->dma_mask pointer on OF platform devices although
>> dma_supported(DMA_BIT_MASK(32)) returns true.
>
> The popular trick implemented for device-tree probed devices is -
> dev->dma_mask = &dev->coherent_dma_mask;

This looks the right solution for now.  I'll send revised patches that
include this trick in ufshcd-pltfrm and fixed ufshcd_set_dma_mask() as
James suggested above.

