From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380 drivers
Date: Sun, 22 Nov 2015 00:07:12 +0100
Message-ID: <201511220007.35517.linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au> <alpine.LNX.2.00.1511211144460.23065@nippy.intranet> <201511211401.39957.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:41077 "EHLO
	smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbbKUXIB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Nov 2015 18:08:01 -0500
In-Reply-To: <201511211401.39957.linux@rainbow-software.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Saturday 21 November 2015 14:01:39 Ondrej Zary wrote:
> On Saturday 21 November 2015 02:58:57 Finn Thain wrote:
> > 
> > Hi Ondrej,
> > 
> > On Fri, 20 Nov 2015, Ondrej Zary wrote:
> > 
> > > On Friday 20 November 2015 02:41:19 Finn Thain wrote:
> > > > 
> > > > 
> > > > My tests involved 3 different scsi targets (two disks and a CD-ROM) 
> > > > but none of these send a SDTR. Your log says the driver correctly 
> > > > rejected the SDTR message but that doesn't mean the target actually 
> > > > went to MSG IN phase and got the message. Do you have any older 
> > > > targets you can test?
> > > 

[...]

> > > 
> > 
> > Thanks for these test results! It looks like READ(10) commands don't work. 
> > I don't know the cause of the failures but it appears to be an old bug. 
> > Did you find any regression?
> > 
> > I gather that your setup here is a QUANTUM LP240S target with Domex 3181 
> > (DTC-436) card and g_NCR5380 module. I've been testing a similar setup: 
> > QUANTUM LPS540S target with a Domex 3191D (DTC-536) card and dmx3191d 
> > module. In both setups PIO is used exclusively, no IRQ is used, and 
> > FLAG_DTC3181E is set. I didn't see any issues in my tests, so your results 
> > are surprising.
> 
> I agree that the results are surprising. Even tried 2.4 kernels (Debian 3.1)
> and even 2.2 (Debian 3.0) and nothing worked.
> HW is fine - the drive is accessible in Windows 98 (with Domex driver
> installed).
> 
> Now testing the Canon FG2-5202 controller - a simple 8-bit ISA card with only
> two chips: NCR 53C400 and 74LS245. It's memory mapped, IRQ hardwired to 7.
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
> Seems that the PSEUDO_DMA is broken. After adding FLAG_NO_PSEUDO_DMA:
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

Even the HP C2502 (that never worked) works now. It's 8-bit card based on
NCR 53C400A (there are also 74ALS245 and 3 PALCE chips).
Configuration is by using magic numbers, wrote a simple userspace enabler:

#include <stdio.h>
#include <sys/io.h>

const unsigned short io_ports[] = { 0x280, 0x290, 0x300, 0x310, 0x330, 0x340, 0x348, 0x350 };

/* IRQs: 2,3,4,5,7 */
void configure_hp400a(int idx, unsigned char irq) {
        unsigned char b = 0;

        outb(0x0f, 0x779);
        outb(0x22, 0x379);
        outb(0xf0, 0x379);
        outb(0x20, 0x379);
        outb(0x80, 0x379);
        if (irq != 2 && irq != 3 && irq != 4 && irq != 5 && irq != 7)
                irq = 0;
        if (idx >= 0 && idx <= 7)
                b = 0x80 | idx | (irq << 4);
        outb(b, 0x379);
}

int main(void) {
        if (iopl(3)) {
                perror("iopl");
                return 1;
        }

        configure_hp400a(0, 7);

        return 0;
}

And now:
# modprobe g_NCR5380 ncr_irq=255 ncr_addr=0x280 ncr_53c400a=1

[   79.051669] scsi2 : interrupts not enabled. for better interactive performance,
[   79.051770] scsi2 : please jumper the board for a free IRQ.
[   79.051833] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x280, n_io_port 16, base 0x0, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NO_PSEUDO_DMA }, options { AUTOPROBE_IRQ PSEUDO_DMA }
[   95.390329] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
[  177.022776] sd 2:0:1:0: Attached scsi generic sg1 type 0
[  177.041505] sd 2:0:1:0: [sdb] 479350 512-byte logical blocks: (245 MB/234 MiB)
[  177.044491] sd 2:0:1:0: [sdb] Write Protect is off
[  177.049605] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  177.129093]  sdb: sdb1
[  177.145439] sd 2:0:1:0: [sdb] Attached SCSI disk

# hdparm -t --direct /dev/sdb

/dev/sdb:
 Timing O_DIRECT disk reads:   2 MB in 21.38 seconds =  95.77 kB/sec

Seems to work without IRQ.
With IRQ is enabled, no interrupts are shown in /proc/interrupts.

-- 
Ondrej Zary
