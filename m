Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2815A36655D
	for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 09:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787564408; cv=none; b=evK22szP7ypDPxfROLQ+EOZo5DN/YQYuxpL/91AUvvNt/RbfrQn7tXri3zChUK5auLuinoPOH5TAX0RiERzprqaF5adYn26+UM/l8qB9kRKKfLNNvG5Kd/o3CNojTuTncw4PjIkKUe+CxUkmIlJ+Fn1VMC0yVFvBV+mUGxI3278=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787564408; c=relaxed/simple;
	bh=7/tWfK2hCxUdeCv/pg0uDu4P2EexFBRkkam6Q7uYagE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IfNzSu8lWSq/5HG836CEweBm8KHVAf+odiE/svtDyRX/U/StEmE+JY5qASp1gfCtzOkS37ENDGRo1frNW2qOZTusn1YBoHQXM+bWVq/wCTq6XtDWE4aFpuMS//mN4qH8yOrCV5pom9K3j1s3L0E/Vh86OHX84X2f0FR95BwS6Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZPyobcw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZPyobcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F9C1F000E9;
	Mon, 24 Aug 2026 09:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787564406;
	bh=f2vHAX7LhhJSq0ZeRU+JPHFboyKrfq8XZ2zfxpvFK2k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eZPyobcwxCmE/vEEM+3aFfOhEUbfCrTbJIq4NQZ0a4oGuLpufly266EYsi0LVQTJ/
	 V0w+cpEN25+21UDyimou5A7iObCEjEJTVKTF5VlPMAim2hY/FIM8rZh1EaYLs6k7Y8
	 h9mx3FLaRVytLwLAvADKHPdLbQa38NAn7Cn9pndxTkQ2aG2gDBklATI3vFt6pB132h
	 oPiM/xtnZoISjuATb48Vu4TccJjJtDrTpzBCEdwnivCEm+c6/bXQGLqaM38cX6r9bQ
	 m917IsEKUHjIuWjmQU7+fIh03umve4NUoGOm0mgE4fWomjhg0mPkKSk1CzqKiIOjP3
	 KgRH6om9FGvog==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: be2iscsi: use rollback index when freeing MSI-X
 vectors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260824092712.2130707-1-runyu.xiao@seu.edu.cn>
References: <20260824092712.2130707-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 24 Aug 2026 09:40:06 +0000
Message-Id: <20260824094006.91F9C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Flawed MSI-X fallback logic completely breaks the driver on MSI-X =
allocation failure and disables multiqueue on success.
--

--- Patch [1]: [PATCH] scsi: be2iscsi: use rollback index when freeing MSI-=
X vectors ---
commit 8e4e7a262620af574aa50d93aa71fefbc719c7d1
Author: Runyu Xiao <runyu.xiao@seu.edu.cn>

scsi: be2iscsi: use rollback index when freeing MSI-X vectors
   =20
beiscsi_init_irqs() unwinds previously registered MSI-X handlers with
free_irq(pci_irq_vector(pcidev, i), &phwi_context->be_eq[j]). The IRQ
number should match the rollback slot j, not the current loop index i.
Using i passes the wrong IRQ/dev_id pair and leaves earlier handlers
registered on failure.

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

[Severity: High]
This isn't a bug introduced by this patch, but the MSI-X fallback logic
completely breaks the driver on MSI-X allocation failure and disables
multiqueue on success.

In be2iscsi_enable_msix(), if pci_alloc_irq_vectors_affinity() fails (retur=
ns
< 0), the code incorrectly sets phba->num_cpus =3D nvec - 1:

drivers/scsi/be2iscsi/be_main.c:be2iscsi_enable_msix() {
    ...
		if (pci_alloc_irq_vectors_affinity(phba->pcidev, 2, nvec,
				PCI_IRQ_MSIX | PCI_IRQ_AFFINITY, &desc) < 0) {
			phba->num_cpus =3D nvec - 1;
			return;
		}
	}

	phba->num_cpus =3D 1;
}

The driver then falls back to INTx and provisions multiple event queues, but
the INTx handler be_isr() is hardcoded to only process be_eq[0]:

drivers/scsi/be2iscsi/be_main.c:be_isr() {
    ...
	pbe_eq =3D &phwi_context->be_eq[0];

	eq =3D &phwi_context->be_eq[0].q;
    ...
}

Any I/O submitted to other queues will time out and hang. Conversely, if
allocation succeeds (returns > 0), the code skips the error branch and
unconditionally executes phba->num_cpus =3D 1, artificially restricting the
driver to 1 I/O queue and effectively disabling multiqueue.

Is it possible to correct the logic so the driver does not hang on fallback
and properly utilizes multiqueue on success?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260824092712.2130=
707-1-runyu.xiao@seu.edu.cn?part=3D1
