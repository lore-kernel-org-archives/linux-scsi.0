Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B694A199E89
	for <linux-scsi@vger.kernel.org>; Sat, 29 Aug 2026 03:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787975806; cv=none; b=E0J3C42ppf6/05lGGzE2HcX7EE0z511iTpLvS/Sb60Flyn0Y8ylWHp9jmUpJbEs7hbWhEO/sVgj1j08HZ98mn45KKwTTpDrO2pw5CXLb6DFg5sTHCvkqeOWVKeQ5Xg8WY49tzcVCaNkAlG49s3X/+nTTZMOTK7dLN7EkfuVtGKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787975806; c=relaxed/simple;
	bh=1lCDRr+gC4H90EXd6Qxjzh9eF6064D/FjYBvqpOOrkM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cyvcS2kWmC3IsfjUerMwmAJaRKgFWh9+XBTHDS6Pj4ogar3Vgy4JFSkqiId06RSUblTD2tbcTQfcaPecRdiZasxqSQneFjdNkoJhWLsjmmeuDxwLaHSTZfAuBZ5d4jvPk2TE9n/YJ6Z5/NihMM4dquqJeDCc2HU4JcCasi+H4mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fTGu7MtA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fTGu7MtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32ED11F000E9;
	Sat, 29 Aug 2026 03:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787975804;
	bh=BVLHG+iyzy7MidAyxNUXt298bYlOXcBVc4lCzZGPYto=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fTGu7MtASl9PcYBqcHUslXeaVI4h3OZdwh8m9P8BKVrhn9OghobZZu14OynksZ9N7
	 EDQ/aBdFIZ9zPybIVebBabTlS/I/WZ70t6MalSFyweYGr6HvCmftRwrNAV0c2k8ZL1
	 9giD47cE+ueU5R5tKcUMur6YmELa5pbNC6MWy7MUJRQ9dc6zGEd1mc+dXeV+dzstZo
	 RvS/RS3LpkDZDXxDGQorZFdDugICSytM/TnWjvlUNMC7QLZMysvkKNI40NsCo/J1oE
	 Pr2LmuTunp6wxzvRJFwbMWZWHWCi3i05LcpwbcgT+PiU0ZQsjtLaiK3OrVh9zlhmRh
	 ySg3wgnqhPYuA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] scsi: hisi_sas: Fix spinup failure for SAS SSP
 devices in Active_Wait state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260829032858.1661019-4-yangxingui@huawei.com>
References: <20260829032858.1661019-1-yangxingui@huawei.com>
 <20260829032858.1661019-4-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 29 Aug 2026 03:56:43 +0000
Message-Id: <20260829035644.32ED11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] The asynchronous work `hisi_sas_spinup_notify_work` accesses MMIO =
registers without acquiring a runtime PM reference, potentially accessing u=
nclocked hardware and causing bus faults.

Pre-existing issues:
- [Critical] Integer overflow in `min_t` causes a massive out-of-bounds `me=
mcpy` when processing malicious SAS sense data.
- [High] Read-modify-write race on the `SL_CONTROL` register between proces=
s context and hardirq context can lead to lost hardware state updates.
- [High] Race condition in suspend path allows hardware access after device=
 is disabled due to improper `flush_workqueue()` ordering.
--

commit 02edb194a91901ddad40e4d837a58a4131b5ffa4
Author: Xingui Yang <yangxingui@huawei.com>

scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_Wait state

This commit fixes a spinup failure for SAS SSP devices powered up with RNOT=
=3D1.
It parses sense data in the driver's slot completion path and queues a defe=
rred
work item to notify the phy to spin up the device.

> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sa=
s/hisi_sas_main.c
> index 944ce19ae2fc1..1cb578e6ae593 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -996,10 +996,22 @@ static void hisi_sas_phyup_pm_work(struct work_stru=
ct *work)
>  	pm_runtime_put_sync(dev);
>  }
> =20
> +static void hisi_sas_spinup_notify_work(struct work_struct *work)
> +{
> +	struct hisi_sas_phy *phy =3D
> +		container_of(work, typeof(*phy), works[HISI_PHYE_SPINUP_NOTIFY]);
> +	struct hisi_hba *hisi_hba =3D phy->hisi_hba;
> +	int phy_no =3D phy->sas_phy.id;
> +
> +	hisi_hba->hw->sl_notify_ssp(hisi_hba, phy_no);

[Severity: High]
Could this MMIO access happen while the device is in a suspended state?

When hisi_sas_spinup_notify() queues the HISI_PHYE_SPINUP_NOTIFY work, it
does not take a runtime PM reference on the HBA. Once the completed SAS task
finishes, the block layer can release its runtime PM reference on the devic=
e.

If the system is under load and the work execution is delayed beyond the
autosuspend timeout, the host controller might enter runtime suspend. When
hisi_sas_spinup_notify_work() eventually executes, it calls
hisi_hba->hw->sl_notify_ssp(), which directly reads and writes hardware
registers.

Would it be safer to wrap this hardware access with pm_runtime_get_sync()
and pm_runtime_put_sync() to prevent synchronous bus faults or invalid
reads on unclocked hardware?

[Severity: High]
This is a pre-existing issue, but does sl_notify_ssp() contain a
read-modify-write race with hardirq contexts?

For example, in sl_notify_ssp_v3_hw() (called here via workqueue in process
context), the code performs a lockless read-modify-write on the SL_CONTROL
register:

sl_control =3D hisi_sas_phy_read32(hisi_hba, phy_no, SL_CONTROL);
sl_control |=3D SL_CONTROL_NOTIFY_EN_MSK;
hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL, sl_control);

However, phy_down_v3_hw() (called from the int_phy_up_down_bcast_v3_hw
hardirq handler) also performs a lockless read-modify-write on the same
SL_CONTROL register. Since sl_notify_ssp_v3_hw() doesn't disable interrupts
or hold a spinlock, can the interrupt fire exactly between its read and
write, causing the interrupt's modification to be completely overwritten
and lost?

> +	dev_info(hisi_hba->dev, "spinup notify primitive on phy%d\n", phy_no);
> +}
> +
>  static const work_func_t hisi_sas_phye_fns[HISI_PHYES_NUM] =3D {
>  	[HISI_PHYE_PHY_UP] =3D hisi_sas_phyup_work,
>  	[HISI_PHYE_LINK_RESET] =3D hisi_sas_linkreset_work,
>  	[HISI_PHYE_PHY_UP_PM] =3D hisi_sas_phyup_pm_work,
> +	[HISI_PHYE_SPINUP_NOTIFY] =3D hisi_sas_spinup_notify_work,

[Severity: High]
This is a pre-existing issue, but could there be a race condition in the
suspend path that executes newly queued work on disabled hardware?

In _suspend_v3_hw(), the workqueue is flushed before threaded IRQs are
silenced:

flush_workqueue(hisi_hba->wq);
interrupt_disable_v3_hw(hisi_hba);

Because the driver uses threaded IRQs, an interrupt could have already woken
the IRQ thread before interrupt_disable_v3_hw() runs. The IRQ thread (calli=
ng
slot_complete_v3_hw()) can queue new work items like HISI_PHYE_SPINUP_NOTIFY
to hisi_hba->wq after the flush_workqueue() call has returned.

Will these newly queued works then execute and access hardware registers
concurrently with or after disable_host_v3_hw(), leading to illegal
accesses on disabled or suspended hardware?

[ ... ]

> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_s=
as/hisi_sas_v1_hw.c
> index fa94d7110714f..9d89db6e8716e 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> @@ -1272,6 +1272,9 @@ static void slot_complete_v1_hw(struct hisi_hba *hi=
si_hba,
>  				&status_buffer->iu[0];
> =20
>  		sas_ssp_task_response(dev, task, iu);

[Severity: Critical]
This isn't a bug introduced by this patch, but is there a potential integer
overflow leading to a buffer overflow when sas_ssp_task_response() processes
malicious SAS sense data?

In sas_ssp_task_response() (called here), iu->sense_data_len is converted
to CPU byte order and bounded using min_t():

tstat->buf_valid_size =3D
    min_t(int, SAS_STATUS_BUF_SIZE,
          be32_to_cpu(iu->sense_data_len));

Because both arguments are cast to int, if a malicious or malformed device
provides a sense_data_len like 0xFFFFFFFF, the cast results in -1. Since
-1 < 96, min_t() returns -1.

When this -1 is passed to the subsequent memcpy(tstat->buf, iu->sense_data,
tstat->buf_valid_size), it is interpreted as a massive size_t value.=20
Can this cause an immediate out-of-bounds read from the DMA buffer and a=20
massive out-of-bounds write to kernel memory?

> +		if (ts->stat =3D=3D SAS_SAM_STAT_CHECK_CONDITION &&
> +		    !dev_parent_is_expander(device))
> +			hisi_sas_spinup_notify(hisi_hba, task);
>  		break;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260829032858.1661=
019-1-yangxingui@huawei.com?part=3D3
