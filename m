Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26404248DC
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 21:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786051448; cv=none; b=qlS40dLfwcINrmoJWvxwUA7q8yQDj2gQfweQ8vbx3JxkvekD4jWwfptGSuNuqKbHz4PpUY92j5RWMaZZ/7nNCqoLTNI7X8Q2hj8LhMY2Cb7kG0GwcjkjrvKwKwEvBoiFm987bVRSzfffknhmZBsNHrlsIwkj5rPCRAtEhqHd8w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786051448; c=relaxed/simple;
	bh=RUNgHsZhsbUxoW0N/6xG6oRvrtl6kvxZWxQk+V0Wn90=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uJoDxFI/W2AkMswBzG7mmcbJ5C4FiTPsukmXo2CYStNOo5tUY3eBId5VEvITdd4b3z65imRQWw6I0SuhqXksvVESTU58tH1h/1EVzqXFTU+dfgTHwsW5taWpnHQcQ9GACtZq0NzyzQ1VYookQCvKaM228ZG2rjuq26NmWYC/TBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPSvr5Um; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPSvr5Um"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D0F1F000E9;
	Thu,  6 Aug 2026 21:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786051446;
	bh=DInRmae74VA6Ahd8+dqvD+k6eTsLVrvedEaik/J4xdk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lPSvr5UmM1prlE9W3zYN5qZbmjY887557anlLNyPWa7DfE6ItZb/mF7ie/sHSzcKa
	 A2espYjSTWUwnRTTpd3yQZwLM+4oh+2z/asd97hIDZqU1JPxfuvIMeJY3RaZ4LcZ0K
	 Dsu1q4/HkkboKmvpUCg+GJnFAJlxH9StTP4Hcq06fz3Hih5zDHhNuJWmqOBC8iCtzz
	 K/V+WgKQVd+x6PdnJV+ee/qDNzwfFM3ygeq4nvlkGjGjtl7mCb9nHy8hQKoDgfRdIP
	 mvN5Gc7PybiSQUMhAzqNbOAeYWq+cXR/bsSUw+nbsMuu6RtcyylWiRKhQkTZ2LnXqB
	 pgZO3wwdCZ5zg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] scsi: elx: efct: destroy the mailbox pools when
 setup fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ali Ahmet Memis" <ali@iusegentoo.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806210631.357456-3-ali@iusegentoo.com>
References: <20260806210631.357456-1-ali@iusegentoo.com>
 <20260806210631.357456-3-ali@iusegentoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 21:24:04 +0000
Message-Id: <20260806212406.19D0F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] sli_setup() leaks DMA memory allocations on initialization error p=
aths.
- [High] Hardware resources successfully allocated in efct_hw_setup() are l=
eaked on subsequent probe and attach error paths.
- [High] efct_hw_init() leaks partially allocated resources on internal fai=
lures and its caller bypasses teardown.
- [High] PCI error recovery handlers ignore critical initialization failure=
s.
--

--- Patch [2]: [PATCH v3 2/2] scsi: elx: efct: destroy the mailbox pools wh=
en setup fails ---
commit e796d2f4c5c631f17e0be2ece667e66aa7e2a789
Author: Ali Ahmet Memis <ali@iusegentoo.com>

scsi: elx: efct: destroy the mailbox pools when setup fails

This commit adds missing cleanup logic to the error paths of efct_hw_setup(=
).
It ensures that the mailbox request and command context pools are properly
destroyed if initialization steps fail.

> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct=
_hw.c
> index cc600220168a6..20f4821078aa1 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
[ ... ]
> @@ -277,7 +277,7 @@ efct_hw_setup(struct efct_hw *hw, void *os, struct pc=
i_dev *pdev)
>  	hw->config.speed =3D SLI4_LINK_SPEED_AUTO_16_8_4;
>  	if (sli_setup(&hw->sli, hw->os, pdev, ((struct efct *)os)->reg)) {
>  		efc_log_err(hw->os, "SLI setup failed\n");
> -		return -EIO;
> +		goto free_mbox_rqst_pool;
>  	}

[Severity: High]
This isn't a bug introduced by this patch, but does sli_setup() still leak =
DMA
memory allocations on its initialization error paths?

