Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1BE2D978A
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 16:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764262789; cv=none; b=h+hUALQkaLw45NYvkWoe0GhJmqvucyxj6aj+hHtmI6gGI9rWCCXB6TiaiEynwPSzcox6BSMvX+2IVlG8uF02JRKFoqf0Zn1HJ3o4fkzABdSn30IU0Otcx57Zb14EiCgOvOb9V+ohAHJqRjNXCfHX9KOAn2B5SrRg5d56nzVzLyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764262789; c=relaxed/simple;
	bh=w8YSUIQcvr0OXtoBuy3njN2kN7BA/vW8sDA200mQepM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HUFTjskhXFrqBArvO/Wc3NiMn0K0/6BCkTv8eY/1N6THDc54NK1JYF3YIEwK1NFWFcCwWm7WWeB1JVA3VGIY84ynguWXV3DLV3A6Bb5KwjhYi1ZJidjCshKgqAD+fDqlIpElrUjfNpIZdrGtycBJz7LojQx9AM5ywG9oxkpGa/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=grGwYD9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="grGwYD9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A105BC4CEF8;
	Thu, 27 Nov 2025 16:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764262786;
	bh=w8YSUIQcvr0OXtoBuy3njN2kN7BA/vW8sDA200mQepM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=grGwYD9NIkD5aYV/zJCqjfyq7FhSgTQYZ+I7QHvGnkhq0VpEaUUPwk7UGBrM1XJ5Z
	 4NODWBFdLjHlac/5pV4uh+m2LWFcm3udJAOAguZg/02L704iw7xKoxPXETIzevkBYr
	 F4qXkYfx8HAhn3PplMN/4GFTx8pQnBWAuvALTRPV+EVkHll5h12k1vJOF2+YYm5rCf
	 BjZOBAsdzyzDbsiMaRKG1+CfxrShGDjTfz2dIfC+yAwK78Il3mtyNmeX6XxAdLVq8T
	 70kQs0l5H7gfp3zK67A7r50SB3YKbwcnnDJjzCNWd/QJTHj8D3xNJYE9/14XrYj1H/
	 Fbag7i16RZhvA==
Date: Thu, 27 Nov 2025 22:29:35 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
Message-ID: <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251031204029.2883185-22-bvanassche@acm.org>

On Fri, Oct 31, 2025 at 01:39:29PM -0700, Bart Van Assche wrote:
> Instead of letting the SCSI core allocate hba->nutrs - 1 commands, let
> the SCSI core allocate hba->nutrs commands, set the number of reserved
> tags to 1 and use the reserved tag for device management commands. This
> patch changes the 'reserved slot' from hba->nutrs - 1 into 0 because
> the block layer reserves the smallest tags for reserved commands.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Hi,

While the issue introduced by this patch was fixed in [1], this patch (and the
fix) somehow prevents mounting rootfs on Qcom RB3Gen2 board. The UFS partitions
are detected, but rootfs is not getting mounted and the boot just got stuck.
I collected the logs, but nothing much useful as there is no error/warning:
https://gist.github.com/Mani-Sadhasivam/396ef4a636d3b0140e7f07595bd41e4f

If I revert this patch, together with the dependencies, rootfs is getting
mounted properly.

Any inputs would be appreciated.

- Mani

[1] https://lore.kernel.org/linux-scsi/20251114193406.3097237-1-bvanassche@acm.org/

> ---
>  drivers/ufs/core/ufshcd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index f6eecc03282a..20eae5d9487b 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2476,7 +2476,7 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
>  	hba->nutrs = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS_SDB) + 1;
>  	hba->nutmrs =
>  	((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >> 16) + 1;
> -	hba->reserved_slot = hba->nutrs - 1;
> +	hba->reserved_slot = 0;
>  
>  	hba->nortt = FIELD_GET(MASK_NUMBER_OUTSTANDING_RTT, hba->capabilities) + 1;
>  
> @@ -8945,7 +8945,6 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
>  		goto err;
>  
>  	hba->host->can_queue = hba->nutrs - UFSHCD_NUM_RESERVED;
> -	hba->reserved_slot = hba->nutrs - UFSHCD_NUM_RESERVED;
>  
>  	return 0;
>  err:
> @@ -9184,6 +9183,7 @@ static const struct scsi_host_template ufshcd_driver_template = {
>  	.proc_name		= UFSHCD,
>  	.map_queues		= ufshcd_map_queues,
>  	.queuecommand		= ufshcd_queuecommand,
> +	.nr_reserved_cmds	= UFSHCD_NUM_RESERVED,
>  	.mq_poll		= ufshcd_poll,
>  	.sdev_init		= ufshcd_sdev_init,
>  	.sdev_configure		= ufshcd_sdev_configure,

-- 
மணிவண்ணன் சதாசிவம்
