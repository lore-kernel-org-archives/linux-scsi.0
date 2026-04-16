Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5A7378D95;
	Thu, 16 Apr 2026 11:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776337959; cv=none; b=M1rJ+5oMkY7osr8OgzqHyHoesH9qXz0WGHFrQlX/t5afrJXOAX8bXt60PX82DPZ66TyJcPQiWPwx7VcMwacWuP9mVe3bbYK8NaRpXVezXOnzZtggu7P6W9T5gmmWSZNzJksH8UIT7k01SY+bKxkI3yfqSnn6UtZQo5SmC9Atkio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776337959; c=relaxed/simple;
	bh=1WqbQj66VpX2vwbzG11jliipQo7f1Ab/bkioXw1QT0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bfkpLhQAEW28OaRKwbANcZ2N5CPmPRxRXPLwWgu4EiFMAl+eCnoMmTbM69ZpwhfMJlWKzDgzprd6F+fiu6I14PzoJUobE6gT5ugrv2RWUgLF0q0i/yF9muaT+9h3+6tQB+BJ+oTs12Zmk/ROm2ldB84N2E3OB9PhINIG87rRU1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TWJwQfPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TWJwQfPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E30C2BCAF;
	Thu, 16 Apr 2026 11:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776337959;
	bh=1WqbQj66VpX2vwbzG11jliipQo7f1Ab/bkioXw1QT0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TWJwQfPd2fiYl3NnM/xHgUwtOwS/MIXwd+Y4GcCclBkmr53Q+m6GwV5sypZUYWnEV
	 +QlWA9t4VGBnme9lwbq5GPqjCK1U4L0QKaXv1DMC8+dC3nz+KF8KGNC5GgQaTD7Iw4
	 zyG8Dszyq3GhgL765nOTkOMcBabA3ubhDVj2NzO/Ts1cHe8NpnmE0bSsJaX8KnnzD2
	 klQQUSRgYcacopFyAOTkmM8KpMtODBVZKXcqpD/znnIZ/gKVNyidusN/J+GeYrsFWT
	 s0GghAutqNBwOs+8BR6KTJvYpKs68v1Kqpe/aekyNZYRKRepBoLQ030hebXC7AlDYi
	 2zRVmH9babR9A==
Date: Thu, 16 Apr 2026 16:42:31 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: palash.kambar@oss.qualcomm.com
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	bvanassche@acm.org, shawn.lin@rock-chips.com, linux-arm-msm@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, nitin.rawat@oss.qualcomm.com
Subject: Re: [PATCH V3 1/2] ufs: core: Configure only active lanes during link
Message-ID: <i6mbqvrhw2aggbrofp2p6kdhf3jfo4qdmpu72mhhkuqay4i3ua@hcnezixc2vhl>
References: <20260414093135.660725-1-palash.kambar@oss.qualcomm.com>
 <20260414093135.660725-2-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260414093135.660725-2-palash.kambar@oss.qualcomm.com>

On Tue, Apr 14, 2026 at 03:01:34PM +0530, palash.kambar@oss.qualcomm.com wrote:
> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
> 
> The number of connected lanes detected during UFS link startup can be
> fewer than the lanes specified in the device tree. The current driver
> logic attempts to configure all lanes defined in the device tree,
> regardless of their actual availability. This mismatch may cause
> failures during power mode changes.
> 
> Hence, Add a check during link startup to ensure that only the lanes
> actually discovered are considered valid. If a mismatch is detected,
> fail the initialization early, preventing the driver from entering
> an unsupported configuration that could cause power mode transition
> failures.
> 
> Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
> ---
>  drivers/ufs/core/ufshcd.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 31950fc51a4c..754bf4df3016 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5035,6 +5035,38 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val)
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_update_evt_hist);
>  
> +static int ufshcd_validate_link_params(struct ufs_hba *hba)
> +{
> +	int ret;
> +	int val;

ret, val

> +
> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
> +			     &val);
> +	if (ret)
> +		goto out;
> +
> +	if (val != hba->lanes_per_direction) {
> +		dev_err(hba->dev, "Tx lane mismatch [config,reported] [%d,%d]\n",
> +			hba->lanes_per_direction, val);
> +		ret = -ENOLINK;
> +		goto out;
> +	}
> +
> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDRXDATALANES),
> +			     &val);
> +	if (ret)
> +		goto out;
> +
> +	if (val != hba->lanes_per_direction) {
> +		dev_err(hba->dev, "Rx lane mismatch [config,reported] [%d,%d]\n",
> +			hba->lanes_per_direction, val);
> +		ret = -ENOLINK;

		goto out;

> +	}
> +

return 0;

> +out:
> +	return ret;
> +}
> +
>  /**
>   * ufshcd_link_startup - Initialize unipro link startup
>   * @hba: per adapter instance
> @@ -5108,6 +5140,11 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
>  			goto out;
>  	}
>  
> +	/* Check successfully detected lanes */

Drop the comment.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
