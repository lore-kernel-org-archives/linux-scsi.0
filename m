From: david@lang.hm
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 19:12:00 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0710151848330.3949@asgard.lang.hm>
References: <200710112011.22000.rob@landley.net> <200710150304.00901.rob@landley.net>
 <18195.19678.500863.613193@notabene.brown> <200710151634.57407.rob@landley.net>
 <18195.64142.416450.912504@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:54387
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650AbXJPCIm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 22:08:42 -0400
In-Reply-To: <18195.64142.416450.912504@notabene.brown>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Rob Landley <rob@landley.net>, Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Tue, 16 Oct 2007, Neil Brown wrote:

> On Monday October 15, rob@landley.net wrote:
>>> Therefore it is best to not have stable single-number naming schemes
>>> for any devices on any machines.  Why?  Because it ensure there will
>>> not be any second class citizens.
>>
>> This is where we disagree.  The existence of devices you cannot stably
>> enumerate does not eliminate the existence of devices you trivially can.
>
> No, but it dramatically reduces that value of being able to enumerate
> those devices.

this is the point of disagreement. the devices you can trivially enumerate 
can be handled easily and trivially, the ones that you can't may require 
more complex things to handle them, but that depends on the situation. If 
you only have one USB drive on a system you don't need to worry about what 
order USB hotplug events come in if you can just say 'the first USB 
drive'. mixing the different types of devices into one namespace 
complicates things in a couple of ways.

1. devices that used to have stable names no longer have stable names 
without extra effort.

2. having multiple seperate unstable namespaces with one name in each of 
them looks to the user like a stable namespace, since the instability 
never comes into play. combineing these into a single namespace looses 
this stability

>>
>> Pulling out the "IBM numa cluster with multiple SAS enclosures _and_ firewire"
>> infrastructure to find the root partition on my hard drive may be good for
>> the IBM numa clusters, but only at the expense of complicating this part of
>> my laptop's infrastructure by an order of magnitude, and making embedded
>> systems nearly impossible to put together.  If "one size fits all" were true,
>> my cell phone would be running Red Hat Enterprise.
>>
>>> If some devices that are even reasonably common (e.g. IDE drives) are
>>> stable, then some application developers or system integrators will
>>> work under the assumption of stability and whatever they build will
>>> break when you try it on different hardware.
>>
>> So you break the IDE drives to get laptop users to debug the Niagra set?  The
>
> Breaking old behaviour is always bad... My computers with IDE
> interfaces still see stable "/dev/hda" devices.  Are you saying the
> devices that used to be "hda" are now "sdb" ??  Maybe there is a
> .config option...

yes, this changed. If you run your IDE drives with the PATA drivers of 
libata they show up as sdX, and are subject to the same detection order 
issues as any other sd device.

>> solution is to make the easy cases hard?
>
> Is it really that hard?
>
>>> Note that stable names a still a very real option.  udev provides
>>> several.  /dev/disk-by-path/XXX will be stable for lots of "screwed
>>> in" devices.  /dev/disk-by-id will be stable for devices the report a
>>> unique id. etc.
>>
>> Here it's
>>
>>   ls /dev/disk/by-path/
>>   pci-0000:00:1f.2-scsi-0:0:0:0        pci-0000:00:1f.2-scsi-0:0:0:0-part4
>>   pci-0000:00:1f.2-scsi-0:0:0:0-part1  pci-0000:00:1f.2-scsi-0:0:0:0-part5
>>   pci-0000:00:1f.2-scsi-0:0:0:0-part2  pci-0000:00:1f.2-scsi-0:0:0:0-part6
>>   pci-0000:00:1f.2-scsi-0:0:0:0-part3  pci-0000:00:1f.2-scsi-1:0:0:0
>>
>> And this is an improvement?
>
> Depends on your metric.
>
> "Easy to type" - I guess /dev/hda1 wins hands down.
> "Can be used in a script or config file and is guaranteed always to
> work until a screwdriver is used to change that device or it's
> controller"
>  I think
>      /dev/disk/by-path/pci-0000:00:1f.2-scsi-0:0:0:0-part1
> is quite acceptable.
> What is your metric?

does it have to be one or the other? /dev/hda1 suceeded on both metrics.


