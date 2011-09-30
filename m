From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: =?windows-1252?Q?Re=3A_BUG_in_kernel=3A_Wrong_Handling_of_USB_HDD=92s_in_?=
 =?windows-1252?Q?scsiglue=28slave=5Fconfigure=29_and_scsi=2Fsd=28sd=5Fread=5Fcache=5Ftype=29?=
Date: Fri, 30 Sep 2011 14:17:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1109301405370.2017-100000@iolanthe.rowland.org>
References: <CADDb1s0-7c0VSAvJ+t11ehw8gKsOg8aOssYS6ZwXssiGWRE+_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADDb1s0-7c0VSAvJ+t11ehw8gKsOg8aOssYS6ZwXssiGWRE+_Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 30 Sep 2011, Amit Sahrawat wrote:

> Adding linux-usb - to get more insight's into the problem.
>=20
> On Fri, Sep 30, 2011 at 11:23 PM, Amit Sahrawat
> <amit.sahrawat83@gmail.com> wrote:
> > On Fri, Sep 30, 2011 at 5:48 PM, James Bottomley
> > <James.Bottomley@hansenpartnership.com> wrote:
> >> On Fri, 2011-09-30 at 12:26 +0530, Amit Sahrawat wrote:
> >>> Now, for the USB HDD which do have write cache - sginfo is showin=
g
> >>> them to Write Cache Enabled as false.
> >>> Why do the result of hdparm identification and sginfo varies- (I =
know
> >>> they have different interface to work with and hdparm takes care =
of
> >>> that by using SG_IO interface from it's code)? hdparm showed me
> >>> correct results - that lead me to digging in the kernel code and
> >>> checking the performance for USB HDD with Write cache enabled/dis=
abled
> >>> - which also showed that QUEUE ordering chosen for USB HDD is not
> >>> correct.
> >>
> >> Well, what all this means is the SATL in the USB device is impleme=
nted
> >> wrongly. =A0Since USB devices only preset SCSI interfaces, that's =
what we
> >> have to believe.
> >>
> >> hdparm when used correctly sends an ATA inquiry command wrapped in=
 an
> >> ATA_12 or ATA_16 SCSI command. =A0A large number of legacy SATLs a=
re known
> >> to crash on these commands.
> >>
> >> Are you sure the ATA command is reporting correctly? =A0A write ba=
ck cache
> >> is a remarkably silly thing to enable for a USB device because the=
y're
> >> highly likely to be surprise ejected which powers the device down.

A usbmon trace would be very helpful for understanding this. =20
Instructions can be found in the kernel source file=20
Documentation/usb/usbmon.txt.  Post a trace showing what happens when=20
the drive is first plugged in.

> > In addition to the problem reported - there is one more thing I hav=
e
> > noticed with USB HDD - they should be shown as 'removable' but the
> > removable is marked only for USB PEN Drives. This seems to be a bit=
 of
> > confusing, any mass storage media connected on USB port should be
> > recognized as removable.

That is not true.  The word "removable" refers to the storage media. =20
Thus, a cdrom drive is removable because you can remove the disc from
the drive.  The same for a card reader, because you can remove the card
from the reader.  But a flash drive is not removable, because you can't
take the flash memory chip out of the device.

You are confusing "removable" with "hot-unpluggable".  All USB drives
are hot-unpluggable, but relatively few of them are removable.  Vendors=
=20
often get this wrong, however.

> > So, for handling the issue, I would consider adding the handling in
> > slave_configure()(usb/storage/scsiglue) which marks the HDD/pen dri=
ves
> > as removable also signifying them to be USB based.

This does not happen in usb-storage at all.  The SCSI core is
responsible for determining whether or not a device is removable, and
it does this by looking at second byte of the data returned by the SCSI
INQUIRY command.

> > Then, as part of sd_revalidation =96 how about adding the ATA_IDENT=
IFY
> > command part if the device is USB HDD? As far as the result of
> > ATA_IDENTIFY is concerned =96 they return proper =91256=92 bytes - =
response
> > and the Words =96 82, 85 used for feature supported and enabled/dis=
abled
> > returns proper values for the USB HDD=92s I have seen. In case of U=
SB
> > pen drives =96 they return failure =96 I did not see any crash =96 =
maybe I
> > don=92t have one of the legacy SATL based disk.
> > Since, I am new to this =96 I will check more on this to get a viab=
le
> > solution. Please add your opinion. Can you share the name of the
> > device which causes crash with these ATA commands, If I am able to =
get
> > one I can try on that also.
> >
> >>> I have a large number of USB HDD's - with different vendors, and =
for
> >>> all of them - it is showing Write Cache Enabled as false.

This indicates those drives do not implement the SCSI MODE SENSE=20
command correctly.  usbmon will help track down the problem.

> >>> The code works only for the Pen Drives or the USB HDD which do no=
t
> >>> have internal cache.
> >>>
> >>> Also, for journalling filesystem being used on USB HDD - it does
> >>> becomes a cause of concern.
> >>>
> >>> Please share your opinion, I guess we need a change for mode sens=
ing
> >>> in the kernel code for USB HDD.
> >>
> >> Well that's a nastily complex problem. =A0It really needs to be
> >> whitelisted in the USB stack, but if every drive is doing it, that=
's
> >> quite a task.
> >>
> >> The question becomes how do we detect in a SCSI fashion that the d=
evice
> >> has a write back cache if none of the standard SCSI mechanisms rep=
orts
> >> it?
> > As far as detecting in SCSI fashion =96 I wonder using that I would=
 have
> > never reached the conclusion that it is the Write Cache of USB HDD
> > which is causing problem instead I would have been focusing on
> > particular file system (XFS in my case =96which in itself is comple=
x) =96
> > there BARRIER support and also the Queue handling in the elevator w=
ith
> > I/O scheduler.
> > None of the sg utils is showing anything related with the Write Cac=
he
> > in USB HDD =96 which provide any hint that the Cache is enabled =96=
 this
> > is a bit surprising because most of the high end USB mass storages
> > device in the market have Write Cache in them.

Alan Stern
