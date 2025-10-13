Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC5B27146B
	for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 12:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760358595; cv=none; b=j/lroEPg4I/g8AIdF68XoIbWghuYe5IoH9HCJkYe8cZHc4FzxKawMm+6Vr8BAHPBmnTgOLdEUF3/RfCLPCDXgi9dNXtyQtjo2zpxpxDI4hCQk2qX+l55VQuuf4Ku//6nOKl//cyba1C00x1ngzWJVOjVGBIiETQYwl2jH4cuInQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760358595; c=relaxed/simple;
	bh=u5A2B4cxGHxuvX6wsICtQXWG0hhh2q6pv0dMsAd0ZV4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aDBOSLQqClloUngmvagUV7cHX3LBvuPwg05d36N0SUQ9b26I/D41x9JkRWQOo5SUL1k9HdJ6qBe4QaH/K003rUZdlR5pwW/CBmUk52tE5U15bdsgQuD+BC52QlyDAanECzqFqp1kv21Q0L31+kQZ7BdQR1r64kgYfU8wDac5qD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=romjZbYM; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="romjZbYM"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 9CFB4240101
	for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 14:29:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de; s=2017;
	t=1760358591; bh=BNrUhklJjD5L4z4ko/bJgHuU483gqT28YNlaAj8Gtpw=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:Autocrypt:OpenPGP:From;
	b=romjZbYMQtAHLvdiMjbdiUKDlIiEupkeHiVEe8/y2b6/56BbvEwE6KHAyMdA4k+/X
	 XeVT8w/knYN43rOCiL88tecQTMptRVMPxkdt9mKiH027+x649G2DkZwELY9ihK6lun
	 DEIL74DIJFHZ0ZNHSib/61ionVN105mo7gpX2qfGgYJVY3uKVfhexJ5n+snRaCvaqK
	 D8M09wn9kj95AWAyytN0uAu5x8Iz82jqe9LsXbYzuIRgLqk9b0ZaoLMkA9VhwqqBpg
	 CbkIWOoXTVVWtse9CLSw99m6PIdCMqP7Mc1dLh57KpfS8jMUPdOpwyIzLgMdyh+qL9
	 MlfKjhN9SFS/w==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4clc9j4lDfz6twv;
	Mon, 13 Oct 2025 14:29:45 +0200 (CEST)
Message-ID: <48eff111d66156fd0bd8eb2418570db4aa62f392.camel@posteo.de>
Subject: Re: [PATCH v3 2/2] ata: Use ACPI methods to power on disks
From: Markus Probst <markus.probst@posteo.de>
To: Niklas Cassel <cassel@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, "James E.J. Bottomley"
	 <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
	 <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2025 12:29:46 +0000
In-Reply-To: <aOy2Vy6AQNynzewo@ryzen>
References: <20251010223817.729490-1-markus.probst@posteo.de>
	 <20251010223817.729490-3-markus.probst@posteo.de> <aOy2Vy6AQNynzewo@ryzen>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Autocrypt: addr=markus.probst@posteo.de; prefer-encrypt=mutual;
  keydata=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
  aBeNN4ijKZchBXHPgVx+YtWRHfcm4l8=
OpenPGP: url=https://posteo.de/keys/markus.probst@posteo.de.asc; preference=encrypt

