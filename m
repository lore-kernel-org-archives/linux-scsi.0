From: "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Subject: Re: [PATCH v1 7/9] scsi: ufs: add UFS power collapse support during
 hibern8
Date: Mon, 23 Jul 2018 08:37:04 +0530
Message-ID: <8607cabf-e6ae-0a53-2139-d2279d458a9c@codeaurora.org>
References: <cover.1530880006.git.asutoshd@codeaurora.org>
 <13f4fbc290b5e3cfea95f49d65ddb2bf99a15cdb.1530880007.git.asutoshd@codeaurora.org>
 <e14fff20f9464677967fac6d9c5b905c@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e14fff20f9464677967fac6d9c5b905c@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Venkat Gopalakrishnan <venkatg@codeaurora.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 7/21/2018 5:28 AM, Subhash Jadavani wrote:
> On 2018-07-06 05:30, Asutosh Das wrote:
>> From: Subhash Jadavani <subhashj@codeaurora.org>
>>
>> UFS host controller hardware may allow the host controller
>> to be power collapsed when UFS link is hibern8 state, this
>> change allows the UFS host controller to be power collapsed
>> during hibern8.
>>
>> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
>> Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c |  8 ++++++--
>>  drivers/scsi/ufs/ufshcd.h | 13 ++++++++++++-
>>  2 files changed, 18 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 40d9c35..50588cf 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -7673,13 +7673,17 @@ static int ufshcd_vreg_set_hpm(struct ufs_hba 
>> *hba)
>>
>>  static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba)
>>  {
>> -    if (ufshcd_is_link_off(hba))
>> +    if (ufshcd_is_link_off(hba) ||
>> +        (ufshcd_is_link_hibern8(hba)
>> +         && ufshcd_is_power_collapse_during_hibern8_allowed(hba)))
>>          ufshcd_setup_hba_vreg(hba, false);
> 
> I guess we have to handle the UFS host controller power collapse via 
> "power-domains" which would requires us to specify the "power-domains" 
> attribute under UFS controller's DT node and then linux core power 
> framework should automatically collapse the UFS controller post runtime 
> suspend. This also means we can't power collapse UFS controller 
> aggressively (as part of clock gating) but it should still be fine from 
> power point of view.
> 
>>  }
>>
>>  static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba)
>>  {
>> -    if (ufshcd_is_link_off(hba))
>> +    if (ufshcd_is_link_off(hba) ||
>> +        (ufshcd_is_link_hibern8(hba)
>> +         && ufshcd_is_power_collapse_during_hibern8_allowed(hba)))
>>          ufshcd_setup_hba_vreg(hba, true);
>>  }
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index f79a639..8c5f987 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -728,7 +728,12 @@ struct ufs_hba {
>>       * to do background operation when it's active but it might degrade
>>       * the performance of ongoing read/write operations.
>>       */
>> -#define UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND (1 << 5)
>> +#define UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND (1 << 6)
>> +    /*
>> +     * If host controller hardware can be power collapsed when UFS 
>> link is
>> +     * in hibern8 then enable this cap.
>> +     */
>> +#define UFSHCD_CAP_POWER_COLLAPSE_DURING_HIBERN8 (1 << 7)
>>
>>      struct devfreq *devfreq;
>>      struct ufs_clk_scaling clk_scaling;
>> @@ -764,6 +769,12 @@ static inline bool
>> ufshcd_is_hibern8_on_idle_allowed(struct ufs_hba *hba)
>>      return hba->caps & UFSHCD_CAP_HIBERN8_ENTER_ON_IDLE;
>>  }
>>
>> +static inline bool ufshcd_is_power_collapse_during_hibern8_allowed(
>> +                        struct ufs_hba *hba)
>> +{
>> +    return !!(hba->caps & UFSHCD_CAP_POWER_COLLAPSE_DURING_HIBERN8);
>> +}
>> +
>>  static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
>>  {
>>  /* DWC UFS Core has the Interrupt aggregation feature but is not 
>> detectable*/
> 

Thanks. I'll check the 'power-domains' part and get back with the changes.


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
