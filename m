From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Buggy Firewire bridge 'Prolific PL3507'
Date: Tue, 8 Jan 2008 11:22:05 -0700
Message-ID: <20080108182205.GG16309@parisc-linux.org>
References: <47837E06.5080406@novell.com> <20080108140151.GD16309@parisc-linux.org> <4783B93B.70307@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52124 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbYAHSWH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 13:22:07 -0500
Content-Disposition: inline
In-Reply-To: <4783B93B.70307@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Hannes Reinecke <hare@novell.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jan 08, 2008 at 06:56:11PM +0100, Stefan Richter wrote:
> It's hald or something like that.

Can't we get hald to look at the cached results of the inquiry command,
handily available through sysfs?

> Matthew Wilcox wrote:
> > I have a hard time thinking this needs to be handled generically
> > because READ CAPACITY isn't in the Primary Command Set, unlike INQUIRY.
> > It's mandatory for SBC devices to implement it, but other devices
> > shouldn't even implement it.
> 
> It is also mandatory in RBC, which most SBP-2 to IDE or SBP-2 to SATA
> bridges implement (besides MMC, if a CD/DVD-ROM/R/W is attached).

According to SPC4r05a, READ CAPACITY(10) (opcode 25) is Mandatory for D,
W and O.  READ CAPACITY (opcode 25) is Optional for R.  READ CARD
CAPACITY (also opcode 25) is Mandatory for K.
D - DIRECT ACCESS BLOCK DEVICE (SBC-3)
W - WRITE ONCE BLOCK DEVICE (SBC)
O - OPTICAL MEMORY BLOCK DEVICE (SBC)
R - CD/DVD DEVICE (MMC-6)
K - OPTICAL CARD READER/WRITER DEVICE (OCRW)

According to this table (D.2 for anyone following along at home), RBC
devices are not supposed to implement it.

> I would not at all like to see a respective workaround added to the sbp2
> driver.  Sbp2 is a transport layer which does not touch commands.  Maybe
> an in-kernel workaround would be considered by whoever maintains the
> point where that extra INQUIRY is injected (via sd or sg, I don't know
> which).

It would be thoroughly inappropriate to put this workaround in the
midlayer.  sbp2 isn't a good place either, but it's better than
sg/sd/scsi_ioctl/...

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
