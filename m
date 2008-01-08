From: David Zeuthen <david@fubar.dk>
Subject: Re: Buggy Firewire bridge 'Prolific PL3507'
Date: Tue, 08 Jan 2008 15:10:31 -0500
Message-ID: <1199823031.3264.16.camel@oneill.fubar.dk>
References: <47837E06.5080406@novell.com>
	 <20080108140151.GD16309@parisc-linux.org>
	 <4783B93B.70307@s5r6.in-berlin.de>
	 <1199815847.3534.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 128-177-28-166.ip.openhosting.com ([128.177.28.166]:46498 "EHLO
	zelenka.fubar.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYAHUlw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 15:41:52 -0500
In-Reply-To: <1199815847.3534.49.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Matthew Wilcox <matthew@wil.cx>, Hannes Reinecke <hare@novell.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


On Tue, 2008-01-08 at 12:10 -0600, James Bottomley wrote:
> On Tue, 2008-01-08 at 18:56 +0100, Stefan Richter wrote:
> > Matthew Wilcox wrote:
> > > On Tue, Jan 08, 2008 at 02:43:34PM +0100, Hannes Reinecke wrote:
> > >> I have here a buggy firewire bridge (Prolific PL3507) which requ=
ires
> > >> that each 'INQUIRY' command is followed by a 'READ CAPACITY' com=
mand.
> > >> Otherwise any read will return invalid data (the payload is prec=
eded
> > >> by 36 empty bytes).
> > >>=20
> > >> How to fix this? Sure one could add a hack to sbp2.c to always i=
ssue
> > >> a READ CAPACITY after INQUIRY, but this somehow feels wrong ...
> > >=20
> > > There's only one place in the scsi stack that issues INQUIRY --
> > > scsi_scan.c [1].  sd is going to issue READ CAPACITY before it is=
sues
> > > any READ commands, so I don't see where you're having this proble=
m.
> > > Is it with some program issuing INQUIRY through SG_IO or somethin=
g?
> >=20
> > It's hald or something like that.
>=20
> Not to hijack the thread, but this is getting to be a broken record. =
 I
> was dealing only a few days ago with a camera presenting as a mass
> storage device that was then crashing and going offline.  I looked at
> the dmesg trace which showed that the SCSI layer completes its probin=
g
> successfully, and said it was some other extraneous command issued fr=
om
> user level causing the crash.  Sure enough, stopping hald fixed the
> camera so it functioned as a mass storage device properly.  The bug
> report is here:
>=20
> https://bugs.launchpad.net/ubuntu/+source/hal/+bug/180472
>=20
> What is the point of having SCSI be so careful in its probing and set=
up
> so as not to annoy these devices, and then have hald or another stand=
ard
> component blithely go and wreck the device by issuing unwarranted SCS=
I
> commands?
>=20
> Can we please stop hald from issuing SCSI commands ... we should have
> the infrastructure in place now that renders this unnecessary ... unl=
ess
> there's still some information it needs that we're not providing?

Huh, AFAIK, we only send SCSI commands to optical drives [1] and not
anything else. For optical drives, we issue these commands to

 - figure out what discs the drive supports
   - the kernel knows this and used to export it in a flat file in /pro=
c
     that wasn't really helpful
 - get read/write speeds (depends on the media currently inserted IIRC)
 - figure out if a disc is appendable
 - figure out if a disc is rewritable
 - get the capacity of a disc

and perhaps others (don't have the code handy right here but can give
you a definite list).=20

(I admit this is a big mess and it would be ideal if the kernel can
export this information - some of it is somewhat expensive to figure ou=
t
so perhaps should only be invoked when reading a sysfs file? I don't
know).

So it seems like people are experiencing this problem on non-optical
drives, right?. So, my knee-jerk reaction would be to say that the
assumption that hald is to blame is wrong since I'm pretty sure we only
issue SCSI commands for optical drives.=20

Also, keep in mind that we do a lot of IO to probe for the file system
on the actual disc including trying to get e.g. the iso9660 file system
label of the latest session. Maybe this trivial IO is what is causing
the hiccups?

(Notably udev doesn't do this for optical discs [2] but it does it for
everything else (e.g. runs /lib/udev/vol_id - the exactly same code hal=
d
is using.).=20

Perhaps if you can point to what SCSI commands hald are sending it woul=
d
be easier to debug. Any other ideas?

Thanks,
David

[1] : the way we determine a drive is an optical drive on SCSI is by
checking if=20

 /sys/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/type

has the value 5.

[2] : =EF=BB=BFudev doesn't probe optical discs just yet because for so=
me reason
sessions/partitions isn't exported by the kernel for this kind of media
(annoying, but understandable).


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
