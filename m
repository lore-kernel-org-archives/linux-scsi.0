Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DDD392C3A;
	Fri, 29 May 2026 17:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780077183; cv=none; b=ItvB+R0tWNjD5W4kknrlGlByef79+o0KNmshN2BWNA06k/rPFO6UI3IZ0GDrfH7BWyiEzgRykKB74o8bdGQywPlNr2TTl6+JvhSHCoWCHLVOUrxvPvKcA1UUcuePvpVsEAthSzXwfOO0C/Ked6QLQDROaugJPnfLztv2Uyg0dhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780077183; c=relaxed/simple;
	bh=54IFEOZdN2o2SWjPhLNoTbpQLmuPaWhWr9cSAUki4wc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J0Lf6hn1kS1i0d3BREIhSNmWg6uXPi3JwJVv5AnOrXx8TQv7RagZk/HnsZA3z732SjvQkSrG5WYidhVMBsoVgiYWXf8R25+OxLfP+k0ZfUS3w4/wxonLCRCcUAlTN0delA3iFK6xoCHJe1Coswi15Um7DlHtuWkpxhB4iN2BORI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CL0+TWK0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CL0+TWK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AADB1F00893;
	Fri, 29 May 2026 17:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780077179;
	bh=1bpqPpO9aTHCPceJDjrVjKhFFDy3yMAGMbtB/mhfrOE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CL0+TWK0LOPIO65oUDsWrSbN0zLvWb5tb0y4g5bvuTv/04lgueJrTu+oqkhsQqs5n
	 ULBFhvmZCVayzBHYdfaSH+QYGDjwvsppx/09MvR3Eu3DXXAzt0o8bn843XlOdPoCPq
	 69+SquO6DatpBUSADOEsAFrmy13rPWw7IHxVQ1O2mzSFYNG4HQG8ubeSWvQcUSL+W3
	 2fro1t2NfMDmoQ2g8UC9/VRiWMPvL+npzAjD90pADD84CvAi29PEpSzhX38p0eJuNX
	 VLV7vn+mR0GXVUmu0GQZxpJ93WnJCxrI7tjQOydX/uTVLi1d27AWv4zb685Z9/KMGI
	 MgbgJpvcfHtNg==
Date: Fri, 29 May 2026 19:52:54 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Nitin Rawat <quic_nitirawa@quicinc.com>, 
	Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
Message-ID: <w2mwg7g6l7mwbwk5yjjlrrp3hcg2hccdenyusb6ehez644kbhm@dfy2ex63iam3>
References: <20260529113338.984301-1-can.guo@oss.qualcomm.com>
 <20260529113338.984301-3-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260529113338.984301-3-can.guo@oss.qualcomm.com>

On Fri, May 29, 2026 at 04:33:38AM -0700, Can Guo wrote:
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
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

A couple of nits below.

> ---
>  drivers/ufs/core/ufs-txeq.c      |  10 ++-
>  drivers/ufs/host/ufshcd-pltfrm.c | 139 +++++++++++++++++++++++++++++++
>  include/ufs/ufshcd.h             |   2 +
>  3 files changed, 150 insertions(+), 1 deletion(-)
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
> index c2dafb583cf5..fc6aa91b6210 100644
> --- a/drivers/ufs/host/ufshcd-pltfrm.c
> +++ b/drivers/ufs/host/ufshcd-pltfrm.c
> @@ -210,6 +210,143 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
>  	}
>  }
>  
> +/**
> + * ufshcd_parse_tx_eq_settings_for_gear - Parse static TX EQ DT settings for one gear
> + * @hba: per adapter instance
> + * @gear: target HS gear
> + * @num_elems: expected number of elements per property
> + *
> + * Reads the txeq-preshoot-gN, txeq-deemphasis-gN, and (for G6)
> + * tx-precode-enable-gN device-tree properties and, if all are valid, stores
> + * them as static TX Equalization settings for the given gear.
> + */
> +static void ufshcd_parse_tx_eq_settings_for_gear(struct ufs_hba *hba,
> +						 int gear, const u32 num_elems)

ufshcd_parse_tx_eq_settings_per_gear()?

