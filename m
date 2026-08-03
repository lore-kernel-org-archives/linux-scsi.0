Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF8826F2BE
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2026 02:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785724572; cv=none; b=tGx53GA8arSVwBaSGg79CvFbLwqR6FwFVKDA2c00Z/lANF6+AYuJ1IIbxOs+qLbdzT+ipdEdt7x4O4uSsiUICca/GQhx5sut5t4QzexiphJmVJBYbb1VWi0OpVHXoHjqg9v0CUZiBi/qVI5C9A88hrIZV2UWqL2q8uRBR5ZI5r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785724572; c=relaxed/simple;
	bh=HO/QF1VWMl7ILTt93hQdVyuPjl3ZUg4b9XinUJZTG4U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eGuwTiXlNYszlqbZZZXuwU7VbABsu6d6KlfCSO4MnvfN48qxxg3YK+5s+gjjr/YpKX/cqqjs/DHItbb8Dga7lOgZhyXx8yyrab0+788nQvirHhv7AIjBgCetYFvXxKCJn3KU1vilrkOz/5R6b/OySbydwSbeMZMIZEBNJtIrzTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HcbeDdv0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HcbeDdv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340F01F000E9;
	Mon,  3 Aug 2026 02:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785724570;
	bh=sub0B+60l2Trw2EORQlzXU8M3u1IkIFY0ryU4S1JfTM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HcbeDdv0UWeRdYaoGXVCNcOY8R/OUphLUMy/RCKAhUTKr7ow6BL3c/b8iy8Rr97I5
	 j1O6NVQvY6nmkNek8eB+Q27jZcvsJ8zE0Ys4Y+ZvZxlIezbFrpvcf38SvYnJ6V0iZk
	 uctatsZVFHxUMNWM9sVt9/8SCCCMuCzBlNah26POZWjg3wNvyIVzRIMQWS495SWEWw
	 /F1q9O9K+ZDHcDTA9G5n8uRKxDoiPeGRj10Dv6TFAQu3Gzb5PP4QdoNKpXZcfx8DBP
	 5dpSaj/W94NROwwlgpQuq20Q/RyDr2jcILxoIb22F2jmOVyEsULxjaWdWlMo7yvzJg
	 zzT6vQ+ElGLvA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] scsi: hisi_sas: Add lldd_notify_enable_spinup
 callback for SAS devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260803020536.546544-3-yangxingui@huawei.com>
References: <20260803020536.546544-1-yangxingui@huawei.com>
 <20260803020536.546544-3-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 02:36:09 +0000
Message-Id: <20260803023610.340F01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Missing check for controller reset state before accessing hardware=
 registers in the `hisi_sas_notify_enable_spinup` callback.

Pre-existing issues:
- [High] Race condition on SL_CONTROL register read-modify-write (RMW) oper=
ations between process and interrupt contexts without locking.
--

--- Patch [2]: [PATCH v3 2/2] scsi: hisi_sas: Add lldd_notify_enable_spinup=
 callback for SAS devices ---
commit 1a996ce0b10b1f8ffbc88dbdf06f98375a589a5c
Author: Xingui Yang <yangxingui@huawei.com>

scsi: hisi_sas: Add lldd_notify_enable_spinup callback for SAS devices
   =20
This commit registers the lldd_notify_enable_spinup callback for hisi_sas.
The callback sends a NOTIFY(ENABLE SPINUP) primitive to trigger media spinup
on SAS devices in Active_Wait or Idle_Wait state.

> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sa=
s/hisi_sas_main.c
> index 944ce19ae2fc1..a726d66803865 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -2081,6 +2081,16 @@ static int hisi_sas_write_gpio(struct sas_ha_struc=
t *sha, u8 reg_type,
>  				reg_index, reg_count, write_data);
>  }
> =20
> +static void hisi_sas_notify_enable_spinup(struct asd_sas_phy *phy)
> +{
> +	struct hisi_sas_phy *hisi_phy =3D
> +		container_of(phy, struct hisi_sas_phy, sas_phy);
> +	struct hisi_hba *hisi_hba =3D hisi_phy->hisi_hba;
> +
> +	hisi_hba->hw->sl_notify_ssp(hisi_hba, phy->id);

[Severity: High]
Should this code check the controller reset state before accessing the
hardware registers?

If a controller reset is triggered concurrently (e.g., via PCIe FLR) and
sets HISI_SAS_RESETTING_BIT, calling sl_notify_ssp() performs MMIO writes
while the hardware is resetting. This could trigger a Synchronous External
Abort (SEA) and kernel panic on ARM platforms.

Other callbacks like hisi_sas_phy_bcast() use
test_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags) to prevent this. Would
it be appropriate to add a similar check here?


[Severity: High]
This is a pre-existing issue, but does calling sl_notify_ssp() here
expose an unprotected read-modify-write race on the SL_CONTROL register?

The hardware-specific callback sl_notify_ssp_v3_hw() runs in process
context and modifies the register:

drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:sl_notify_ssp_v3_hw() {
    ...
    sl_control =3D hisi_sas_phy_read32(hisi_hba, phy_no, SL_CONTROL);
    sl_control |=3D SL_CONTROL_NOTIFY_EN_MSK;
    hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL, sl_control);
}

However, when a PHY goes down, phy_down_v3_hw() modifies the same register
in hardirq context:

drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:phy_down_v3_hw() {
    ...
    sl_ctrl =3D hisi_sas_phy_read32(hisi_hba, phy_no, SL_CONTROL);
    hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL,
                         sl_ctrl&(~SL_CTA_MSK));
}

If the hardirq preempts the process-context worker exactly between the read
and write in sl_notify_ssp_v3_hw(), the worker will subsequently write back
its stale read value, undoing the interrupt's modification. Can this corrupt
the PHY state machine?

> +	dev_info(hisi_hba->dev, "phy%d notify enable spinup\n", phy->id);
> +}
> +

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803020536.5465=
44-1-yangxingui@huawei.com?part=3D2
