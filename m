From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH 1/2] ufs-pltfrm: initialize DMA mask for device-tree probed
 device
Date: Tue, 20 Aug 2013 12:56:21 +0530
Message-ID: <52131A1D.2060907@codeaurora.org>
References: <1376920566-20325-1-git-send-email-mita@fixstars.com> <1376922720.2069.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:37478 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3HTH01 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2013 03:26:27 -0400
In-Reply-To: <1376922720.2069.10.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Akinobu Mita <mita@fixstars.com>, linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, devicetree@vger.kernel.org

On 8/19/2013 8:02 PM, James Bottomley wrote:
> On Mon, 2013-08-19 at 22:56 +0900, Akinobu Mita wrote:
>> The device-tree probed device for ARM doesn't have dev->dma_mask.
>> So dma_set_mask() for the device doesn't succeed.  The popular trick
>> for this is - dev->dma_mask = &dev->coherent_dma_mask;
>>
>> Currently there is no dma_set_mask() call in ufs-pltfrm, but the
>> forthcoming fix needs proper DMA mask setting in ufs core driver.  So
>> initializing dev->dma_mask as described above is required.
>>
>> Signed-off-by: Akinobu Mita <mita@fixstars.com>
>> Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
>> Cc: Vinayak Holikatti <vinholikatti@gmail.com>
>> Cc: Santosh Y <santoshsy@gmail.com>
>> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
>> Cc: linux-scsi@vger.kernel.org
>> ---
>>   drivers/scsi/ufs/ufshcd-pltfrm.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
>> index 94ba40c..c780840 100644
>> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
>> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
>> @@ -122,6 +122,9 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
>>   		goto out;
>>   	}
>>
>> +	if (!dev->dma_mask)
>> +		dev->dma_mask = &dev->coherent_dma_mask;
>> +
>
> If the DMA mask is NULL, it means there's buggy platform code somewhere;
> I'm not sure we should be hacking a fix in a SCSI driver.

Yes, ideally DT core should do this, there are patches lying around but
are not converged. Adding devicetree@vger.kernel.org to see if someone
has better suggestions.

Recent additions to kernel with similar hacks -
https://patchwork.kernel.org/patch/2537021/


-- 
Regards,
Sujit
