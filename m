From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Recurring qla2xxx crashes (maybe APIC related)
Date: Fri, 25 Apr 2008 10:18:21 -0700
Message-ID: <20080425171821.GK8849@plap4>
References: <4811ACAC.7060808@linpro.no> <20080425155018.GG8849@plap4> <48120F8B.7060005@linpro.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:28469 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbYDYRSZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Apr 2008 13:18:25 -0400
Content-Disposition: inline
In-Reply-To: <48120F8B.7060005@linpro.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tore Anderson <tore@linpro.no>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 25 Apr 2008, Tore Anderson wrote:

> * Andrew Vasquez
> 
> > There's a slew of problem reports noted on the web with this 'APIC
> > error' signature...  From the qla2xxx driver perspective the following
> > logs show the classic 'no interrupts being routed' failures:
> 
> Yes - I suspect this might not have anything to do with the HBA at all.
> It is a bit odd that it is always the qla2xxx driver that runs into
> trouble, for instance will I/O to the local hard drives continue to work
> (which is fortunate as that's where I have the kernel logs).
> 
> > So do the abort requests fail with the similar signature (timeout)?
> 
> The log isn't edited so if it doesn't say then I don't know.
> 
> I/O service never recovers after the crash, so the multipath maps blocks
> all I/O until the machine is rebooted (which the remaining cluster
> members take care of within a minute).

Hmm, MSI is enabled:

	qla2xxx 0000:08:01.1: Found an ISP2422, irq 26, iobase 0xffffc20000c54000
	qla2xxx 0000:08:01.1: Configuring PCI space...
	qla2xxx 0000:08:01.1: Configure NVRAM parameters...
	qla2xxx 0000:08:01.1: Verifying loaded RISC code...
	scsi(2): **** Load RISC code ****
	scsi(2): Verifying Checksum of loaded RISC code.
	scsi(2): Checksum OK, start firmware.
	qla2xxx 0000:08:01.1: Allocated (64 KB) for EFT...
	qla2xxx 0000:08:01.1: Allocated (1413 KB) for firmware dump...
	scsi(2): Issue init firmware.
	qla2xxx 0000:08:01.1: MSI: Enabled.
	...

could you try disabling MSI via 'pci=nomsi' (I believe), we've dealt
with a large number of problem reports where customers reported 'odd'
behaviours (no interrupt routining) with several motherboard chipsets.
At least it could be another useful datapoint...

> > There's a blanket suggestion that has helped others (perhaps by
> > ignoring the problem), disable the APIC:
> > 
> > 	apm=force noapic acpi=off pci=noacpi
> > 
> > but that seems like a bandaid.  I'd suggest you work this through your
> > IBM support contract, if possible.
> 
> I will try to do both, thank you for the suggestions.  I fear IBM will
> hang up on me for not running SuSE or Red Hat, though...
> 
> > BTW: I'd like to take a look at several failure iterations, could you
> > send the messages file during the failures...
> 
> Okay, sent you the (unedited) kern.log since the last log rotation.  It
> contains several crash events, as well as the bootup messages (left them
> in there in case there's anything interesting for you to see).
> 
> I have many more crash events in the rotated logs.  If you want I can
> send you those too (maybe off list due to their size), just say so.
> They all look the same, though:  APIC errors followed by qla2xxx
> attempting to fix it, but the rports never recover and in the end the
> machine is rebooted by another cluster node.

Let's force the driver to operating in INTx mode...

--
av
