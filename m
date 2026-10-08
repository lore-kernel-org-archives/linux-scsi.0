Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7561C2931F0
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 03:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791430516; cv=none; b=j0XgqGLKPTezX92VjCgz35Mrdl9NCmJFiarL5c+D1jmV0OpkgkT9g7e7KM+AznkFeNkEBWlwd8Jbbc7jTbfT31DdC3zdNDUs4nDicdQdxtthEwJnF9piHVUACI31T7WxWkr/ScocBllZVCylqfvrw7mQV1158B5uFtu+/My9Nak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791430516; c=relaxed/simple;
	bh=+1DgYQTiv7VwJxw/IqZ76J4txGU0ppJY6BueMJqukLE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ruCXvBG/S8xv0cfoX7rQrCT+KVjxWPlQH7TsZi/Ru/44eEX1nIwnz8RI2eiLC5mkbCy0SsItLDNvb/5kfRqLrB1JNExzDXfB/joF8Beu3eDFCBs8hlkuhH8sXgMJPExeiwT7yVqMEaSc6LWnjWq3P0jYlbE74GcBqQD2mfmbLJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aV4J49Pm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aV4J49Pm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4018C1F000FF;
	Thu,  8 Oct 2026 03:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791430515;
	bh=NriW7f7SVlhBXEDzxXupyPztYnAwcJCMZm53GGK/1Nc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aV4J49PmTmqdD0DnU75pYhqNF0v7bkYY/OoNR3IsCBJcX+R/sxwdPq5qbmnOdBP7O
	 l2f+xXg1POVo2ow1ux4K8O3CmXiHzTJBsp0FaJbZDO6MR61rDbbpBpiKttZxIj3icM
	 6fpcQ+aC2dygbhzOmFfkU/+stOXyh4vFHZyNgy/BQ0BJBX8ny+HgU3kTely2FjBnCE
	 9Sj+VTNgk8wW6YUe241rP7NhR1JvmHGDbchHoO3g0Tlk+Cuei+yIhNbeew5E7V6NyR
	 wr3EhrQILUn0rxSQwKgI+orpKDi+lSu3efDiEgVE+/uDYSOPcW/BhYvIR3uCtetQSi
	 mKz1vqONwQSAQ==
Message-ID: <sashiko-outbox-163563@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/4] scsi: hisi_sas: Fix incorrect delay values from
 magic-number cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261008032605.2853026-3-yangxingui@huawei.com>
References: <20261008032605.2853026-1-yangxingui@huawei.com>
 <20261008032605.2853026-3-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 03:35:14 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: hisi_sas: 50ms busy-wait with local interrupts disabled in p=
hy_disable
- [Low] scsi: hisi_sas: Unnecessary 10ms busy wait in sleepable contexts
--

commit 5f2f960c5f34b8a4d831a4867550861d71459fff
Author: Xingui Yang <yangxingui@huawei.com>

scsi: hisi_sas: Fix incorrect delay values from magic-number cleanup

This commit restores original delay values that were incorrectly changed to
100 by replacing a single macro with separate macros for each delay site.
This avoids magic numbers while fixing overly long delays on PHY disable
and host shutdown paths.

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
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[Severity: High]
Does this code execute a 50ms busy-wait with local interrupts disabled?

Looking at hisi_sas_phy_enable(), it acquires phy->lock using
spin_lock_irqsave(), disabling local hardware interrupts on the current CPU:

drivers/scsi/hisi_sas/hisi_sas_main.c:hisi_sas_phy_enable() {
    ...
    spin_lock_irqsave(&phy->lock, flags);
    ...
    if (enable)
        ...
    else
        hisi_hba->hw->phy_disable(hisi_hba, phy_no);
    ...
}

For v3 hardware, this callback resolves to disable_phy_v3_hw(), which
executes a 50ms busy loop via mdelay(DISABLE_PHY_DELAY_MS) while remaining
in atomic context.

Furthermore, hisi_sas_stop_phys() iterates over all PHYs and calls
hisi_sas_phy_enable(..., 0) sequentially. For a controller with multiple
PHYs, this multiplies the delay, resulting in hundreds of milliseconds
of CPU stall with interrupts disabled.

Executing massive busy loops with interrupts disabled blocks scheduling,
drops hardware interrupts, and causes massive system latency, risking soft
lockups. While this patch reduces the delay from 100ms back to 50ms, the
underlying architectural violation in the modified delay path remains.

> =20
>  	state =3D hisi_sas_read32(hisi_hba, PHY_STATE);
>  	if (state & BIT(phy_no)) {
[ ... ]
> @@ -2755,7 +2758,7 @@ static int disable_host_v3_hw(struct hisi_hba *hisi=
_hba)
> =20
>  	hisi_sas_stop_phys(hisi_hba);
> =20
> -	mdelay(HISI_SAS_DELAY_FOR_PHY_DISABLE);
> +	mdelay(DISABLE_HOST_PHY_DELAY_MS);
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[Severity: Low]
Is it necessary to use a 10ms busy loop in sleepable contexts?

disable_host_v3_hw() executes mdelay(DISABLE_HOST_PHY_DELAY_MS), which
constitutes a 10ms CPU busy loop.

This function is called from paths like soft_reset_v3_hw(),
hisi_sas_reset_prepare_v3_hw(), and _suspend_v3_hw(). These callers
operate in sleepable contexts such as PM suspend/resume and device reset
paths where local CPU interrupts are not disabled.

Using mdelay() for a delay as long as 10ms on a sleepable code path wastes
CPU cycles and needlessly increases power consumption. Could this be
replaced with msleep() or usleep_range() instead?

> =20
>  	reg_val =3D hisi_sas_read32(hisi_hba, AXI_MASTER_CFG_BASE +
>  				  AM_CTRL_GLOBAL);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008032605.2853=
026-1-yangxingui@huawei.com?part=3D2
