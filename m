From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: MPTSAS: ("activate status led" | "find disc") in external enclosure
Date: Wed, 23 Apr 2008 09:39:15 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229FFEEF4@NAMAIL2.ad.lsil.com>
References: <20080423101143.d1fa10d0.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:58853 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090AbYDWPj2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Apr 2008 11:39:28 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080423101143.d1fa10d0.taeuber@bbaw.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Lars_T=E4uber?= <taeuber@bbaw.de>
Cc: linux-scsi@vger.kernel.org

On  Wednesday, April 23, 2008 2:12 AM, Lars T=E4uber wrote:
> I hoped I had the newet version of the firmware on the HBA.
> monosan:~ # cat /sys/class/scsi_host/host6/version_fw=20
> 01.24.01.00

This is code was release back in December, so its fairly new.

> > I would like to point out there is a firmware request for=20
> sending SEP request, for instance setting LEDS.   Here is a=20
> copy of the structure.  We call this function to set LED when=20
> there is SMART errors (for non-raid devices).  For RAID, the=20
> firmware handles it.   Is this what your looking for?
>=20
> I'm not firm enough with scsi to understand all your words.=20
> But the problem I have is not that something doesn't work. It=20
> works with 2.6.25.
> I can get the LEDs to blink. I can choose which one should=20
> do. I simply don't know which one it should be.
>=20
> The problem is, I wanted to simultate a faulty drive without=20
> being one faulty.
> Therefore I choosed a (working) disk to be faulty by its=20
> mutlipath-name: dm-9
> Then I found out which disk it is in sd? notation. Then I=20
> read the serial number of this disk with the smartmontools.
> Now I want this LED of the bay containing the disk with this=20
> serial number to blink. But I can't find out which LED=20
> matches which serial number of the containing disk.
>=20

The current driver will set the faulty LED when there is sense ASC =3D =
0x5D, meaning smart error.   This will occurr from the device driver fo=
r devices not belonging to a RAID volume.  If its in a RAID volume, the=
 firmware will handle setting the LED.    You can verify this by adding=
 a printk inside the source code:  From function mptscsih_copy_sense_da=
ta(), scroll down to "Log Smart Data", add it here after the check on 0=
x5D.   Also mptscish_issue_sep_command() is called to send the SEP comm=
and to set the LED.   This is found in /usr/src/linux/drivers/message/f=
usion/mptscsih.c.

Also, you should be able to figure out which slot your device inside yo=
ur enclosure.   Each enclousre will have a unique enclosoure logical id=
, which is simailar to a sas address.  Each device that is in inside th=
e enclosure is assigned a slot id, which is the same as a bay indentifi=
er.   If you have a SAS device, it will have the sas_address on the sti=
cker.  Then with that sas_address, you can search inside /sys/class/sas=
_device, that will tell you which end device it is.  Within that, you w=
ill see the bay identifier, which is the slot id.  The slot id I guess =
is assigned from 0 to the largest number you have of slots in your encl=
osure, probally from left to right.  If you look inside the expanders, =
you will see the enslosure logical id.   If you have more than one expa=
nder in the enclosure, they all have the same enclosure logical id. =20

Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
