Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDDA468C05
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 09:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789118768; cv=none; b=q1eKWSZedFMmu+dAKAsYtqqkrJv2z5E/306O1TfWcr7w+lGp34RfJr9sFSgbhRD65Oj89MpeOEQVxGdEQh90lok/VXfFF7GY2qZlUUoeA442lEFCXY6CZC+b6wkCBKXKJ9Bo+LxHqlgo/Dk2EFgNAUs1a4+ppmdIv51h62yGjUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789118768; c=relaxed/simple;
	bh=BxgcLHAU6lgZOkFIjwml4qvVlC7crHDKlRXLnDAY2dQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hojmLU/WrpU7yF+wpZAB1e8ViObPKJXY8NzKKCCYbSEoQN7bSJbexw+72MKTMQx+/jBTZLw55pRccBa56YxNNuzy9WFNsMBwLPQJRw0OYSoGw24L1rGfVme/vwRlpYFuniHPmD22MLpY5BVxj16pPVyGEMGr9OaYYF6Jz8nayUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JATj3qZ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JATj3qZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9771F000FF;
	Fri, 11 Sep 2026 09:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789118766;
	bh=PHoQyxQPqK7dWQd6JmtfjaOW604XanCMNl+2Btobc08=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JATj3qZ8TvkUjGgckli3R1Ys2cLpF9ywPZw9MYPEhih0FAy9lF9Ms4dawbXWHSvuT
	 /k392Heubgc9WNdhFbAxK17rr6Y+XM9HYptPzftaPMEMDPct8ZD23OisxTbR/M0xzk
	 B1ZMU8wJBb0vgS4KBIgeAFcPgizxQFSdHLzu0Js2B7OYEtY9EdtElbSxZa5tnHvmPj
	 eT9E9RVjPbCpXGFi77jSWdA2B7je2HDIAFfgHuotG/HQp+bqtNkSX15IKYBcVhl5aj
	 KI22CbrDes5PG/19pdieQrrgvEqrVUQ6S7sPFszpoTMz5kUY/UOMUiaBaBm/04PcjI
	 XaPZ/IebKIZ0w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/4] scsi: pm8001: free IRQs when HBA allocation fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Peng Hao" <flyingpenghao@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911091011.94676-2-flyingpeng@tencent.com>
References: <20260911091011.94676-1-flyingpeng@tencent.com>
 <20260911091011.94676-2-flyingpeng@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 09:26:05 +0000
Message-Id: <20260911092605.EF9771F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The IRQ handler is registered before queue initialization is compl=
ete, causing a NULL pointer dereference on early/spurious interrupts.
- [High] Invalid offset virtual address passed to dma_free_coherent() when =
freeing MPI memory regions.
--

commit 9749644d500951b76d7ccb7050664ddfe58c9592
Author: Peng Hao <flyingpenghao@gmail.com>

scsi: pm8001: free IRQs when HBA allocation fails

pm8001_alloc() registers the interrupt handlers before allocating the MPI
memory regions and device array. If one of those later allocations fails,
pm8001_pci_alloc() frees the HBA while the IRQ handlers remain registered.
This patch releases the IRQs on every failure after successful registration
and kills the initialized tasklets before freeing the HBA.

> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -323,9 +323,8 @@ static int pm8001_alloc(struct pm8001_hba_info *pm800=
1_ha,
>  		   pm8001_ha->chip->n_phy);
> =20
>  	/* Request Interrupt */
> -	rc =3D pm8001_request_irq(pm8001_ha);
> -	if (rc)
> -		goto err_out;
> +	if (pm8001_request_irq(pm8001_ha))
> +		return 1;

[Severity: High]
This is a pre-existing issue, but since we are modifying the IRQ registrati=
on=20
path here, is it safe to request the interrupt before the chip and memory=20
queues are initialized?

If an interrupt fires early (e.g., from an unquiesced device via kexec, or =
a=20
spurious interrupt on a shared INT-x line), the tasklet can be scheduled.=20
The tasklet executes pm8001_chip_isr(), which calls process_oq().

In drivers/scsi/pm8001/pm8001_hwi.c:process_oq():

    circularQ->producer_index =3D
        cpu_to_le32(pm8001_read_32(circularQ->pi_virt));

This unconditionally dereferences circularQ->pi_virt, but pi_virt is not=20
populated until much later in the initialization sequence. Could this cause=
 a=20
NULL pointer dereference on early or spurious interrupts?

[ ... ]

> @@ -575,6 +563,7 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struc=
t pci_dev *pdev,
>  	if (!pm8001_alloc(pm8001_ha, ent))
>  		return pm8001_ha;
>  failed_pci_alloc:
> +	pm8001_kill_tasklet(pm8001_ha);
>  	pm8001_free(pm8001_ha);
>  	return NULL;
>  }

[Severity: High]
This isn't a bug introduced by this patch, but does the memory-region clean=
up=20
in pm8001_free() violate the DMA API by passing an offset virtual address?

During allocation in pm8001_mem_alloc() (in drivers/scsi/pm8001/pm8001_sas.=
c),
the virtual pointer is manually aligned:

    *virt_addr =3D (void *)mem_virt_alloc + phys_align - *pphys_addr;

This modifies the virtual pointer away from the original value returned by=
=20
dma_alloc_coherent(). When pm8001_free() iterates over the memoryMap.region=
=20
array to free the memory, it unconditionally passes this shifted virt_ptr a=
s=20
the cpu_addr argument to dma_free_coherent().

The DMA API strictly requires the exact virtual address originally returned=
 by=20
dma_alloc_coherent() to be passed when freeing. Can passing this shifted=20
pointer result in undefined behavior or a panic from the DMA allocator duri=
ng=20
driver unload or probe failure?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911091011.9467=
6-1-flyingpeng@tencent.com?part=3D1
