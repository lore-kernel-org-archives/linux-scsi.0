Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C5F3DAABB
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 08:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784881691; cv=none; b=gGIm2Y0f+Dndq/jhd0Ovq0VRMh+et58tbxP6VFh92LvWGeiIOr3E1XHAaa65ku0Rd7VjqpDg33kFEoeNoCfn5BMsoDkk+UN8FD/U0N5/OIlo1dz4IPp+5VOI+FggxbvXw9e7wOxpYcwiGPcRcObP3f/QHEYZaudjOwiHRb/YuwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784881691; c=relaxed/simple;
	bh=kXDbqtROMfITrRDWGoxVseWf/ipLOYBl9GLIZRBPTRA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LHBKpboQfz/0WYNPA32/l0vLDoyTsNs0CCyieiJ2ik2cBJbR0CuKh4QDsNKotaT+dKiml3jizJscY8l1DNGfY5zt39Q7ZwDZEcieX/RlXcAyck69AyuyuhqiNJistSUpk39rxBSVBFualutuSd5c+G30cT3Sld4br5cg/v9icl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGDg+vG9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGDg+vG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E151F000E9;
	Fri, 24 Jul 2026 08:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784881676;
	bh=sOP5KYU1y7C22x+FgUTydEVHYymNNDpsUwr4BEJOp2Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VGDg+vG9CoolhHpnBtC1AFP8XSFGdZKygEMcLF+Az4+yirZwJRHBD37UG1xrkKuzn
	 t/MNeWDRGxdaZY+x3j9hPpmE1K2mzHl9rXDycCTUTTP4BTYntRNuY8vpZVOkCOtHID
	 tUYybaM+Zr1lNRwJ9RaKZyq1AiEMYZ5s99vkGA/M3EUheWoek+yesu+y/5skU/mOou
	 ylIG51RME9syTYf6lWR4/SXFkoNSXL3opp2NBvlYf/6AIuAKhsiZV9rOcuxm5CP8QI
	 kosftHr8HqROCNG/65GlDpa1Gdjwc7SDa3O96+0Zk89xyz7gduI0FtNnHkQyZ2JQRO
	 GhKPxOfHRsflQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: wd719x: initialize all fields of eeprom_93cx6
 struct
Reply-To: sashiko-reviews@lists.linux.dev
To: stf_xl@wp.pl
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724081747.7726-1-stf_xl@wp.pl>
References: <20260724081747.7726-1-stf_xl@wp.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 08:27:55 +0000
Message-Id: <20260724082756.64E151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The commit fixes an issue in wd719x.c where allocating `struct eep=
rom_93cx6` on the stack without initialization leaves the newly added `quir=
k` field undefined, leading to random EEPROM read corruption. However, it m=
isses several other drivers (such as ax88796, rtl8180, rtl8187, and rt2400p=
ci) that also allocate `struct eeprom_93cx6` on the stack and only perform =
element-wise assignment of some fields, leaving `quirk` uninitialized stack=
 garbage.
- [High] In `wd719x_chip_init()`, if the firmware is reloaded during a host=
 reset, `wd->fw_size` is updated with the size of the newly loaded firmware=
 files, but `wd->fw_virt` is not reallocated if it is already non-NULL. If =
the new firmware is larger than the original one, the subsequent `memcpy` o=
perations will overflow the previously allocated DMA coherent buffer.
- [High] When `wd719x_queuecommand()` returns `SCSI_MLQUEUE_HOST_BUSY` due =
to the AMR command register being busy, it fails to clean up the newly allo=
cated SCB and DMA mappings. This leaks DMA handles and leaves the SCB in `w=
d->active_scbs`. On retry, a new SCB is allocated for the same command. Dur=
ing a host reset, `wd719x_host_reset()` iterates over `active_scbs` and com=
pletes commands, which causes a double-completion and use-after-free on the=
 same `scsi_cmnd`.
- [High] In `wd719x_interrupt()`, the `list_for_each_entry` iterator `scb` =
is evaluated outside the loop to check if a match was found. If the list is=
 empty or no match is found, `scb` points to an invalid structure computed =
from the list head. Dereferencing `scb->phys` results in an out-of-bounds m=
emory access. If it happens to match `SCB_out`, it leads to processing a bo=
gus SCB.
--

--- Patch [1]: [PATCH] scsi: wd719x: initialize all fields of eeprom_93cx6 =
struct ---
commit 7b28e726009ab6205dc4b45d7a3c7506d55ae0e3
Author: Stanislaw Gruszka <stf_xl@wp.pl>

