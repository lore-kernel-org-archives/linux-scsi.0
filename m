Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1283264CB;
	Thu, 30 Jul 2026 10:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785407659; cv=none; b=JnIfMy89klRHXvmmKiN+FSsOUUbhpbSeqCgEY9WCcaateRS1VEwjdQqWU6dE/KU0UyO9aUX54+tC5cBDkfN39d7FZKRQk/CgDG4eV/F5788Z+pCKquyJkVUoUqFnO5dSuD78DlaghRGOrjVtYtol5tdUysEI2C+xOYgasNm8j2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785407659; c=relaxed/simple;
	bh=O6EtZQTBEz6dV1TeHmiemF8vWJ9i/5izQsQ8VyX5J7E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mIDwIu2tfIzDS//f4Y9rG7JEkxRBnSY5Z8+5qcjnOw9453wNayWClq7dZZy6qmuchNnHkdzGBuLGUFkdouUs/rJ9Qn1+awUYnpYvSObUCoQ34lH/6lJ0CBgywjXRpAw0DS3o1ctkl6IgiO81O/D+06b9TBCE2i0u962HwS5ceNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KYbB3fXx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KYbB3fXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B2F1F00A3A;
	Thu, 30 Jul 2026 10:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785407657;
	bh=PRaGGaF7JcUJAdXA15IjjKSObsBHz3MiJmG58IerBrc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KYbB3fXxH1p7Mwp5xGR4iF/0DvJJQwTJSwB85f17CWM+7Uve5xl4CK52jsdrNzkCQ
	 DZuYS5epTn3LRQo9Q1c7j5lZKQ2CUzpHDM20BToEaVyWaklFJSI9ItCONXQlfCLhUJ
	 zQs5bUlJaCBhiDM/0X8k4/cUdj1oNTcqJ7oIuWN/d3b7lVWREBPD1yLi6dGRznGhoE
	 Vlx92XAGzGuKseLk663nvp15/WRK1N+2iWJWS7nUfaVsgKu7nPUQ0mmVdKWMoDVjql
	 EF7JZiiK4yYGUQm03nLHf4g0pckSSM2sNF1tNPMFC5SkRTScaZZNDAvxyTtpq0cNew
	 vvjx3JPfDRd9Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 15/26] scsi: ufs: mediatek: Rework
 _ufs_mtk_clk_scale error paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: vkoul@kernel.org, linux-phy@lists.infradead.org, robh@kernel.org, neil.armstrong@linaro.org, conor+dt@kernel.org, olteanv@gmail.com, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20260730-mt8196-ufs-v10-15-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
 <20260730-mt8196-ufs-v10-15-bc5ecef202dc@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 10:34:16 +0000
Message-Id: <20260730103417.68B2F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Failures during hardware operations in `_ufs_mtk_clk_scale` are no=
t propagated to callers, causing software state tracking and the UFS core t=
o desynchronize from the actual hardware state.
--

--- Patch [15]: [PATCH v10 15/26] scsi: ufs: mediatek: Rework _ufs_mtk_clk_=
scale error paths ---
commit fc8d96d1151c17bc40e741378caf17dd49c71248
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Rework _ufs_mtk_clk_scale error paths

This commit reworks the error paths in _ufs_mtk_clk_scale to print errors
at the correct log level and adds missing gotos in the scale up case.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index b4867c9c27434..cc4b5f4c4a079 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[ ... ]

> @@ -1989,51 +1989,48 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hb=
a, bool scale_up)
>  		if (clk_bind_vcore) {
>  			ret =3D regulator_set_voltage(reg, volt, INT_MAX);
>  			if (ret) {
> -				dev_info(hba->dev,
> -					"Failed to set vcore to %d\n", volt);
> +				dev_err(hba->dev, "Failed to set vcore to %d\n", volt);
>  				goto out;

[Severity: High]
This is a pre-existing issue, but since the error paths are being reworked
here, should _ufs_mtk_clk_scale() be changed to return an int so these
errors can be propagated?

Currently, _ufs_mtk_clk_scale() returns void. When hardware operations like
regulator_set_voltage() or clk_set_parent() fail, the function jumps out
but drops the error code.

The caller ufs_mtk_clk_scale() then unconditionally updates the software
tracking state assuming success:

ufs_mtk_clk_scale() {
        ...
        if (scale_up)
                _ufs_mtk_clk_scale(hba, true);
        else
                _ufs_mtk_clk_scale(hba, false);

        host->clk_scale_up =3D scale_up;

        /* Must always set before clk_set_rate() */
        if (scale_up)
                clki->curr_freq =3D clki->max_freq;
        ...
}

Could this desynchronize the driver and devfreq state from the hardware,
potentially causing the UFS core to overdrive the wrong clock parent or
fail to scale frequencies properly?

>  			}
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730-mt8196-ufs=
-v10-0-bc5ecef202dc@collabora.com?part=3D15
