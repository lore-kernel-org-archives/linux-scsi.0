From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: Re: [PATCH V3 10/16] scsi: ufs: add UFS power management support
Date: Sun, 21 Sep 2014 14:35:44 -0000
Message-ID: <c2cf94d0b05432efd5d244b0658123a8.squirrel@www.codeaurora.org>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
    <1410350063-23267-11-git-send-email-draviv@codeaurora.org>
    <541AD7F4.2070706@smartplayin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <541AD7F4.2070706@smartplayin.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: Dolev Raviv <draviv@codeaurora.org>, james.bottomley@hansenpartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Hi Kiran,
Thanks for bringing it to my attention. Fortunately I already noticed i=
t
and fixed it. It will be sent soon when all comments on this series are
addressed.

Thanks,
Dolev

> Hi Dolev,
>
> On Wednesday 10 September 2014 05:24 PM, Dolev Raviv wrote:
>> From: Subhash Jadavani <subhashj@codeaurora.org>
>>
>> This patch adds support for UFS device and UniPro link power managem=
ent
>> during runtime/system PM.
>>
>
> <snip>
>
>> +vccq_lpm:
>> +	ufshcd_config_vreg_lpm(hba, hba->vreg_info.vccq);
>> +vcc_disable:
>> +	ufshcd_toggle_vreg(hba->dev, hba->vreg_info.vcc, false);
>> +out:
>> +	return ret;
>> +}
>> +
>> +static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba)
>> +{
>> +	if (ufshcd_is_link_off(hba))
>> +		ufshcd_setup_hba_vreg(hba, false);
>
> I didn't find any declaration and definition of above API in your pat=
ch
> set.
> During compilation of this driver I got a below error, am I missing a=
ny
> thing?
>
> drivers/scsi/ufs/ufshcd.c: In function =91ufshcd_hba_vreg_set_lpm=92:
> drivers/scsi/ufs/ufshcd.c:4656:3: error: implicit declaration of
> function =91ufshcd_setup_hba_vreg=92 [-Werror=3Dimplicit-function-dec=
laration]
>    ufshcd_setup_hba_vreg(hba, false);
>    ^
>
>> +}
>> +
>> +static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba)
>> +{
>> +	if (ufshcd_is_link_off(hba))
>> +		ufshcd_setup_hba_vreg(hba, true);
>
> Ditto.
>
>>  }
>> -EXPORT_SYMBOL_GPL(ufshcd_suspend);
>>
>>  /**
>> - * ufshcd_resume - resume power management function
>> + * ufshcd_suspend - helper function for suspend operations
>>   * @hba: per adapter instance
>> + * @pm_op: desired low power operation type
>> + *
>> + * This function will try to put the UFS device and link into low p=
ower
>> + * mode based on the "rpm_lvl" (Runtime PM level) or "spm_lvl"
>> + * (System PM level).
>>   *
>
> <snip>
>
>> +int ufshcd_system_resume(struct ufs_hba *hba)
>> +{
>> +	if (!hba || !hba->is_powered || pm_runtime_suspended(hba->dev))
>> +		/*
>> +		 * Let the runtime resume take care of resuming
>> +		 * if runtime suspended.
>> +		 */
>> +		return 0;
>> +	else
>
> "else" is not generally useful after a break or return.
>
>> +		return ufshcd_resume(hba, UFS_SYSTEM_PM);
>> +}
>> +EXPORT_SYMBOL(ufshcd_system_resume);
>> +
>> +/**
>> + * ufshcd_runtime_suspend - runtime suspend routine
>> + * @hba: per adapter instance
>> + *
>> + * Check the description of ufshcd_suspend() function for more deta=
ils.
>> + *
>> + * Returns 0 for success and non-zero for failure
>> + */
>> +int ufshcd_runtime_suspend(struct ufs_hba *hba)
>> +{
>> +	if (!hba || !hba->is_powered)
>> +		return 0;
>> +	else
>
> "else" is not generally useful after a break or return.
>
>> +		return ufshcd_suspend(hba, UFS_RUNTIME_PM);
>>  }
>>  EXPORT_SYMBOL(ufshcd_runtime_suspend);
>>
>> +/**
>> + * ufshcd_runtime_resume - runtime resume routine
>> + * @hba: per adapter instance
>> + *
>> + * This function basically brings the UFS device, UniPro link and
>> controller
>> + * to active state. Following operations are done in this function:
>> + *
>
> Thanks,
> --Kiran
>
>


--=20
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a mem=
ber
of Code Aurora Forum, hosted by The Linux Foundation
