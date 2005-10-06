From: James.Smart@Emulex.Com
Subject: RE: [PATCH] 3ware: use scsi_scan_target()
Date: Thu, 6 Oct 2005 09:13:44 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7ADD@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50085 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750908AbVJFN3E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Oct 2005 09:29:04 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com, jgarzik@pobox.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linuxraid@amcc.com


> I'd like to move sas_do_lu_discovery(struct domain_device *dev)
> into SCSI Core (as the comment therein says), for _new_ (non-legacy)
> devices, i.e. with newer FW.

My vote, for what it's worth, is to *not* have multiple discovery threads.
I don't care about "old" or "new", and in general, even things with "new"
interfaces behave in "old" manners, as they typically are existing
subsystems with new interface chips placed on them. It also makes life
hell for transport bridging devices, which want to map at the transport
endpoint level, and leave luns up to the actual SCSI task manager in the
device. Remember - devices are made to work with many OS's, and the level
of SCSI/SAM support in each os differs, so the devices choose a median
that allows them to function with the OS's they care about. It's no longer
a SAM thing. Also - SAM/SPC/SBC/etc has many many grey areas, and SAM (the
original) was written such that SCSI-2 devices were still SAM compliant.
And if you say SAM - what rev of SAM (SAM, SAM-2, SAM-3) ?  There are
things allowed in SAM that are disallowed in SAM-3. Same with SPC and so on.

I've lived with a driver with it's own scan subsystem (which equates to
your own SAS scan functions) and all it did was create confusion for the
end users. If a device is mis-behaving, do you tweak driver/sas_transport
tunables, or do you tweak black/white list entries ? How do you deal with
the same SAS target device that behaves differently behind 2 different
adapters - one using the midlayers standard scanning functions (which the
device may already be supported by) vs the other using its own custom scan
logic. I know you'll come back at this from the pristine view that SAS is
new - well true, the transport is new, but the devices aren't necessarily.
Go back and look at the exceptions I mentioned above.

Bottomline, this kind of choice just makes life confusing for the end user.

As has been said before on this list - replicating scan functions is silly.
Let's fix or extend the current scan behavior.

-- james
