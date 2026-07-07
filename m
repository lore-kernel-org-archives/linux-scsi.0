Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9739842254D;
	Tue,  7 Jul 2026 14:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783433539; cv=none; b=dyWWrcTrNNJkeRHSHtrDQ31wFo1B8C30pnziUBX0PlbI78fAtpJghL7TbJQLoU0cl03Hc++QWTxrU81SA6HoYbp7XAJzXwBVSJHhC7P65BUsuODodzyoF0CBoeV3yovid0V+i+z5uk6wDg5aIPxaCQuklKr9v1EWgB5YHLNOH8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783433539; c=relaxed/simple;
	bh=OVtv5I8nY4k2+NYX38ZksLgxwnnzdn3K5q5ZwzIS0IQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VWo0jCuwitOuvODhu3diBKA9w0SllCl0J+enOrGpw9BwbpraRxFAQ6tUXmsM5ms76SUXS1W1lfGb1abalJun9Q+pZneNfEcce3I8/azCXk0Iybi4c96hYzUOTf7mlDK+n6HB6ZUkiMCYaX/Hm/8ZeM5biivMI0tzxJTgg2b/Qsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OY9UAjLm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OY9UAjLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732CB1F00A3D;
	Tue,  7 Jul 2026 14:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783433534;
	bh=U5EcTzMi/IEhPzzjYbkg3G4Fs0byQhzWOrG0+G6+GxA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OY9UAjLmHX7VOWczV4GzyLSPcp3qcOXPB8C8UHf/FjXSbaKixLkYEMIZLdlmg8e/T
	 uLpQ0jlOeisX4MmqXhsCTvp5AZzzG54zP6/8SA8btCC8fhiVVsct3j2UhkJpFnMzQ7
	 cVkAqkFP2s73jAbrhd4ivkCBCxEi9ss1NDkiOBTkdYwDTT1UEuVVyrqVB64i9emHRM
	 NXuABlgr+mWKHW77lHpfVabsSOEENApUnZo0vhd/gQAQfj+uG4DsiewZvFfvDDcVyf
	 4a6SlpLVGos4exgUsABwA8XwS5ZpRB98XKRHXbwpPtQsAgvIWLYF3VU1a1AbHrnD5F
	 4w5oxVaC2vwyQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/9] nsp32: don't store pci_device_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: dri-devel@lists.freedesktop.org, linux-pci@vger.kernel.org, linux-ide@vger.kernel.org, cassel@kernel.org, linux-scsi@vger.kernel.org, dlemoal@kernel.org
In-Reply-To: <20260706-pci_id_fix-v3-2-2d48fc025acc@garyguo.net>
References: <20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net>
 <20260706-pci_id_fix-v3-2-2d48fc025acc@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 14:12:13 +0000
Message-Id: <20260707141213.732CB1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unvalidated `driver_data` from PCI dynamic IDs can cause an out-of=
-bounds array access on `nsp32_model`.
- [High] Global structure `nsp32_data_base` is used for passing probe state=
, causing data races on parallel probing.
- [High] A failure in `nsp32_detect()` returns 1, causing `nsp32_probe()` t=
o report success. This leads to a NULL pointer dereference in `nsp32_remove=
()` and memory leaks.
--

commit 96fc8cc24426c19e6b0431d668e3217eed8887c7
Author: Gary Guo <gary@garyguo.net>

nsp32: don't store pci_device_id

This commit removes the storage of pci_device_id in the nsp32 hardware
data structure, as it may not outlive the probe function when dynamic IDs
are used. Instead, it directly stores the driver_data which is the only
information needed later.

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
value lead to an out-of-bounds read?

If a privileged user writes a dynamic ID via the new_id sysfs interface
and passes a driver_data value greater than or equal to 7, it seems this
could read outside the bounds of nsp32_model[] when printing further down
in nsp32_show_info() or nsp32_probe():

    seq_printf(m, "OEM:                   %ld, %s\n",
               (mode_reg & (OEM0|OEM1)), nsp32_model[model]);

[ ... ]
> @@ -3340,7 +3340,7 @@ static int nsp32_probe(struct pci_dev *pdev, const =
struct pci_device_id *id)
>  	}
> =20
>  	data->Pci	  =3D pdev;
> -	data->pci_devid   =3D id;
> +	data->model       =3D id->driver_data;

[Severity: High]
This isn't a bug introduced by this patch, but does writing to data here
cause a data race if multiple devices matching the driver are probed
concurrently?

Looking at nsp32_probe(), data points to the static global
nsp32_data_base structure:

    nsp32_hw_data *data =3D &nsp32_data_base;

Since multiple probes will write to this shared structure before it is copi=
ed
to the per-instance allocation in nsp32_detect(), could this corrupt
device-specific state like MMIO addresses, IRQs, and PCI device pointers?

[Severity: High]
This isn't a bug introduced by this patch, but could this probe function
return a false success on failure, leading to a NULL pointer dereference
on removal?

If nsp32_detect() fails and returns 1, nsp32_probe() propagates this
positive value. The PCI driver core treats positive returns as success and
binds the device without setting the driver data.

Later, when the device is unbound, nsp32_remove() calls pci_get_drvdata(),
receives NULL, and passes it to scsi_remove_host(host). Because
scsi_remove_host() dereferences its argument unconditionally, wouldn't
this cause a kernel panic?

>  	data->IrqNumber   =3D pdev->irq;
>  	data->BaseAddress =3D pci_resource_start(pdev, 0);
>  	data->NumAddress  =3D pci_resource_len  (pdev, 0);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706-pci_id_fix=
-v3-0-2d48fc025acc@garyguo.net?part=3D2
