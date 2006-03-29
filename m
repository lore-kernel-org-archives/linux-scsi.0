From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Maxtor drive doesn't wake from sleep
Date: Wed, 29 Mar 2006 13:21:59 -0500
Message-ID: <442AD047.5050002@torque.net>
References: <442AB4A8.8070307@alma.ch> <442AC484.2070107@s5r6.in-berlin.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:61921 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S1750959AbWC2SWh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 13:22:37 -0500
In-Reply-To: <442AC484.2070107@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Mi <mi.lists@alma.ch>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Mi wrote at linux1394-devel:
> 
>> Hello,
>>
>> I have 3 external firewire Maxtor One Touch III drives, which appear
>> to go into a "sleep" state after between one and two hours, and cannot
>> be accessed after that.
>>
>> After a lot of searches and tests, I have found a few clues, but still
>> wonder why they don't wake up automatically as needed. Is there
>> anything I can do to my system so that it "Just Works"? Is this a
>> known problem?
> 
> 
> There are very few vendors which implement auto-spin-down in FireWire
> disk enclosures. And of these few, only few get it right.
> 
>> To have the drive re-appear, I found I can
>>
>>   rmmod sbp2
>>   modprobe sbp2
>>
>> and I later found scsi-spin which is also able to wake up the drive:
>>
>>   scsi-spin -u /dev/sdd
>>
>> But since these drives are on a server and suposed to be mounted with
>> automount, these manual steps to wake them are nt much help.
>>
>> Note that there is absolutely nothing in the logs when the drive goes
>> to sleep. Only errors when I try to access them:
>>
>>    kernel: Device sdd not ready.
>>    kernel: end_request: I/O error, dev sdd, sector 0
> 
> 
> I don't think this could be solved in the FireWire drivers. It seems
> sd_mod is the place to look for a solution. The sbp2 driver is not aware
> that there is something wrong with the disk, else there would be error
> messages.
> 
> That's why I added linux-scsi to the recipients. I'd be glad if somebody
> of the SCSI folk could comment.

Stefan,
I believe the sd driver should issue a START STOP UNIT
(start) command when confronted with a "... initializing
command required" error [sk,asc,ascq: 2,4,2]. It also
needs to tell the block layer to go away and amuse itself
while it polls the device until it is ready.

When I suggested this some time ago, the response was that
whatever app was responsible for stopping the device bore
the responsibility for spinning it up again (i.e. "not our
problem").

The power condition state machine of ATA and SCSI differ
see: http://www.torque.net/sg/power.html
For devices that use SAT as a guide (and Maxtor seems to be)
the reported problem is going to become more signficant:
   a) external device decides to spin itself down after
      a period of inactivity
   b) user later accesses mounted file system and sd driver
      receives a "2,4,2" error

Doug Gilbert
