Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DEC4AF680;
	Fri, 25 Sep 2026 14:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790347478; cv=none; b=dfRThANRuaQzwKJXtg3I2NI3fxQ92EOTZdFRCGconv2gzfTgnkwKTnwITmWvh4jzTpyUpYNIphC4vyKYfe0vxSK/eQMaxekrzg0iLlYaRmcm0ujZ2XqXksbv5GFqpvJUoPO7XGrf5f1dtvEOgchn76l2SKOuG9t+d0vrNZdL/wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790347478; c=relaxed/simple;
	bh=Wjc+K4g1PDEQuBhpGdpLmy1RW4pTi1bQI0UMlQC3o38=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LQ5rj3nBIvBcq683S0yaZS+RlTU5qNr/tQKKq4gHthdZq+pM0T/i6mbTJEtXYQHC5ijCVNHJLhQ+IJ3wZwvS3Yov6ZwmZrBb4M5jnsSenFwB/hEuRQ188DIcAts5zg+oFnA0aB45lLztHCYWhSs0p04+SVWbMwMjEinqdbvl2oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b25XS05S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b25XS05S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE0A1F00893;
	Fri, 25 Sep 2026 14:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790347475;
	bh=ITZDFVox5NLHXsnmK10W6wsN7s4IILuSRlfCt0zYpN4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b25XS05S3OB6eWWJs/qEIGE0ur+QK+mebfkuqKKgxQjBKRVdmn7lPJVLfXSBMzZWX
	 +ijRghadWFlCg4T8sbwHIfu0U96F8SjDp2xtPM2gLbj804B47Cz4O6uCfMoNDL4GXF
	 IJpsg5ljunxtt+yRZSgCs7RY1WgccIl1cgf7aEOhi73Rwgo7dib8Tn8l2o0yOwMk8t
	 Jglk1bafKFY0W7sGXdES+CSRmCD8+OBgw8XYpXYWtDczNcaa5FlisuyxEv0zBeGRz7
	 hftIicdb8SIidhEYHD8g3rmD08vK+WHKrJ4aEkpeCdPucRpy7VMhRcu5VRWgX+CXDE
	 Sz6mOmCPsKXeA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 09/12] scsi: ufs: Add NXP S32N79 UFS host controller
 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Larisa Grigore" <larisa.grigore@oss.nxp.com>
Cc: imx@lists.linux.dev, robh@kernel.org, devicetree@vger.kernel.org, conor+dt@kernel.org, Frank.Li@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260925143534.3298540-10-larisa.grigore@oss.nxp.com>
References: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
 <20260925143534.3298540-10-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 25 Sep 2026 14:44:34 +0000
Message-Id: <20260925144435.3CE0A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] pm: incorrect conditional wrapper used for system sleep callbacks
--

commit d098a24e93df9f55eb797a42c24f7333f79c7078
Author: Larisa Grigore <larisa.grigore@oss.nxp.com>

scsi: ufs: Add NXP S32N79 UFS host controller driver
   =20
Add support for the UFS host controller on the NXP S32N79 SoC, built on
the Synopsys DesignWare (DWC) UFS architecture, using the UFSHCD DWC and
UFSHCD platform glue. This controller requires S32N79-specific initializati=
on
prior to UIC_LINKSTARTUP.

> diff --git a/drivers/ufs/host/ufs-nxp-s32n7.c b/drivers/ufs/host/ufs-nxp-=
s32n7.c
> new file mode 100644
> index 0000000000000..f7a017a6d9ae6
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-nxp-s32n7.c

[ ... ]

> +static const struct dev_pm_ops ufs_s32n7_pm_ops =3D {
> +	SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
> +	RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
> +	.prepare	=3D pm_ptr(ufshcd_suspend_prepare),
> +	.complete	=3D pm_ptr(ufshcd_resume_complete),

[Severity: Low]
Is it correct to use pm_ptr() for the .prepare and .complete system sleep
callbacks in ufs_s32n7_pm_ops?

The pm_ptr() macro evaluates to NULL when CONFIG_PM is disabled, but .prepa=
re
and .complete are system sleep callbacks which should evaluate to NULL when
CONFIG_PM_SLEEP is disabled. Wrapping them in pm_ptr() could cause dead code
or build errors if the kernel is configured with CONFIG_PM=3Dy but
CONFIG_PM_SLEEP=3Dn. Should pm_sleep_ptr() be used here instead?

> +};
> +
> +static struct platform_driver ufs_s32n7_driver =3D {

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925143534.3298=
540-1-larisa.grigore@oss.nxp.com?part=3D9
