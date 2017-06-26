From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v2 0/5] g_NCR5380: PDMA fixes and cleanup
Date: Mon, 26 Jun 2017 10:20:37 +0200
Message-ID: <201706261020.38053.linux@rainbow-software.org>
References: <cover.1498285948.git.fthain@telegraphics.com.au> <201706251126.23739.linux@rainbow-software.org> <alpine.LNX.2.00.1706261511280.9167@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1706261511280.9167@nippy.intranet>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Monday 26 June 2017, Finn Thain wrote:
> On Sun, 25 Jun 2017, Ondrej Zary wrote:
> > It mostly works, but there are some problems:
> >
> > It's not reliable - we continue the data transfer after poll_politely2
> > returns zero but we don't know if it returned because of host buffer
> > being ready of because of an IRQ. So if a device disconnects during
> > write, we continue to fill the buffer and only then find out that wait
> > for 53c80 registers timed out. Then PDMA gets disabled:
> > [ 3458.774251] sd 2:0:1:0: [sdb] tag#0 53c80 registers not accessible,
> > device will be reset [ 3458.774251] sd 2:0:1:0: [sdb] tag#0 switching to
> > slow handshake
>
> Sorry about that. I messed up the Gated-IRQ-is-asserted case when I
> changed the algorithm to avoid adding more polling loops.
>
> > We can just reset and continue with a new PDMA transfer.
>
> We should only reset the 53c400 logic when there is a real failure (like
> no access to 53c80 registers). If a reset is needed to handle normal
> target behaviour (like disconnection during a slow transfer) then we are
> doing something wrong.

The reset is probably the only way to terminate a PDMA transfer.

> > Found no problems with reads. But when this happens during a write, we
> > might have lost some data buffers that we need to transfer again. The
> > chip's PDMA block counter does not seem to be very helpful here -
> > testing shows that either one buffer is missing in the file or is
> > duplicated.
> >
> > That's why my code had separate host buffer ready and IRQ checks. Host
> > buffer first - if it's ready, transfer the data. If not, check for IRQ -
> > if it was an error, rollback 2 buffers (the same if the host buffer is
> > not ready in time).
>
> In v3 of the patch series I've fixed the Gated IRQ logic so the transfer
> loop will terminate early.
>
> > There's also a performance regression on DTC436 - the sg_tablesize limit
> > affects performance badly.
> > Before:
> > # hdparm -t --direct /dev/sdb
> >
> > /dev/sdb:
> >  Timing O_DIRECT disk reads:   4 MB in  3.21 seconds =   1.25 MB/sec
> >
> > Now:
> > # hdparm -t --direct /dev/sdb
> >
> > /dev/sdb:
> >  Timing O_DIRECT disk reads:   4 MB in  4.89 seconds = 837.69 kB/sec
>
> The lost throughput can perhaps be explained by extra kernel-mode CPU
> overhead. Next time maybe check for that with "time hdparm". Anyway, since
> you have a patch, we should try to avoid this regression.

I don't think the CPU is that slow. It probably decreases the SCSI read 
command length and we must wait for the drive to process each command (it 
probably does no read-ahead).

