From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380
 drivers
Date: Sun, 22 Nov 2015 10:32:31 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1511221001400.7671@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <201511201929.17000.linux@rainbow-software.org> <alpine.LNX.2.00.1511211144460.23065@nippy.intranet> <201511211401.39957.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <201511211401.39957.linux@rainbow-software.org>
Sender: linux-m68k-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Sat, 21 Nov 2015, Ondrej Zary wrote:

> On Saturday 21 November 2015 02:58:57 Finn Thain wrote:
> 
> > 
> > I gather that your setup here is a QUANTUM LP240S target with Domex 
> > 3181 (DTC-436) card and g_NCR5380 module. I've been testing a similar 
> > setup: QUANTUM LPS540S target with a Domex 3191D (DTC-536) card and 
> > dmx3191d module. In both setups PIO is used exclusively, no IRQ is 
> > used, and FLAG_DTC3181E is set. I didn't see any issues in my tests, 
> > so your results are surprising.
> 
> I agree that the results are surprising. Even tried 2.4 kernels (Debian 
> 3.1) and even 2.2 (Debian 3.0) and nothing worked. HW is fine - the 
> drive is accessible in Windows 98 (with Domex driver installed).

That's good to know (and very thorough).

> 
> Now testing the Canon FG2-5202 controller - a simple 8-bit ISA card with 
> only two chips: NCR 53C400 and 74LS245. It's memory mapped, IRQ 
> hardwired to 7.
> 
> # modprobe g_NCR5380_mmio ncr_irq=255 ncr_addr=0xd8000 ncr_53c400=1
> 
> [ 1245.919223] scsi2 : interrupts not enabled. for better interactive performance,
> [ 1245.919326] scsi2 : please jumper the board for a free IRQ.
> [ 1245.919389] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x0, n_io_port 0, base 0xd8000, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NCR53C400 }, USLEEP_POLL 3, USLEEP_WAITLONG 1250, options { AUTOPROBE_IRQ PSEUDO_DMA NCR53C400 }
> [ 1246.376738] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
> [ 1248.202198] sd 2:0:1:0: Attached scsi generic sg1 type 0
> [ 1248.420856] 53C400r: no 53C80 gated irq after transfer
> [ 1248.420948] 53C400r: no end dma signal
> [ 1248.422459] sd 2:0:1:0: [sdb] Sector size 0 reported, assuming 512.
> 
> Seems that the PSEUDO_DMA is broken.

That's been my experience with mac_scsi also (going back 10 years). I'm 
told that it used to work in v2.2. PIO was always usable though hopelessly 
slow.

I haven't yet done any work on the PDMA problem with mac_scsi because 
crashing bugs and the forked core driver seemed to be the more pressing 
problems. And resolving the fork has implications for all of the DMA 
variations anyway.

