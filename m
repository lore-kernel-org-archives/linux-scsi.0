From: Doug Ledford <dledford@redhat.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <-> LLDD reentrancy
Date: Mon, 26 Aug 2002 19:10:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020826191036.C28828@redhat.com>
References: <20020826205720.GE1301@beaverton.ibm.com> <200208262110.g7QLAJ312481@localhost.localdomain> <20020826223809.GB9917@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
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

The scsi host can be collapsed, the other stuff should really remain.  
After all, the scsi host number was nothing more than the previous way of 
expressing "PCI device 1014:002e", they both map to a controller 
somewhere.

> > tgt1 is really a fiction: For a device that has luns there's usually 
> > no such thing as the target address (traditionally, it's LUN 0).
> 
> Is there no need to represent a I_T nexus and a I_T_L nexus?

There is.  Not really for device needs, but for management needs.  It's 
connection specific and likely is just an implementation detail, but it 
would make like simpler for LLDDs if this was expressed.  What I'm 
thinking is that both the target level struct and the lun level struct 
need to have driver_private pointers for driver defined memory structs as 
well as a back pointer from the lun struct to the parent target struct.  
This is so drivers can easily do things like implement tagged queues 
properly, which are per lun, and also implement speed negotiations, which 
are per target.

> It would
> seem to be a lost of information if we dump everything into to large of
> a bucket and then need to make extra links to regain this information.

Having links to get the information isn't bad (it's currently better than 
the crap we do now which is search the linear list until we've found all 
the needed devices, very ugly).  Having the right links is actually quite 
nice ;-)

> The tgts where just examples, these could be port names, etc. My point
> was to say if luns (which can have any name you want) where contained
> under a port node than it would be easy to determine siblings. The only
> drawback would be an extra lun0 node.

It doesn't have to be that way.  It's entirely possible to make the target 
struct not require this extra lun0 node you refer to.  However, the target 
struct should actually be a fairly thin struct, only containing enough 
info to represent those items that are in fact target wide vs. lun 
specific.  Essentially, anything that the SAM spec calls out as using an 
I_T nexus should be here, and anything that goes on an I_T_L nexus should 
be in the lun struct.  It seems to me that the specs are likely to keep 
this level of heirarchy going forward and so it should be safe to model 
after it, but I could be wrong (and I have read the latest draft specs so 
I could already be wrong).  Feel free to correct me here if I am wrong.

> I am confused as the scsi subsystem is creating parts of this tree by
> deciding when and what to register with driverfs. Driverfs is only
> providing the interface and some default nodes. While driverfs is doing
> a lot, how we register can make future code easier or hard.

Hmmm...I'm not going to comment on this yet because I want to go look a 
few things up first....

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
