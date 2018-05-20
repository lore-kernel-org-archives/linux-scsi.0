From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [RFC PATCH V2] scsi: ufs: Add specific callback for setting DMA
 mask
Date: Sun, 20 May 2018 07:05:45 +0530
Message-ID: <1e53194e-7255-a353-54ed-5c6c815205dc@samsung.com>
References: <CGME20180308111416epcas1p4f9f1dbb36e8567121c6236ac0e9b4e03@epcas1p4.samsung.com>
        <1520507013-2410-1-git-send-email-alim.akhtar@samsung.com>
        <CAGOxZ52yZ8Xqype7AVsH43DWOA2byh2kW3SGsfHyHtzqSH6QPw@mail.gmail.com>
        <1f7df8bfbc161243956233eac80f2cee@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1f7df8bfbc161243956233eac80f2cee@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>, alim.akhtar@samsung.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, vinayak holikatti <vinholikatti@gmail.com>, devicetree@vger.kernel.org, Shaik Ameer Basha <shaik.ameer@samsung.com>
List-Id: linux-scsi@vger.kernel.org

Hi Subhash

On 05/17/2018 03:01 AM, Subhash Jadavani wrote:
> On 2018-05-15 21:31, Alim Akhtar wrote:
>> Ping !!!
>>
>> On Thu, Mar 8, 2018 at 4:33 PM, Alim Akhtar <alim.akhtar@samsung.com> 
>> wrote:
>>> Currently DMA mask for UFS HCI is set by reading CAP register's
>>> [64AS] bit. Some HCI controller like Exynos support 36-bit bus address.
>>> This works perfectly fine with DMA mask set as 64 in case there is no
>>> IOMMU attached to HCI.
>>> In case if HCI is behind an IOMMU, setting DMA mask as 64 bit won't
>>> work as HCI has only 36bit addressing and SMMU has created mapping of
>>> 64 bit and as the device truncates the address, its mapping will not
>>> be found by iommu.
>>> To resolve such issues, let the variant driver sets its own DMA mask.
>>>
>>> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
>>> ---
>>>  drivers/scsi/ufs/ufshcd.c | 3 +++
>>>  drivers/scsi/ufs/ufshcd.h | 2 ++
>>>  2 files changed, 5 insertions(+)
>>>
>>> I am not sure if there are other ways available to handle such cases.
>>> The IOMMU I am talking about is arm-smmu and it DT binding does not
>>> give much idea about handling such cases.
>>> Have tested this patch with HCI controller with IOMMU attached.
>>>
>>> Changes Since V1:
>>>         - Fixed build issue as reported by Kbuild test robot.
>>>
>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>> index a355d98..9a1374e 100644
>>> --- a/drivers/scsi/ufs/ufshcd.c
>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>> @@ -7781,6 +7781,9 @@ EXPORT_SYMBOL_GPL(ufshcd_dealloc_host);
>>>   */
>>>  static int ufshcd_set_dma_mask(struct ufs_hba *hba)
>>>  {
>>> +       if (hba->vops && hba->vops->set_dma_mask)
>>> +               return hba->vops->set_dma_mask(hba);
>>> +
>>>         if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT) {
>>>                 if (!dma_set_mask_and_coherent(hba->dev, 
>>> DMA_BIT_MASK(64)))
>>>                         return 0;
>>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>>> index 1332e54..89c6dae 100644
>>> --- a/drivers/scsi/ufs/ufshcd.h
>>> +++ b/drivers/scsi/ufs/ufshcd.h
>>> @@ -297,6 +297,7 @@ struct ufs_pwr_mode_info {
>>>   * @resume: called during host controller PM callback
>>>   * @dbg_register_dump: used to dump controller debug information
>>>   * @phy_initialization: used to initialize phys
>>> + * @set_dma_mask: used to set variant specific DMA mask
>>>   */
>>>  struct ufs_hba_variant_ops {
>>>         const char *name;
>>> @@ -325,6 +326,7 @@ struct ufs_hba_variant_ops {
>>>         int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
>>>         void    (*dbg_register_dump)(struct ufs_hba *hba);
>>>         int     (*phy_initialization)(struct ufs_hba *);
>>> +       int     (*set_dma_mask)(struct ufs_hba *hba);
>>>  };
>>>
>>>  /* clock gating state  */
>>> -- 
>>> 2.7.4
>>>
> 
> Looks reasonable to me, you may try posting non-RFC version.
> 
Thanks for review.
Will send a non-RFC version.

Regards,
Alim
