From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Symbios Logic 53C876 detected as 53C875, then doesn't work
Date: Sat, 12 Aug 2006 14:32:51 -0600
Message-ID: <20060812203251.GB789@parisc-linux.org>
References: <Pine.LNX.4.64.0608120108330.21468@potato.cts.ucla.edu> <20060812132213.GA789@parisc-linux.org> <Pine.LNX.4.64.0608121320530.5419@potato.cts.ucla.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:50097 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932596AbWHLUcw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Aug 2006 16:32:52 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0608121320530.5419@potato.cts.ucla.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Stromsoe <cbs@cts.ucla.edu>
Cc: linux-scsi@vger.kernel.org

On Sat, Aug 12, 2006 at 01:24:15PM -0700, Chris Stromsoe wrote:
> I have two cards that detect as 0007 in the particular slot and one that 
> detects as 000f.  Moving a 0007 to a different slot detects it as 000f. 
> The slots are on a 64-bit pci riser card, so it's possible that there is a 
> bad connection on one of the fingers.  I'll try the boards in a different 
> machien and see it makes any difference.

Definitely sounds like dodgy connections.

> >I don't like the look of this.  If you're getting ffffffff back from 
> >those particular registers, the chip has clearly gone fatal.  But I use 
> >875 controllers *all the time*, so there's something odd going on here. 
> >I don't know what to suggest at this point, I'm afraid.
> 
> Whenever the cards are detected as 000f they have given me that error at 
> boot.  The cards came from Sun and are running Sun firmware if that makes 
> any difference at all.  Up until a week ago they were all functioning in a 
> couple of Sun E450 running Solaris 9 without any visible problems.

Actually, there's no firmware on the cards; the firmware is built into
the driver and uploaded to the onboard ram at initialisation time.

If there's dodgy connectors, then the card probably detected a PCI
parity error and went fatal.  I think it'd be useful to leverage the
PCI error recovery framework to at least display a useful error message
to the user on systems with little or no support for error *recovery*.
