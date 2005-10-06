From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] 3ware: use scsi_scan_target()
Date: Thu, 06 Oct 2005 14:09:03 -0400
Message-ID: <4345683F.6060709@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7ADD@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:4811 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751266AbVJFSJK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2005 14:09:10 -0400
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7ADD@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: ltuikov@yahoo.com, jgarzik@pobox.com, hch@infradead.org, linux-scsi@vger.kernel.org, linuxraid@amcc.com

On 10/06/05 09:13, James.Smart@Emulex.Com wrote:
>>I'd like to move sas_do_lu_discovery(struct domain_device *dev)
>>into SCSI Core (as the comment therein says), for _new_ (non-legacy)
>>devices, i.e. with newer FW.
> 

Hi James, how are you?

> My vote, for what it's worth, is to *not* have multiple discovery threads.
> I don't care about "old" or "new", and in general, even things with "new"
> interfaces behave in "old" manners, as they typically are existing
> subsystems with new interface chips placed on them. It also makes life
> hell for transport bridging devices, which want to map at the transport
> endpoint level, and leave luns up to the actual SCSI task manager in the
> device.

This is perfectly fine -- SAS FW supports REPORT LUNS.

> Remember - devices are made to work with many OS's, and the level
> of SCSI/SAM support in each os differs, so the devices choose a median
> that allows them to function with the OS's they care about. It's no longer
> a SAM thing.

Would you be presenting SAS devices as something else (FC, etc)?
In which case the old, broken, semantically fat scanning technique
would apply.  This is ok also.

> Also - SAM/SPC/SBC/etc has many many grey areas, and SAM (the
> original) was written such that SCSI-2 devices were still SAM compliant.
> And if you say SAM - what rev of SAM (SAM, SAM-2, SAM-3) ?  There are
> things allowed in SAM that are disallowed in SAM-3. Same with SPC and so on.

SAM-3 and/or SAM-4.  (What you'd normally see is SAM-4 behaviour advertized
as SAM-3.)

> I've lived with a driver with it's own scan subsystem (which equates to
> your own SAS scan functions) and all it did was create confusion for the
> end users. If a device is mis-behaving, do you tweak driver/sas_transport
> tunables, or do you tweak black/white list entries ? How do you deal with

Yes, this is a good hypotethical _SAS_ situation.  Let's get there
first, who knows, we may never do.

SAS FW writers are aware that REPORT LUNS is mandatory.

Can you imagine a SAS device supporting more than one LUN and _not_
supporting REPORT LUNS?

As to transport bridging -- at least one thing the transport bridge
would do is implement the _first_ command that would be sent to a
SCSI device: REPORT LUNS.  Imagine a transport bridge device _not_
supporting REPORT LUNS.

> the same SAS target device that behaves differently behind 2 different
> adapters - one using the midlayers standard scanning functions (which the
> device may already be supported by) vs the other using its own custom scan
> logic.

Then the bug is in the "adapters", since the task router hasn't changed.

> I know you'll come back at this from the pristine view that SAS is
> new - well true, the transport is new, but the devices aren't necessarily.

Yes, as an engineer I'm an optimist.

You have a good point, but if the underlying devices are _old_ and there's
a SAS-to-whatever bridge, then _that_ bridge would have to properly implement
REPORT LUNS (somehow).

It would be quite unbelievable (to me) to find out a SAS device which
does not support REPORT LUNS and we have to black listed it.

> Go back and look at the exceptions I mentioned above.
> 
> Bottomline, this kind of choice just makes life confusing for the end user.
> 
> As has been said before on this list - replicating scan functions is silly.
> Let's fix or extend the current scan behavior.

That's fine James, but there is only so much crud the current code can
take.  After a while, it starts breaking at the seams.

So why don't we take it one step at a time.  If you have a specific
SAS device which would not work with the proper LUN scan as shown
in sas_discover.c::sas_do_lu_discovery(struct domain_device *dev),
please let lsml know about it.

	Luben

P.S. How much crud can we add to older code?
