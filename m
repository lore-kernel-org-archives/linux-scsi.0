From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH] st: implement sysfs based tape statistics v2
Date: Mon, 9 Feb 2015 21:14:41 +0200
Message-ID: <5F694657-8ECC-45DE-93A0-E7D987128F6E@kolumbus.fi>
References: <DDB9C85B850785449757F9914A034FCB3BF288C6@G9W0766.americas.hpqcorp.net> <87r3u0mivl.fsf@hobgoblin.ariadne.com> <DDB9C85B850785449757F9914A034FCB3BF3F323@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs19.mail.saunalahti.fi ([62.142.117.200]:55945 "EHLO
	vs19.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111AbbBITOr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2015 14:14:47 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3BF3F323@G9W0766.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>
Cc: "Dale R. Worley" <worley@alum.mit.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On 9.2.2015, at 8.00, Seymour, Shane M <shane.seymour@hp.com> wrote:
>=20
> Kai - see last 3 paragraphs for question about if something is a bug =
or not.
>=20
> BTW I had a look - I couldn't quickly find out if there was a way to =
tell if the medium has changed in a tape drive (there could be somethin=
g device specific). At the device level there's a record of I/O errors:
>=20
> [root@tapedrive device]# pwd
> /sys/class/scsi_tape/st0/device
> [root@tapedrive device]# cat ioerr_cnt
> 0x5
> =20
> That doesn't distinguish between read or write or any other kind of e=
rror though - it doesn't even really have to mean an error since readin=
g with a block size too small also increments the error count:

The counts in the device directory are not specific to tapes. From linu=
x/scsi/scsi_lib.c one can see that ierr_cnt is incremented every time t=
he scsi call returns any kind of error, including when the tape drive w=
ants to return some information with sense data.

> [root@tapedrive tape-stats]# ./tape_exercise write /dev/st0 /dev/uran=
dom 1000000
> About to write from /dev/urandom to /dev/st0, max size =3D 1000000, b=
lksize =3D 4096
> Write complete on /dev/st0 after 1003520 bytes
> ./tape_[root@tapedrive tape-stats]# ./tape_exercise read /dev/st0
> About to read from /dev/st0 blksize =3D 256
> Failed to read from /dev/st0 using current blksize, will try using a =
bigger blksize
> About to read from /dev/st0 blksize =3D 512
> Failed to read from /dev/st0 using current blksize, will try using a =
bigger blksize
> About to read from /dev/st0 blksize =3D 1024
> Failed to read from /dev/st0 using current blksize, will try using a =
bigger blksize
> About to read from /dev/st0 blksize =3D 2048
> Failed to read from /dev/st0 using current blksize, will try using a =
bigger blksize
> About to read from /dev/st0 blksize =3D 4096
> Reading complete for /dev/st0, 987136 bytes read
>=20
> [root@tapedrive tape-stats]# cd /sys/class/scsi_tape/st0/device
> [root@tapedrive device]# cat ioerr_cnt
> 0xa
>=20
> It would seem that ioerr_cnt is probably a count of SCSI check condit=
ions encountered?
>=20
> Unfortunately for the MTIOCGET ioctl the value of mt_resid is the par=
tition number of the tape not what I would have expected it to be - the=
 residual left after the last read or write that returned an error (and=
 0 if the last read/write didn't return an error).
>=20
> Kai - is that a bug? Shouldn't mt_resid be the residual from the last=
 failed read or write indicating how much data didn't make it to the de=
vice and 0 on a successful read or write? I've used mt_resid from MTIOC=
GET on HP-UX previously when issuing reads and repositioning and retryi=
ng tape reads when starting with too low a block size to try and automa=
tically determine the block size in use (it's never a good idea to unde=
r or overread tape blocks because it always results in check conditions=
 and in the st driver under reading the block size always creates messa=
ges in dmesg).
>=20
This is not a bug. man st documents that mt_resid does return the parti=
tion number. In the different unix systems the field did not consistent=
ly return the residual count. The Linux SCSI drivers did not at that ti=
me return the residual. These are reasons why the field is used for par=
tition number.

=46or writes in any real situation (drive in buffered mode) you don=E2=80=
=99t know when the write() returns whether the data can be written to t=
ape. All writes are on tape when write file marks returns successfully =
of the device is successfully closed. I am not sure that the amount of =
data successfully written is really useful. If I see a write error, I w=
ant to rewrite at least the latest file.

=46or reads, there are other ways to determine the block size. (Use a l=
arge enough byte count and see what you get.)

The st driver does not write to the log if the block is shorter than re=
quested. Short read is logged (together with the real block size). If y=
ou don=E2=80=99t want the overhead of returning the sense data for shor=
t reads, you can set the SILI flag.

> If you don't have time to look at it I may look at if it's possible t=
o provide the correct mt_resid for MTIOCGET - assuming that a long time=
 if misuse prevents us from correcting it. If there's no way to export =
a partition number for the devices that support it I can add a new sysf=
s file (call it partition) to export it that way and see if I can get t=
he correct value into mt_resid.
>=20
Changing the definition of a field should not be done. There is softwar=
e that is correctly using the field as it is documented.

Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
