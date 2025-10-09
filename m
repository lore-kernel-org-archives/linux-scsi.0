Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB472DCC1A
	for <linux-scsi@vger.kernel.org>; Thu,  9 Oct 2025 11:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760008025; cv=none; b=WkmQrmNL1j/y+e2kI7zXlAV5a1MwTDXh2o4DTDIlaOpi1174IqCbbiWRJLAQNG10pM+AUhWFztHBx4lCz3lRYgVHBZUl0kyou6OjVWF75thMFLxxSm77aGUYGt9pee/vw4IfYQA8YesheXjByjMfnXBQqIr+uVyrkrlyze5z5ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760008025; c=relaxed/simple;
	bh=bU93fiDaF53YDILN7nrgapLV3wtHSlS/AbXCHy35IZM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fKA9uM0xkXf/W89Ii22aWbukkIPOIETfdPJa/ovuAtviRX/4BDC3AGsb0lw05DWNSgfnFH8Vgqfgl0xQSsz+LZxEfaKnsGEk6uOviMHJm7fi56pr9o4aBkoRcgOJZQvl+Mbe4r2IEsKa/NkQEUR2KFkmTT6EW9yNoESlNAaNS1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=eaymSdCx; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="eaymSdCx"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id D26B7240105
	for <linux-scsi@vger.kernel.org>; Thu,  9 Oct 2025 13:07:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de; s=2017;
	t=1760008021; bh=jdodBx5Ch5acLH1mwoIFx9Y9llTCsxwJpsKX6tIr/bQ=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:Autocrypt:OpenPGP:From;
	b=eaymSdCx3ktBFULxbRKWAutE4qhm7yc/5l25PwV+zTdcABX/As9s5g32+F+Y6sWDk
	 64Fgpqh8hBmilUKrgTZJZWmGCiCFp52DbDH9W7ERwciWjFDD0t762Yb1CtVOcJcH17
	 bRfqTf4RTffzCygxPrpebI/1hsrZh6UiDBHI7zoP4URizrXA9MyZbNMg3rt3rAXE58
	 EAIuSQ7ug5MQFjY3eEuJ6HaCxKE2Gs1+zZ0lGjA1ldJIChSYOcUrJyOS42RnWl9mGk
	 Q+CeAcLa4pUE/wO+IZrWM0n22pCRT0eBgPRdfLdm2vRbHYOaHob8q0pQdIUfEAC0ry
	 i4lHUPZtLcQzw==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4cj6X43PvWz6v08;
	Thu,  9 Oct 2025 13:07:00 +0200 (CEST)
Message-ID: <d8b785ff14e4c0b12aa73a6ebb2be6466157cc1c.camel@posteo.de>
Subject: Re: [PATCH 2/2] Power on ata ports defined in ACPI before probing
 ports
From: Markus Probst <markus.probst@posteo.de>
To: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Markus Probst <markus.probst@posteo.de>
Date: Thu, 09 Oct 2025 11:07:01 +0000
In-Reply-To: <7ab0ef5c-cce7-44d7-a416-4963e24e0b17@kernel.org>
References: <8c3cb28c57462f9665b08fdaa022e6abc57fcd9e.camel@posteo.de>
	 <20251005190559.1472308-1-markus.probst@posteo.de>
	 <20251005190559.1472308-2-markus.probst@posteo.de>
	 <7ab0ef5c-cce7-44d7-a416-4963e24e0b17@kernel.org>
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

