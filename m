From: "Bodle, Donald E" <donald_bodle@reyrey.com>
Subject: RE: setting driver default to variable block size
Date: Thu, 12 Sep 2002 15:18:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <EFD504BF6A4BD411BF2E009027653A810772072C@oh15ex09.reyrey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "Bodle, Donald E" <donald_bodle@reyrey.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

I read the 7/1/2000 email from Kai that mentions minor number bits to c=
hange
driver characteristics.  However, I can't find anything that documents =
what
minor numbers mean what.  0 is default rewind, 128 is default no rewind=
=2E
I've already modified st_options.h to make default behavior SYSV.  But
that's all I find.  Still searching for a way to make a device or the d=
river
itself use variable block size without resorting to mt setblk 0.
Thanks

Donald E. Bodle, Jr.
Systems Software Engineer
Platform Development
The Reynolds and Reynolds Co.
(937) 485-1954
=20

-----Original Message-----
=46rom: Bodle, Donald E=20
Sent: Thursday, September 12, 2002 11:43 AM
To: 'linux-scsi@vger.kernel.org'
Subject: setting driver default to variable block size

We have a lot of systems with tapes written on HP tape drives, that can=
't by
default without intervention be read on the DDS 4 drive from IBM for ou=
r
x345.=A0 Here's the quote from IBM:
=A0
"Generally speaking, the issue with reading HP tapes is that HP has
historically defaulted to variable block mode in their DDS products whi=
le
Sony and Seagate DDS products have defaulted to fixed block mode. This =
may
be the cause of the error being reported.
=A0
If you read the man pages for the mt command under Linux you will see a
great many options. Among the options are how to set the block size. I
believe that in particular you can use the setblk option of the mt comm=
and.
This should enable you to set the HP drive to fixed block mode or the
Seagate drive to variable block mode and you can interchange from there=
=2E
=A0
=A0
Richard Quinlan
Product Engineer - Tape drives, Autoloaders, and Libraries Server Produ=
ct
Engineering IBM Corporation
"
=A0
=A0
We want to make the st driver set the default block size to 0 (variable=
) all
the time.=A0 We know about mt -f /dev/st0 setblk 0; and we have the pro=
gram by
David Pierce called setvarblock (as well as query).=A0 But what we need=
 is for
the default to be variable, not fixed at 512 which seems to be the case=
 on
the tape drive we are using.=A0 Is it possible to force that in the dri=
ver?=A0
I'm slowly improving my C skills.=A0 I attempted to change=20
=A0
/* Internal ioctl to set both density (uppermost 8 bits) and blocksize
(lower
=A0=A0 24 bits) */
#define SET_DENS_AND_BLK 0x10001
=A0
to=20
=A0
/* Internal ioctl to set both density (uppermost 8 bits) and blocksize
(lower
=A0=A0 24 bits) */
#define SET_DENS_AND_BLK 0x10000
=A0
but that didn't appear to help.
=A0
It appears that even if the default is set to 0, a tape insertion sets =
the
block size to 512, even though that's wrong.=A0 i.e.=A0 Boot from power=
 up, no
tape in drive.=A0 Run query, block size is zero.=A0 Insert tape, run qu=
ery,
block size is 512.=A0 Try tar tvf /dev/st0, get wrong block size messag=
e.=A0 Run
either setvarblock or mt -f /dev/st0 setblk 0.=A0 Run query, block size=
 is now
0.=A0 tar tvf suceeds.
=A0
Can anyone suggest a solution?
=A0
Donald E. Bodle, Jr.
Systems Software Engineer
Platform Development
The Reynolds and Reynolds Co.
(937) 485-1954


Donald E. Bodle, Jr.
Systems Software Engineer
Platform Development
The Reynolds and Reynolds Co.
(937) 485-1954
=20

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
