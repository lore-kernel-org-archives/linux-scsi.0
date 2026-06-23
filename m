Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F66397352;
	Tue, 23 Jun 2026 06:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782196645; cv=none; b=Ap/bu28VxN9HSDItbHt3Iim5f4FTQkvtxgR88v1+MMV9jMslJcb+8UWsHsEREGFpNFWk1Lf0YuxQY0D5Ojxdb+QJvTGO+a32Zp8Yqr1a1Npyv6ywgwlIy/Ch4vQ6EDrPnDWiaPKGi30D2lOPETNZJLYD5tU5GGI9HJ6NRcjCWMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782196645; c=relaxed/simple;
	bh=Q4CZJt443Id/t6Hrsq+nsMVaVgwyUTUdaxdoMTNUq14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ON/2td0WBfgBIJQtHL/kWGE6FPvKpHICSrjl/kKfyGu/dLYYpPRwfMPhjvmPrWmfxQ5bafxWySlB7F45opwXyXNNKCAzCe8jzc5lIJumR5CDxxCpLladCmwOs4zzZMBhyzcIBUc08iR4XTnhuzu/4p09XpUnL6Z+GbQNa78Szgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MUzwf90+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MUzwf90+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E66B1F000E9;
	Tue, 23 Jun 2026 06:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782196643;
	bh=HBmE3QByzYc8paAmAOTxXgrEIWQ2GbkLp1XEN2YtrSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MUzwf90+JwUj3oX53rzaEUo7Eafg7wYNjkwWRUX4vOyMbgvO4SOoP630qJ8hyVgzQ
	 Q1IHKv5BYPYj8tmddyu+drgBGqUZF+rdFda5/ljhEKG9FNsYxuzdLcnnzY1K9fK/fH
	 VZ+uFtmIpMF111dPig8Pi6ivEOdtISDeTkSZdrhCwwUieb5jXOJEnS6A4Qbnay/Knn
	 6Vmye3vhJsdbCxjvfHxEBngtj0lbF7vxwixtLAeaQPPU9+QgsMyIaZeNEK77/v7DXy
	 dsqaDAwFSDQ6g3Rd+d/UCDz4U/vjLdaHAsXvpqT2/i8jHnBY/Vo8xkn7XQmu4Z4u9N
	 6nuf8aQqBc45A==
Date: Tue, 23 Jun 2026 08:37:14 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] scsi: ufs: core: Tolerate RX_FOM read failures in TX
 EQTR
Message-ID: <lyexmz7ldpw2jzfwpg6f725kcvtkdzygkkeyrbilyfostgyvt7@6ftnkxnrfo6w>
References: <20260620080322.3765210-1-can.guo@oss.qualcomm.com>
 <20260620080322.3765210-3-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260620080322.3765210-3-can.guo@oss.qualcomm.com>

On Sat, Jun 20, 2026 at 01:03:21AM -0700, Can Guo wrote:
> ufshcd_get_rx_fom() aborted TX EQTR when a per-lane RX_FOM DME read failed.
> That makes the whole training flow fragile even though these reads can be
> treated as best effort.
> 
> Keep TX EQTR running by logging RX_FOM read failures and continuing.
> Make failed lanes deterministic by initializing each lane FOM to 0 before
> reading and only updating it when the DME read succeeds. This avoids
> propagating stale or uninitialized values into EQTR evaluation.
> 
> Also update the kerneldoc return description to match behavior: RX_FOM
> DME read failures are logged for debug visibility, while get_rx_fom()
> vops failures are still propagated to the caller.
> 
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
>  drivers/ufs/core/ufs-txeq.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
> index 9dca0cd344b8..23a12e221d31 100644
> --- a/drivers/ufs/core/ufs-txeq.c
> +++ b/drivers/ufs/core/ufs-txeq.c
> @@ -482,7 +482,9 @@ static void ufshcd_evaluate_tx_eqtr_fom(struct ufs_hba *hba,
>   * @h_iter: host TX EQTR iterator data structure
>   * @d_iter: device TX EQTR iterator data structure
>   *
> - * Returns 0 on success, negative error code otherwise
> + * Returns 0 on success, negative error code if get_rx_fom vops fails.
> + * RX_FOM DME get failures are debug-logged and treated as 0 FOM for
> + * that lane.
>   */
>  static int ufshcd_get_rx_fom(struct ufs_hba *hba,
>  			     struct ufs_pa_layer_attr *pwr_mode,
> @@ -494,22 +496,30 @@ static int ufshcd_get_rx_fom(struct ufs_hba *hba,
>  
>  	/* Get FOM of host's TX lanes from device's RX_FOM. */
>  	for (lane = 0; lane < pwr_mode->lane_tx; lane++) {
> +		h_iter->fom[lane] = 0;
>  		ret = ufshcd_dme_peer_get(hba, UIC_ARG_MIB_SEL(RX_FOM,
>  					  UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane)),
>  					  &fom);
> -		if (ret)
> -			return ret;
> +		if (ret) {
> +			dev_dbg(hba->dev, "Failed to get FOM for Host TX Lane %d: %d\n",
> +				lane, ret);
> +			continue;
> +		}
>  
>  		h_iter->fom[lane] = (u8)fom;
>  	}
>  
>  	/* Get FOM of device's TX lanes from host's RX_FOM. */
>  	for (lane = 0; lane < pwr_mode->lane_rx; lane++) {
> +		d_iter->fom[lane] = 0;
>  		ret = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(RX_FOM,
>  				     UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane)),
>  				     &fom);
> -		if (ret)
> -			return ret;
> +		if (ret) {
> +			dev_dbg(hba->dev, "Failed to get FOM for Device TX Lane %d: %d\n",
> +				lane, ret);
> +			continue;
> +		}
>  
>  		d_iter->fom[lane] = (u8)fom;
>  	}
> -- 
> 2.34.1
> 

-- 
மணிவண்ணன் சதாசிவம்
