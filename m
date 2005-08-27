From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Fri, 26 Aug 2005 21:39:30 -0400
Message-ID: <430FC452.70604@pobox.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>	 <20050823154232.GA3464@us.ibm.com> <430BBBBE.4070408@adaptec.com>	 <430E1CB1.1050108@s5r6.in-berlin.de> <430E24AB.2060002@pobox.com>	 <430F46AA.2050305@adaptec.com> <1125076960.5079.61.camel@mulgrave> <430F5C8F.3030708@adaptec.com> <430F63EA.7020400@pobox.com> <430F6F89.8040503@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:10156 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S965200AbVH0Bji (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 21:39:38 -0400
In-Reply-To: <430F6F89.8040503@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: James Bottomley <jejb@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> On 08/26/05 14:48, Jeff Garzik wrote:
> 
>>>No host numbers, no routing information.  This is all
>>>transparent to SCSI Core, and NONE of its business.
>>
>>Routing is an essential part of the SCSI core's duties.
> 
> 
> [I'm not a big fan of reading mixed-message emails, but what can you do...]
>  
> 
>>The SCSI core is the resource manager responsible for routing messages 
>>[CDBs] to/from LLDs based on <scsi-specific device address>.  This 
>>includes resolution of kernel-specific identifiers (device major/minor, 
>>etc.) into <s.s.d.a.>.  This also includes direct use of 
> 
> 
> This particular is the task of sd.c.  How it does it is
> sd.c. job.  Not SCSI Core.

No.  sd, sr, st, and sg all use the -common- infrastructure to execute 
tasks and return results.  That common infrastructure is part of the 
SCSI core.

The SCSI layer itself is a marraige between

	device classes -- sd, sr, st, sg
	transport classes -- common per-transport code
	drivers -- executes tasks via transport class
	glue -- the myriad functions that tie the above 3 together

All transport-specific knowledge that is common across hardware vendors 
should be in the transport class.  The SCSI core uses the transport 
class to perform transport-specific actions.



>>userspace-provided identifiers as <s.s.d.a.>, such as via SG_IO ioctl.
> 
> 
> Ah, yes, I see.  So the question is, how do we fit SG_IO ioctl?
> 
> SG_IO can be transport/protocol agnostic _if_ SCSI Core gets
> the architecture right.
> 
> I.e. if I show you a picture of the objects "out there" in the
> SCSI domain, you can just point to one and send something to it.
> That picture will be painted by the transport layer.  SCSI Core
> is _completely_ unaware of all this!  This is how you can accomodate
> SMP and any future protocols that can come your way.

The SCSI core is the common point for exporting bus topology via 
transport classes.


>>Moving away from HCIL requires a lot of thought, including thinking 
>>about userland app breakage -- a big deal in Linux.
> 
> 
> I never contended that userspace should be moved away from HCIL.

Then, by implication, SAS and FC must continue to maintain HCIL<->device 
maps.


> What I contend is that _internally_ SCSI Core start moving
> away from HCIL and towards SAM.

SAM is already mostly there.  ->queuecommand is already a pretty good 
execute_task().


> Most easily this would be done by implementing a bunch of
> new-way-to-do-it functions.  The request_queue wouldn't care,
> and old LLDD can use the old interface, and new ones can use
> the new interface.

Disagree.  Just follow the TODO list Christoph outlined, plus figure out 
how to handle SG_IO and /dev/sg sanely.

We don't need yet more

	if (new way) {
		...
	} else {
		...
	}

code blocks :)

HCIL addressing gunk largely belongs in SPI transport class, along with 
scsi_scan_host() [each transport class should build its own topology].

This achieves the result you want to achive:  new-way-to-do-it functions 
live in the SAS and FC transport classes (with generic code in generic 
SCSI layer), old-way-to-do-it HCIL functions live in the SPI transport 
class.


>>Ask yourself where all these HCIL-addressed CDBs come from...  each one 
>>of those CDB submittors must be updated from HCIL addressing/routing to 
>>transport-specific.

> No, no transport specific -- I repeat again: the whole point is to move
> away from "transport specific".  _SCSI_Core_can invent an HCIL label for them,
> not LLDD as they currently do.

You will never be able to eliminate transport-specific code.  That's the 
whole point of transport classes:  encapsulate common transport code. 
Call it a transport library, rather than a class, if "class" gives 
people the shivers.

Example:  I have access to SAS+SATA host controllers from Adaptec and 
Company X.  Both are largely software-based, directly controlling the 
PHY ports and manually performing all SAS+SATA discovery.

I would expect that adaptec_sas and companyx_sas drivers would share 
transport-specific code via the ata_transport and sas_transport classes.

	Jeff


