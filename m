From: Oliver Xymoron <oxymoron@waste.org>
Subject: Re: [PATCH] /proc/scsi/map
Date: Thu, 20 Jun 2002 15:06:55 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0206201442060.16808-100000@waste.org>
References: <Pine.LNX.4.44.0206201210420.8225-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0206201210420.8225-100000@home.transmeta.com>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Patrick Mansfield <patmans@us.ibm.com>, Andries Brouwer <aebr@win.tue.nl>, Martin Schwenke <martin@meltin.net>, Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mochel <mochel@osdl.org>

On Thu, 20 Jun 2002, Linus Torvalds wrote:

> On Thu, 20 Jun 2002, James Bottomley wrote:
> >
> > We should probably have some more discussion about the layout of the device
> > tree, particularly if it's going to be consistent with other devices like ide
> > discs and cds.
>
> Absolutely. I suspect that the _real_ issues start coming up only once
> people start using this for useful work, and we should just accept that
> the format (for now) is in flux. But that doesn't mean that we shouldn't
> try to make it reasonably sane from the very start.
>
> And make sure that the naming convention works for both IDE and SCSI (ie
> there should be a way to figure out _portably_ whether a device is a disk
> or CD-RW or whatever, without even knowing whether it's SCSI or IDE).

There are other device classes beyond disks we need to do similar things
with that we ought to figure out at the same time. Examples off the top of
my head: disk (disk? cdaudio? dvd? cdrw?), sound (wave table? 3d?), v4l
(tuner? radio? mpeg?), net (wireless?).

One possibility is an "interfaces" file that lists the types of interfaces
that a device supports, possibly along with major:minor for that
interface. Then you can do find /devices -name interfaces | xargs grep
disk to locate your disks..

Another general question is how to fit "virtual" devices that aren't
associated with a bus into this scheme. For instance, PPP, VPNs, loopback
block devices, ramdisks, iSCSI, NBD. While you might argue that most of
these aren't really devices, iSCSI is every bit as "real" as a "local" FC
disk. And then you get into logical devices ala LVM and RAID..

-- 
 "Love the dolphins," she advised him. "Write by W.A.S.T.E.."

