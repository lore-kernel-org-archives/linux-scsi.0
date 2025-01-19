Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690712913;
	Sun, 19 Jan 2025 07:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737273466; cv=none; b=pVPgBrSbBmyVINVZKz6sGETAd9EEkr5npbU3nuN8rYZy1nZHGfoEbz8dhd/AZykZ080u1qVtKzJM+S51JtV2qwgiLHaL1AYVBsoPKFpYcXHS1QObaN2+qx3E19sc9i3pq7ZDlvXIafaDzzngbGInPe86b2Ta8p8G6YPUpTspBLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737273466; c=relaxed/simple;
	bh=WhZPPkqDkAojKGZjphwsBAaMUBDzAEWSrFqrmjWwtJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IXhGoN6SI4iW63OIlOnZM3whKGEh0AhBbtGMkm+D0KhWjrRjaWeQGtqm+l857Gp8nC8oLlWLamYanjtLoYnd8VDEJfTQ/fE+ddVcu23mUhNTTXbe56JAexQGRjQ7YVs+kEF/pKa79ifqOjEyM+YBnsFAi71ZLkAhbn4Q4ljzpQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vElZ1u7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vElZ1u7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCF3C4CED6;
	Sun, 19 Jan 2025 07:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737273465;
	bh=WhZPPkqDkAojKGZjphwsBAaMUBDzAEWSrFqrmjWwtJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vElZ1u7QRlkEA9UcsOaPxNbdib4xryud9IhBPaAvkYyEcWznzS9WYlLe8ZiDySkJL
	 Jafje7xYAonrFwMc1IMvOs9xcw/yAup8rqHGkRoSOLXN4GEY36dljzY243RtN8CqXK
	 jM19qnyVfNW9JkrVaNZOM6JWysltI/lc+QTNsjAVqLgR+U4IomxMh8LPOb+zjQoize
	 L3y4jobUsg9/McnsAqMi1DdxNgUn0aXYoCDkIKo9lUXTBI5ZD7IkMxQxpAchleyvMJ
	 WLmc8x4cPCIBvBF9LcXqkA84rjWtBvB10YDCriCkUvgJg1pv29/CTvLIrKqQziyjHj
	 g4x4uYTs8k9WQ==
Date: Sun, 19 Jan 2025 13:27:36 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Ziqi Chen <quic_ziqichen@quicinc.com>
Cc: quic_cang@quicinc.com, bvanassche@acm.org, mani@kernel.org,
	beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
	martin.petersen@oracle.com, quic_nguyenb@quicinc.com,
	quic_nitirawa@quicinc.com, quic_rampraka@quicinc.com,
	linux-scsi@vger.kernel.org,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"open list:ARM/Mediatek SoC support:Keyword:mediatek" <linux-kernel@vger.kernel.org>,
	"moderated list:ARM/Mediatek SoC support:Keyword:mediatek" <linux-arm-kernel@lists.infradead.org>,
	"moderated list:ARM/Mediatek SoC support:Keyword:mediatek" <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH 0/8] Support Multi-frequency scale for UFS
Message-ID: <20250119075736.cyjgpglf4azrmprv@thinkpad>
References: <20250116091150.1167739-1-quic_ziqichen@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250116091150.1167739-1-quic_ziqichen@quicinc.com>

On Thu, Jan 16, 2025 at 05:11:41PM +0800, Ziqi Chen wrote:

You missed CCing linux-arm-msm mailing list to the cover letter.

> With OPP V2 enabled, devfreq can scale clocks amongst multiple frequency
> plans. However, the gear speed is only toggled between min and max during
> clock scaling. Enable multi-level gear scaling by mapping clock frequencies
> to gear speeds, so that when devfreq scales clock frequencies we can put
> the UFS link at the appropraite gear speeds accordingly.
> 

But the UFSHC PHY settings are not updated for each gear speed, isn't it? Then
I'm wondering how much we get out of this 'multi-level gear scaling'.

- Mani

> This series has been tested on below platforms -
> SM8650 + UFS3.1
> SM8750 + UFS4.0
> 
> 
> Can Guo (6):
>   scsi: ufs: core: Pass target_freq to clk_scale_notify() vops
>   scsi: ufs: qcom: Pass target_freq to clk scale pre and post change
>   scsi: ufs: core: Add a vops to map clock frequency to gear speed
>   scsi: ufs: qcom: Implement the freq_to_gear_speed() vops
>   scsi: ufs: core: Enable multi-level gear scaling
>   scsi: ufs: core: Toggle Write Booster during clock scaling base on
>     gear speed
> 
> Ziqi Chen (2):
>   scsi: ufs: core: Check if scaling up is required when disable clkscale
>   ARM: dts: msm: Use Operation Points V2 for UFS on SM8650
> 
>  arch/arm64/boot/dts/qcom/sm8650.dtsi | 51 ++++++++++++++++----
>  drivers/ufs/core/ufshcd-priv.h       | 17 +++++--
>  drivers/ufs/core/ufshcd.c            | 71 +++++++++++++++++++++-------
>  drivers/ufs/host/ufs-mediatek.c      |  1 +
>  drivers/ufs/host/ufs-qcom.c          | 60 ++++++++++++++++++-----
>  include/ufs/ufshcd.h                 |  8 +++-
>  6 files changed, 166 insertions(+), 42 deletions(-)
> 
> -- 
> 2.34.1
> 

-- 
மணிவண்ணன் சதாசிவம்
