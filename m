From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: BUG in kernel: Wrong Handling of USB =?UTF-8?Q?HDD=E2=80=99s?=
 in scsiglue(slave_configure) and scsi/sd(sd_read_cache_type)
Date: Fri, 30 Sep 2011 13:11:07 -0500
Message-ID: <1317406267.2993.33.camel@dabdike.hansenpartnership.com>
References: <CADDb1s2Qhy1dNmjk+DhU=rf46A4X6kPdQ2rdpwK9zinY4Yv1mw@mail.gmail.com>
	 <CADDb1s3KjMugBGwLmjoPv93hJVBCjkD81o8F0CZxJXXt+-Fk2A@mail.gmail.com>
	 <1317245383.22022.23.camel@dabdike.hansenpartnership.com>
	 <CADDb1s0naC9bKYDuvxMK1R+ey9KB+Sh8e-9KNJXH-EuTNueueQ@mail.gmail.com>
	 <1317320825.3190.70.camel@dabdike.hansenpartnership.com>
	 <1317321077.3190.71.camel@dabdike.hansenpartnership.com>
	 <CADDb1s3CSvmqNGA48sHyOJ-pGpB1ix3WEVd0KV4b+s5yE3abLw@mail.gmail.com>
	 <1317385117.2993.7.camel@dabdike.hansenpartnership.com>
	 <CADDb1s0_6fTa-e6WubVGfcyn2fe3ohss=FvMh9r6q76uUOsXMw@mail.gmail.com>
	 <CADDb1s0-7c0VSAvJ+t11ehw8gKsOg8aOssYS6ZwXssiGWRE+_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADDb1s0-7c0VSAvJ+t11ehw8gKsOg8aOssYS6ZwXssiGWRE+_Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-09-30 at 23:26 +0530, Amit Sahrawat wrote:
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
> >> wrongly.  Since USB devices only preset SCSI interfaces, that's wh=
at we
> >> have to believe.
> >>
> >> hdparm when used correctly sends an ATA inquiry command wrapped in=
 an
> >> ATA_12 or ATA_16 SCSI command.  A large number of legacy SATLs are=
 known
> >> to crash on these commands.
> >>
> >> Are you sure the ATA command is reporting correctly?  A write back=
 cache
> >> is a remarkably silly thing to enable for a USB device because the=
y're
> >> highly likely to be surprise ejected which powers the device down.
> >>
> > In addition to the problem reported - there is one more thing I hav=
e
> > noticed with USB HDD - they should be shown as 'removable' but the
> > removable is marked only for USB PEN Drives. This seems to be a bit=
 of
> > confusing, any mass storage media connected on USB port should be
> > recognized as removable.

I don't really think so.  Removable to sd means that the drive can be
removed from the housing, not that the connector cable is hot plug so
the whole disk can disappear.  I think your disk is the latter, and
therefore removable probably isn't what you want (otherwise the sd
driver will start probing for medium change and other things your devic=
e
won't understand).

> > So, for handling the issue, I would consider adding the handling in
> > slave_configure()(usb/storage/scsiglue) which marks the HDD/pen dri=
ves
> > as removable also signifying them to be USB based.
> > Then, as part of sd_revalidation =E2=80=93 how about adding the ATA=
_IDENTIFY
> > command part if the device is USB HDD? As far as the result of
> > ATA_IDENTIFY is concerned =E2=80=93 they return proper =E2=80=98256=
=E2=80=99 bytes - response
> > and the Words =E2=80=93 82, 85 used for feature supported and enabl=
ed/disabled
> > returns proper values for the USB HDD=E2=80=99s I have seen. In cas=
e of USB
> > pen drives =E2=80=93 they return failure =E2=80=93 I did not see an=
y crash =E2=80=93 maybe I
> > don=E2=80=99t have one of the legacy SATL based disk.
> > Since, I am new to this =E2=80=93 I will check more on this to get =
a viable
> > solution. Please add your opinion. Can you share the name of the
> > device which causes crash with these ATA commands, If I am able to =
get
> > one I can try on that also.

How?  There are many USB devices whose SATL crashes and burns on ATA_12
or ATA_16, so this would add fragility to the detection path. The
detection path has to be cast iron because it has to work on a vast
range of devices.  The only way this could really work is to add it in
the usb storage driver and then replace the bad mode pages.

James