For example, if sli_setup() in drivers/scsi/elx/libefc_sli/sli4.c fails the
alignment check:

	if (sli4->bmbx.phys & SLI4_BMBX_MASK_LO) {
		efc_log_err(sli4, "bad alignment for bootstrap mailbox\n");
		return -EIO;
	}

it returns -EIO without calling dma_free_coherent() on previously allocated
buffers like bmbx.virt and vpd_data.virt.

[ ... ]
> @@ -313,6 +313,17 @@ efct_hw_setup(struct efct_hw *hw, void *os, struct p=
ci_dev *pdev)
>  	(void)efct_hw_read_max_dump_size(hw);
> =20
>  	return 0;
> +
> +free_mbox_rqst_pool:
> +	mempool_destroy(hw->mbox_rqst_pool);
> +	hw->mbox_rqst_pool =3D NULL;
> +free_cmd_ctx_pool:
> +	mempool_destroy(hw->cmd_ctx_pool);
> +	hw->cmd_ctx_pool =3D NULL;
> +not_setup:
> +	hw->hw_setup_called =3D false;
> +
> +	return -EIO;
>  }

[Severity: High]
This is a pre-existing issue, but are hardware resources successfully alloc=
ated
in efct_hw_setup() leaked on subsequent probe and attach error paths?

If efct_hw_setup() completes successfully during efct_device_interrupts_req=
uired(),
but a later step in efct_pci_probe() fails (like efct_setup_msix()), execut=
ion
jumps to the dma_mask_out label:

drivers/scsi/elx/efct/efct_driver.c:efct_pci_probe() {
    ...
attach_out:
	efct_teardown_msix(efct);
dma_mask_out:
	pci_set_drvdata(pdev, NULL);

	for (i =3D 0; i < EFCT_PCI_MAX_REGS; i++) {
		if (efct->reg[i])
			iounmap(efct->reg[i]);
	}
	efct_device_free(efct);
}

This skips efct_hw_teardown() entirely, permanently leaking the mempools and
SLI DMA buffers this patch is aiming to clean up.

Similarly, if efct_xport_attach() fails to create the IO pool:

drivers/scsi/elx/efct/efct_xport.c:efct_xport_attach() {
    ...
	xport->io_pool =3D efct_io_pool_create(efct, efct->hw.config.n_sgl);
	if (!xport->io_pool) {
		efc_log_err(efct, "Can't allocate IO pool\n");
		return -ENOMEM;
	}
    ...
}

it returns early without triggering teardown of resources allocated earlier=
 in
efct_hw_setup().


[Severity: High]
This is a pre-existing issue, but does efct_hw_init() leak partially alloca=
ted
resources on internal failures, and does its caller bypass the teardown?

If efct_hw_init() fails midway, for example:

drivers/scsi/elx/efct/efct_hw.c:efct_hw_init() {
    ...
	rc =3D efct_hw_rx_allocate(hw);
	if (rc) {
		efc_log_err(hw->os, "rx_allocate failed\n");
		return rc;
	}
    ...
}

it returns the error directly without cleaning up previously allocated reso=
urces.

Additionally, its caller, efct_xport_initialize(), handles the failure by
jumping to the out label, bypassing efct_hw_teardown():

drivers/scsi/elx/efct/efct_xport.c:efct_xport_initialize() {
    ...
	rc =3D efct_hw_init(&efct->hw);
	if (rc) {
		efc_log_err(efct, "efct_hw_init failure\n");
		goto out;
	}
	...
hw_init_out:
	efct_hw_teardown(&efct->hw);
out:
	return rc;
}


[Severity: High]
This is a pre-existing issue, but do the PCI error recovery handlers ignore
critical initialization failures?

In efct_pci_io_slot_reset(), if efct_setup_msix() or efct_device_attach()
returns an error, the code logs the failure but ignores the return value:

drivers/scsi/elx/efct/efct_driver.c:efct_pci_io_slot_reset() {
    ...
	rc =3D efct_setup_msix(efct, efct->n_msix_vec);
	if (rc)
		efc_log_err(efct, "rc %d returned, IRQ allocation failed\n", rc);

	/* Perform device reset */
	efct_device_detach(efct);
	/* Bring device to online*/
	efct_device_attach(efct);

	return PCI_ERS_RESULT_RECOVERED;
}

This forces an incorrect success status back to the PCI subsystem even when
the device is broken.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806210631.3574=
56-1-ali@iusegentoo.com?part=3D2
