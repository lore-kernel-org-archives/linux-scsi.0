From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Handling multiple paths to enclosure devices?
Date: Thu, 28 Jul 2011 18:01:48 -0400
Message-ID: <4E31DC4C.1050509@interlog.com>
References: <1311872730-4863-1-git-send-email-roland@kernel.org> <1311885202.5464.14.camel@mulgrave>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:48931 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab1G1WB4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jul 2011 18:01:56 -0400
In-Reply-To: <1311885202.5464.14.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Roland Dreier <roland@kernel.org>, linux-scsi@vger.kernel.org, eric@purestorage.com

On 11-07-28 04:33 PM, James Bottomley wrote:
> On Thu, 2011-07-28 at 10:05 -0700, Roland Dreier wrote:
>> Hi,
>>
>> I'm seeing an issue with the current design of our enclosure
>> handling.  In a system with a bunch of drives in an enclosure, it's
>> definitely helpful to have a way to go from sdXX to which slot in the
>> enclosure that drive is in, and that's what the symlink
>> /sys/block/sdXX/device/enclosure_device:NN provides.
>>
>> However, in a system with multiple paths to the enclosure, eg an HBA
>> with two external SAS ports, both connected to a SAS expander in a
>> JBOD, ie in lame ASCII graphics, something like:
>>
>>       +-----+                 /-- drv1
>>       |     |       +-----+  /---  .
>>       |     |==SAS==|     |-/----  .
>>       | HBA |       | exp |------  .
>>       |     |==SAS==|     |-\----  .
>>       |     |       +-----+  \---  .
>>       +-----+                 \-- drvN
>
> So this configuration should form a single wide port and thus not
> actually be multiple paths.  However, if you have two HBAs instead of
> one (or a non-SAS HBA), I grant it becomes multipath.

Here are some conflicting results for the single HBA case.
I tested two LSI HBAs separately, each with 8 phys and wired 5
of those phys to a LSI SAS-2 expander.

Here are the results for a SAS-1.1 (3 Gbps) 3444E HBA seen
from a SMP DISCOVER on the expander:
   phy   5:T:attached:[5001517e85c3efe5:00  t(SATA)]  3 Gbps
   phy   7:T:attached:[5000c500215725bd:00  t(SSP)]  6 Gbps
   phy  12:T:attached:[500605b00006f263:03  i(SSP+STP+SMP)]  3 Gbps
   phy  20:T:attached:[500605b00006f264:04  i(SSP+STP+SMP)]  3 Gbps
   phy  21:T:attached:[500605b00006f264:05  i(SSP+STP+SMP)]  3 Gbps
   phy  22:T:attached:[500605b00006f264:06  i(SSP+STP+SMP)]  3 Gbps
   phy  23:T:attached:[500605b00006f264:07  i(SSP+STP+SMP)]  3 Gbps
   phy  24:D:attached:[5001517e85c3effd:00  V i(SSP+SMP) t(SSP)]  6 Gbps

That is two ports:
   - a narrow port [HBA phy 3 to expander phy 12]
     note the different SAS address of HBA phy 3: 500605b00006f263
   - a wide port [HBA phys 4-7 to expander phys 20-23]
Should the HBA report as two hosts?? [It only reports as one host
in my test.]

So if a SAS HBA can't handle a wide port with more than
4 phys, it can just change the SAS addresses on one or more
phys at the HBA end.


Here are the results for a SAS-2 (6 Gbps) 9212 HBA seen
from a SMP DISCOVER on the same expander:
   phy   5:T:attached:[5001517e85c3efe5:00  t(SATA)]  3 Gbps
   phy   7:T:attached:[5000c500215725bd:00  t(SSP)]  6 Gbps
   phy  12:T:attached:[500605b001d0d3e0:04  i(SSP+STP+SMP)]  6 Gbps
   phy  20:T:attached:[500605b001d0d3e0:03  i(SSP+STP+SMP)]  6 Gbps
   phy  21:T:attached:[500605b001d0d3e0:02  i(SSP+STP+SMP)]  6 Gbps
   phy  22:T:attached:[500605b001d0d3e0:01  i(SSP+STP+SMP)]  6 Gbps
   phy  23:T:attached:[500605b001d0d3e0:00  i(SSP+STP+SMP)]  6 Gbps
   phy  24:D:attached:[5001517e85c3effd:00  V i(SSP+SMP) t(SSP)]  6 Gbps

Now that is a single wide port (5 phys wide) since all
5 expander phys have the same SAS address (not shown)
and all 5 HBA phys have the same address.

>> we have two paths to each drive, so each gets two names, sdXX and
>> sdYY.  However, in drivers/misc/enclosure.c, the code only allows one
>> device in each component and so what happens is that sdXX gets
>> discovered, then gets an enclosure_device:NN link, then sdYY is
>> discovered, so sdXX's enclosure_device:NN link is removed and one is
>> added for sdYY.  And so if I want to figure out which enclosure slot
>> sdXX is in, I'm in for a hard time.
>>
>> It would be a simple matter of writing code to allow all the block
>> devices in a slot to link back to that slot -- we would have to be a
>> bit more careful of keeping track of what links exist, but it should
>> be doable.
>>
>> The wrinkle is that there are also /sys/class/enclosure/ZZZ/NN/device
>> symlinks that allow going the other way.  And it's harder to see how
>> to express multiple block devices in one enclosure slot.
>>
>> Thoughts on how to improve our enclosure handling?

IN SAS-2 the SMP DISCOVER response should contain slot information.
Looking at sysfs for my test system:

# lsscsi
[1:0:0:0]    disk    ATA      ST3320620AS      3.AA  /dev/sda
[6:0:0:0]    disk    ATA      ST31000528AS     CC38  /dev/sdb
[6:0:1:0]    disk    SEAGATE  ST32000444SS     0006  /dev/sdc
[6:0:2:0]    enclosu Intel    RES2SV240        0600  -

then fetching the corresponding SAS port addresses:

# lsscsi -t
[1:0:0:0]    disk    sata:                           /dev/sda
[6:0:0:0]    disk    sas:0x5001517e85c3efe5          /dev/sdb
[6:0:1:0]    disk    sas:0x5000c500215725bd          /dev/sdc
[6:0:2:0]    enclosu sas:0x5001517e85c3effd          -

Referring to the SMP DISCOVER response above, it can be seen
that /dev/sdc is connected to expander phy 7. So getting the
long form output for a SMP DISCOVER on phy 7 :

# smp_discover -p 7 /dev/bsg/expander-6\:0
Discover response:
   ...
   attached SAS address: 0x5000c500215725bd
   attached phy identifier: 0
   ...
   device slot number: 255
   device slot group number: 255
   device slot group output connector:

Sadly the value of 255 means not available. YMMV

> My initial thought is that in a multi-path situation, as above, we get
> two enclosures appearing as well (one down each path).  If we
> incorporated the idea of topological subtrees into the identity matching
> code, we'd end up filling each of the enclosures with the path connected
> devices.  That seems to be an easy situation for multi-path drivers to
> sort out and one requiring no alteration of the existing enclosure code
> (except to do the topological subtree search).
>
> How does that sound?

Does this also solve the problem reported a few weeks back
in which a SES logical unit reported duplicate element
descriptor names?

Doug Gilbert
