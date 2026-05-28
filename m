Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F013ED3DD;
	Thu, 28 May 2026 12:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779971239; cv=none; b=pJSH4Wtf4Pd8mP6wKqkjDKjFH88Yd7yFSQ3LbjN0y57Mn2Liob44MeJIlo1XkWKU1si8uS7H9pNBzo4sRdz+Mi7ypJ2np522xdh68CoYMGSClgZbUfdx+7qRP0cHtlqcx1lAMa0Ea16A/rZKNrXrtEd684adyh2L/dSEIg1tdxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779971239; c=relaxed/simple;
	bh=fCvRxOmZWFmx6SVnpq+XK/iM3UH6xNmuEXVRaIV8bWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hiYMjOakOARJWKWvdu8AZsk6fmXnBvTu2lSYqd75ogoiyil+ZkT+XJbuzJxsLV8Q2glsX0aexC2bNXB7AZOVf9BM5kkrqcSVHsnOiUPyDftbRtY5rF2Tidh/XUJP5SdQNOKlkFdNqdfuF47ryu/nULFngZO78IVF+nso8RzTGq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYAmdAh/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYAmdAh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC231F00A3A;
	Thu, 28 May 2026 12:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779971237;
	bh=AKtovlCbQK2L9SecQuSzND1Hzg+p1s/9wKBZpHroIC8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DYAmdAh/UPeHc+5ayN1F7tSOxCQNSYGXc5i7NocUaom4feo8gvBmzaOqV/TLvNZ7H
	 ePwdZz141hNaTbouHrv25vYpUcnDptzfUmpE5MG5Qu4Jg8uDdGCmm0o7odVzMcCEXD
	 m6wVqsKiTSYSJTBLibdtPFfViykOAqYmw5axgyy5Kpt3PgQW40h9w+E+9yUNBMicux
	 QxS30rY7VggoCRg/I9tF9OmWd8/MOW0Tu2L3Oxhzo4uLqKWCu46bODkD/wNh7Es5rP
	 C71XxfZ3AkCSZphbYSd/PKUgg93YeuzS04pFVSNZQJOatPhgcLpQVbUA37rD7edoD4
	 q9RGdOB0m3sQQ==
Date: Thu, 28 May 2026 14:27:12 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>, 
	Nitin Rawat <quic_nitirawa@quicinc.com>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
Message-ID: <bh27zjliqpam2wzwbwusw4n5wk5ka7hdu776k22nmdogupsu6t@xetc7lnmj43v>
References: <20260528100614.3386423-1-can.guo@oss.qualcomm.com>
 <20260528100614.3386423-3-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260528100614.3386423-3-can.guo@oss.qualcomm.com>

On Thu, May 28, 2026 at 03:06:14AM -0700, Can Guo wrote:
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

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
>  drivers/ufs/core/ufs-txeq.c      |  10 ++-
>  drivers/ufs/host/ufshcd-pltfrm.c | 126 +++++++++++++++++++++++++++++++
>  include/ufs/ufshcd.h             |   2 +
>  3 files changed, 137 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
> index 4b264adfdf49..b645fe5f6d95 100644
> --- a/drivers/ufs/core/ufs-txeq.c
> +++ b/drivers/ufs/core/ufs-txeq.c
> @@ -1297,7 +1297,13 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
>  	}
>  
>  	params = &hba->tx_eq_params[gear - 1];
> -	if (!params->is_valid || force_tx_eqtr) {
> +	/*
> +	 * TX EQTR must run for the following cases:
> +	 * 1. TX EQ settings are invalid.
> +	 * 2. TX EQ settings are valid but static, i.e., populated from DT.
> +	 * 3. TX EQTR procedure is forced.
> +	 */
> +	if (!params->is_valid || params->is_static || force_tx_eqtr) {
>  		int ret;
>  
>  		ret = ufshcd_tx_eqtr(hba, params, pwr_mode);
> @@ -1310,6 +1316,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
>  		/* Mark TX Equalization settings as valid */
>  		params->is_valid = true;
>  		params->is_trained = true;
> +		params->is_static = false;
>  		params->is_applied = false;
>  	}
>  
> @@ -1495,6 +1502,7 @@ static void ufshcd_extract_tx_eq_settings_attrs(struct ufs_hba *hba, u8 gear)
>  	}
>  
>  	params->is_valid = true;
> +	params->is_static = false;
>  }
>  
>  void ufshcd_retrieve_tx_eq_settings(struct ufs_hba *hba)
> diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
> index c2dafb583cf5..6fe360efa80a 100644
> --- a/drivers/ufs/host/ufshcd-pltfrm.c
> +++ b/drivers/ufs/host/ufshcd-pltfrm.c
> @@ -210,6 +210,130 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
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
> +	if (!lpd || lpd > UFS_MAX_LANES)
> +		return;
> +
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
> @@ -528,6 +652,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
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
> 

-- 
மணிவண்ணன் சதாசிவம்
