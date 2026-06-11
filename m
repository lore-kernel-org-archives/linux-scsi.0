Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D43360EC9
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 06:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781159314; cv=none; b=uURDi5bnkrGNM8zWhkR2NaC5JgA7pRr2S4V/n9+oujbXNzJmjLdARB5zPLGuTrcpesoDEo69SXu5/EX8f79lReBjI5KbfgC+lEDSvoCdtXvGwTYoNoeQK+/0pbMG6w5hoezqLwaZ3TfJKtXJLtz+jfIu1GERVdhLxa2t8nSXKLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781159314; c=relaxed/simple;
	bh=WmNfo8Pom9VunujeiXPazFKbXSv/vdu1Pnjzu3GcPdA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XV47lsClymI1d5e8VCQxdMUwWiZUqYfYlP42KHbsytWRXEJ9tQ+Bg7KgNA1mu1DJa+c2IooDqtjZGihcWm3bIadGw4Ew7y27BaWmscSZXkzOsKckVrjwgkNWd0j+6urZWVPyV155+XVVwX+R6FpvVeUuYuaMLHq01lq5vWM7iRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZDXENqLl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZDXENqLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357031F00893;
	Thu, 11 Jun 2026 06:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781159313;
	bh=SCn5Yh21+oLb4+QSBK25es1qzuKSpe4aPkWINJMEAAM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZDXENqLluxOn3XVph91gAOPLfWWdO8Esp6bxPPHP/QKF+9PKYMaxKPIDqIGtUqYxE
	 Q4RO+HJOiqahamQGCJc9oZGvccJ+jp1w+iQsRULMN85wuM8xaLZewXmyPR/bnl4zjs
	 x9V81Fg1zLc4Kw25MwlbpUikVgsQ/RpfttBgBatPnVSwSuExZa4vEClMfzA+fFxacH
	 E8zg2X6B6BYnL/KDxT2IYgc+MB10wKkRDQyyRNnCevwj2btEHpeiS/skA9AAmVtTHs
	 MUycmtUuJcpuTtrz4Iwieoysv7AnWzjCg5XL/pmlSWS53NMSYQ0IryimsDbGkPmZ4Z
	 Jnj3eUZWk24qA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 2/2] scsi: libsas: Add linkrate and sas_addr change
 detection in rediscover
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260611061551.1171058-3-yangxingui@huawei.com>
References: <20260611061551.1171058-3-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 Jun 2026 06:28:32 +0000
Message-Id: <20260611062833.357031F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Flawed validation ordering in sas_dev_is_flutter() bypasses SAS ad=
dress restoration on link rate changes, causing the old device to leak perm=
anently.
- [High] Dereferencing `child_dev` after the blocking `sas_ex_phy_discover(=
)` call creates a Use-After-Free vulnerability if the device is concurrentl=
y removed.
--

commit 65aa55f588bb6a694e028ec218567c1d5cad6baa
Author: Xingui Yang <yangxingui@huawei.com>

scsi: libsas: Add linkrate and sas_addr change detection in rediscover

This commit introduces sas_dev_is_flutter() and sas_rediscover_ex_phy() to
improve flutter and device replace detection. It adds validation for linkra=
te
and sas_addr changes during rediscovery.

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
> index f55ae9a979cd4..4145938a0db52 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -1962,6 +1962,71 @@ static bool dev_type_flutter(enum sas_device_type =
new, enum sas_device_type old)
[ ... ]
> +static bool sas_dev_is_flutter(struct domain_device *dev, int phy_id,
> +			       u8 *sas_addr, enum sas_device_type type)
> +{
[ ... ]
> +	child_dev =3D sas_ex_to_dev(dev, phy_id);
> +	if (!child_dev)
> +		goto out;
> +
> +	res =3D sas_ex_phy_discover(dev, phy_id);
> +	if (res)
> +		return false;
> +
> +	if (dev_is_sata(child_dev) &&
> +	    phy->attached_dev_type =3D=3D SAS_SATA_PENDING) {

[Severity: High]
Does this code risk a use-after-free of child_dev?

The pointer child_dev is acquired before the call to sas_ex_phy_discover()
without incrementing the device kref. The sas_ex_phy_discover() function
sends an SMP request and can sleep.

During this sleep, could a concurrent link event free the device if
sas_deform_port() is invoked? If so, dereferencing child_dev here and
in the link rate check below would access freed memory.

> +		action =3D ", needs recovery";
> +		goto out;
> +	}
> +
> +	if (child_dev->linkrate !=3D phy->linkrate) {
> +		pr_info("ex %016llx phy%02d linkrate changed from %d to %d\n",
> +			SAS_ADDR(dev->sas_addr), phy_id,
> +			child_dev->linkrate, phy->linkrate);
> +		return false;
> +	}

[Severity: High]
If a device swap causes both the link rate and the SAS address to change,
will returning false here skip the address restoration block below?

If the address restoration is skipped, it looks like
sas_unregister_devs_sas_addr() will fail to match the old device since it
searches using the new address. Could this result in permanently leaking
the old device and triggering sysfs_warn_dup() errors when the new device
is discovered?

> +
> +	if (SAS_ADDR(child_dev->sas_addr) !=3D SAS_ADDR(phy->attached_sas_addr)=
) {
> +		pr_info("ex %016llx phy%02d sas_addr changed from %016llx to %016llx\n=
",
> +			SAS_ADDR(dev->sas_addr), phy_id,
> +			SAS_ADDR(child_dev->sas_addr),
> +			SAS_ADDR(phy->attached_sas_addr));
> +		/*
> +		 * Device unregistering relies on address matching. Restore
> +		 * attached_sas_addr back to the original address so that the old
> +		 * device can be unregistered later
> +		 */
> +		memcpy(phy->attached_sas_addr, child_dev->sas_addr, SAS_ADDR_SIZE);
> +		return false;
> +	}
> +out:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611061551.1171=
058-1-yangxingui@huawei.com?part=3D2
