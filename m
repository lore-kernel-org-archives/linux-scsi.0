From: Rob Landley <rob@landley.net>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 16:34:57 -0500
Message-ID: <200710151634.57407.rob@landley.net>
References: <200710112011.22000.rob@landley.net> <200710150304.00901.rob@landley.net> <18195.19678.500863.613193@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:56565
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbXJOVfC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 17:35:02 -0400
In-Reply-To: <18195.19678.500863.613193@notabene.brown>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Monday 15 October 2007 6:19:58 am Neil Brown wrote:
> On Monday October 15, rob@landley.net wrote:
> > This is my objection.  Even when enumerating multiple devices of the same
> > type is tricky, enumerating multiple devices of _different_ types should
> > not be. There's a great big type indicator that is being _deliberately_
> > ignored, and large classes of devices (millions of laptops) where you
> > know there's only going to be _one_ instance of a given type.
>
> My perspective is different.
>
> The range of addressing option for "all disk devices" is far too rich
> to be able to assign a stable device number every device: there are
> multiple, multi-dimensional addressing scheme, and some devices might
> not even have a stable address at all (e.g. USB?).
> So the reality of dealing with disk devices is that you cannot provide
> a stable single-number naming scheme for all devices on all machines.

Sure.

> Therefore it is best to not have stable single-number naming schemes
> for any devices on any machines.  Why?  Because it ensure there will
> not be any second class citizens.

This is where we disagree.  The existence of devices you cannot stably 
enumerate does not eliminate the existence of devices you trivially can.

Pulling out the "IBM numa cluster with multiple SAS enclosures _and_ firewire" 
infrastructure to find the root partition on my hard drive may be good for 
the IBM numa clusters, but only at the expense of complicating this part of 
my laptop's infrastructure by an order of magnitude, and making embedded 
systems nearly impossible to put together.  If "one size fits all" were true, 
my cell phone would be running Red Hat Enterprise.

> If some devices that are even reasonably common (e.g. IDE drives) are
> stable, then some application developers or system integrators will
> work under the assumption of stability and whatever they build will
> break when you try it on different hardware.

So you break the IDE drives to get laptop users to debug the Niagra set?  The 
solution is to make the easy cases hard?

> This happened during the 
> early days of SCSI support - code assumed the stability of
> major/minor numbers and so did not work properly with SCSI which
> cannot provide that stability in general.

In this case, I ripped the relevant infrastructure out by hand so fstab again 
has /dev/sda.  I can do it again on future systems.  I'd just really rather 
not have to.

> Having a totally uniform approach makes development and testing a lot
> easier - there are fewer special cases.

There are actually more special cases, you just expose more people to them.

> I would prefer that 'total uniformity' went even further than
> /dev/sd?? to /dev/disk??.  i.e. Anything that is or behaves
> substantially like a disk drive should be "/dev/diskXX", where numbers
> are assigned sequentially on discovery. (I wonder why we need
> /dev/scdX to be separate from /dev/sdX).

It's /dev/srX here, and I have no idea.

I believe merging these namespaces invents problems, and was a bad idea.  I 
understand you're reasoning, but imposing the problems of mainframes onto 
laptops does not strike me as an improvement for laptops.

> Note that stable names a still a very real option.  udev provides
> several.  /dev/disk-by-path/XXX will be stable for lots of "screwed
> in" devices.  /dev/disk-by-id will be stable for devices the report a
> unique id. etc.

Here it's

  ls /dev/disk/by-path/
  pci-0000:00:1f.2-scsi-0:0:0:0        pci-0000:00:1f.2-scsi-0:0:0:0-part4
  pci-0000:00:1f.2-scsi-0:0:0:0-part1  pci-0000:00:1f.2-scsi-0:0:0:0-part5
  pci-0000:00:1f.2-scsi-0:0:0:0-part2  pci-0000:00:1f.2-scsi-0:0:0:0-part6
  pci-0000:00:1f.2-scsi-0:0:0:0-part3  pci-0000:00:1f.2-scsi-1:0:0:0

And this is an improvement?

> The different between IDE, SATA, SCSI and even USB is peripheral for
> the large majority of uses, and I think maintaining the distinction in
> the major/minor number or in the "primary" /dev name is - for the
> above reasons - more of a cost that a value.

Is your definition of "the large majority of uses" where ncr Voyager, the 
Amiga, and current macintosh laptops are all one use each, or is your 
definition of "the large majority of uses" the one where each "use" is an 
installation, of which there are millions of PCs (and even more ARM cell 
phones), and something like three instances of Voyager?

I realize that both views are valid.  This is why the US has a house and a 
senate, and filters things through both views.  My gripe is that forcing my 
laptop to look at my USB devices to find my SATA hard drive is aligned with 
only one of those viewpoints, and completely opposed to the other.

An approach that makes things much easier on laptops is seen to hurt big iron, 
not because it the approach itself has a direct negative impact on big iron, 
but only because then laptops are not saddled with the problems of big iron.

Why do you allow uni-processor kernel builds then?

> NeilBrown

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
