Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F552199FB0;
	Wed, 27 May 2026 07:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779868631; cv=none; b=NYDBLEU3MBjtJEBcrRS9bUXtzi66t2Rm6Y6zUlDSBZKg9Ai5SkexcSeoJ6FMPeL6N25W8s5DMSZi8i9Kr55a9jFCSlp3Q/641RdBz+mCYeCTWoM/W/z32zRqeGv/ds9rQPP/SLMUIUvtuci4sbwSLMwd8RBVa2gLXrTlTqpyFFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779868631; c=relaxed/simple;
	bh=cDQn5s2+jaJMx8GvfvQuZ2kwZgL69T7ZvP8ZFvF9vJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n8++Z+lpZ4I10fJhaOkT0irKdnqI3MG8n0g0h29lVU3+J31+7V4RY1plbOQWDvnBpIXQUnpxRjpmCNrnQNh+8WIQRB7Zc3+I8zbqo/p8JTYo7mhgckYYIlr7CPVsUH+dL/lEVtwUsJqcLsOxZKLk5QDzI56vLfDTCTl0mSCbfas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RmLVpH4l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RmLVpH4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5ADF1F000E9;
	Wed, 27 May 2026 07:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779868630;
	bh=1uKbyYIwX7h0BeN9LJO6kkfvGyCBieMmhCP+iJayVU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RmLVpH4lmGMuAFrpfK6EMEJ6XjWchxnmA2gI0FLiHueRFbqP2UGgaF/PcpeS78iPg
	 8bA1slGvWZ8T2KOZQf1CqGKWm+LiUSUrTqQSmTda/ZG6Ktm45u6OJRz4KCxmOzLnYJ
	 g38MTdPNvG/Chb1T/udZAk30/5e3jew8v+hZdF/I79mwVYna4Zt5aUBVMJ2uY2uTli
	 FYbKJnCf86Sv+Fn/6a21PMjYafV9st8H0kUAffbROsiicMO+pT2zbrO9tl0XBG4pL1
	 Yb7c4Pno0FLLC6FsKzVG6R0R00QoyxFz4o5PHK529iof7TsMuxg7o8vEqy0BYhzPBz
	 4hquflT2M2vhA==
Date: Wed, 27 May 2026 09:57:04 +0200
From: "mani@kernel.org" <mani@kernel.org>
To: Daejun Park <daejun7.park@samsung.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, 
	"James.Bottomley@HansenPartnership.com" <James.Bottomley@hansenpartnership.com>, "bvanassche@acm.org" <bvanassche@acm.org>, 
	"avri.altman@wdc.com" <avri.altman@wdc.com>, ALIM AKHTAR <alim.akhtar@samsung.com>, 
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>, 
	"palash.kambar@oss.qualcomm.com" <palash.kambar@oss.qualcomm.com>, "shawn.lin@rock-chips.com" <shawn.lin@rock-chips.com>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: core: Skip link param validation when
 lanes_per_direction is unset
Message-ID: <ffvttcdm3ghy7ryy53eu65mmujm52kn6w2va3jbjhkytgx6ybk@qhqutom6vatg>
References: <CGME20260520070009epcms2p6542f3abb7660839e9d8140b3f2f145c3@epcms2p6>
 <20260520070009epcms2p6542f3abb7660839e9d8140b3f2f145c3@epcms2p6>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260520070009epcms2p6542f3abb7660839e9d8140b3f2f145c3@epcms2p6>

On Wed, May 20, 2026 at 04:00:09PM +0900, Daejun Park wrote:
> ufshcd_validate_link_params(), added by commit e72323f3b09f ("scsi: ufs:
> core: Configure only active lanes during link"), is called
> unconditionally from ufshcd_link_startup() and fails link startup with
> -ENOLINK when the connected lane count read from the device differs from
> hba->lanes_per_direction.
> 
> lanes_per_direction is only set by ufshcd-pltfrm (default 2, or the
> "lanes-per-direction" devicetree property); ufshcd-pci controllers
> (e.g. Intel) leave it 0. As the device always reports >= 1 connected
> lanes, the check can never match and link startup always fails.
> Reproduced with QEMU's UFS device.
> 
> Skip the check when lanes_per_direction is unset: with no expected value
> to validate against, restore the behaviour from before that commit.
> 
> Fixes: e72323f3b09f ("scsi: ufs: core: Configure only active lanes during link")
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
>  drivers/ufs/core/ufshcd.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 1aad1c03c3fc..0a510f43ce76 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5222,6 +5222,16 @@ static int ufshcd_validate_link_params(struct ufs_hba *hba)
>  {
>  	int ret, val;
>  
> +	/*
> +	 * lanes_per_direction is only populated by the platform glue (it
> +	 * defaults to 2 or is read from the "lanes-per-direction" devicetree
> +	 * property). Controllers probed via ufshcd-pci leave it unset (0), in
> +	 * which case there is no expected lane count to validate the connected
> +	 * lanes against. Skip the check instead of failing link startup.
> +	 */
> +	if (!hba->lanes_per_direction)
> +		return 0;
> +
>  	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
>  			     &val);
>  	if (ret)
> 
> base-commit: 016d484531e3169cd7bcb26e0ac2c5523080809f
> -- 
> 2.43.0
> 

-- 
மணிவண்ணன் சதாசிவம்
