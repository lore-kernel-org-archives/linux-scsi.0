Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7A13612ED
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 04:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791518409; cv=none; b=Igy1VMCRs3f1G/0LMenBANEo7QzcCUginLDx1vgecLUtPtSQbtrnDBgLLVXyM8bWRjkRhhqseFBUoQZ925FNNLCXHBYXVp8y62t00gCmViMYQwhajGsMk+3m5W0gx8w0Vhevi+WmmmccXzglCm3/TbHgjAaV82R6hokm/ZAPFjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791518409; c=relaxed/simple;
	bh=syHdWRrS8Pmo2eOhnp/J3KugehiWJ7BxoSzHuIuEcU8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=i/QOmif47FSVa28e/Eef2LGqPOzGOsCtClbimwmuDPuU+2TGtpu7ogwhumr+dGyzQjNaF9OvvufFgZ3YGvIrkdBSoFygwJiA26K5DQG5YV7JhzddYWv6u6PNIHahWvVgkbmEeygSDjI/HgYKXPel/IyXoStvgCvFEx3b+3D5Ffs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/6RhzBb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/6RhzBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E5E1F000FF;
	Fri,  9 Oct 2026 04:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791518404;
	bh=UbooIiHNuobkTLqdAxLZow3giSHDBcX5JFOQwNDZ/7s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j/6RhzBbG7EB/c/FCf17C6Sztv6Fq5UERuf4RJ/7UvVHUZFny9dTw+LyXbjFqJrxb
	 FhtORYEQ0ktJs+FTcx63cdhaq0enhyrhsek8+bqtQWDTppPPV7kVkHzqgEoV0PO8f7
	 PJA2MQZpvznFfLsxCLA0wCVxq+55xjQODfMuhnbP92c25on+T7b5c0Akc+lwJlTeR5
	 IrvSE6K3HOUB7uoopxumOWteKvcpskZborIkmEBDQCzsWNdtUQfSEsKKT5ksv/Zrsw
	 30BjmYjVZm7ou4Mh30lGKjTqiIQZa3bzSEb+9YSey9honTwWSkUGl1+Fy+Q7RHCqIR
	 hbvgUEcRkDyTg==
Message-ID: <sashiko-outbox-164807@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/4] scsi: hisi_sas: Fix incorrect delay values from
 magic-number cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261009033238.1076098-3-yangxingui@huawei.com>
References: <20261009033238.1076098-1-yangxingui@huawei.com>
 <20261009033238.1076098-3-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 04:00:04 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: hisi_sas: 50ms busy-wait under IRQ-disabled spinlock in phy_=
disable
--

commit 86ffaa91665021920ad95de8013bfb6e4e20fbda
Author: Xingui Yang <yangxingui@huawei.com>

scsi: hisi_sas: Fix incorrect delay values from magic-number cleanup

Commit 4ca7fe99fc84 ("scsi: hisi_sas: Use macro instead of magic
number") replaced several delay constants with a single macro of
value 100. This commit adds separate macros for each delay to restore
the original values while avoiding magic numbers.

> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_s=
as/hisi_sas_v3_hw.c
> index 8a2500993e19d..9c363e2373538 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c

[ ... ]

> @@ -1072,7 +1075,7 @@ static void disable_phy_v3_hw(struct hisi_hba *hisi=
_hba, int phy_no)
>  	cfg &=3D ~PHY_CFG_ENA_MSK;
>  	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
> =20
> -	mdelay(HISI_SAS_DELAY_FOR_PHY_DISABLE);
> +	mdelay(DISABLE_PHY_DELAY_MS);

[Severity: High]
Does this execute a 50ms busy-wait under an IRQ-disabled spinlock?

Looking at hisi_sas_phy_enable() in drivers/scsi/hisi_sas/hisi_sas_main.c,
it calls the hardware-specific PHY disable callback while holding the
IRQ-disabled spinlock:

hisi_sas_phy_enable() {
	...
	spin_lock_irqsave(&phy->lock, flags);

	if (enable) {
		...
	} else {
		sphy->negotiated_linkrate =3D SAS_PHY_DISABLED;
		hisi_hba->hw->phy_disable(hisi_hba, phy_no);
	}
	...
}

Because hisi_hba->hw->phy_disable maps to disable_phy_v3_hw(), this means
the 50ms mdelay() executes with local interrupts disabled.

This will happen on any path that disables a PHY, including
hisi_sas_stop_phys() which iteratively disables all PHYs, compounding the
delay linearly.

Can this be changed to avoid executing a massive busy-wait with interrupts
disabled?

> =20
>  	state =3D hisi_sas_read32(hisi_hba, PHY_STATE);
>  	if (state & BIT(phy_no)) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009033238.1076=
098-1-yangxingui@huawei.com?part=3D2
