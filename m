From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Adaptec SAS integration notes
Date: Tue, 18 Oct 2005 12:44:00 -0400
Message-ID: <43552650.2090104@pobox.com>
References: <20051014180615.5604.qmail@web31808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:920 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750810AbVJRQoL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Oct 2005 12:44:11 -0400
In-Reply-To: <20051014180615.5604.qmail@web31808.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: linux-scsi@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>, Luben Tuikov <luben_tuikov@adaptec.com>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, linux-ide@vger.kernel.org

Luben Tuikov wrote:
> --- Jeff Garzik <jgarzik@pobox.com> wrote:
> 
> 
>>Problems (with both Adaptec SAS and existing kernel)
> 
> 
> Jeff, you've got to be _specific_ in your specifying to _which_ group
> those problems pertain to.  Saying "both Adaptec SAS and existing kernel"
> is very vague.

You are supposed to know when I am referring to the upstream kernel, and 
when I am referring to your code :)  Logically, if I'm not talking about 
updates your code needs, I am talking about updates the core kernel needs.


>>* Adaptec SAS abuses Scsi_Host_Template.  The host template is a set of
>>ops for various layers, and it is fine as an interface.  No need to
>>avoid it.
> 
> 
> Neither the Host Adapter, nor the FW, implements anything which has
> to do with the scsi host template.

Wrong.  DMA boundary is a trivial counterexample.


>>* struct domain_device ultimately means "an RPC message destination",
> 
> 
> Depends on your technial background.
> 
> What it actually means, as the name _also_ suggest is a device on
> the domain, which is transport addressible.  See SAM chapter 4 and 5.

I'm discussing the topic at hand at a higher level than SAM.


