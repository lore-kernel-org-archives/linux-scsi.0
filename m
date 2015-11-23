From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380 drivers
Date: Mon, 23 Nov 2015 23:55:03 +0100
Message-ID: <201511232355.04017.linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au> <201511211401.39957.linux@rainbow-software.org> <alpine.LNX.2.00.1511221001400.7671@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1511221001400.7671@nippy.intranet>
Content-Disposition: inline
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sunday 22 November 2015 00:32:31 Finn Thain wrote:
> 
> On Sat, 21 Nov 2015, Ondrej Zary wrote:
> 
> > On Saturday 21 November 2015 02:58:57 Finn Thain wrote:
> > 
> > > 
> > > I gather that your setup here is a QUANTUM LP240S target with Domex 
> > > 3181 (DTC-436) card and g_NCR5380 module. I've been testing a similar 
> > > setup: QUANTUM LPS540S target with a Domex 3191D (DTC-536) card and 
> > > dmx3191d module. In both setups PIO is used exclusively, no IRQ is 
> > > used, and FLAG_DTC3181E is set. I didn't see any issues in my tests, 
> > > so your results are surprising.
> > 
> > I agree that the results are surprising. Even tried 2.4 kernels (Debian 
> > 3.1) and even 2.2 (Debian 3.0) and nothing worked. HW is fine - the 
> > drive is accessible in Windows 98 (with Domex driver installed).
> 
> That's good to know (and very thorough).
> 
> > 
> > Now testing the Canon FG2-5202 controller - a simple 8-bit ISA card with 
> > only two chips: NCR 53C400 and 74LS245. It's memory mapped, IRQ 
> > hardwired to 7.
> > 
> > # modprobe g_NCR5380_mmio ncr_irq=255 ncr_addr=0xd8000 ncr_53c400=1
> > 
> > [ 1245.919223] scsi2 : interrupts not enabled. for better interactive performance,
> > [ 1245.919326] scsi2 : please jumper the board for a free IRQ.
> > [ 1245.919389] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x0, n_io_port 0, base 0xd8000, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NCR53C400 }, USLEEP_POLL 3, USLEEP_WAITLONG 1250, options { AUTOPROBE_IRQ PSEUDO_DMA NCR53C400 }
> > [ 1246.376738] scsi 2:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
> > [ 1248.202198] sd 2:0:1:0: Attached scsi generic sg1 type 0
> > [ 1248.420856] 53C400r: no 53C80 gated irq after transfer
> > [ 1248.420948] 53C400r: no end dma signal
> > [ 1248.422459] sd 2:0:1:0: [sdb] Sector size 0 reported, assuming 512.
> > 
> > Seems that the PSEUDO_DMA is broken.
> 
> That's been my experience with mac_scsi also (going back 10 years). I'm 
> told that it used to work in v2.2. PIO was always usable though hopelessly 
> slow.
> 
> I haven't yet done any work on the PDMA problem with mac_scsi because 
> crashing bugs and the forked core driver seemed to be the more pressing 
> problems. And resolving the fork has implications for all of the DMA 
> variations anyway.

PDMA seems to be broken in multiple ways. NCR5380_pread cannot process less
than 128 bytes. In fact, 53C400 datasheet says that it's HW limitation:
non-modulo-128-byte transfers should use PIO.

Adding
        transfersize = round_down(transfersize, 128);
to generic_NCR5380_dma_xfer_len() improves the situation a bit.

After modprobe, some small reads (8, 4, 24 and 64 bytes) are done using PIO,
then eight 512-byte reads using PDMA and then it fails on a 254-byte read.
First 128 bytes are read using PDMA and the next PDMA operation hangs waiting
forever for the host buffer to be ready.

-- 
Ondrej Zary
