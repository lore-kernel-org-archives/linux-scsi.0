Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBAD26ED4F
	for <linux-scsi@vger.kernel.org>; Sat, 29 Aug 2026 03:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787975764; cv=none; b=KWfr2rmUz7YRZuk0lQGqIxSF2lDc+nCkppNOWwHPfwNtP83e8Xlsa503YFUVBE8LR2WbjNvihUifCg756xUvnsjolJ41NvFiZ3qFYTFFQOTHcmUCEPhk5oRSIt37grIle5SgQlCSxqixT/zAZWWtKJlbAlqznh9KuLt1aWMV00c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787975764; c=relaxed/simple;
	bh=g0rjEiLJKLsXFWOZq4DAegRT3E/upteTCckWTpXwYYI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sWQPlBk6YhKNcti0FK6reGrir/41PZ5lu95o4VdCxEzD8ILQBZiI63qBWEvktFjrgTd7APoYHyp5GLyuw2BiV6vM2S2An7tj6iQNVpazfIzldRKnLiPFmv4Eb06hvcIOyvH+IEliB7DPqBCJLfXwultyY4H7osJ9KNkCt8uygq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5fIbqSb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5fIbqSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BFA1F000E9;
	Sat, 29 Aug 2026 03:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787975762;
	bh=qP5c31vBTgy6QRYC5gh9qvr+/lur8xNOUxojzdsQego=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K5fIbqSbgYZUxFPOa+sPjfdS32Ta9/tKAMPIUGkct/1jPdngHbzpT+nT5j4m6NFj6
	 zGqGF22ZB6S1VoP3g/57OFMfr+SCE3qjpYGU3Nq2/a5hflfPwM3uACb7c6LYuQIes+
	 fdBHDqyw2GBZhc/oN0krFmUQPfPUg6Vl+MiOqf3G7uupj2FSoC3V43zmLTfXL+grIs
	 dZ5PxDulV6e7BHFnh3QhUohF72wZ6XpgH5nsKJ1AAoUeH4sB7UHcWFGDLzKcURsSV1
	 srURhPqw0CpEWObDD+3Iuyva9KuS0GHHV5dRpFHpPUZOl+YVoK4drj/E0XhPLOK85Q
	 wFRlX+RWV8kzQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] scsi: hisi_sas: Clear PHY error counts on phyup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260829032858.1661019-3-yangxingui@huawei.com>
References: <20260829032858.1661019-1-yangxingui@huawei.com>
 <20260829032858.1661019-3-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 29 Aug 2026 03:56:02 +0000
Message-Id: <20260829035602.C6BFA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Log noise suppression logic incorrectly uses cumulative software c=
ounters, failing to suppress logs after the first error.
- [High] The patch fails to clear intermediate link establishment errors be=
cause the interrupt handler processes them before phyup.
- [Medium] Clearing CHL_INT2 interrupt statuses in phy_up_v3_hw races with =
the channel interrupt handler, causing spurious warnings.
- [Medium] Concurrent lockless reads of read-to-clear hardware registers ca=
use non-deterministic error accounting.
--

commit 7c1564a2ad8d2d14ea2f5907d02dc785640e35d4
Author: Xingui Yang <yangxingui@huawei.com>

scsi: hisi_sas: Clear PHY error counts on phyup

This commit clears PHY intermediate error counts generated during link
establishment upon a successful phyup. It aims to prevent logging of stale
error data by clearing hardware counters and only printing errors when they
are non-zero.

> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_s=
as/hisi_sas_v3_hw.c
> index 9c363e2373538..f7e259aff3df1 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -1061,6 +1061,19 @@ static void enable_phy_v3_hw(struct hisi_hba *hisi=
_hba, int phy_no)
>  	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
>  }
> =20
> +static void clear_phy_err_cnt_v3_hw(struct hisi_hba *hisi_hba, int phy_n=
o)
> +{
> +	static const u32 msk =3D BIT(CHL_INT2_RX_DISP_ERR_OFF) |
> +			       BIT(CHL_INT2_RX_CODE_ERR_OFF) |
> +			       BIT(CHL_INT2_RX_INVLD_DW_OFF);
> +
> +	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_INVLD_DW);
> +	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_DISP_ERR);
> +	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_CODE_ERR);

[Severity: Medium]
Could these lockless reads of read-to-clear hardware registers cause
non-deterministic error accounting?

If this runs concurrently with the accounting reads in phy_get_events_v3_hw=
()
from the interrupt handler or sysfs, it seems one of the readers will consu=
me
the register and get zero, leading to lost or corrupted statistics.

> +
> +	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2, msk);
> +}

[Severity: Medium]
Will clearing the CHL_INT2 interrupt statuses here race with the channel
interrupt handler?

When phy_up_v3_hw() calls this function, it writes to CHL_INT2 without
synchronization or masking. If handle_chl_int2_v3_hw() is executing
concurrently on another CPU, it might read CHL_INT2 immediately after it was
cleared. This would result in a read of zero and trigger the spurious warni=
ng:
"channel int 2 received with status bits cleared".

[ ... ]

> @@ -1673,6 +1682,8 @@ static irqreturn_t phy_up_v3_hw(int phy_no, struct =
hisi_hba *hisi_hba)
>  	phy->phy_attached =3D 1;
>  	spin_unlock(&phy->lock);
> =20
> +	clear_phy_err_cnt_v3_hw(hisi_hba, phy_no);
> +

[Severity: High]
Does this clear the hardware counters too late in the process?

Since the CHL_INT2 error interrupts are unmasked by default during link
establishment, any intermediate error will immediately trigger an interrupt.
The handle_chl_int2_v3_hw() handler will process and log these errors before
phy_up_v3_hw() executes this cleanup, which appears to miss the goal of
suppressing those intermediate logs.

[ ... ]

> @@ -1926,15 +1937,18 @@ static void handle_chl_int2_v3_hw(struct hisi_hba=
 *hisi_hba, int phy_no)
> =20
>  		phy_get_events_v3_hw(hisi_hba, phy_no);
> =20
> -		if (irq_value & BIT(CHL_INT2_RX_INVLD_DW_OFF))
> +		if ((irq_value & BIT(CHL_INT2_RX_INVLD_DW_OFF)) &&
> +		    sphy->invalid_dword_count > 0)

[Severity: High]
Does checking the cumulative software counter (sphy->invalid_dword_count)
break the log suppression logic?

Once a single link error occurs, this lifetime counter remains permanently
greater than zero. Subsequent link events will then evaluate this condition
to true and print the stale lifetime total, even if the new hardware error
count is zero. Should this be checking a newly read hardware count instead?

>  			dev_info(dev, "phy%d invalid dword cnt:   %u\n", phy_no,
>  				 sphy->invalid_dword_count);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260829032858.1661=
019-1-yangxingui@huawei.com?part=3D2
