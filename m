From: David Zeuthen <davidz@redhat.com>
Subject: Re: [PATCH] scsi: ensure bsg device is available before announcing
 scsi device
Date: Fri, 04 Mar 2011 09:32:55 -0500
Message-ID: <1299249176.4710.15.camel@satan>
References: <1299092565.26023.2.camel@satan>
	 <1299175019.9151.16.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759644Ab1CDOdI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Mar 2011 09:33:08 -0500
In-Reply-To: <1299175019.9151.16.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, kay.sievers@vrfy.org

Hey,

On Thu, 2011-03-03 at 11:56 -0600, James Bottomley wrote:
> On Wed, 2011-03-02 at 14:02 -0500, David Zeuthen wrote:
> > From: David Zeuthen <davidz@redhat.com>
> >=20
> > udev should be able to examine a scsi device (e.g. retrieving VPD l=
ike
> > the make/model and serial number) before announcing it to the rest =
of
> > user space. Currently this is not possible because the scsi device =
has
> > no device node of its own. Instead, user space will have to use eit=
her
> > the bsg device or sg device but these are not available at uevent a=
dd
> > time since both are children of the scsi device
>=20
> This premise sounds a bit wrong.  SCSI devices go through several
> distinct phases: create, add and then configure.  We send the initial
> probe before the add phase, but no user should really poke at the dev=
ice
> before the configure phase because that's where we set the
> characteristics and other stuff.  The signal to udev that the configu=
re
> phase is over is when the ULD binding completes.  That's when the dev=
ice
> is running and it's safe to poke at.  It also means it's been identif=
ied
> internally and you'll know whether it's a disk, a tape or whatever.
>=20
> So you should see two distinct events: an ADD for the sdev, meaning w=
e
> think there's something there, but at this point there's no real devi=
ce
> for a user to see followed by the add for whatever the ULD major devi=
ce
> binding is ... at that point, we guarantee the device is up, its bsg
> queue is registered, there's actually a user block or character devic=
e
> corresponding to it and we've finished configuring it.
>=20
> What exactly are you trying to do here?  It's really not that safe to=
 be
> running user level poking in parallel with the configuration scanning
> we'll be doing as the ULD binds.

So there are basically two things I'd like to achieve here

 1. Have bsg-symlinks for SCSI devices like this

  /dev/bsg/by-id/scsi-0x05-SEAGATE-ST3300657SS-3SJ1S7K600009051M0CE
  /dev/bsg/by-id/scsi-0x0d-PROMISE-2U-SAS-12-D2-BP-35000155350e0133e

  (e.g. scsi-<type>-<vendor>-<model>-<t83-serial>)

 2. Some RAID HBAs / drivers (I've seen this with a LSI1068 using the
    mptsas driver) expose the disks that are part of a HW RAID as
    scsi device but there are no block devices for them. This allows
    user space to send SMART commands (using the bsg node) and nag the
    user if a disk is failing.

Note that we can already do all this today but since the sysfs layout
looks like this

 0:0:0:0
 |-- block
 =E2=94=82   +-- sdb
 |   |   ...
 |
 |-- bsg
 |   +-- 0:0:0:0
 |   |   ...

This setup is rather unfortunate because the bsg device and block devic=
e
are siblings and, thus, cannot share information with each other. This
is because only children can import information from their parents -
anything else is prone to races.

Now, since we currently run scsi_id + friends on the block device it
would mean running these tools _again_ on the bsg device. Which,
honestly is a waste. So the idea was simply to always run it on the scs=
i
device (using the bsg node) and simply just import the data to the bloc=
k
device and bsg devices (both are children of the scsi device).

    David


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
