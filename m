From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: =?windows-1252?Q?Re=3A_Re=3A_BUG_in_kernel=3A_Wrong_Handling_of_USB_HDD=92s?=
	=?windows-1252?Q?_in_scsiglue=28slave=5Fconfigure=29_and_scsi=2Fsd=28sd=5Fread=5Fcache=5Ftype?=
	=?windows-1252?Q?=29?=
Date: Sat, 1 Oct 2011 00:06:00 +0530
Message-ID: <CADDb1s22Mo5E-2fk=q7d2B45TnxhYO48RVVGfM0o7D8J5jepkQ@mail.gmail.com>
References: <CADDb1s0-7c0VSAvJ+t11ehw8gKsOg8aOssYS6ZwXssiGWRE+_Q@mail.gmail.com>
	<Pine.LNX.4.44L0.1109301405370.2017-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1109301405370.2017-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 30, 2011 at 11:47 PM, Alan Stern <stern@rowland.harvard.edu=
> wrote:
> On Fri, 30 Sep 2011, Amit Sahrawat wrote:
>
>> Adding linux-usb - to get more insight's into the problem.
>>
>> On Fri, Sep 30, 2011 at 11:23 PM, Amit Sahrawat
>> <amit.sahrawat83@gmail.com> wrote:
>> > On Fri, Sep 30, 2011 at 5:48 PM, James Bottomley
>> > <James.Bottomley@hansenpartnership.com> wrote:
>> >> On Fri, 2011-09-30 at 12:26 +0530, Amit Sahrawat wrote:
>> >>> Now, for the USB HDD which do have write cache - sginfo is showi=
ng
>> >>> them to Write Cache Enabled as false.
>> >>> Why do the result of hdparm identification and sginfo varies- (I=
 know
>> >>> they have different interface to work with and hdparm takes care=
 of
>> >>> that by using SG_IO interface from it's code)? hdparm showed me
>> >>> correct results - that lead me to digging in the kernel code and
>> >>> checking the performance for USB HDD with Write cache enabled/di=
sabled
>> >>> - which also showed that QUEUE ordering chosen for USB HDD is no=
t
>> >>> correct.
>> >>
>> >> Well, what all this means is the SATL in the USB device is implem=
ented
>> >> wrongly. =A0Since USB devices only preset SCSI interfaces, that's=
 what we
>> >> have to believe.
>> >>
>> >> hdparm when used correctly sends an ATA inquiry command wrapped i=
n an
>> >> ATA_12 or ATA_16 SCSI command. =A0A large number of legacy SATLs =
are known
>> >> to crash on these commands.
>> >>
>> >> Are you sure the ATA command is reporting correctly? =A0A write b=
ack cache
>> >> is a remarkably silly thing to enable for a USB device because th=
ey're
>> >> highly likely to be surprise ejected which powers the device down=
=2E
>
> A usbmon trace would be very helpful for understanding this.
> Instructions can be found in the kernel source file
> Documentation/usb/usbmon.txt. =A0Post a trace showing what happens wh=
en
> the drive is first plugged in.
Thanks Alan, I will go through the usbmon and check all the
information I can retrieve using that.
>
>> > In addition to the problem reported - there is one more thing I ha=
ve
>> > noticed with USB HDD - they should be shown as 'removable' but the
>> > removable is marked only for USB PEN Drives. This seems to be a bi=
t of
>> > confusing, any mass storage media connected on USB port should be
>> > recognized as removable.
>
> That is not true. =A0The word "removable" refers to the storage media=
=2E
> Thus, a cdrom drive is removable because you can remove the disc from
> the drive. =A0The same for a card reader, because you can remove the =
card
> from the reader. =A0But a flash drive is not removable, because you c=
an't
> take the flash memory chip out of the device.
>
> You are confusing "removable" with "hot-unpluggable". =A0All USB driv=
es
> are hot-unpluggable, but relatively few of them are removable. =A0Ven=
dors
> often get this wrong, however.
I got your point.
>
>> > So, for handling the issue, I would consider adding the handling i=
n
>> > slave_configure()(usb/storage/scsiglue) which marks the HDD/pen dr=
ives
>> > as removable also signifying them to be USB based.
>
> This does not happen in usb-storage at all. =A0The SCSI core is
> responsible for determining whether or not a device is removable, and
> it does this by looking at second byte of the data returned by the SC=
SI
> INQUIRY command.
>
>> > Then, as part of sd_revalidation =96 how about adding the ATA_IDEN=
TIFY
>> > command part if the device is USB HDD? As far as the result of
>> > ATA_IDENTIFY is concerned =96 they return proper =91256=92 bytes -=
 response
>> > and the Words =96 82, 85 used for feature supported and enabled/di=
sabled
>> > returns proper values for the USB HDD=92s I have seen. In case of =
USB
>> > pen drives =96 they return failure =96 I did not see any crash =96=
 maybe I
>> > don=92t have one of the legacy SATL based disk.
>> > Since, I am new to this =96 I will check more on this to get a via=
ble
>> > solution. Please add your opinion. Can you share the name of the
>> > device which causes crash with these ATA commands, If I am able to=
 get
>> > one I can try on that also.
>> >
>> >>> I have a large number of USB HDD's - with different vendors, and=
 for
>> >>> all of them - it is showing Write Cache Enabled as false.
>
> This indicates those drives do not implement the SCSI MODE SENSE
> command correctly. =A0usbmon will help track down the problem.
Yes, this seems to be the problem. But, almost all the manufacturer's
HDD is behaving the same way. They are showing the effectof switching
Write Cache on/off but not able to detect the same at plug-on.
Anyway, I will look at the 'usbmon' option you have provided.
>
>> >>> The code works only for the Pen Drives or the USB HDD which do n=
ot
>> >>> have internal cache.
>> >>>
>> >>> Also, for journalling filesystem being used on USB HDD - it does
>> >>> becomes a cause of concern.
>> >>>
>> >>> Please share your opinion, I guess we need a change for mode sen=
sing
>> >>> in the kernel code for USB HDD.
>> >>
>> >> Well that's a nastily complex problem. =A0It really needs to be
>> >> whitelisted in the USB stack, but if every drive is doing it, tha=
t's
>> >> quite a task.
>> >>
>> >> The question becomes how do we detect in a SCSI fashion that the =
device
>> >> has a write back cache if none of the standard SCSI mechanisms re=
ports
>> >> it?
>> > As far as detecting in SCSI fashion =96 I wonder using that I woul=
d have
>> > never reached the conclusion that it is the Write Cache of USB HDD
>> > which is causing problem instead I would have been focusing on
>> > particular file system (XFS in my case =96which in itself is compl=
ex) =96
>> > there BARRIER support and also the Queue handling in the elevator =
with
>> > I/O scheduler.
>> > None of the sg utils is showing anything related with the Write Ca=
che
>> > in USB HDD =96 which provide any hint that the Cache is enabled =96=
 this
>> > is a bit surprising because most of the high end USB mass storages
>> > device in the market have Write Cache in them.
>
> Alan Stern
>
>

Regards,
Amit Sahrawat
