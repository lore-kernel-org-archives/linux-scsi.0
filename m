From: Douglas Gilbert <dougg@torque.net>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 10:46:03 -0400
Message-ID: <47137D2B.60306@torque.net>
References: <200710112011.22000.rob@landley.net> <200710141845.44750.rob@landley.net> <20071015014503.GF9715@thunk.org> <200710150304.00901.rob@landley.net> <20071015132106.GE21216@thunk.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57821 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760887AbXJOOqd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 10:46:33 -0400
In-Reply-To: <20071015132106.GE21216@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, Rob Landley <rob@landley.net>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@

Theodore Tso wrote:
> On Mon, Oct 15, 2007 at 03:04:00AM -0500, Rob Landley wrote:
>> Ok, I'll bite.  If it's all "real" scsi, why does ioctl(SG_EMULATED_HOST) 
>> exist? exist if it's all "real" scsi?
> 
> SG_EMULATED_HOST was added before Linux 2.4, at least six or seven
> years ago.

SG_EMULATED_HOST was present when I started maintaining the
the sg driver in 1997. Back then some folks (one German name
comes to mind) toyed with the idea of sending SCSI Parallel
Interface (SPI) messages through a pass through interface.
SPI messages are obviously transport specific and hence any
app trying to send them needed to ascertain what the transport
was. There were really only two to choose from at the time
(in linux): SPI and the ATA Packet Interface (ATAPI).

If SG_EMULATED_HOST was every used I'm not sure. It is just
an historical remnant now.

 Back then the migration of ATA devices through the various
> versions the ATAPI specification and then into SATA was very early in
> its evolution, and back then, yes there were people who considered
> anything that didn't use the honking huge parallel SCSI cables not
> "real" SCSI.  Over time, that distinction at both the physical
> connector level and logical level has declined to the point of almost
> non-existence.

On the contrary, the distinction between the logical
(command) level and the transport level (down to the
physical/connector level) is pivotal. There is one
industry accepted storage architecture (SAM (yes, ATA
documents defer to it)), two command sets: ATA and SCSI
(and ways to tunnel one within the other and translate
between the two) and about 10 transports (interconnects)
that I can think of.

Comparisons between PATA and SCSI (SPI) are now history.
More precise terminology is now required.
For example the "ATAPI specification" IMO is a handful
of ATA commands designed to convey a packet based protocol
(which the rest of the ATA command set is not). So ATAPI
could be used to send IP over ATA! Is that what you meant?

  It's note quite at the point where SAS exists only to
> justify massive prices differences between commodity and "data-center
> grade" disks to the benefit of hard drive manufacturers, but it's
> darned close.  (There are differences such as voltage levels so that
> the max cable differences for SAS are larger, etc., but those could
> have been optional additions to the SATA spec, and allegedly SAS
> drives are supposedly manufactered to be more robust --- although some
> recent papers published at FAST have raised some interesting questions
> about how true those marketing claims really are in practice.)

You should read more about SAS.

Anyway Seagate have announced a ES.2 family of 3.5" disks
that rotate at 7200 rpm. One would not normally expect disks
below 10000 rpm to come with a SCSI transport (FCP, SAS or
SPI) but the ES.2 series breaks the pattern since it
comes with either a SATA or a SAS interface. What will be
really interesting is how Seagate will price the two versions.
Apart from the SAS variant having dual ports it is pretty
close to an apples versus apples comparison.

A port selector could be added to the SATA variant to provide
dual port functionality. However the SCSI command set offers
persistent reservations which are beyond the scope of ATA
command sets which assume a logical point to point connection.

Doug Gilbert