> > We should limit the transfer size instead:
> > --- a/drivers/scsi/g_NCR5380.c
> > +++ b/drivers/scsi/g_NCR5380.c
> > @@ -45,7 +45,8 @@
> >         int c400_blk_cnt; \
> >         int c400_host_buf; \
> >         int io_width; \
> > -       int pdma_residual
> > +       int pdma_residual; \
> > +       int board;
> >
> >  #define NCR5380_dma_xfer_len            generic_NCR5380_dma_xfer_len
> >  #define NCR5380_dma_recv_setup          generic_NCR5380_pread
> > @@ -247,7 +248,6 @@ static int generic_NCR5380_init_one(struct
> > scsi_host_template *tpnt, case BOARD_DTC3181E:
> >                 ports = dtc_3181e_ports;
> >                 magic = ncr_53c400a_magic;
> > -               tpnt->sg_tablesize = 1;
> >                 break;
> >         }
>
> I've dropped my "sg_tablesize = 1" patch from the v3 series.
>
> > @@ -317,6 +317,7 @@ static int generic_NCR5380_init_one(struct
> > scsi_host_template *tpnt, }
> >         hostdata = shost_priv(instance);
> >
> > +       hostdata->board = board;
> >         hostdata->io = iomem;
> >         hostdata->region_size = region_size;
>
> I've added the hostdata->board variable in v3. It looks like we are going
> to need it one way or another.
>
> > @@ -625,6 +626,9 @@ static int generic_NCR5380_dma_xfer_len(struct
> > NCR5380_hostdata *hostdata, /* 53C400 datasheet: non-modulo-128-byte
> > transfers should use PIO */ if (transfersize % 128)
> >                 transfersize = 0;
> > +       /* Limit transfers to 512B to prevent random write corruption on
> > DTC */ +       if (hostdata->board == BOARD_DTC3181E && transfersize >
> > 512) +               transfersize = 512;
> >
> >         return min(transfersize, DMA_MAX_SIZE);
> >  }
> >
> >
> > No data corruption
>
> How did you confirm that? What about a 1024 byte limit? 2048? 4096? Does
> it make any difference?
>
> Do you have any theories that might explain the need for a 512 B limit?

Tested it by copying a large file (230 MB of random data) to a slow Quantum 
240MB HDD, then read it back and compare. No corruption with 512B, corruption 
with anything more.

My theory is that with 512 B size, no disconnect occurs during a transfer 
(because the drive has 512 B sectors).

> My theory about the "read overrun" issue doesn't seem applicable, given
> that this is actually the CMOS version, which has different errata than
> the NMOS version.
>
> The need for udelay(4) on this board does suggest timing issues. What
> happens if you add a udelay into the generic_NCR5380_pwrite() loop?

I've had major problems with this DTC chip on one mainboard (PCPartner with 
VIA 694T chipset) - the chip locked up and died completely until reset. This 
udelay worked it around at one place but it eventually died somewhere else. 
No amount of delays helped.

Tested the DTC card with another mainboard - Procomp BIZ1A (i440ZX chipset) 
and all the weird problems went away! Looks like there's a HW incompatibility 
between the PCPartner board (or its VIA chipset) and the DTC chip/card. So 
I'm now using the Procomp board for testing. 

> > and no performance regression:
> > # hdparm -t --direct /dev/sdb
>
> Well, I'd still expect some added CPU overhead. The driver is being handed
> a 4096 byte transfer and is now splitting that up into eight separate
> transfers. That means eight times as many DMA setup and completion calls
> and presumably a similar increase in interrupts.

Yes, there's still some overhead but it seems minimal compared to the drive 
slowness.

> > /dev/sdb:
> >  Timing O_DIRECT disk reads:   4 MB in  3.25 seconds =   1.23 MB/sec
> >
> > As the data corruption affects only writes, we could keep transfersize
> > unlimited for reads:
> > +       /* Limit write transfers to 512B to prevent random corruption on
> > DTC */ +       if (hostdata->board == BOARD_DTC3181E &&
> > +           cmd->sc_data_direction == DMA_TO_DEVICE && transfersize >
> > 512) +               transfersize = 512;
> >
> > So we can get some performance gain at least for reads:
> > # hdparm -t --direct /dev/sdb
> >
> > /dev/sdb:
> >  Timing O_DIRECT disk reads:   6 MB in  4.17 seconds =   1.44 MB/sec
>
> Right. No need to penalize read performance by splitting up transfers.
>
> Anyway, I'd really like to get some idea of the root cause before I sign
> off on this particular approach.

I don't like this workaround but haven't found anything better yet.

-- 
Ondrej Zary
