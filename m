From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <->
 LLDD reentrancy
Date: Mon, 26 Aug 2002 16:10:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200208262110.g7QLAJ312481@localhost.localdomain>
References: <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA08195
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2002 14:10:24 -0700
In-Reply-To: Message from Mike Anderson <andmike@us.ibm.com>
   of "Mon, 26 Aug 2002 13:57:20 PDT." <20020826205720.GE1301@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

andmike@us.ibm.com said:
> Ok, so we are looking for a sibling check

Exactly.

> Example tree
> devices/root/pci0/00:09.0/name "PCI device 1014:002e"
> devices/root/pci0/00:09.0/0/name "scsi0"
> devices/root/pci0/00:09.0/0/0/name "chan0"
> devices/root/pci0/00:09.0/0/0/1/name "tgt1"
> devices/root/pci0/00:09.0/0/0/1/1/name "lun1"
> devices/root/pci0/00:09.0/0/0/1/0/name "lun0"
> devices/root/pci0/00:09.0/0/0/0/name "tgt0"
> devices/root/pci0/00:09.0/0/0/0/1/name "lun1"
> devices/root/pci0/00:09.0/0/0/0/0/name "lun0"

I'm not too happy with this tree.  The unique string 
devices/root/pci0/00:09.0/name "PCI device 1014:002e" is enough to enumerate 
the scsi card (as long as it's not multi-function).  If I follow my PUN/LUN 
position to its logical conclusion, we no longer need scsi host numbers, 
either.  tgt1 is really a fiction: For a device that has luns there's usually 
no such thing as the target address (traditionally, it's LUN 0).  However, 
fundamentally, the point is that moving all this entirely into driverfs means 
that scsi doesn't need to care what the tree looks like, it just has mappings 
into parts of it.

James


