From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <-> LLDD reentrancy
Date: Mon, 26 Aug 2002 15:56:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020826155602.A16077@eng2.beaverton.ibm.com>
References: <20020826205720.GE1301@beaverton.ibm.com> <200208262110.g7QLAJ312481@localhost.localdomain> <20020826223809.GB9917@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020826223809.GB9917@beaverton.ibm.com>; from andmike@us.ibm.com on Mon, Aug 26, 2002 at 03:38:09PM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Aug 26, 2002 at 03:38:09PM -0700, Mike Anderson wrote:
> James Bottomley [James.Bottomley@SteelEye.com] wrote:
> > > Example tree
> > > devices/root/pci0/00:09.0/name "PCI device 1014:002e"
> > > devices/root/pci0/00:09.0/0/name "scsi0"
> > > devices/root/pci0/00:09.0/0/0/name "chan0"
> > > devices/root/pci0/00:09.0/0/0/1/name "tgt1"
> > > devices/root/pci0/00:09.0/0/0/1/1/name "lun1"
> > > devices/root/pci0/00:09.0/0/0/1/0/name "lun0"
> > > devices/root/pci0/00:09.0/0/0/0/name "tgt0"
> > > devices/root/pci0/00:09.0/0/0/0/1/name "lun1"
> > > devices/root/pci0/00:09.0/0/0/0/0/name "lun0"
> > 
> > I'm not too happy with this tree.  The unique string 
> > devices/root/pci0/00:09.0/name "PCI device 1014:002e" is enough to enumerate 
> > the scsi card (as long as it's not multi-function).  If I follow my PUN/LUN 
> > position to its logical conclusion, we no longer need scsi host numbers, 
> > either.  
> Agreed, this most likely can be collapsed. In looking at hosts.[ch] list
> addition/cleanup and talking with Greg k-h in the future (once driverfs
> ref count is in) we should not being doing our own host lists and ref
> counting. 

> > tgt1 is really a fiction: For a device that has luns there's usually 
> > no such thing as the target address (traditionally, it's LUN 0).
> 
> Is there no need to represent a I_T nexus and a I_T_L nexus? It would
> seem to be a lost of information if we dump everything into to large of
> a bucket and then need to make extra links to regain this information.
 
> The tgts where just examples, these could be port names, etc. My point
> was to say if luns (which can have any name you want) where contained
> under a port node than it would be easy to determine siblings. The only
> drawback would be an extra lun0 node.

James/Mike - 

For hotplug user level probe/scanning, you want a target identified: having
the device model (aka driverfs) expose a target would (should) eventually
lead to a hotplug callout that can then be used to trigger a probe (sequential
lun or report lun scans) of the target from user land.

A target representation is also nice for device (i.e. target) 
removal/replacment, where we want to shutdown and perhaps remove
everything on one target with multiple LUNs. Even if we have to manually
remove each LUN, having a target in the tree lets a user figure out
which LUNs have to be shutdown/removed.

The notion of a target could be useful for multi-path path selection, when
we want to round-robin across the target ports, rather than a LUN port, or
pick the least-busy target port. The notion of a bus (like a SCSI bus, FCP
fabric, or an FCP loop) could be usefull for similiar reasons.

Also - according to Pat Mochel the struct device "name" field is supposed
to be a description of the device, not an id or unique identifier. I don't
know if he has plans to add a id/uuid field.

-- Patrick Mansfield
