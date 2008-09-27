From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: mac scsi, ncr5380
Date: Sat, 27 Sep 2008 18:00:10 +1000 (EST)
Message-ID: <Pine.LNX.4.64.0809271359460.2612@loopy.telegraphics.com.au>
References: <Pine.LNX.4.64.0809240019001.3458@loopy.telegraphics.com.au>
 <alpine.DEB.1.00.0809270439470.19669@zirkon.biophys.uni-duesseldorf.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from loopy.telegraphics.com.au ([202.45.126.152]:32898 "EHLO
	loopy.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbYI0IAN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Sep 2008 04:00:13 -0400
In-Reply-To: <alpine.DEB.1.00.0809270439470.19669@zirkon.biophys.uni-duesseldorf.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Cc: linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>



On Sat, 27 Sep 2008, Michael Schmitz wrote:

> > mac_scsi actually works (once I fixed the 
> > enable_irq-before-request_irq bug -- already fixed in various other 
> > NCR5380 wrapper drivers ... sigh) but it only works in PIO mode. The 
> > PDMA read routine causes a bus error (The Guide to Mac Family Hardware 
> > says "if a read or write operation over the SCSI bus is not completed 
> > within certain time (different for different machines), the general 
> > logic IC asserts a bus error (/BERR) to the CPU.") The driver tries to 
> > fall back to PIO mode when that happens.
> 
> The bus error is caught OK by the PDMA function?

Yes. Here's a log where the PB 190 booted to login prompt. This kernel had 
PDMA enabled, and you can see that the fallback to PIO worked in this 
instance,

http://marc.info/?l=linux-m68k&m=121930677128486&w=2

Note that the sector size response was screwed up. That happens sometimes. 
It could be related to the other problem I mentioned --

> > The fall back succeeds only on the powerbook 190 and only if the code 
> > was compiled with gcc-3. It just hangs on the PB 150 and Mac II, 
> > though PIO works on those machines too when PDMA is disabled. So I 
> > think there's a race there somewhere. And PIO doesn't work anywhere 
> > once debugging printks are enabled.
> 
> I've worked around that in the past by hooking into the Mac level 7 
> interrupt, listing the driver state from the NMI post-mortem. (Actually 
> I did that on the old Mac ESP driver, but the same sort of hack should 
> apply. ESP was a lot more debug friendly though ...)

OK. But PIO shouldn't be timing sensitive, right? Anyway, I don't want to 
get sidetracked with PIO.. unless there are macs that can't do PDMA.

> > All of which gives me little confidence in NCR5380.c.
> >
> > (I tested those 3 machines because they have the 3 different kinds of 
> > VIA2. Logs can be found here 
> > <http://www.telegraphics.com.au/~fthain/mac_scsi_logs/> should anyone 
> > want to see them.)
> 
> Looks like a race with the ADB interrupt to me.

Well, I know Mac interrupt handling used to be flaky, but that's all fixed 
now. Anyway, I did some tests using the adb_sync parameter, to prevent the 
background ADB probe task, and I get the same results (you can find some 
new logs at the same URL).

> In the second Mac II gcc4 case, it even seems to fail to add the target 
> to the disconnect queue.

I dunno why. I haven't seen that happen before or since.

> What are these unknown interrupts? DRQ? PDMA stalling?

The schematics say that only the NCR5380 drives that VIA input (VIA2 CB2 
aka IRQ_MAC_SCSI), so IRQ 19 is definitely the IRQ line from the chip (and 
not the DRQ line). The DRQ interrupt was/is never registered (BTW, I found 
that it doesn't fire on one of the PowerBooks).

Anyway, it probably isn't PDMA related since that was disabled (#undef 
PSEUDO_DMA).

BASR 0x18 would indicate "IRQ active" and "phase match"... I haven't read 
enough of the datasheet to know what that combination means.

> > There is so much duplication of code for the NCR5380 drivers -- sun3, 
> > atari, g_NCR5380, 2.4 & 2.2 branches in the mac68k CVS -- that I don't 
> > know where to start looking for fixes.
> 
> The Mac driver originated from the Atari one, but I haven't done more 
> than the absolute minimum in fixes to keep that one alive.

There are some mac_scsi.c/NCR5380.c fixes in the mac68k CVS, but it is 
hard to know whether they are relevant to atari_NCR5380.c...

http://linux-mac68k.cvs.sourceforge.net/linux-mac68k/linux-mac68k/drivers/scsi/NCR53C9x.c?view=log&pathrev=MAIN 
http://linux-mac68k.cvs.sourceforge.net/linux-mac68k/linux-mac68k/drivers/scsi/NCR53C9x.c?view=log&pathrev=linux-2_2

> 
> > Thinking that the bug would be trivial, I started out writing cleanup 
> > patches for the existing mac_scsi.c/NCR5380.c combination. But the 
> > more I think about it, the less I want to go in that direction.
> >
> > Now I'm thinking that mac_scsi should adopt the atari core, since that 
> > appears to be the better maintained contender. Michael, does that 
> > sound sensible? Does it have working PDMA?
> 
> Atari uses real DMA. When I adapted it for Mac, I added PIO and that did 
> work fine (slowish, but OK). Must have been in the 2.2 kernel series, 
> more than 10 years ago, so it may not work in the driver's current 
> state. I can test that if you need to.

Thanks. I don't know if PIO will be needed though?

> Better maintained ... I strongly doubt it. It still works in the regular 
> case, but I haven't pushed it hard enough to test whether my 2.6 error 
> handling changes still work today.
> 
> > Another thing, should we look at merging sun3_NCR5380.c and 
> > atari_NCR5380.c? The diff is huge, but that is because of the code 
> > style and formatting cleanups in atari_NCR5380.c. The functional 
> > differencess are few and far between.
> 
> In order to avoid duplication maintenance effort, we should merge those 
> if it is at all possible. I didn't write the Atari code, and my 
> discussions with the author were so long ago I have trouble remembering 
> the details. Much of the peculiar things in the Atari driver result from 
> the fact that the SCSI chip hangs quite frequently on Atari (hardware 
> issue), and the command in-flight may not be in any of the queues if 
> that happens (or so a comment in the code claims; I think I fixed the 
> most glaring case a while ago). Maybe we can let the error handler clean 
> up after these hangs now; changes since 2.2 in locking and error 
> handling have been simplifying things enormously after all.
> 

One implication for a creating a shared driver core is that it rules out 
#ifdef CONFIG_ATARI if we want "make allyesconfig" to work and give 
complete code coverage. We'd have to have run-time conditionals for 
hardware bugs.

I will see what can be done about merging sun3_NCR5380.c with 
atari_NCR5380.c.

Finn
