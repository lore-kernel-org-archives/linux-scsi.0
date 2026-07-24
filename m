Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DA94137BB;
	Fri, 24 Jul 2026 22:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784930529; cv=none; b=WNp+43/VSIVdfEMIPAC/yfc+zBW/Z9M9Lii2zu6A4qby+r6CDTpgfb1wauIYvX/5cOI1xpmaNoRQdIVF3Kl9osky3Jd0mNM4MY/kE+6iqnuRK/p3UCEn1qoM7A1/0oEuQgvxv634UnPil+nqKlK6q1BTQ8Kz9hZ7dCaxv8wbQr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784930529; c=relaxed/simple;
	bh=UWBRGsA13N+09wkO9ThYY6cO/0rp/xBkycF2rhkhyXg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oLnMJibpbFiv/F0L0BCTg34eYLtKYyxS8jGsHILRvjHyoLnJfW1yaanHUlh0fn4ShxgQOnCYebY8j+IMztvHplkt1kMmjkeGr1jRa6X3mCMuGi7iJVGAMi4l6MxiIKFlqWnT53GJngUNLhrZIwJxOS1dByQK1fTda9di6GugEkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q2T5FNEx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q2T5FNEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE731F000E9;
	Fri, 24 Jul 2026 22:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784930527;
	bh=liHvd4UWZzTACLWwdcsgKVn83NxP5xBM2Fo+2M4tTPY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q2T5FNEx93A4+0Vq63c940wOUqKxZ+rF57U8eJPjObNl8WJC4rX62owFaLxz/s5jd
	 cxFoYJN/itvcOolSpUhDsvPUWtKa7SavseOcYSLQ3oTYNJ36FPKxuxQUQOC/hCJYuc
	 w0tamN5qZNLpmmDNI8Y7QMNjbfmiCUti1uq8L5QvNmbLoHm24cbUHk3VDm295HPFfl
	 6F9bki4K7AA5KMdbRXDfFyHk4c/80oBEvaM3LfSACFCsaUORRZNZ+vhExQcwxSNWrV
	 ff22QZ3huwCUJo74gtuuWLSX1n8AU3A1jl4sQ6aREepQRbg9U57zCd+xCMUOgCE4jJ
	 XD7dOBANx6FlQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/9] scsi: nsp32: don't store pci_device_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: cassel@kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260723-pci_id_fix-v4-2-3580726844e1@garyguo.net>
References: <20260723-pci_id_fix-v4-0-3580726844e1@garyguo.net>
 <20260723-pci_id_fix-v4-2-3580726844e1@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 22:02:06 +0000
Message-Id: <20260724220207.3CE731F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unvalidated `driver_data` from dynamic PCI IDs causes an out-of-bo=
unds read of the `nsp32_model` array.
- [High] Missing cleanup of PCI resources and MMIO mapping on probe error p=
ath, and missing disable on removal.
- [High] Unprotected global `nsp32_data_base` causes race conditions during=
 concurrent device probes.
- [High] Time-of-Check to Time-of-Use (TOCTOU) race fetching `CurrentSC` lo=
cklessly in the ISR.
- [High] Returning a positive value instead of a negative error code on pro=
be failure tricks the PCI core into assuming success, causing a subsequent =
NULL pointer dereference.
--

--- Patch [2]: [PATCH v4 2/9] scsi: nsp32: don't store pci_device_id ---
commit d3fbc37c7e8ddff13dd3c674aa1a8a1d1f511010
Author: Gary Guo <gary@garyguo.net>

scsi: nsp32: don't store pci_device_id

pci_device_id is not guaranteed to live longer than probe due to presence
of dynamic ID. All information apart from driver_data can be easily
retrieved from pci_dev, so just store driver_data.

> diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> index e893d56772417..9c9281222a0ac 100644
> --- a/drivers/scsi/nsp32.c
> +++ b/drivers/scsi/nsp32.c
> @@ -1470,7 +1470,7 @@ static int nsp32_show_info(struct seq_file *m, stru=
ct Scsi_Host *host)
>  		   (nsp32_read2(base, INDEX_REG) >> 8) & 0xff);
> =20
>  	mode_reg =3D nsp32_index_read1(base, CHIP_MODE);
> -	model    =3D data->pci_devid->driver_data;
> +	model    =3D data->model;

