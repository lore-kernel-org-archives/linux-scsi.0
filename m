From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: =?windows-1252?Q?Re=3A_BUG_in_kernel=3A_Wrong_Handling_of_USB_HDD=92s_in_?=
	=?windows-1252?Q?scsiglue=28slave=5Fconfigure=29_and_scsi=2Fsd=28sd=5Fread=5Fcache=5Ftype=29?=
Date: Fri, 30 Sep 2011 23:26:41 +0530
Message-ID: <CADDb1s0-7c0VSAvJ+t11ehw8gKsOg8aOssYS6ZwXssiGWRE+_Q@mail.gmail.com>
References: <CADDb1s2Qhy1dNmjk+DhU=rf46A4X6kPdQ2rdpwK9zinY4Yv1mw@mail.gmail.com>
	<CADDb1s3KjMugBGwLmjoPv93hJVBCjkD81o8F0CZxJXXt+-Fk2A@mail.gmail.com>
	<1317245383.22022.23.camel@dabdike.hansenpartnership.com>
	<CADDb1s0naC9bKYDuvxMK1R+ey9KB+Sh8e-9KNJXH-EuTNueueQ@mail.gmail.com>
	<1317320825.3190.70.camel@dabdike.hansenpartnership.com>
	<1317321077.3190.71.camel@dabdike.hansenpartnership.com>
	<CADDb1s3CSvmqNGA48sHyOJ-pGpB1ix3WEVd0KV4b+s5yE3abLw@mail.gmail.com>
	<1317385117.2993.7.camel@dabdike.hansenpartnership.com>
	<CADDb1s0_6fTa-e6WubVGfcyn2fe3ohss=FvMh9r6q76uUOsXMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADDb1s0_6fTa-e6WubVGfcyn2fe3ohss=FvMh9r6q76uUOsXMw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-usb@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Adding linux-usb - to get more insight's into the problem.

On Fri, Sep 30, 2011 at 11:23 PM, Amit Sahrawat
<amit.sahrawat83@gmail.com> wrote:
> On Fri, Sep 30, 2011 at 5:48 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
>> On Fri, 2011-09-30 at 12:26 +0530, Amit Sahrawat wrote:
>>> Now, for the USB HDD which do have write cache - sginfo is showing
>>> them to Write Cache Enabled as false.
>>> Why do the result of hdparm identification and sginfo varies- (I kn=
ow
>>> they have different interface to work with and hdparm takes care of
>>> that by using SG_IO interface from it's code)? hdparm showed me
>>> correct results - that lead me to digging in the kernel code and
>>> checking the performance for USB HDD with Write cache enabled/disab=
led
>>> - which also showed that QUEUE ordering chosen for USB HDD is not
>>> correct.
>>
>> Well, what all this means is the SATL in the USB device is implement=
ed
>> wrongly. =A0Since USB devices only preset SCSI interfaces, that's wh=
at we
>> have to believe.
>>
>> hdparm when used correctly sends an ATA inquiry command wrapped in a=
n
>> ATA_12 or ATA_16 SCSI command. =A0A large number of legacy SATLs are=
 known
>> to crash on these commands.
>>
>> Are you sure the ATA command is reporting correctly? =A0A write back=
 cache
>> is a remarkably silly thing to enable for a USB device because they'=
re
>> highly likely to be surprise ejected which powers the device down.
>>
> In addition to the problem reported - there is one more thing I have
> noticed with USB HDD - they should be shown as 'removable' but the
> removable is marked only for USB PEN Drives. This seems to be a bit o=
f
> confusing, any mass storage media connected on USB port should be
> recognized as removable.
> So, for handling the issue, I would consider adding the handling in
> slave_configure()(usb/storage/scsiglue) which marks the HDD/pen drive=
s
> as removable also signifying them to be USB based.
> Then, as part of sd_revalidation =96 how about adding the ATA_IDENTIF=
Y
> command part if the device is USB HDD? As far as the result of
> ATA_IDENTIFY is concerned =96 they return proper =91256=92 bytes - re=
sponse
> and the Words =96 82, 85 used for feature supported and enabled/disab=
led
> returns proper values for the USB HDD=92s I have seen. In case of USB
> pen drives =96 they return failure =96 I did not see any crash =96 ma=
ybe I
> don=92t have one of the legacy SATL based disk.
> Since, I am new to this =96 I will check more on this to get a viable
> solution. Please add your opinion. Can you share the name of the
> device which causes crash with these ATA commands, If I am able to ge=
t
> one I can try on that also.
>
>>> I have a large number of USB HDD's - with different vendors, and fo=
r
>>> all of them - it is showing Write Cache Enabled as false.
>>> The code works only for the Pen Drives or the USB HDD which do not
>>> have internal cache.
>>>
>>> Also, for journalling filesystem being used on USB HDD - it does
>>> becomes a cause of concern.
>>>
>>> Please share your opinion, I guess we need a change for mode sensin=
g
>>> in the kernel code for USB HDD.
>>
>> Well that's a nastily complex problem. =A0It really needs to be
>> whitelisted in the USB stack, but if every drive is doing it, that's
>> quite a task.
>>
>> The question becomes how do we detect in a SCSI fashion that the dev=
ice
>> has a write back cache if none of the standard SCSI mechanisms repor=
ts
>> it?
> As far as detecting in SCSI fashion =96 I wonder using that I would h=
ave
> never reached the conclusion that it is the Write Cache of USB HDD
> which is causing problem instead I would have been focusing on
> particular file system (XFS in my case =96which in itself is complex)=
 =96
> there BARRIER support and also the Queue handling in the elevator wit=
h
> I/O scheduler.
> None of the sg utils is showing anything related with the Write Cache
> in USB HDD =96 which provide any hint that the Cache is enabled =96 t=
his
> is a bit surprising because most of the high end USB mass storages
> device in the market have Write Cache in them.
>
> Thanks & Regards,
> Amit Sahrawat
>>
>> James
>>
>>
>>
>
