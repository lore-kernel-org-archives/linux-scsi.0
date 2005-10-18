From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Adaptec SAS integration notes
Date: Tue, 18 Oct 2005 16:16:32 -0400
Message-ID: <43555820.4000106@pobox.com>
References: <20051014180615.5604.qmail@web31808.mail.mud.yahoo.com> <43552650.2090104@pobox.com> <43554D43.7010704@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:922 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751485AbVJRUQi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Oct 2005 16:16:38 -0400
In-Reply-To: <43554D43.7010704@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: ltuikov@yahoo.com, linux-scsi@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, linux-ide@vger.kernel.org

Luben Tuikov wrote:
> On 10/18/05 12:44, Jeff Garzik wrote:
>>Wrong.  DMA boundary is a trivial counterexample.
> 
> 
> I've addressed DMA boundary in another email which I posted 2 hours ago
> to this list.
> 
> Our controller has no limitation as to DMA boundaries.  All 64 bit space
> is fair game.  There is also no sg list size limitation.

These are an Adaptec-only assumptions, at the present time.

The DMA boundary, s/g stuff etc. are there for the LLDD to communicate 
that to the SCSI and block layers that need that info.

Once you encounter non-Adaptec hardware with limitations on these 
details, you'll either be forced to reinvent the wheel, duplicating this 
stuff, or backtrack and use the scsi-host-template as it was intended to 
be used.


> For this reason I did not overengineer the code.
> 
> Adding HW specific stuff is trivial.  In fact I'll add it to my code
> today and update the code.
> 
> The aic94xx code does include it: struct hw_profile { ... }; embedded in
> struct asd_ha_struct { ... };  See drivers/scsi/aic94xx/aic94xx_hwi.h.
> 
> Exactly the same concept applies to struct sas_ha_struct { ... };.
> I'll embed struct hw_profile { ... }; into it later today.  sg lists
> max lengths, DMA maps, would be there (all ~0).

No.  This would simply be duplicating more of the SCSI core, because you 
don't like scsi-host-template.


>>>What it actually means, as the name _also_ suggest is a device on
>>>the domain, which is transport addressible.  See SAM chapter 4 and 5.
>>
>>
>>I'm discussing the topic at hand at a higher level than SAM.
> 
> 
> Can you give us a reference to this "higher level than SAM"?
> I'd like to read about it.

<shrug>  Any literature on messaging, networks, and RPC.

Block layer, and Dragonfly BSD concepts are along these lines.


>>>You cannot care about "remote" ports -- some types of device have _no_
>>>port layer, as well you only care about the port "half" on your end.
>>>SAS is quite clear on that.
>>
>>Remote ports deals with the other half of the connection.  You gotta 
>>deal with it somewhere.
> 
> 
> I do deal with it.  Just look at the code and how it shows you the
> ports that have been formed (from Announcement 1 at 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112629509826900&w=2)

The quoted part you deleted was referring to the existing SAS transport 
class, unless I'm completely lost in this thread.


>>>>* very poor SATA interface
>>>
>>>
>>>Hmm, no sorry, I'm not going to accept the BS FUD, generalized
>>>comment.
>>
>>
>>If it doesn't interface with libata, the current SATA interface, then 
>>the code needs improvement.  Its a statement of fact.
> 
> 
> Aaah, _that's_ what you meant. "If it doesn't use my code, it bad code."

If it duplicates SCSI<->ATA translation, and ignores existing kernel 
facilities...


>>>Look, I've even included comments on how to integrate the code with
>>>a SATL (which libata is _not_, but it does implement some SATL tasks).
>>>
>>>I know that you're pushing for libata-scsi to become SATL, but this
>>>is hard when your devices belong to a port in an _array_.
>>
>>
>>I've simply stated that there will not be more than one SCSI<->ATA 
>>simulator in the kernel.
>>
>>All implementation decisions trickle down from that overall path.
> 
> 
> And you're forcing libata-scsi to be SATL which it is currently not.

I'm describing the path that needs to be taken, moving forward.


>>SAM is ultimately message passing RPC over a network.
> 
> 
> While I understand what you mean, according to the Abstract it is:
> 
> 	"This standard specifies the SCSI Architecture Model.
> 	The purpose of the architecture is to provide a common
> 	basis for the coordination of SCSI standards and to specify
> 	those aspects of SCSI I/O system behavior that are independent
> 	of a particular technology and common to all implementations."
> 
> Not all transports would be a "network".  Anyway this isn't important
> to the tasks at hand.

It's quite important.

SAS is networking -- we have packets, we have routing.


>>>>* Using scsi_scan_target() would allow us to use the normal LUN scan
>>>
>>>
>>>Again not my code.  Normal LUN "scan" is done through REPORT LUNS
>>>as shown in sas_discover.c as I posted both functions to this list
>>>in a recent email.
>>
>>
>>SCSI core does REPORT LUNS, so we should use that.
> 
> 
> HCIL.

That's a reason to work with the SCSI layer to update it, not work 
around it.


>>>>* Avoid writing a separate SMP driver for now, and see how things
>>>>shake out with future SAS+SATA hardware.
>>>
>>>
>>>No such intentions.  SMP should not be in a separate driver.
>>>For SMP you need _addressing_ and the solution to this problem
>>>has been showin in driver/scsi/sas/README and in the announcement
>>>emails to linux-kernel and linux-scsi here:
>>>http://linux.adaptec.com/sas/
>>
>>
>>As I said above, this entire thread is talking about your code, and how 
>>it will integrate into the upstream kernel.  There is little value in 
>>repeatedly posting a URL to code we're already discussing.
> 
> 
> Well, in all honesty and actuallity the code has already been integrated
> and it works.  The link is here:
> http://linux.adaptec.com/sas/

How many times are you going to post this link in each message?


>>>libata is two layers: SATL and HW interface -- given ata_port and how
>>
>>Obviously.  ls(1) would have told you that:
>>
>>[jgarzik@pretzel sas-2.6]$ ls drivers/scsi/libata*.c
>>drivers/scsi/libata-core.c  drivers/scsi/libata-scsi.c
>>
>>The hardware interface is separate from the SCSI simulator.
> 
> 
> The exported to the kernel ata_scsi_queuecommand() defined in
> libata-scsi.c dereferences struct ata_port.
> 
> That is, if, say SAS Transport Layer wanted translation for
> a SATA device it would have to conjure up ata_port, which
> would need to be made up.

Again, I'm stating the path to move forward.  Obviously, code changes 
are needed.  Rather than continually pointing to a URL, I'm trying to 
point out where those code changes should occur.

	Jeff


