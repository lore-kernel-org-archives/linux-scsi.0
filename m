Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5847A30674B
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2026 01:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785722059; cv=none; b=sRvWZ5gxO85Y3P2Mx8FFoqY5UyEFmt+qXAXcyrqyt3hTmlKusfnhxaSCguhxXj9ruuOU/2W0/eK13PGgISsCTLzqeBVtmT4u5fmQMpdGRWO0CjSsD9K3Qwqn1ET/QpJw31q+3O3PMkwgOGfBweD+5ZG07+rybnCQULV+iUwSyZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785722059; c=relaxed/simple;
	bh=O1jbA8z4nZcUxdhXdspKTTol/XPg9SHfUb1RhBvovLY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BtVYILbYvU+IeYITGzBEjc5AEuUOJq3MyjATFCR9MX0B4YSAIS0JtwmESTnvD6rqcUj7o8bLpCxfOMaQWUZXw7pCVXXpUHFS6AZ1IdLpAJHQ7tOtwy2SCXZfqXX40qcUqHTb0rX4e9NpX8+lo+NOvOIDg5pkiW6hY0MM8d2aSC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gazHSx5n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gazHSx5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18F71F000E9;
	Mon,  3 Aug 2026 01:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785722058;
	bh=3TQT2C8j//1895KS/WlWxM0t7/3H2gZ+ZMmReKgL7rE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gazHSx5nKT/7e2STRzmkja5/xarOrhfrIzyrrpriC+NEMHloXDn9h761ReMc+B4mr
	 BWy5FgiHAkiQPFGB5DeuB+aNiKPabrPP5ArSQSW3m7TuFcfBpvkI1YJX7vdhKwXQRc
	 Rdy+msoE6uBSVTyoiWjefb9boQUiOSFhLlnkLzUGiOi8RZ1X+LqB9CRuBT7CEcDiEU
	 JtzjeP2w24wkSbGWUsq3+r6E5nmLRWw+MqTTxwzOvfp7atHxQnIZUJ64SkSqf4lsfw
	 MO3zsUHmiDfv2OspztvgaPNaQwlF7Ml3qULIHTbHL/0QEqrQ4MAi+1pLTmGiZQusRt
	 Bk8rIuWXXdbIA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1] scsi: be2iscsi: Fix MSI-X IRQ cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuho Choi" <dbgh9129@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260803014224.614347-1-dbgh9129@gmail.com>
References: <20260803014224.614347-1-dbgh9129@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 01:54:17 +0000
Message-Id: <20260803015417.C18F71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The logic handling the return value of `pci_alloc_irq_vectors_affi=
nity` in `be2iscsi_enable_msix` is completely inverted, leading to severe r=
esource underutilization on success and guaranteed out-of-bounds array acce=
sses on failure.
--

--- Patch [1]: [PATCH v1] scsi: be2iscsi: Fix MSI-X IRQ cleanup ---
commit 7ef06019dd8a33e5e182606a30c7033f3e41b3de
Author: Yuho Choi <dbgh9129@gmail.com>

scsi: be2iscsi: Fix MSI-X IRQ cleanup
   =20
This patch fixes the MSI-X IRQ cleanup path in beiscsi_init_irqs(). When
unwinding an allocation failure, it uses the correct index to release the
same vectors that were registered.

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
This is a pre-existing issue, but while reviewing the MSI-X initialization =
in
this driver, I noticed what appears to be inverted error handling logic in
be2iscsi_enable_msix():

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

Does this code set phba->num_cpus to a high value on allocation failure, and
limit it to 1 on success?

If pci_alloc_irq_vectors_affinity() fails, phba->num_cpus is set to nvec - =
1,
where nvec can be up to 2048. Subsequent functions iterate up to this value:

drivers/scsi/be2iscsi/be_main.c:beiscsi_create_eqs() {
    ...
	for (i =3D 0; i < (phba->num_cpus + eq_for_mcc); i++) {
		eq =3D &phwi_context->be_eq[i].q;
    ...
}

Because the be_eq array in struct hwi_context_memory is strictly bounded by
MAX_CPUS (64), can this out-of-bounds access corrupt memory if the MSI-X
allocation fails?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803014224.6143=
47-1-dbgh9129@gmail.com?part=3D1
