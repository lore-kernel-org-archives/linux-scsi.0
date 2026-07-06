Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F3F3A6412;
	Mon,  6 Jul 2026 15:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783352699; cv=none; b=uMyQDjgYORG1PaOLxKRa6XrZdZZETc/cO/78A6TLvUBKW9Lj1lUrgEzPpiNzXGxoY8TpugxvUlhemx4/F/sDbhj+CsewSTMSsJQessOtErQR4WVNtByis/pny4h9IMixtOJYT7w5Pbs1UnxsGQkaHQk3Nk0o9th1OsSqRH75DKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783352699; c=relaxed/simple;
	bh=511R11LYjOzQzVbepT9caDpbIOxlSuhy66D/ZPY2TNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PeKi5HPCQjaTzec+quUZDVlaY9xR+JKn+MDF/kuwKzU1iyFwrkQq5niK93vgkp2LgqExWIKMSw11F5AcW/14jlhWMTQZl3Nd+SX3IXdQOMXEKCyJ3nVu6vSZV3VsctNlWJUY2lESkLYRi6ydj63QCXezbuS9VIrmHknQspOR1Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HENOhOJQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HENOhOJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2760F1F00A3D;
	Mon,  6 Jul 2026 15:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783352697;
	bh=B+QafvzKcmkbe/vB2mZ7imHvd1YjyqLfJAKS3svHs6g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HENOhOJQSxAGgJ8ISWGePG95mFkJTfbz42cn7IvTb/mUFxVVfvi+wYLz8Bhw8D5+H
	 qbk7kwPjfCfAqvBg2047Js9c4ZhUt49p5cx+w/AwoRfiMlEPcNPNTHTMqUZygwJ33p
	 e8e2DG0kW79o5rtd1hrLtuLeKdfxFa70dc+i5ClvPxp9TfyIZ8IQ6UiAqa305BIhFn
	 3w1iX946iMJZ8wM3G//rt72yG4zeXaercXj1S9i8zXCbZfDZ3d57c9W/U8sFkQQmfF
	 TFgUAElsSdNMSGQQw1FL0TksPoObm9qz/SGbb3USv/NEd9TlsteJAlkWwVeM8STgDS
	 +IUcnn4B/HlvA==
Date: Mon, 6 Jul 2026 17:44:49 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: ufs: core: Avoid possible memory reclaim
 deadlock in TX EQTR context
Message-ID: <h5lsilzmxhu3jyujladib3w75nsute7yrkr4t5sg57nwzwb2ek@d4btnbylvrvu>
References: <20260618140941.902000-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260618140941.902000-1-can.guo@oss.qualcomm.com>

On Thu, Jun 18, 2026 at 07:09:29AM -0700, Can Guo wrote:
> TX EQTR may run while devfreq gear scaling has quiesced the UFS tagset. In
> that context, functions ufshcd_tx_eqtr(), __ufshcd_tx_eqtr() and
> ufs_qcom_get_rx_fom() allocate memory with GFP_KERNEL. If direct reclaim
> is triggered, reclaim/writeback can depend on I/O to UFS device. Because
> the queue is quiesced, this can cause deadlock.
> 
> Use memalloc_noio_save/restore() in ufshcd_tx_eqtr() to cover all
> allocations in the TX EQTR call tree, including:
> - params->eqtr_record in ufshcd_tx_eqtr()
> - eqtr_data in __ufshcd_tx_eqtr()
> - params in ufs_qcom_get_rx_fom()
> 
> This is preferred over tagging individual call sites with GFP_NOIO, as it
> automatically covers any future allocations added anywhere in the call
> tree without requiring each caller to be aware of this constraint.
> 
> Fixes: 03e5d38e2f98 ("scsi: ufs: core: Add support for TX Equalization")
> Closes: https://sashiko.dev/#/patchset/20260615132834.2985346-1-can.guo@oss.qualcomm.com?part=2
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
> v1 -> v2:
> - Replaced per-allocation GFP_NOIO usage with memalloc_noio_save/restore()
>   around ufshcd_tx_eqtr() call tree.
> 
>  drivers/ufs/core/ufs-txeq.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
> index 4b264adfdf49..9dca0cd344b8 100644
> --- a/drivers/ufs/core/ufs-txeq.c
> +++ b/drivers/ufs/core/ufs-txeq.c
> @@ -10,6 +10,7 @@
>  #include <linux/delay.h>
>  #include <linux/errno.h>
>  #include <linux/kernel.h>
> +#include <linux/sched/mm.h>
>  #include <ufs/ufshcd.h>
>  #include <ufs/unipro.h>
>  #include "ufshcd-priv.h"
> @@ -1212,14 +1213,25 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
>  			  struct ufs_pa_layer_attr *pwr_mode)
>  {
>  	struct ufs_pa_layer_attr old_pwr_info;
> +	unsigned int noio_flag;
>  	int ret;
>  
> +	/*
> +	 * ufshcd_tx_eqtr() is called from a power-mode-change context where
> +	 * I/O is suspended. Use memalloc_noio_save() to propagate GFP_NOIO
> +	 * to all allocations in the call tree instead of tagging each call
> +	 * site individually.
> +	 */
> +	noio_flag = memalloc_noio_save();
> +
>  	if (!params->eqtr_record) {
>  		params->eqtr_record = devm_kzalloc(hba->dev,
>  						   sizeof(*params->eqtr_record),
>  						   GFP_KERNEL);
> -		if (!params->eqtr_record)
> -			return -ENOMEM;
> +		if (!params->eqtr_record) {
> +			ret = -ENOMEM;
> +			goto out_noio_restore;
> +		}
>  	}
>  
>  	memcpy(&old_pwr_info, &hba->pwr_info, sizeof(struct ufs_pa_layer_attr));
> @@ -1244,6 +1256,9 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
>  	if (ret)
>  		ufshcd_tx_eqtr_unprepare(hba, &old_pwr_info);
>  
> +out_noio_restore:
> +	memalloc_noio_restore(noio_flag);
> +
>  	return ret;
>  }
>  
> -- 
> 2.34.1

-- 
மணிவண்ணன் சதாசிவம்
