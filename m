From: Joel Becker <jlbec@evilplan.org>
Subject: Re: Why using configfs as the only interface is wrong for a
 storage target
Date: Mon, 7 Feb 2011 14:44:09 -0800
Message-ID: <20110207224407.GC13518@noexit>
References: <AANLkTi=b0mcWp3ergh=GvUF2CvgXUDv3Rq1fHY=xKf9L@mail.gmail.com>
 <20110207115347.GA7503@noexit>
 <1297089709.3012.19.camel@mulgrave.site>
 <20110207160223.598210a2@harpe.intellique.com>
 <1297109379.13752.250.camel@haakon2.linux-iscsi.org>
 <20110207223845.71d2ab18@galadriel2.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:40172 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab1BGWoY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 17:44:24 -0500
Content-Disposition: inline
In-Reply-To: <20110207223845.71d2ab18@galadriel2.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@suse.de>, Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>

On Mon, Feb 07, 2011 at 10:38:45PM +0100, Emmanuel Florac wrote:
> Le Mon, 07 Feb 2011 12:09:39 -0800 vous =E9criviez:
> The configuration files are actually programs, because even a simple
> bash script is a program. I'm getting uneasy. These are not your
> regular, non executable config files.

	This is independent of configfs vs other methods, and probably
wants to be visited on its own.  More on this below.

> > Having python code walk this layout and output the exact
> > running configuration is how we save -> reinstate the running confi=
g,
> > and it's really quite trivial with configfs.
>=20
> Please understand that at this point, anybody lacking a deep
> understanding of kernel innards like me or 99.9% of linux system
> admins or users, really don't give a fsck. I actually understand the

	Nor should they.  That's kind of the point.  Again, see below.

> Aaaaargh. Are you trying to convince me that you've done the windows
> registry right this time? I don't want no stinking object oriented
> library to manage my scsi targets.
>=20
> But finally, OK, I see the point for infrastructure. Now tell me, cou=
ld
> we avoid more virtual fs creep in the future ?=20

	Configfs is not a registry.
	Let me try to restate the issue.  The kernel doesn't persist
state; whether DM maps, iSCSI target configs, or network interface
addresses, some userspace entity has to tell the kernel about it on
each boot.  We have multiple methods of doing this: proc/sys, sysfs,
configfs, ioctl(2)s, etc.  So if you want to have your system advertise
sdb1 as an iSCSI LUN, you have to tell the target code.
	configfs was designed for exactly this case.  You want to create
a kernel object (eg a "target" or a "LUN mapping"), and userspace drive=
s
this.  You might have multiple objects that need to be connected
("targets" and "LUNs advertised by this target"), and configfs handles
this too.
	You could do this with an ioctl(2), but you'd still have to have
some persistent configuration in userspace so that the ioctl(2) gets
called on each reboot to rebuild the mapping.  This is exactly analogou=
s
to "mdadm --assemble" running on each boot.  mdadm(8) uses an ioctl(2),
but it still needs /etc/mdadm.conf to know what to send down the
ioctl(2).  Similarly, /etc/sysctl.conf tells sysctl(8) what to store on
boot.
	So any of these services have to provide some userspace program
that reads a configuration and knows how to send it down to the kernel.
They should be isolating the "how I send it down to the kernel" from
your average admin.  Whether that config is a simple text file or a
complex scripty mess is independent of this.  One would hope that, like
mdadm(8), you have a simple human-readable text file that a program
turns into the proper kernel invocation.
	It's great that Nick has fancy tools to fly around the target
configfs space, but that's all fluff for people writing and debugging
the tools.  Same with mdadm(8) and the MD ioctl(2)s.  You don't want to
know the details of the ioctl(2) call; you just want mdadm(8) to work.

Joel

--=20

"Here's something to think about:  How come you never see a headline
 like ``Psychic Wins Lottery''?"
	- Jay Leno

			http://www.jlbec.org/
			jlbec@evilplan.org
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
