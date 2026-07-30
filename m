Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6782A3D9DDF;
	Thu, 30 Jul 2026 10:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785407446; cv=none; b=q+qgbPDVSJPzf3YDfmX8bzRRwgt0OXz6SgRUi5aYqrrUYHiYHRcGTYuryWm/7dKKNUgygmwLfrfqajr4o4Orcg6051FffzQzM5QF2USfgKI380NJ3JrdrQU/M5QGEAsPMdNaYh6BX09+JQAeo2FtqLskVqrY6kbVuAeQtohtwDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785407446; c=relaxed/simple;
	bh=0hZYhan7GueBD8RjBOoEpcuDYTgAl7wqO9MfugLwqdw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aGl1B36VzN347cjd3lKDd3T/VRRU+mhDYHJB5eBgjM+M5v3Sh0u4HoeYFxgarqL7auPE4O45IxZUADdlALxg2tNlcXrH4jkHRZwDHCR94/QwoPdwBTEN/FOp0ni10EJHF3gK43GC2iu85gL7xAjYVlP2LUtvnHYOTwbWecFPAfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kn1josYa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kn1josYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6B31F000E9;
	Thu, 30 Jul 2026 10:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785407445;
	bh=MeyYoFf8kISumnlY6DHOTN8orLf4SamT/FJQ5R3g65E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kn1josYaw7uhzxrG9TLdDCuR878qBAH9h8KTAGV5xd4Zdl3Duus78cDBP7OUSOQNb
	 MvA7K7Fmm6/sRs4t9tf+bcMWnfA70r8A/+nLNqPdI+7M4t963cyqoMxNxVvxtrLunB
	 Qpu6s2CaJjiPRkwqIRZKAtveFa2xwl4PjvngJZZHzgBdtpG7x38AEM29dQpZkOIiYN
	 qEcJyeQjZ1h+rsBigcXNA1eezkU4XkyqPHcyCmO9iDIp35DmTnT8oWvw/Rs6+ndiFA
	 /RosiO7MxMcCKzdBxxWcYR6TGTGPxDxSf9C3FR1erjDEnOsehI1sBNs2qvHhM7duwf
	 HDOZxaB9rPCXw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 12/26] scsi: ufs: mediatek: Remove vendor kernel
 quirks cruft
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-scsi@vger.kernel.org, neil.armstrong@linaro.org, devicetree@vger.kernel.org, linux-phy@lists.infradead.org, robh@kernel.org, olteanv@gmail.com, vkoul@kernel.org, conor+dt@kernel.org
In-Reply-To: <20260730-mt8196-ufs-v10-12-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
 <20260730-mt8196-ufs-v10-12-bc5ecef202dc@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 10:30:44 +0000
Message-Id: <20260730103044.9A6B31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Dangling pointer to `phy_dev` in `ufs_mtk_probe()` due to prematur=
e `put_device()`.
--

--- Patch [12]: [PATCH v10 12/26] scsi: ufs: mediatek: Remove vendor kernel=
 quirks cruft ---
commit 6a21968869510eaa0eea1b9f7b65e382357ae809
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Remove vendor kernel quirks cruft

Both ufs_mtk_vreg_fix_vcc and ufs_mtk_vreg_fix_vccqx look like they are
vendor kernel hacks to work around existing downstream device trees.
Mainline does not need or want them, so remove them.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index a2749e79514c4..e5527969a5e67 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[ ... ]

[Severity: High]
This isn't a bug introduced by this patch, but does dropping the kobject
reference to phy_dev with put_device() leave host->phy_dev as a dangling
pointer?

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_probe() {
	...
		pm_runtime_set_active(phy_dev);
		pm_runtime_enable(phy_dev);
		pm_runtime_get_sync(phy_dev);

		put_device(phy_dev);
		dev_info(dev, "phys node found\n");
	...
	if (phy_node && phy_dev) {
		host =3D ufshcd_get_variant(hba);
		host->phy_dev =3D phy_dev;
	}
	...
}

If the PHY platform device is unregistered (for example, via DT overlay rem=
oval
or manual sysfs unbind) between the UFS probe and runtime PM transitions,
would dereferencing this pointer later in ufs_mtk_runtime_suspend() or
ufs_mtk_runtime_resume() cause a use-after-free?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730-mt8196-ufs=
-v10-0-bc5ecef202dc@collabora.com?part=3D12