> +{
> +	u32 precode_en[UFS_MAX_LANES * 2] = { 0 };
> +	const u32 lpd = hba->lanes_per_direction;
> +	struct ufshcd_tx_eq_params *params;
> +	u32 deemphasis[UFS_MAX_LANES * 2];
> +	u32 preshoot[UFS_MAX_LANES * 2];
> +	struct device *dev = hba->dev;
> +	char prop_name[MAX_PROP_SIZE];
> +	int i, err, lane, count;
> +
> +	snprintf(prop_name, MAX_PROP_SIZE, "txeq-preshoot-g%d", gear);
> +	count = of_property_count_u32_elems(dev->of_node, prop_name);
> +	if (count <= 0)
> +		return;
> +
> +	if (count != num_elems) {
> +		dev_err(dev, "Property %s has invalid count (%d), expecting %u\n",
> +			prop_name, count, num_elems);
> +		return;
> +	}
> +
> +	err = of_property_read_u32_array(dev->of_node, prop_name, preshoot, num_elems);
> +	if (err) {
> +		dev_err(dev, "Failed to read %s property, %d\n", prop_name, err);
> +		return;
> +	}
> +
> +	for (i = 0; i < num_elems; i++) {
> +		if (preshoot[i] >= TX_HS_NUM_PRESHOOT) {
> +			dev_err(dev, "An invalid TX EQ PreShoot (%d) provided in %s property\n",
> +				preshoot[i], prop_name);
> +			return;
> +		}
> +	}
> +
> +	snprintf(prop_name, MAX_PROP_SIZE, "txeq-deemphasis-g%d", gear);
> +	count = of_property_count_u32_elems(dev->of_node, prop_name);
> +	if (count <= 0) {
> +		dev_err(dev, "Missing required %s property\n", prop_name);
> +		return;
> +	}
> +
> +	if (count != num_elems) {
> +		dev_err(dev, "Property %s has invalid count (%d), expecting %u\n",
> +			prop_name, count, num_elems);
> +		return;
> +	}
> +
> +	err = of_property_read_u32_array(dev->of_node, prop_name, deemphasis, num_elems);
> +	if (err) {
> +		dev_err(dev, "Failed to read %s property, %d\n", prop_name, err);
> +		return;
> +	}
> +
> +	for (i = 0; i < num_elems; i++) {
> +		if (deemphasis[i] >= TX_HS_NUM_DEEMPHASIS) {
> +			dev_err(dev, "An invalid TX EQ DeEmphasis (%d) provided in %s property\n",
> +				deemphasis[i], prop_name);
> +			return;
> +		}
> +	}
> +
> +	if (gear == UFS_HS_G6) {
> +		snprintf(prop_name, MAX_PROP_SIZE, "tx-precode-enable-g%d", gear);
> +		count = of_property_count_u32_elems(dev->of_node, prop_name);
> +		if (count > 0) {
> +			if (count != num_elems) {
> +				dev_err(dev, "Property %s has invalid count (%d), expecting %u\n",
> +					prop_name, count, num_elems);
> +				return;
> +			}
> +
> +			err = of_property_read_u32_array(dev->of_node, prop_name,
> +							 precode_en, num_elems);
> +			if (err) {
> +				dev_err(dev, "Failed to read %s property, %d\n",
> +					prop_name, err);
> +				return;
> +			}
> +
> +			for (i = 0; i < num_elems; i++) {
> +				if (precode_en[i] > 1) {
> +					dev_err(dev, "An invalid PrecodeEn (%d) provided in %s property\n",
> +						precode_en[i], prop_name);
> +					return;
> +				}
> +			}
> +		}
> +	}
> +
> +	params = &hba->tx_eq_params[gear - 1];
> +	for (lane = 0; lane < lpd; lane++) {
> +		params->host[lane].preshoot = preshoot[lane * 2];
> +		params->host[lane].deemphasis = deemphasis[lane * 2];
> +		params->host[lane].precode_en = precode_en[lane * 2];
> +
> +		params->device[lane].preshoot = preshoot[lane * 2 + 1];
> +		params->device[lane].deemphasis = deemphasis[lane * 2 + 1];
> +		params->device[lane].precode_en = precode_en[lane * 2 + 1];
> +	}
> +
> +	params->is_valid = true;
> +	params->is_static = true;
> +}
> +
> +static void ufshcd_parse_static_tx_eq_settings(struct ufs_hba *hba)
> +{
> +	const u32 lpd = hba->lanes_per_direction;
> +	const u32 num_elems = lpd * 2;
> +	int gear;
> +
> +	if (!lpd) {
> +		return;
> +	}

Redundant braces.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
