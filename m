Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30663947B5
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 09:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789118751; cv=none; b=miHfmc94QvAnnhS0qukDi4bzWvHKgqnhp7wb44cG+fU+efvJ7QtbBFHgkC5DP17Y19Xsyi8Aalu4FRzghXJvP1EqO9YpqYrnZK1aLRgx6SsoMX1/7sCPfTWpFPXz6aMrYU8UIQ5g3pM39oYJ9xDVblyKcjPv0UrFnxCZsBw1tv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789118751; c=relaxed/simple;
	bh=cf3sBVSVrECw/XYh5/LKnZkcga85ypEBO2WnDGKYfIo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pVhjj/wGYcdGfh0uJ2ilNOv8oPxQIqDB4Eg2I5LEb2Oamj/akb2cbyOtm++vl4jAKfLQS0KldxENJaVH6YnsQrripfr/8jlGUH82qV/JBEtd7llw6TRUl/WAzoWnV1JUAPfJhwSRKJWKnB60RSWh90vNuVjk8TTAjSUow/HnGFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I3P6YyAQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I3P6YyAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE1F1F000FF;
	Fri, 11 Sep 2026 09:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789118750;
	bh=UMAcuTAmeq9ndIa9vtcIuuhgAgCABXKcr/IzIrjViEA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I3P6YyAQsjCbF+z8Ecm6hRbDXeVscAq8MgThI9GVvolMs5b5+/b4NmSIB2UpIOqh8
	 WbfZ+9/z6U4O6gA+iO+aqqMj/DwauGubIiM0XxO7eEhJkJTH1Kde/Zpl8ZdCbX8yU8
	 cLRSLKLg3zXQLb2wR9Gg9ZfGFvOzf6DIKVtX7ndVjZ+z6yc/PSr8kmU7JcLQYDfxPt
	 dIbVPUTydzU7Oz+bgfOH8GbcjUVX/Qy3j+ZgG1Tt60n61IjTiAfstytlgTM9z7tCtb
	 8Uzn1pi0YrMnnOxPVUS5QYBOuoiy2a+/Y8hABjPUw0RtJi8s0IAaDmMlb+L8goEd8r
	 Fdr7HHIE1SULA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] scsi: pm8001: clean up resources on probe failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Peng Hao" <flyingpenghao@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911091011.94676-3-flyingpeng@tencent.com>
References: <20260911091011.94676-1-flyingpeng@tencent.com>
 <20260911091011.94676-3-flyingpeng@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 09:25:49 +0000
Message-Id: <20260911092550.4BE1F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Hardware soft reset is initiated before tearing down tasklets and =
IRQs, allowing concurrent MMIO accesses during reset.
- [High] Workqueue flushed after freeing DMA memory and unmapping MMIO regi=
sters, leading to use-after-free and use-after-unmap.
--

commit 701715eef41b511a0a6a9cbd9e7c8e9908bfcfc9
Author: Peng Hao <flyingpenghao@gmail.com>
scsi: pm8001: clean up resources on probe failure

This commit improves resource cleanup on probe failures in the pm8001 drive=
r.
It routes failures through the standard teardown chain and correctly resets
the chip. It also adds logic to release SAS arrays when initialization fail=
s.

> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
> index d0e91ed09bbe9..20b02e63be8c9 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> [ ... ]
> @@ -1216,8 +1216,16 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
> =20
>  err_out_shost:
>  	scsi_remove_host(pm8001_ha->shost);
> +err_out_chip:
> +	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
> +	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
>  err_out_ha_free:
> +	pm8001_free_irq(pm8001_ha);
> +	pm8001_kill_tasklet(pm8001_ha);

[Severity: High]
This is a pre-existing issue, but does this ordering allow concurrent MMIO
accesses during the hardware soft reset?

In the newly introduced err_out_chip error path of pm8001_pci_probe(),
chip_soft_rst() is called before pm8001_free_irq() and pm8001_kill_tasklet(=
).
If an interrupt fires immediately before interrupt_disable(), a tasklet can
be scheduled.

This tasklet could then execute concurrently on another CPU during the leng=
thy
soft reset window, accessing chip MMIO registers via pm8001_chip_isr() and
triggering PCI bus errors like a PCI Master Abort.

Could we tear down the tasklets and IRQs before initiating the soft reset?

>  	pm8001_free(pm8001_ha);

[Severity: High]
This is also a pre-existing issue, but can this lead to a use-after-free
or use-after-unmap if a delayed work item executes?

When pm8001_free() is called here, it unmaps MMIO and frees memory before
flushing the workqueue:

pm8001_free() {
    ...
    dma_free_coherent(...)
    PM8001_CHIP_DISP->chip_iounmap(pm8001_ha);
    flush_workqueue(pm8001_wq);
}

Because interrupts are enabled earlier in pm8001_pci_probe() prior to
pm8001_init_sas_add(), any work item queued by an interrupt during this
window could execute concurrently with or after the unmapping.

The delayed work item could then write to the now-freed DMA memory and acce=
ss
unmapped MMIO.

Should the workqueue be flushed before freeing DMA memory and unmapping
the MMIO registers?

> +err_out_free_sas_ha:
> +	kfree(sha->sas_phy);
> +	kfree(sha->sas_port);
>  err_out_free:
>  	kfree(sha);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911091011.9467=
6-1-flyingpeng@tencent.com?part=3D2
