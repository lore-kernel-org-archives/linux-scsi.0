From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH V3] scsi: ufs: Add specific callback for setting DMA
 mask
Date: Mon, 28 May 2018 12:05:56 +0530
Message-ID: <20180528064822epcas5p392f2255a985966b4e78cbd31860a8873~yvCeqPAYy2177421774epcas5p3N@epcas5p3.samsung.com>
References: <CGME20180520023633epcas2p333689dfc3c9f94c15018e33f69c751cb@epcas2p3.samsung.com>
        <1526783057-16620-1-git-send-email-alim.akhtar@samsung.com>
        <c9b0e89069769a093e07ac911f3a9019d1da32c1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c9b0e89069769a093e07ac911f3a9019d1da32c1.camel@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "shaik.ameer@samsung.com" <shaik.ameer@samsung.com>
List-Id: linux-scsi@vger.kernel.org

Hi Bart

On 05/20/2018 07:51 PM, Bart Van Assche wrote:
> On Sun, 2018-05-20 at 07:54 +0530, Alim Akhtar wrote:
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index a355d98..9a1374e 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -7781,6 +7781,9 @@ EXPORT_SYMBOL_GPL(ufshcd_dealloc_host);
>>    */
>>   static int ufshcd_set_dma_mask(struct ufs_hba *hba)
>>   {
>> +	if (hba->vops && hba->vops->set_dma_mask)
>> +		return hba->vops->set_dma_mask(hba);
>> +
>>   	if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT) {
>>   		if (!dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(64)))
>>   			return 0;
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index 1332e54..89c6dae 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -297,6 +297,7 @@ struct ufs_pwr_mode_info {
>>    * @resume: called during host controller PM callback
>>    * @dbg_register_dump: used to dump controller debug information
>>    * @phy_initialization: used to initialize phys
>> + * @set_dma_mask: used to set variant specific DMA mask
>>    */
>>   struct ufs_hba_variant_ops {
>>   	const char *name;
>> @@ -325,6 +326,7 @@ struct ufs_hba_variant_ops {
>>   	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
>>   	void	(*dbg_register_dump)(struct ufs_hba *hba);
>>   	int	(*phy_initialization)(struct ufs_hba *);
>> +	int	(*set_dma_mask)(struct ufs_hba *hba);
>>   };
> 
> I want to see the code that sets the .set_dma_mask callback function. Where
> is it? If it is outside the upstream kernel, please consider to send it
> upstream before making changes like this. Adding support for out-of-tree
> kernel code is frowned upon big time in the kernel community.
> 
Thanks for review and feedback.
Ok, I will include this patch with the series which uses this particular 
patch set.
Thanks!

> Bart.
> 
> 
> 
