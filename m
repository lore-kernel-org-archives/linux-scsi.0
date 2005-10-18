From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Adaptec SAS integration notes
Date: Tue, 18 Oct 2005 16:55:44 -0400
Message-ID: <43556150.9030607@adaptec.com>
References: <20051014180615.5604.qmail@web31808.mail.mud.yahoo.com> <43552650.2090104@pobox.com> <43554D43.7010704@adaptec.com> <43555820.4000106@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43555820.4000106@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: ltuikov@yahoo.com, linux-scsi@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/18/05 16:16, Jeff Garzik wrote:
>>Our controller has no limitation as to DMA boundaries.  All 64 bit space
>>is fair game.  There is also no sg list size limitation.
> 
> 
> These are an Adaptec-only assumptions, at the present time.
> 
> The DMA boundary, s/g stuff etc. are there for the LLDD to communicate 
> that to the SCSI and block layers that need that info.
> 
> Once you encounter non-Adaptec hardware with limitations on these 
> details, you'll either be forced to reinvent the wheel, duplicating this 
> stuff, or backtrack and use the scsi-host-template as it was intended to 
> be used.

Not so.  Since the architecture is cleanly _layered_, it is very
simple to add struct hw_profile { ... } to struct sas_ha_struct
and "move forward".

As I said I didn't want to overengineer.

The SCSI Host template is Parallel SCSI structure invented
when there was a need for it, over 10 years ago.  It (host
template) completely mixes up hw limitations, SCSI Core
concepts and Protocol (Parallel SCSI) into a single
list of variables and function stubs.

struct sas_ha_struct and struct asd_ha_struct show how
you can have a separate structure (object?) to express
what is needed: hw limitations, software presentations,
etc.  See how struct hw_profile is embedded into
asd_ha_struct ?  Similarly for struct sas_ha_struct.

Again, look at USB storage and SBP code to see how the concept
is the same.

In open source there is no such thing as "xyz was intended to
be used".  This is all about innovation, and "moving forward"
as far as technology is concerned.

>>Exactly the same concept applies to struct sas_ha_struct { ... };.
>>I'll embed struct hw_profile { ... }; into it later today.  sg lists
>>max lengths, DMA maps, would be there (all ~0).
> 
> 
> No.  This would simply be duplicating more of the SCSI core, because you 
> don't like scsi-host-template.

It has nothing to do with "like".  It has to do with what is the
host template and what is the interconnect driver.

The interconnect driver, aic94xx, is not a SCSI host, thus
it cannot be represented as struct scsi_host_template.

The SCSI Host abstraction is achieved by and in the SAS
transport Layer, in exactly the same way it is done
in USB Storage and in the SBP code.

Such concepts are not new Jeff, and there is no reason to
force struct scsi_host_template into aic94xx, while it has
been shown that it doesn't need it since it is not
a SCSI Host to begin with.  This is clearly shown
in the code, currently working just fine:
http://linux.adaptec.com/sas/

aic94xx is a PCI driver providing access to certain
type of interconnect.

The SAS Transport Layer provides the SCSI Host abstraction.

What all this accomplishes is clearly exposed and separated
layer: an interconnect and Transport.

That is, it is possible for another entity to want to
control the Host Adapter (aic94xx) using the struct sas_ha_struct 
_directly_.

Currrently the only other such entitty is SCSI Core via
sas_scsi_host.c file glue (996 lines), it (SCSI Core) doesn't
necessarily have to be the only one.

There is a clear example of another entity which may want
such low level control, but this a different topic.

All in all, if you would like to put the SCSI Host template
in aic94xx, so that James B officially accepts the code into
scsi-misc-2.6, so be it.  I just want to make the technical
objection known into this list and the archives.

>>>>What it actually means, as the name _also_ suggest is a device on
>>>>the domain, which is transport addressible.  See SAM chapter 4 and 5.
>>>
>>>
>>>I'm discussing the topic at hand at a higher level than SAM.
>>
>>
>>Can you give us a reference to this "higher level than SAM"?
>>I'd like to read about it.
> 
> 
> <shrug>  Any literature on messaging, networks, and RPC.
> 
> Block layer, and Dragonfly BSD concepts are along these lines.

You seem to talk about "higher level than SAM" and then
you mention that getting rid of HCIL is long term.

While getting rid of HCIL is straightforward and we
can postpone those "higher level than SAM" concepts
for later.

