From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH v3 1/3] scsi: ufs: Introduce vops for resetting device
Date: Tue, 25 Jun 2019 18:11:24 +0530
Message-ID: <ad1c2a2a-91d6-25ce-9dfb-3b386b572ee2@samsung.com>
References: <20190608050450.12056-1-bjorn.andersson@linaro.org>
        <CGME20190608050458epcas1p30f03f6d448eb962a6af56a4c0b021ef0@epcas1p3.samsung.com>
        <20190608050450.12056-2-bjorn.andersson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190608050450.12056-2-bjorn.andersson@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Andy Gross <agross@kernel.org>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Bjorn,
Are you planning to address Bean's comment on patch#2 and want to 
re-spin this series?
I am ok with taking this patch as it is and take a Softreset patch as a 
separate patch.

On 6/8/19 10:34 AM, Bjorn Andersson wrote:
> Some UFS memory devices needs their reset line toggled in order to get
> them into a good state for initialization. Provide a new vops to allow
> the platform driver to implement this operation.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
feel free to add
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
> 
> Changes since v2:
> - New patch, to allow moving implementation to platform driver
> 
>   drivers/scsi/ufs/ufshcd.c | 6 ++++++
>   drivers/scsi/ufs/ufshcd.h | 8 ++++++++
>   2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 04d3686511c8..ee895a625456 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6191,6 +6191,9 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
>   	int retries = MAX_HOST_RESET_RETRIES;
>   
>   	do {
> +		/* Reset the attached device */
> +		ufshcd_vops_device_reset(hba);
> +
>   		err = ufshcd_host_reset_and_restore(hba);
>   	} while (err && --retries);
>   
> @@ -8322,6 +8325,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>   		goto exit_gating;
>   	}
>   
> +	/* Reset the attached device */
> +	ufshcd_vops_device_reset(hba);
> +
>   	/* Host controller enable */
>   	err = ufshcd_hba_enable(hba);
>   	if (err) {
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 994d73d03207..cd8139052ed6 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -298,6 +298,7 @@ struct ufs_pwr_mode_info {
>    * @resume: called during host controller PM callback
>    * @dbg_register_dump: used to dump controller debug information
>    * @phy_initialization: used to initialize phys
> + * @device_reset: called to issue a reset pulse on the UFS device
>    */
>   struct ufs_hba_variant_ops {
>   	const char *name;
> @@ -326,6 +327,7 @@ struct ufs_hba_variant_ops {
>   	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
>   	void	(*dbg_register_dump)(struct ufs_hba *hba);
>   	int	(*phy_initialization)(struct ufs_hba *);
> +	void	(*device_reset)(struct ufs_hba *);
>   };
>   
>   /* clock gating state  */
> @@ -1045,6 +1047,12 @@ static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
>   		hba->vops->dbg_register_dump(hba);
>   }
>   
> +static inline void ufshcd_vops_device_reset(struct ufs_hba *hba)
> +{
> +	if (hba->vops && hba->vops->device_reset)
> +		hba->vops->device_reset(hba);
> +}
> +
>   extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
>   
>   /*
> 
