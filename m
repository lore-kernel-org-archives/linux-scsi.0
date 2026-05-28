Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669FC23BCF7;
	Thu, 28 May 2026 06:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779948788; cv=none; b=sVJrpW4QetF1PPF6xqWUr7RClFnQV2JSr9Ubhmovgiu2p30zGwMAdLOZsuAHFqK2WTCFd6vqbzDfbmUXoTs1xi3VXZ5RJbvqXwmsG/Ad6IhzREFTAYP+gPS3RdCs9dpTbwJiRk+STIKqyuKpDnqAjdV2xzXTXlM3ExpQ3aUXsBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779948788; c=relaxed/simple;
	bh=M1lIOw8RzUbSX4Fp/xeOTV5F6Sv9JqyletuypNe00MI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iC6ctVkjGF1SP9TJ22NXF0lWKQNWMrh7DJs4X3AcAV7CGF+CXHQrfLw98ef1P8FfDh53Wl+4APJx5HUChG0I/782DTrJmklkg8PNlpM+wiCVLKqI0iJXmBMwcHH+j2dPXinPkz6zxEMzGM2fyXX+cKcGtZiENZpAF1Zcezhos1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kNTIMc4F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kNTIMc4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903141F000E9;
	Thu, 28 May 2026 06:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779948787;
	bh=uj1fx2qM/+eb3hzxTDik5JCa4rgScj7oUgppfD3IGww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kNTIMc4F/LGP+smu50Sgn5LYie+S9H8Abs/9DLwCqc0tJZ6gQGhVmgNupyeEla4gx
	 ODEdPLnbOUwjLq5LUqMi5DaeeCLsCIi0QFS7UFInZ4drSPGxg4S4NzFGO5OWpOeBdb
	 7niizjq6/rfepo5oBGcnKOrmD7zBVa3+/LmzKD+Px0WSMTnlKgQXWp0uuwB4BfpUzT
	 iIfS1PY4d2D03x3fU5sBz0D5Y8gdnaTCK3/NQo9ZNSK9gDID3iJMRwdcB/50wpC9dn
	 W17IFHxIRSf8kj86fYk4E6Yv+OPEM2I9fJbYHSk/nPmBFbgvIAeOFY82bKB0yYeAIa
	 1QQOc86x8VW8g==
Date: Thu, 28 May 2026 08:13:01 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>, 
	Nitin Rawat <quic_nitirawa@quicinc.com>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
Message-ID: <mt2asdx4vnuxo3eodrc7dlfdtv3b5bpjfvxxglmncny36otfav@htri3l5q4ba3>
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

Maybe it's me, but I'm not able to understand how you want to apply these static
EQ settings. In commit message you said, the static values should be used as a
fallback, but you just check for 'params->is_static' while triggering
ufshcd_tx_eqtr() which is supposed to perform adaptive TX EQ training. IMO, you
don't need any check at all for applying static setting. If '(!params->is_valid
|| force_tx_eqtr)' condition is not satisfied, then the static setting should be
used.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
