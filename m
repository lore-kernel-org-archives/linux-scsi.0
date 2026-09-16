Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D05A486640;
	Wed, 16 Sep 2026 09:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789549227; cv=none; b=FBe0LIN0bWf0A53BfxRcS8+k9VtOlfGKxZji9+G/9UTLI0hcNIkhK53xkWsGp2H7aylHhQykj53hiHOVtXIMRwB9u6Pgjz8PUXQ1UFIk1nG5p0sTSROFsIOg0qLhjtD/u+K2CG/2jjnS78J8s7m9jUA03juQ0IH9CTiSuNoFFVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789549227; c=relaxed/simple;
	bh=7hjShUH8oG2qiOcGYyNttSxIxKlulyMkTIff6p+A8No=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Pm7nfTFgVN7Xw4ZsHP4VNls0P2mDxhDjw6SZEpXLfzb7NAfBCwMm0OZH9iSwORkJZY1FVEuj1G9bOecsRD2g8DfSG2WsW6fHKsAV/yDkfARxCOAa5Us7Ua7FfBM060gLgaVoQRh8jr71Ci7cPIBvYgwvOy6no3BTkJI+Ssea1MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NAU/WoCy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NAU/WoCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7111F00899;
	Wed, 16 Sep 2026 09:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789549211;
	bh=Ng0BJe/IEPoeGD8s9AGF/YjESKtaslK1oYhKm/z5OrY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NAU/WoCy+PNyHbj+OQ3WPb8JznVEIh0ORecyxVEfiQE+KWyB7zI93UFwrzCAxZPvy
	 QPzJ6I5qIGgC5OWw3sIspJ632/RpvUZjFj38CSwgHf3u7J7Yd4X+xp/SmClpbxavk7
	 Kg121fNnqrjkDGtdhcsOrGlOhKXnTWjCemQM744xcmslmWQAyfdo643lBxqZOvufDa
	 dLCqWHOYaw2ZFmPTxIBXUfcHJdl83r1nRlAgqvAYfP3tagvtelBLFYZAWdo1YLGwNb
	 BdP3s6ZsX+hVeQ5wCybYdBdSGtOUTGRUIodhS6ST4qTdwC7qaEL6Ti8cpG/yjFGxWC
	 g2khCgdEq4u3A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 07/10] scsi: ufs: Add NXP S32N79 UFS host controller
 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Larisa Grigore" <larisa.grigore@oss.nxp.com>
Cc: conor+dt@kernel.org, robh@kernel.org, Frank.Li@kernel.org, imx@lists.linux.dev, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260916084411.941297-8-larisa.grigore@oss.nxp.com>
References: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
 <20260916084411.941297-8-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 09:00:09 +0000
Message-Id: <20260916090010.6C7111F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] pm: positive return in ufs_s32n7_link_startup_notify() causes uncl=
ocked access
- [Low] pm: missing pm_sleep_ptr() wrapper for .prepare and .complete callb=
acks
--

commit 774c9ff68bb8216bae4f82205ba8ce70b0364e59
Author: Larisa Grigore <larisa.grigore@oss.nxp.com>

scsi: ufs: Add NXP S32N79 UFS host controller driver

This commit adds support for the UFS host controller on the NXP S32N79 SoC,
built on the Synopsys DesignWare (DWC) UFS architecture. It implements
S32N79-specific initialization sequences before link startup and applies
post-link calibration for HS operation.

> diff --git a/drivers/ufs/host/ufs-nxp-s32n7.c b/drivers/ufs/host/ufs-nxp-=
s32n7.c
> new file mode 100644
> index 0000000000000..4f9a001562024
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-nxp-s32n7.c

[ ... ]

> +static int ufs_s32n7_link_startup_notify(struct ufs_hba *hba,
> +			     enum ufs_notify_change_status status)
> +{
> +	int err;
> +
> +	if (status =3D=3D PRE_CHANGE) {
> +		err =3D ufs_s32n7_link_startup_pre_change(hba);
> +		if (err) {
> +			dev_err(hba->dev, "MPHY setup failed (%d).\n", err);
> +			return err;
> +		}
> +		return 0;
> +	}
> +
> +	/* POST_CHANGE */
> +	err =3D ufshcd_dwc_link_is_up(hba);
> +	if (err) {
> +		dev_err(hba->dev, "Link is not up.\n");
> +		return err;

[Severity: High]
Could this propagate a positive return value on failure?

When ufshcd_dwc_link_is_up() fails, it returns 1. If this positive value is
returned here, it will propagate up through ufshcd_link_startup() and
ufshcd_resume() to ufshcd_runtime_resume().

The PM core's rpm_resume() will treat the positive return value as a failur=
e,
marking the device as RPM_SUSPENDED, but will propagate the positive 1
back to callers of pm_runtime_get_sync().

Since callers typically check for failure using a ret < 0 condition, they
will assume the device successfully resumed and proceed to access unclocked
or powered-off hardware registers. This can cause a system crash or bus han=
g.

> +	}
> +
> +	err =3D ufs_s32n7_link_startup_post_change(hba);

[ ... ]

> +static const struct dev_pm_ops ufs_s32n7_pm_ops =3D {
> +	SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
> +	RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
> +	.prepare	=3D ufshcd_suspend_prepare,
> +	.complete	=3D ufshcd_resume_complete,

[Severity: Low]
Should these sleep callbacks be wrapped with pm_sleep_ptr()?

The power management subsystem guidelines require sleep callbacks like
.prepare and .complete to be wrapped in pm_sleep_ptr() to prevent them
from becoming dead code when CONFIG_PM_SLEEP is disabled.

Assigning them unconditionally can cause minor memory bloat and potential
compiler warnings due to unused symbols being retained.

> +};
> +
> +static struct platform_driver ufs_s32n7_driver =3D {

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916084411.9412=
97-1-larisa.grigore@oss.nxp.com?part=3D7
