Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86B334CFDE
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 04:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782966044; cv=none; b=EZnXaSA84336Bx/2bDSmr0Ck3ZoTr5d6lNuRYSPj0BywctY/6WucMCxBJP7c7wScBuXOY9cpYp7ZXdqWiIM+dcJIPqxpxaBrlUNGG3m3YhG4Kuw7StcGs2Sk1/h+UKBo1WNPAs4I56gY7ap0quzaX/QVAJSJYXamXj5q+mLtGBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782966044; c=relaxed/simple;
	bh=KQMN3luBCf3grqjFyeMF/JSrsH7bPN6AXaLUbH87ySI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=i/3Nn374BC7t1AkZBZL49pHnEYNyaQB4HD6SwFXAlq32K5eN9Kl2bKtUwUvdpuEXuYL9aZrvOpp7v6dIUgM4prfRxkgPm+FjYyFdTQavNWhDHsUXiWYGVvP+9VTKoQxJmMxtzqB1UmEgYzJwDNKeKxfbqe32SLGweRaC7g2ZMJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zji4yEyn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zji4yEyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C511F000E9;
	Thu,  2 Jul 2026 04:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782966042;
	bh=LValOxn6+6dzPVmR/WXFF/F7Gv42H9fuXeb5FABY1bI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Zji4yEynpDvstk7kcxzwh41/XfEjYsspWTv7yWvJkEGZJazj9E7tkYDJKsfTbbu1n
	 rrYe2OJtCn4FFXHltqcY98489UND4nbIm6UiiXH/PfH2tuXVXh61joq/F2x5SJF6+b
	 Mm+1VvMn3/lReOxEuQll95Mn3Ja76QVcWYEbL6R+Ojkxg9muEZXK9osyrrGeAoR7F8
	 nnchmqwnbfyxzB9F8j/wTyV1WTSaWogbMLyblv/9fUzLG+RxicAhDLbbcLltihZMPS
	 1i0RZy8uhTn6noacDm7TFMTvAuwcSfJTEkZPhUbFZB27dntPgWvGY+jtTA8Dje1dcX
	 xU/xowmwxxBKA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: hisi_sas: add spinup_notify callback to
 handle Active_Wait/Idle_Wait SSP devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260702035724.2059166-3-yangxingui@huawei.com>
References: <20260702035724.2059166-1-yangxingui@huawei.com>
 <20260702035724.2059166-3-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 04:20:42 +0000
Message-Id: <20260702042042.73C511F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Sleep in atomic context (softirq) leading to kernel panic.
- [High] Unprotected lockless read-modify-write on the per-PHY SL_CONTROL r=
egister.
--

commit bffefed84eeb23f304d7311529b064b5addeb6c8
Author: Xingui Yang <yangxingui@huawei.com>

scsi: hisi_sas: add spinup_notify callback to handle Active_Wait/Idle_Wait =
SSP devices

This patch adds a spinup_notify callback to the hisi_sas controller driver =
to
handle SSP devices in waiting states. When a device requires spinup, the dr=
iver
sends a NOTIFY(ENABLE SPINUP) primitive by toggling the SL_CONTROL.NOTIFY_EN
bit. The callback is registered across hardware versions v1, v2, and v3.

> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sa=
s/hisi_sas_main.c
> index 944ce19ae2fc1..1a16d18db297a 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -2474,6 +2474,31 @@ int hisi_sas_get_fw_info(struct hisi_hba *hisi_hba)
>  }
>  EXPORT_SYMBOL_GPL(hisi_sas_get_fw_info);
> =20
> +void hisi_sas_spinup_notify(struct scsi_device *sdev)
> +{
> +	struct domain_device *dev =3D sdev_to_domain_dev(sdev);
> +	struct sas_ha_struct *sha;
> +	struct hisi_hba *hisi_hba;
> +	struct sas_phy *local_phy;
> +	struct hisi_sas_phy *phy;
> +
> +	if (dev->parent && dev_is_expander(dev->parent->dev_type))
> +		return;
> +
> +	sha =3D SHOST_TO_SAS_HA(sdev->host);
> +	hisi_hba =3D sha->lldd_ha;
> +
> +	local_phy =3D sas_get_local_phy(dev);
> +	phy =3D &hisi_hba->phy[local_phy->number];
> +	if (phy->identify.target_port_protocols & SAS_PROTOCOL_SSP) {
> +		hisi_hba->hw->sl_notify_ssp(hisi_hba, local_phy->number);

[Severity: High]
Does calling sl_notify_ssp() here lead to a sleep in atomic context?

When the block layer completes a request and the device requires spinup,
the SCSI completion softirq invokes scsi_complete(), which calls
scsi_decide_disposition() -> scsi_check_sense() -> spinup_notify().

Since hisi_sas_spinup_notify() executes in BLOCK_SOFTIRQ context, calling
hisi_hba->hw->sl_notify_ssp() causes a panic on v3 hardware, as it contains
msleep(1):

drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:sl_notify_ssp_v3_hw() {
	...
	sl_control =3D hisi_sas_phy_read32(hisi_hba, phy_no, SL_CONTROL);
	sl_control |=3D SL_CONTROL_NOTIFY_EN_MSK;
	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL, sl_control);
	msleep(1);
	...
}

[Severity: High]
Can concurrent invocations of hisi_sas_spinup_notify() clobber the
SL_CONTROL register?

Because this lockless callback path is exposed to parallel softirq contexts,
multiple I/O completions for the same device can result in concurrent
read-modify-write operations in sl_notify_ssp_v3_hw():

drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:sl_notify_ssp_v3_hw() {
	...
	sl_control =3D hisi_sas_phy_read32(hisi_hba, phy_no, SL_CONTROL);
	sl_control |=3D SL_CONTROL_NOTIFY_EN_MSK;
	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL, sl_control);
	...
}

Could this unprotected read-modify-write race with itself across
different CPUs, potentially leaving NOTIFY_EN permanently asserted or
overwriting state changes made by concurrent hard IRQ handlers?

> +		dev_info(hisi_hba->dev, "spinup notify on phy%d for sdev %s\n",
> +			 local_phy->number, dev_name(&sdev->sdev_dev));
> +	}
> +	sas_put_local_phy(local_phy);
> +}
> +EXPORT_SYMBOL_GPL(hisi_sas_spinup_notify);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702035724.2059=
166-1-yangxingui@huawei.com?part=3D2
