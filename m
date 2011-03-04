From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ensure bsg device is available before announcing
 scsi device
Date: Fri, 04 Mar 2011 09:41:16 -0600
Message-ID: <1299253276.2461.33.camel@mulgrave.site>
References: <1299092565.26023.2.camel@satan>
	 <1299175019.9151.16.camel@mulgrave.site>  <1299249176.4710.15.camel@satan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48808 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228Ab1CDPlT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2011 10:41:19 -0500
In-Reply-To: <1299249176.4710.15.camel@satan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Zeuthen <davidz@redhat.com>
Cc: linux-scsi@vger.kernel.org, kay.sievers@vrfy.org

On Fri, 2011-03-04 at 09:32 -0500, David Zeuthen wrote:
> Hey,
>=20
> On Thu, 2011-03-03 at 11:56 -0600, James Bottomley wrote:
> > On Wed, 2011-03-02 at 14:02 -0500, David Zeuthen wrote:
> > > From: David Zeuthen <davidz@redhat.com>
> > >=20
> > > udev should be able to examine a scsi device (e.g. retrieving VPD=
 like
> > > the make/model and serial number) before announcing it to the res=
t of
> > > user space. Currently this is not possible because the scsi devic=
e has
> > > no device node of its own. Instead, user space will have to use e=
ither
> > > the bsg device or sg device but these are not available at uevent=
 add
> > > time since both are children of the scsi device
> >=20
> > This premise sounds a bit wrong.  SCSI devices go through several
> > distinct phases: create, add and then configure.  We send the initi=
al
> > probe before the add phase, but no user should really poke at the d=
evice
> > before the configure phase because that's where we set the
> > characteristics and other stuff.  The signal to udev that the confi=
gure
> > phase is over is when the ULD binding completes.  That's when the d=
evice
> > is running and it's safe to poke at.  It also means it's been ident=
ified
> > internally and you'll know whether it's a disk, a tape or whatever.
> >=20
> > So you should see two distinct events: an ADD for the sdev, meaning=
 we
> > think there's something there, but at this point there's no real de=
vice
> > for a user to see followed by the add for whatever the ULD major de=
vice
> > binding is ... at that point, we guarantee the device is up, its bs=
g
> > queue is registered, there's actually a user block or character dev=
ice
> > corresponding to it and we've finished configuring it.
> >=20
> > What exactly are you trying to do here?  It's really not that safe =
to be
> > running user level poking in parallel with the configuration scanni=
ng
> > we'll be doing as the ULD binds.
>=20
> So there are basically two things I'd like to achieve here
>=20
>  1. Have bsg-symlinks for SCSI devices like this
>=20
>   /dev/bsg/by-id/scsi-0x05-SEAGATE-ST3300657SS-3SJ1S7K600009051M0CE
>   /dev/bsg/by-id/scsi-0x0d-PROMISE-2U-SAS-12-D2-BP-35000155350e0133e
>=20
>   (e.g. scsi-<type>-<vendor>-<model>-<t83-serial>)
>=20
>  2. Some RAID HBAs / drivers (I've seen this with a LSI1068 using the
>     mptsas driver) expose the disks that are part of a HW RAID as
>     scsi device but there are no block devices for them. This allows
>     user space to send SMART commands (using the bsg node) and nag th=
e
>     user if a disk is failing.

This really doesn't sound like such a good idea.  The smart commands
have to be ATA_16/12 encapsulated.  There's already a pile of bugs
saying that this fails (including causing crashes) because various
internal firmwares don't process the encapsulation correctly.  The LSI
firmware, is the majority culprit, by the way.

> Note that we can already do all this today but since the sysfs layout
> looks like this
>=20
>  0:0:0:0
>  |-- block
>  =E2=94=82   +-- sdb
>  |   |   ...
>  |
>  |-- bsg
>  |   +-- 0:0:0:0
>  |   |   ...
>=20
> This setup is rather unfortunate because the bsg device and block dev=
ice
> are siblings and, thus, cannot share information with each other. Thi=
s
> is because only children can import information from their parents -
> anything else is prone to races.
>=20
> Now, since we currently run scsi_id + friends on the block device it
> would mean running these tools _again_ on the bsg device. Which,
> honestly is a waste. So the idea was simply to always run it on the s=
csi
> device (using the bsg node) and simply just import the data to the bl=
ock
> device and bsg devices (both are children of the scsi device).

OK, so why not simply an event on BSG device creation then?  To make
what you want to do work, it sounds like we should be moving BSG bindin=
g
farther back in the configure sequence (to the same place where we'd be
binding an ordinary ULD).  It also perhaps sounds like we don't need an=
y
events on the sdev.  The only reason we might find them useful is if we
were going to do configuration from user space (which was a proposal
once upon a time).  The sdev was never designed to be any sort of thing
the user saw (well, except as an identifying label).  That's why you
need to bind a driver (including bsg) to speak to it.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