>>and I'm not convinced it is a useful abstraction.  Further, if people
>>choose to introduce this abstraction, the implementation of such should
>>be far more widespread.
> 
> 
> You must've seen latest emails between me and James B on linux-scsi
> mailing list.  We both seem to agree (James correct me if I'm wrong)
> that a struct scsi_domain_device { ... }; would be the proper
> way to go next.  It doesn't exist yet, but it would be really easy to
> create it.  It would also eliminate HCIL at the _core_.
> 
> SAM tells you what goes in struct scsi_domain_device { ... };.

My overall point is that we would need to convert the device classes and 
SPI transport in order for this to happen.  And I'm still not convinced 
that scsi_domain_device as you have implemented it is a useful abstraction.

There is interface stuff in struct sas_ha_struct that really should move 
to a higher level -- its not SAS-only, and that may be the better interface.


>>* Adaptec SAS could certainly integrate a bit with scsi_transport_sas...
>>not sure if full integration will work:
>>
>>* scsi_transport_sas's sas_rphy_add() digs a bit too deep into
>>discovery.  I would prefer that libsas call scsi_scan_target() as it
>>makes connections.
> 
> 
> This concept was all taken from FC and "implanted" into "scsi_transport_sas".
> And it is wrong.  For proper implmentation see the SAS code:
> http://linux.adaptec.com/sas/

This entire thread is talking about the code at that URL.  No need to be 
self-referential.


> You cannot care about "remote" ports -- some types of device have _no_
> port layer, as well you only care about the port "half" on your end.
> SAS is quite clear on that.

Remote ports deals with the other half of the connection.  You gotta 
deal with it somewhere.


>>* very poor SATA interface
> 
> 
> Hmm, no sorry, I'm not going to accept the BS FUD, generalized
> comment.

If it doesn't interface with libata, the current SATA interface, then 
the code needs improvement.  Its a statement of fact.


> Look, I've even included comments on how to integrate the code with
> a SATL (which libata is _not_, but it does implement some SATL tasks).
> 
> I know that you're pushing for libata-scsi to become SATL, but this
> is hard when your devices belong to a port in an _array_.

I've simply stated that there will not be more than one SCSI<->ATA 
simulator in the kernel.

All implementation decisions trickle down from that overall path.


>>* not sure if SMP really needs a full blown block driver abstraction.
>>Christoph did some experiments and wasn't terribly pleased with what he
>>saw.  I can see his point.
> 
> 
> Apparently this applies to his code not mine.
> 
> This link show how to use SMP:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112629509318354&w=2
> (this is also xlinked from the Adaptec SAS page)
> 
> SMP is NOT block device and will NEVER BE.

In this context, a block device is simply a messaging queue.


>>* existing LUN scan should be fine, with maybe a few tiny tweaks
>>
>>* Consider the problem of SAS vs. SATA, and both Adaptec SAS and libata
>>fighting over who's host struct to use.
> 
> 
> Yeah, I agree with you: the political BS is just overflowing and hitting
> the fan all the time.

Sigh.  I'm talking about implementation details, here.


> How about a drivers/scsi/satl/satl.c which Doug can start writing
> and then we can contribute?

Absolutely not.  Update libata-scsi.


>>* SCSI core already pretty much equates to SAM, even if there is plenty
>>of HCIL dependency in various places (HCIL should get marginalized,
>>as all agree)
> 
> 
> At a concept level yes, at implementation level absolutely no.
> 
> A true SAM layer would be *much* _smaller_ and would have a more
> straightforward path for tasks. (as does the SAS layer)

Important concept:  struct naming and explicit layering based on 
pictures in a spec is not how we want to do development.  We want to 
-think- about the overall issues, and implement in the best manner while 
ensuring the hardware state machine isn't violated.

SAM is ultimately message passing RPC over a network.


>>Solutions
>>---------
>>* Similar to libata drivers, scsi-host-template should be in the LLDD,
>>even if it is filled with mostly generic helper calls.
> 
> 
> Again, see SBP and USB storage code (as well as the SAS code): this would be
> a step backwards not forwards.  A true SAS LLLD has nothing to do with
> the scsi host template.  This abstraction happens at the (SAS/SBP/USB Storage)
> level layer.

A SCSI domain and Linux SCSI host are already pretty close.  There's no 
need to rewrite the world, just because they don't match 100%.


>>* I would tend to prefer calling scsi_scan_target() from SAS discovery
>>code, rather than sas_rhy_add()
> 
> 
> This is apparently not my code.
> 
> The SAS transport _layer_ does complete domain discovery as stipulated in
> SAS 1.1.  (2.0 is out -- I'll be updating things when I come back).

I'm trying to move forward by talking about how your code will integrate 
with the kernel.

Pointing out "that's not my code" is completely irrelevant, and unhelpful.


>>* Using scsi_scan_target() would allow us to use the normal LUN scan
> 
> 
> Again not my code.  Normal LUN "scan" is done through REPORT LUNS
> as shown in sas_discover.c as I posted both functions to this list
> in a recent email.

SCSI core does REPORT LUNS, so we should use that.


>>* Avoid writing a separate SMP driver for now, and see how things
>>shake out with future SAS+SATA hardware.
> 
> 
> No such intentions.  SMP should not be in a separate driver.
> For SMP you need _addressing_ and the solution to this problem
> has been showin in driver/scsi/sas/README and in the announcement
> emails to linux-kernel and linux-scsi here:
> http://linux.adaptec.com/sas/

As I said above, this entire thread is talking about your code, and how 
it will integrate into the upstream kernel.  There is little value in 
repeatedly posting a URL to code we're already discussing.


>>* Put HCIL mapping into top-level helper code, for sharing between FC
>>and SAS (hopefully!)
> 
> 
> One step further: eliminate the ugly legacy SPI-centric HCIL from
> SCSI Core.  Minimise and streamline SCSI Core.

How many times must we repeat:  that's the long term goal.

Rome wasn't built in a day.


>>* use existing struct scsi_lun where feasible
>>
>>* LONG TERM: I wouldn't mind a small "scsi_rpc" helper lib
>>which provided execute_task() hook and other task mgmt functions.
>>Authors could choose to use that interface -- sitting just underneath
>>Scsi_Host_Template -- if their hardware closely matches the pure SAM
>>TMF model.  If hardware doesn't closely match, using this interface
>>will simply lead to a lot of glue/simulation code.  This gets the
>>hardware a bit closer to scsi_execute_req() etc.
> 
> 
> You don't see the _big_ picture: you need a _layer_, not "helper libs".
> This is what Object Oriented Deisign is all about.  SAM is object
> oriented, as is SAS as is iSCSI as is SBP, etc.
> 
> "Helper libs" makes the code ugly and spaghetti like.
> 
> A transport LLDD implments access to the _transport_: take USB, SBP and SAS --
> they all do it.  They need a management transport layer as showin in
> those implementations.
> 
> I know that this is how libata works: "helper libs" but you have to think
> on a larger scale:

Helper lib is another way of saying object-oriented design.  Look closer.


> libata is two layers: SATL and HW interface -- given ata_port and how

Obviously.  ls(1) would have told you that:

[jgarzik@pretzel sas-2.6]$ ls drivers/scsi/libata*.c
drivers/scsi/libata-core.c  drivers/scsi/libata-scsi.c

The hardware interface is separate from the SCSI simulator.

	Jeff


