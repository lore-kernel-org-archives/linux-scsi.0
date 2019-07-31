From: Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [PATCH] scsi: ufs: Additional clock initialization in Cadence UFS
Date: Wed, 31 Jul 2019 22:05:15 +0530
Message-ID: <77210067-ee65-4c12-9c7e-2b78260acdef@ti.com>
References: <20190731083614.25926-1-aniljoy@cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190731083614.25926-1-aniljoy@cadence.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Varughese <aniljoy@cadence.com>, alim.akhtar@samsung.com, avri.altman@wdc.com, pedrom.sousa@synopsys.com
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, hare@suse.de, rafalc@cadence.com, mparab@cadence.com, jank@cadence.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 31-Jul-19 2:06 PM, Anil Varughese wrote:
> Configure CDNS_UFS_REG_HCLKDIV in .hce_enable_notify()
> because if UFSHCD resets the controller ip because of
> phy or device related errors then CDNS_UFS_REG_HCLKDIV
> is reset to default value and .setup_clock() is not
> called later in the sequence whereas hce_enable_notify
> will be called everytime controller is reenabled.
>
So, now that CDNS_UFS_REG_HCLKDIV is configured in .hce_enable_notify(),
is it still required to have the same code in .setup_clock() as well?
Isn't setting up CDNS_UFS_REG_HCLKDIV in .hce_enable_notify() alone not
sufficient?

Regards
Vignesh

> Signed-off-by: Anil Varughese <aniljoy@cadence.com>
> ---
>  drivers/scsi/ufs/cdns-pltfrm.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
> index 86dbb723f..15ee54d28 100644
> --- a/drivers/scsi/ufs/cdns-pltfrm.c
> +++ b/drivers/scsi/ufs/cdns-pltfrm.c
> @@ -78,6 +78,22 @@ static int cdns_ufs_setup_clocks(struct ufs_hba *hba, bool on,
>  	return cdns_ufs_set_hclkdiv(hba);
>  }
>  
> +/**
> + * Called before and after HCE enable bit is set.
> + * @hba: host controller instance
> + * @status: notify stage (pre, post change)
> + *
> + * Return zero for success and non-zero for failure
> + */
> +static int cdns_ufs_hce_enable_notify(struct ufs_hba *hba,
> +				      enum ufs_notify_change_status status)
> +{
> +	if (status != PRE_CHANGE)
> +		return 0;
> +
> +	return cdns_ufs_set_hclkdiv(hba);
> +}
> +
>  /**
>   * cdns_ufs_init - performs additional ufs initialization
>   * @hba: host controller instance
> @@ -115,12 +131,14 @@ static int cdns_ufs_m31_16nm_phy_initialization(struct ufs_hba *hba)
>  static const struct ufs_hba_variant_ops cdns_ufs_pltfm_hba_vops = {
>  	.name = "cdns-ufs-pltfm",
>  	.setup_clocks = cdns_ufs_setup_clocks,
> +	.hce_enable_notify = cdns_ufs_hce_enable_notify,
>  };
>  
>  static const struct ufs_hba_variant_ops cdns_ufs_m31_16nm_pltfm_hba_vops = {
>  	.name = "cdns-ufs-pltfm",
>  	.init = cdns_ufs_init,
>  	.setup_clocks = cdns_ufs_setup_clocks,
> +	.hce_enable_notify = cdns_ufs_hce_enable_notify,
>  	.phy_initialization = cdns_ufs_m31_16nm_phy_initialization,
>  };
>  
> 
