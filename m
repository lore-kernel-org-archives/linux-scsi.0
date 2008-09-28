From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: mac scsi, ncr5380
Date: Sun, 28 Sep 2008 16:16:08 +0300
Message-ID: <48DF8398.30000@panasas.com>
References: <Pine.LNX.4.64.0809240019001.3458@loopy.telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:9749 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751120AbYI1NQO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Sep 2008 09:16:14 -0400
In-Reply-To: <Pine.LNX.4.64.0809240019001.3458@loopy.telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>, Christoph Hellwig <hch@infradead.org>

Finn Thain wrote:
> Hi All,
> 
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
> 
> The fall back succeeds only on the powerbook 190 and only if the code was 
> compiled with gcc-3. It just hangs on the PB 150 and Mac II, though PIO 
> works on those machines too when PDMA is disabled. So I think there's a 
> race there somewhere. And PIO doesn't work anywhere once debugging printks 
> are enabled.
> 
> All of which gives me little confidence in NCR5380.c.
> 
> (I tested those 3 machines because they have the 3 different kinds of 
> VIA2. Logs can be found here
> <http://www.telegraphics.com.au/~fthain/mac_scsi_logs/>
> should anyone want to see them.)
> 
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
> 
> Merging core 5380 drivers could _maybe_ go further if those responsible 
> for them were interested, but I would not want to bite off more than 
> atari/mac/sun3 at first. As to the rest, here's a list of all the relevant 
> #includes (this really needs to be converted to a graphical representation 
> somehow..) I don't know who maintains all of these 5380 drivers.
> 
> files that include NCR5380.c --
> ./drivers/scsi/arm/cumana_1.c
> ./drivers/scsi/arm/oak.c
> ./drivers/scsi/dmx3191d.c
> ./drivers/scsi/dtc.c
> ./drivers/scsi/g_NCR5380.c
> ./drivers/scsi/mac_scsi.c
> ./drivers/scsi/pas16.c
> ./drivers/scsi/t128.c
> 
> files that include NCR5380.h --
> ./drivers/scsi/arm/cumana_1.c
> ./drivers/scsi/arm/oak.c
> ./drivers/scsi/atari_scsi.c
> ./drivers/scsi/dmx3191d.c
> ./drivers/scsi/dtc.c
> ./drivers/scsi/g_NCR5380.c
> ./drivers/scsi/mac_scsi.c
> ./drivers/scsi/pas16.c
> ./drivers/scsi/sun3_scsi.c 
> ./drivers/scsi/sun3_scsi_vme.c
> ./drivers/scsi/t128.c
> 
> files that include atari_NCR5380.c --
> ./drivers/scsi/atari_scsi.c
> 
> files that include atari_scsi.h --
> ./drivers/scsi/atari_scsi.c
> 
> files that include dtc.h --
> ./drivers/scsi/dtc.c
> 
> files that include g_NCR5380.c --
> ./drivers/scsi/g_NCR5380_mmio.c
> 
> files that include g_NCR5380.h --
> ./drivers/scsi/g_NCR5380.c
> 
> files that include mac_scsi.h --
> ./drivers/scsi/mac_scsi.c
> 
> files that include pas16.h --
> ./drivers/scsi/pas16.c
> 
> files that include sun3_NCR5380.c --
> ./drivers/scsi/sun3_scsi.c
> ./drivers/scsi/sun3_scsi_vme.c
> 
> files that include sun3_scsi.h --
> ./drivers/scsi/sun3_scsi.c
> ./drivers/scsi/sun3_scsi_vme.c
> 
> files that include t128.h --
> ./drivers/scsi/t128.c
> 
> Note that this include graph is post-patching: I moved the #include 
> "NCR5380.h" out of sun3_scsi.h and into sun3_scsi.c and sun3_scsi_vme.c so 
> that the graph was more shallow and more symmetrical (that patch is at 
> <http://www.telegraphics.com.au/~fthain/patches_wip/>
> I'll send some of these patches for the 2.6.28 merge window.)
> 
> Regards,
> 
> Finn
> --
Dear Finn

>From a SCSI generic point of view. The current xxx_NCR5380 remind me allot
of the old ESP drivers stack. At-least at the surface level of the patches
I sent for both these drivers. I was lucky, at the end, to only send the
xxx_NCR5380 patches, because, as strongly recommended by Christoph Hellwig
(CCed), the old ESP stack was brilliantly replaced by a new one. That is 1/10
the size of the old one, and currently supports most of the interesting devices
out there. My unsent patches was a catalyst, for the now broken old-driver-stack,
to be removed quickly. And it seems every one is happy.

My point being, If you are looking to do a major cleanup work, on all these
1/2 forks. Maybe give a hard thought on just trashing the all thing and crafting
a completely new stack, 1/10 the size and much simpler, modern, and maintainable.

>From what I understand, (And again I do not), the ESP sounds a lot like the
NCR5380. I would craft a very similar copy of the new ESP stack, with it's
central library and function-vector registration, The scsi-generic part is
all there, in full glory. Then one concentrated effort should go into the
basic/general chip programing, which lots of it could be ripped from current
code, and the different platform implementation becomes one liners, if the new
ESP stack is any indication.

>From my passed experience, there becomes a source code state when a rewrite is
less effort then any cleanup or enhancements. From the small changes I had to do
to the xxx_NCR5380 family of drivers, my guts feeling scream "rewrite", so here I
voice them. In the mid/long-term you will work much less. And be much more
satisfied from the results.

Good lock
Boaz
