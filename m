Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CF23612DB
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 04:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791518694; cv=none; b=Wz2oIaNG2oJmtfdOC4SzWhznfShTFiyNYgCCXf6PtizJt18tdaqO2fOtb9qaoXFxNS9LgLVr79Di6ebQ2wbIeaHKm/lNkOOhLVVw944RCfLsNVb02KF9wPzjLyYGfREhXAhZIo6pvHAGcxvzVgokpEhNe/VDH5vk+Hr4QF3gGgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791518694; c=relaxed/simple;
	bh=lZRL8Hm9ro1r2R1v89QElaLMMW1NjbMx+v55zZxmssA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=qeZIV5bSvl3Z2F5neHgrNNCXdtuW5U8m+G7JWCcISgz7ff+OMaoybyBDG1gJ9j6YluXwz7fxKOYzuQQxuG2uO2TKCimFTvvfVJKgomC3vIILzqUYlEUS9CLho0mpuvumNIGcVQX4LSxw6LKX/Dhc+CDh+5EVqHY6BXEo+rworU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f55U+lgB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f55U+lgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60681F000FF;
	Fri,  9 Oct 2026 04:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791518688;
	bh=Qy0+EKwczbbD1mat875rt4xgdzZT9ICFZj+AiUu+JoI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f55U+lgB5KFdM3T0V3/Z+yBW3PINYlW7I36Ud/egAp6r2YNy6EGY6IP61buS9jVED
	 KypQ6cLAIydmUNdvEGkVE20QuDFkGfuQ3jA35/LnAgX1zEbbsfvA0vddSD8MklQEIq
	 dHBlq+b9tkRCbalg2YG90WgRRv4B7e4vR+++iAvlYd6VMo+gkdCKtxxd/B3tQtcSlr
	 d/3UlTAdN4lbabzegS9VKRlwSkb4KRqnYVEw8G36SwKkyBvKaVl87ivGG8sGxaRGAW
	 2+KS2RHO2gq3TjLyjvXR1ojTb1yvd6FNMNvBhf1pw4P5LAS05NmI4mK7Uz2AK7C03r
	 rJZ7W4MCs7koA==
Message-ID: <sashiko-outbox-164809@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/4] scsi: hisi_sas: Clear PHY error counts on phyup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261009033238.1076098-4-yangxingui@huawei.com>
References: <20261009033238.1076098-1-yangxingui@huawei.com>
 <20261009033238.1076098-4-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 04:04:47 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] scsi: hisi_sas: Race condition in clear_phy_err_cnt_v3_hw loses int=
errupts
--

commit fc6fb794eb6c362e576f814fd8ef3aeacd812117
Author: Xingui Yang <yangxingui@huawei.com>

scsi: hisi_sas: Clear PHY error counts on phyup

Some disks generate link errors during link establishment but still
phy up successfully. This commit clears these intermediate error
counts on phyup to prevent leaving stale data for error detection.

> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_s=
as/hisi_sas_v3_hw.c
> index 9c363e2373538..030f050731ba1 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c

[ ... ]

> @@ -1061,16 +1064,31 @@ static void enable_phy_v3_hw(struct hisi_hba *his=
i_hba, int phy_no)
>  	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
>  }
> =20
> +static void clear_phy_err_cnt_v3_hw(struct hisi_hba *hisi_hba, int phy_n=
o)
> +{
> +	u32 irq_msk =3D hisi_sas_phy_read32(hisi_hba, phy_no, CHL_INT2_MSK);
> +
> +	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2_MSK,
> +			     CHL_INT2_RX_ERR_MSK | irq_msk);
> +
> +	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_DWS_LOST);
> +	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_RESET_PROB);
> +	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_INVLD_DW);
> +	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_DISP_ERR);
> +	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_CODE_ERR);
> +
> +	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2, CHL_INT2_RX_ERR_MSK);

[Severity: Low]
Does this sequence create a race window where an error interrupt can be los=
t?

Because the error counters are clear-on-read, reading them before clearing =
the
Write-1-to-Clear interrupt status register CHL_INT2 could lead to a race.
If a new PHY error occurs in the window after the counter is read but before
CHL_INT2 is written, the hardware will increment the error counter and set =
the
corresponding interrupt status bit.

The subsequent write to CHL_INT2 will then clear this newly set interrupt
status bit, causing the interrupt for the new error to be permanently lost
until another independent error occurs.

Could the CHL_INT2 register be cleared before reading the clear-on-read
counters to prevent this race?

> +	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2_MSK, irq_msk);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009033238.1076=
098-1-yangxingui@huawei.com?part=3D3
