From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCHv2] qla2xxx: Correct compilation issues when
	CONFIG_MOUDLES=n.
Date: Tue, 15 Sep 2009 19:22:03 +0200
Message-ID: <ac3eb2510909151022s5a0704c2xd4be73d5c63ab0f1@mail.gmail.com>
References: <1252708951.13282.151.camel@mulgrave.site> <20090912001752.GC12098@plap4-2.local>
	<20090912003808.GD12098@plap4-2.local> <20090912005446.GA11691@kroah.com>
	<20090912025623.GA14824@plap4-2.local> <20090912043333.GA12349@kroah.com>
	<1252765807.4238.74.camel@mulgrave.site> <20090915153312.GB22774@kroah.com>
	<1253029631.29947.156.camel@mulgrave.site> <20090915165708.GA18817@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090915165708.GA18817@kroah.com>
Sender: linux-next-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 15, 2009 at 18:57, Greg KH <greg@kroah.com> wrote:
> On Tue, Sep 15, 2009 at 10:47:11AM -0500, James Bottomley wrote:
>> On Tue, 2009-09-15 at 08:33 -0700, Greg KH wrote:
>> > On Sat, Sep 12, 2009 at 09:30:07AM -0500, James Bottomley wrote:
>> > > On Fri, 2009-09-11 at 21:33 -0700, Greg KH wrote:
>> > > > On Fri, Sep 11, 2009 at 07:56:23PM -0700, Andrew Vasquez wrote=
:
>> > > > > On Fri, 11 Sep 2009, Greg KH wrote:
>> > > > >
>> > > > > > On Fri, Sep 11, 2009 at 05:38:08PM -0700, Andrew Vasquez w=
rote:
>> > > > > > > Randy Dunlap noted:
>> > > > > > >
>> > > > > > > =C2=A0 when CONFIG_MODULES=3Dn:
>> > > > > > >
>> > > > > > > =C2=A0 drivers/scsi/qla2xxx/qla_os.c:2685: error: derefe=
rencing pointer to incomplete type
>> > > > > > >
>> > > > > > > =C2=A0 in
>> > > > > > >
>> > > > > > > =C2=A0 kobject_uevent_env(&(&vha->hw->pdev->driver->driv=
er)->owner->mkobj.kobj,
>> > > > > > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 KOBJ_CHANGE, envp);
>> > > > > > >
>> > > > > > > Trigger kobject event on the 'struct device' hanging off=
 the pci_dev.
>> > > > > >
>> > > > > > Um, why? =C2=A0What are you trying to do here? =C2=A0kobje=
ct change should not be
>> > > > > > for a device, or a "normal" kobject.
>> > > > > >
>> > > > > > What do you expect userspace to do with this? =C2=A0Where =
have you documented
>> > > > > > it?
>> > > > >
>> > > > > The purpose was described here:
>> > > > >
>> > > > > =C2=A0 =C2=A0 =C2=A0 http://article.gmane.org/gmane.linux.sc=
si/54155
>> > > > >
>> > > > > Basically we'd like to instruct user-space to retrieve a blo=
b of data
>> > > > > automatically.
>> > > >
>> > > > Hm, like a firmware object perhaps?
>> > > >
>> > > > > Original implementation used the kboject hanging off
>> > > > > the module which does not exist when CONFIG_MODULES=3Dn. =C2=
=A0It was
>> > > > > suggested that perhaps an alternative would be to use 'struc=
t device'
>> > > > > kobj. =C2=A0Any tips on how to trigger such a driver-specifi=
c event,
>> > > > > perhaps a dedicated kobject exported by the driver itself???
>> > > >
>> > > > Why not use the firmware interface for it, that is what it is =
designed
>> > > > for, and you will not have to craft any new udev rules.
>> > >
>> > > The data is going the wrong way to use the current firmware inte=
rface,
>> > > which is designed to load data from userspace into the kernel. =C2=
=A0For this
>> > > interface, we want the data to go the other way (i.e. the kernel=
 has a
>> > > blob of dump data it would like userspace to save if it can).
>> >
>> > Ick.
>>
>> It's a natural debugging event ... the user can simply program the
>> system to discard the dump.
>>
>> > > I'd be amenable to updating the firmware interface to do this, b=
ut it
>> > > looks like adding a completely new codepath, which it's not clea=
r even
>> > > belongs there.
>> >
>> > Well, I don't think it deserves a kobject change event, as that me=
ans
>> > something a bit different to userspace today, right?
>>
>> Well, the documentation (in include/linux/kobject.h) does say that
>> KOBJ_CHANGED is the dumping ground for events that don't match anyth=
ing
>> else, which this one seems to qualify as. =C2=A0What else do you sug=
gest?
>
> Ok, I can't think of anything else at the moment, sorry.

Wouldn't kernel/kmod.c :: call_usermodehelper_pipe() somehow fit for
that interface?

Kay