>>>>You cannot care about "remote" ports -- some types of device have _no_
>>>>port layer, as well you only care about the port "half" on your end.
>>>>SAS is quite clear on that.
>>>
>>>Remote ports deals with the other half of the connection.  You gotta 
>>>deal with it somewhere.
>>
>>
>>I do deal with it.  Just look at the code and how it shows you the
>>ports that have been formed (from Announcement 1 at 
>>http://marc.theaimsgroup.com/?l=linux-scsi&m=112629509826900&w=2)
> 
> 
> The quoted part you deleted was referring to the existing SAS transport 
> class, unless I'm completely lost in this thread.

In this case I must've assumed that you were talking about my code,
while in fact you were talking about the "SAS Transport attributes",
which do not follow SAS but are FC-like.

Unless I am also completely lost in this thread. ;-)

>>>If it doesn't interface with libata, the current SATA interface, then 
>>>the code needs improvement.  Its a statement of fact.
>>
>>
>>Aaah, _that's_ what you meant. "If it doesn't use my code, it bad code."
> 
> 
> If it duplicates SCSI<->ATA translation, and ignores existing kernel 
> facilities...

Well, I've pointed out numerous times why libata-scsi.c isn't
quite SATL.  I'm not sure if I should repeat myself for a
5th time.

It would take an insurmountable effort to change libata-scsi.c
to become SATL, after which only the top comment would be
left.  Judging from your comments, am I assuming incorrectly that
this is the intention?

Also wouldn't it be more logical to call the file "satl.c" since
this is exactly what it provides?

>>>All implementation decisions trickle down from that overall path.
>>
>>
>>And you're forcing libata-scsi to be SATL which it is currently not.
> 
> 
> I'm describing the path that needs to be taken, moving forward.

Again higly subjectively, Jeff.

>>>SAM is ultimately message passing RPC over a network.
>>
>>
>>While I understand what you mean, according to the Abstract it is:
>>
>>	"This standard specifies the SCSI Architecture Model.
>>	The purpose of the architecture is to provide a common
>>	basis for the coordination of SCSI standards and to specify
>>	those aspects of SCSI I/O system behavior that are independent
>>	of a particular technology and common to all implementations."
>>
>>Not all transports would be a "network".  Anyway this isn't important
>>to the tasks at hand.
> 
> 
> It's quite important.
> 
> SAS is networking -- we have packets, we have routing.

Not all transports would be a "network".  Again this isn't important
to the tasks at hand.

I've numerous times explained why a SAS Domain isn't quite a
"network" a lot less "Ethernet-like".

>>>>>* Using scsi_scan_target() would allow us to use the normal LUN scan
>>>>
>>>>
>>>>Again not my code.  Normal LUN "scan" is done through REPORT LUNS
>>>>as shown in sas_discover.c as I posted both functions to this list
>>>>in a recent email.
>>>
>>>
>>>SCSI core does REPORT LUNS, so we should use that.
>>
>>
>>HCIL.
> 
> 
> That's a reason to work with the SCSI layer to update it, not work 
> around it.

Create scsi_domain_device { ... }; ?

>>Well, in all honesty and actuallity the code has already been integrated
>>and it works.  The link is here:
>>http://linux.adaptec.com/sas/
> 
> 
> How many times are you going to post this link in each message?

Not sure.  Jeff, do you personally object to my postig this link, which
contains a working kernel with SAS Transport Layer and aic94xx?

>>>>libata is two layers: SATL and HW interface -- given ata_port and how
>>>
>>>Obviously.  ls(1) would have told you that:
>>>
>>>[jgarzik@pretzel sas-2.6]$ ls drivers/scsi/libata*.c
>>>drivers/scsi/libata-core.c  drivers/scsi/libata-scsi.c
>>>
>>>The hardware interface is separate from the SCSI simulator.
>>
>>
>>The exported to the kernel ata_scsi_queuecommand() defined in
>>libata-scsi.c dereferences struct ata_port.
>>
>>That is, if, say SAS Transport Layer wanted translation for
>>a SATA device it would have to conjure up ata_port, which
>>would need to be made up.
> 
> 
> Again, I'm stating the path to move forward.  Obviously, code changes 
> are needed.  Rather than continually pointing to a URL, I'm trying to 
> point out where those code changes should occur.

Ok, so how do you think libata-scsi.c should change to support SATL?

I think that you need to have code which, say, exports only 2 functions.
One to register the SATA device to be translated for, the other
to unregister.  Thus any entity could register a translation service.
All other functions are filled in from both layers (registrant and registrar)
depending on their capabilities and the type of SATA device.

If you take a look at the design of the SAS Transport layer it does
exactly this: only 2 functions are exported to the kernel and everything
else is filled in the struct sas_ha_struct at the time of registering
the host adapter -- filled in by the LLDD and by the SAS Transport Layer.

This design is coherent.

Exporting 1e9 functions into the kernel is questionable.

What do you think?

	Luben
-- 
http://linux.adaptec.com/sas/
