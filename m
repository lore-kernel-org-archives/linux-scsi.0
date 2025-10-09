Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E462E6CA5
	for <linux-scsi@vger.kernel.org>; Thu,  9 Oct 2025 13:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760017697; cv=none; b=fkPMwwvO8+G+VgzNiXbJbO+zf+oC53yj6PaTRFbh1EpHyT0KWL/GU6INsGO8zOpAUiHCaCrr4NYqRW9EdJD0WB06EpNAQ9CJ/6rWRj+vyv/RigBGB77+3HxNGnI+csYoxFD+bWwPhVsiS7snlRQvgaCli2FJ2kJ77+SaDSelOpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760017697; c=relaxed/simple;
	bh=uMTYl0l0bgRiFOYdD2SO3Mgit4uamyS2BKPDM62RoPw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dz03vS6L3qI206+SZ2ACoLaWNOPScijuc5V7TCGDdafv+2ehPRTz5mjr5tiII6PF1TrqGOUVBY70bjhhqdMU9lk7uT7PNC6ROxpTDH6rdIk6Gr9n7owItTBGOSSLshHSdVObWvEd3BzBaQT7QGuTiAcx0wzdIc2kYFZ5KyDH1C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=Ko5GMo+M; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="Ko5GMo+M"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 283C0240101
	for <linux-scsi@vger.kernel.org>; Thu,  9 Oct 2025 15:48:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de; s=2017;
	t=1760017692; bh=2DCj6qFoCxBp2NDx0KA/+MnCcq+JdNn8e5RmKU2/pbs=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:Autocrypt:OpenPGP:From;
	b=Ko5GMo+Mk8iG/F965pPGt/5Q+/oe29ORbJ594XdvcVdEu0RhTLynHS+BYwElaKqDf
	 glzCuIyj8GTWBoy7uFkV62225AiUC17JmDrK0yd0/kG7PKw9YOoncMXI2vpsU82gzP
	 uKGP1zEuiWt5lgJ0bEmqCuPP81DUJAJ4/CLGjFkW/JUIoOJv/kraoVLPclzCYNPnhg
	 dK3uR8fsRr0J8S4qTlDntt18dqrDHc0f6P5ONErLfTpB3I5FC98xdqI+2lxubCebnM
	 kzYkP9SjLjA7QNyjBn0H4i8rdBPHhQUyeAoVqT2Yw3IV3eFKh6UC/Kjs/d2qHMlH8k
	 cLPFSLKQd+75g==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4cjB631b7lz6twC;
	Thu,  9 Oct 2025 15:48:11 +0200 (CEST)
Message-ID: <5900cfcea7e5f8bc0f100be4afeced9e203c3e9f.camel@posteo.de>
Subject: Re: [PATCH v2 2/2] ata: Use ACPI methods to power on ata ports
From: Markus Probst <markus.probst@posteo.de>
To: Niklas Cassel <cassel@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, "James E . J . Bottomley"
	 <James.Bottomley@hansenpartnership.com>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 09 Oct 2025 13:48:11 +0000
In-Reply-To: <aOejov5d_TlVkueH@ryzen>
References: <8c3cb28c57462f9665b08fdaa022e6abc57fcd9e.camel@posteo.de>
	 <20251009112433.108643-1-markus.probst@posteo.de>
	 <20251009112433.108643-3-markus.probst@posteo.de> <aOejov5d_TlVkueH@ryzen>
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

On Thu, 2025-10-09 at 13:59 +0200, Niklas Cassel wrote:
> On Thu, Oct 09, 2025 at 11:24:49AM +0000, Markus Probst wrote:
> > Some embedded devices, including many Synology NAS devices, have
> > the
> > ability to control whether a ATA port has power or not.
>=20
> In V1, you mentioned that it was to control the SATA power supply,
> now you mention the ATA port. I am confused.
The power supply associated with the ata port (or to be more precise,
it controls the power gate to the SATA Power connector for the specific
disk, at least in the synology example). It sets the power state
defined in ACPI on the ata port. I might need to update the wording
used in the patches to make it more clear.

>=20
> If it is for the ATA port, then SATA already has support for this,
> using PxSCTL.
>=20
> How does this ACPI way to control power interact with the regular
> way to control power for a port using PxSCTL?
>=20
>=20
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
> > will be used to power on an ata port if usable ACPI power resources
> > are
> > found. It will be called right before probing the port, therefore
> > the port
> > will be powered on just in time.
> >=20
> > Signed-off-by: Markus Probst <markus.probst@posteo.de>
> > ---
> > =C2=A0drivers/ata/libata-acpi.c | 70
> > +++++++++++++++++++++++++++++++++++++++
> > =C2=A0drivers/ata/libata-core.c |=C2=A0 2 ++
> > =C2=A0drivers/ata/libata-scsi.c |=C2=A0 1 +
> > =C2=A0drivers/ata/libata.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +++
> > =C2=A04 files changed, 77 insertions(+)
> >=20
> > diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> > index f2140fc06ba0..bba5ef49f055 100644
> > --- a/drivers/ata/libata-acpi.c
> > +++ b/drivers/ata/libata-acpi.c
> > @@ -245,6 +245,76 @@ void ata_acpi_bind_dev(struct ata_device *dev)
> > =C2=A0				=C2=A0=C2=A0 ata_acpi_dev_uevent);
> > =C2=A0}
> > =C2=A0
> > +/**
> > + * ata_acpi_dev_manage_restart - if the disk should be stopped
> > (spin down) on
> > + * system restart.
> > + * @dev: target ATA device
> > + *
> > + * RETURNS:
> > + * true if the disk should be stopped, otherwise false
> > + */
> > +bool ata_acpi_dev_manage_restart(struct ata_device *dev)
> > +{
> > +	// If the device is power manageable and we assume the
> > disk loses power
> > +	// on reboot.
>=20
> Like Damien mentioned earlier, please no C++ style comments.
>=20
>=20
> Kind regards,
> Niklas

Also for the questions sent to the v1 patch:

> Since this patch implements something similar to DevSleep, but
> rather,
> IIUC, for the SATA power itself?

Yes


> How is SATA power supplied tied to a port in ACPI? If you have a
desktop
> you have a PSU, and don't really know which supply is for which port.

It is not for desktop computers, but for embedded devices.


> So, considering how many ways we already have to disable/power off a
port,
> you might understand why I think it is extra important that you
document
> exactly how, and why we need yet another way to disable/power on/off
a port.

In this case,
- According to ACPI spec, if a device has a power resource defined it
has to be turned on before we are able send commands to the device
- Because there is hardware out there, that is perfectly capable of
running upstream linux, which doesn't use one of the methods you
mentioned for controlling the power. Same did apply for the USB VBus
power, despite there being "USB_PORT_FEAT_POWER" in the spec and it
also got in the kernel, see commit
f7ac7787ad361e31a7972e2854ed8dc2eedfac3b.

I will try to add a short version of the reason written above in the
commit message.


Thanks,
- Markus Probst