>>> The different between IDE, SATA, SCSI and even USB is peripheral for
>>> the large majority of uses, and I think maintaining the distinction in
>>> the major/minor number or in the "primary" /dev name is - for the
>>> above reasons - more of a cost that a value.
>>
>> Is your definition of "the large majority of uses" where ncr Voyager, the
>> Amiga, and current macintosh laptops are all one use each, or is your
>> definition of "the large majority of uses" the one where each "use" is an
>> installation, of which there are millions of PCs (and even more ARM cell
>> phones), and something like three instances of Voyager?
>
> My definition of "the large majority or uses" is "mkfs, fsck, mount,
> fdisk, system-install-process".
>
> Different people differentiate devices in different ways.  A system
> integrator might know about the hardware path.  An end user might know
> about drive brands or sizes.  A casual user might just think "internal
> or external".  The kernel cannot support all these different
> approaches to naming.  It really is best if it uses arbitrary names,
> and provides access to descriptions that the user can choose between.
> udev facilitates this with links in /dev/disk/.  A system install can
> facilitate this even more by reporting size/manufacturer information etc.

but is the possibility of wanting different options really sufficiant 
reason to eliminate every stable option? right now the /dev names are 
essentially random without external help. why couldn't they be stable (in 
all cases where that is possible) and let people who are happy with the 
defaults not run the external helpers, but leave them as options for 
people who do want things to be different.

>>
>> I realize that both views are valid.  This is why the US has a house and a
>> senate, and filters things through both views.  My gripe is that forcing my
>> laptop to look at my USB devices to find my SATA hard drive is aligned with
>> only one of those viewpoints, and completely opposed to the other.
>
> I'm guessing you are talking about mount-by-uuid? This effectively has
> to look at the filesystem of all devices to discover which one has the
> correct UUID, though it can cache the information for efficiency.
>
> Maybe it is just an implementation issue.  Suppose that everytime a
> device were discovered, it were examined to see what was stored on it,
> and this information was stored in a cache.
> Then to find a particular filesystem to mount, you just look in the
> cache and if the info isn't there yet, just wait or fail as
> appropriate.
> Then we don't "look at my USB devices to find my SATA hard drive" but
> rather "look at each device as it is attached to find out what is in
> it", which seems like a sensible thing to do...

this would still require spinning up every drive and looking at it to find 
the UUID.

>>
>> An approach that makes things much easier on laptops is seen to hurt big iron,
>> not because it the approach itself has a direct negative impact on big iron,
>> but only because then laptops are not saddled with the problems of big iron.
>
> I think your "laptops vs big iron" contrast is making the gap seem
> bigger than it really is.  Naming issues are present in laptops and
> easily get significant is modest servers.

maby it's becouse I've been useing linux for so long (since before 1.0), 
but I have not been seeing the same thing, it's possible that none of the 
several hundred servers I've built and managed have been big enough to 
have the problems that you describe, but the recent 'fixes' for these 
problems have been more painful for me than the original problems.

yes I have had kernel upgrades that changed the link order of drivers and 
I've had to deal with that, but I still have that problem today, with udev 
and friends involved. I recently was installing linux onto machines with 
multiple SCSI controllers and had all sorts of fun becouse the install 
disk detection order wasn't the same as the installed kernel detection 
order, causing the installer to decide teh wrong drive was the boot drive 
and put the boot loader in the wrong place (and this happened for multiple 
distros). To get things working I finally did the install, then dug up my 
old slackware boot disks to get into the system and manually install the 
boot loader to fix things up.

I've also had problems with distro boot systems not working with labels
becouse there were too many drives in the system and it gave up before 
checking far enough to find the root partition (on that machine the root 
partition was sdr2)

>> Why do you allow uni-processor kernel builds then?
>
> Funny you should suggest that...
> I don't think OpenSuSE10.3 includes any UP kernels.  There is code in
> the kernel which detects the single processor case and removes some
> the more expense "LOCK" operations to reduce the cost of using an SMP
> kernel on a UP computer.
> There is real value in reducing the number of options, and people have
> obviously put work into making that a cost-effective proposition.

but there's a huge difference between a distro deciding to not include UP 
kernels and removing the option to build a UP kernel from the kernel 
entirely. Nobody is saying that Ubuntu (or any other distro) should be 
prohibited from makeing everything SMP, or i686, we are just saying that 
the option to compile something UP or i486 should not be removed just 
becouse distros don't choose to use them much. (has the i386 option been 
completely erradicated yet? or is it still hanging on)

David Lang

