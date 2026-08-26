Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6674440A2C;
	Wed, 26 Aug 2026 14:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787752879; cv=none; b=Ffpy4bvP5HdgwPH+pMsVSKUuOxTmB6db6ocCp4sFxehWf5V6fW+iG01wAXJt5J5P5DcdgUIRZPGgYoTdz+HU5+y5+xSvUvm1yW6PNeSoLMl1hXx9BKFcODTjN0Tchm2EjZ/7XYfG8nD7NVz2Nnc3xMW75VjUxX22UfGfLICJSi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787752879; c=relaxed/simple;
	bh=Z//0R6rrgYE4syUuu9EGWFrde5oAW4nlyzPGtZfjR+g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oCIcwyUkqv/YkLr8nIrMcT6cQNAx7jVSCmFzd+MB9weQ1qhID4QYtyn8bOtDIHff84QMcM6Mgt0QtaOGiMwQTmP6HofziB1eu06xTfoekf/cTITEeXyU5spMSspfb3jyO/qhh9uCvFNJo4JzxBuuu2g3zrc0UvmOe9nXH4C2Kv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aXsSHWN+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aXsSHWN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AB61F000E9;
	Wed, 26 Aug 2026 14:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787752875;
	bh=6IQ1ntCNnNj0PpJ9TcmCmeREGvLZpF+B/RzWt6l61VU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aXsSHWN+wzgrg3eAckG6ilQAqVVjDnMWGWQKgHYQiGLyzYSRQQPtosSgqlEXSadT5
	 xAfgl9gQMtxQTmpIN6xhPLX2V3FP+518XTGDz11tLVMWgKU8ZO3Kqg8JVlcMDwhboo
	 aau0BufO1bxMEYH849FxFRmeAGUQWaOqTQWXlrxgJntwYPXI26qgRt+IOikwDMfPSU
	 09fCvkqTPVWzh9UZiKcIw9CDsGZ7YDYNp4p5Wj6UMyIYy/YlclvVJfeb2gntklttyl
	 02fmOHHeKCfyX6HGAXkbkF9SpiWNjk9DO/ScrerTmv4xMASxysMWfozu6su18NaY1F
	 xetnL8W8LUxvA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/10] scsi: ufs: Add NXP S32N79 UFS host controller
 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Larisa Grigore" <larisa.grigore@oss.nxp.com>
Cc: robh@kernel.org, conor+dt@kernel.org, imx@lists.linux.dev, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, Frank.Li@kernel.org
In-Reply-To: <20260826134048.854748-8-larisa.grigore@oss.nxp.com>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-8-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 14:01:15 +0000
Message-Id: <20260826140115.72AB61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The error handling for an unrecognized `nxp,mphy-boot-mode` prop=
erty aborts the probe instead of skipping MPHY initialization, contradictin=
g its own error message.
--

commit cc6f571e7075af648ae4e8cc7125fa859f589eaf
Author: Larisa Grigore <larisa.grigore@oss.nxp.com>

scsi: ufs: Add NXP S32N79 UFS host controller driver

This commit adds support for the UFS host controller on the NXP S32N79 SoC
using the DWC architecture. It handles specific initialization steps prior
to UIC_LINKSTARTUP and introduces the 'nxp,mphy-boot-mode' device tree
property.

> diff --git a/drivers/ufs/host/ufs-nxp-s32n7.c b/drivers/ufs/host/ufs-nxp-=
s32n7.c
> new file mode 100644
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-nxp-s32n7.c

[ ... ]

> +static int ufs_s32n_init(struct ufs_hba *hba)
> +{

[ ... ]

> +	ret =3D of_property_read_string(np, "nxp,mphy-boot-mode", &mphy_boot_mo=
de);
> +	if (ret || !mphy_boot_mode) {
> +		dev_dbg(dev,
> +			"nxp,mphy-boot-mode property not found. UFS MPHY init will be skipped=
.\n");
> +		goto init_out;
> +	}
> +
> +	if (!strcmp(mphy_boot_mode, "rom")) {
> +		ufs->mphy_boot_mode =3D MPHY_BOOT_ROM;
> +	} else {
> +		return dev_err_probe(dev, -EINVAL,
> +				     "Unrecognized nxp,mphy-boot-mode property. UFS MPHY init will b=
e skipped.\n");
> +	}

[Severity: Medium]
Does this code inadvertently abort the entire UFS host controller probe?

The error message explicitly states "UFS MPHY init will be skipped", but
returning the result of dev_err_probe() propagates the -EINVAL error up the
call stack and completely fails the probe.

If the intent is to truly skip the MPHY initialization as indicated by the =
log
message, should this perhaps log a warning and use `goto init_out` instead =
of
returning a fatal error code?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260826134048.8547=
48-1-larisa.grigore@oss.nxp.com?part=3D7
