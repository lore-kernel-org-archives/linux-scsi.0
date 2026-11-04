Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759161;
	b=fyHWWAZIwCL0es6NwWYpgDrlyLOuBCkI8SC8ajfw3ymRjJg9clodsyG2mDRbz3ux/HxA
	 y5Z0IMwUqhgkhlQmfefBp+ccw2leFzdrdGjM2PHCgXAjteST5NYACJcP48yLiOLAkJOUW
	 l3fNU8wf4KqM8w5OesUkzOJKQPmt/6LYPlgk6WeAwyvJLibbOsLPOqNgkgp2fRvXLZOWn
	 oMQS86aW3DB5AMvkpMbgLbmBunRKUCFo1pK5TOsdPy8WopeqNF7Gr/nHXfsTgCfmON6+z
	 zUtZWwRSfk8rzKL0Bla2SohRTx5/Vs+c8AAdBI8hGd9myuaPAPYIncQ/V9irbUDaRvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759161;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=A13Bw1HFMytSYoyHHGxC/miljqDeX5CTomtPscoqxhQ=;
	b=oSE/gVOhiMFlH5M7GjVVL/GuY7J6b1xYXQATLlxb6+ZEmDQ9jIshbT0jVhSBlEM6o4QH
	 LKDBjBILoFGjtLsfyogT5PGOWWfQC4zE9R8xnD2TcoFMWI4Q+maNGdrmpYYVmlLHXQ0cw
	 jALBelZjTZ7oxhYJRdmtZoSF/G1YYHz20uvL5+CAj9Qujg86rkNLTSHqttzwmeHvRRXxo
	 dGu4G/nXcy9xRTv0JoehO4fXER9PLztLaQ72JH7LRJkK5FzTEnL3kgt1E5kAXBm7B2pfv
	 IFSEbr8m1gEyUCpvpejqOJbJH6maq8e9gowTNwS7TAJoJHprEPPR7qbx+668akhsC7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FAmQYOXN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955F6606A329
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FAmQYOXN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8D11F000C1;
	Wed,  4 Nov 2026 02:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793759161;
	bh=A13Bw1HFMytSYoyHHGxC/miljqDeX5CTomtPscoqxhQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FAmQYOXNHK5gNKYaLOMDM/lpiH0pyn9NuCUODCQRp73g2xlWfU37qgRrxmwUKsS5w
	 LKjD3Q/i1nj9Qn0MJqLT3S0JLhfVgZWYzfv/rzOTENNm+oyap9S4Jm3mVheyZ8No0T
	 qlQwsjZjhCL3wS6Qylt1CDTa4jiwHLVSrSQs+j0JnCnr6czZ1+F0uzRI3v1QLoID7G
	 Zu6EObOUD3NdtCp3jP66UdUiRU/vhZz2HczHZBRDquVTwmpPN4dmYQjlHqTJPQJ8Fo
	 xoui4rLcdz5fO3HzxtfDXjkouCPi3UhGne4rcZmhadUy6twWM0tzW4hmcL11/XMy6A
	 TZSxuLfEJvotg==
Message-ID: <sashiko-outbox-196457@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: pm8001: unwind the probe on ccb tag allocation
 failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261104021411.1467970-1-vulab@iscas.ac.cn>
References: <20261104021411.1467970-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 02:26:00 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] scsi: pm8001: use-after-free via active IRQs in pm8001_pci_probe()
- [High] scsi: pm8001: DMA regions freed while MPI is active in pm8001_pci_=
probe()
- [Medium] scsi: pm8001: memory leaks on ccb tag failure unwind in pm8001_p=
ci_probe()
--

commit 06b680982a72c843fb06984b05c4494852d0cf98
Author: Wentao Liang <vulab@iscas.ac.cn>

scsi: pm8001: unwind the probe on ccb tag allocation failure

This commit changes the error handling path in pm8001_pci_probe() when
pm8001_init_ccb_tag() fails, jumping to err_out_ha_free instead of
err_out_enable to release previously allocated resources.

> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
> index 5af81c73a8f87..389649b36aabd 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1178,7 +1178,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
> =20
>  	rc =3D pm8001_init_ccb_tag(pm8001_ha);
>  	if (rc)
> -		goto err_out_enable;
> +		goto err_out_ha_free;

[Severity: High]
Can jumping to err_out_ha_free here leave active interrupt handlers
registered with dangling pointers into freed pm8001_ha and sha memory?

Before pm8001_init_ccb_tag() runs, pm8001_pci_probe() calls
pm8001_pci_alloc() -> pm8001_init_tasklet() and pm8001_alloc() ->
pm8001_request_irq().

In MSI-X mode, pm8001_request_msix() registers IRQ handlers pointing into
pm8001_ha:

drivers/scsi/pm8001/pm8001_init.c:pm8001_request_msix() {
	...
		rc =3D request_irq(pci_irq_vector(pm8001_ha->pdev, i),
			pm8001_interrupt_handler_msix, flag,
			pm8001_ha->intr_drvname[i],
			&(pm8001_ha->irq_vector[i]));
	...
}

