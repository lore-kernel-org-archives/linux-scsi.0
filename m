Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793928128;
	b=1zaVv+ITqxxCalvIYoOGQbE5EzHrDYZvoFMJJ3r9gwWQ7cGTrV/J4boxTELLn5APJHi0
	 UIEZD7z2RtcLxaTl4nFTdmboflrMJdwBtBxcvgQeL49b/ShOW7naaZWVC6YJp92+imeZ3
	 9VWOq0oIBI1nyV/FBzbOyoaZzUcdbkmzKsO9ZFuZvMjlqfa6DPECteQesWc7AydemGDKD
	 CI/W+EjFV9j69Qk6SxRVsVV6M+6YiZnCzuLv/HRzj6T7Vn3fygCgWjs/acByNZ+8JWIR2
	 4busc1PSuQJwerNuLT3oMiF1oCbhQFKxBrw7SLDbfWnMvuHoVfkY81Rj4QfRQ02rWTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793928128;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=K2J5/NBuezMDMeyNCRhwbidhe0DBqphzE7FDxd5kQmo=;
	b=qKKQb1E3xCDW60tJ20EkO3QxL0yj6dFmcpWK8eeCgBO9kxYhQVLq45YAOnNCtYJKSQlG
	 RIaLhcU/gkyrqGZMU2sfuw329QKob9v0YOwZs7l9+QhUaprWQ1PPGD+2dlLrYmFWF5UgM
	 bm+LzEpPeMqFASv3NxjCSuFc+5rGYWi0C06v+x5VLY/kVp25IJbwOyx49OosSKyGMNoYN
	 GnyvzF89X58BzQ7nXACBP9txujalCqEWXo3EY2Y0tZquZHySpKZC67KIVWV1bWiDkNcdf
	 8aBaxH9GzRXcX+ARLCnaJVpFUoCnfZvsRfTNDiOmZ08MJ74nvx7mJ3yBtkKDkM8a6xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GGGkbOQ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE44606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GGGkbOQ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D921F008A1;
	Fri,  6 Nov 2026 01:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793928128;
	bh=K2J5/NBuezMDMeyNCRhwbidhe0DBqphzE7FDxd5kQmo=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=GGGkbOQ2AnGHm/1C7eNqYNMeiHt8syNXTjiVnYoWv5pSqUiuYjfyHWqk/pwPQD1ID
	 Nj21YI7BDl2/r3Ve8cqVQsFhOzARSA0uPJ0eP8ThxA6JyXCuKgv9eSiLkaxqvNktwP
	 aAbpzQW7GCi22u3itn53F6MdladOkAZX7Toj7wDeUBhwoLEYD0pWVeApP+zkBvzuqS
	 7qEBx7U15Jo1t6JmvGLs45sFvwB1A6g5mLTTxKQlTpB68YGd1Lrc9cXUNVrW4lqmLN
	 fzhZnnV/D7cFeIxQKJqtUMvtLHtnSPFU63VQMNjase2KwjfD40EMperezbxta37kE/
	 1nuJGYzSCgpUw==
Message-ID: <sashiko-outbox-200509@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 16/37] scsi: mpt3sas: Fix page fault from stale
 ioc->chip after PCI error recovery
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1793925772-1303-17-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1793925772-1303-17-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 01:22:07 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: mpt3sas: NULL ioc->chip dereference in teardown and reset pa=
ths
--

commit 118d4e051f29076a6276971b9fb64bd8927def06
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

scsi: mpt3sas: Fix page fault from stale ioc->chip after PCI error recovery

This commit sets ioc->chip to NULL when unmapping controller resources in
mpt3sas_base_unmap_resources(), guards mpt3sas_base_mask_interrupts() and
mpt3sas_base_unmask_interrupts() against a NULL ioc->chip pointer, and skips
zero-length memory BARs in mpt3sas_base_map_resources().

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
> index 060482ba20aef..f0ed1bea64bbc 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -1645,6 +1645,8 @@ mpt3sas_base_mask_interrupts(struct MPT3SAS_ADAPTER=
 *ioc)
