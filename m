From: Nick Bellinger <nickb@attheoffice.org>
Subject: Re: [PATCH] /proc/scsi/map
Date: 21 Jun 2002 22:38:39 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1024720721.6874.104.camel@subjeKt>
References: <Pine.LNX.4.44.0206211616510.16808-100000@waste.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0206211616510.16808-100000@waste.org>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Xymoron <oxymoron@waste.org>
Cc: Patrick Mochel <mochel@osdl.org>, sullivan <sullivan@austin.ibm.com>, Linus Torvalds <torvalds@transmeta.com>, Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Fri, 2002-06-21 at 15:33, Oliver Xymoron wrote:
> On Thu, 20 Jun 2002, Patrick Mochel wrote:
> 
> > > But it was entierly behind me how to fit this
> > > in to the sheme other sd@4,0:h,raw
> > > OS-es are using. And finally how would one fit this in to the
> > > partitioning shemes? For the system aprtitions are simply
> > > block devices hanging off the corresponding block device.
> >
> > Partitions are purely logical entities on a physical disk. They have no
> > presence in the physical device tree.
> 
> As I raised elsewhere in this thread, the distinction between physical and
> logical is troubling. Consider iSCSI, (aka SCSI-over-IP). It's analogous
> to SCSI-over-Fibre Channel, except that rather than using an embedded FC
> stack, it's using the kernel's IP stack. But it's every bit as much a SCSI
> disk/tape/whatever as a local device. Ergo, it ought to show up in the
> device tree so that it can be discovered in the same way. But where?
> 
> This is only one step (the SCSI midlayer) removed from the logical devices
> created by partitioning, LVM, NBD, MD, loopback, ramdisk and the like,
> that again, ought to be discoverable in the same way as all other block
> devices. Perhaps we need root/{virtual,logical}?
> 

The interaction between iSCSI & driverfs does pose an interesting
problem:

On one hand I tend to lead toward the view of a physical device. 
The reason being that there will never be a distinction as far as the
kernel is concerned (other than driverfs of course) that a SCSI upper
level driver (hopefully soon to be a personality driver) using a iSCSI
Initiator low-level driver is not really a physical host. 

On the other hand there is the obvious fact that an iSCSI initiator
driver is not attached to a bus, and assuming /root/iSCSI.target/disk1
etc, is out of the question.  There is a real need for a solution to
handle virtual devices (as stated your previous message) that are not
assoicated with any physical connectors.  

Not being too fimilar with driverfs,  what are the options with regard
to virtual devices as things currently stand without tainting the
elegant tree that is provides?
				
				Nicholas Bellinger

