From: Swen Schillig <swen@vnet.ibm.com>
Subject: Re: With kernel 2.6.19 no sg devices for devices that return PQ=1, PDT=0x1f
Date: Fri, 8 Aug 2008 08:52:53 +0200
Message-ID: <200808080852.53822.swen@vnet.ibm.com>
References: <48984A20.2050002@linux.vnet.ibm.com> <4899698C.4050308@torque.net> <1218041921.7493.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:48217 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbYHHGxh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2008 02:53:37 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate6.uk.ibm.com (8.13.8/8.13.8) with ESMTP id m786pl0H333616
	for <linux-scsi@vger.kernel.org>; Fri, 8 Aug 2008 06:51:48 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m786plVW4223082
	for <linux-scsi@vger.kernel.org>; Fri, 8 Aug 2008 07:51:47 +0100
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m786plKU003837
	for <linux-scsi@vger.kernel.org>; Fri, 8 Aug 2008 07:51:47 +0100
In-Reply-To: <1218041921.7493.22.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: dougg@torque.net, Martin Petermann <martin@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

On Wednesday 06 August 2008 18:58, James Bottomley wrote:
> On Wed, 2008-08-06 at 11:06 +0200, Douglas Gilbert wrote:
> > Swen Schillig wrote:
> > > On Tuesday 05 August 2008 18:51, James Bottomley wrote:
> > >> On Tue, 2008-08-05 at 14:40 +0200, Martin Petermann wrote:
> > >>> With kernel 2.6.19 a change was introduced that no sg device wa=
s=20
> > >>> generated if PQ=3D1, PDT=3D0x1f was returned from the particula=
r device:
> > >>>
> > >>> commit 84961f28e9d13a4b193d0c8545f3c060c1890ff3
> > >>> Author: dave wysochanski <davidw@netapp.com>
> > >>> Date:   Wed Aug 9 14:56:32 2006 -0400
> > >>>
> > >>>      [SCSI] Don't add scsi_device for devices that return PQ=3D=
1, PDT=3D0x1f
> > >>>
> > >>> Before it was possible on Linux 390 in user space to a e.g. LUN=
 0 to a=20
> > >>> port and to receive a generic device:
> > >>>
> > >>> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # ll
> > >>> total 0
> > >>> -r--r--r-- 1 root root 4096 Aug  4 12:07 access_denied
> > >>> -rw-r--r-- 1 root root 4096 Aug  4 12:07 failed
> > >>> -r--r--r-- 1 root root 4096 Aug  4 12:07 in_recovery
> > >>> -r--r--r-- 1 root root 4096 Aug  4 12:07 status
> > >>> --w------- 1 root root 4096 Aug  4 12:07 uevent
> > >>> --w------- 1 root root    0 Aug  4 13:46 unit_add
> > >>> --w------- 1 root root    0 Aug  5 14:24 unit_remove
> > >>> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # ech=
o 0 >=20
> > >>> unit_add
> > >>> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # ll
> > >>> total 0
> > >>> drwxr-xr-x 2 root root    0 Aug  5 14:25 0x0000000000000000
> > >>> -r--r--r-- 1 root root 4096 Aug  4 12:07 access_denied
> > >>> -rw-r--r-- 1 root root 4096 Aug  4 12:07 failed
> > >>> -r--r--r-- 1 root root 4096 Aug  4 12:07 in_recovery
> > >>> -r--r--r-- 1 root root 4096 Aug  4 12:07 status
> > >>> --w------- 1 root root 4096 Aug  4 12:07 uevent
> > >>> --w------- 1 root root    0 Aug  5 14:25 unit_add
> > >>> --w------- 1 root root    0 Aug  5 14:24 unit_remove
> > >>> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # lss=
csi -g
> > >>> [0:0:0:0]    no dev  IBM      2107900          2.27  -         =
/dev/sg0
> > >>>
> > >>> After this fix there is no /dev/sg0 device generated.
> > >>>
> > >>> We are utilizing the possibility to create such a device for th=
e=20
> > >>> sg_utils commands in the case no other LUN has been attached to=
 a port.
> > >>>
> > >>> I do not want to put this fix into question. I would like to kn=
ow if=20
> > >>> someone has an idea how to workaround this problem and to gener=
ate a=20
> > >>> generic device in user space using kernel 2.6.19 or a later ver=
sion.
> > >> First of all, why is the device returning PQ=3D1 PTD=3D0x1f? thi=
s should
> > >> mean its not connected and probably doesn't exist... ie inaccess=
ible
> > >> without some unspecified action being taken.  If you can use it,=
 it's
> > >> clearly not behaving like a PQ=3D1 LUN.  Perhaps the simplest th=
ing would
> > >> be for something in s390 to fix up the inquiry data ... or we co=
uld
> > >> allow you could have a script to force it to appear (as in if yo=
u send a
> > >> specific scan for this one LUN we could override the catch in th=
e code
> > >> that throws it out again).
> > >>
> > >> James
> > >>
> > >>
> > >> --
> > >> To unsubscribe from this list: send the line "unsubscribe linux-=
scsi" in
> > >> the body of a message to majordomo@vger.kernel.org
> > >> More majordomo info at  http://vger.kernel.org/majordomo-info.ht=
ml
> > >>
> > >=20
> > > James
> > >=20
> > > I think Martin is saying that this LUN is a non existent one whic=
h is just used for scanning
> > > all available (existing) LUNs on the remote storage port.
> > > That's why PQ=3D1 PTD=3D0x1f are returned and correct !
> > >=20
> > > So what's required here is the possibility to add a "dummy" LUN w=
hich can be used just for this purpose.
> > > Not sure whether this is covered by anything in the standard
> >=20
> > That sounds like a job for the REPORT LUNS well known logical
> > unit (WLUN or W-LUN). I implemented one in the scsi_debug driver.
> > See the description of the "no_lun_0" parameter in
> > http://sg.torque.net/sg/sdebug26.html
> >=20
> > You might try:
> >    echo "- - 49409" > /sys/class/scsi_host/host<n>/scan
> > where "host<n>" is the controller in question. Then
> > see if a WLUN has appeared as a sg device node.
>=20
> Actually, if this thing is WLUN or ZLUN ... that's something we shoul=
d
> support unconditionally without looking at the PQ bit ... is that how=
 it
> is supposed to show up on the Z?
>=20
> James
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
Yes, that's exactly how it should be !
That would mean in our case that LUN 0xc101 would get a generic device=20
which could be used for scanning.

so something like=20

Index: HEAD/drivers/scsi/scsi_scan.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- HEAD.orig/drivers/scsi/scsi_scan.c
+++ HEAD/drivers/scsi/scsi_scan.c
@@ -1080,7 +1080,7 @@ static int scsi_probe_and_add_lun(struct
=A0=A0=A0=A0=A0=A0=A0=A0 * PDT=3D1Fh none (no FDD connected to the requ=
ested logical unit)
=A0=A0=A0=A0=A0=A0=A0=A0 */
=A0=A0=A0=A0=A0=A0=A0=A0if (((result[0] >> 5) =3D=3D 1 || starget->pdt_=
1f_for_no_lun) &&
-=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 (result[0] & 0x1f) =3D=3D 0x1f) {
+=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 (result[0] & 0x1f) =3D=3D 0x1f && (lun &=
 0xc100) !=3D 0xc100)) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0SCSI_LOG_SCAN_BUS(3, pr=
intk(KERN_INFO
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"scsi scan: peripheral =
device type"
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0" of 31, no device adde=
d\n"));

could do the trick ( or maybe something fancier).

Cheers Swen
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
