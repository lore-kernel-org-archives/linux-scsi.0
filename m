Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A723F3396EE
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 23:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781306553; cv=none; b=hsHRHNccst7bzjmkN+BETAJH0HMrzGJRAQmBWeGWatOkzu54Ny36hqgPcJvuutj6uHYbbHJznuK2bplzIQnKgQQKtVDTL0yR22CXq/eBVrz21JWl5hin7YtkrBiNwzWgt7TxNHo47a2Y6p8Dkl9hRX8JScJbvqHrB+toWSYg3xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781306553; c=relaxed/simple;
	bh=A0IcIUV0neE+7sNAq/7ERrlTVNZ9xkJz77RmsbLuiys=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DLnC82X66LOe1FXgclfgLeaO3pR5fg9sGj+7L14yaMntPLtRfi28Kqjzy8l5aQ8TwUIZwQ3ODMMd9/rg+E+RuNkJvYdT/PO34XsIs1fJgSGBBzSwIyMu4arLvTApyEwujOh0H+DpNryT05VaCpNt5o0Lrm3NhcsJhD3SuavqhEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lMhfrY0W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lMhfrY0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5FA1F000E9;
	Fri, 12 Jun 2026 23:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781306552;
	bh=fFgBe2qFzP9bnHF+b27Wg7Lr+cx6KEMYhFOM7DL/JEA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lMhfrY0Wq1ymJuiSJRpheAUN9abOHnUUWV+mpHBC3TfN82vo9s+dHaMwf7oZei9KA
	 fuUiXtv2zUMlTPmsBToNUuL0gPkWrHF+03fCfXIdaULslzZjfZAhegL//gjrkYRgnQ
	 HeDsLfce0VuJ8qvgxeTxFs4DPNFoatXSNgPX5MbHfvFSlhJy/lB4a5YSNyyzGRtKqa
	 pwk+hhCz1gpExt5FD2pzQNMIX2p/wJ2Av99eiYgAyril0Ys01ga14zPvPzaiBKz5Tq
	 1Tdqb5qdtzHjCg2Ng/9qZXAeV9OrVUHE3dbtqHDjto7X8akXSRyVeP6qRNA2g0YlNH
	 AzaWC57KBWUOw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 12/13] scsi: fnic: Expose NVMe transport state in
 debugfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612180918.8554-13-kartilak@cisco.com>
References: <20260612180918.8554-13-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 23:22:31 +0000
Message-Id: <20260612232232.1C5FA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Missing cleanup of NVMe debugfs files during `fnic_probe` error pa=
ths allows a use-after-free on the freed `fnic` structure.
- [Low] The debugfs file is created with write permissions (`0200`) but the=
 file operations lack a `.write` callback.
- [Low] The error handling block for `fnic_nvmef_debugfs_init` is dead code=
 because the function unconditionally returns 0.
--

commit 295552911c6b775471123862aa4f6e6325417f36
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Expose NVMe transport state in debugfs

Create an NVMe debugfs directory with a per-host nvmef_info file.
Report local-port and target-port identifiers for NVMe initiator
instances, and initialize and remove the debugfs entries with the NVMe
probe and teardown paths.

> diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_de=
bugfs.c
> index 467fba29ea5f8..690b1c6ecf010 100644
> --- a/drivers/scsi/fnic/fnic_debugfs.c
> +++ b/drivers/scsi/fnic/fnic_debugfs.c

[ ... ]

> +static const struct file_operations fnic_nvmef_debugfs_fops =3D {
> +	.owner =3D THIS_MODULE,
> +	.open =3D fnic_nvmef_debugfs_open,
> +	.read =3D fnic_nvmef_debugfs_read,
> +	.release =3D fnic_nvmef_debugfs_release,
> +};

[ ... ]

> +int fnic_nvmef_debugfs_init(struct fnic *fnic)
> +{
> +	char name[16];
> +
> +	snprintf(name, sizeof(name), "host%d", fnic->fnic_num);
> +
> +	fnic->fnic_nvmef_debugfs_host =3D debugfs_create_dir(name,
> +							   fnic_nvmef_debugfs_root);
> +	fnic->fnic_nvmef_debugfs_file =3D debugfs_create_file("nvmef_info",
> +							    S_IFREG | 0444 |
> +							    0200,

[Severity: Low]
Is the 0200 write permission intended here?

The file is created with write permissions (resulting in 0644), but
fnic_nvmef_debugfs_fops does not implement a .write callback.

> +							    fnic->fnic_nvmef_debugfs_host,
> +							    fnic,
> +							    &fnic_nvmef_debugfs_fops);
> +	return 0;

[Severity: Low]
Since fnic_nvmef_debugfs_init() unconditionally returns 0, the error checki=
ng
block for it in fnic_probe() is unreachable dead code.

Could this function be changed to return void, or should it propagate an er=
ror
if the debugfs creation fails?

> +}

> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
> index cd5483aac4629..da5f9d53ad104 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c

[ ... ]

> @@ -933,6 +933,15 @@ static int fnic_probe(struct pci_dev *pdev, const st=
ruct pci_device_id *ent)
>  		err =3D -EOPNOTSUPP;
>  		goto err_out_fnic_role;
>  	case VFCF_FC_NVME_INITIATOR:
> +		err =3D fnic_nvmef_debugfs_init(fnic);
> +		if (err) {
> +			dev_info(&fnic->pdev->dev,
> +			       "fnic(%d) Failed to initialize debugfs for nvmef\n",
> +			       fnic->fnic_num);
> +			fnic_nvmef_debugfs_remove(fnic);
> +			goto err_out_fnic_role;
> +		}

[Severity: High]
If fnic_probe() encounters an error later in the initialization sequence
(for example, during fnic_set_intr_mode() or fnic_alloc_vnic_resources()),
does the error handling cascade correctly clean up this debugfs entry?

Looking at the error paths at the end of fnic_probe(), it appears the fnic
structure is ultimately freed via kfree(fnic), but there is no matching
call to fnic_nvmef_debugfs_remove(fnic) during the teardown sequence.

Could this leave an active debugfs node pointing to a freed fnic structure,
leading to a use-after-free if the debugfs file is read?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612180918.8554=
-1-kartilak@cisco.com?part=3D12