On Mon, 2025-10-13 at 10:20 +0200, Niklas Cassel wrote:
> On Fri, Oct 10, 2025 at 10:38:35PM +0000, Markus Probst wrote:
> > Some embedded devices have the ability to control whether power is
> > provided to the disks via the sata power connector or not. If power
> > resources are defined on ata ports / devices in ACPI, we should try
> > to set
> > the power state to D0 before probing the disk to ensure that any
> > power
> > supply or power gate that may exist is providing power to the disk.
> >=20
> > An example for such devices would be newer synology nas devices.
> > Every
> > disk slot has its own sata power connector. Whether the connector
> > is
> > providing power is controlled via an gpio, which is *off by
> > default*.
> > Also the disk loses power on reboots.
> >=20
> > Add a new function, ata_acpi_dev_manage_restart(), that will be
> > used to
> > determine if a disk should be stopped before restarting the system.
> > If a
> > usable ACPI power resource has been found, it is assumed that the
> > disk
> > will lose power after a restart and should be stopped to avoid a
> > power
> > failure. Also add a new function, ata_acpi_port_set_power_state(),
> > that
> > will be used to power on the sata power connector if usable ACPI
> > power
> > resources on the associated ata port are found. It will be called
> > right
> > before probing the port, therefore the disk will be powered on just
> > in
> > time.
>=20
> s/sata/SATA/
> s/nas/NAS/
> s/ata/ATA/ (except for function names of course)
>=20
> Since this patch is basically doing two logical changes
> 1) Calling ata_acpi_dev_manage_restart() on restart, which calls
> acpi_bus_power_manageable() to disable power on shutdown.
>=20
> 2) Calling ata_acpi_port_set_power_state() during ata_port_probe(),
> to enable power.
>=20
> Please also split this patch into two, so that we have one commit per
> logical change. That would make things easier to understand, as your
> commit message your just describe one behavior instead of two
> completely
> different behaviors.
>=20
>=20
> Your commit message mentions that you want to spin down the disk on
> restart to avoid "avoid a power failure".
>=20
> Is there a reason why you call acpi_bus_power_manageable() to spin
> down
> the disk instead of the regular function: ata_dev_power_set_standby()
> which spins down the disk?
I don't use acpi_bus_power_manageable() to spin down the disk. It just
checks if there is a power resource present in acpi for the ata port /
device. If thats the case, scsi should spin the disk down on
SYSTEM_RESTART.
>=20
>=20
> >=20
> > Signed-off-by: Markus Probst <markus.probst@posteo.de>
> > ---
> > =C2=A0drivers/ata/libata-acpi.c | 71
> > +++++++++++++++++++++++++++++++++++++++
> > =C2=A0drivers/ata/libata-core.c |=C2=A0 2 ++
> > =C2=A0drivers/ata/libata-scsi.c |=C2=A0 1 +
> > =C2=A0drivers/ata/libata.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +++
> > =C2=A04 files changed, 78 insertions(+)
> >=20
> > diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> > index f2140fc06ba0..4a72a98b922c 100644
> > --- a/drivers/ata/libata-acpi.c
> > +++ b/drivers/ata/libata-acpi.c
> > @@ -245,6 +245,77 @@ void ata_acpi_bind_dev(struct ata_device *dev)
> > =C2=A0				=C2=A0=C2=A0 ata_acpi_dev_uevent);
> > =C2=A0}
> > =C2=A0
> > +/**
> > + * ata_acpi_dev_manage_restart - if the disk should be stopped
> > (spun down) on
> > + * system restart.
> > + * @dev: target ATA device
> > + *
> > + * RETURNS:
> > + * 1 if the disk should be stopped, otherwise 0
> > + */
> > +bool ata_acpi_dev_manage_restart(struct ata_device *dev)
> > +{
> > +	// If the device is power manageable and we assume the
> > disk loses power
> > +	// on reboot.
>=20
> Please no C++ style comments.
>=20
> Also "If the device is power manageable and we assume"
> should this not be
> "If the device is power manageable, we assume"
>=20
> Because your commit message says:
> "If a usable ACPI power resource has been found, it is assumed that
> the disk
> will lose power after a restart"
>=20
> so I think the word "and" here is wrong.
>=20
>=20
> > +	if (dev->link->ap->flags & ATA_FLAG_ACPI_SATA) {
> > +		if (!is_acpi_device_node(dev->tdev.fwnode))
> > +			return 0;
> > +		return acpi_bus_power_manageable(ACPI_HANDLE(&dev-
> > >tdev));
> > +	}
> > +
>=20
> Please add a commend here explaining the difference between the
> two cases, because you call either:
> return acpi_bus_power_manageable(ACPI_HANDLE(&dev->tdev));
> or
> return acpi_bus_power_manageable(ACPI_HANDLE(&dev->link->ap->tdev));
>=20
> At least the difference is not obvious to me, from just looking at
> this
> function.
if ATA_FLAG_ACPI_SATA is set, the acpi fwnode with the power resources
is not set on the ata_port->tdev, but on the ata_device->tdev. See
ata_acpi_bind_port (return if ATA_FLAG_ACPI_SATA is set) and
ata_acpi_bind_dev (return if ATA_FLAG_ACPI_SATA is not set).
I will add a comment for this.

Thanks
- Markus Probst

>=20
>=20
> > +	if (!is_acpi_device_node(dev->link->ap->tdev.fwnode))
> > +		return 0;
> > +	return acpi_bus_power_manageable(ACPI_HANDLE(&dev->link-
> > >ap->tdev));
> > +}
> > +
> > +/**
> > + * ata_acpi_port_set_power_state - set the power state of the ata
> > port
> > + * @ap: target ATA port
> > + * @enable: power state to be set
> > + *
> > + * This function is called at the beginning of ata_port_probe.
> > + */
> > +void ata_acpi_port_set_power_state(struct ata_port *ap, bool
> > enable)
>=20
> This function is never called with enable=3D=3Dfalse, so let's please
> remove
> this parameter and rename the function to something like
> ata_acpi_port_enable_power() or similar.
> If someone a future patch ever wants to refactor this to also handle
> disable, then that patch can also create a parameter for this
> function.
> Otherwise we are just adding dead code.
>=20
>=20
> Kind regards,
> Niklas