> After adding FLAG_NO_PSEUDO_DMA:
> 
> # modprobe g_NCR5380_mmio ncr_irq=255 ncr_addr=0xd8000 ncr_53c400=1
> 
> [   67.974362] scsi2 : interrupts not enabled. for better interactive performance,
> [   67.974463] scsi2 : please jumper the board for a free IRQ.
> [   67.974526] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x0, n_io_port 0, base 0xd8000, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NCR53C400 NO_PSEUDO_DMA }, USLEEP_POLL 3, USLEEP_WAITLONG 1250, options { AUTOPROBE_IRQ PSEUDO_DMA NCR53C400 }
> [   68.432728] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
> [   70.258258] sd 2:0:1:0: Attached scsi generic sg1 type 0
> [   70.277265] sd 2:0:1:0: [sdb] 479350 512-byte logical blocks: (245 MB/234 MiB)
> [   70.482252] sd 2:0:1:0: [sdb] Write Protect is off
> [   70.482335] sd 2:0:1:0: [sdb] Mode Sense: 8b 00 00 08
> [   70.889646] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   73.159513]  sdb: sdb1
> [   74.617099] sd 2:0:1:0: [sdb] Attached SCSI disk
> 
> Yeah, first success! I can even mount the filesystem, although it takes ages
> (a minute) and these messages:
> [  160.872074] sd 2:0:1:0: [sdb] aborting command
> [  161.816083] sd 2:0:1:0: [sdb] aborting command
> 
> # hdparm -t --direct /dev/sdb
> 
> /dev/sdb:
> [  244.840075] sd 2:0:1:0: [sdb] aborting command
> [  248.824078] sd 2:0:1:0: [sdb] aborting command
> [  293.864069] sd 2:0:1:0: [sdb] aborting command
> [  297.824075] sd 2:0:1:0: [sdb] aborting command
> [  319.765020] blk_update_request: critical target error, dev sdb, sector 0
> [  319.972994] blk_update_request: critical target error, dev sdb, sector 0
>  Timing O_DIRECT disk reads:   2 MB in 105.26 seconds =  19.46 kB/sec
> 
> 
> 
> With your patches (and adding FLAG_NO_PSEUDO_DMA), modprobe is slower but
> mount faster (4 seconds) and then works better:
> 
> # modprobe g_NCR5380_mmio ncr_irq=255 ncr_addr=0xd8000 ncr_53c400=1
> 
> [  130.126185] scsi2 : interrupts not enabled. for better interactive performance,
> [  130.126284] scsi2 : please jumper the board for a free IRQ.
> [  130.126347] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x0, n_io_port 0, base 0xd8000, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NO_PSEUDO_DMA }, options { AUTOPROBE_IRQ PSEUDO_DMA }
> [  145.221755] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
> [  220.629912] sd 2:0:1:0: Attached scsi generic sg1 type 0
> [  220.651400] sd 2:0:1:0: [sdb] 479350 512-byte logical blocks: (245 MB/234 MiB)
> [  220.654061] sd 2:0:1:0: [sdb] Write Protect is off
> [  220.659344] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [  220.732415]  sdb: sdb1
> [  220.749760] sd 2:0:1:0: [sdb] Attached SCSI disk
> 
> # hdparm -t --direct /dev/sdb
> 
> /dev/sdb:
>  Timing O_DIRECT disk reads:   2 MB in 18.25 seconds = 112.20 kB/sec
> 
> 
> 
> IRQ seems to work too, although driver always shows "irq 0":

Your right, there's a superficial bug there that affects the banner in the 
log. But it doesn't affect behaviour (the IRQ should still work). It isn't 
a new bug.

> 
> # modprobe g_NCR5380_mmio ncr_irq=7 ncr_addr=0xd8000 ncr_53c400=1
> 
> [  117.263062] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x0, n_io_port 0, base 0xd8000, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NO_PSEUDO_DMA }, options { AUTOPROBE_IRQ PSEUDO_DMA }
> [  132.357474] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
> [  207.765080] sd 2:0:1:0: Attached scsi generic sg1 type 0
> [  207.783415] sd 2:0:1:0: [sdb] 479350 512-byte logical blocks: (245 MB/234 MiB)
> [  207.786167] sd 2:0:1:0: [sdb] Write Protect is off
> [  207.790260] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [  207.859669]  sdb: sdb1
> [  207.876556] sd 2:0:1:0: [sdb] Attached SCSI disk
> 
> # hdparm -t --direct /dev/sdb
> 
> /dev/sdb:
>  Timing O_DIRECT disk reads:   2 MB in 18.30 seconds = 111.94 kB/sec
> 
> # mount /dev/sdb1 /mnt
> # umount /mnt
> # head /proc/interrupts
>            CPU0
>   0:      44793    XT-PIC  timer
>   1:          9    XT-PIC  i8042
>   2:          0    XT-PIC  cascade
>   7:         86    XT-PIC  NCR5380
>   8:          1    XT-PIC  rtc0
>   9:          0    XT-PIC  uhci_hcd:usb1, uhci_hcd:usb2
>  10:       1179    XT-PIC  eth0
>  12:        136    XT-PIC  i8042
>  14:       3411    XT-PIC  pata_via
> 

Nice! Thanks for your perseverance. It is gratifying to see it working.

-- 
