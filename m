Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8D22D043
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 12:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iSWB1cH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB5CC433C7;
	Wed,  6 Dec 2023 12:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701864174;
	bh=BiR1najpAX293kKEaaKpGpEKLDwjfEK+NqznOMhkJAY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iSWB1cH6k4OUEUk7A4FwcmEJhcyYVYQbwSOFpocRmdOMoffcD4DIWYZH872z09k44
	 /8sknIf9xxTRdZX+TAB+WuhaRAcoNAGycn2b7WpNU3wIxcQx1f8X/6yANsgQGUu4sO
	 1tJU1kaz//IjG0DT+0gSkB5+g3CVaAsRPFE8xyllM9Wx4I8evrBvU/u/KXzA1CJ8OP
	 JNeE/Z5IrGl8Fug6swfSUPGhAv3SzqUjEvcYM225YUpaIj+CTqftJguV4zqugmZo1B
	 o5f1Yg8TmiOBOqTrOF1azKCvlec4DFUUF5nGfomO/QIwrnUgkfTbYdb6gyHGfGE1vF
	 ez3mX3nFcm5IA==
Date: Wed, 6 Dec 2023 17:32:46 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	quic_cang@quicinc.com, Manish Pandey <quic_mapa@quicinc.com>
Subject: Re: [PATCH V2] scsi: ufs: core: store min and max clk freq from OPP
 table
Message-ID: <20231206120246.GB12802@thinkpad>
References: <20231206114659.13009-1-quic_nitirawa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231206114659.13009-1-quic_nitirawa@quicinc.com>

On Wed, Dec 06, 2023 at 05:16:59PM +0530, Nitin Rawat wrote:
> OPP support added by commit 72208ebe181e ("scsi: ufs: core: Add support
> for parsing OPP") doesn't update the min_freq and max_freq of each clocks
> in 'struct ufs_clk_info'.
> 
> But these values are used by the vendor host drivers internally for
> controller configuration. When the OPP support is enabled in devicetree,
> these values will be 0, causing boot issues on the respective platforms.
> 
> So add support to parse the min_freq and max_freq of all clocks while
> parsing the OPP table.
> 
> Fixes: 72208ebe181e ("scsi: ufs: core: Add support for parsing OPP")
> Co-developed-by: Manish Pandey <quic_mapa@quicinc.com>
> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Martin, please queue this patch for 6.7-rcS.

- Mani

> ---
> Changes from v1:
> As per Manivannan's comment:
> - Updated commmit description
> - Sort include file alphabetically
> - Added missing dev_pm_opp_put
> - updated function name and documention
> - removed ret variable
> ---
>  drivers/ufs/host/ufshcd-pltfrm.c | 53 ++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
> 
> diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
> index da2558e274b4..409efa0db8fa 100644
> --- a/drivers/ufs/host/ufshcd-pltfrm.c
> +++ b/drivers/ufs/host/ufshcd-pltfrm.c
> @@ -8,6 +8,7 @@
>   *	Vinayak Holikatti <h.vinayak@samsung.com>
>   */
> 
> +#include <linux/clk.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_opp.h>
> @@ -213,6 +214,54 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
>  	}
>  }
> 
> +/**
> + * ufshcd_parse_clock_min_max_freq  - Parse MIN and MAX clocks freq
> + * @hba: per adapter instance
> + *
> + * This function parses MIN and MAX frequencies of all clocks required
> + * by the vendor host drivers.
> + *
> + * Returns 0 for success and non-zero for failure
> + */
> +static int ufshcd_parse_clock_min_max_freq(struct ufs_hba *hba)
> +{
> +	struct list_head *head = &hba->clk_list_head;
> +	struct ufs_clk_info *clki;
> +	struct dev_pm_opp *opp;
> +	unsigned long freq;
> +	u8 idx = 0;
> +
> +	list_for_each_entry(clki, head, list) {
> +		if (!clki->name)
> +			continue;
> +
> +		clki->clk = devm_clk_get(hba->dev, clki->name);
> +		if (!IS_ERR(clki->clk)) {
> +			/* Find Max Freq */
> +			freq = ULONG_MAX;
> +			opp = dev_pm_opp_find_freq_floor_indexed(hba->dev, &freq, idx);
> +			if (IS_ERR(opp)) {
> +				dev_err(hba->dev, "Failed to find OPP for MAX frequency\n");
> +				return PTR_ERR(opp);
> +			}
> +			clki->max_freq = dev_pm_opp_get_freq_indexed(opp, idx);
> +			dev_pm_opp_put(opp);
> +
> +			/* Find Min Freq */
> +			freq = 0;
> +			opp = dev_pm_opp_find_freq_ceil_indexed(hba->dev, &freq, idx++);
> +			if (IS_ERR(opp)) {
> +				dev_err(hba->dev, "Failed to find OPP for MIN frequency\n");
> +				return PTR_ERR(opp);
> +			}
> +			clki->min_freq = dev_pm_opp_get_freq_indexed(opp, idx);
> +			dev_pm_opp_put(opp);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static int ufshcd_parse_operating_points(struct ufs_hba *hba)
>  {
>  	struct device *dev = hba->dev;
> @@ -279,6 +328,10 @@ static int ufshcd_parse_operating_points(struct ufs_hba *hba)
>  		return ret;
>  	}
> 
> +	ret = ufshcd_parse_clock_min_max_freq(hba);
> +	if (ret)
> +		return ret;
> +
>  	hba->use_pm_opp = true;
> 
>  	return 0;
> --
> 2.17.1
> 

-- 
மணிவண்ணன் சதாசிவம்
