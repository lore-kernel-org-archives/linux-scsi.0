From: Akinobu Mita <mita@fixstars.com>
Subject: Re: [PATCH 10/10] ufs: fix DMA mask setting
Date: Sat, 29 Jun 2013 14:40:17 +0900
Message-ID: <CAD7r0yBAW2XWCkO_38u3GaUaL=kRFC84nqBXUoWLjaTRvUJ+ag@mail.gmail.com>
References: <1372266575-3468-1-git-send-email-santoshsy@gmail.com>
	<1372266575-3468-11-git-send-email-santoshsy@gmail.com>
	<1372451836.1884.23.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo.fixstars.hdemail.jp ([176.34.54.138]:57879 "EHLO
	mo.fixstars.hdemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3F2FoF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Jun 2013 01:44:05 -0400
In-Reply-To: <1372451836.1884.23.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Santosh Y <santoshsy@gmail.com>, linux-scsi@vger.kernel.org, vinholikatti@gmail.com

2013/6/29 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Wed, 2013-06-26 at 22:39 +0530, Santosh Y wrote:
>> index 19618c6..431ddb2 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -1711,6 +1711,25 @@ void ufshcd_remove(struct ufs_hba *hba)
>>  EXPORT_SYMBOL_GPL(ufshcd_remove);
>>
>>  /**
>> + * ufshcd_set_dma_mask - Set dma mask based on the controller
>> + *                    addressing capability
>> + * @hba: per adapter instance
>> + *
>> + * Returns 0 for success, non-zero for failure
>> + */
>> +static int ufshcd_set_dma_mask(struct ufs_hba *hba)
>> +{
>> +     if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT) {
>> +             if (!dma_set_mask(hba->dev, DMA_BIT_MASK(64)) &&
>> +                 !dma_set_coherent_mask(hba->dev, DMA_BIT_MASK(64)))
>> +                     return 0;
>> +     }
>> +     dma_set_mask(hba->dev, DMA_BIT_MASK(32));
>> +
>> +     return dma_set_coherent_mask(hba->dev, DMA_BIT_MASK(32));
>> +}
>
> This isn't right per the API spec.  The guarantee is that if
> dma_set_mask() succeeds then dma_set_coherent_mask of the same mask will
> succeed,  so this should read
>
>         int err;
>
>         if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT) {
>                 if (!dma_set_mask(hba->dev, DMA_BIT_MASK(64))) {
>                         dma_set_coherent_mask(hba->dev, DMA_BIT_MASK(64)))
>                         return 0;
>                 }
>         }
>         err = dma_set_mask(hba->dev, DMA_BIT_MASK(32));
>         if (!err)
>                 dma_set_coherent_mask(hba->dev, DMA_BIT_MASK(32));
>         return err;

Thanks for the explanation.  I agree that this is the correct definision
of ufshcd_set_dma_mask().

The reason that I omitted the error check on dma_set_mask(DMA_BIT_MASK(32))
in the patch was that I was seeing that error due to the luck of
valid dev->dma_mask pointer on OF platform devices although
dma_supported(DMA_BIT_MASK(32)) returns true.

However, now I think that I should investigate more about dev->dma_mask
issue rather than jumping into short-circuit fixing in the driver.  And
then I will revisit this.
