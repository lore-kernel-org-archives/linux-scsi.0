From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: /proc/scsi/map
Date: Mon, 17 Jun 2002 00:38:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206170038.51403.oliver@neukum.name>
References: <200206162202.g5GM2XT02750@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200206162202.g5GM2XT02750@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>, David Brownell <david-b@pacbell.net>, Andries.Brouwer@cwi.nl, garloff@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, sancho@dauskardt.de, linux-usb-devel@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dougg@torque.net

Am Montag, 17. Juni 2002 00:02 schrieb James Bottomley:
> oliver@neukum.name said:
> > How would you find out what a device is ? If the kernel has to supply
> > the information anyway, you could just as well pass all information to
> > the script or devfs.
>
> But the kernel doesn't know this globally unique identifier information
> today, that's what the discussion is about.

But the drivers already know, or would have to be taught to know
about it. Somewhence that information has to come. You cannot
avoid that effort.

> The essence of the problem is that there's no one method that can get a
> unique identifier for every SCSI device (even though almost every device
> possesses one in one form or another).  So you have to implement a
> collection of ad hoc methods depending on what the device actually is.

That is wrong. You'd need a common method to determine device type
and several methods of passing guid. You are better off in implementing
one common way of getting at that information, which shouldn't be
too hard, as all the generic layer would have to do is pass up that information.

> The idea behind using hotplug to solve the problem is that with scsimon,
> a hotplug insertion event is generated for every SCSI device as it is
> added. The script is provided with the information the kernel knows
> (host, channel, pun lun, model and vendor inquiry strings---see
> www.torque.net/scsimon.html for details).  The hotplug script then does
> the remaining processing to extract the ID from the device (by ioctls,
> sending down SCSI commands etc.) and then binds it into the /dev/volume
> nodes using the identifier it determines.

So implement a scsi low level method called 'get_guid' and pass its
result with the other hotplugging information. Simple, no callbacks needed
and no problems with simultaneous plugging events.

The only problem you now face is stale symlinks. Which is not trivial.
If you have a link /dev/volumes/scratchvol -> /dev/sdc and you issue
mkfs -t ext2 /dev/volumes/scratchvolume you want to be very sure
that the symlink is current.
IMHO you need a kernel part that kills the symlink upon device removal.

	Regards
		Oliver

