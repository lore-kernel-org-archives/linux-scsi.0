From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 22/71] ncr5380: Eliminate selecting state
Date: Fri, 27 Nov 2015 09:32:46 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1511270930280.723@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <201511252259.26792.linux@rainbow-software.org> <alpine.LNX.2.00.1511261130120.12333@nippy.intranet> <201511262035.40920.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <201511262035.40920.linux@rainbow-software.org>
Sender: linux-m68k-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Thu, 26 Nov 2015, Ondrej Zary wrote:

> 
> [  156.014234] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x0, n_io_port 0, base 0xd8000, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NO_DMA_FIXUP }, options { AUTOPROBE_IRQ PSEUDO_DMA }
> [  156.020369] scsi host2: scsi_scan_host_selected: <4294967295:4294967295:18446744073709551615>
> [  156.020777] scsi 2:0:0:0: scsi scan: INQUIRY pass 1 length 36
> [  156.022046] scsi host2: main: dequeued de045600
> [  156.022109] STATUS_REG: 00
> BASR: 00
> ICR: 00
> MODE: 00
> [  156.022451] scsi host2: starting arbitration, id = 7
> [  156.022740] scsi host2: won arbitration
> [  156.022806] scsi host2: selecting target 0
> [  171.097450] scsi host2: target did not respond within 250ms
> [  171.097508] scsi host2: main: select complete
> [  171.099554] scsi 2:0:0:0: scsi scan: INQUIRY failed with code 0x40000

This is very helpful, thanks.

The problem has to be this:

        err = NCR5380_poll_politely(instance, STATUS_REG, SR_BSY, SR_BSY,
                                    msecs_to_jiffies(250));

which would suggest a problem with the busy wait loop. It seems that 5380 
register accesses are much more expensive on PC than the platforms I've 
tested.