scsi: wd719x: initialize all fields of eeprom_93cx6 struct
   =20
Commit 7738a7ab9d12 ("misc: eeprom: eeprom_93cx6: Add quirk for extra
read clock cycle") added extra quirk field to struct eeprom_93cx6,
which changed how the data is read.
   =20
Some existing users of eeprom_93cx6, including the wd719x driver, allocate
the structure on the stack without initialization of all the fields.
As a result, the added quirk field has an undefined value, which can
randomly cause reading wrong data from the EEPROM.

> diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
> index e3da1a2fdb666..31e0fe9eb93cb 100644
> --- a/drivers/scsi/wd719x.c
> +++ b/drivers/scsi/wd719x.c
> @@ -731,15 +731,15 @@ static void wd719x_eeprom_reg_write(struct eeprom_9=
3cx6 *eeprom)
>  /* read config from EEPROM so it can be downloaded by the RISC on (re-)i=
nit */
>  static void wd719x_read_eeprom(struct wd719x *wd)
>  {
> -	struct eeprom_93cx6 eeprom;
> +	struct eeprom_93cx6 eeprom =3D {
> +		.data =3D wd,
> +		.register_read =3D wd719x_eeprom_reg_read,
> +		.register_write =3D wd719x_eeprom_reg_write,
> +		.width =3D PCI_EEPROM_WIDTH_93C46,
> +	};

[Severity: High]
This isn't a bug introduced by this patch, but it looks like there are other
drivers allocating struct eeprom_93cx6 on the stack without initializing the
quirk field. Should this fix also be applied to ax_init_dev() in
drivers/net/ethernet/8390/ax88796.c, rtl8180_eeprom_read() in
drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c, rtl8187_probe() in
drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c, and
rt2400pci_validate_eeprom() in drivers/net/wireless/rt2x00/rt2400pci.c?

For example, in ax_init_dev():

drivers/net/ethernet/8390/ax88796.c:ax_init_dev() {
    ...
    struct eeprom_93cx6 eeprom;
    ...
}

[Severity: High]
This is a pre-existing issue, but does the firmware reallocation logic in t=
his
driver potentially cause a buffer overflow?

If a host reset occurs after the firmware file on disk is replaced with a
larger one, request_firmware() is called again and wd->fw_size is updated,
but the buffer reallocation is skipped:

drivers/scsi/wd719x.c:wd719x_chip_init() {
    ...
    if (!wd->fw_virt)
        wd->fw_virt =3D pci_alloc_consistent(wd->pdev, wd->fw_size,
                                           &wd->fw_phys);
    ...
}

The subsequent memcpy() operations then write the new larger firmware to the
old buffer, which could overflow the previously allocated DMA coherent buff=
er:

drivers/scsi/wd719x.c:wd719x_chip_init() {
    ...
    memcpy(wd->fw_virt, fw_wcs->data, fw_wcs->size);
    memcpy(wd->fw_virt + ALIGN(fw_wcs->size, 4), fw_risc->data,
           fw_risc->size);
    ...
}

[Severity: High]
This is a pre-existing issue, but does returning SCSI_MLQUEUE_HOST_BUSY here
leak DMA handles and the SCB?

drivers/scsi/wd719x.c:wd719x_queuecommand() {
    ...
    if (wd719x_readb(wd, WD719X_AMR_COMMAND) !=3D WD719X_CMD_READY) {
        spin_unlock_irqrestore(wd->sh->host_lock, flags);
        return SCSI_MLQUEUE_HOST_BUSY;
    }
    ...
}

If the host is busy, the function returns without cleaning up the newly
allocated SCB and DMA mappings, leaving the SCB in wd->active_scbs.

On retry, a new SCB is allocated for the same command. During a host reset,
iterating over active_scbs and completing commands could cause a
double-completion and use-after-free on the same scsi_cmnd.

[Severity: High]
This is a pre-existing issue, but does this list iterator usage result in an
out-of-bounds access?

drivers/scsi/wd719x.c:wd719x_interrupt() {
    ...
    list_for_each_entry(scb, &wd->active_scbs, list) {
        // ...
    }

    if (SCB_out =3D=3D scb->phys)
        wd719x_interrupt_SCB(wd, regs, scb);
    ...
}

If the list is empty or no match is found, the scb iterator points to an
invalid structure computed from the list head. Dereferencing scb->phys resu=
lts
in an out-of-bounds memory access.

If the garbage value matches SCB_out, it could lead to processing a bogus S=
CB.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724081747.7726=
-1-stf_xl@wp.pl?part=3D1
