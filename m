Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C625430DEB2;
	Fri, 31 Jul 2026 22:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785535662; cv=none; b=c5RFSGbmZNkVNuRHB210NorYNQfk0JCtEuym4pErSzf5zXCBZqde8DK6XpXHjPZhGioY2RxQG90VVYRrSGZ/5UX19altEmR3g5C05X63dak8gsJdmJX06/+Tj1e/eTPXxG7rUzYoUYaD8sE5GnG5n7SOj/bxE/dFu1HnRNqnCPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785535662; c=relaxed/simple;
	bh=4ZU1cQPN1QIXeQlEhj1WIIHSYg/+iDqCQU8fexCrFMA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LzqthvgneV0r1vD0QvAuzWp3x0H9hGYr2OdlrHgOPQ2UBpTC3dmk6sA64Jl6hTxCqNLZF2B8EIPTbOFqWqNo9q0yTguCaK/QfVB53ecYR7DIHLUZ/x7WhdOmgkWQrUQsv20UlrvyYvJ5n6rPAVyVthIFz5plzShD1Z4xLlylAJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LL9L5mg4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LL9L5mg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E14E1F00ACF;
	Fri, 31 Jul 2026 22:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785535660;
	bh=DhddgBOfpAO1iFzFwwrvaGvfXbBAr3UsFm9h99A2Ri0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LL9L5mg43NkjkWdB8L3GHBSQRJ6vUwIFVcbrT/+E/1S1c6AtO+ZgV4DEHMIo7JrLP
	 VGJWkUv49Lfin069y0dJwIaHFdVyjcsc5Q+Ans/WLDPAdZGWXgO2hxdCvRM/XdQ8xc
	 /FcO7Hbtg80ZBFSr/Qu/JlU4Hj6SqW825SKhA/9TJ1+Rs2ZTJ3M3SxPeVIkZJT5DMv
	 uHGmi1ZvH+zw1kaR9tC3nZjpkki09iGcDMxUlUchXbmBINchZt6/USPsP/Z2pg+E8m
	 +6Cx/HH0ZkJ6zLLrA5ogSIbWDkb00wHq9Y6xYAC3UMKhaTTvZIl34EDiHE7mEa4BHm
	 ue+pxKzMaDL7A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 2/6] ata: libata-scsi: convert dev->sdev to per-LUN
 array
Reply-To: sashiko-reviews@lists.linux.dev
To: "Phil Pemberton" <philpem@philpem.me.uk>
Cc: linux-scsi@vger.kernel.org, cassel@kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260731213503.2379771-3-philpem@philpem.me.uk>
References: <20260731213503.2379771-1-philpem@philpem.me.uk>
 <20260731213503.2379771-3-philpem@philpem.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 22:07:40 +0000
Message-Id: <20260731220740.7E14E1F00ACF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Sleeping in atomic context due to `scsi_device_put()` under spinlo=
ck in `ata_scsi_dev_rescan` error path

Pre-existing issues:
- [High] Double-free or reference count underflow of OF device node in `ata=
_scsi_assign_ofnode`
- [High] Use-After-Free in `ata_port_detach` due to missing reference count=
 before `scsi_remove_device`
--

--- Patch [2]: [PATCH v8 2/6] ata: libata-scsi: convert dev->sdev to per-LU=
N array ---
commit 576f81319ae7ef4943e02f2cfa1da008a5f4256c
Author: Phil Pemberton <philpem@philpem.me.uk>
Subject: ata: libata-scsi: convert dev->sdev to per-LUN array

This commit replaces the scalar dev->sdev pointer with an array of
scsi_device pointers to support multi-LUN ATAPI devices. Code paths
are updated to iterate over all ATAPI_MAX_LUN slots instead of assuming
a single LUN.

> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 15ee44cf5bf23..43d5221dc347c 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -6381,11 +6381,16 @@ static void ata_port_detach(struct ata_port *ap)
>  	/* Remove scsi devices */
>  	ata_for_each_link(link, ap, HOST_FIRST) {
>  		ata_for_each_dev(dev, link, ALL) {
> -			if (dev->sdev) {
> +			int lun;
> +
> +			for (lun =3D ATAPI_MAX_LUN - 1; lun >=3D 0; lun--) {
> +				struct scsi_device *sdev =3D dev->sdev[lun];
> +				if (!sdev)
> +					continue;
> +				dev->sdev[lun] =3D NULL;
>  				spin_unlock_irqrestore(ap->lock, flags);
> -				scsi_remove_device(dev->sdev);
> +				scsi_remove_device(sdev);

[Severity: High]
This is a pre-existing issue, but does dropping the lock here without
holding a reference to sdev expose us to a use-after-free?

The commit message mentions that clearing the array slot closes the UAF
window, but if a concurrent sysfs removal drops the final reference
while the lock is released, could scsi_remove_device(sdev) end up
dereferencing freed memory?

Would it be safer to call scsi_device_get(sdev) before dropping the lock?

>  				spin_lock_irqsave(ap->lock, flags);
> -				dev->sdev =3D NULL;
>  			}
>  		}
>  	}

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 04c96f3fd8652..808368b952b51 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
[ ... ]
> @@ -5185,7 +5196,7 @@ int ata_scsi_add_hosts(struct ata_host *host, const=
 struct scsi_host_template *s
>  #ifdef CONFIG_OF
>  static void ata_scsi_assign_ofnode(struct ata_device *dev, struct ata_po=
rt *ap)
>  {
> -	struct scsi_device *sdev =3D dev->sdev;
> +	struct scsi_device *sdev =3D ata_dev_scsi_device(dev, 0);
>  	struct device *d =3D ap->host->dev;
>  	struct device_node *np =3D d->of_node;
>  	struct device_node *child;

[Severity: High]
This isn't a bug introduced by this patch, but does
ata_scsi_assign_ofnode() cause a reference count underflow or
double-free on the device node?

If for_each_available_child_of_node() assigns the child pointer to both
dev->tdev.of_node and sdev->sdev_gendev.of_node, we have two pointers
sharing a single acquired reference. When both devices are destroyed,
they will each call of_node_put(), potentially leading to a double-free.

Should we add an of_node_get() for the second assignment?

[ ... ]
> @@ -5534,7 +5542,8 @@ void ata_scsi_dev_rescan(struct work_struct *work)
[ ... ]
>  				ret =3D scsi_rescan_device(sdevs[lun]);
>  				scsi_device_put(sdevs[lun]);
>  				spin_lock_irqsave(ap->lock, flags);
> =20
> -			if (ret)
> -				goto unlock_ap;
> +				if (ret) {
> +					while (++lun < ATAPI_MAX_LUN)
> +						if (sdevs[lun])
> +							scsi_device_put(sdevs[lun]);
> +					goto unlock_ap;
>  				}

[Severity: High]
Can this call to scsi_device_put() sleep while holding the spinlock?

Since this block runs after spin_lock_irqsave(ap->lock, flags) is
called, interrupts are disabled. If a concurrent removal has dropped
other references, this scsi_device_put() call might drop the final
reference and invoke the release handler scsi_device_dev_release().

Since the release handler contains blocking calls like
cancel_work_sync(), could this cause a schedule-while-atomic BUG?

> -			ret =3D scsi_rescan_device(sdev);
> -			scsi_device_put(sdev);
> -			spin_lock_irqsave(ap->lock, flags);
> =20
> -			if (ret)
> -				goto unlock_ap;
> +			if (do_resume)
> +				dev->flags &=3D ~ATA_DFLAG_RESUMING;
>  		}
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731213503.2379=
771-1-philpem@philpem.me.uk?part=3D2
