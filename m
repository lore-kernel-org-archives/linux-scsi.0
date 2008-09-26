From: Sam Creasey <sammy@sammy.net>
Subject: Re: [linux-m68k] mac scsi, ncr5380
Date: Fri, 26 Sep 2008 10:40:55 -0400
Message-ID: <20080926144055.GS10918@sammy.net>
References: <Pine.LNX.4.64.0809240019001.3458@loopy.telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from anhedonia.sammy.net ([72.46.127.32]:44609 "EHLO
	anhedonia.sammy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYIZPIu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2008 11:08:50 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0809240019001.3458@loopy.telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>

On Fri, Sep 26, 2008 at 06:27:05PM +1000, Finn Thain wrote:

> There is so much duplication of code for the NCR5380 drivers -- sun3, 
> atari, g_NCR5380, 2.4 & 2.2 branches in the mac68k CVS -- that I don't 
> know where to start looking for fixes.
> 
> Thinking that the bug would be trivial, I started out writing cleanup 
> patches for the existing mac_scsi.c/NCR5380.c combination. But the more I 
> think about it, the less I want to go in that direction.
> 
> Now I'm thinking that mac_scsi should adopt the atari core, since that 
> appears to be the better maintained contender. Michael, does that sound 
> sensible? Does it have working PDMA?
> 
> Another thing, should we look at merging sun3_NCR5380.c and 
> atari_NCR5380.c? The diff is huge, but that is because of the code style 
> and formatting cleanups in atari_NCR5380.c. The functional differencess 
> are few and far between.
> 
> If we can get to a working, common sun3/atari/mac core, I could then look 
> at minimising C preprocessor abuse in favour of a cleaner link-time/ops 
> struct abstraction layer -- with some assistance from Micheal and Sam: I'm 
> assuming that there is a cut somewhere that would make for a broadly 
> useful interface. Does this make sense?

It makes sense, I think.  I'm trying to remember what hackery I had
to do which led me to fork the driver in the first place -- I'm fairly
sure that the main differences were related to the dma controller on
the OBIO sun3's (50/60) being very picky about what bus phases you
programmed the DMA controller during, and this not working well with
the model in place in the version of atari_NCR5380 which I started
with (it's only been 9 years, you'd think I'd know this... :)

I can't actually recall what the requirments are at the moment.  most
of the sun3* function calls seem to be centered around making sure DMA
is configured in the CMDOUT phase and started in the DATAIN/DATAOUT
phases (is this why I commented out merge_contiguous_buffers() in
NCR5380_transfer_dma?)

Let me know if you start making progress, I'll be happy to let ya know
anything else I can rememeber, or to try to bring a kernel up on real
hardware (I think a couple of them still boot...  :)

-- Sam
