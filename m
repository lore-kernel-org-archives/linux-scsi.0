From: Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: Re: [PATCH V3 10/16] scsi: ufs: add UFS power management support
Date: Thu, 18 Sep 2014 18:32:44 +0530
Message-ID: <541AD7F4.2070706@smartplayin.com>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org> <1410350063-23267-11-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1410350063-23267-11-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Hi Dolev,

On Wednesday 10 September 2014 05:24 PM, Dolev Raviv wrote:
> From: Subhash Jadavani <subhashj@codeaurora.org>
>=20
> This patch adds support for UFS device and UniPro link power manageme=
nt
> during runtime/system PM.
>=20

<snip>

> +vccq_lpm:
> +	ufshcd_config_vreg_lpm(hba, hba->vreg_info.vccq);
> +vcc_disable:
> +	ufshcd_toggle_vreg(hba->dev, hba->vreg_info.vcc, false);
> +out:
> +	return ret;
> +}
> +
> +static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba)
> +{
> +	if (ufshcd_is_link_off(hba))
> +		ufshcd_setup_hba_vreg(hba, false);

I didn't find any declaration and definition of above API in your patch=
 set.=20
During compilation of this driver I got a below error, am I missing any=
 thing?

drivers/scsi/ufs/ufshcd.c: In function =91ufshcd_hba_vreg_set_lpm=92:
drivers/scsi/ufs/ufshcd.c:4656:3: error: implicit declaration of=20
function =91ufshcd_setup_hba_vreg=92 [-Werror=3Dimplicit-function-decla=
ration]
   ufshcd_setup_hba_vreg(hba, false);
   ^

> +}
> +
> +static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba)
> +{
> +	if (ufshcd_is_link_off(hba))
> +		ufshcd_setup_hba_vreg(hba, true);

Ditto.

>  }
> -EXPORT_SYMBOL_GPL(ufshcd_suspend);
> =20
>  /**
> - * ufshcd_resume - resume power management function
> + * ufshcd_suspend - helper function for suspend operations
>   * @hba: per adapter instance
> + * @pm_op: desired low power operation type
> + *
> + * This function will try to put the UFS device and link into low po=
wer
> + * mode based on the "rpm_lvl" (Runtime PM level) or "spm_lvl"
> + * (System PM level).
>   *

<snip>

> +int ufshcd_system_resume(struct ufs_hba *hba)
> +{
> +	if (!hba || !hba->is_powered || pm_runtime_suspended(hba->dev))
> +		/*
> +		 * Let the runtime resume take care of resuming
> +		 * if runtime suspended.
> +		 */
> +		return 0;
> +	else

"else" is not generally useful after a break or return.

> +		return ufshcd_resume(hba, UFS_SYSTEM_PM);
> +}
> +EXPORT_SYMBOL(ufshcd_system_resume);
> +
> +/**
> + * ufshcd_runtime_suspend - runtime suspend routine
> + * @hba: per adapter instance
> + *
> + * Check the description of ufshcd_suspend() function for more detai=
ls.
> + *
> + * Returns 0 for success and non-zero for failure
> + */
> +int ufshcd_runtime_suspend(struct ufs_hba *hba)
> +{
> +	if (!hba || !hba->is_powered)
> +		return 0;
> +	else

"else" is not generally useful after a break or return.

> +		return ufshcd_suspend(hba, UFS_RUNTIME_PM);
>  }
>  EXPORT_SYMBOL(ufshcd_runtime_suspend);
> =20
> +/**
> + * ufshcd_runtime_resume - runtime resume routine
> + * @hba: per adapter instance
> + *
> + * This function basically brings the UFS device, UniPro link and co=
ntroller
> + * to active state. Following operations are done in this function:
> + *

Thanks,
--Kiran
