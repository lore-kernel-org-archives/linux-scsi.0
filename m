Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3523126DF;
	Thu, 28 May 2026 06:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779949090; cv=none; b=a1Y8nN4NA5FrqM400PbVE1kWdTfkp2WPSAHK/KY2c4QcfYUQa58+zsuiyppjLDFciP9WOEcSIZUDIeNf5AwD/5YygFIuRsPlCHxVs9qdlYVfblP5Ay2tKVdqNkP6M71j9nSQ86BLUVzvc5eC9LxoLd8lewH/KYsIHf2vxb/KUQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779949090; c=relaxed/simple;
	bh=zY+RDhviVqI/nuvLLQqyu0zTAL2YtC7TZYKUWjh3XrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lhZ7ybEhz7fC4LyTIqHmQ5j9g1cYTdv03Bsof4y9epTAu8pmOSvSV2CCvaEvBeOwPIMchekia5b5yMbxlDQ+631UHrwlwb4A8iiOVLnOMykWuGkq3vsyW+FPznzoCpKuPs6FvGg0W+uMf/7JocCRbk2tWLON2XgDX6vidpL1CCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dtMY9/og; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dtMY9/og"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769831F000E9;
	Thu, 28 May 2026 06:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779949089;
	bh=hl0if7ags4VWBvm0RcJgjlOIvdEi4uxHKciAKzDPp8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dtMY9/og7FrZOa2PKVRqQx9Q6L9G7ANGB+i0n63FlJ4bE0oT11NezrL6RuWo1mzdv
	 2ULrhu/AJjhIXiSc++T0ht7gvjct4p8ahU6438Iv6LNNhe2P1zmOmFGTGx279jTS7d
	 v/I7xJAVigNkcwew/fm06kImEbVgnOhCH+OQMtkArhmgf0r5VM1uWA0Za32UMCLsG3
	 aR6Fdj1QJ1IeNMsNpmHffI0cBQpeGbcOKEAUnz68Nj8XYDVuf8lksb+oJmA/buD9gK
	 4NrFz+jQczuWvlLqLnVw21DBCllj7nhkg7K59MUgOP4M5eFNA9einE/jdyhGrxvG7Z
	 wqPrSBxaaYXYQ==
Date: Thu, 28 May 2026 08:18:04 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>, 
	Nitin Rawat <quic_nitirawa@quicinc.com>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
Message-ID: <z23icwga6qa4edt3amjx6jfl7uxmqqb7ipibxrqtpewguulfid@z4d7nj47mcu7>
References: <20260527144055.2758170-1-can.guo@oss.qualcomm.com>
 <20260527144055.2758170-3-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260527144055.2758170-3-can.guo@oss.qualcomm.com>

