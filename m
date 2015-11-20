From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380 drivers
Date: Fri, 20 Nov 2015 08:35:19 +0100
Message-ID: <201511200835.20019.linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au> <201511192350.58253.linux@rainbow-software.org> <alpine.LNX.2.00.1511201238430.31133@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1511201238430.31133@nippy.intranet>
Content-Disposition: inline
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Friday 20 November 2015, Finn Thain wrote:
> 
> On Thu, 19 Nov 2015, Ondrej Zary wrote:
> 
> > On Thursday 19 November 2015 03:24:56 Finn Thain wrote:
> >
> > > On Wed, 18 Nov 2015, Ondrej Zary wrote:
> > >
> > > >
> > > > I have some NCR5380 ISA cards and can test them.
> > >
> > > Thanks Ondrej. I've no idea which ISA drivers are presently working in 
> > > mainline. Finding regressions may be more difficult than usual ;-)
> > 
> > You're right... looks very broken:
> > 
> > [   62.577194] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x240, n_io_port 16, base 0x0, irq 0, can_queue 16, cmd_per_lun 2, 
> > sg_tablesize 128, this_id 7, flags { DTC3181E NO_PSEUDO_DMA }, USLEEP_POLL 3, USLEEP_WAITLONG 1250, options { AUTOPROBE_IRQ PSEUDO_DMA 
> > NCR53C400 }
> > [   62.796635] scsi 2:0:0:0: Direct-Access     IBM      0663             e    PQ: 0 ANSI: 2
> > [   63.878494] sd 2:0:0:0: Attached scsi generic sg1 type 0
> > [   95.848260] sd 2:0:0:0: aborting command
> > 
> > And the system hangs completely.
> > 
> 
> Yes. That was the usual failure mode. The old EH abort routine is fatal. 
> Up until I disabled PDMA by default for mac_scsi (in v3.19), that driver 
> would do the same thing.
> 
> > It's much better with your patches, but still not great :)
> > 
> 
> Pleased to hear it :)
> 
> > [   93.963264] pnp 01:01.00: [io  0x0240-0x025f]
> > [   93.963493] pnp 01:01.00: [irq 5]
> > [   93.965768] pnp 01:01.00: activated
> > [   93.977147] scsi host2: Generic NCR5380/NCR53C400 SCSI, io_port 0x240, n_io_port 16, base 0x0, irq 0, can_queue 16, cmd_per_lun 2, 
> > sg_tablesize 128, this_id 7, flags { DTC3181E NO_PSEUDO_DMA }, options { AUTOPROBE_IRQ PSEUDO_DMA }
> > [   93.987527] scsi host2: rejecting message
> > [   93.987647] Synchronous Data Transfer Request period = 100 ns offset = 12
> > [   94.001219] scsi 2:0:0:0: Direct-Access     IBM      0663             e    PQ: 0 ANSI: 2
> > [  113.000794] sd 2:0:0:0: Attached scsi generic sg1 type 0
> 
> I'd be interested to know what commands were in play in that 19 second 
> interval. Might need to use scsi_logging_level to figure that out.
> 
> My tests involved 3 different scsi targets (two disks and a CD-ROM) but 
> none of these send a SDTR. Your log says the driver correctly rejected the 
> SDTR message but that doesn't mean the target actually went to MSG IN 
> phase and got the message. Do you have any older targets you can test?

Yes, I have some older disks too and also CD-ROMs. This one was just handy in
an external enclosure (the card has only an external DB25 connector). It can
be opened easily so I'll test the other devices too.

> > [  144.852432] sd 2:0:0:0: [sdb] Unit Not Ready
> > [  144.852574] sd 2:0:0:0: [sdb] Sense Key : Aborted Command [current]
> > [  144.852713] sd 2:0:0:0: [sdb] Add. Sense: Select or reselect failure
> 
> AFAIK, the target should not have to abort any commands. Moreover, the 
> target should never experience a select/reselect failure, because you have 
> irq == 0 (see above) and that implies that the target is never permitted 
> the disconnect privilege.
> 
> > [  240.108292] INFO: task modprobe:1957 blocked for more than 120 seconds.
> > [  240.108418]       Not tainted 4.3.0-rc1+ #74
> 
> Why not use v4.3?

I had that already built so just quickly applied the patches and tested. I have
to update the git tree anyway as ACPI is broken.

> > [  240.108501] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  240.108597] modprobe        D 0000001a     0  1957   1950 0x00000000
> > [  240.108790]  ce0fad00 00000086 53881781 0000001a c1525f88 4edbe39c 0000001a 04ac33e5
> > [  240.109246]  00000000 ccd54000 ffffffff ffffffff d204b280 c139c504 00000000 c104416d
> > [  240.109699]  00000000 ce0fad00 c1054a45 c151fd8c c151fd8c d204b280 00000000 ccd6d100
> > [  240.110156] Call Trace:
> > [  240.110295]  [<c139c504>] ? schedule+0x5b/0x67
> > [  240.110430]  [<c104416d>] ? async_synchronize_cookie_domain+0x73/0x9f
> > [  240.110569]  [<c1054a45>] ? abort_exclusive_wait+0x6e/0x6e
> > [  240.110699]  [<c10ac9bc>] ? do_init_module+0xa4/0x1a3
> > [  240.110824]  [<c107ddb5>] ? load_module+0x14de/0x18ca
> > [  240.110948]  [<c107e2a0>] ? SyS_finit_module+0x47/0x56
> > [  240.111068]  [<c139e2c0>] ? sysenter_do_call+0x12/0x12
> 
> Not sure what module was being probed here. I presume it was g_NCR5380 or 
> g_NCR5380_mmio. Neither of these calls 'scsi_scan_host'. I'm not sure what 
> the implications are (?)

It was g_NCR5380 (DTCT-436P card).

> > [  240.852458] sd 2:0:0:0: [sdb] Read Capacity(10) failed: Result: hostbyte=DID_TIME_OUT driverbyte=DRIVER_SENSE
> > [  240.852620] sd 2:0:0:0: [sdb] Sense Key : Aborted Command [current]
> > [  240.852760] sd 2:0:0:0: [sdb] Add. Sense: Select or reselect failure
> > [  272.852471] sd 2:0:0:0: [sdb] Write Protect is off
> > [  272.852614] sd 2:0:0:0: [sdb] Mode Sense: 00 00 00 00
> > [  304.084452] sd 2:0:0:0: [sdb] Asking for cache data failed
> > [  304.084592] sd 2:0:0:0: [sdb] Assuming drive cache: write through
> 
> This looks like nonsense to me ... I don't think the target actually 
> aborted the reselection phase of a read capacity command. I'm out of ideas 
> here. Can anyone else make sense of this?


-- 
Ondrej Zary
