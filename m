From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Adaptec SAS integration notes
Date: Tue, 18 Oct 2005 15:30:11 -0400
Message-ID: <43554D43.7010704@adaptec.com>
References: <20051014180615.5604.qmail@web31808.mail.mud.yahoo.com> <43552650.2090104@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43552650.2090104@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: ltuikov@yahoo.com, linux-scsi@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/18/05 12:44, Jeff Garzik wrote:
>>Jeff, you've got to be _specific_ in your specifying to _which_ group
>>those problems pertain to.  Saying "both Adaptec SAS and existing kernel"
>>is very vague.
> 
> 
> You are supposed to know when I am referring to the upstream kernel, and 
> when I am referring to your code :)  Logically, if I'm not talking about 
> updates your code needs, I am talking about updates the core kernel needs.

Yes, reading your post it was really unclear which is which -- hopefully
not intentional.

It would've been much better if you had:

Kernel needed updates:
 1)
 2)
 3)
 ... etc.

SAS Transport Layer updates:
 1)
 2)
 ... etc

etc.

Unless of course your message wasn't addressed to engineers of this list.

>>Neither the Host Adapter, nor the FW, implements anything which has
>>to do with the scsi host template.
> 
> 
> Wrong.  DMA boundary is a trivial counterexample.

I've addressed DMA boundary in another email which I posted 2 hours ago
to this list.

Our controller has no limitation as to DMA boundaries.  All 64 bit space
is fair game.  There is also no sg list size limitation.

For this reason I did not overengineer the code.

Adding HW specific stuff is trivial.  In fact I'll add it to my code
today and update the code.

The aic94xx code does include it: struct hw_profile { ... }; embedded in
struct asd_ha_struct { ... };  See drivers/scsi/aic94xx/aic94xx_hwi.h.

Exactly the same concept applies to struct sas_ha_struct { ... };.
I'll embed struct hw_profile { ... }; into it later today.  sg lists
max lengths, DMA maps, would be there (all ~0).

>>What it actually means, as the name _also_ suggest is a device on
>>the domain, which is transport addressible.  See SAM chapter 4 and 5.
> 
> 
> I'm discussing the topic at hand at a higher level than SAM.

Can you give us a reference to this "higher level than SAM"?
I'd like to read about it.

>>SAM tells you what goes in struct scsi_domain_device { ... };.
> 
> 
> My overall point is that we would need to convert the device classes and 
> SPI transport in order for this to happen.  And I'm still not convinced 
> that scsi_domain_device as you have implemented it is a useful abstraction.

I've never implemented struct scsi_domain_device.  Only struct domain_device { }
exists in the SAS code, to represent a domain device on a SAS domain.

BTW, SAM tells you clearly whether "scsi_domain_device" is a "useful abstraction."

> There is interface stuff in struct sas_ha_struct that really should move 
> to a higher level -- its not SAS-only, and that may be the better interface.

Well, you see, as _you_ said: the SAS code is pretty self contained.
I couldn't go and rip the whole SCSI Core apart.

But you are right: TMFs should've been part of SCSI Core long ago.
James B remembers when I was asking for TMF integration into
SCSI Core 3 years ago.

>>http://linux.adaptec.com/sas/
> 
> 
> This entire thread is talking about the code at that URL.  No need to be 
> self-referential.

http://linux.adaptec.com/sas/ ;-)

>>You cannot care about "remote" ports -- some types of device have _no_
>>port layer, as well you only care about the port "half" on your end.
>>SAS is quite clear on that.
> 
> Remote ports deals with the other half of the connection.  You gotta 
> deal with it somewhere.

