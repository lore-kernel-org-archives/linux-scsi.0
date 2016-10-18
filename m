From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v2 01/10] phy: qcom-ufs: remove failure when
 rx/tx_iface_clk are absent
Date: Tue, 18 Oct 2016 11:38:29 -0700
Message-ID: <65e2d1acf20ffc11d4c08e129b862998@codeaurora.org>
References: <1476800897-19898-1-git-send-email-vivek.gautam@codeaurora.org>
 <1476800897-19898-2-git-send-email-vivek.gautam@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1476800897-19898-2-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Vivek Gautam <vivek.gautam@codeaurora.org>
Cc: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Yaniv Gardi <ygardi@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

On 2016-10-18 07:28, Vivek Gautam wrote:
> From: Yaniv Gardi <ygardi@codeaurora.org>
> 
> Since in future UFS Phy's the tx_iface_clk and rx_iface_clk
> are no longer exist, we should not fail when their initialization
> fail, but rather just report with debug message.

You may also want to update the device tree binding (documentation) to 
update these as optional properties.

> 
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
> ---
> 
> No change since v1.
> 
>  drivers/phy/phy-qcom-ufs.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/phy/phy-qcom-ufs.c b/drivers/phy/phy-qcom-ufs.c
> index 107cb57..183ec04 100644
> --- a/drivers/phy/phy-qcom-ufs.c
> +++ b/drivers/phy/phy-qcom-ufs.c
> @@ -186,16 +186,27 @@ ufs_qcom_phy_init_clks(struct phy *generic_phy,
>  		       struct ufs_qcom_phy *phy_common)
>  {
>  	int err;
> +	struct ufs_qcom_phy *phy = get_ufs_qcom_phy(generic_phy);
> 
>  	err = ufs_qcom_phy_clk_get(generic_phy, "tx_iface_clk",
>  				   &phy_common->tx_iface_clk);
> +	/*
> +	 * tx_iface_clk does not exist in newer version of ufs-phy HW,
> +	 * so don't return error if it is not found
> +	 */
>  	if (err)
> -		goto out;
> +		dev_dbg(phy->dev, "%s: failed to get tx_iface_clk\n",
> +			__func__);
> 
>  	err = ufs_qcom_phy_clk_get(generic_phy, "rx_iface_clk",
>  				   &phy_common->rx_iface_clk);
> +	/*
> +	 * rx_iface_clk does not exist in newer version of ufs-phy HW,
> +	 * so don't return error if it is not found
> +	 */
>  	if (err)
> -		goto out;
> +		dev_dbg(phy->dev, "%s: failed to get rx_iface_clk\n",
> +			__func__);
> 
>  	err = ufs_qcom_phy_clk_get(generic_phy, "ref_clk_src",
>  				   &phy_common->ref_clk_src);

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
