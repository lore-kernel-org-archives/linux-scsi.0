Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA5F283FE5
	for <linux-scsi@vger.kernel.org>; Sat, 29 Aug 2026 03:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787974590; cv=none; b=tCtsXu4k3kHBI4c6zP7oHhxm9H+MutKZ6O1/C+DD32rXT6qXQapwf9JB8WUqezPoYCMk0eIzrCJZViWXYlXz7HjtH8dvkwh24mznwpsP9qFDBPombIRc4u2VopHB77429UIAlYYMyAAIKqfU372m7ZOZeBvtaCkY/d65FVHPPrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787974590; c=relaxed/simple;
	bh=J3eWuEcZmUueuwoXfs2yxX4pWOmfCrhM1t36LD4doag=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B7y2pQtE+686tdtawtYQF9VnSyO5C4LEeHQzyuLqC9UMWhK0jzSoLAGvfUrp5fVsKbpxul5ENcNEenIQB25Qe63Rvu3ETI3mB+r8DyWqoI6urMz2eaWQmtm8BpMzukmEjhYyVUzntZA8Y/Vya2Wvige9LzUIPah2+918sKOIFL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UFtWz+Ke; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UFtWz+Ke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9802D1F000E9;
	Sat, 29 Aug 2026 03:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787974588;
	bh=r/Fwn2ky7nB/MU0L5pHBCLtoYEwzN21SZ4tqhiqLMPk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UFtWz+Ke+d3ylpXBuZ5+VN9DC5iz0lKq0PbUU/e5YTnSUsBKpZJD/z9Dj5ZILMhso
	 4R02HMZ+wRMxxhMxKsOC/mPBZFTI/311HNoFh4rjOIE7BTmfJDzF9ackeoehhS2AJG
	 uaFyVrpUKfAwZg1AMqQ30ItDBaMP+1jHAWL0RXKVlq+P6dGPsRXsDswLHZdNzWvxxv
	 F3EmgTaT+EBNV4KT0XHZdre23c3OHTiLovdhj2vTwxzKFsTMYcf378EV3ngFa7fCzL
	 hPkt39MjGp+8+PDvniDfFCDDz8FNbiyfj3gggLLMl9kBGoMDmylkFu75YunV3E19+R
	 Jca7XrCZDcn2w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] scsi: hisi_sas: Fix incorrect delay values from
 magic-number cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260829032858.1661019-2-yangxingui@huawei.com>
References: <20260829032858.1661019-1-yangxingui@huawei.com>
 <20260829032858.1661019-2-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 29 Aug 2026 03:36:28 +0000
Message-Id: <20260829033628.9802D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Hardware callback executes a 50ms busy-wait delay while holding an=
 IRQ-disabled spinlock, severely degrading system latency and risking watch=
dog timeouts.
--

commit e8ddd9bef8daf2db411c3a4e51016ed28809f393
Author: Xingui Yang <yangxingui@huawei.com>

scsi: hisi_sas: Fix incorrect delay values from magic-number cleanup

This commit fixes incorrect delay values in the hisi_sas v3 hardware driver
that were introduced during a magic-number cleanup. It adds separate macros
for each delay site to restore their original timings of 50us, 50ms, and
10ms respectively.

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
This is a pre-existing issue, but is it safe to use a 50ms busy-wait delay
here while holding an IRQ-disabled spinlock?

Looking at hisi_sas_phy_enable() in drivers/scsi/hisi_sas/hisi_sas_main.c,
the hardware callback is invoked with interrupts disabled:

hisi_sas_phy_enable() {
        ...
        spin_lock_irqsave(&phy->lock, flags);
        if (enable) {
                ...
        } else {
                phy->negotiated_linkrate =3D SAS_PHY_DISABLED;
                hisi_hba->hw->phy_disable(hisi_hba, phy_no);
        }
        ...
}

Since hisi_hba->hw->phy_disable resolves to disable_phy_v3_hw(), this will
block the CPU with interrupts disabled for 50ms. When looping over multiple
PHYs in hisi_sas_stop_phys(), this delay can multiply, potentially causing
severe scheduling latency, dropped interrupts, or triggering softlockup
panics.

Could this delay be moved outside the spinlock, or could we use a sleepable
context here instead?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260829032858.1661=
019-1-yangxingui@huawei.com?part=3D1
