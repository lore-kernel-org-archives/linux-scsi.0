From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 22/71] ncr5380: Eliminate selecting state
Date: Tue, 24 Nov 2015 20:08:34 +0100
Message-ID: <201511242008.35378.linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au> <20151118083501.571002212@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151118083501.571002212@telegraphics.com.au>
Content-Disposition: inline
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 18 November 2015 09:35:17 Finn Thain wrote:
> Linux v2.1.105 changed the algorithm for polling for the BSY signal
> in NCR5380_select() and NCR5380_main().
> 
> Presently, this code has a bug. Back then, NCR5380_set_timer(hostdata, 1)
> meant reschedule main() after sleeping for 10 ms. Repeated 25 times this
> provided the recommended 250 ms selection time-out delay. This got broken
> when HZ became configurable.
> 
> We could fix this but there's no need to reschedule the main loop. This
> BSY polling presently happens when the NCR5380_main() work queue item
> calls NCR5380_select(), which in turn schedules NCR5380_main(), which
> calls NCR5380_select() again, and so on.
> 
> This algorithm is a deviation from the simpler one in atari_NCR5380.c.
> The extra complexity and state is pointless. There's no reason to
> stop selection half-way and return to to the main loop when the main
> loop can do nothing useful until selection completes.
> 
> So just poll for BSY. We can sleep while polling now that we have a
> suitable workqueue.

Bisecting slow module initialization pointed to this commit.

Before this commit (2 seconds):
[   60.317374] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x0, n_io_port 0, base 0xd8000, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NCR53C400 }, USLEEP_POLL 3, USLEEP_SLEEP 50, options { AUTOPROBE_IRQ PSEUDO_DMA }
[   60.780715] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
[   62.606260] sd 2:0:1:0: Attached scsi generic sg1 type 0


After this commit (22 seconds):
[  137.511711] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x0, n_io_port 0, base 0xd8000, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NCR53C400 }, USLEEP_POLL 3, USLEEP_SLEEP 50, options { AUTOPROBE_IRQ PSEUDO_DMA }
[  145.028532] clocksource: timekeeping watchdog: Marking clocksource 'tsc' as unstable because the skew is too large:
[  145.029767] clocksource:                       'acpi_pm' wd_now: a49738 wd_last: f4da04 mask: ffffff
[  145.029828] clocksource:                       'tsc' cs_now: 2ea624698e cs_last: 2c710aa17f mask: ffffffffffffffff
[  145.032733] clocksource: Switched to clocksource acpi_pm
[  145.236951] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
[  159.959308] sd 2:0:1:0: Attached scsi generic sg1 type 0


-- 
Ondrej Zary
