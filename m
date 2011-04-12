From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/2] SCSI: Add a SCSI option for persistent device
 names in Kernel.
Date: Tue, 12 Apr 2011 08:29:28 -0500
Message-ID: <1302614968.2604.2.camel@mulgrave.site>
References: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110405161400.GA885@kroah.com> <4D9F17DF.5030601@hitachi.com>
	 <4D9F1CD1.2020600@suse.de> <1302275652.4090.10.camel@mulgrave.site>
	 <4DA4526B.2030609@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <4DA4526B.2030609@hitachi.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: Hannes Reinecke <hare@suse.de>, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-hotplug@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, Jon Masters <jcm@redhat.com>, 2nddept-manager@sdl.hitachi.co.jp
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-04-12 at 22:23 +0900, Nao Nishijima wrote:
> (2011/04/09 0:14), James Bottomley wrote:
> > On Fri, 2011-04-08 at 07:33 -0700, Hannes Reinecke wrote:
> >>> The problem I would like to discuss here is that users can not id=
entify
> >>> a disk from kernel messages when they DIRECTLY refer to these mes=
sages.
> >>> For example, a device name is used instead of a symbolic link nam=
es in
> >>> bootup messages, I/O devices errors and /proc/partitions =E2=80=A6=
etc.
> >>>
> >>> In particular, users can not identify an appropriate device from =
a
> >>> device name in syslog since different device name may be assigned=
 to it
> >>> at each boot time.
> >>>
> >>> My idea is able to fix this issue with small changes in scsi subs=
ystem.
> >>> Also, it is implemented as an option. Therefore, it does not affe=
ct
> >>> users who do not select this option.
> >>>
> >> We have been discussing this problem several times in the past, an=
d
> >> indeed on these very mailing list.
> >>
> >> The conclusion we arrived at is that the kernel-provided device no=
de
> >> name is inherently unstable and impossible to fix within the exist=
ing
> >> 'sdX' naming scheme.
> >> So the choices have been to either move to a totally different nam=
ing
> >> scheme or keep the naming scheme and provide the required informat=
ion
> >> by other means.
> >> We have decided on the latter, and agreed on using udev to provide
> >> persistent device names.
> >> We are fully aware that any kernel related messages are subject to
> >> chance after reboot, but then most kernel related messages are
> >> (PID number, timestamps, login tty etc).
> >> And also we are aware that any kernel messages need to be matched
> >> against the current system layout to figure out any hardware-relat=
ed
> >> issue.
> >>
> >> But then basically all products requiring to filter out informatio=
n
> >> from kernel messages already do so I don't see a problem with that=
=2E
> >>
> >> Just adding an in-kernel identifier to the LUN will only be an
> >> incomplete solution, as other identifiers will still be volatile.
> >>
> >> So I would prefer by keeping the in-kernel information as small
> >> as possible to reduce memory consumption and rely on out-of-band
> >> programs to provide the required mapping.
> >=20
> > So, while I agree totally with the above: udev and userspace is the=
 way
> > to go, I'm not totally opposed to having a non-invasive mechanism f=
or
> > indicating a user's preferred name for a device.  I think there are=
 a
> > couple of ways to do this:
> >=20
> >      1. Entirely in userspace: just have udev consult a preferred n=
ame
> >         file and create say /dev/disk/by-preferred.  Then have all =
the
> >         tools that normally output device information do the same (=
i.e.
> >         since real name to preferred name is 1:1, they could all do=
 a
> >         reverse lookup).
> >      2. have a writeable sysfs preferred_name field, either in the
> >         generic device or just in SCSI.  The preferred name would b=
e
> >         used by outbound only (i.e. kernel dev_printk messages and
> >         possibly /proc/partitions).  All inbound uses of the device
> >         would come via the standard udev mechanisms
> >         (i.e. /dev/disk/by-preferred would be the usual symlink).  =
This
> >         means from the kernel point of view, no renaming has happen=
ed.
> >         We'd just try to print out the preferred name in certain
> >         circumstances, which should solve most of the described pro=
blem.
> >=20
> > James
> >=20
> >=20
> >=20
>=20
> I have a question. Why is in-kernel device name necessary? The kernel
> can identify a device by major/miner number and udev can create a
> device node of a prefer name.

Well, that's the inbound vs outbound name I referred to above.  If all
you care about is inbound, this is true.

> Currently, device names are only used to show to users. Therefore I
> think that in-kernel device name is unnecessary if we introduce your
> /dev/disk/by-prefferd idea.

So if you have no problem with the kernel still printing out sdX in log=
s
and it appearing in /proc/partitions, I'm happy with this.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-hotplug=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