> [  171.103200] scsi 2:0:1:0: scsi scan: INQUIRY pass 1 length 36
> [  171.105246] scsi host2: main: dequeued df6b9f00
> [  171.105350] STATUS_REG: 00
> BASR: 08
> ICR: 00
> MODE: 00
> [  171.105664] scsi host2: starting arbitration, id = 7
> [  171.105752] scsi host2: won arbitration
> [  171.105822] scsi host2: selecting target 1
> [  171.105977] scsi host2: target 1 selected, going into MESSAGE OUT phase.
> [  171.106042] scsi host2: nexus established.
> [  171.106093] scsi host2: main: select complete
> [  171.106145] scsi host2: main: performing information transfer
> [  171.108531] scsi 2:0:1:0: scsi scan: INQUIRY successful with code 0x0
> [  171.108639] scsi 2:0:1:0: scsi scan: INQUIRY pass 2 length 130
> [  171.109401] scsi host2: main: dequeued df6b9f00
> [  171.109485] STATUS_REG: 00
> BASR: 08
> ICR: 00
> MODE: 00
> [  171.109779] scsi host2: starting arbitration, id = 7
> [  171.109878] scsi host2: won arbitration
> [  171.109954] scsi host2: selecting target 1
> [  171.110112] scsi host2: target 1 selected, going into MESSAGE OUT phase.
> [  171.110181] scsi host2: nexus established.
> [  171.110236] scsi host2: main: select complete
> [  171.110286] scsi host2: main: performing information transfer
> [  171.114811] scsi 2:0:1:0: scsi scan: INQUIRY successful with code 0x0
> [  171.114928] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
> [  171.115011] scsi target2:0:1: scsi scan: Sequential scan
> [  171.115856] scsi 2:0:1:1: scsi scan: INQUIRY pass 1 length 36
> [  171.116008] scsi host2: main: dequeued df6b9800
> [  171.116039] STATUS_REG: 00
> BASR: 08
> ICR: 00
> MODE: 00
> [  171.116736] scsi host2: starting arbitration, id = 7
> [  171.116843] scsi host2: won arbitration
> [  171.116898] scsi host2: selecting target 1
> [  171.117117] scsi host2: target 1 selected, going into MESSAGE OUT phase.
> [  171.117182] scsi host2: nexus established.
> [  171.117234] scsi host2: main: select complete
> [  171.117287] scsi host2: main: performing information transfer
> [  171.119674] scsi 2:0:1:1: scsi scan: INQUIRY successful with code 0x0
> [  171.119781] scsi 2:0:1:1: scsi scan: INQUIRY pass 2 length 130
> [  171.119898] scsi host2: main: dequeued df6b9800
> [  171.119962] STATUS_REG: 00
> BASR: 08
> ICR: 00
> MODE: 00
> [  171.121426] scsi host2: starting arbitration, id = 7
> [  171.121537] scsi host2: won arbitration
> [  171.121592] scsi host2: selecting target 1
> [  171.121766] scsi host2: target 1 selected, going into MESSAGE OUT phase.
> [  171.121834] scsi host2: nexus established.
> [  171.121889] scsi host2: main: select complete
> [  171.121940] scsi host2: main: performing information transfer
> [  171.126361] scsi 2:0:1:1: scsi scan: INQUIRY successful with code 0x0
> [  171.126470] scsi 2:0:1:1: scsi scan: peripheral qualifier of 3, device not added
> [  171.127735] scsi 2:0:2:0: scsi scan: INQUIRY pass 1 length 36
> [  171.127920] scsi host2: main: dequeued df6b9800
> [  171.127982] STATUS_REG: 00
> BASR: 08
> ICR: 00
> MODE: 00
> [  171.128648] scsi host2: starting arbitration, id = 7
> [  171.128754] scsi host2: won arbitration
> [  171.128811] scsi host2: selecting target 2
> [  186.203734] scsi host2: target did not respond within 250ms
> [  186.203794] scsi host2: main: select complete
> [  186.205355] scsi 2:0:2:0: scsi scan: INQUIRY failed with code 0x40000
> [  186.208989] scsi 2:0:3:0: scsi scan: INQUIRY pass 1 length 36
> [  186.209178] scsi host2: main: dequeued df6b9f00
> [  186.209242] STATUS_REG: 00
> BASR: 08
> ICR: 00
> MODE: 00
> [  186.209570] scsi host2: starting arbitration, id = 7
> [  186.209660] scsi host2: won arbitration
> [  186.209731] scsi host2: selecting target 3
> [  201.284666] scsi host2: target did not respond within 250ms
> [  201.284726] scsi host2: main: select complete
> [  201.286193] scsi 2:0:3:0: scsi scan: INQUIRY failed with code 0x40000
> [  201.287455] scsi 2:0:4:0: scsi scan: INQUIRY pass 1 length 36
> [  201.287609] scsi host2: main: dequeued df6b9900
> [  201.287673] STATUS_REG: 00
> BASR: 08
> ICR: 00
> MODE: 00
> [  201.287973] scsi host2: starting arbitration, id = 7
> [  201.288766] scsi host2: won arbitration
> [  201.288855] scsi host2: selecting target 4
> [  216.363793] scsi host2: target did not respond within 250ms
> [  216.363853] scsi host2: main: select complete
> [  216.363947] scsi 2:0:4:0: scsi scan: INQUIRY failed with code 0x40000
> [  216.366469] scsi 2:0:5:0: scsi scan: INQUIRY pass 1 length 36
> [  216.366633] scsi host2: main: dequeued df6b9f00
> [  216.366696] STATUS_REG: 00
> BASR: 08
> ICR: 00
> MODE: 00
> [  216.366997] scsi host2: starting arbitration, id = 7
> [  216.367153] scsi host2: won arbitration
> [  216.367208] scsi host2: selecting target 5
> [  231.442079] scsi host2: target did not respond within 250ms
> [  231.442136] scsi host2: main: select complete
> [  231.442214] scsi 2:0:5:0: scsi scan: INQUIRY failed with code 0x40000
> [  231.445050] scsi 2:0:6:0: scsi scan: INQUIRY pass 1 length 36
> [  231.445329] scsi host2: main: dequeued df6b9c00
> [  231.445392] STATUS_REG: 00
> BASR: 08
> ICR: 00
> MODE: 00
> [  231.445682] scsi host2: starting arbitration, id = 7
> [  231.445784] scsi host2: won arbitration
> [  231.445855] scsi host2: selecting target 6
> [  246.521110] scsi host2: target did not respond within 250ms
> [  246.521171] scsi host2: main: select complete
> [  246.521253] scsi 2:0:6:0: scsi scan: INQUIRY failed with code 0x40000
> [  246.525098] sd 2:0:1:0: Attached scsi generic sg1 type 0
> 
> 
> > [...] Which card(s) are affected?
> 
> All of them: HP C2502 (53C400A), Canon FG2-5202 (53C400) and DTCT-436P.
>  

OK.

> > Aside from trying to figure out why the chip behaves oddly, we could also 
> > try to figure out whether the driver and its main loop is causing problems 
> > for other tasks i.e. timekeeping watchdog. Does this patch make any 
> > difference?
> 
> The timekeeping warning does not appear when all 71 patches are applied.
> Reverse-bisected it - the warning disappears after:
> [PATCH 50/71] ncr5380: Change instance->host_lock to hostdata->lock
> 

Makes sense. I think that this should solve the problem:

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-27 09:21:40.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-27 09:25:36.000000000 +1100
@@ -230,7 +230,7 @@ static int NCR5380_poll_politely2(struct
 	unsigned long n;
 
 	/* Busy-wait for up to 1 jiffy */
-	n = loops_per_jiffy;
+	n = 1 + loops_per_jiffy / 10;
 	do {
 		if ((NCR5380_read(reg1) & bit1) == val1)
 			return 0;

-- 
