Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C315314B76;
	Tue, 23 Jun 2026 06:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782196417; cv=none; b=eXuWwJXpZGfqk9F9+fExhSyxSZHwGSezqTIMSY6g9asYMvsZaEsale55fFzUnMZB2nvv2QSBbT5uPs5Y7UTn82/Fl3qDlstAlwFsMJ8xbJSd91350f8GFajJzeOiS0I7XHP51DYCCcdojQ3Hqs0a73O73+FVlPHpccrmvvnS+GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782196417; c=relaxed/simple;
	bh=unHidGKrvaOpMkqzdsAS+bgVQsQ+I5bc+1nM1sLdqNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e2/l9fxzVb6J9DVxyfkEE6kTTO7cD17P2K0VbVJU+llLNjdBhyPDSgRGM0cZ2Rjzcdx7oKnPTROk8qLIQ39ofjI5pPpFvZji45mHQWn+AtYgBC9gFl7qyjSDHJKuctw6Qo8mTQXULzVR/yWf3uoj7cjkqb2YLeUW9Ww74qo5I0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DqeVfJ0t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DqeVfJ0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F701F000E9;
	Tue, 23 Jun 2026 06:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782196415;
	bh=TJVx3Nd5w3IxezMNcxefyA9B50Vx2xuvEct5vcFTeJ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DqeVfJ0tot+jLCX6K1vzNcv2T29W7RyMtjPf7NVp/9pt9IzFx+KhjWKWV04o0TdyD
	 F3+YN8grie5LUjpE6qHN9vgsXG8XB5Xhx9pukzJLTGku+zRUDnNBALfuiXe7GFE/Y5
	 flUyeP8xdIfpkbj+yv4nynr8sMlmF76SaQ1tCMWEvEkkk3tXGJvDvPll1Z1+2Z+o54
	 1wRX7EEcKWKAW/hgaRYQcradMUHG71ODsec7iSkjxM74A6qrabjnKjq8+SRQ+B98W+
	 X9yT+DZyJSKZrj67CpWT19BKRagnEdL47PlEPbHExCfuL9uYy+tN4Cu4KXJIQGyRne
	 BalO43mTS8RDw==
Date: Tue, 23 Jun 2026 08:33:26 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER..." <linux-arm-msm@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] scsi: ufs: ufs-qcom: Restore TX Equalization
 settings on FOM failure
Message-ID: <3e6codiksnngi442bitbvzgs222hl5poqi7o7chtt4ulnq7na3@4otqpolqzhbs>
References: <20260620080322.3765210-1-can.guo@oss.qualcomm.com>
 <20260620080322.3765210-2-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260620080322.3765210-2-can.guo@oss.qualcomm.com>

On Sat, Jun 20, 2026 at 01:03:20AM -0700, Can Guo wrote:
> ufs_qcom_get_rx_fom() applies temporary device TX Equalization values
> before forcing HS mode and running the EOM-based SW FOM scan.
> 
> When one of these steps fails, the function can bypass the shared
> cleanup path and leave temporary TX Equalization settings programmed.
> 
> Route those failures through the cleanup label so the original TX EQ
> settings are restored and link recovery runs before exit.
> 
> This path also reuses ret for cleanup, so it may overwrite the original
> error. Keep that on purpose: if cleanup succeeds, the caller can proceed
> with the FOM result for the current iteration.
> 
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index c084ccc72523..7d7c001435bf 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -2791,7 +2791,7 @@ static int ufs_qcom_get_rx_fom(struct ufs_hba *hba,
>  	if (ret) {
>  		dev_err(hba->dev, "%s: Failed to apply TX EQ settings for HS-G%u: %d\n",
>  			__func__, gear, ret);
> -		return ret;
> +		goto link_recover_and_restore;

IIUC, if ufshcd_apply_tx_eq_settings() fails, then it means the TX EQ settings
were not applied. So do we really need to restore the original TQ EQ here?

>  	}
>  
>  	/* Force PMC to target HS Gear to use new TX Equalization settings. */
> @@ -2799,16 +2799,15 @@ static int ufs_qcom_get_rx_fom(struct ufs_hba *hba,
>  	if (ret) {
>  		dev_err(hba->dev, "%s: Failed to change power mode to HS-G%u, Rate-%s: %d\n",
>  			__func__, gear, ufs_hs_rate_to_str(rate), ret);
> -		return ret;
> +		goto link_recover_and_restore;
>  	}
>  
>  	ret = ufs_qcom_host_sw_rx_fom(hba, pwr_mode->lane_rx, fom);
> -	if (ret) {
> +	if (ret)
>  		dev_err(hba->dev, "Failed to get SW FOM of TX (PreShoot: %u, DeEmphasis: %u): %d\n",
>  			d_iter->preshoot, d_iter->deemphasis, ret);
> -		return ret;
> -	}
>  
> +link_recover_and_restore:
>  	/* Restore Device's TX Equalization settings. */
>  	ret = ufshcd_apply_tx_eq_settings(hba, &hba->tx_eq_params[gear - 1], gear);
>  	if (ret) {

'ret' will be overridden here and '0' might be returned to the caller.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