On Mon, 2025-10-06 at 10:09 +0900, Damien Le Moal wrote:
> On 10/6/25 04:06, Markus Probst wrote:
> > some devices (for example every synology nas with "deep sleep"
> > support)
> > have the ability to power on and off each ata port individually.
> > This
> > turns the specific port on, if power manageable in acpi, before
> > probing
> > it.
>=20
> Please add "ata: " prefix to the commit titel and capitalize the
> first letter of
> sentences.
>=20
> The commit message above should also be improved. E.g. The "This" in
> "This turns
> on..." is unclear (I am assuming you mean "this patch" ?).
>=20
> >=20
> > This can later be extended to power down the ata ports (removing
> > power
> > from a disk) while the disk is spin down.
> >=20
> > Signed-off-by: Markus Probst <markus.probst@posteo.de>
> > ---
> > =C2=A0drivers/ata/libata-acpi.c | 68
> > +++++++++++++++++++++++++++++++++++++++
> > =C2=A0drivers/ata/libata-core.c | 21 ++++++++++++
> > =C2=A0drivers/ata/libata-scsi.c |=C2=A0 1 +
> > =C2=A0drivers/ata/libata.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +++
> > =C2=A0include/linux/libata.h=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> > =C2=A05 files changed, 95 insertions(+)
> >=20
> > diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> > index f2140fc06ba0..891b59bfe29f 100644
> > --- a/drivers/ata/libata-acpi.c
> > +++ b/drivers/ata/libata-acpi.c
> > @@ -245,6 +245,74 @@ void ata_acpi_bind_dev(struct ata_device *dev)
> > =C2=A0				=C2=A0=C2=A0 ata_acpi_dev_uevent);
> > =C2=A0}
> > =C2=A0
> > +/**
> > + * ata_acpi_dev_manage_restart - if the disk should be stopped
> > (spin down) on system restart.
>=20
> Long line. Please split at 80 chars.
>=20
> > + * @dev: target ATA device
> > + *
> > + * RETURNS:
> > + * true if the disk should be stopped, otherwise false
> > + */
> > +bool ata_acpi_dev_manage_restart(struct ata_device *dev)
> > +{
> > +	// If the device is power manageable and we assume the
> > disk loses power on reboot.
>=20
> This is not C++. Please use C style comments and split the long line.
>=20
> > +	if (dev->link->ap->flags & ATA_FLAG_ACPI_SATA) {
> > +		if (!is_acpi_device_node(dev->tdev.fwnode))
> > +			return false;
> > +		return acpi_bus_power_manageable(ACPI_HANDLE(&dev-
> > >tdev));
> > +	}
> > +
> > +	if (!is_acpi_device_node(dev->link->ap->tdev.fwnode))
> > +		return false;
> > +	return acpi_bus_power_manageable(ACPI_HANDLE(&dev->link-
> > >ap->tdev));
> > +}
> > +
> > +/**
> > + * ata_acpi_port_set_power_state - set the power state of the ata
> > port
> > + * @ap: target ATA port
> > + *
> > + * This function is called at the begin of ata_port_probe.
>=20
> ...at the beginning of ata_port_probe().
>=20
> > + */
> > +void ata_acpi_port_set_power_state(struct ata_port *ap, bool
> > enable)
> > +{
> > +	acpi_handle handle;
> > +	unsigned char state;
> > +	int i;
> > +
> > +	if (libata_noacpi)
> > +		return;
> > +
> > +	if (enable)
> > +		state =3D ACPI_STATE_D0;
> > +	else
> > +		state =3D ACPI_STATE_D3_COLD;
> > +
> > +	if (ap->flags & ATA_FLAG_ACPI_SATA) {
> > +		for (i =3D 0; i < ATA_MAX_DEVICES; i++) {
> > +			if (!is_acpi_device_node(ap-
> > >link.device[i].tdev.fwnode))
> > +				continue;
> > +			handle =3D ACPI_HANDLE(&ap-
> > >link.device[i].tdev);
> > +			if (!acpi_bus_power_manageable(handle))
> > +				continue;
> > +			if (!acpi_bus_set_power(handle, state))
> > +				ata_dev_info(&ap->link.device[i],
> > "acpi: power was set to %d\n",
> > +					=C2=A0=C2=A0=C2=A0=C2=A0 enable);
> > +			else
> > +				ata_dev_info(&ap->link.device[i],
> > "acpi: power failed to be set\n");
> > +		}
>=20
> Add a return here to avoid the else.
>=20
> > +	} else {
> > +		if (!is_acpi_device_node(ap->tdev.fwnode))
> > +			return;
> > +		handle =3D ACPI_HANDLE(&ap->tdev);
> > +		if (!acpi_bus_power_manageable(handle))
> > +			return;
> > +
> > +		if (!acpi_bus_set_power(handle, state))
> > +			ata_port_info(ap, "acpi: power was set to
> > %d\n", enable);
>=20
> ata_port_debug(ap, "acpi: power %sabled\n",
> 	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enable ? "en" : "dis");
>=20
> > +		else
> > +			ata_port_info(ap, "acpi: power failed to
> > be set\n");
>=20
> ata_port_err(ap, "acpi: failed to set power state\n");
>=20
> Overall, this hunk is the same as what is done in the loop above. So
> maybe
> create a helper function instead of repeating the same procedure.
I don't think this can be avoided while still having proper log
messages.
In the first hunk the power state will be set on a ata_device, on the
second hunk on a ata_port.

>=20
> > +	}
> > +}
> > +
> > =C2=A0/**
> > =C2=A0 * ata_acpi_dissociate - dissociate ATA host from ACPI objects
> > =C2=A0 * @host: target ATA host
> > diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> > index ff53f5f029b4..a52b916af14c 100644
> > --- a/drivers/ata/libata-core.c
> > +++ b/drivers/ata/libata-core.c
> > @@ -5899,11 +5899,32 @@ void ata_host_init(struct ata_host *host,
> > struct device *dev,
> > =C2=A0}
> > =C2=A0EXPORT_SYMBOL_GPL(ata_host_init);
> > =C2=A0
> > +static inline void ata_port_set_power_state(struct ata_port *ap,
> > bool enable)
> > +{
> > +	ata_acpi_port_set_power_state(ap, enable);
> > +	// Maybe add a way with device tree and regulators too?
>=20
> Drop this comment please.
>=20
> > +}
> > +
> > +/**
> > + * ata_dev_manage_restart - if the disk should be stopped (spin
> > down) on system restart.
> > + * @dev: target ATA device
> > + *
> > + * RETURNS:
> > + * true if the disk should be stopped, otherwise false
> > + */
> > +bool ata_dev_manage_restart(struct ata_device *dev)
> > +{
> > +	return ata_acpi_dev_manage_restart(dev);
> > +}
> > +EXPORT_SYMBOL_GPL(ata_dev_manage_restart);
>=20
> Why the export ? libata-core and libata-scsi are compiled together as
> libata.ko.
> The export should not be needed.
>=20
> > +
> > =C2=A0void ata_port_probe(struct ata_port *ap)
> > =C2=A0{
> > =C2=A0	struct ata_eh_info *ehi =3D &ap->link.eh_info;
> > =C2=A0	unsigned long flags;
> > =C2=A0
> > +	ata_port_set_power_state(ap, true);
> > +
> > =C2=A0	/* kick EH for boot probing */
> > =C2=A0	spin_lock_irqsave(ap->lock, flags);
> > =C2=A0
> > diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> > index 2ded5e476d6e..52297d9e3dc2 100644
> > --- a/drivers/ata/libata-scsi.c
> > +++ b/drivers/ata/libata-scsi.c
> > @@ -1095,6 +1095,7 @@ int ata_scsi_dev_config(struct scsi_device
> > *sdev, struct queue_limits *lim,
> > =C2=A0		 */
> > =C2=A0		sdev->manage_runtime_start_stop =3D 1;
> > =C2=A0		sdev->manage_shutdown =3D 1;
> > +		sdev->manage_restart =3D
> > ata_dev_manage_restart(dev);
> > =C2=A0		sdev->force_runtime_start_on_system_start =3D 1;
> > =C2=A0	}
> > =C2=A0
> > diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> > index e5b977a8d3e1..28cb652d99bc 100644
> > --- a/drivers/ata/libata.h
> > +++ b/drivers/ata/libata.h
> > @@ -130,6 +130,8 @@ extern void ata_acpi_on_disable(struct
> > ata_device *dev);
> > =C2=A0extern void ata_acpi_set_state(struct ata_port *ap, pm_message_t
> > state);
> > =C2=A0extern void ata_acpi_bind_port(struct ata_port *ap);
> > =C2=A0extern void ata_acpi_bind_dev(struct ata_device *dev);
> > +extern void ata_acpi_port_set_power_state(struct ata_port *ap,
> > bool enable);
> > +extern bool ata_acpi_dev_manage_restart(struct ata_device *dev);
> > =C2=A0extern acpi_handle ata_dev_acpi_handle(struct ata_device *dev);
> > =C2=A0#else
> > =C2=A0static inline void ata_acpi_dissociate(struct ata_host *host) { }
> > @@ -140,6 +142,8 @@ static inline void ata_acpi_set_state(struct
> > ata_port *ap,
> > =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pm_message_t state) { }
> > =C2=A0static inline void ata_acpi_bind_port(struct ata_port *ap) {}
> > =C2=A0static inline void ata_acpi_bind_dev(struct ata_device *dev) {}
> > +static inline void ata_acpi_port_set_power_state(struct ata_port
> > *ap, bool enable) {}
> > +static inline bool ata_acpi_dev_manage_restart(struct ata_device
> > *dev) { return false; }
> > =C2=A0#endif
> > =C2=A0
> > =C2=A0/* libata-scsi.c */
> > diff --git a/include/linux/libata.h b/include/linux/libata.h
> > index 0620dd67369f..af5974e91e1d 100644
> > --- a/include/linux/libata.h
> > +++ b/include/linux/libata.h
> > @@ -1302,6 +1302,7 @@ extern int sata_link_debounce(struct ata_link
> > *link,
> > =C2=A0extern int sata_link_scr_lpm(struct ata_link *link, enum
> > ata_lpm_policy policy,
> > =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0 bool spm_wakeup);
> > =C2=A0extern int ata_slave_link_init(struct ata_port *ap);
> > +extern bool ata_dev_manage_restart(struct ata_device *dev);
> > =C2=A0extern void ata_port_probe(struct ata_port *ap);
> > =C2=A0extern struct ata_port *ata_port_alloc(struct ata_host *host);
> > =C2=A0extern void ata_port_free(struct ata_port *ap);
>=20

Thanks
- Markus Probst
