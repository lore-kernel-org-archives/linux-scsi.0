Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D570C49C4DE;
	Tue,  6 Oct 2026 23:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791331160; cv=none; b=sitmt4l6HV9C4nO/NCdz1UuPxyjHUA5AjnZD9Jh1su4n/k9asYrWyAdu8nxRoQJOHWdPwfN5aPdDDclruVj/G0Kp7RWsod32aYq6CX7VllCcXjimXO4A+oXu8puO6Zlq+cI5fw2coHD6rHjK9ERkKY7RxibZiD2UaaD8mmOcJec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791331160; c=relaxed/simple;
	bh=E2zdl3tWC02RuyhIIj5TAOXJ0zYXjvMy8Odh36xfjJ4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=J59vYfBB7NGoI3k5u6VWSlYHHBdGR3KuSTbSO5l4NVQRlLJBlYa4sMU/+pYrhaCVz7UQN6x847jCWWhhFSjKvpIY4iih0EqrkayAEzGI3KYm0QqQT79DrZTLRc4LzpQHL0ptXduZNNlRzmGCtJLKOrgphugw6r+wQC0Zrtg5zsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M5uAeq9L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M5uAeq9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786F71F0089B;
	Tue,  6 Oct 2026 23:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791331159;
	bh=fFD2qmY5CVz0kUhCV/jMKbuZbwPm32sA57UwWzsd0HA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M5uAeq9LCUs8tzw7FNE5JTwGrM1aHhe2BGvKFJnfdDp936hKsuWOcvT68EGhZkvWQ
	 OyzYbYRMzmp5e8HwhfT5MguXsvSPYABL3AxG9oXzwJjqymskOfI2p+5EIuH+tajFKD
	 lSCLsZ8xrOrstp+VgGDja3JKMb8lSvJ/dCA7Wipf+iP6Rlsz2xrtgH0JPUaUUh3OCt
	 r/WxR1bCCuU/HcWHQR9/H+HfPmUPwKTU85X4m9n2/6FtG82C3D8ajcRmt9ahOy3GxW
	 WQ89IKTk10TBfmjT9ZEa5YG6Oh12gvKeyUFfl6nRerkc/ejfh8HsrliweqVCXHGHxA
	 gUqAmR/1DVo6A==
Message-ID: <sashiko-outbox-162545@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 02/11] ata: libata-zpodd: reference SCSI devices in
 PM callbacks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Phil Pemberton" <philpem@philpem.me.uk>
Cc: cassel@kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261006234202.1139018-3-philpem@philpem.me.uk>
References: <20261006234202.1139018-1-philpem@philpem.me.uk>
 <20261006234202.1139018-3-philpem@philpem.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 23:59:19 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] ata: TOCTOU race in zpodd wake can cause phantom tray ejections
- [Medium] ata: libata-zpodd: NULL pointer dereference in zpodd_wake_dev()
--

commit f9410c07ec8a633f31a2392169e048611d2e22b5
Author: Phil Pemberton <philpem@philpem.me.uk>
Subject: ata: libata-zpodd: reference SCSI devices in PM callbacks

This commit takes a SCSI device reference under ap->lock to prevent concurr=
ent
sysfs deletion from releasing the device before PM callbacks access it.
Missing or deleting devices are skipped, and locks are dropped before
accessing PM state or releasing the reference.

Link: https://lore.kernel.org/linux-ide/20260611030131.5285D1F00893@smtp.ke=
rnel.org/

> diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
> index 414e7c63bd850..581eb41ea0f3c 100644
> --- a/drivers/ata/libata-zpodd.c
> +++ b/drivers/ata/libata-zpodd.c

[ ... ]

>  static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
>  {
>  	struct ata_device *ata_dev =3D context;
>  	struct zpodd *zpodd =3D ata_dev->zpodd;
> -	struct device *dev =3D &ata_dev->sdev->sdev_gendev;
> +	struct scsi_device *sdev;
> =20
> -	if (event =3D=3D ACPI_NOTIFY_DEVICE_WAKE && pm_runtime_suspended(dev)) {
> +	if (event !=3D ACPI_NOTIFY_DEVICE_WAKE)
> +		return;
> +	sdev =3D zpodd_get_sdev(ata_dev);
> +	if (!sdev)
> +		return;
> +	if (pm_runtime_suspended(&sdev->sdev_gendev)) {

[Severity: Medium]
Could this lockless check of pm_runtime_suspended() race with a concurrent
runtime PM resume?

A race between an ACPI wake event (e.g. user pressing the eject button) and=
 a
concurrent runtime PM resume can cause the from_notify flag to be set right
after the resume path reads it as false.

If a concurrent resume is already progressing, it can execute
zpodd_post_poweron() and read from_notify as false:

drivers/ata/libata-zpodd.c:zpodd_post_poweron() {
    ...
    if (zpodd->from_notify) {
        zpodd->from_notify =3D false;
        if (zpodd->mech_type =3D=3D ODD_MECH_TYPE_DRAWER)
            eject_tray(dev);
    }
    ...
}

Then, zpodd_wake_dev() might set from_notify =3D true right after, leaving =
it
persistently true until the next power-on cycle.

This defers the tray ejection to the next resume cycle, potentially causing=
 a
phantom tray ejection. Alternatively, if the PM state just changed from
suspended, the ACPI handler might skip setting the flag entirely, losing the
eject event.

>  		zpodd->from_notify =3D true;

[Severity: Medium]
Can this dereference a NULL zpodd pointer if an ACPI event fires concurrent=
ly?

If a memory allocation failure occurs during the initial zpodd_init() call,
dev->zpodd remains NULL.

If the device later undergoes EH revalidation and kzalloc succeeds,
ata_acpi_add_pm_notifier() is called before dev->zpodd is assigned:

drivers/ata/libata-zpodd.c:zpodd_init() {
    ...
    ata_acpi_add_pm_notifier(dev);
    zpodd->dev =3D dev;
    dev->zpodd =3D zpodd;
    ...
}

If an ACPI wake event fires concurrently at this exact moment, zpodd_wake_d=
ev()
will execute asynchronously.

Because the device was previously successfully probed, dev->sdev is valid a=
nd
zpodd_get_sdev() returns a valid SCSI device.

If the SCSI device is runtime suspended (which can happen during a hotplug =
or
PHY event before the SCSI layer fully resumes it), pm_runtime_suspended()
evaluates to true.

This leads to zpodd->from_notify =3D true executing while zpodd is still NU=
LL,
causing a kernel oops.

> -		pm_runtime_resume(dev);
> +		pm_runtime_resume(&sdev->sdev_gendev);
>  	}
> +	scsi_device_put(sdev);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006234202.1139=
018-1-philpem@philpem.me.uk?part=3D2