On Wed, May 27, 2026 at 07:40:55AM -0700, Can Guo wrote:
> Static TX Equalization settings and TX Precode enable indication from DT
> properties txeq-preshoot-g[1-6], txeq-deemphasis-g[1-6], and
> tx-precode-enable-g6 are board-specific baseline values. Values are
> provided as per-lane tuples:
> 
> <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]
> 
> Parse DT u32 properties with explicit range checks by using
> of_property_count_u32_elems()/of_property_read_u32_array().
> 
> When adaptive TX Equalization is used, these static settings are not final:
> 
> - If valid settings are retrieved from qTxEQGnSettings/wTxEQGnSettingsExt,
>   those retrieved settings override static DT settings.
> - If retrieval is not available/valid, TX EQTR runs and trained settings
>   override static DT settings.
> 
> So static DT settings are a fallback and are intended for cases where
> adaptive TX Equalization is not enabled/used. Adaptive TX Equalization
> remains the primary path when enabled.
> 
> No behavior changes for platforms that do not provide these properties.
> 
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
> ---
>  drivers/ufs/core/ufs-txeq.c      |   4 +-
>  drivers/ufs/host/ufshcd-pltfrm.c | 128 +++++++++++++++++++++++++++++++
>  include/ufs/ufshcd.h             |   2 +
>  3 files changed, 133 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
> index 4b264adfdf49..634ec039e129 100644
> --- a/drivers/ufs/core/ufs-txeq.c
> +++ b/drivers/ufs/core/ufs-txeq.c
> @@ -1297,7 +1297,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
>  	}
>  
>  	params = &hba->tx_eq_params[gear - 1];
> -	if (!params->is_valid || force_tx_eqtr) {
> +	if (!params->is_valid || params->is_static || force_tx_eqtr) {
>  		int ret;
>  
>  		ret = ufshcd_tx_eqtr(hba, params, pwr_mode);
> @@ -1310,6 +1310,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
>  		/* Mark TX Equalization settings as valid */
>  		params->is_valid = true;
>  		params->is_trained = true;
> +		params->is_static = false;
>  		params->is_applied = false;
>  	}
>  
> @@ -1495,6 +1496,7 @@ static void ufshcd_extract_tx_eq_settings_attrs(struct ufs_hba *hba, u8 gear)
>  	}
>  
>  	params->is_valid = true;
> +	params->is_static = false;
>  }
>  
>  void ufshcd_retrieve_tx_eq_settings(struct ufs_hba *hba)
> diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
> index c2dafb583cf5..2db2103a6ac0 100644
> --- a/drivers/ufs/host/ufshcd-pltfrm.c
> +++ b/drivers/ufs/host/ufshcd-pltfrm.c
> @@ -210,6 +210,132 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
>  	}
>  }
>  
> +static void ufshcd_parse_static_tx_eq_settings(struct ufs_hba *hba)
> +{
> +	size_t sz = hba->lanes_per_direction * 2;
> +	u32 lpd = hba->lanes_per_direction;
> +	struct ufshcd_tx_eq_params *params;
> +	u32 deemphasis[UFS_MAX_LANES * 2];
> +	u32 precode_en[UFS_MAX_LANES * 2];
> +	u32 preshoot[UFS_MAX_LANES * 2];
> +	struct device *dev = hba->dev;
> +	char prop_name[MAX_PROP_SIZE];
> +	int i, err, count, gear, lane;
> +
> +	if (!lpd || lpd > UFS_MAX_LANES) {
> +		dev_err(dev, "Invalid lanes-per-direction value (%u) provided\n", lpd);
> +		return;
> +	}
> +

'lanes_per_direction' can be 0 for platforms that do not support deriving the
lanes count from DT:

https://lore.kernel.org/linux-scsi/20260520070009epcms2p6542f3abb7660839e9d8140b3f2f145c3@epcms2p6/

You should just drop the err message to avoid spamming those platforms.

- Mani

> +	for (gear = UFS_HS_G1; gear <= UFS_HS_GEAR_MAX; gear++) {
> +		snprintf(prop_name, MAX_PROP_SIZE, "txeq-preshoot-g%d", gear);
> +		count = of_property_count_u32_elems(dev->of_node, prop_name);
> +		if (count <= 0)
> +			continue;
> +
> +		if (count != sz) {
> +			dev_err(dev, "Property %s has invalid count (%d), expecting %zu\n",
> +				prop_name, count, sz);
> +			continue;
> +		}
> +
> +		err = of_property_read_u32_array(dev->of_node, prop_name, preshoot, sz);
> +		if (err) {
> +			dev_err(dev, "Failed to read %s property, %d\n",
> +				prop_name, err);
> +			continue;
> +		}
> +
> +		for (i = 0; i < count; i++) {
> +			if (preshoot[i] >= TX_HS_NUM_PRESHOOT) {
> +				dev_err(dev, "An invalid TX EQ PreShoot (%d) provided in %s property\n",
> +					preshoot[i], prop_name);
> +				break;
> +			}
> +		}
> +
> +		if (i != count)
> +			continue;
> +
> +		snprintf(prop_name, MAX_PROP_SIZE, "txeq-deemphasis-g%d", gear);
> +		count = of_property_count_u32_elems(dev->of_node, prop_name);
> +		if (count <= 0) {
> +			dev_err(dev, "Missing required %s property\n", prop_name);
> +			continue;
> +		}
> +
> +		if (count != sz) {
> +			dev_err(dev, "Property %s has invalid count (%d), expecting %zu\n",
> +				prop_name, count, sz);
> +			continue;
> +		}
> +
> +		err = of_property_read_u32_array(dev->of_node, prop_name, deemphasis, sz);
> +		if (err) {
> +			dev_err(dev, "Failed to read %s property, %d\n",
> +				prop_name, err);
> +			continue;
> +		}
> +
> +		for (i = 0; i < count; i++) {
> +			if (deemphasis[i] >= TX_HS_NUM_DEEMPHASIS) {
> +				dev_err(dev, "An invalid TX EQ DeEmphasis (%d) provided in %s property\n",
> +					deemphasis[i], prop_name);
> +				break;
> +			}
> +		}
> +
> +		if (i != count)
> +			continue;
> +
> +		memset(precode_en, 0, sizeof(precode_en));
> +		if (gear == UFS_HS_G6) {
> +			snprintf(prop_name, MAX_PROP_SIZE, "tx-precode-enable-g%d", gear);
> +			count = of_property_count_u32_elems(dev->of_node, prop_name);
> +			if (count > 0) {
> +				if (count != sz) {
> +					dev_err(dev, "Property %s has invalid count (%d), expecting %zu\n",
> +						prop_name, count, sz);
> +					continue;
> +				}
> +
> +				err = of_property_read_u32_array(dev->of_node, prop_name,
> +								 precode_en, sz);
> +				if (err) {
> +					dev_err(dev, "Failed to read %s property, %d\n",
> +						prop_name, err);
> +					continue;
> +				}
> +
> +				for (i = 0; i < count; i++) {
> +					if (precode_en[i] > 1) {
> +						dev_err(dev, "An invalid PrecodeEn (%d) provided in %s property\n",
> +							precode_en[i], prop_name);
> +						break;
> +					}
> +				}
> +
> +				if (i != count)
> +					continue;
> +			}
> +		}
> +
> +		params = &hba->tx_eq_params[gear - 1];
> +		for (lane = 0; lane < lpd; lane++) {
> +			params->host[lane].preshoot = preshoot[lane * 2];
> +			params->host[lane].deemphasis = deemphasis[lane * 2];
> +			params->host[lane].precode_en = precode_en[lane * 2];
> +
> +			params->device[lane].preshoot = preshoot[lane * 2 + 1];
> +			params->device[lane].deemphasis = deemphasis[lane * 2 + 1];
> +			params->device[lane].precode_en = precode_en[lane * 2 + 1];
> +		}
> +
> +		params->is_valid = true;
> +		params->is_static = true;
> +	}
> +}
> +
>  /**
>   * ufshcd_parse_clock_min_max_freq  - Parse MIN and MAX clocks freq
>   * @hba: per adapter instance
> @@ -528,6 +654,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
>  
>  	ufshcd_init_lanes_per_dir(hba);
>  
> +	ufshcd_parse_static_tx_eq_settings(hba);
> +
>  	err = ufshcd_parse_operating_points(hba);
>  	if (err) {
>  		dev_err(dev, "%s: OPP parse failed %d\n", __func__, err);
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index f48d6416e299..c01824576472 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -359,6 +359,7 @@ struct ufshcd_tx_eqtr_record {
>   * @is_valid: True if parameter contains valid TX Equalization settings
>   * @is_applied: True if settings have been applied to UniPro of both sides
>   * @is_trained: True if parameters obtained from TX EQTR procedure
> + * @is_static: True if settings are static
>   */
>  struct ufshcd_tx_eq_params {
>  	struct ufshcd_tx_eq_settings host[UFS_MAX_LANES];
> @@ -367,6 +368,7 @@ struct ufshcd_tx_eq_params {
>  	bool is_valid;
>  	bool is_applied;
>  	bool is_trained;
> +	bool is_static;
>  };
>  
>  /**
> -- 
> 2.34.1

-- 
மணிவண்ணன் சதாசிவம்
