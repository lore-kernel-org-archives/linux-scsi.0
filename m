From: Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [PATCH v2] scsi: ufs: Configure clock in .hce_enable_notify() in
 Cadence UFS
Date: Mon, 5 Aug 2019 13:32:14 +0530
Message-ID: <86985e8d-2aa8-5583-f899-925191f2041d@ti.com>
References: <20190802112112.18714-1-aniljoy@cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190802112112.18714-1-aniljoy@cadence.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Varughese <aniljoy@cadence.com>, alim.akhtar@samsung.com, avri.altman@wdc.com, pedrom.sousa@synopsys.com
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, hare@suse.de, rafalc@cadence.com, mparab@cadence.com, jank@cadence.com, pawell@cadence.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 02/08/19 4:51 PM, Anil Varughese wrote:
> Configure CDNS_UFS_REG_HCLKDIV in .hce_enable_notify() instead of
> .setup_clock() because if UFSHCD resets the controller ip because
> of phy or device related errors then CDNS_UFS_REG_HCLKDIV is
> reset to default value and .setup_clock() is not called later
> in the sequence whereas .hce_enable_notify will be called everytime
> controller is reenabled.
> 
> Signed-off-by: Anil Varughese <aniljoy@cadence.com>
> ---

Reviewed-by: Vignesh Raghavendra <vigneshr@ti.com>

>  drivers/scsi/ufs/cdns-pltfrm.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
> index 86dbb723f..993519080 100644
> --- a/drivers/scsi/ufs/cdns-pltfrm.c
> +++ b/drivers/scsi/ufs/cdns-pltfrm.c
> @@ -62,17 +62,16 @@ static int cdns_ufs_set_hclkdiv(struct ufs_hba *hba)
>  }
>  
>  /**
> - * Sets clocks used by the controller
> + * Called before and after HCE enable bit is set.
>   * @hba: host controller instance
> - * @on: if true, enable clocks, otherwise disable
>   * @status: notify stage (pre, post change)
>   *
>   * Return zero for success and non-zero for failure
>   */
> -static int cdns_ufs_setup_clocks(struct ufs_hba *hba, bool on,
> -				 enum ufs_notify_change_status status)
> +static int cdns_ufs_hce_enable_notify(struct ufs_hba *hba,
> +				      enum ufs_notify_change_status status)
>  {
> -	if ((!on) || (status == PRE_CHANGE))
> +	if (status != PRE_CHANGE)
>  		return 0;
>  
>  	return cdns_ufs_set_hclkdiv(hba);
> @@ -114,13 +113,13 @@ static int cdns_ufs_m31_16nm_phy_initialization(struct ufs_hba *hba)
>  
>  static const struct ufs_hba_variant_ops cdns_ufs_pltfm_hba_vops = {
>  	.name = "cdns-ufs-pltfm",
> -	.setup_clocks = cdns_ufs_setup_clocks,
> +	.hce_enable_notify = cdns_ufs_hce_enable_notify,
>  };
>  
>  static const struct ufs_hba_variant_ops cdns_ufs_m31_16nm_pltfm_hba_vops = {
>  	.name = "cdns-ufs-pltfm",
>  	.init = cdns_ufs_init,
> -	.setup_clocks = cdns_ufs_setup_clocks,
> +	.hce_enable_notify = cdns_ufs_hce_enable_notify,
>  	.phy_initialization = cdns_ufs_m31_16nm_phy_initialization,
>  };
>  
> 

-- 
Regards
Vignesh