>  	u32 him_register;
> =20
>  	ioc->mask_interrupts =3D 1;
> +	if (!ioc->chip)
> +		return;
>  	him_register =3D ioc->base_readl(&ioc->chip->HostInterruptMask);
>  	him_register |=3D MPI2_HIM_DIM + MPI2_HIM_RIM + MPI2_HIM_RESET_IRQ_MASK;
>  	writel(him_register, &ioc->chip->HostInterruptMask);
> @@ -1662,6 +1664,8 @@ mpt3sas_base_unmask_interrupts(struct MPT3SAS_ADAPT=
ER *ioc)
>  {
>  	u32 him_register;
> =20
> +	if (!ioc->chip)
> +		return;
>  	him_register =3D ioc->base_readl(&ioc->chip->HostInterruptMask);
>  	him_register &=3D ~MPI2_HIM_RIM;
>  	writel(him_register, &ioc->chip->HostInterruptMask);
> @@ -3579,6 +3583,7 @@ mpt3sas_base_unmap_resources(struct MPT3SAS_ADAPTER=
 *ioc)
> =20
>  	if (ioc->chip_phys) {
>  		iounmap(ioc->chip);
> +		ioc->chip =3D NULL;
>  		ioc->chip_phys =3D 0;
>  	}

[Severity: High]
When mpt3sas_base_unmap_resources() sets ioc->chip =3D NULL (such as during
scsih_pci_error_detected() on pci_channel_io_frozen, scsih_suspend(), or wh=
en
mpt3sas_base_map_resources() fails in scsih_pci_slot_reset() or
scsih_resume()), can the surrounding teardown and reset paths still
dereference a NULL ioc->chip pointer?

In drivers/scsi/mpt3sas/mpt3sas_scsih.c, scsih_shutdown() and scsih_remove()
run several helpers right around the newly guarded
mpt3sas_base_mask_interrupts() call without checking if ioc->chip is NULL:

drivers/scsi/mpt3sas/mpt3sas_scsih.c:scsih_shutdown() {
	...
	if (ioc->is_aero_ioc)
		mpt3sas_config_set_ioc_pg1(ioc, &mpi_reply,
				&ioc->ioc_pg1_copy);

	_scsih_ir_shutdown(ioc);
	_scsih_nvme_shutdown(ioc);
	mpt3sas_base_mask_interrupts(ioc);
	mpt3sas_base_stop_watchdog(ioc);
	ioc->shost_recovery =3D 1;
	mpt3sas_base_make_ioc_ready(ioc, SOFT_RESET);
	...
}

drivers/scsi/mpt3sas/mpt3sas_scsih.c:scsih_remove() {
	...
	if (ioc->is_aero_ioc)
		mpt3sas_config_set_ioc_pg1(ioc, &mpi_reply,
				&ioc->ioc_pg1_copy);
	/* release all the volumes */
	_scsih_ir_shutdown(ioc);
	...
}

Specifically:

1. mpt3sas_config_set_ioc_pg1() (when ioc->is_aero_ioc is set) calls
_config_request() -> mpt3sas_wait_for_ioc() -> mpt3sas_base_get_iocstate(),
which reads &ioc->chip->Doorbell in drivers/scsi/mpt3sas/mpt3sas_base.c:

	s =3D ioc->base_readl_ext_retry(&ioc->chip->Doorbell);

2. _scsih_ir_shutdown() (when ioc->ir_firmware is set and raid_device_list =
is
non-empty) and _scsih_nvme_shutdown() (when pcie_device_list is non-empty)
both call ioc->put_smid_default(ioc, smid), which writes to
&ioc->chip->RequestDescriptorPostLow or
&ioc->chip->AtomicRequestDescriptorPost without checking ioc->chip or
ioc->pci_error_recovery.

3. In scsih_shutdown(), mpt3sas_base_make_ioc_ready(ioc, SOFT_RESET) is
called unconditionally without the if (ioc->chip_phys && ioc->chip) check u=
sed
in mpt3sas_base_free_resources(). Because mpt3sas_base_make_ioc_ready() only
checks ioc->pci_error_recovery and not ioc->chip, any path where ioc->chip =
is
NULL and ioc->pci_error_recovery is 0 (for example, after
scsih_pci_slot_reset() clears ioc->pci_error_recovery =3D 0 and fails
mpt3sas_base_map_resources(), or after scsih_suspend() / failed
scsih_resume()) calls mpt3sas_base_get_iocstate(ioc, 0) and dereferences
&ioc->chip->Doorbell.

4. Similarly, in mpt3sas_base_hard_reset_handler() in
drivers/scsi/mpt3sas/mpt3sas_base.c, mpt3sas_wait_for_commands_to_complete()
and mpt3sas_base_make_ioc_ready() immediately precede and follow
mpt3sas_base_mask_interrupts() and both call mpt3sas_base_get_iocstate(),
dereferencing &ioc->chip->Doorbell when ioc->chip is NULL.

Should these callers and mpt3sas_base_get_iocstate() /
mpt3sas_base_make_ioc_ready() also guard against !ioc->chip?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1793925772-1303-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D16
