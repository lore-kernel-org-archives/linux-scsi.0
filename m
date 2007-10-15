From: Neil Brown <neilb@suse.de>
Subject: Re: What still uses the block layer?
Date: Tue, 16 Oct 2007 09:41:02 +1000
Message-ID: <18195.64142.416450.912504@notabene.brown>
References: <200710112011.22000.rob@landley.net>
	<200710150304.00901.rob@landley.net>
	<18195.19678.500863.613193@notabene.brown>
	<200710151634.57407.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759657AbXJOXlR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Oct 2007 19:41:17 -0400
In-Reply-To: message from Rob Landley on Monday October 15
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Monday October 15, rob@landley.net wrote:
> > Therefore it is best to not have stable single-number naming schemes
> > for any devices on any machines.  Why?  Because it ensure there will
> > not be any second class citizens.
> 
> This is where we disagree.  The existence of devices you cannot stably 
> enumerate does not eliminate the existence of devices you trivially can.

No, but it dramatically reduces that value of being able to enumerate
those devices.

> 
> Pulling out the "IBM numa cluster with multiple SAS enclosures _and_ firewire" 
> infrastructure to find the root partition on my hard drive may be good for 
> the IBM numa clusters, but only at the expense of complicating this part of 
> my laptop's infrastructure by an order of magnitude, and making embedded 
> systems nearly impossible to put together.  If "one size fits all" were true, 
> my cell phone would be running Red Hat Enterprise.
> 
> > If some devices that are even reasonably common (e.g. IDE drives) are
> > stable, then some application developers or system integrators will
> > work under the assumption of stability and whatever they build will
> > break when you try it on different hardware.
> 
> So you break the IDE drives to get laptop users to debug the Niagra set?  The 

Breaking old behaviour is always bad... My computers with IDE
interfaces still see stable "/dev/hda" devices.  Are you saying the
devices that used to be "hda" are now "sdb" ??  Maybe there is a
.config option...

> solution is to make the easy cases hard?

Is it really that hard?

> > Note that stable names a still a very real option.  udev provides
> > several.  /dev/disk-by-path/XXX will be stable for lots of "screwed
> > in" devices.  /dev/disk-by-id will be stable for devices the report a
> > unique id. etc.
> 
> Here it's
> 
>   ls /dev/disk/by-path/
>   pci-0000:00:1f.2-scsi-0:0:0:0        pci-0000:00:1f.2-scsi-0:0:0:0-part4
>   pci-0000:00:1f.2-scsi-0:0:0:0-part1  pci-0000:00:1f.2-scsi-0:0:0:0-part5
>   pci-0000:00:1f.2-scsi-0:0:0:0-part2  pci-0000:00:1f.2-scsi-0:0:0:0-part6
>   pci-0000:00:1f.2-scsi-0:0:0:0-part3  pci-0000:00:1f.2-scsi-1:0:0:0
> 
> And this is an improvement?

Depends on your metric.

"Easy to type" - I guess /dev/hda1 wins hands down.
"Can be used in a script or config file and is guaranteed always to
work until a screwdriver is used to change that device or it's
controller"
  I think
      /dev/disk/by-path/pci-0000:00:1f.2-scsi-0:0:0:0-part1
is quite acceptable.
What is your metric?


> 
> > The different between IDE, SATA, SCSI and even USB is peripheral for
> > the large majority of uses, and I think maintaining the distinction in
> > the major/minor number or in the "primary" /dev name is - for the
> > above reasons - more of a cost that a value.
> 
> Is your definition of "the large majority of uses" where ncr Voyager, the 
> Amiga, and current macintosh laptops are all one use each, or is your 
> definition of "the large majority of uses" the one where each "use" is an 
> installation, of which there are millions of PCs (and even more ARM cell 
> phones), and something like three instances of Voyager?

My definition of "the large majority or uses" is "mkfs, fsck, mount,
fdisk, system-install-process".

Different people differentiate devices in different ways.  A system
integrator might know about the hardware path.  An end user might know
about drive brands or sizes.  A casual user might just think "internal
or external".  The kernel cannot support all these different
approaches to naming.  It really is best if it uses arbitrary names,
and provides access to descriptions that the user can choose between.
udev facilitates this with links in /dev/disk/.  A system install can
facilitate this even more by reporting size/manufacturer information etc.

> 
> I realize that both views are valid.  This is why the US has a house and a 
> senate, and filters things through both views.  My gripe is that forcing my 
> laptop to look at my USB devices to find my SATA hard drive is aligned with 
> only one of those viewpoints, and completely opposed to the other.

I'm guessing you are talking about mount-by-uuid? This effectively has
to look at the filesystem of all devices to discover which one has the
correct UUID, though it can cache the information for efficiency.

Maybe it is just an implementation issue.  Suppose that everytime a
device were discovered, it were examined to see what was stored on it,
and this information was stored in a cache.
Then to find a particular filesystem to mount, you just look in the
cache and if the info isn't there yet, just wait or fail as
appropriate. 
Then we don't "look at my USB devices to find my SATA hard drive" but
rather "look at each device as it is attached to find out what is in
it", which seems like a sensible thing to do...

> 
> An approach that makes things much easier on laptops is seen to hurt big iron, 
> not because it the approach itself has a direct negative impact on big iron, 
> but only because then laptops are not saddled with the problems of big iron.

I think your "laptops vs big iron" contrast is making the gap seem
bigger than it really is.  Naming issues are present in laptops and
easily get significant is modest servers.

> 
> Why do you allow uni-processor kernel builds then?

Funny you should suggest that...
I don't think OpenSuSE10.3 includes any UP kernels.  There is code in
the kernel which detects the single processor case and removes some
the more expense "LOCK" operations to reduce the cost of using an SMP
kernel on a UP computer.
There is real value in reducing the number of options, and people have
obviously put work into making that a cost-effective proposition.

NeilBrown
