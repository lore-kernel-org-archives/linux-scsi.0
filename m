Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F9525B08D
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 03:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791431220; cv=none; b=KT3e1+bcP5Jdv06vZTbRkFOw6siUWJYyk1mMxnVvPxwBx29GE3DsxwhMpCzYuzPGkColB6H5X9B8MUw+alby7qmx2nLMxy0inGbvDt9IMHy9NfXSyjDF4c7bmpfNQRzCOq8CbGdL29WuojY+Cv9POd4MPr0zhpkAF+sCBM4sCR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791431220; c=relaxed/simple;
	bh=bLKhDNBsx2JsuZSiJ3f/1EmKD/pycfDcvmpwC+LYG5I=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=k8gdh34ge4xMYLEhZeG1KAqlpx4CxD3ZhN0Oz/hdlRpam2TnIxmdtbgHb0df8nyuE6NNTvhE7+KTJNy9MEWabzQz74SksrsozG+cy8GjeesJxDpCESam2od2nfmRKXfpbIRnHRkDlNs+LHDFJEAp55lJN5oBdSlVJzv/SftOgQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cDjz64Ck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cDjz64Ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BD61F000FF;
	Thu,  8 Oct 2026 03:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791431218;
	bh=Q1ZdFofrbgKap7sGz5UdiFRAqt/xmhDtupoO5/f+DJY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cDjz64CkB/6GLxsp/JtGhJh2NtKx5pzndNMOpk3IeInHODlm0PfSP22hTXl1U/8JK
	 gyTULjQONBdADXy6ixf/TVyh7sz29Eu3Bmv/l13DVWyPMwTP/MlEav0/EO9NoE19F+
	 e0UmYXBZN5nfim/EqH70R3x6cuMgS7UaD2Ju4eqXcJVZ9eTPI02gdDIhI6fGKwT/0x
	 6WQn57UgnRGr1Zo8xoaFETU8uICkNa88Pdr9ktYT0WrLhKRXCXPe9YyRK59ANDdZ1l
	 u/ylmDh7ValUCDUuAc1mXE67GuuFQW1khn/caI6lyluNP5Qm/3/qjfWbdgwlrHzDHG
	 hCCCewn8rxW8Q==
Message-ID: <sashiko-outbox-163581@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/4] scsi: hisi_sas: Fix spinup failure for SAS SSP
 devices in Active_Wait state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261008032605.2853026-5-yangxingui@huawei.com>
References: <20261008032605.2853026-1-yangxingui@huawei.com>
 <20261008032605.2853026-5-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 03:46:58 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: hisi_sas: hardware access on suspended device via late CQ in=
terrupt
- [Medium] pm: pm_runtime_get_noresume() used in IRQ handler instead of pm_=
runtime_get_if_active()
--

commit 8d6af7e7596b04b1c535c9ae957073a4a940e9cc
Author: Xingui Yang <yangxingui@huawei.com>

scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_Wait state

This commit fixes a spinup failure for SAS SSP devices by parsing the sense
data in the slot completion path. When LU_NOT_READY_NOTIFY_REQUIRED is
returned, it queues a work item to send a spinup notify primitive while
taking a runtime PM reference.

> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sa=
s/hisi_sas_main.c
> index 944ce19ae2fc1..f3b6bb510a71e 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -996,10 +996,25 @@ static void hisi_sas_phyup_pm_work(struct work_stru=
ct *work)
>  	pm_runtime_put_sync(dev);
>  }
> =20
> +static void hisi_sas_spinup_notify_work(struct work_struct *work)
> +{
> +	struct hisi_sas_phy *phy =3D
> +		container_of(work, typeof(*phy), works[HISI_PHYE_SPINUP_NOTIFY]);
> +	struct hisi_hba *hisi_hba =3D phy->hisi_hba;
> +	struct device *dev =3D hisi_hba->dev;
> +	int phy_no =3D phy->sas_phy.id;
> +
> +	hisi_hba->hw->sl_notify_ssp(hisi_hba, phy_no);

[Severity: High]
Could this work item execute after the hardware is suspended?=20

If a completion queue interrupt fires during suspend, it could happen in the
window between the workqueue flush and disabling interrupts:

_suspend_v3_hw()
    flush_workqueue(hisi_hba->wq);
    // interrupt fires -> hisi_sas_spinup_notify() queues this work
    interrupt_disable_v3_hw(hisi_hba);

Because the interrupt handler queues this work to a non-freezable workqueue=
,=20
it can execute concurrently with or after the host is disabled. If the=20
controller's bus is shut down by the time sl_notify_ssp() accesses MMIO=20
registers, will this cause a system freeze or panic?

> +	dev_info(dev, "spinup notify primitive on phy%d\n", phy_no);
> +
> +	pm_runtime_put_sync(dev);
> +}

[ ... ]

> @@ -1639,6 +1654,33 @@ void hisi_sas_controller_reset_done(struct hisi_hb=
a *hisi_hba)
>  }
>  EXPORT_SYMBOL_GPL(hisi_sas_controller_reset_done);
> =20
> +void hisi_sas_spinup_notify(struct hisi_hba *hisi_hba,
> +			    struct sas_task *task)
> +{
> +	struct task_status_struct *ts =3D &task->task_status;
> +	struct domain_device *dev =3D task->dev;
> +	struct scsi_sense_hdr sshdr;
> +	struct sas_phy *local_phy;
> +	struct hisi_sas_phy *phy;
> +
> +	if (!scsi_normalize_sense(ts->buf, ts->buf_valid_size, &sshdr))
> +		return;
> +
> +	if (sshdr.sense_key !=3D NOT_READY ||
> +	    sshdr.sense_code !=3D LU_NOT_READY_NOTIFY_REQUIRED)
> +		return;
> +
> +	local_phy =3D sas_get_local_phy(dev);
> +	phy =3D &hisi_hba->phy[local_phy->number];
> +
> +	pm_runtime_get_noresume(hisi_hba->dev);

[Severity: Medium]
The PM subsystem guidelines state that IRQ handlers should use=20
pm_runtime_get_if_active() rather than pm_runtime_get_noresume().=20

Since hisi_sas_spinup_notify() is called directly from hardware completion=
=20
interrupt handlers, could this blindly increment the usage counter on a=20
device that is already suspended or transitioning to suspend?=20

Using pm_runtime_get_if_active() would verify the device is actually active=
=20
and prevent queuing the spinup notify work when the controller is powering
down.

> +	if (!hisi_sas_notify_phy_event(phy, HISI_PHYE_SPINUP_NOTIFY))
> +		pm_runtime_put(hisi_hba->dev);
> +
> +	sas_put_local_phy(local_phy);
> +}
> +EXPORT_SYMBOL_GPL(hisi_sas_spinup_notify);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008032605.2853=
026-1-yangxingui@huawei.com?part=3D4
