Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B8251FCC6
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 19:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788810068; cv=none; b=ZYcATl25D0FHNvCNz7FPvbJ+2w+WQ/7PDCdBrcDnidg63uN9rrOSQ0lQiVR819wcQpEG9U7L7p06HGbKBU9q4jBKdP0VPje8nlFViy9oLWGdsazeJdsHyZgWM+8QnsOJo2xwBXSa+MUhfjtlfZxMC7WdSUJ/BxFFqcQexzRFkaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788810068; c=relaxed/simple;
	bh=ehUDwUVWh2bA3FSXoqO30xNhR4umSccKcGPXvffsojQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sfoFWo79P3Zu/5JW0GAm2xZnTsf4trJSKW3nysuqIwVPp1iDLCZY+USKnPxenpwzY5BTWnP+T/wscfZgbLcSDid5d8ruBlVbmqRxtjFFpyGO3s6S5PkGl4oqctViJq1UbQZCh/XS43bZQWsan2B/lqkU8vZ0SXN8YcUZadjJbes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W7GsCclH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W7GsCclH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF131F00A3A;
	Mon,  7 Sep 2026 19:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788810066;
	bh=pSV7z1LuipUTeiHBNogLd0irpFpTfg8AF5mqK/wvoKg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W7GsCclH4z3M2fzgJV0QOIa5sbheYNCt2kUpxqwOu8f8gYE6uqLAENVCoPte3RHSQ
	 +gKnRj8Khdv+gXW58L2WvDlya/zXi3GoWSbU4jau90lnhw1irE0FBQKI7HO+4dB6ix
	 sX5R6iWrKL9Lhrw9g829RSkuBkU2X6OFgYeL+eicjMMQ2HoJeNIR7kylNq1KjOqASx
	 RNH2aSVGxYDeX/GPohGGdrcchxml5IQOpRcIwyphWKB+9geRKsAQd00Erxjuc/4rtm
	 A2vdR/U7AkrpAFKdlT9Pi9snkp8Z+Oyt1+f+/LYnr/hR91pxk187ssqyexzkiP2Ecl
	 tvrATWBDkgDsQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/4] scsi: ufs: core: Record the frequency the
 controller starts at
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bean Huo" <beanhuo@iokpp.de>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260907192140.2701755-4-beanhuo@iokpp.de>
References: <20260907192140.2701755-1-beanhuo@iokpp.de>
 <20260907192140.2701755-4-beanhuo@iokpp.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 19:41:06 +0000
Message-Id: <20260907194106.BBF131F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Unprotected concurrent modification of the globally shared `ufs_=
hba_vps` structure during asynchronous probe.
--

commit d1d1b66402811c53b2fbc0d56ed07cd4f77540ee
Author: Bean Huo <beanhuo@micron.com>

scsi: ufs: core: Record the frequency the controller starts at

This commit records the maximum frequency during ufshcd_devfreq_init(),
preventing devfreq from reporting an initial 0 Hz frequency. It avoids
an unnecessary governor scale that resets the same frequency and gear.
It addresses the issue for both modes with and without OPPs.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 2ba244cf40ac7..351c76094b9ff 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c

[ ... ]

> @@ -1727,12 +1722,21 @@ static int ufshcd_devfreq_init(struct ufs_hba *hb=
a)
>  	if (list_empty(clk_list))
>  		return 0;
> =20
> +	clki =3D list_first_entry(clk_list, struct ufs_clk_info, list);
> +
>  	if (!hba->use_pm_opp) {
> -		clki =3D list_first_entry(clk_list, struct ufs_clk_info, list);
>  		dev_pm_opp_add(hba->dev, clki->min_freq, 0);
>  		dev_pm_opp_add(hba->dev, clki->max_freq, 0);
>  	}
> =20
> +	/*
> +	 * ufshcd_init_clocks() has already set the clocks to the highest
> +	 * frequency, and nothing has changed them since. Save that frequency,
> +	 * so that devfreq and the clock scaling code know where we start.
> +	 */
> +	hba->clk_scaling.target_freq =3D clki->max_freq;
> +	hba->vps->devfreq_profile.initial_freq =3D clki->max_freq;

[Severity: Medium]
Could this introduce a data race during asynchronous probe?

Because ufs_hba_vps is a globally shared static structure assigned to all U=
FS
host controllers by default (hba->vps =3D &ufs_hba_vps), writing directly to
hba->vps->devfreq_profile.initial_freq mutates this shared state.

If multiple controllers probe concurrently during system initialization
(e.g. via ufshcd_async_scan), they will race to overwrite this field.
If the controllers have different maximum frequencies, they might overwrite
each other's initial devfreq settings, causing devfreq to start with an
incorrect frequency on one or more controllers.

> +
>  	ufshcd_vops_config_scaling_param(hba, &hba->vps->devfreq_profile,
>  					 &hba->vps->ondemand_data);
>  	devfreq =3D devfreq_add_device(hba->dev,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907192140.2701=
755-1-beanhuo@iokpp.de?part=3D3
