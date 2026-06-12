Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A050238F638
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781260243; cv=none; b=GyefzzSrVd08aCn6lEFRf+PwoDSpixInm+0Y9J8bNCw+iq2sGMUgYKjYIrFOPY5358gAieXFPh6IbsveOh+m8pnDpcnyfcf/ZSpVzCEGyW011rMrQeDw24AWrW2zhH/3yCvTE70vMFwEDS/6jKVOSE596BruM25HC8h2aXBUVdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781260243; c=relaxed/simple;
	bh=5FdbwaDeGyhD1ICR2gXWQSRTLLL/XDDQKYStsQLlPpU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ekDoEoO83KbMD4fw1S+gKZ3SHUEXU3QdP2Uq3IfbQZDc6XtOH8LzTe/pY+gAIvgXAmrSDbrgN37BxvhsG+M+Ne3GAEANohxeTi1di4/FeootTzMgoZd1O+Fe0wbcjzK9tiHAEqyZjZ4wlavYpltN7ZdITlRp0AO4haedLFiNgos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S4yOX44f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S4yOX44f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327021F000E9;
	Fri, 12 Jun 2026 10:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781260242;
	bh=wZ8aJ6v94N6+umJJ7ClfRsoMZY+BXH6WDZxS9g2zetE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S4yOX44fCbo8vYuAlkKPGlN2V6l5AahnKVYb1Hy4m8P36DJxar86dFxRJc5TWnBe8
	 C74Z58XY3va5o5pR2cCZf281xfahtlS1qv0SjNXU/xNVIO9us+tzANIDb/X0TTGlTK
	 jw8nsflhNHpUjbC4/qVgGkig4+8RBVSS9zUhCmC+xMqJt99HXlas9g/kBhBY6S8c7r
	 1uuEoBqqSVN/fhoSkhetAa0LAKEYlfaFpdRpIvkwhgsAWlYPhkojNHSEKKL5yG7r5r
	 l21omwk0JfGtXujBWsTS0N2WavqpAVLBj1hWJAlZDNvhgRho0AVO3kA6j4QNQYJw1C
	 LrxWaDPeEFhJw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 01/60] scsi: qla2xxx: Add 29xx series PCI device ID
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-2-njavali@marvell.com>
References: <20260612095333.1666592-2-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 10:30:41 +0000
Message-Id: <20260612103042.327021F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Critical] Out-of-bounds write during firmware dump due to undersized buf=
fer allocation

Pre-existing issues:
- [High] Integer truncation and underflow of `max_req_queues` leading to ze=
ro-sized allocation and kernel panic
--

commit 3a7611054d56fb889d96ec52acc8efac418ed86d
Author: Manish Rangankar <mrangankar@marvell.com>
Subject: scsi: qla2xxx: Add 29xx series PCI device ID support

This commit introduces support for the QLA29xx series of Fibre Channel HBAs.
It registers the new PCI device IDs and adds IS_QLA29XX() capability checks
across the driver to handle initialization, MSI-X setup, and other hardware
specifics.

> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2773,7 +2773,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
>  	ha->isp_ops->reset_chip(vha);
> =20
>  	/* Check for secure flash support */
> -	if (IS_QLA28XX(ha)) {
> +	if (IS_QLA28XX(ha) || IS_QLA29XX(ha)) {

[Severity: Critical]
Is it possible that the new IS_QLA29XX() check is missing in
qla2x00_alloc_fw_dump()?=20

In qla2x00_alloc_fw_dump() within drivers/scsi/qla2xxx/qla_init.c, the driv=
er
dynamically calculates the firmware dump buffer size for 27xx and 28xx
adapters:

	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
		/* dynamic size calculation */
	}

Without the IS_QLA29XX() check, the driver falls back to a hardcoded legacy
formula, which allocates an undersized buffer. Later, when a firmware dump
is triggered (e.g., from a RISC pause), qla27xx_fwdump() blindly writes to
this buffer via qla27xx_insert32() in drivers/scsi/qla2xxx/qla_tmpl.c:

	buf +=3D *len;
	*(__le32 *)buf =3D cpu_to_le32(value);

Will this result in an out-of-bounds write and kernel memory corruption sin=
ce
the 29xx firmware template requires significantly more space?

>  		if (rd_reg_word(&reg->mailbox12) & BIT_0)
>  			ha->flags.secure_adapter =3D 1;

[ ... ]

> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
[ ... ]
> @@ -2203,10 +2202,18 @@ qla83xx_iospace_config(struct qla_hw_data *ha)
>  	ha->msixbase =3D ioremap(pci_resource_start(ha->pdev, 2),
>  			pci_resource_len(ha->pdev, 2));
>  	if (ha->msixbase) {
> +		int msix_cnt;
> +
>  		/* Read MSIX vector size of the board */
> -		pci_read_config_word(ha->pdev,
> -		    QLA_83XX_PCI_MSIX_CONTROL, &msix);
> -		ha->msix_count =3D (msix & PCI_MSIX_FLAGS_QSIZE)  + 1;
> +		msix_cnt =3D pci_msix_vec_count(ha->pdev);
> +		if (msix_cnt <=3D 0) {
> +			ql_log_pci(ql_log_warn, ha->pdev, 0x0120,
> +				   "Failed to read MSI-X count (%d), falling back to base vectors.\n=
",
> +				   msix_cnt);
> +			goto mqiobase_exit;
> +		}
> +		ha->msix_count =3D msix_cnt;

[Severity: High]
This is a pre-existing issue, but does assigning msix_cnt to ha->msix_count
expose us to a truncation bug if the device advertises 257 vectors?

The ha->max_req_queues field is defined as an 8-bit unsigned integer
(uint8_t) in struct qla_hw_data in drivers/scsi/qla2xxx/qla_def.h. Later in
qla83xx_iospace_config(), we do:

	ha->max_req_queues =3D ha->msix_count - 1;

If the device advertises exactly 257 MSI-X vectors, msix_count - 1 evaluates
to 256, which truncates to 0 in the 8-bit max_req_queues. (It would also
underflow to 0 if the MSI-X count is 1).

Subsequently, qla2x00_alloc_queues() uses this truncated value:

	ha->req_q_map =3D kzalloc_objs(struct req_que *, ha->max_req_queues);

Passing 0 to kzalloc_objs() returns the ZERO_SIZE_PTR. The driver then
dereferences it:

	ha->req_q_map[0] =3D req;

Could this lead to a kernel panic when a misconfigured or malicious
hot-plugged PCIe device provides these vector counts?

> +
>  		/*
>  		 * By default, driver uses at least two msix vectors
>  		 * (default & rspq)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D1
