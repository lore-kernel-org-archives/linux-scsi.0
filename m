From: david@lang.hm
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 19:51:40 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0710151919310.3949@asgard.lang.hm>
References: <200710112011.22000.rob@landley.net> <200710141845.44750.rob@landley.net>
 <20071015014503.GF9715@thunk.org> <200710150304.00901.rob@landley.net>
 <20071015132106.GE21216@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:44613
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847AbXJPCrl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 22:47:41 -0400
In-Reply-To: <20071015132106.GE21216@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Cc: Rob Landley <rob@landley.net>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Mon, 15 Oct 2007, Theodore Tso wrote:

> On Mon, Oct 15, 2007 at 03:04:00AM -0500, Rob Landley wrote:
>
>>> just
>>> as Ethernet and PPP interfaces really are fundamentally the same
>>> thing.
>>
>> They're the same thing?
>>
>> Do you mean that on a system with both, going:
>>   ifconfig eth1 66.92.53.140
>>   ifconfig ppp 192.168.0.42
>>
>> Would be functionally equivalent to:
>>   ifconfig eth1 192.168.0.42
>>   ifconfig ppp 66.92.53.140
>
> No, of course not.  But we don't have separate IP stacks for ethernet
> and ppp devices.  And how we connect to a host via ssh makes no
> difference whether we accessed it via Ethernet or PPP.  And I would
> argue that how we address a filesystem should also make no difference
> depending on the path to hard drive.

I think a close analogy would be that after a partition is mounted you 
don't need to know the path to the hard drive, and that is already true 
today. when you mount a drive (or assign and IP address to a network 
interface) the path to the device not only matters, it's critical.

>> By the way, ethernet cards contain a unique MAC address.  Hard
>> drives do not seem to, or if they do it's not being consistently
>> exposed in a way I can find.
>
> You can pull a Model and Serial number via hdparm -i, but it's not as
> easy to manipulate as a fixed-length MAC address.  That's why people
> tend to use filesystem UUID's.
>
>>> More to the point, with SATA, hot plugging has been designed in, so
>>> probing order is not going to be well defined,
>>
>> The spec may define the capability to hotplug, but your average
>> laptop doesn't not offer the capability to hotplug anything into its
>> SATA controllers.  The hard drive is screwed in (due to the
>> portability part of laptopness), all the controllers wired onto the
>> motherboard are accounted for, none are exposed externally.  What
>> _is_ exposed externally is USB, and if you want to add an extra hard
>> drive you can buy a cheap USB one at Fry's.
>
> That may be true for laptops today, but Linux doesn't run just on
> servers.  You can easily get home servers with hot-swap SATA bays.  My
> home fileserver, which is a white box I purchased on my own nickel,
> NOT IBM big iron, has 3TB of raw storage for less than $10,000 a year
> ago.  Today, that amount of home storage with hot-swap SATA drives and
> a battery-backed hardware RAID controller could probably be purchased
> for about half that price.

I also have a 3TB raid I built at home, it uses 3ware cards and a dozen 
300G IDE drives. since the 3ware driver is classified as SCSI if a drive 
fails all the other drives get renumbered on the next boot and it's 
painful to figure out which drive has a problem. I have to reboot and go 
into the 3ware BIOS to figure out which drive isn't reporting. This system 
also has an adaptec raid card in it and an adaptec regular SCSI card. The 
fact that these three cards take different drivers, and so the order of 
detection changes the drive numbering is a real pain when I'm installing a 
new distro onto it. once I get it installed I compile my own monolithic 
kernel and this problem stops becouse the kernel linking order determins 
the detection order.

this replaced a 1.2TB raid that I just about filled up, and then stared 
having drive failures due to age on. It used 8 160G IDE drives, and when I 
had problems with a drive it was easy to see that /dev/hdk was missing 
from the set, and I was still able to have a removable drive bay for 
/dev/hdc that I could hook my tivo drive into (on a reboot for safety) and 
not have things go haywire if I left the bay empty (or switched off) when 
I booted.

this may not be hundreds of drives, but it should be enough to show that I 
have experianced the pain that some people claim is the reason all of this 
must be dynamic with a userspace helper to sort it all out. My take is 
that adding the userspace helper and not enumerating things that are easy 
to enumerate is making things worse, not better.

> And even for laptops, if you need the performance, you can get Cardbus
> cards that will allow you to connect eSATA drives to your laptop at
> Fry's.
>
> So even if you ignore "big data center" interconnects like FC, this
> problem exists even for commodity grade SATA devices.

but these are seperate SATA buses, while you could run into ordering 
issues if you hook multiple devices to one bus, you should be able to have 
no ordering issues if you don't have more then one device of a type on any 
one bus (you could have a SATA hard drive on the internal PCI controller, 
and another one of the Cardbus controller, but if you always order 
directly connected devices before cardbus connected devices they will 
always show up in the same order)

>> It's necessary for IBM big iron to do this.  It's generally not
>> necessary for laptops or embedded systems to do this if they
>> distinguish between _types_ of devices, which is something they
>> until recently did for the types of devices I was interested in, and
>> something they _stopped_ doing when everything got merged into the
>> scsi layer, and I consider this a regression.
>
> As another example, it's easy to see a home media server running Linux
> which doesn't have any expansion bays for additional hard drive --- so
> the only way a user could expand their storage is by using one or more
> permanently connected USB disks.  So we do need to solve the general
> device enumeration problem in the general case; it's not just the case
> of IBM "big iron" as you seem to think.

there are two seperate problems here.

1. how to enumerate devices that have a repeatable, stable address.

2. how to enumerate devices that do not.

nobody is saying that there are no cases of #2 and that there is no need 
to address that problem, what I, and I think others are saying is that the 
solutions to #2 are not perfect, and while they are a reasonable fit for 
that case, they are in many ways inferior to simple enumeration for 
devices in catagory #1

>> No, distinguishing between types of devices is not a perfect
>> solution to device enumeration, but it was sufficient for all my use
>> cases for many years, and would still be if the kernel still did it,
>> and I'm not alone here.
>
> News flash!  The kernel wasn't built just for you, and over time, more
> and more people will have multiple disk drives of the same type, so we
> will need to solve the device naming problem sooner or later.  Why not
> solve it sooner, especially given that a number of companies (not just
> IBM) are funding the organization that is paying *your* salary are
> interested in solving the general case?

the kernel wasn't just built for people who have dozens or hundreds of 
devices on busses that make enumeration impossible either, why should 
their requirements be the only ones considered?

(by the way, I think the crack about who is paying Rob's salary is a 
little below the belt)

> Furthermore, I've already pointed a number of situations where the
> home user might have multiple USB devices on their system today, and
> that is probably going to go up over time, not down.  Have you seen
> how cheap 500GB USB disks are at Costco?  And for a typical
> unsophisticated user, plugging in another 500G USB disk when they need
> more storage is a lot easier than cracking open the computer case and
> futzing with screws and disk cables and power connectors.

so let USB devices use 'best guess' nameing and let other devices use 
names based on their fixed addresses/hardware paths.

you could use the suggestion made by Stefan Richter in Message-ID: 
<47139F15.7050702@s5r6.in-berlin.de> that lets the driver suggest a name 
if the system hasn't choosen to override it. Since distros look for 
/dev/sd* it should even be able to work without breaking new installs (the 
transition would break existing installs, so it would need to be optional)

David Lang

