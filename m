From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Why using configfs as the only interface is wrong for a
	storage target
Date: Mon, 07 Feb 2011 16:03:53 -0800
Message-ID: <1297123433.13752.362.camel@haakon2.linux-iscsi.org>
References: <AANLkTi=b0mcWp3ergh=GvUF2CvgXUDv3Rq1fHY=xKf9L@mail.gmail.com>
	 <20110207115347.GA7503@noexit> <1297089709.3012.19.camel@mulgrave.site>
	 <20110207160223.598210a2@harpe.intellique.com>
	 <1297109379.13752.250.camel@haakon2.linux-iscsi.org>
	 <20110207223845.71d2ab18@galadriel2.home>  <20110207224407.GC13518@noexit>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49701 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab1BHAD7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 19:03:59 -0500
In-Reply-To: <20110207224407.GC13518@noexit>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel Becker <jlbec@evilplan.org>
Cc: Emmanuel Florac <eflorac@intellique.com>, James Bottomley <James.Bottomley@suse.de>, Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>

On Mon, 2011-02-07 at 14:44 -0800, Joel Becker wrote:
> On Mon, Feb 07, 2011 at 10:38:45PM +0100, Emmanuel Florac wrote:
> > Le Mon, 07 Feb 2011 12:09:39 -0800 vous =C3=A9criviez:
> > The configuration files are actually programs, because even a simpl=
e
> > bash script is a program. I'm getting uneasy. These are not your
> > regular, non executable config files.
>=20
> 	This is independent of configfs vs other methods, and probably
> wants to be visited on its own.  More on this below.
>=20
> > > Having python code walk this layout and output the exact
> > > running configuration is how we save -> reinstate the running con=
fig,
> > > and it's really quite trivial with configfs.
> >=20
> > Please understand that at this point, anybody lacking a deep
> > understanding of kernel innards like me or 99.9% of linux system
> > admins or users, really don't give a fsck. I actually understand th=
e
>=20
> 	Nor should they.  That's kind of the point.  Again, see below.
>=20
> > Aaaaargh. Are you trying to convince me that you've done the window=
s
> > registry right this time? I don't want no stinking object oriented
> > library to manage my scsi targets.
> >=20
> > But finally, OK, I see the point for infrastructure. Now tell me, c=
ould
> > we avoid more virtual fs creep in the future ?=20
>=20
> 	Configfs is not a registry.
> 	Let me try to restate the issue.  The kernel doesn't persist
> state; whether DM maps, iSCSI target configs, or network interface
> addresses, some userspace entity has to tell the kernel about it on
> each boot.  We have multiple methods of doing this: proc/sys, sysfs,
> configfs, ioctl(2)s, etc.  So if you want to have your system adverti=
se
> sdb1 as an iSCSI LUN, you have to tell the target code.
> 	configfs was designed for exactly this case.  You want to create
> a kernel object (eg a "target" or a "LUN mapping"), and userspace dri=
ves
> this.  You might have multiple objects that need to be connected
> ("targets" and "LUNs advertised by this target"), and configfs handle=
s
> this too.
> 	You could do this with an ioctl(2), but you'd still have to have
> some persistent configuration in userspace so that the ioctl(2) gets
> called on each reboot to rebuild the mapping.  This is exactly analog=
ous
> to "mdadm --assemble" running on each boot.  mdadm(8) uses an ioctl(2=
),
> but it still needs /etc/mdadm.conf to know what to send down the
> ioctl(2).  Similarly, /etc/sysctl.conf tells sysctl(8) what to store =
on
> boot.
> 	So any of these services have to provide some userspace program
> that reads a configuration and knows how to send it down to the kerne=
l.
> They should be isolating the "how I send it down to the kernel" from
> your average admin.  Whether that config is a simple text file or a
> complex scripty mess is independent of this.  One would hope that, li=
ke
> mdadm(8), you have a simple human-readable text file that a program
> turns into the proper kernel invocation.

Completely agreed.  I prefer having a /bin/sh walkable layout of target
kernel data structures using struct config_group references, and using
easily maintainable intrepreted code running in userspace to handle
changes to that layout.

IOCTLs are fine for nuts-and-bolts pieces like mdadm, but I think tryin=
g
to provide an easily expandable control interface across multiple linux
kernel modules w/ internal data structure reference counting is a prett=
y
painful exercise for actually adding new fabric module kernel and new
<cough> and flexiable userspace code.

> 	It's great that Nick has fancy tools to fly around the target
> configfs space, but that's all fluff for people writing and debugging
> the tools.  Same with mdadm(8) and the MD ioctl(2)s.  You don't want =
to
> know the details of the ioctl(2) call; you just want mdadm(8) to work=
=2E
>=20

So wrt to the last point, I would like to clarify one item wrt to the
RTS userspace tools with LIO target mode v4 kernel code.

We (RisingTideSystems & Linux-iSCSI.org) will be publically releasing
our single-node high level shell+CLI (rtsadmin) and object oriented
python library (rtslib) to drive real-time management of 'for-38'
mainline /sys/kernel/config/target/ configfs code.  These are the
userspace packages that RTS/LIO customers+partners+friends have been
using in production with iscsi_target_mod and tcm_loop in v3.x
lio-core-backports.git before the mainline adoption of TCM v4 code.  Th=
e
public documentation for both of these is available here:

http://www.risingtidesystems.com/doc/rtsadmin/html/rtsadmin_reference.h=
tml
http://www.risingtidesystems.com/doc/rtslib/html/

Our code will also be including generic support for all v4 compatiable
-> target_core_fabric_configfs.c modules, and will be released in git
trees as the 'for-39' merge window opens later this spring.=20

We are currently offering rtsadmin-frozen packages on v4.0-rc and v3.x
LIO kernel code on a case-by-case basis to a number of folks, and we
would be happy to provide new forward looking TCM fabric module
developers with this high level shell that can be used directly during
their own fabric port I/O bringup efforts from generic fabric level
struct config_group /sys/kernel/config/target/core/$HBA/$DEV/ backends
on for-38 code.

Best Regards,

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
