From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Adaptec SAS integration notes
Date: Tue, 18 Oct 2005 12:12:40 -0400
Message-ID: <43551EF8.8080309@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7AED@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:25222 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1750892AbVJRQMr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Oct 2005 12:12:47 -0400
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7AED@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: ltuikov@yahoo.com, jgarzik@pobox.com, linux-scsi@vger.kernel.org, andmike@us.ibm.com, James.Bottomley@steeleye.com, hch@infradead.org, linux-ide@vger.kernel.org

On 10/15/05 10:21, James.Smart@Emulex.Com wrote:
>>>* Adaptec SAS abuses Scsi_Host_Template.  The host template 
>>
>>is a set of
>>
>>>ops for various layers, and it is fine as an interface.  No need to
>>>avoid it.
>>
>>Neither the Host Adapter, nor the FW, implements anything which has
>>to do with the scsi host template.  What the Host Adapter 
>>(the hardware) and
>>the FW implement is access to the transport -- that' all.
>>
>>So in effect the LLDD is _access to the (SAS) transport_. Cf. 
>>the USB Storage
>>code and SBP code.
>>
>>Putting the host template back into the LLDD is a step 
>>_backwards_, i.e.
>>it's just a workaround, not a step forward.
> 
> 
> This statement absolutely amazes me....
> 
> Your first comment "Host Adapter, nor the FW ..." is true of every
> adapter.
> 
> The job of a Device Driver is to map between the interface presented
> by the Host Adapter/FW and the interfaces of the host os. This is true
> of whatever the technology is - SCSI, Ethernet, rs232, whatever.

I understand that a lot of vendors have legacy drivers which they'll
try to reuse for SAS.  This is fine -- they'll fit in as they've
always had.

But for newer hardware, you cannot muzzle it up as has been done,
until now.  We need to use its potential fully, as is shown in the
SAS Transport Layer code: domain discovery, domain presentation,
addressablity, etc.

USB Storage, SBP, etc. transport layers have shown the way to follow.
The reason for this is that the Storage Protocol and the interconnect
can be completely non-related: e.g. USB Storage.

> As the current design of the scsi subsystem has SCSI-hba's attaching
> via the host template - of course the LLDD will contain the host
> template.

Other members of the community have addressed this too and shown
that it is not necessary for this to be the case.

Separating those layers: SCSI Core's host template and the
interconnect driver gives you, I've said this before,
_layer intersection_.  This is most apparent for USB, as
well as for SAS, whereby you can communicate with an expander
accessing the interconnect driver (layer), or you can communicate
with a SCSI device/LU at SCSI Core level (layer).

> So - if you want to change this there are only 2 options:
> A) Change the scsi subsystem LLDD interface
> B) Work within the existing scsi subsystem hba interface

Yes, I understand the need to support legacy.  Although
A) would give some LLDDs heart attack and others would be
impossible to convert.
B) gives us the same old infrastructure, which to current
technology is incomplete.

An option C would be to create scsi_domain_device { ... };
and to start using this and its interface so that newer
Layers and LLDD are smaller and more straightforward.

> As this list has repeatedly stated:
> 
> If you choose to do A :
>   As you are the one motivated for change, you better be able to 
>     back it up by effort (aka the coding).

I don't mind coding.  The problem is that it would not necessarily
be accepted into the kernel.

adp94xx didn't get accepted because Discovery was in the LLDD,
and the community wanted it common.  It is common now, but in
due time MPT-like drivers came out with SAS, which has different
layering, and all of a sudden there "Discovery common" is no longer
a criterium for kernel acceptance.

>   The resulting work had better:
>     Support the midlayer and above to the same extent that
>       the existing LLDD interface does.

So then why do you need the "motivated change"?

>     Be extensible to other LLDDs.
>       Minimally this means at least 2 LLDDs.
>       In the best world, this means any LLDD, supporting any
>         type of transport.
>       And what better way to prove extensible than by providing
>         an example!  (a 2nd LLDD)

USB/SBP/SAS are layers.  Their LLDDs are the interconnect drivers.
Does this satisfy?

If Jeff starts work on BCM8603, that interconnect LLDD can also
use the SAS Layer.

USB as SBP as SAS is just a transport/interconnect -- there is
nothing about LUs in them or about host templates.

>   As this is "new" and unproven, expect this work to evolve 

"unproven" -- I see you've already made up your mind.
"expect this to work" -- you can find a working
driver here: http://linux.adaptec.com/sas/ .

>     outside of the upstream kernel (in a parallel git tree).
>     It integrates upstream only when it is generally accepted by
>     the community that it meets the requirements of midlayer 
>     support and extensibility.

IOW, nothing constructive.

BTW, Christoph and Jeff have mentioned that the code is good
and easy to follow, etc.

> If you choose B :
>   You are free to partition the implementation of your driver
>     in any way you want, which can include an upper "layer" that
>     contains the host template, but no hardware/fw knowledge,
>     leaving that for lower "layer".

Pure hw knowlege can be exported in a hw only struct.
Similarly how this is done by the struct hw_prof { ... };
which is embedded into struct asd_ha_struct { ... };
as is shown in the aic94xx LLDD.

Similarly, hw only knowlege can be exported to the
upper layer in struct hw_profile { ... }; (non-existing)
to be embedded into struct sas_ha_struct { ... } (existing).

The reason I didn't include it is because our controller
doesn't quite have hw limitations, as the common sg limits,
or DMA limits, etc.

>   And if other drivers can reuse those layers - great.

Yes they can.

As history shows, implementations start with a layer
and one driver.  As time goes by, more and more interconnect
LLDDs would be written to use the interface, domain discovery
etc.  Like say the BCM8603 chip.

