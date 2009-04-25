From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: Stop disks on reboot for laptop which cuts power
Date: Sat, 25 Apr 2009 11:18:18 +0200
Message-ID: <20090425111818.1728cf21@neptune.home>
References: <cslAV-2lq-113@gated-at.bofh.it>
	<9f0e232d-4901-4e60-ac83-c14a6405202d@z5g2000yqn.googlegroups.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <9f0e232d-4901-4e60-ac83-c14a6405202d@z5g2000yqn.googlegroups.com>
Sender: linux-ide-owner@vger.kernel.org
To: Ciprian Dorin =?UTF-8?B?Q3LEg2NpdW4=?= <ciprian.craciun@gmail.com>
Cc: Linux IDE <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux SCSI <linux-scsi@vger.kernel.org>, Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 25 April 2009 Ciprian Dorin Craciun wrote:
> On Apr 18, 7:30=C2=A0pm, Bruno Pr=C3=A9mont <bonb...@linux-vserver.or=
g> wrote:
> > Hi,
> >
> > During shutdown (power off) the disks are stopped gracefully thus
> > the stopping is skipped for reboot case.
> >
> > On my Acer Travelmate 660 reboot is more like power-off as it cuts
> > all power during reboot which currently causes the disk to
> > emergency-park its head (noisy and shortens disk life).
> >
> > This patch series adds a DMI-based check to ide-gd and sd to still
> > stop the disks for affected laptop during reboot.
> >
> > Has been compile an run-tested with libata and just compile-tested
> > for ide.
> >
> > Bruno Pr=C3=A9mont
>=20
>     (I've tried to reply to the group by google-groups, but it didn't
> worked...)
>=20
>     I have a Benq JoyBook S32 laptop that has the same behaviour...
> I've applied you patch, and just replaced the condition (dmi_...) wit=
h
> true, and now my laptop works OK while rebooting (it doesn't just cut
> power to the disks)...
>=20
>     So I would say this is a very needed patch for the mainline
> kernel... Will it be included? Also how do I add my laptop to the
> table provided in your patch?
>=20
>     Thanks,
>     Ciprian Craciun.
>=20
Just a note, my patches do not change the BIOS behavior on reboot, thus
power is still being cut if it was so before applying the patches. But
it stops the disks first so those do not suffer from the power cut.

The variant for IDE-GD is on its way for inclusion, for the SD one I
don't know.

Below is a sample patch to add your system to the list, please check if
it works when applied on top of my 2 patches. If it doesn't you will
have to adjust the name of your laptop's manufacturer and it's product
name to correctly match your system. Please report if it works (or what
manufacturer/product name it works with) for you.
The right information can be extracted from dmidecode (System
Information block)


Tejun suggested eventually stopping the disks for all machines though
as far as I can see here my laptop is the only one affected out of a
dozen different boxes I have around. (eventually just doing it for
laptops might be reasonable as generalization)

Bruno

---

sd, ide-gd: stop disk on reboot for Benq JoyBook S32

Ciprian Craciun reported that Benq JoyBook S32 was affected by
the same power-cut on reboot as Acer TravelMate 660, so add it
to the list.

---
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 4b6b71e..a78813d 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -109,6 +109,14 @@ static const struct dmi_system_id ide_coldreboot_t=
able[] =3D {
 			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 660"),
 		},
 	},
+	{
+		/* Benq JoyBook S32 cuts power during reboot */
+		.ident   =3D "Benq JoyBook S32",
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "Benq"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "JoyBook S32"),
+		},
+	},
=20
 	{ }	/* terminate list */
 };
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fdad8bc..68c828a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2137,6 +2137,14 @@ static const struct dmi_system_id sd_coldreboot_=
table[] =3D {
 			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 660"),
 		},
 	},
+	{
+		/* Benq JoyBook S32 cuts power during reboot */
+		.ident   =3D "Benq JoyBook S32",
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "Benq"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "JoyBook S32"),
+		},
+	},
=20
 	{ }	/* terminate list */
 };
