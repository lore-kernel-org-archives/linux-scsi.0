From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <-> LLDD reentrancy
Date: Mon, 26 Aug 2002 15:38:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020826223809.GB9917@beaverton.ibm.com>
References: <20020826205720.GE1301@beaverton.ibm.com> <200208262110.g7QLAJ312481@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200208262110.g7QLAJ312481@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> > Example tree
> > devices/root/pci0/00:09.0/name "PCI device 1014:002e"
> > devices/root/pci0/00:09.0/0/name "scsi0"
> > devices/root/pci0/00:09.0/0/0/name "chan0"
> > devices/root/pci0/00:09.0/0/0/1/name "tgt1"
> > devices/root/pci0/00:09.0/0/0/1/1/name "lun1"
> > devices/root/pci0/00:09.0/0/0/1/0/name "lun0"
> > devices/root/pci0/00:09.0/0/0/0/name "tgt0"
> > devices/root/pci0/00:09.0/0/0/0/1/name "lun1"
> > devices/root/pci0/00:09.0/0/0/0/0/name "lun0"
> 
> I'm not too happy with this tree.  The unique string 
> devices/root/pci0/00:09.0/name "PCI device 1014:002e" is enough to enumerate 
> the scsi card (as long as it's not multi-function).  If I follow my PUN/LUN 
> position to its logical conclusion, we no longer need scsi host numbers, 
> either.  
Agreed, this most likely can be collapsed. In looking at hosts.[ch] list
addition/cleanup and talking with Greg k-h in the future (once driverfs
ref count is in) we should not being doing our own host lists and ref
counting. 

> tgt1 is really a fiction: For a device that has luns there's usually 
> no such thing as the target address (traditionally, it's LUN 0).

Is there no need to represent a I_T nexus and a I_T_L nexus? It would
seem to be a lost of information if we dump everything into to large of
a bucket and then need to make extra links to regain this information.

The tgts where just examples, these could be port names, etc. My point
was to say if luns (which can have any name you want) where contained
under a port node than it would be easy to determine siblings. The only
drawback would be an extra lun0 node.

> However, fundamentally, the point is that moving all this entirely
> into driverfs means that scsi doesn't need to care what the tree looks
> like, it just has mappings into parts of it.

I am confused as the scsi subsystem is creating parts of this tree by
deciding when and what to register with driverfs. Driverfs is only
providing the interface and some default nodes. While driverfs is doing
a lot, how we register can make future code easier or hard.

-Mike

-- 
Michael Anderson
andmike@us.ibm.com