I do deal with it.  Just look at the code and how it shows you the
ports that have been formed (from Announcement 1 at 
http://marc.theaimsgroup.com/?l=linux-scsi&m=112629509826900&w=2)

Example of a domain:

tree -d /sys/devices/pci0000\:01/0000\:01\:04.0/host11/sas/ha 

/sys/devices/pci0000:01/0000:01:04.0/host11/sas/ha
|-- phys
|   |-- 0
|   |   `-- port -> ../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/ports/0
|   |-- 1
|   |-- 2
|   |-- 3
|   |-- 4
|   |   `-- port -> ../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/ports/1
|   |-- 5
|   |   `-- port -> ../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/ports/1
|   |-- 6
|   |   `-- port -> ../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/ports/1
|   `-- 7
|       `-- port -> ../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/ports/1
`-- ports
    |-- 0
    |   |-- domain
    |   |   `-- 500000e000031c12
    |   |       `-- LUNS
    |   |           `-- 0000000000000000
    |   `-- phys
    |       `-- 0 -> ../../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/phys/0
    `-- 1
        |-- domain
        |   `-- 50001c1716010600
        |       |-- 50001c1071609c00
        |       |   |-- 50001c1071609c02
        |       |   |-- 5000c50000102a65
        |       |   |   `-- LUNS
        |       |   |       `-- 0000000000000000
        |       |   `-- 5005076a000001e0
        |       |       |-- 5000c50000513385
        |       |       |   `-- LUNS
        |       |       |       `-- 0000000000000000
        |       |       |-- 5005076a000001ed
        |       |       |   `-- LUNS
        |       |       |       `-- 0000000000000000
        |       |       `-- 5c50000000409c11
        |       |           `-- LUNS
        |       |               `-- 0000000000000000
        |       |-- 50001c1716010603
        |       |-- 50001c171601060d
        |       |   `-- LUNS
        |       |       `-- 0000000000000000
        |       `-- 5000c50000513329
        |           `-- LUNS
        |               `-- 0000000000000000
        `-- phys
            |-- 4 -> ../../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/phys/4
            |-- 5 -> ../../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/phys/5
            |-- 6 -> ../../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/phys/6
            `-- 7 -> ../../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/phys/7

All three announcements can be found here:
http://linux.adaptec.com/sas/

>>>* very poor SATA interface
>>
>>
>>Hmm, no sorry, I'm not going to accept the BS FUD, generalized
>>comment.
> 
> 
> If it doesn't interface with libata, the current SATA interface, then 
> the code needs improvement.  Its a statement of fact.

Aaah, _that's_ what you meant. "If it doesn't use my code, it bad code."

>>Look, I've even included comments on how to integrate the code with
>>a SATL (which libata is _not_, but it does implement some SATL tasks).
>>
>>I know that you're pushing for libata-scsi to become SATL, but this
>>is hard when your devices belong to a port in an _array_.
> 
> 
> I've simply stated that there will not be more than one SCSI<->ATA 
> simulator in the kernel.
> 
> All implementation decisions trickle down from that overall path.

And you're forcing libata-scsi to be SATL which it is currently not.

The problem is that libata-scsi wasn't written with SATL in mind.
It doesn't present the translation at _device_ level, but at
port level, but the port in libata-core and libata-scsi is a
hw extension, QED.

E.g: int ata_scsi_queuecmd(...) references ata_port which clearly doesn't
exist as far as SATL is concerned.  Furthermore ata_port is a hw extension
which is used in libata-core.c.

Let me repeat: you need to have code which, say, exports only 2 functions.
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

>>SMP is NOT block device and will NEVER BE.
> 
> In this context, a block device is simply a messaging queue.

You are forgetting the definition of a block device.

SMP is not a block device, because (please fill in):
	1) ...
	2) ...

The SMP access implementation in the SAS Transport layer
gives you most of what you need, it is short and sweet:


/* ---------- SMP portal ---------- */

static ssize_t smp_portal_write(struct kobject *kobj, char *buf, loff_t offs,
				size_t size)
{
	struct domain_device *dev = to_dom_device(kobj);
	struct expander_device *ex = &dev->ex_dev;

	if (offs != 0)
		return -EFBIG;
	else if (size == 0)
		return 0;

	down_interruptible(&ex->smp_sema);
	if (ex->smp_req)
		kfree(ex->smp_req);
	ex->smp_req = kzalloc(size, GFP_USER);
	if (!ex->smp_req) {
		up(&ex->smp_sema);
		return -ENOMEM;
	}
	memcpy(ex->smp_req, buf, size);
	ex->smp_req_size = size;
	ex->smp_portal_pid = current->pid;
	up(&ex->smp_sema);

	return size;
}

static ssize_t smp_portal_read(struct kobject *kobj, char *buf, loff_t offs,
			       size_t size)
{
	struct domain_device *dev = to_dom_device(kobj);
	struct expander_device *ex = &dev->ex_dev;
	u8 *smp_resp;
	int res = -EINVAL;

	/* XXX: sysfs gives us an offset of 0x10 or 0x8 while in fact
	 *  it should be 0.
	 */

	down_interruptible(&ex->smp_sema);
	if (!ex->smp_req || ex->smp_portal_pid != current->pid)
		goto out;

	res = 0;
	if (size == 0)
		goto out;

	res = -ENOMEM;
	smp_resp = alloc_smp_resp(size);
	if (!smp_resp)
		goto out;
	res = smp_execute_task(dev, ex->smp_req, ex->smp_req_size,
			       smp_resp, size);
	if (!res) {
		memcpy(buf, smp_resp, size);
		res = size;
	}

	kfree(smp_resp);
out:
	kfree(ex->smp_req);
	ex->smp_req = NULL;
	ex->smp_req_size = 0;
	ex->smp_portal_pid = -1;
	up(&ex->smp_sema);
	return res;
}


A user space program is also provided in drivers/scsi/sas/expander_conf.c
and how to use it in drivers/scsi/sas/README.

There is no reason to make something be something it is not.

> Sigh.  I'm talking about implementation details, here.

Me too -- more than ever.  My code shows it, the comments there in.
And emails.  I've tried to cut and paste code as much as possible.

>>How about a drivers/scsi/satl/satl.c which Doug can start writing
>>and then we can contribute?
> 
> Absolutely not.  Update libata-scsi.

Jeff, the _design_ of libata-scsi doesn't satisfy for SATL.

Such a transformation would _completely_ change libata-scsi.c
other than the comment at the very top.  Is this what is desired?

What is needed by a SATL complient code is OOD: for any entity
to call in to register a device abstraction for translation,
at _device_ level.

>>>* SCSI core already pretty much equates to SAM, even if there is plenty
>>>of HCIL dependency in various places (HCIL should get marginalized,
>>>as all agree)
>>
>>
>>At a concept level yes, at implementation level absolutely no.
>>
>>A true SAM layer would be *much* _smaller_ and would have a more
>>straightforward path for tasks. (as does the SAS layer)
> 
> 
> Important concept:  struct naming and explicit layering based on 
> pictures in a spec is not how we want to do development.  We want to 
> -think- about the overall issues, and implement in the best manner while 
> ensuring the hardware state machine isn't violated.

Well, the hw state machine is _reflected_ in the SAS Transport layer
and aic94xx code.  It is exactly what it is, without any "impurities".

> SAM is ultimately message passing RPC over a network.

While I understand what you mean, according to the Abstract it is:

	"This standard specifies the SCSI Architecture Model.
	The purpose of the architecture is to provide a common
	basis for the coordination of SCSI standards and to specify
	those aspects of SCSI I/O system behavior that are independent
	of a particular technology and common to all implementations."

Not all transports would be a "network".  Anyway this isn't important
to the tasks at hand.

>>>Solutions
>>>---------
>>>* Similar to libata drivers, scsi-host-template should be in the LLDD,
>>>even if it is filled with mostly generic helper calls.
>>
>>
>>Again, see SBP and USB storage code (as well as the SAS code): this would be
>>a step backwards not forwards.  A true SAS LLLD has nothing to do with
>>the scsi host template.  This abstraction happens at the (SAS/SBP/USB Storage)
>>level layer.
> 
> 
> A SCSI domain and Linux SCSI host are already pretty close.  There's no 
> need to rewrite the world, just because they don't match 100%.

Not sure how your response relates to the quoted above.

But yes, you do not need to rewrite the word, or even one letter,
to make it work.  It works already here:
http://linux.adaptec.com/sas/

There is no SCSI Domain representation in SCSI Core.

The Linux SCSI Host structure isn't quite relevant -- it is shielded
from lower layers.

But above you talk about how there is relevant things in 
sas_ha_struct { ... }; which you want to pull into upper layers.

My suggestion is: One step at a time.

>>>* I would tend to prefer calling scsi_scan_target() from SAS discovery
>>>code, rather than sas_rhy_add()
>>
>>
>>This is apparently not my code.
>>
>>The SAS transport _layer_ does complete domain discovery as stipulated in
>>SAS 1.1.  (2.0 is out -- I'll be updating things when I come back).
> 
> 
> I'm trying to move forward by talking about how your code will integrate 
> with the kernel.

Ok, good.

> Pointing out "that's not my code" is completely irrelevant, and unhelpful.

I was merely stating that I wouldn't have been able to comment on
the code side.

>>>* Using scsi_scan_target() would allow us to use the normal LUN scan
>>
>>
>>Again not my code.  Normal LUN "scan" is done through REPORT LUNS
>>as shown in sas_discover.c as I posted both functions to this list
>>in a recent email.
> 
> 
> SCSI core does REPORT LUNS, so we should use that.

HCIL.


>>>* Avoid writing a separate SMP driver for now, and see how things
>>>shake out with future SAS+SATA hardware.
>>
>>
>>No such intentions.  SMP should not be in a separate driver.
>>For SMP you need _addressing_ and the solution to this problem
>>has been showin in driver/scsi/sas/README and in the announcement
>>emails to linux-kernel and linux-scsi here:
>>http://linux.adaptec.com/sas/
> 
> 
> As I said above, this entire thread is talking about your code, and how 
> it will integrate into the upstream kernel.  There is little value in 
> repeatedly posting a URL to code we're already discussing.

Well, in all honesty and actuallity the code has already been integrated
and it works.  The link is here:
http://linux.adaptec.com/sas/

Plus there are people using this code for their storage needs every day.

>>>* Put HCIL mapping into top-level helper code, for sharing between FC
>>>and SAS (hopefully!)
>>
>>
>>One step further: eliminate the ugly legacy SPI-centric HCIL from
>>SCSI Core.  Minimise and streamline SCSI Core.
> 
> 
> How many times must we repeat:  that's the long term goal.
> 
> Rome wasn't built in a day.

Indeed Rome wasn't built in a day.

As to SCSI Core, if you conjure up struct scsi_domain_device { ... };
you rid yourself of HCIL immediately.

>>You don't see the _big_ picture: you need a _layer_, not "helper libs".
>>This is what Object Oriented Deisign is all about.  SAM is object
>>oriented, as is SAS as is iSCSI as is SBP, etc.
>>
>>"Helper libs" makes the code ugly and spaghetti like.
>>
>>A transport LLDD implments access to the _transport_: take USB, SBP and SAS --
>>they all do it.  They need a management transport layer as showin in
>>those implementations.
>>
>>I know that this is how libata works: "helper libs" but you have to think
>>on a larger scale:
> 
> 
> Helper lib is another way of saying object-oriented design.  Look closer.

Jeff, can I quote you on this and use it as my sig? ;-)

>>libata is two layers: SATL and HW interface -- given ata_port and how
> 
> Obviously.  ls(1) would have told you that:
> 
> [jgarzik@pretzel sas-2.6]$ ls drivers/scsi/libata*.c
> drivers/scsi/libata-core.c  drivers/scsi/libata-scsi.c
> 
> The hardware interface is separate from the SCSI simulator.

The exported to the kernel ata_scsi_queuecommand() defined in
libata-scsi.c dereferences struct ata_port.

That is, if, say SAS Transport Layer wanted translation for
a SATA device it would have to conjure up ata_port, which
would need to be made up.

	Luben
-- 
http://linux.adaptec.com/sas/
