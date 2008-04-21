From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: MPTSAS: ("activate status led" | "find disc") in external
	enclosure
Date: Mon, 21 Apr 2008 10:16:45 -0500
Message-ID: <1208791005.3640.10.camel@localhost.localdomain>
References: <20080418124104.9ca87130.taeuber@bbaw.de>
	 <1208528945.3063.7.camel@localhost.localdomain>
	 <20080421110148.1918485e.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50059 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754115AbYDUPQs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2008 11:16:48 -0400
In-Reply-To: <20080421110148.1918485e.taeuber@bbaw.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lars =?ISO-8859-1?Q?T=E4uber?= <taeuber@bbaw.de>
Cc: linux-scsi@vger.kernel.org

On Mon, 2008-04-21 at 11:01 +0200, Lars T=C3=A4uber wrote:
> Hi James,
>=20
> James Bottomley <James.Bottomley@HansenPartnership.com> schrieb:
> > On Fri, 2008-04-18 at 12:41 +0200, Lars T=C3=A4uber wrote:
> > > Is there a standard way to lit the led in the enclosure with linu=
x means or anything alike?
> > > The enclosure does not tell the serial numbers of the included di=
sc.
> > > The HBA is an LSI SAS 3801X.
> >=20
> > It depends on whether you have the HBA configured in RAID mode or n=
ot.
> > If you have, then it takes absolute control of the enclosure manage=
ment
> > at the moment and I don't think you can get to it.
>=20
> our HBA has no RAID option.
>=20
> > If you run the HBA as a pure SAS one, then the promise website says=
 this
> > enclosure is ses2 compliant, so you should just be able to insert t=
he
> > ses module and have enclosure management (2.6.24+ kernels).  This r=
elies
> > on the HBA exposing the enclosure device, but I think mptsas only e=
ats
> > it for RAID configurations.

> I tried 2.6.24.5 but the ses seems to be introduced in 2.6.25.

OK ... it's hard for me to keep track of what went when.  It must have
gone in after 2.6.24 in the merge window.
=20
> > to see what's in the enclosure, just do
> >=20
> > ls /sys/class/enclosure/*/
>=20
> # ls /sys/class/enclosure/*/
> /sys/class/enclosure/6:0:16:0/:
> 0  10  12  14  2  4  6  8  components  subsystem
> 1  11  13  15  3  5  7  9  device      uevent
>=20
> /sys/class/enclosure/6:0:33:0/:
> 0  10  12  14  2  4  6  8  components  subsystem
> 1  11  13  15  3  5  7  9  device      uevent
>=20
> This is two times the same enclosure.

That's unusual .. to have two devices managing the same enclosure, but
if you only have 16 slots and not 32, I suppose it must be so.  I'd als=
o
guess the enclosure information doesn't provide slot names, so ses
automatically provided the numbering.

I have a 12 slot vitesse enclosure with two enclosure devices but they
each manage half the slots:

/sys/class/enclosure/0:0:1:0/:
components  power/     SLOT 007/  SLOT 009/  SLOT 011/   uevent
device@     SLOT 006/  SLOT 008/  SLOT 010/  subsystem@

/sys/class/enclosure/0:0:3:0/:
components  power/     SLOT 001/  SLOT 003/  SLOT 005/   uevent
device@     SLOT 000/  SLOT 002/  SLOT 004/  subsystem@

> > each of the subdirectories has a slot label (name taken from SES) t=
o
> > locate the enclosure, just echo 1 to the locate file and it will fl=
ash
> > the lights.  If it has a disk, there should be a device link in the=
 slot
> > directory (might not be, this depends on ses working correctly and =
VPD
> > inquiries identifying the right disk).
>=20
> monosan:/sys/class/enclosure/6:0:16:0/0 # ls -l
> insgesamt 0
> -rw-r--r-- 1 root root 4096 21. Apr 10:48 active
> -rw-r--r-- 1 root root 4096 21. Apr 10:48 fault
> -rw-r--r-- 1 root root 4096 21. Apr 10:48 locate
> -rw-r--r-- 1 root root 4096 21. Apr 10:48 status
> lrwxrwxrwx 1 root root    0 21. Apr 10:46 subsystem -> ../../../enclo=
sure_component
> -r--r--r-- 1 root root 4096 21. Apr 10:48 type
> --w------- 1 root root 4096 21. Apr 10:48 uevent
>=20
> There seems to be no device link if I understood you correctly.
> Is the subdirctory numbering somehow in relation to the SCSI ID?

No ... the subdirectory numbering is taken from the enclosure
information (if available)... it should be the slot numbers of the
enclosure.  If the slot is populated a device link should appear (this
is the tricky bit because the ses driver uses VPD inquiries to match up
the reported disk, assuming the enclosure reports it, to the actual one=
=2E
These work for SAS disks, but not for SATA ones).  Empty slots have no
device link (but you can still flash the lights using the files).

If you look at my enclosure, I only have two devices:

sparkweed:~# ls -l /sys/class/enclosure/*/*/device
lrwxrwxrwx 1 root root 0 2008-04-21 10:16 /sys/class/enclosure/0:0:1:0/=
SLOT 006/device -> ../../../../../../../port-0:0:0/end_device-0:0:0/tar=
get0:0:0/0:0:0:0
lrwxrwxrwx 1 root root 0 2008-04-21 10:16 /sys/class/enclosure/0:0:3:0/=
SLOT 001/device -> ../../../../../../../port-0:1:11/end_device-0:1:11/t=
arget0:0:2/0:0:2:0

James


James


> Thanks
> Lars
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
