From: Theodore Tso <tytso@mit.edu>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 09:21:06 -0400
Message-ID: <20071015132106.GE21216@thunk.org>
References: <200710112011.22000.rob@landley.net> <200710141845.44750.rob@landley.net> <20071015014503.GF9715@thunk.org> <200710150304.00901.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764938AbXJONWB@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200710150304.00901.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 15, 2007 at 03:04:00AM -0500, Rob Landley wrote:
> Ok, I'll bite.  If it's all "real" scsi, why does ioctl(SG_EMULATED_HOST) 
> exist? exist if it's all "real" scsi?

SG_EMULATED_HOST was added before Linux 2.4, at least six or seven
years ago.  Back then the migration of ATA devices through the various
versions the ATAPI specification and then into SATA was very early in
its evolution, and back then, yes there were people who considered
anything that didn't use the honking huge parallel SCSI cables not
"real" SCSI.  Over time, that distinction at both the physical
connector level and logical level has declined to the point of almost
non-existence.  It's note quite at the point where SAS exists only to
justify massive prices differences between commodity and "data-center
grade" disks to the benefit of hard drive manufacturers, but it's
darned close.  (There are differences such as voltage levels so that
the max cable differences for SAS are larger, etc., but those could
have been optional additions to the SATA spec, and allegedly SAS
drives are supposedly manufactered to be more robust --- although some
recent papers published at FAST have raised some interesting questions
about how true those marketing claims really are in practice.)

> > just 
> > as Ethernet and PPP interfaces really are fundamentally the same
> > thing.
> 
> They're the same thing?
> 
> Do you mean that on a system with both, going:
>   ifconfig eth1 66.92.53.140
>   ifconfig ppp 192.168.0.42
> 
> Would be functionally equivalent to:
>   ifconfig eth1 192.168.0.42
>   ifconfig ppp 66.92.53.140

No, of course not.  But we don't have separate IP stacks for ethernet
and ppp devices.  And how we connect to a host via ssh makes no
difference whether we accessed it via Ethernet or PPP.  And I would
argue that how we address a filesystem should also make no difference
depending on the path to hard drive.

> By the way, ethernet cards contain a unique MAC address.  Hard
> drives do not seem to, or if they do it's not being consistently
> exposed in a way I can find.

You can pull a Model and Serial number via hdparm -i, but it's not as
easy to manipulate as a fixed-length MAC address.  That's why people
tend to use filesystem UUID's.   

> > More to the point, with SATA, hot plugging has been designed in, so
> > probing order is not going to be well defined,
> 
> The spec may define the capability to hotplug, but your average
> laptop doesn't not offer the capability to hotplug anything into its
> SATA controllers.  The hard drive is screwed in (due to the
> portability part of laptopness), all the controllers wired onto the
> motherboard are accounted for, none are exposed externally.  What
> _is_ exposed externally is USB, and if you want to add an extra hard
> drive you can buy a cheap USB one at Fry's.

That may be true for laptops today, but Linux doesn't run just on
servers.  You can easily get home servers with hot-swap SATA bays.  My
home fileserver, which is a white box I purchased on my own nickel,
NOT IBM big iron, has 3TB of raw storage for less than $10,000 a year
ago.  Today, that amount of home storage with hot-swap SATA drives and
a battery-backed hardware RAID controller could probably be purchased
for about half that price. 

And even for laptops, if you need the performance, you can get Cardbus
cards that will allow you to connect eSATA drives to your laptop at
Fry's.

So even if you ignore "big data center" interconnects like FC, this
problem exists even for commodity grade SATA devices.

I agree at the moment we have an issue where if the root device isn't
guaranteed, it forces people to use initrd's, and the quality and
debuggability of initrd's between distro's is highly variable and not
standardized.  In practice though the /dev/sda is actually pretty
stable on laptops, especially if you end up compiling ehci and uhci
support as modules (which is a good idea from a power savings point of
view anyway).  The reason why Ubuntu and other distributions are using
UUID-based labels is not just because of the root device, but also for
all of the other disks that might be mounted on the system, including
some that might be using USB devices that don't have stable /dev
names. 

> It's necessary for IBM big iron to do this.  It's generally not
> necessary for laptops or embedded systems to do this if they
> distinguish between _types_ of devices, which is something they
> until recently did for the types of devices I was interested in, and
> something they _stopped_ doing when everything got merged into the
> scsi layer, and I consider this a regression.

As another example, it's easy to see a home media server running Linux
which doesn't have any expansion bays for additional hard drive --- so
the only way a user could expand their storage is by using one or more
permanently connected USB disks.  So we do need to solve the general
device enumeration problem in the general case; it's not just the case
of IBM "big iron" as you seem to think.

> No, distinguishing between types of devices is not a perfect
> solution to device enumeration, but it was sufficient for all my use
> cases for many years, and would still be if the kernel still did it,
> and I'm not alone here.

News flash!  The kernel wasn't built just for you, and over time, more
and more people will have multiple disk drives of the same type, so we
will need to solve the device naming problem sooner or later.  Why not
solve it sooner, especially given that a number of companies (not just
IBM) are funding the organization that is paying *your* salary are
interested in solving the general case?  

Furthermore, I've already pointed a number of situations where the
home user might have multiple USB devices on their system today, and
that is probably going to go up over time, not down.  Have you seen
how cheap 500GB USB disks are at Costco?  And for a typical
unsophisticated user, plugging in another 500G USB disk when they need
more storage is a lot easier than cracking open the computer case and
futzing with screws and disk cables and power connectors.

		     	    	     	    - Ted
