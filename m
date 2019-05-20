From: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 2/3] scsi: ufs: Add error-handling of Auto-Hibernate
Date: Mon, 20 May 2019 11:07:39 +0530
Message-ID: <c8c03a4c-3131-9036-02ce-8678c2113398@samsung.com>
References: <1557912988-26758-1-git-send-email-stanley.chu@mediatek.com>
 <CGME20190515093655epcas1p4642d3521d2abf9909c6964eea248540c@epcas1p4.samsung.com>
 <1557912988-26758-3-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1557912988-26758-3-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, avri.altman-Sjgp3cTcYWE@public.gmane.org, pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org
Cc: marc.w.gonzalez-GANU6spQydw@public.gmane.org, andy.teng-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, evgreen-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, beanhuo-AL4WhLSQfzjQT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Stanley,

On 5/15/19 3:06 PM, Stanley Chu wrote:
> Currently auto-hibernate is activated if host supports
> auto-hibern8 capability. However error-handling is not implemented,
> which makes the feature somewhat risky.
> 
> If either "Hibernate Enter" or "Hibernate Exit" fail during
> auto-hibernate flow, the corresponding interrupt
> "UIC_HIBERNATE_ENTER" or "UIC_HIBERNATE_EXIT" shall be raised
> according to UFS specification.
> 
> This patch adds auto-hibernate error-handling:
> 
> - Monitor "Hibernate Enter" and "Hibernate Exit" interrupts after
>    auto-hibernate feature is activated.
> 
> - If fail happens, trigger error-handling just like "manual-hibernate"
>    fail and apply the same recovery flow: schedule UFS error handler in
>    ufshcd_check_errors(), and then do host reset and restore
>    in UFS error handler.
> 
> Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/scsi/ufs/ufshcd.c | 31 +++++++++++++++++++++++++++++++
>   drivers/scsi/ufs/ufshcd.h |  5 +++++
>   drivers/scsi/ufs/ufshci.h |  3 +++
>   3 files changed, 39 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 1665820c22fd..e6a86223a0d4 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5254,6 +5254,7 @@ static void ufshcd_err_handler(struct work_struct *work)
>   			goto skip_err_handling;
>   	}
>   	if ((hba->saved_err & INT_FATAL_ERRORS) ||
> +	    (hba->saved_err & UFSHCD_UIC_AH8_ERROR_MASK) ||
>   	    ((hba->saved_err & UIC_ERROR) &&
>   	    (hba->saved_uic_err & (UFSHCD_UIC_DL_PA_INIT_ERROR |
>   				   UFSHCD_UIC_DL_NAC_RECEIVED_ERROR |
> @@ -5413,6 +5414,23 @@ static void ufshcd_update_uic_error(struct ufs_hba *hba)
>   			__func__, hba->uic_error);
>   }
>   
> +static bool ufshcd_is_auto_hibern8_error(struct ufs_hba *hba,
> +					 u32 intr_mask)
> +{
> +	if (!ufshcd_is_auto_hibern8_supported(hba))
> +		return false;
> +
> +	if (!(intr_mask & UFSHCD_UIC_AH8_ERROR_MASK))
> +		return false;
> +
> +	if (hba->active_uic_cmd &&
> +	    (hba->active_uic_cmd->command == UIC_CMD_DME_HIBER_ENTER ||
> +	    hba->active_uic_cmd->command == UIC_CMD_DME_HIBER_EXIT))
> +		return false;
> +
> +	return true;
> +}
> +
>   /**
>    * ufshcd_check_errors - Check for errors that need s/w attention
>    * @hba: per-adapter instance
> @@ -5431,6 +5449,15 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
>   			queue_eh_work = true;
>   	}
>   
> +	if (hba->errors & UFSHCD_UIC_AH8_ERROR_MASK) {
> +		dev_err(hba->dev,
> +			"%s: Auto Hibern8 %s failed - status: 0x%08x, upmcrs: 0x%08x\n",
> +			__func__, (hba->errors & UIC_HIBERNATE_ENTER) ?
> +			"Enter" : "Exit",
> +			hba->errors, ufshcd_get_upmcrs(hba));
> +		queue_eh_work = true;
> +	}
> +
>   	if (queue_eh_work) {
>   		/*
>   		 * update the transfer error masks to sticky bits, let's do this
> @@ -5493,6 +5520,10 @@ static void ufshcd_tmc_handler(struct ufs_hba *hba)
>   static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
>   {
>   	hba->errors = UFSHCD_ERROR_MASK & intr_status;
> +
> +	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
> +		hba->errors |= (UFSHCD_UIC_AH8_ERROR_MASK & intr_status);
> +
>   	if (hba->errors)
>   		ufshcd_check_errors(hba);
>   
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index ecfa898b9ccc..994d73d03207 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -740,6 +740,11 @@ return true;
>   #endif
>   }
>   
> +static inline bool ufshcd_is_auto_hibern8_supported(struct ufs_hba *hba)
> +{
> +	return (hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT);
> +}
> +
>   #define ufshcd_writel(hba, val, reg)	\
>   	writel((val), (hba)->mmio_base + (reg))
>   #define ufshcd_readl(hba, reg)	\
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> index 6fa889de5ee5..4bcb205f2077 100644
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -148,6 +148,9 @@ enum {
>   				UIC_HIBERNATE_EXIT |\
>   				UIC_POWER_MODE)
>   
> +#define UFSHCD_UIC_AH8_ERROR_MASK	(UIC_HIBERNATE_ENTER |\
> +					UIC_HIBERNATE_EXIT)
> +
>   #define UFSHCD_UIC_MASK		(UIC_COMMAND_COMPL | UFSHCD_UIC_PWR_MASK)
>   
>   #define UFSHCD_ERROR_MASK	(UIC_ERROR |\
> 
I don't have a way to test this patch, as my current platform does not 
support Auto Hibern8, over all this look ok to me.
Thanks,
Reviewed-by: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
