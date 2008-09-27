From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: mac scsi, ncr5380
Date: Sat, 27 Sep 2008 05:10:46 +0200 (CEST)
Message-ID: <alpine.DEB.1.00.0809270439470.19669@zirkon.biophys.uni-duesseldorf.de>
References: <Pine.LNX.4.64.0809240019001.3458@loopy.telegraphics.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.rz.uni-duesseldorf.de ([134.99.128.30]:59072 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbYI0GES (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Sep 2008 02:04:18 -0400
In-reply-to: <Pine.LNX.4.64.0809240019001.3458@loopy.telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>

Hi Finn,

> Of late I've spent some time wrestling with mac_scsi. I've made some
> progress, but I'm uncertain as to how I should procede -- whatever I do,
> there will be implications for some other NCR5380 drivers.
>
> mac_scsi actually works (once I fixed the enable_irq-before-request_irq
> bug -- already fixed in various other NCR5380 wrapper drivers ... sigh)
> but it only works in PIO mode. The PDMA read routine causes a bus error
> (The Guide to Mac Family Hardware says "if a read or write operation over
> the SCSI bus is not completed within certain time (different for different
> machines), the general logic IC asserts a bus error (/BERR) to the CPU.")
> The driver tries to fall back to PIO mode when that happens.

The bus error is caught OK by the PDMA function?

> The fall back succeeds only on the powerbook 190 and only if the code was
> compiled with gcc-3. It just hangs on the PB 150 and Mac II, though PIO
> works on those machines too when PDMA is disabled. So I think there's a
> race there somewhere. And PIO doesn't work anywhere once debugging printks
> are enabled.

I've worked around that in the past by hooking into the Mac level 7 interrupt, 
listing the driver state from the NMI post-mortem. (Actually I did that on the 
old Mac ESP driver, but the same sort of hack should apply. ESP was a lot more 
debug friendly though ...)

> All of which gives me little confidence in NCR5380.c.
>
> (I tested those 3 machines because they have the 3 different kinds of
> VIA2. Logs can be found here
> <http://www.telegraphics.com.au/~fthain/mac_scsi_logs/>
> should anyone want to see them.)

Looks like a race with the ADB interrupt to me. In the second Mac II gcc4 case, 
it even seems to fail to add the target to the disconnect queue.

What are these unknown interrupts? DRQ? PDMA stalling?

> There is so much duplication of code for the NCR5380 drivers -- sun3,
> atari, g_NCR5380, 2.4 & 2.2 branches in the mac68k CVS -- that I don't
> know where to start looking for fixes.

The Mac driver originated from the Atari one, but I haven't done more than the 
absolute minimum in fixes to keep that one alive.

> Thinking that the bug would be trivial, I started out writing cleanup
> patches for the existing mac_scsi.c/NCR5380.c combination. But the more I
> think about it, the less I want to go in that direction.
>
> Now I'm thinking that mac_scsi should adopt the atari core, since that
> appears to be the better maintained contender. Michael, does that sound
> sensible? Does it have working PDMA?

Atari uses real DMA. When I adapted it for Mac, I added PIO and that did work 
fine (slowish, but OK). Must have been in the 2.2 kernel series, more than 10 
years ago, so it may not work in the driver's current state. I can test that if 
you need to.

Better maintained ... I strongly doubt it. It still works in the regular case, 
but I haven't pushed it hard enough to test whether my 2.6 error handling 
changes still work today.

> Another thing, should we look at merging sun3_NCR5380.c and
> atari_NCR5380.c? The diff is huge, but that is because of the code style
> and formatting cleanups in atari_NCR5380.c. The functional differencess
> are few and far between.

In order to avoid duplication maintenance effort, we should merge those if it is 
at all possible. I didn't write the Atari code, and my discussions with the 
author were so long ago I have trouble remembering the details. Much of the 
peculiar things in the Atari driver result from the fact that the SCSI chip 
hangs quite frequently on Atari (hardware issue), and the command in-flight may 
not be in any of the queues if that happens (or so a comment in the code claims;
I think I fixed the most glaring case a while ago). Maybe we can let the error
handler clean up after these hangs now; changes since 2.2 in locking and error 
handling have been simplifying things enormously after all.

> If we can get to a working, common sun3/atari/mac core, I could then look
> at minimising C preprocessor abuse in favour of a cleaner link-time/ops
> struct abstraction layer -- with some assistance from Micheal and Sam: I'm
> assuming that there is a cut somewhere that would make for a broadly
> useful interface. Does this make sense?

It does, for me.

> Merging core 5380 drivers could _maybe_ go further if those responsible
> for them were interested, but I would not want to bite off more than
> atari/mac/sun3 at first. As to the rest, here's a list of all the relevant
> #includes (this really needs to be converted to a graphical representation
> somehow..) I don't know who maintains all of these 5380 drivers.

I don't think we have a chance to get most of these tested for regression these 
days. Let's stick to the m68k ones.

My $.02,

 	Michael
