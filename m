From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Some quick scsi documentation questions:
Date: Fri, 03 Aug 2007 12:43:25 +0200
Message-ID: <46B306CD.3030002@s5r6.in-berlin.de>
References: <200707252328.28981.rob@landley.net> <46B2256A.3070902@torque.net> <46B24A77.2050809@s5r6.in-berlin.de> <200708022055.45523.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:50768 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760152AbXHCKn1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2007 06:43:27 -0400
In-Reply-To: <200708022055.45523.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: dougg@torque.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Rob Landley wrote:
> On Thursday 02 August 2007 5:19:51 pm Stefan Richter wrote:
>> Alternatively to partition labels, you can also have udev create
>> persistently named symlinks for you.
> 
> A) You never need to label the _partition_, you need to consistently identify 
> the _device_ and the partitions fall out from that.
> 
> landley@dell:/$ cat /sys/block/sr0/device/model
> CDRWDVD DW224EV
> landley@dell:/$ cat /sys/block/sda/device/model
> Hitachi HTS54161
> 
> Why exactly do I need a uuid to identify either of these when I only have one 
> of each in the system and _know_ I'll never have more than that?

If there is only have one device of a kind, then there is no UUID needed
for anything in the first place.

Besides, then you also don't need to map between the sd or sr device and
the sg device.  You can and should do the generic IO through the sd and
sr devices nowadays.

> (Sure go 
> for a uuid when there's more than one hard drive.  But please explain to me 
> how a uuid would help if I had two identical DVD burners with no media in 
> them on bootup...)

In case of FireWire drives and several other types of drives (I believe
also in case of SATA devices) there is a UUID tied to the *drive* too,
alongside UUIDs of the media.

> B) This particular device can't move without a screwdriver, and you can't add 
> another sata drive to this laptop without a soldering iron.

And how is software supposed to know that?

> The fact that modern Linux kernels can't consistently identify it during 
> bootup is a design flaw.

Do you mean the Linux OS or the Linux kernel?

> (Yes, I followed the discussion of all this years 
> ago, but the fact remains that there are certain very common types of 
> hardware that only get confused by things like USB keys because both the USB 
> keys, which may speak a scsi-like protocol but aren't actually scsi hardware, 
> and SATA drives, ditto, get routed into the same scsi layer heap and 
> conflated.  And that's sad.

Harddisks are harddisks, CD-ROMs are CD-ROMs, scanners are scanners, no
matter how they are attached.  At least as far as the commands are
concerned that software sends to them.  I say that's a good thing.

Sure, the type of attachment may be interesting to know for device file
naming, see below.

>> The udev rules I have here (Gentoo's) apparently don't do this for
>> CD/DVD-ROM/R/Ws although that should be possible as well.
> 
> Many things are possible.  It doesn't make them a good idea.  Telling udev to 
> do something complicated to keep track of a device that I know, at OS install 
> time, _can't_ever_physically_move_, is one of them.

There is a variety of possible naming schemes:

  - Naming by order of discovery.
  - Naming by vendor/model name strings.
  - Naming by universally unique identifier.
  - Naming by topology.
  - ...

Only the simplest of these schemes (naming by order of discovery) is
hardwired into the kernel portion of the Linux OS.  The other naming
schemes are (or can be) implemented in the userland portion of the Linux OS.

There is only the most primitive naming scheme implemented in the kernel
because naming policy, like most other kinds of policy, is better left
to userland.  The kernel is a too restricted framework to implement such
things.  The kernel lacks runtime-configuration files, scripting
interfaces, et cetera.

>> On the other 
>> hand, application programs like K3B already nicely show devices with
>> vendor and model strings.  I don't know how much effort that imposes on
>> the application programs.
> 
> See above, but notice that Greg KH says that any program that follows 
> the "device" symlink is buggy,

K3B doesn't use sysfs for that.  It most certainly uses SG IO (SCSI
generic IO) to figure out these names.

> because he doesn't want to be tied down to anything as mundane as a
> stable userspace API.

Sysfs is designed to be unstable; see my answer to your other post.
Sysfs (most of it) does not belong to the stable userspace ABIs of the
kernel.
-- 
Stefan Richter
-=====-=-=== =--- ---==
http://arcgraph.de/sr/
