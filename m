From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: Suspending SCSI devices and buses
Date: Fri, 20 Aug 2004 16:06:32 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <31E92B97-F2F5-11D8-8CAE-00039398BB5E@ieee.org>
References: <7C828B3E-F2EA-11D8-B9BF-00039398BB5E@ieee.org> <41266F71.906020
	7@optonline.net>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:62664 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S268769AbUHTWGf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 18:06:35 -0400
In-Reply-To: <41266F71.9060207@optonline.net>
List-Id: linux-scsi@vger.kernel.org
To: Nathan Bryant <nbryant@optonline.net>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

Nathan B:

>> > current ... Linux kernel ... not distinguish
>> > power-on events from media change events.
>> ...
>> SK ASC x 6 29 UnitAttention Reset is the only notice a host gets of a 
>> wall-powered drive unplugged from one host and plugged into another, 
>> when the bus does not distinctly identify the host, as in USB, etc.  
>> From the drive's point of view, that is not an SK ASC x 6 28 
>> UnitAttention GoneReady ... yet still from the host's point of view, 
>> that is a media change.
>
> We only see this sense when the device is unplugged from the wall in 
> the process, right?

No, help, sorry.  I mean to say, try this thought experiment:

1) Power both hosts.
2) Insert a disc, power the device, connect to one host.
3) Provoke that first host to clear the x 6 29 and x 6 28.
4) Disconnect the device from one host, connect to the other.

The second host will see only x 6 29, and indeed catch that only 
because the dis/connect reset the device.

That read-once-then-lost x 6 29 is the only signal the second host 
receives that means "media change" i.e. that some other host may have 
written blocks of the media.

In theory, in the specific case of USB, the wall-powered device could 
look to notice the loss of bus power, and report loss of bus power as 
an x 6 28.  But that device design choice would create more false 
positive media change: any host that killed bus power as part of 
suspend would thus produce x 6 28, like they do now when suspend/ 
resume power cycles bus-powered removable drives.

Also, be it truth or slander, I hear that non-removable drives don't 
reliably produce the x 6 29, so to catch this always the host itself 
has to see dis/connect as a potential media change.

>>  x 2 04 02
> translates as NOT_READY,     "LOGICAL UNIT NOT READY, INITIALIZING 
> CMD. REQUIRED"

Often, yes.

> Which means they require START UNIT, right?

Op x1B, yes.

>> 1) Do enough hosts consistently limit how stale cache may be?
>>
>> 2) Do enough hosts reliably tolerate x 6 28 GoneReady produced by a 
>> suspend-resume power cycle without media change?
>
> According to recent SBC/SPC, drives are not supposed to produce x6 28 
> for low-power conditions defined by the SCSI standard. There is a 
> separate sense code for that: ILLEGAL REQUEST, ASC=LOW POWER CONDITION 
> ON.
>
> However, for SCSI devices hooked up to an ACPI capable desktop power 
> supply, S3 suspend looks just like power-off to them. So in that case 
> they're likely to report x6 29 and maybe also x6 28.

Ah, fun.

> S3

I know this is popular PC jargon, I don't personally know what it means.

> suspend looks just like power-off

Aye, that holds for any bus-powered device whose min power demand 
exceeds max suspend supply.

>> 3) Does the device itself cache part of the disc?
>
> With my patch, I'm sending SYNCHRONIZE CACHE on suspend.

Me, I'd only rely on op x35 flushing written data blocks.

What significantly may remain cached thru op x35 is metadata, 
especially the read cache of metadata e.g. the real C:H:S of each LBA.

>> 4) Is the disc robust enough to tolerate a auto fetch of its identity 
>> after each resume or power on?
>>
>> 5) Does swapping the disc detectably change a mechanical state in the 
>> drive?
>>
>> 6) Was the device expensive enough to include a non-volatile record 
>> of the identity of the disc present before each suspend or power off?
>>
>> In design, me, I'd vote to have the device pessimistically queue any 
>> UA that might be necessary, and let the host sort out which are real, 
>> but I'm not sure how often people like me lose such votes.
>
> Kill 'em all, and let Ghod sort 'em out. :)

Yep. :)  Meanwhile, we could at least write a wikipedia article to 
argue our case ...

Pat LaVarre

