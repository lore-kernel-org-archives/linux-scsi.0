From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Sun, 28 Aug 2005 18:13:30 -0400
Message-ID: <4312370A.5070707@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>	 <20050823154232.GA3464@us.ibm.com> <430BBBBE.4070408@adaptec.com>	 <430E1CB1.1050108@s5r6.in-berlin.de> <430E24AB.2060002@pobox.com>	 <430F46AA.2050305@adaptec.com> <1125076960.5079.61.camel@mulgrave> <430F5C8F.3030708@adaptec.com> <430F63EA.7020400@pobox.com> <430F6F89.8040503@adaptec.com> <430FC452.70604@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:41865 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751033AbVH2Anb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Aug 2005 20:43:31 -0400
In-Reply-To: <430FC452.70604@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <jejb@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 08/26/05 21:39, Jeff Garzik wrote:
> Luben Tuikov wrote:
> 
>>On 08/26/05 14:48, Jeff Garzik wrote:
>>
>>
>>>>No host numbers, no routing information.  This is all
>>>>transparent to SCSI Core, and NONE of its business.
>>>
>>>Routing is an essential part of the SCSI core's duties.
>>
>>
>>[I'm not a big fan of reading mixed-message emails, but what can you do...]
>> 
>>
>>
>>>The SCSI core is the resource manager responsible for routing messages 
>>>[CDBs] to/from LLDs based on <scsi-specific device address>.  This 
>>>includes resolution of kernel-specific identifiers (device major/minor, 
>>>etc.) into <s.s.d.a.>.  This also includes direct use of 
>>
>>
>>This particular is the task of sd.c.  How it does it is
>>sd.c. job.  Not SCSI Core.
> 
> 
> No.  sd, sr, st, and sg all use the -common- infrastructure to execute 
> tasks and return results.  That common infrastructure is part of the 
> SCSI core.
> 
> The SCSI layer itself is a marraige between
> 
> 	device classes -- sd, sr, st, sg
> 	transport classes -- common per-transport code
> 	drivers -- executes tasks via transport class
> 	glue -- the myriad functions that tie the above 3 together

Yes, this is the current infrastructure and is quite messy without
clear separation between layers.

SCSI layer should sit above any transport specific layer and should
have no knowlege about the transport specifics.  Read SAM.
 
> All transport-specific knowledge that is common across hardware vendors 
> should be in the transport class.

First, there is no such thing as "transport specific knowlege common
accross vendors" -- maybe you mean same-transport, different vendor?

Yes, this is what I'm driving at: same-transport, same transport-layer,
different vendors, *but* clear separation between them:

FS/user >> Block/char >> Command set drivers >> SCSI Core >> transport layer >> LLDD/transport >> interconnect >> physical world.

"Transport layer" is *not* James B's transport class, because it, transport
class, falls short of representing the specific concepts that a transport
may have.  Case in point: SAS.

I'd suggest looking at those figures:
SAM4r02, page 2, Figure 1 and Figure 2.
SPC4r00, page 1, Figure 1.
SAS1r09, page 33, Figure 10 -- yellow highlight is what should be SCSI Core.

>  The SCSI core uses the transport 
> class to perform transport-specific actions.

And it should absolutely not.  Because the layering infratructure would be broken
then.   Or would SCSI Core know about every transport there is.
Transport specific actions should be performed only by the transport
layer, which sits _below_ SCSI Core.

> The SCSI core is the common point for exporting bus topology via 
> transport classes.

Which is again: wrong.

A transport implementation sits below SCSI Core and exports
topology info in a unified way for all vendors implementing
a transport.

>>>Moving away from HCIL requires a lot of thought, including thinking 
>>>about userland app breakage -- a big deal in Linux.
>>
>>
>>I never contended that userspace should be moved away from HCIL.
> 
> 
> Then, by implication, SAS and FC must continue to maintain HCIL<->device 
> maps.

And I repeat: those should be done by SCSI Core, simply because:
	- They (HCIL) are _invented_ by SAS and FC and USB and Firewire, etc.
	- They (HCIL) are crud which only SCSI Core requires.

> SAM is already mostly there.  ->queuecommand is already a pretty good 
> execute_task().

Jeff *do not spread FUD*!  SCSI Core doesn't know about SAM to save its
life!

The situation hasn't changed one bit for the last 5 years!

There are no TMF implementions, the layering infrastructure is wrong, etc, etc.

>>Most easily this would be done by implementing a bunch of
>>new-way-to-do-it functions.  The request_queue wouldn't care,
>>and old LLDD can use the old interface, and new ones can use
>>the new interface.
> 
> 
> Disagree.  Just follow the TODO list Christoph outlined, plus figure out 

Christoph was asking me if that list was ok -- just to be clear.

> how to handle SG_IO and /dev/sg sanely.
> 
> We don't need yet more
> 
> 	if (new way) {
> 		...
> 	} else {
> 		...
> 	}
> 
> code blocks :)

