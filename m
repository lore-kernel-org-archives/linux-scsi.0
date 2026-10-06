Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F54238759C;
	Tue,  6 Oct 2026 23:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791331129; cv=none; b=HrJsY3lNg9NxiZjY+VT6dROOSEpI2xOcjmLOWxYEbffBlOLBtg4kTCQivhqRWCQKWUFJY4ysj/hJfKHSiJbhwOR/ak8NuRA5FyXM8IwzDp8FMmmiPJjy5GaCk427OVIW+rhciBaTMCn+ill/PR5joxBRBOWOvC1ZC7Lmdub8GV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791331129; c=relaxed/simple;
	bh=9FtlvY+EA7iOj/R9Ejk2Xmp52qvpuI8V/J1+7RPDaXU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=OoYUqrpWRaNH47ixpVmh8XQX/qYBBaZkx4jiDTYyf8Er4Fk2xadhc5HSg8fQPrWj7FOuFIm1V/U9iJLxImDxCTtc6IKh8pdnUUkl/1uJtA2cmcNuWKNoCqSVUU/VSOJS0k/pYaJT6wp8HJZlovSW+5tFjGXRiZyKOSQQ0K0+wiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jia3UIBc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jia3UIBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92B91F0089B;
	Tue,  6 Oct 2026 23:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791331128;
	bh=1t4PU1R4AoXFb280ybJN1CXnTE8NME3aBwxkVA4Zqls=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Jia3UIBc5lSF56fmiFn+oudAnH0ZQ4fNy+45o3SVRAg7R+Ot4ARBQmMQBAXJ5iO5g
	 rvH7WwPf3uE99o0ziO9VbgWUEGj93N4hS2qUE/hRoIzIsE32kud9rGVBdovAjTrI4j
	 4mydvDOFkD5ffK72zzotOYNfgGAlk0gCz08F9RZydocKtu/MS14tmBVT5TDujddLfv
	 EwYVm/68UUNFqukPmU6Z6n4cmV+o/qS4MjFmeRv1G5WnIV33vh2TDdzjuYU0z4aEyq
	 SLTI3C4SgyBgoPCSwCiVXCh7R7zFKKHTUNBbwuhlJaDi2h1hrQfgocKf4JG8o7vO7E
	 kCl1bbIiXOG4A==
Message-ID: <sashiko-outbox-162543@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 07/11] ata: libata-scsi: convert dev->sdev to per-LUN
 array
Reply-To: sashiko-reviews@lists.linux.dev
To: "Phil Pemberton" <philpem@philpem.me.uk>
Cc: cassel@kernel.org, linux-scsi@vger.kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20261006234202.1139018-8-philpem@philpem.me.uk>
References: <20261006234202.1139018-1-philpem@philpem.me.uk>
 <20261006234202.1139018-8-philpem@philpem.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 23:58:47 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] ata: UAF in ata_acpi_uevent() accessing freed scsi_device kobject
- [Medium] of: memory leak in ata_scsi_assign_ofnode() due to missing of_no=
de_put()
- [Medium] ata: libata-zpodd: stale from_notify flag in zpodd_wake_dev() ca=
uses unintended tray ejection
- [Medium] ata: redundant scsi_resume_device() calls on already-resumed LUN=
s due to shared device flag
--

commit 6719cc4aa927e2dd12a61aea767af00a2eb99075
Author: Phil Pemberton <philpem@philpem.me.uk>

ata: libata-scsi: convert dev->sdev to per-LUN array

Multi-LUN ATAPI devices share one ata_device and expose several SCSI
devices. Replace dev->sdev with an eight-slot array indexed by LUN and
update its callers. Single-LUN devices use slot 0; unused slots are NULL.

> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index 4433f626246ba..2d1662f6f0642 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -153,10 +153,13 @@ static void ata_acpi_uevent(struct ata_port *ap, st=
ruct ata_device *dev,
>  	char *envp[] =3D { event_string, NULL };
> =20
>  	if (dev) {
> -		if (dev->sdev)
> -			kobj =3D &dev->sdev->sdev_gendev.kobj;
> -	} else
> +		struct scsi_device *sdev =3D ata_dev_scsi_device(dev, 0);
> +
> +		if (sdev)
> +			kobj =3D &sdev->sdev_gendev.kobj;

[Severity: High]
Is this scsi_device kobject safe from being freed during this call?

The scsi_device is retrieved via ata_dev_scsi_device() without taking
ap->lock or acquiring a reference with scsi_device_get(). A concurrent
unplug could drop the reference count and free the device object before
kobject_uevent_env() executes, leading to a use-after-free.

> +	} else {
>  		kobj =3D &ap->dev->kobj;
> +	}
> =20
>  	if (kobj) {

[ ... ]

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 3131d84204ed7..68d6ca1f791dd 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c

[ ... ]

> @@ -5259,9 +5270,9 @@ int ata_scsi_add_hosts(struct ata_host *host, const=
 struct scsi_host_template *s
>  }
> =20
>  #ifdef CONFIG_OF
> -static void ata_scsi_assign_ofnode(struct ata_device *dev, struct ata_po=
rt *ap)
> +static void ata_scsi_assign_ofnode(struct scsi_device *sdev,
> +				   struct ata_device *dev, struct ata_port *ap)
>  {

[Severity: Medium]
Does ata_scsi_assign_ofnode() leak a device tree node reference?

When for_each_available_child_of_node() inside this function finds a
matching port, it assigns the child to sdev->sdev_gendev.of_node and
returns early. The iterator implicitly acquires a reference to the child
node on each iteration. Since the SCSI and driver cores do not
automatically call of_node_put() on the device of_node during teardown,
this leaves a persistent reference leak.

> -	struct scsi_device *sdev =3D dev->sdev;
>  	struct device *d =3D ap->host->dev;
>  	struct device_node *np =3D d->of_node;
>  	struct device_node *child;

[ ... ]

> @@ -5610,7 +5619,9 @@ void ata_scsi_dev_rescan(struct work_struct *work)
> =20
>  	ata_for_each_link(link, ap, EDGE) {
>  		ata_for_each_dev(dev, link, ENABLED) {
> -			struct scsi_device *sdev =3D dev->sdev;
> +			struct scsi_device *sdevs[ATAPI_MAX_LUN] =3D {};
> +			bool retry =3D false;
> +			int lun, err;
> =20
>  			/*
>  			 * If the port was suspended before this was scheduled,

[ ... ]

> -			spin_unlock_irqrestore(ap->lock, flags);
> -			if (do_resume) {
> -				ret =3D scsi_resume_device(sdev);
> -				if (ret =3D=3D -EWOULDBLOCK) {
> -					scsi_device_put(sdev);
> -					goto unlock_scan;
> +			for (lun =3D 0; lun < ATAPI_MAX_LUN; lun++) {
> +				if (!sdevs[lun])
> +					continue;
> +
> +				spin_unlock_irqrestore(ap->lock, flags);
> +				if (do_resume) {
> +					err =3D scsi_resume_device(sdevs[lun]);
> +					if (err =3D=3D -EWOULDBLOCK)
> +						goto put_sdev;
>  				}
> -				dev->flags &=3D ~ATA_DFLAG_RESUMING;
> +				err =3D scsi_rescan_device(sdevs[lun]);

[Severity: Medium]
Will this cause redundant resume attempts on already-resumed LUNs?

When do_resume is true, both scsi_resume_device() and scsi_rescan_device()
execute for every valid LUN without checking if that specific LUN was
already successfully resumed in a previous pass.

> +put_sdev:
> +				/* A deferred LUN must not prevent scanning its siblings. */
> +				if (err) {
> +					ret =3D err;
> +					retry =3D true;
> +				}
> +				scsi_device_put(sdevs[lun]);
> +				spin_lock_irqsave(ap->lock, flags);
>  			}
> -			ret =3D scsi_rescan_device(sdev);
> -			scsi_device_put(sdev);
> -			spin_lock_irqsave(ap->lock, flags);
> =20
> -			if (ret)
> -				goto unlock_ap;
> +			if (do_resume && !retry)
> +				dev->flags &=3D ~ATA_DFLAG_RESUMING;

[Severity: Medium]
If any LUN sets retry to true by returning -EWOULDBLOCK, the per-device
ATA_DFLAG_RESUMING flag is kept set. Consequently, the next execution of
the workqueue will see do_resume as true and unconditionally re-resume all
sibling LUNs, even the ones that previously succeeded.

>  		}
>  	}

[ ... ]

> diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
> index 581eb41ea0f3c..bbdcaaa357980 100644
> --- a/drivers/ata/libata-zpodd.c
> +++ b/drivers/ata/libata-zpodd.c

[ ... ]

> @@ -265,18 +272,21 @@ static void zpodd_wake_dev(acpi_handle handle, u32 =
event, void *context)
>  {
>  	struct ata_device *ata_dev =3D context;
>  	struct zpodd *zpodd =3D ata_dev->zpodd;
> -	struct scsi_device *sdev;
> +	int lun;
> =20
>  	if (event !=3D ACPI_NOTIFY_DEVICE_WAKE)
>  		return;
> -	sdev =3D zpodd_get_sdev(ata_dev);
> -	if (!sdev)
> -		return;
> -	if (pm_runtime_suspended(&sdev->sdev_gendev)) {
> -		zpodd->from_notify =3D true;
> -		pm_runtime_resume(&sdev->sdev_gendev);
> +	for (lun =3D 0; lun < ATAPI_MAX_LUN; lun++) {
> +		struct scsi_device *sdev =3D zpodd_get_sdev(ata_dev, lun);
> +
> +		if (!sdev)
> +			continue;
> +		if (pm_runtime_suspended(&sdev->sdev_gendev)) {
> +			zpodd->from_notify =3D true;
> +			pm_runtime_resume(&sdev->sdev_gendev);
> +		}

[Severity: Medium]
Can the from_notify flag become stuck in a true state here?

Setting this per-ATA-device flag inside a per-LUN loop allows the flag to
be incorrectly left true. If the first suspended LUN causes an actual
resume, from_notify is set and then cleared in zpodd_post_poweron() when
EH runs. For subsequent suspended LUNs, from_notify is set to true again,
but pm_runtime_resume() finds the parent already active and does not
trigger EH. This leaves from_notify set to true, which will cause an
unintended physical tray ejection during the next power-on.

> +		scsi_device_put(sdev);
>  	}
> -	scsi_device_put(sdev);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006234202.1139=
018-1-philpem@philpem.me.uk?part=3D7