[Severity: High]
This isn't a bug introduced by this patch, but does this unvalidated model
value (derived from id->driver_data via sysfs new_id) cause an out-of-bounds
read of the fixed-size nsp32_model array?

If a large value for driver_data is supplied, this happens just below when
reading the procfs file:

nsp32_show_info():
    seq_printf(m, "OEM:                   %ld, %s\n",
           (mode_reg & (OEM0|OEM1)), nsp32_model[model]);

The same out-of-bounds read also appears in nsp32_probe() during logging.

[ ... ]

> @@ -3340,7 +3340,7 @@ static int nsp32_probe(struct pci_dev *pdev, const =
struct pci_device_id *id)
>  	}
> =20
>  	data->Pci	  =3D pdev;
> -	data->pci_devid   =3D id;
> +	data->model       =3D id->driver_data;

[Severity: High]
This is a pre-existing issue, but does the lockless use of the global
nsp32_data_base struct cause race conditions during concurrent device probe=
s?

nsp32_probe() writes device-specific resources to this shared global struct:

nsp32_probe():
    nsp32_hw_data *data =3D &nsp32_data_base;
    ...
    data->Pci =3D pdev;
    data->model =3D id->driver_data;
    data->MmioAddress =3D pci_ioremap_bar(pdev, 1);

nsp32_detect() then copies it to the per-device hostdata. If multiple devic=
es
are probed concurrently (e.g., async probe or hotplug), threads might race =
to
overwrite these fields, causing devices to steal each other's MMIO mappings.

[Severity: High]
This is another pre-existing issue, but doesn't the error path of
nsp32_probe() fail to clean up PCI resources?

If nsp32_detect() fails, nsp32_probe() returns the error without unmapping
data->MmioAddress or calling pci_disable_device(). Also, on the normal
removal path, nsp32_release() unmaps the IO but entirely skips
pci_disable_device().

[Severity: High]
This is also a pre-existing issue, but does nsp32_detect() returning 1
instead of a negative error code on failure cause issues with the PCI core?

nsp32_probe() propagates this positive value, which the PCI core treats as
success in local_pci_probe(), binding the device even though pci_set_drvdat=
a()
was skipped. When the device is later unbound, nsp32_remove() retrieves a
NULL driver data pointer and passes it to scsi_remove_host(), triggering a
NULL pointer dereference.

>  	data->IrqNumber   =3D pdev->irq;
>  	data->BaseAddress =3D pci_resource_start(pdev, 0);
>  	data->NumAddress  =3D pci_resource_len  (pdev, 0);
> diff --git a/drivers/scsi/nsp32.h b/drivers/scsi/nsp32.h
> index 924889f8bd37e..9e65771cb5928 100644
> --- a/drivers/scsi/nsp32.h
> +++ b/drivers/scsi/nsp32.h
> @@ -564,10 +564,10 @@ typedef struct _nsp32_hw_data {
> =20
>  	struct scsi_cmnd *CurrentSC;
> =20
> -	struct pci_dev             *Pci;
> -	const struct pci_device_id *pci_devid;
> -	struct Scsi_Host           *Host;
> -	spinlock_t                  Lock;
> +	struct pci_dev    *Pci;
> +	int                model;
> +	struct Scsi_Host  *Host;
> +	spinlock_t         Lock;

[Severity: High]
This isn't a bug introduced by this patch, but is there a Time-of-Check to
Time-of-Use (TOCTOU) race condition when fetching CurrentSC in the ISR?

In do_nsp32_isr(), SCpnt =3D data->CurrentSC is fetched locklessly before
acquiring host->host_lock.=20

If the EH thread completes the command concurrently, it frees the DMA mappi=
ng,
calls scsi_done(), and sets data->CurrentSC =3D NULL. The ISR thread might
subsequently acquire the lock and use the stale pre-fetched SCpnt pointer
to modify its result and call nsp32_scsi_done() again, potentially causing a
use-after-free and double completion.

> =20
>  	char info_str[100];

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723-pci_id_fix=
-v4-0-3580726844e1@garyguo.net?part=3D2
