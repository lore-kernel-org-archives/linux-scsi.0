From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Help decoding: Info fld=0x25e6e3, Current sd08:b1: sense key
 Recovered Error
Date: Wed, 19 Jan 2005 11:22:35 +1000
Message-ID: <41EDB65B.5030007@torque.net>
References: <200501182334.j0INYD904933@www.watkins-home.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:64712 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261529AbVASBWc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 20:22:32 -0500
In-Reply-To: <200501182334.j0INYD904933@www.watkins-home.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Matthias Andree' <matthias.andree@gmx.de>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

Guy wrote:
> Good info.  Thanks!
> I could not find the answer with google.  Too much noise!
>=20
> Is 0x25e6e3 the block number?

Yes (logical block number expressed in hex)

> If it is, is it relative to the beginning of sdl1, or sdl?

/dev/sdl

> If not, what is it?

Looking at the settings of the "read write error recovery"
mode page on /dev/sdl may be instructive. ['sginfo -e /dev/sdl'
from sg3_utils.] The PER bit seems to be set (otherwise a
recovered error should not have been reported) but the ARRE
and AWRE bits are probably clear. Those bits control the
automatic reaasignment of a block when a recovered error
occurs as reported in your case.

Assuming the problem occurred on a read and that the ARRE
it is clear then you may want to reassign that block. To
check its current state you might try:
  sg_dd if=3D/dev/sdl skip=3D0x25e6e3 of=3D. bs=3D512 count=3D1 blk_sgi=
o=3D1

If that recovered error persists (or worse) rather than formatting
the disk, reassigning that block is more surgical. sg_reassign has
be added to sg3_utils recently (v1.12 beta at www.torque.net/sg)
to do this. In your case:
  sg_reassign -a 0x25e6e3 /dev/sdl

If successful the replaced sector should go into the
"grown" defect list ('sginfo -G /dev/sdl'). This utility
may be worth trying before and after the sg_reassign.

Another way to accomplish the same thing is to set
the ARRE bit (and the AWRE while you are at it) and do
another read of that block. The reported additonal
sense message should change to something like "Recovered
data: data auto-reallocated". Reading the whole disk
might be wise (to see if that lba was a lone case).

More generally this is not a good sign concerning the
health of that disk. No data has been lost _yet_ but it
had to work hard to recovery it. Any entries in the "grown"
defect list is not a good sign. Also with smartmontools
you might like to try 'smartctl -a /dev/sdl' and examine
the "Error counter log" and compare that does some of your
other drives that are not reporting problems. A long
self test may also be appropriate: 'smartctl -t long /dev/sdl'.

Doug Gilbert

> -----Original Message-----
> From: Matthias Andree [mailto:matthias.andree@gmx.de]=20
> Sent: Tuesday, January 18, 2005 4:09 PM
> To: Guy
> Cc: unlisted-recipients:; no To-header on input; 'SCSI Mailing List'
> Subject: Re: Help decoding: Info fld=3D0x25e6e3, Current sd08:b1: sen=
se key
> Recovered Error
>=20
> "Guy" <bugzilla@watkins-home.com> writes:
>=20
>=20
>>Can anyone help decode this info?
>>
>>What is 0x25e6e3?
>>What disk is sd08:b1?
>=20
>=20
> /dev/sdl1 (ess dee ell one) - that's sedecimal notation for a device
> with major 8 minor 0xb1 =3D 177;
>=20
> $ ls -l /dev/sd* |grep " 8, 177"
> brw-rw----  1 root disk   8, 177 2004-10-02 10:38 /dev/sdl1
>=20
>=20
>>kernel: Info fld=3D0x25e6e3, Current sd08:b1: sense key Recovered Err=
or
>>kernel: Additional sense indicates Recovered data with error corr. &
>=20
> retries
>=20
>>applied
>=20
>=20
> Time to check and possibly replace the drive, or at least refresh the
> block.
>=20
> smartmontools (on sourceforge) and perhaps badblocks or J=F6rg Schill=
ings
> sformat (careful!) may help you with that.
>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
