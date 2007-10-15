From: Rob Landley <rob@landley.net>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 04:26:04 -0500
Message-ID: <200710150426.04924.rob@landley.net>
References: <200710112011.22000.rob@landley.net> <200710141836.55211.rob@landley.net> <4712FE33.3000400@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41227
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848AbXJOJ0L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 05:26:11 -0400
In-Reply-To: <4712FE33.3000400@s5r6.in-berlin.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: David Newall <david@davidnewall.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Monday 15 October 2007 12:44:19 am Stefan Richter wrote:
> Rob Landley wrote:
> > I was at least attempting to ask a serious question.
>
> ...
>
> > Actually, I was going through Documentation/block thinking about making a
> > 00-INDEX for it, but my earlier questions of the scsi guys left me with
> > the impression that the block layer is _not_ used by the SCSI layer.
>
> Ah, so it was about your documentation work.

Well, triggered by.  (This documentation stuff makes me poke into corners of 
the kernel I ordinarily otherwise avoid, for various reasons.  I don't 
currently have the luxury of saying "beats me how this bit works, not my 
area".)

> I already forgot the 
> context of your previous inquiries.  Alas the tone of them already did
> some damage, leading to responses like these.

Sorry about that.  My social skills are finite, I tend to exhaust them when I 
do too much at once. :(

The resulting documentation should be very polite and apolitical. :)

> > since
> > every non-embedded modern storage device I'm aware of has been consumed
> > by the SCSI layer (despite none of them actually having a discernably
> > closer relationship to SCSI than ATA did)
>
> The Linux SCSI subsystems don't consume, they provide services; nowadays
> not only for SCSI hardware and SCSI protocols but also for a number of
> subsystems whose tasks are similar enough to SCSI subsystems to make the
> SCSI core and upper SCSI layer useful to them too.

This discussion has clarified for me that my objection isn't the scsi layer 
itself, it's the /dev/sd? namespace combining devices that would otherwise 
be /dev/hda, /dev/nd0, /dev/ub0 (or usb0 or some such), and /dev/sata into a 
single linear namespace that's unreliably ordered. 

> BTW:
> | Now that IDE disks have been rerouted through the scsi layer, SATA goes
> | through the scsi layer, USB goes through the scsi layer, firewire goes
> | through the scsi layer...
>
> As a side note, SBP-2 is a SCSI transport protocol, hence ieee1394/sbp2
> and firewire/fw-sbp2 are Linux SCSI low-level drivers.  Anything else
> would be just wrong and infeasible in this particular case.

My "scsi mid layer" vs "block layer" question was about whether I should read 
up on the block layer if the scsi mid layer didn't use it.  Neil Brown just 
sent me a nice email (which I'll have to reread in the morning when I'm more 
awake) that helps there.

The "ide/sata/usb/firewire->scsi" complaint didn't belong in the same email as 
the original question, it's a line of questioning I put on hold on linux-scsi 
back in August when the thread started getting a bit heated for my tastes.

To clarify, I think that merging ide, sata, usb, firewire, and others into a 
single device namespace causes each type of device to inherit that 
namespace's cumulative ordering issues, which is a bad thing.  I have no real 
attachment to the underlying scsi or block layers.  I've never seriously 
worked on either (although I'm trying to understand both).

For example, usb devices are never easy to order.  IDE devices (back when they 
had their own namespace) were trivial to order back when /dev/hda couldn't 
move without use of a screwdriver.  USB and IDE devices are very different in 
that it's not possible to plug a USB device into an IDE controller (not 
without one _heck_ of an adapter) and vice versa.  USB devices usually live 
outside the computer's case, and IDE devices inside the case.  They're not 
the same thing.

Combining USB and IDE into the same /dev/sd? namespace makes enumerating the 
IDE devices much harder than in the traditional "/dev/hdb doesn't move 
without a screwdriver" model.  The merger creates a new problem for IDE, one 
which didn't exist before: the addition or removal of other unrelated types 
of devices may change this device's location next boot.  It may be possible 
to add additional complication to the system to compensate, but what was the 
advantage of merging the namespaces in the first place?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
