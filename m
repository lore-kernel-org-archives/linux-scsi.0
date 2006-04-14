From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Comments Needed] scan vs remove_target deadlock
Date: Fri, 14 Apr 2006 21:16:08 +0200
Message-ID: <443FF4F8.6010402@s5r6.in-berlin.de>
References: <1144693508.3820.33.camel@localhost.localdomain> <443B6E90.4020705@s5r6.in-berlin.de> <443E6C60.3050501@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:1159 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751423AbWDNTQ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Apr 2006 15:16:28 -0400
In-Reply-To: <443E6C60.3050501@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
(I wrote)
...
>> before a transport may remove an sdev or shost, it has to unblock it
>> and it also has to make sure that all commands that were enqueued before
>> the blocking are being completed.
> 
> True. The FC transport explicitly performs an unblock prior to the remove
> call. What I'm seeing would align with "not" making sure the prior queued
> commands are completed before it removes.
> 
>> But isn't it rather a responsibility
>> of the SCSI core to get a LU's or target's state transitions right?
> 
> Agreed. The real issue is - define the window for prior queued commands.
> You may flush all that are there right now, but that may immediately
> requeue a retry, etc - which means you have to start all over.

The retry problem is of course also to be solved in the SCSI core and/or 
above, i.e. in the protocol driver (and perhaps in userspace apps doing 
sg_io, although this is not very relevant to this discussion).

For example, sr_mod seems to issue and retry commands to LUs which are 
even in "offline" state.

>> When
>> an sdev is "blocked" and the transport tells the core to transition it
>> to "to be removed", then the core should know that the sdev's LU cannot
>> be reached anymore and act accordingly.
> 
> I would assume - that's what we'll eventually get to, with the mutex
> being the first onion layer to get pulled.

The deadlocks which sbp2<->scsi plagued in the past did not seem 
scan_mutex related. But I will stress-test this again to see if a same 
or similar situation as you described can be provoked with sbp2. Maybe 
it is completely impossible because /a/ sbp2 (currently) has only one LU 
beneath each Scsi_Host and /b/ sdev removal will never be started before 
the scanning finished, due to how the IEEE 1394 subsystem (currently) 
adds and removes units.
-- 
Stefan Richter
-=====-=-==- -=-- -===-
http://arcgraph.de/sr/
