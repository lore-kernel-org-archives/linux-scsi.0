From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Maxtor drive doesn't wake from sleep
Date: Wed, 29 Mar 2006 21:20:24 +0200
Message-ID: <442ADDF8.30209@s5r6.in-berlin.de>
References: <442AB4A8.8070307@alma.ch> <442AC484.2070107@s5r6.in-berlin.de> <442AD047.5050002@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:13994 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750852AbWC2TVi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 14:21:38 -0500
In-Reply-To: <442AD047.5050002@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Mi <mi.lists@alma.ch>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
>>Mi wrote at linux1394-devel:
>>>I have 3 external firewire Maxtor One Touch III drives, which appear
>>>to go into a "sleep" state after between one and two hours, and cannot
>>>be accessed after that.
...
>>>I later found scsi-spin which is also able to wake up the drive:
>>>  scsi-spin -u /dev/sdd
...
>>>Note that there is absolutely nothing in the logs when the drive goes
>>>to sleep. Only errors when I try to access them:
>>>   kernel: Device sdd not ready.
>>>   kernel: end_request: I/O error, dev sdd, sector 0
...
> I believe the sd driver should issue a START STOP UNIT
> (start) command when confronted with a "... initializing
> command required" error [sk,asc,ascq: 2,4,2]. It also
> needs to tell the block layer to go away and amuse itself
> while it polls the device until it is ready.
> 
> When I suggested this some time ago, the response was that
> whatever app was responsible for stopping the device bore
> the responsibility for spinning it up again (i.e. "not our
> problem").
> 
> The power condition state machine of ATA and SCSI differ
> see: http://www.torque.net/sg/power.html
> For devices that use SAT as a guide (and Maxtor seems to be)
> the reported problem is going to become more signficant:
>    a) external device decides to spin itself down after
>       a period of inactivity
>    b) user later accesses mounted file system and sd driver
>       receives a "2,4,2" error

Thanks a lot for the pointer. This may indeed become more relevant now, 
including SBP-2 enclosures because vendors have mixed IEEE 1394 and 
(e)SATA product families now.

Mi, I would be glad to help and implement what Douglas described. 
However there is still so much on my sbp2 todo-list that I'm not yet 
considering to go hack other drivers.
-- 
Stefan Richter
-=====-=-==- --== ===-=
http://arcgraph.de/sr/
