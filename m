Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EC6366074
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 05:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783057647; cv=none; b=KFBLyzbSGnvpVUitW01oDlnL8/HR80enjN4bdKhaYnQVOs4qOXL5i6Wr9ekOG6MW05W4ZbW4y12KUwJjdLaTnNviJj9/WWYA75cH0d0U3P4L0xJnuCC4FbNJ9bNYU9rUhFf2OWRSCpdM68VpyqDjgVjW5wm3331Rl4nUno3FINc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783057647; c=relaxed/simple;
	bh=suTfpO1/V4rv7+69STacTD+deUIPH7hZ+v9Mzcr8eQg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Pt+yfv3DUFiwrKjXoB/uvVF92LyxhiYSbEmv5411Vam+IF6GLPIqpGGUBXYF2isdoouR+5aS8LTh/73Er779tZRTrnhNpPfNpsJHrEY3wKOFla/iiShszqU20fki+JH6s6CQBaeb4H2DkiHeQa9GYRHck/IWRKX3X/k1y5KeLpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gAd5Bt9b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gAd5Bt9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FA01F000E9;
	Fri,  3 Jul 2026 05:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783057638;
	bh=Yezqf+2ORO+MdR2KDKc1SeMGrlcmFV0UGrSJfyNV+fU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gAd5Bt9bkLgGe9pb/pBSpIb6vN2QjeKDcqxuMQL2aobtefGDHEO9+BY/PVSM4ITlK
	 oUEyG7X0oHyyny4KVee0oHk5gaeR9HOcKQ1WjHR0PIUUyGMcRS7qdIYc2hT0KXPnyS
	 0H2X8KdIOHHSurFXh/IeP3qZ54R4AgYMDs68pKjSZuKFfldGYmyd87TsoKuK9X7lKp
	 qeQuQrZk91FhBxC2tEQdzV5x9p46DzwUhCieiXmocgCWi8rd3tqefN7njQ1kVcEZZj
	 kN8Fuxuc5/DfT545NeOPF7fgpZ6Ihoy+v3w9/gdmn+YOiivmKjSG/erQ9t9Ak0lOW9
	 FJ1qgEN4asYog==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1] scsi: be2iscsi: Fix MSI-X IRQ unwind on request
 failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuho Choi" <dbgh9129@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703053055.141337-1-dbgh9129@gmail.com>
References: <20260703053055.141337-1-dbgh9129@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 05:47:16 +0000
Message-Id: <20260703054717.A6FA01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Erroneous error handling of pci_alloc_irq_vectors_affinity() in be=
2iscsi_enable_msix() restricts MSI-X to 1 CPU on success, and causes a buff=
er overflow on failure.
--

commit 770fa6df2516c59abfdd643e359fed37ffae37ec
Author: Yuho Choi <dbgh9129@gmail.com>

scsi: be2iscsi: Fix MSI-X IRQ unwind on request failure

This commit fixes the MSI-X IRQ unwind loop in beiscsi_init_irqs() when a
later request_irq() fails. It changes the vector index passed to
pci_irq_vector() from the failing index i to the current unwind index j to
correctly free the registered IRQs.

> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_m=
ain.c
> index fd18d4d3d219b..9833ab06b299a 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -878,7 +878,7 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
>  	return 0;
>  free_msix_irqs:
>  	for (j =3D i - 1; j >=3D 0; j--) {
> -		free_irq(pci_irq_vector(pcidev, i), &phwi_context->be_eq[j]);
> +		free_irq(pci_irq_vector(pcidev, j), &phwi_context->be_eq[j]);

[Severity: High]
This is a pre-existing issue, but since this unwinding code depends on i
which iterates up to phba->num_cpus, can this loop result in a buffer
overflow?

Looking at be2iscsi_enable_msix(), it appears the error handling logic is
inverted when calling pci_alloc_irq_vectors_affinity():

drivers/scsi/be2iscsi/be_main.c:be2iscsi_enable_msix() {
    ...
		if (pci_alloc_irq_vectors_affinity(phba->pcidev, 2, nvec,
				PCI_IRQ_MSIX | PCI_IRQ_AFFINITY, &desc) < 0) {
			phba->num_cpus =3D nvec - 1;
			return;
		}
	}

	phba->num_cpus =3D 1;
    ...
}

On failure (< 0), it sets phba->num_cpus =3D nvec - 1, where nvec can be up
to 2048, which could lead to out-of-bounds array accesses in functions
iterating over num_cpus. For instance, in beiscsi_dev_probe():

drivers/scsi/be2iscsi/be_main.c:beiscsi_dev_probe() {
    ...
	for (i =3D 0; i < phba->num_cpus; i++) {
		pbe_eq =3D &phwi_context->be_eq[i];
		irq_poll_init(&pbe_eq->iopoll, be_iopoll_budget, be_iopoll);
	}
    ...
}

This loop writes into phwi_context->be_eq[i], which has a static size of
MAX_CPUS (64). Should be2iscsi_enable_msix() handle the return value
differently to prevent this overflow on failure, and to avoid hardcoding
phba->num_cpus =3D 1 on success?

>  		kfree(phba->msi_name[j]);
>  	}
>  	return ret;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703053055.1413=
37-1-dbgh9129@gmail.com?part=3D1
