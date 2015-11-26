From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 22/71] ncr5380: Eliminate selecting state
Date: Thu, 26 Nov 2015 21:23:01 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1511261130120.12333@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <201511242008.35378.linux@rainbow-software.org> <alpine.LNX.2.00.1511251312190.24439@nippy.intranet> <201511252259.26792.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201511252259.26792.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Wed, 25 Nov 2015, Ondrej Zary wrote:

> On Wednesday 25 November 2015 04:17:09 Finn Thain wrote:
> > 
> > On Tue, 24 Nov 2015, Ondrej Zary wrote:
> > 
> > > 
> > > Bisecting slow module initialization pointed to this commit.
> > > 
> > > Before this commit (2 seconds):
> > > [   60.317374] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x0, n_io_port 0, base 0xd8000, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NCR53C400 }, USLEEP_POLL 3, USLEEP_SLEEP 50, options { AUTOPROBE_IRQ PSEUDO_DMA }
> > > [   60.780715] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
> > > [   62.606260] sd 2:0:1:0: Attached scsi generic sg1 type 0
> > > 
> > > 
> > > After this commit (22 seconds):
> > > [  137.511711] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x0, n_io_port 0, base 0xd8000, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NCR53C400 }, USLEEP_POLL 3, USLEEP_SLEEP 50, options { AUTOPROBE_IRQ PSEUDO_DMA }
> > > [  145.028532] clocksource: timekeeping watchdog: Marking clocksource 'tsc' as unstable because the skew is too large:
> > > [  145.029767] clocksource:                       'acpi_pm' wd_now: a49738 wd_last: f4da04 mask: ffffff
> > > [  145.029828] clocksource:                       'tsc' cs_now: 2ea624698e cs_last: 2c710aa17f mask: ffffffffffffffff
> > > [  145.032733] clocksource: Switched to clocksource acpi_pm
> > > [  145.236951] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
> > > [  159.959308] sd 2:0:1:0: Attached scsi generic sg1 type 0
> > > 
> > > 
> > 
> > This problem doesn't show up on my hardware, and I'd like to know where 
> > those 22 seconds are being spent. Would you please apply the entire series 
> > and add,
> > #define NDEBUG (NDEBUG_ARBITRATION | NDEBUG_SELECTION | NDEBUG_MAIN)
> > to the top of g_NCR5380.c and send me the messages logged during modprobe?
> 
> [  397.014581] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x0, n_io_port 0, base 0xd8000, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NO_DMA_FIXUP }, options { AUTOPROBE_IRQ PSEUDO_DMA }
> [  412.099695] STATUS_REG: 00
> BASR: 08
> ICR: 00
> MODE: 00
> [  412.103625] STATUS_REG: 00
> BASR: 08
> ICR: 00
> MODE: 00
> [  412.110503] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
> [  412.110892] STATUS_REG: 00
> BASR: 08
> ICR: 00
> MODE: 00
> [  412.114154] STATUS_REG: 00
> BASR: 08
> ICR: 00
> MODE: 00
> [  412.119733] STATUS_REG: 00
> BASR: 08
> ICR: 00
> MODE: 00
> [  427.198108] STATUS_REG: 00
> BASR: 08
> ICR: 00
> MODE: 00
> [  442.276586] STATUS_REG: 00
> BASR: 08
> ICR: 00
> MODE: 00
> [  457.354592] STATUS_REG: 00
> BASR: 08
> ICR: 00
> MODE: 00
> [  472.432999] STATUS_REG: 00
> BASR: 08
> ICR: 00
> MODE: 00
> [  487.513027] sd 2:0:1:0: Attached scsi generic sg1 type 0
> 
> 

I see that the delay increased from 22 seconds to 90 seconds. Perhaps that 
is because the remaining patches were applied.

Anyway, it seems to confirm that this delay comes from scanning the six 
unused SCSI bus IDs. Each one takes 15 seconds. Could be a five second 
timeout and three retries. It's hard to tell because the dsprintk() 
logging didn't show up. Can you try modprobe after,
# echo 1 > /sys/module/printk/parameters/ignore_loglevel
And maybe also,
# scsi_logging_level -sS7

It seems like the 53C400 chip doesn't arbitrate like a 53C80, but that 
doesn't make sense given it contains a 53C80 logic block. Perhaps some 
extra initialization is needed. Which card(s) are affected?

Aside from trying to figure out why the chip behaves oddly, we could also 
try to figure out whether the driver and its main loop is causing problems 
for other tasks i.e. timekeeping watchdog. Does this patch make any 
difference?

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-11-26 15:42:01.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-11-26 15:42:04.000000000 +1100
@@ -925,6 +925,7 @@ static void NCR5380_main(struct work_str
 		container_of(work, struct NCR5380_hostdata, main_task);
 	struct Scsi_Host *instance = hostdata->host;
 	struct scsi_cmnd *cmd;
+	unsigned long deadline = jiffies + msecs_to_jiffies(10);
 	int done;
 
 	/*
@@ -984,9 +985,12 @@ static void NCR5380_main(struct work_str
 			done = 0;
 		}
 		spin_unlock_irq(&hostdata->lock);
-		if (!done)
-			cond_resched();
-	} while (!done);
+		if (done || time_is_before_jiffies(deadline))
+			break;
+		cond_resched();
+	} while (1);
+	if (!done)
+		queue_work(hostdata->work_q, &hostdata->main_task);
 }
 
 
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-26 15:42:01.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-26 15:42:04.000000000 +1100
@@ -817,6 +817,7 @@ static void NCR5380_main(struct work_str
 		container_of(work, struct NCR5380_hostdata, main_task);
 	struct Scsi_Host *instance = hostdata->host;
 	struct scsi_cmnd *cmd;
+	unsigned long deadline = jiffies + msecs_to_jiffies(10);
 	int done;
 
 	do {
@@ -860,9 +861,12 @@ static void NCR5380_main(struct work_str
 			done = 0;
 		}
 		spin_unlock_irq(&hostdata->lock);
-		if (!done)
-			cond_resched();
-	} while (!done);
+		if (done || time_is_before_jiffies(deadline))
+			break;
+		cond_resched();
+	} while (1);
+	if (!done)
+		queue_work(hostdata->work_q, &hostdata->main_task);
 }
 
 #ifndef DONT_USE_INTR
