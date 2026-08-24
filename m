Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B109B4119F2
	for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 11:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787572090; cv=none; b=QfLelgQUpoyq95121vJh7PbtbTnZIYjURUW8Y+9YsteWrulyTJsdnK2YyX2NPVtVnjBrXkhPSIeR1HCXQzXiXIJ4XWSr6A9odz8cy8nimdkivLWuJS6yGur3joICcAZcF08mJw8bxBnIsiDcNvIoc6k14Bj5NSWtwlsMHlnERW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787572090; c=relaxed/simple;
	bh=/kLZe0LZY7epdewSRqWmVzvosMrX/YF76cd2BhDemyU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bpSUTgGpgTzMEpRTd+sVuUJ1ZhfHPgnbnvUjmZaPRRsu7oSOCr7SDbbuaDu2AQuIjXHbNlDDG41SuFIDgMNYYjt0xdVDJ2a7kUN4vs4OBdpqbGrz/7BZP8GenllEKHbVFFI5rXjzHOJgBMg2IiA8z+lgy14zK/Nfh6haLTKS5Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AEJMlDWN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AEJMlDWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C6B1F000E9;
	Mon, 24 Aug 2026 11:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787572088;
	bh=iS5W/39dBmIducPKlF0yPsJClSpsZq0oaGGg81Ivun8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AEJMlDWNddCZ+rMxvX6IzuOJuPurCyxRki6TVnEBFjaPxJ+/jlKxDMCdEoKLvPMx/
	 u0Xxrw2bTHYiIec9A6weMduYF9wpyKC2q3gxwO7XIJ214FELxdC9iEPoe+pUjTL3lX
	 YrpxwJa8qF7euI5xNjJdft7sCbVBFKLwv8ezeO/k4AoK/19wuECKnFJ2j04kQNsOJR
	 UnYSHuio8BkqBHhGSPaYhC5I2HC4IJRYVMRdP3xyiLzFHSqTwdgQ7QvGbM92nnChBr
	 muZakHqh8yC/dJeNStinS88sJPXDMzl0JWcyGHjcAj9KgI08vq9tbETnB+ljEAvo/a
	 UAPsONMciNlng==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: be2iscsi: use rollback index when freeing
 MSI-X vectors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260824113246.2235666-1-runyu.xiao@seu.edu.cn>
References: <20260824092712.2130707-1-runyu.xiao@seu.edu.cn>
 <20260824113246.2235666-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 24 Aug 2026 11:48:07 +0000
Message-Id: <20260824114808.05C6B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Critical out-of-bounds array access and multi-queue degradatio=
n due to inverted MSI-X allocation logic.
- [High] Use-After-Free in INTx error recovery due to incorrect MCC work ca=
ncellation index.
--

--- Patch [1]: [PATCH v2] scsi: be2iscsi: use rollback index when freeing M=
SI-X vectors ---
commit fbea15e24723499491cb379659e8bf49028d4fb3
Author: Runyu Xiao <runyu.xiao@seu.edu.cn>

scsi: be2iscsi: use rollback index when freeing MSI-X vectors

beiscsi_init_irqs() unwinds previously registered MSI-X handlers with
free_irq(pci_irq_vector(pcidev, i), &phwi_context->be_eq[j]). The IRQ
number should match the rollback slot j, not the current loop index i.
Using i passes the wrong IRQ/dev_id pair and leaves earlier handlers
registered on failure.

Use j for pci_irq_vector() in the rollback loop.

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
>  		kfree(phba->msi_name[j]);
>  	}
>  	return ret;

[Severity: Critical]
This is a pre-existing issue, but I noticed a potential problem in
be2iscsi_enable_msix() while reviewing this code.

Is the logic for handling the return value of
pci_alloc_irq_vectors_affinity() inverted?

drivers/scsi/be2iscsi/be_main.c:be2iscsi_enable_msix() {
	if (pci_alloc_irq_vectors_affinity(phba->pcidev, 2, nvec,
			PCI_IRQ_MSIX | PCI_IRQ_AFFINITY, &desc) < 0) {
		phba->num_cpus =3D nvec - 1;
		return;
	}
	...
	phba->num_cpus =3D 1;
}

If allocation fails, phba->num_cpus is set up to nvec - 1. Could this
cause an out-of-bounds write on the 64-element be_eq array later in
beiscsi_enable_port()?

drivers/scsi/be2iscsi/be_main.c:beiscsi_enable_port() {
	for (i =3D 0; i < phba->num_cpus; i++) {
		pbe_eq =3D &phwi_context->be_eq[i];
		irq_poll_init(&pbe_eq->iopoll, be_iopoll_budget, be_iopoll);
	}
}

[Severity: High]
This is also a pre-existing issue, but I have a question about the error
recovery path in beiscsi_disable_port().

When msix_enabled is false, mcc_work is queued on be_eq[0]. Does this
code fail to cancel the active work because it uses the leftover loop
counter 'i'?

drivers/scsi/be2iscsi/be_main.c:beiscsi_disable_port() {
	if (!unload && beiscsi_hba_in_error(phba)) {
		pbe_eq =3D &phwi_context->be_eq[i];
		cancel_work_sync(&pbe_eq->mcc_work);
	}
}

Could this result in a use-after-free when the hardware queues are
subsequently destroyed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260824113246.2235=
666-1-runyu.xiao@seu.edu.cn?part=3D1
