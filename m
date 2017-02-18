From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: g_NCR5380 PDMA, was Re: [PATCH 0/6] ncr5380: Miscellaneous minor patches
Date: Sat, 18 Feb 2017 12:10:07 +0100
Message-ID: <201702181210.08593.linux@rainbow-software.org>
References: <cover.1484523085.git.fthain@telegraphics.com.au> <201702162318.52483.linux@rainbow-software.org> <alpine.LNX.2.00.1702180934190.13115@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1702180934190.13115@nippy.intranet>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Friday 17 February 2017 23:38:12 Finn Thain wrote:
> On Thu, 16 Feb 2017, Ondrej Zary wrote:
> > On Tuesday 31 January 2017 02:31:45 Finn Thain wrote:
> > [...]
> >
> > > Are you trying to figure out which commands are going to disconnect
> > > during a transfer? This is really a function of the firmware in the
> > > target; there are no good heuristics AFAICT, so the PDMA algorithm has
> > > to be robust. mac_scsi has to cope with this too.
> > >
> > > Does the problem go away when you assign no IRQ? When instance->irq ==
> > > NO_IRQ, the core driver will inhibit disconnect privileges.
> >
> > Yes, it seems to run fine with IRQ/disconnect disabled. With IRQ
> > enabled, "dd if=/dev/sr0 of=anything" stops after a while.
>
> When you say "stops", do you mean an infinite loop in
> generic_NCR5380_pread or does the loop complete (which would presumably
> leave the target stuck in DATA IN phase, and a scsi command timeout would
> probably follow after 30 seconds...)

I've added timeouts to the possibly-infinite loops. It times out waiting for 
the host buffer to become ready. Then everything breaks.
Now I found why: pread() returns without waiting for the 53C80 registers to be 
ready. Adding the wait allows to continue in PIO mode with "tag#0 switching 
to slow handshake".

> > I get gated 53C80 IRQ, BASR=0x10, MODE=0x0e, STATUS=0x7c.
>
> You can use NCR5380_print() to get a decoded register dump.
>
> When I decode the above values I get,
>
> BASR   = 0x10 = BASR_IRQ
> MODE   = 0x0e = MR_ENABLE_EOP_INTR | MR_MONITOR_BSY | MR_DMA_MODE
> STATUS = 0x7c = SR_BSY | SR_REQ | SR_MSG | SR_CD | SR_IO
>
> Since BASR_PHASE_MATCH is not set, the interrupt is almost certainly a
> phase mismatch. The new phase is SR_MSG | SR_CD | SR_IO = PHASE_MSGIN,
> which shows that the target has given up on the DATA IN phase and is
> presumably trying to send a DISCONNECT message.

Looks you're right. The transfersize is 4096, i.e. 2 CD-ROM sectors. When the 
2nd sector is not ready in the drive internal buffer, the drive probably 
disconnects which breaks the fragile pdma transfer. When the transfersize is 
limited to 2048 bytes, the problem goes away.

The problem also went away with enabled interrupts because I had some debug 
printks added which were slowing down the transfer enough for the drive (SONY 
CDU-55S) to keep up and not disconnect. Got the same result by inserting 
udelay(100) after each 128 byte block trasnferred in pread().

> > When I enable interrupts during PDMA (like the removed UNSAFE macro
> > did), the problems go away. I see an IRQ after each pread call.
>
> You shouldn't need an interrupt, because NCR5380_dma_complete() gets
> called regardless. AFAICT, the only difference is the timing, which
> becomes less predictable. Calling spinlock_irq_restore() before the
> transfer seems to create a race condition between hostdata->dma_len store
> and load.
>
> I think that the pread call has not yet returned when the interrupt fires
> and NCR5380_dma_complete() is called. Hence hostdata->dma_len has not yet
> been initialized. So when NCR5380_dma_complete() is called by the
> interrupt handler, SCp.this_residual will not change at all because
> hostdata->dma_len is still zero.
>
> > (had to disable "no 53C80 gated irq after transfer" and "no end dma
> > signal" messages to reduce log spam)
>
> That may provide a quick way to detect the failed PDMA transfer, at least
> for testing purposes. There may be a more conclusive test for a partial
> transfer.
>
> We could to implement something like macscsi_dma_residual() to take care
> of a failed PDMA transfer. That way, the failure can be taken into account
> when NCR5380_dma_complete() is called at the end of the transfer.
>
> See patch below for example. It should confirm the theory above though it
> really needs some timeouts added (NCR5380_poll_politely()). And perhaps we
> could do something more clever than retry indefinitely, though we can
> still rely on the command timeout.

Thanks for idea

> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 6f9665d..75cfaf3 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -497,15 +497,17 @@ static inline int generic_NCR5380_pread(struct
> NCR5380_hostdata *hostdata, blocks--;
>  	}
>
> +	hostdata->pdma_residual = 0;
> +
>  	if (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ))
> -		printk("53C400r: no 53C80 gated irq after transfer");
> +		hostdata->pdma_residual = hostdata->dma_len;
>
>  	/* wait for 53C80 registers to be available */
>  	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG))
>  		;
>
>  	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER))
> -		printk(KERN_ERR "53C400r: no end dma signal\n");
> +		hostdata->pdma_residual = hostdata->dma_len;
>
>  	return 0;
>  }
> @@ -576,12 +578,14 @@ static inline int generic_NCR5380_pwrite(struct
> NCR5380_hostdata *hostdata, /* FIXME - no timeout */
>  	}
>
> -	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER)) {
> -		printk(KERN_ERR "53C400w: no end dma signal\n");
> -	}
> +	hostdata->pdma_residual = 0;
> +
> +	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER))
> +		hostdata->pdma_residual = hostdata->dma_len;
>
>  	while (!(NCR5380_read(TARGET_COMMAND_REG) & TCR_LAST_BYTE_SENT))
>  		; 	// TIMEOUT
> +
>  	return 0;
>  }
>
> @@ -607,6 +611,11 @@ static int generic_NCR5380_dma_xfer_len(struct
> NCR5380_hostdata *hostdata, return transfersize;
>  }
>
> +static int generic_NCR5380_dma_residual(struct NCR5380_hostdata *hostdata)
> +{
> +	return hostdata->pdma_residual;
> +}
> +
>  /*
>   *	Include the NCR5380 core code that we build our driver around
>   */
> diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
> index 81b22d9..08c91b7 100644
> --- a/drivers/scsi/g_NCR5380.h
> +++ b/drivers/scsi/g_NCR5380.h
> @@ -26,7 +26,8 @@
>  	int c400_ctl_status; \
>  	int c400_blk_cnt; \
>  	int c400_host_buf; \
> -	int io_width;
> +	int io_width; \
> +	int pdma_residual;
>
>  #define NCR53C400_mem_base 0x3880
>  #define NCR53C400_host_buffer 0x3900
> @@ -35,7 +36,7 @@
>  #define NCR5380_dma_xfer_len		generic_NCR5380_dma_xfer_len
>  #define NCR5380_dma_recv_setup		generic_NCR5380_pread
>  #define NCR5380_dma_send_setup		generic_NCR5380_pwrite
> -#define NCR5380_dma_residual		NCR5380_dma_residual_none
> +#define NCR5380_dma_residual		generic_NCR5380_dma_residual
>
>  #define NCR5380_intr generic_NCR5380_intr
>  #define NCR5380_queue_command generic_NCR5380_queue_command


-- 
Ondrej Zary