In INT-X mode, pm8001_request_irq() registers a shared IRQ handler with
pm8001_ha->name and sha:

drivers/scsi/pm8001/pm8001_init.c:pm8001_request_irq() {
	...
	return request_irq(pdev->irq, pm8001_interrupt_handler_intx,
			   IRQF_SHARED, pm8001_ha->name,
			   SHOST_TO_SAS_HA(pm8001_ha->shost));
}

When pm8001_init_ccb_tag() fails, the err_out_ha_free path calls
pm8001_free(pm8001_ha) and kfree(sha) without calling
pm8001_free_irq(pm8001_ha) or pm8001_kill_tasklet(pm8001_ha) (unlike
pm8001_pci_remove()):

drivers/scsi/pm8001/pm8001_init.c:pm8001_pci_probe() {
	...
err_out_ha_free:
	pm8001_free(pm8001_ha);
err_out_free:
	kfree(sha);
	...
}

If a shared INT-X interrupt fires afterwards, pm8001_interrupt_handler_intx=
()
will dereference the freed sha and pm8001_ha structures and read unmapped M=
MIO
registers, and reading /proc/interrupts will dereference the freed devname
strings in pm8001_ha->intr_drvname[i] or pm8001_ha->name.

[Severity: High]
Also on the err_out_ha_free path, does pm8001_free() release coherent DMA
memory while the controller MPI engine is still active?

In pm8001_pci_probe(), PM8001_CHIP_DISP->chip_init(pm8001_ha) succeeds right
before pm8001_init_ccb_tag() is called, which programs the physical DMA
addresses of pm8001_ha->memoryMap.region[] (inbound/outbound queues,
producer/consumer indices, and firmware event logs) into the controller and
enables the firmware MPI state machine via mpi_init_check().

When pm8001_init_ccb_tag() fails and jumps to err_out_ha_free, pm8001_free()
immediately frees those DMA regions without first calling
PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha) to uninitialize the MPI engine a=
nd
reset the chip (as pm8001_pci_remove() does before calling pm8001_free()):

drivers/scsi/pm8001/pm8001_init.c:pm8001_free() {
	...
	for (i =3D 0; i < USI_MAX_MEMCNT; i++) {
		if (pm8001_ha->memoryMap.region[i].virt_ptr !=3D NULL) {
			dma_free_coherent(&pm8001_ha->pdev->dev,
				(pm8001_ha->memoryMap.region[i].total_len +
				pm8001_ha->memoryMap.region[i].alignment),
				pm8001_ha->memoryMap.region[i].virt_ptr,
				pm8001_ha->memoryMap.region[i].phys_addr);
			}
	}
	PM8001_CHIP_DISP->chip_iounmap(pm8001_ha);
	...
}

Should chip_soft_rst() be called before pm8001_free() so the controller can=
not
DMA into the freed memoryMap.region[] buffers?

[Severity: Medium]
Finally, does unwinding to err_out_ha_free on pm8001_init_ccb_tag() failure
still leak sha->sas_phy, sha->sas_port, pm8001_ha->devices,
pm8001_ha->ccb_info, and partially allocated pm8001_ha->ccb_info[i].buf_prd
DMA buffers?

Inside pm8001_init_ccb_tag(), if bitmap_zalloc() for pm8001_ha->rsvd_tags
fails, or if dma_alloc_coherent() for pm8001_ha->ccb_info[i].buf_prd fails =
at
iteration i, it jumps to err_out:

drivers/scsi/pm8001/pm8001_init.c:pm8001_init_ccb_tag() {
	...
	pm8001_ha->rsvd_tags =3D bitmap_zalloc(PM8001_RESERVE_SLOT, GFP_KERNEL);
	if (!pm8001_ha->rsvd_tags)
		goto err_out;
	...
	for (i =3D 0; i < ccb_count; i++) {
		pm8001_ha->ccb_info[i].buf_prd =3D dma_alloc_coherent(dev,
				sizeof(struct pm8001_prd) * PM8001_MAX_DMA_SG,
				&pm8001_ha->ccb_info[i].ccb_dma_handle,
				GFP_KERNEL);
		if (!pm8001_ha->ccb_info[i].buf_prd) {
			pm8001_dbg(pm8001_ha, FAIL,
				   "ccb prd memory allocation error\n");
			goto err_out;
		}
		...
	}

	return 0;

err_out_noccb:
	kfree(pm8001_ha->devices);
err_out:
	return -ENOMEM;
}

Jumping to err_out bypasses kfree(pm8001_ha->devices) (allocated in
pm8001_alloc()) and leaves pm8001_ha->ccb_info and any already allocated
pm8001_ha->ccb_info[0..i-1].buf_prd buffers unfreed. Neither pm8001_free() =
nor
err_out_free frees those allocations, nor do they free sha->sas_phy and
sha->sas_port (allocated in pm8001_prep_sas_ha_init()) before kfree(sha) is
called.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104021411.1467=
970-1-vulab@iscas.ac.cn?part=3D1
