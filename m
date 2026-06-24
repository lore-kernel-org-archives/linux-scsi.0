Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6F3384CC8
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 06:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782284022; cv=none; b=hyYHIphAcq6RFCmyRNw+OdPNAJ2CdFZfL6vO8CB4qfUiH1DZlGVHQJ/1agmacvq9jCC2iWmy8PzYwPj7Dw6RlWt59hCNVnqUG2Oy3Vp3B3BrzK1yMODQOjeu/zEwheiI+WtAgMRHsmmytb+4WHmXmnzrrIA6OQbPMGNHehWNpSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782284022; c=relaxed/simple;
	bh=CVcxz7ZkFPtDWu8UNgO+InKGefMglunfLm0Bl6Lpd94=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rqhVaavp2IMRLOmhXNLuQEN+SivgLHKpuProToQCBHfP3wckvBrhvjYMvr74aSwpsA4i4YH2hWAEcE6ZAJ0Yhf8VTMcmH4klQgU7Ro0m9soByfhwYrNpdlX6TKyr/MVmvdT1HHGxqBnVrGA84xXjrhgrQnDOHrQ2S0JOXBs167w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g+zun60W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g+zun60W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1349E1F000E9;
	Wed, 24 Jun 2026 06:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782284021;
	bh=eQSZBAzrIKrAdLnWHHyvz40VyPorvHJ0UkCSvkCN8Js=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g+zun60WH4kbFgnByhmofJybxOg1dwz72Xc9C+MS5AMDZmXWnTtW64iCU+H/3Gekz
	 llHb0qRN5IXF4gi+UzMVHYFp+DpwKt8O9agFsec8uH0dCXJQ9v/eqAD2/sXMGThTum
	 5ttsfA5A3KF2ITcUuO3ks3d2jD1ovj3RQG4kNxb5rSHUdmqqsbT/yF37wn5LUl4euq
	 7jl835/dB1D3CyCamDCG51NhDyLVypu17sYw57kK1xRK1hIA+Vqwhu8OLCMHOI3XMH
	 L25hhPRyFRkP23gX8g5MqgHdlFQV1pfrIn31Iw4DqFb5flZUWLMrkOrdVQ3yy9La/4
	 NOv16pg4vyuOw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 2/2] scsi: libsas: Add linkrate and sas_addr change
 detection in rediscover
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260624063230.3264029-3-yangxingui@huawei.com>
References: <20260624063230.3264029-1-yangxingui@huawei.com>
 <20260624063230.3264029-3-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 06:53:40 +0000
Message-Id: <20260624065341.1349E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch attempts to fix a Use-After-Free by moving `sas_ex_phy_d=
iscover()` before the `child_dev` lookup, but `sas_ex_to_dev()` still retur=
ns an unprotected, unreferenced pointer, leaving a lockless TOCTOU / UAF ra=
ce.
--

commit c64b715b8d5d34842e349c246a7de0dc1188f077
Author: Xingui Yang <yangxingui@huawei.com>

scsi: libsas: Add linkrate and sas_addr change detection in rediscover

Introduce sas_dev_is_flutter() and sas_rediscover_ex_phy() to improve
flutter and device replace detection during rediscovery.

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
> index fc6d8f3c9dcae..e27953de2b4e2 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c

[ ... ]

> +static bool sas_dev_is_flutter(struct domain_device *dev, int phy_id,
> +			       u8 *sas_addr, enum sas_device_type type)
> +{
> +	struct expander_device *ex =3D &dev->ex_dev;
> +	struct ex_phy *phy =3D &ex->ex_phy[phy_id];
> +	struct domain_device *child_dev;
> +	char *action =3D "";
> +	int res;
> +
> +	if (SAS_ADDR(sas_addr) !=3D SAS_ADDR(phy->attached_sas_addr) ||
> +	    !dev_type_flutter(type, phy->attached_dev_type))
> +		return false;
> +
> +	res =3D sas_ex_phy_discover(dev, phy_id);
> +	if (res)
> +		return false;
> +
> +	child_dev =3D sas_ex_to_dev(dev, phy_id);
> +	if (!child_dev)
> +		goto out;
> +
> +	if (dev_is_sata(child_dev) &&
> +	    phy->attached_dev_type =3D=3D SAS_SATA_PENDING) {

[Severity: High]
This is a pre-existing issue, but does sas_ex_to_dev() still leave us open
to a use-after-free race here?

It looks like sas_ex_to_dev() calls sas_find_dev_by_rphy() and returns the
unreferenced device pointer without incrementing its reference count via
kref_get().

If a hardware link drop event occurs concurrently, the event workqueue
could trigger sas_deform_port(). Since sas_deform_port() doesn't acquire
the disco_mutex before calling sas_unregister_domain_devices() and
sas_destruct_devices(), it can tear down the device and free its memory.

Because sas_deform_port() only flushes the disco_q after tearing down the
devices, could child_dev be freed by the event workqueue before we
dereference it here in dev_is_sata() or in the sas_addr check below?

> +		action =3D ", needs recovery";
> +		goto out;
> +	}
> +
> +	if (SAS_ADDR(child_dev->sas_addr) !=3D SAS_ADDR(phy->attached_sas_addr)=
) {
> +		pr_info("ex %016llx phy%02d sas_addr changed from %016llx to %016llx\n=
",
> +			SAS_ADDR(dev->sas_addr), phy_id,
> +			SAS_ADDR(child_dev->sas_addr),
> +			SAS_ADDR(phy->attached_sas_addr));

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624063230.3264=
029-1-yangxingui@huawei.com?part=3D2