>   Two thoughts to remember though:
>     This really is a driver implementation choice, not a mandated
>       "Specification" choice.  It may or may not be, for various
>       reasons, be based on an example in an external specification.
> 
>     Every layer in the driver makes an expectation on what can
>       and cannot be done at that level. It is truth that
>       different adapters will have hardware/FW interfaces with
>       different capabilities. Not all adapters may align well with
>       all layers. Thus, the best re-use scenario is one
>       in which the layers are selectable, not all mandated.

I completely agree with selectable layers.   As you can see
I do _not_ try to push the SAS Transport Layer on other SAS
implementations, e.g. MPT.  One of the reasons is the difference
in technology and layering and the other is the freedom you get
with open source.

>     For it to become part of the upstream kernel, it must meet a
>       "style" that is acceptable to the community, as you will not
>       be the only one that will attempt to support the driver.

Such stipulation has to be more constructive and specific.  For
example, when adp94xx was posted, the community wanted common
tasks to go to a common place.  SAS Transport layer + aic94xx
does this, but the community "style" has changed over the course
of the 8 months, so we have this situation now.

As Christoph and Jeff have already mentioned, the code is clean,
straightforward, easy to follow.

The best bet is for you to read the code itself.

Just think about this this: All of the SAS Layer exports _only two_
functions into the kernel -- only TWO.  All the while it implements
domain discovery, port management, etc, etc.

>>Before we start messing with what you suggest above, SCSI Core has a
>>_long_ way to go.
>>
>>(BTW, we're already doing this.)
> 
> I assume from this statement, you are creating an implementation for A.

No.  Jeff was mentioning something about addressability of HAs, I guess
from Doug's mentioning of OBDs.  Either way none of those are related.

What I meant to say is that HA are addressable out on the domain, say
if you want to be a target, you are addressable and initators on the
domain can address you.

Internally (in the kernel) HA are addressable by the devices they
give to the kernel, not by an opaque token.  That is, read from
device X, and the kernel knows how to do it.

A SAS HA is not a network device after all.

> Not quite true - you actually care about the other "half" as well. In other
> words, is it a SSP Target, etc.  If you start interacting (sending i/o)
> with that other half - of course you care about it.  There are functional
> levels that will care about phy's, and other functional levels that care
> about ports.

James you can access devices with which you *do not* form a port.
Think about that.

> IMHO - if you're going to ask for "specific" answers, replies, etc,
> the best way to obtain that is to lead by example....  These words
> provide no value.

Indeed they do not provide any value.

Jeff's email didn't even specify which SAS code was being addressed,
in his bulletpoints.  Was it the "transport attributes" or was it the
SAS Transport layer -- in this respect it was extremely vague
email.

>>A true SAM layer would be *much* _smaller_ and would have a more
>>straightforward path for tasks. (as does the SAS layer)
> 
> IMHO - rarely does expectations meet reality when you go to truly
> make it work. Consider CAM and CAM-3, both are SAM-based scsi

Have you taken a look at the SAS Transport Layer code yet?

> core implementations. [granted, it all depends on where you set
> your boundaries]

I agree with this statement about where one should set their
boundaries.  

Leonardo Da Vinci said that they should be set slightly higher
than one thinks attainable.

> FYI - in looking at SAS-1.1, I see nothing that describes LUN scanning.

Indeed -- it is completely not the job of SAS (or USB or SBP for that
matter) to specify LUN scanning -- this is SAM/SPC issue.

I never claimed that SAS specifies how to do it.  The reason I do it
in sas_discover.c is so that I can register LUs with SCSI Core,
since SCSI Core has no concept of SCSI domain devices as
is shown in my comment in sas_discover.c:

/**
 * sas_do_lu_discovery -- Discover LUs of a SCSI device
 * @dev: pointer to a domain device of interest
 *
 * Discover logical units present in the SCSI device.  I'd like this
 * to be moved to SCSI Core, but SCSI Core has no concept of a "SCSI
 * device with a SCSI Target port".  A SCSI device with a SCSI Target
 * port is a device which the _transport_ found, but other than that,
 * the transport has little or _no_ knowledge about the device.
 * Ideally, a LLDD would register a "SCSI device with a SCSI Target
 * port" with SCSI Core and then SCSI Core would do LU discovery of
 * that device.
 *
 * REPORT LUNS is mandatory.  If a device doesn't support it,
 * it is broken and you should return it.  Nevertheless, we
 * assume (optimistically) that the link hasn't been severed and
 * that maybe we can get to the device anyhow.
 */
static int sas_do_lu_discovery(struct domain_device *dev)
{
	...

> What I do see are things that state "may be" a SCSI Domain or SCSI
> Device - and use a general "see SAM-3" as a reference. No where
> do I see the spec stating that a SCSI Device "shall" be a SCSI Device
> as defined by SAM-3.

Nowhere do I claim any such things.

> Example: please look at the definition of "SCSI Target Device" and
> see if that definition could not apply to a SAM-1, or even a SCSI-2
> device.
> 
> It should be evident what I'm highlighting. The spec is not as literal
> as your convictions. It may not be appropriate to base things on the
> literal assumptions.

No assumption here.

It is all about insight: where is storage moving to and where it
is going.  Thus, what changes are needed in Linux SCSI Core in
order to make it a Storage OS of choice.

Customers want to use Linux for their storage needs.
Vendors try to provide this.  Linux needs some long-needed
advancements.  Again, such advancements are not pushed
for everyone to use -- it is at the discretion of the
other LLDD writer to decide -- freedom of open source
as I mentioned above.

	Luben
-- 
http://linux.adaptec.com/sas/
