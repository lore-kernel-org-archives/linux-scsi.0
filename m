Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7661A49B457;
	Wed, 30 Sep 2026 10:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790765078; cv=none; b=LuwcePwskzuP/n2XAa+imrPvSbCKq32ntOyBA5ZyEuOe21xfl+naRpwsN+xT1oHCekrHrm1DH5OOzUL/PK0PHD57GrvWMD0ljCF618cququehDxNmWgt2E25tVo2CVBuAHXLIIOTWAhdGjam5UO9/RwjwqDaWItbMo4XLkHgJOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790765078; c=relaxed/simple;
	bh=9b9FXd2Dsvtv7SjFTgYz9u9wdklIXRKhI7M3MVczEG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BoBxGbrNNxGEn/ne4Rk6Nsvh5AhBXU93qGDYqZDg+wF9VMuSmGP8T8GGP9dG3cIqsI6tCvHyKk3OO6Jk453zTbDsp1MECQUGjMrCGxQCBuBConQY9FMMmoQyvfu3ZAx+fmSuyzOHwsmukcqD953wQhphI0xS7TAGmJb+oe33D1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bMxD8GDE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bMxD8GDE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB381F0089A;
	Wed, 30 Sep 2026 10:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790765071;
	bh=lCz2+PCUXm0HJA+PW6kXsFNSKj+UYr06WTU06j5a4bA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bMxD8GDEHXc0imS5O4o6vwp3hVDXxlmK9cm/0FNa7ot6LNUjB7lsWkGlENh0oBBl6
	 8M4MoehUk9JXlD9RQo7Vdml+U27I7FeJKx01bydyStz6cC+PjEEyOm1/l8Un/+U5HZ
	 1vMUuiFtLmdilK0rRxDPF5x+dNoN435/3dRfv5Ljgnl7slEMU5X9M+A69HQgjKly+F
	 SDq/3VHomhOjktZ/gqQrNOFOJ+MaI22G6jNW3ysUr9bBxW+axALw/awtRCUKwFZiAO
	 rPk3SDdfpaHk0VLLgYcwsYxq45I3NsJYO3D8evK3GioNjNbAx/5x0OPtKKwrcem0Vf
	 HlhLWkvbqp6aw==
Date: Wed, 30 Sep 2026 12:44:27 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Kartik Rajput <kkartik@nvidia.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Thierry Reding <thierry.reding@kernel.org>, 
	Jonathan Hunter <jonathanh@nvidia.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, 
	Thierry Reding <treding@nvidia.com>, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] scsi: ufs: tegra: Add Tegra264 UFS host
 controller driver
Message-ID: <20260930-peach-slug-of-strength-ec0db8@quoll>
References: <20260929-tegra264-ufs-v2-0-f0467b9c503e@nvidia.com>
 <20260929-tegra264-ufs-v2-4-f0467b9c503e@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260929-tegra264-ufs-v2-4-f0467b9c503e@nvidia.com>

On Tue, Sep 29, 2026 at 03:15:10PM +0530, Kartik Rajput wrote:
> Add a driver for the UFS host controller found on NVIDIA Tegra264 SoCs.
> The controller has Tegra-specific auxiliary registers, clocks and resets,
> and it drives the four M-PHY lane directions exposed by the Tegra264
> M-PHY driver.
> 
> Co-developed-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
> ---
>  drivers/ufs/host/Kconfig     |  14 +
>  drivers/ufs/host/Makefile    |   1 +
>  drivers/ufs/host/ufs-tegra.c | 686 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 701 insertions(+)
> 
> diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
> index ff170c0b6da0..7ca317d25251 100644
> --- a/drivers/ufs/host/Kconfig
> +++ b/drivers/ufs/host/Kconfig
> @@ -168,3 +168,17 @@ config SCSI_UFS_AMD_VERSAL2
>  
>  	  Select this if you have UFS controller on AMD Versal Gen 2 SoC.
>  	  If unsure, say N.
> +
> +config SCSI_UFS_TEGRA
> +	tristate "NVIDIA Tegra264 UFS controller platform driver"
> +	depends on SCSI_UFSHCD_PLATFORM
> +	depends on ARCH_TEGRA_264_SOC || (COMPILE_TEST && 64BIT)
> +	select PHY_TEGRA_MPHY

Nope.

There is nothing here which depends on the phy. If there is, you wrote
this wrong and did not use proper Linux interfaces (the Generic PHY).

Also, you must NOT select user-visible symbols, that's basic rules now.

Best regards,
Krzysztof

