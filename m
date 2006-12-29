From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Fwd: Re: Problem with Linux aic94xx driver
Date: Fri, 29 Dec 2006 12:18:27 -0800 (PST)
Message-ID: <203581.7076.qm@web31806.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31806.mail.mud.yahoo.com ([68.142.207.69]:47739 "HELO
	web31806.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965140AbWL2US1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Dec 2006 15:18:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: terje.rosten@ntnu.no, linux-scsi <linux-scsi@vger.kernel.org>

--- Terje R=F8sten <terje.rosten@ntnu.no> wrote:
> Hi!
>=20
> I have a Tyan Transport TA26 barebone, with an addon card that I thin=
k=20
> has a AIC-94xx chip.
> I am using Fedora Core 6 with a kernel from Fedora rawhide (developme=
nt):
>=20
> $ uname -a
> Linux randi.phys.ntnu.no 2.6.19-1.2891.fc7 #1 SMP Thu Dec 21 10:59:56=
=20
> EST 2006 x86_64 x86_64 x86_64 GNU/Linux
>=20
> It's 2.6.20rc1-git5 kernel with some patches.
>=20
> When I load the module I get:
>=20
> aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.2 loaded
> ACPI: PCI Interrupt 0000:03:05.0[A] -> GSI 25 (level, low) -> IRQ 25
> aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:0=
3:05.0
> scsi7 : aic94xx
> aic94xx: using sequencer V17/10c6
> aic94xx: device 0000:03:05.0: SAS addr 500e081000011470, PCBA SN , 8=20
> phys, 8 enabled phys, flash present, BIOS build 1608
> ERROR: Unidentified device type 5
> ERROR: Unidentified device type 5
> ERROR: Unidentified device type 5
> ERROR: Unidentified device type 5
>=20
> (It's 4 Western Digital RE2 WD5000YS with NCQ (500 GB SATA) on the=20
> controller,
> set up in RAID BIOS  to one RAID 1+0 logical drive).
>=20
> Seems like I end up here:
>=20
> drivers/scsi/libsas/sas_discover.c: sas_get_port_device() :
>=20
> 256   switch (dev->dev_type) {
> 257         case SAS_END_DEV:
> 258                 rphy =3D sas_end_device_alloc(port->port);
> 259                 break;
> 260         case EDGE_DEV:
> 261                 rphy =3D sas_expander_alloc(port->port,
> 262                                           SAS_EDGE_EXPANDER_DEVIC=
E);
> 263                 break;
> 264         case FANOUT_DEV:
> 265                 rphy =3D sas_expander_alloc(port->port,
> 266                                           SAS_FANOUT_EXPANDER_DEV=
ICE);
> 267                 break;
> 268         case SATA_DEV:
> 269         default:
> 270                 printk("ERROR: Unidentified device type %d\n",=20
> dev->dev_type);
> 271                 rphy =3D NULL;
> 272                 break;
> 273         }
>=20
> Any ideas?

Terje,

In my SAS Stack, I _do not_ have that switch statement in that
function.  Apparently you are using "libsas", which is based
on an early, early version of my code, which bottomley and his
gang of SAS experts appropriated to "maintain".  And as your
problem shows has been "fixed" in many ways.

You should complain to them -- I've CC-ed the linux-scsi mailing
list.

BTW, I don't experience this bug with the SAS Stack as I maintain it.

    Luben

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