Hmm, no.  There will never be one such block.  The new way and
the old way will be completely unaware of each other.  Once a
transport layer starts registering SCSI domain devices with the
new SCSI Core, it will just "go" from there.

_Plus_ it will be so much _shorter_ and straightforward.

> HCIL addressing gunk largely belongs in SPI transport class, along with 
> scsi_scan_host()

SPI transport _layer_ will handle finding devices on the SPI domain.
It then registers those with SCSI Core *in no different way* than
SAS or USB or FC or Firewire would register them.  Then SCSI Core
sticks to SPC and does LU discovery, request_queue set up (or whatever),
and announces the LUs to the Command set drivers.  (Look at the figures
I mentioned above.)

> [each transport class should build its own topology].

Agree.

> This achieves the result you want to achive:  new-way-to-do-it functions 
> live in the SAS and FC transport classes (with generic code in generic 
> SCSI layer), old-way-to-do-it HCIL functions live in the SPI transport 
> class.

James B's "transport classes" are completely *orthogonal* to "transport layer".

That is, they have no intersection, thus they are unaware of each other,
and can coexist.

The reason for this is that "transport classes" fall short in _any_way_.

Transport layers are so diverse, that it is impossible to unite them in
a single specific way: from Firewire to USB to iSCSI: Talk about domain
discovery, error handling, etc, etc, etc.

E.g. just think about iSCSI and you'll see whant I mean: try to disect
it and you'll see the layering and how it _does_ fit with SAM, and then
maybe you'll see what I mean.  The same applies to Firewire and USB,
and FC and SAS and whatever.

James B's "transport class", not following any spec or document, is for
exporting _attributes_, not for actually _managing_ a transport.
	1. It doesn't follow (but breaks!) all layering statutes set forth
	   in documents like SAM.
	2. It is a single implmentation supposed to unite many diverse transports.
	   There is just *no way* this can happen.

>>No, no transport specific -- I repeat again: the whole point is to move
>>away from "transport specific".  _SCSI_Core_can invent an HCIL label for them,
>>not LLDD as they currently do.
> 
> 
> You will never be able to eliminate transport-specific code.  That's the 

Eh, well, now you're talking!

So in effect, we stand on _completely_ different bases.

You think that "never be able to eliminate transport-specific code" in SCSI
Core, and I think that I can.  (Maybe already have?)

There is a lot of things which SCSI Core does right now, some of those
in not so graceful way, but most of it is good.

> whole point of transport classes:  encapsulate common transport code.

You have to be more specific: "encapsulate common transport code":
is this across transports or per transport?

Either way: the layering infra is broken -- it'll just never work.
 
> Call it a transport library, rather than a class, if "class" gives 
> people the shivers.
> 
> Example:  I have access to SAS+SATA host controllers from Adaptec and 
> Company X.  Both are largely software-based, directly controlling the 
> PHY ports and manually performing all SAS+SATA discovery.
> 
> I would expect that adaptec_sas and companyx_sas drivers would share 
> transport-specific code via the ata_transport and sas_transport classes.

Sure!  If company_X's LLDD can generate 3 basic events, plus
has a SAM Execute Task and TMF entry points, the SAS Layer would
do port management, discovery, revalidation, etc, etc, for all
devices on the domain.

Plus from userspace (or from the kernel) you'll be able to
"point" to a device and send an (SMP) request and get an (SMP)
response.

	Luben

