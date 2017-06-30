From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v5 0/6] g_NCR5380: PDMA fixes and cleanup
Date: Fri, 30 Jun 2017 20:07:08 +0200
Message-ID: <201706302007.09690.linux@rainbow-software.org>
References: <cover.1498713600.git.fthain@telegraphics.com.au> <201706292006.56377.linux@rainbow-software.org> <alpine.LNX.2.00.1706301412120.2069@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1706301412120.2069@nippy.intranet>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Friday 30 June 2017 09:12:37 Finn Thain wrote:
> On Thu, 29 Jun 2017, Ondrej Zary wrote:
> > The write corruption is still there. I'm afraid it can't be fixed
> > without rolling "start" back (or inceasing residual) if an error
> > occured, something like this:
> >
> > --- a/drivers/scsi/g_NCR5380.c
> > +++ b/drivers/scsi/g_NCR5380.c
> > @@ -619,6 +621,9 @@ static inline int generic_NCR5380_psend(struct
> >  	               (int)NCR5380_read(hostdata->c400_blk_cnt) * 128);
> >
> >  	if (residual != 0) {
> > +		residual += 128;
> >  		/* 53c80 interrupt or transfer timeout. Reset 53c400 logic. */
> >  		NCR5380_write(hostdata->c400_ctl_status, CSR_RESET);
> >  		NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
> >
> > (seems to work - wrote 230MB and read it back with no differences)
> >
> > The corruption mechanism is:
> > 1. Host buffer is ready so we write 128 B of data there and increment
> >    "start".
> > 2. Chip swaps the buffers, decrements the block counter and starts
> >    writing the data to drive.
> > 3. Drive does not like it (e.g. its buffer is full) so it disconnects.
> > 4. Chip stops writing and asserts an IRQ.
> > 5. We detect the IRQ. The block counter is already decremented, "start"
> >    is already incremented but the data was not written to the drive.
>
> OK. Thanks for that analysis.
>
> It sounds like the c400_blk_cnt value gives the number of buffer swaps
> remaining. If so, that value isn't useful for calculating a residual. I'll
> rework that calculation again.
>
> In your patch, the residual gets increased regardless of the actual cause
> of the short transfer. Nothing prevents the residual from being increased
> beyond the original length of the transfer (due to a flaky target or bus).
> Therefore I've taken a slightly different approach in my patch (below).

Yes, that's wrong. My original patch had "start -= 128" and then check for 
negative value.

> > No more log spamming on DTC but reads are corrupted even more than
> > before. The IRQ check after data transfer increases the chance of
> > catching an IRQ before the buffer could become ready.
>
> If we delay the IRQ check, that just means that CSR_GATED_53C80_IRQ will
> be detected a bit later (128 bytes later)... so not much difference.

The main difference is that my original patch read the CSR once and then:
- transfer data if the buffer is ready, ignoring any IRQ
- if the buffer is not ready, check for an IRQ
- if neither buffer is ready nor IRQ was asserted, check for timeout

So yes, the IRQ will be detected 128 bytes later - but the IRQ is asserted at 
3968 bytes which means the transfer will then be complete.

> > This patch:
> > --- a/drivers/scsi/g_NCR5380.c
> > +++ b/drivers/scsi/g_NCR5380.c
> > @@ -548,8 +548,10 @@ static inline int generic_NCR5380_precv(struct
> >  		start += 128;
> >
> >  		if (NCR5380_read(hostdata->c400_ctl_status) &
> > -		    CSR_GATED_53C80_IRQ)
> > +		    CSR_GATED_53C80_IRQ) {
> > +			printk("r irq at start=%d basr=0x%02x\n", start,
> > NCR5380_read(BUS_AND_STATUS_REG)); break;
> > +		}
> >  	}
> >
> >  	residual = len - start;
> >
> > produces lots of these lines:
> > [  896.194054] r irq at start=128 basr=0x98
> > [  896.197758] r irq at start=3968 basr=0x98
>
> Assuming that the registers are available and valid, the value 0x98 means
> BASR_END_DMA_TRANSFER | BASR_IRQ | BASR_PHASE_MATCH. There is no
> BASR_BUSY_ERROR here, so the cause of the CSR_GATED_53C80_IRQ must be that
> the 53c400 has terminated the transfer by asserting /EOP. That shouldn't
> happen before before the counters run down.
>
> It doesn't make sense. So maybe the 53c80 registers are not valid at this
> point? That means a phase mismatch can't be excluded... unlikely at 128
> bytes into the transfer. Busy error? Also unlikely.
>
> I have to conclude that CSR_GATED_53C80_IRQ and BASR_END_DMA_TRANSFER
> can't be trusted on this board. I guess that's why you examine the BASR
> directly in your original algorithm but ignore BASR_END_DMA_TRANSFER.

Exactly, BASR_END_DMA_TRANSFER causes problems on DTC.

> It does look like some kind of timing issue: the "start" value above
> changes from one log message to the next. Who knows?

Only that two values (128 and 3968) appeared. 3968 = 4096-128, one block 
before the end of transfer. So probably BASR_END_DMA_TRANSFER is asserted one 
block earlier (i.e. when the last block of data is transferred from the drive 
to the chip buffer).
Haven't seen this problem at start=128 before.

> > This fixes the DTC read corruption, although I don't like the repeated
> > ctl_status register reads:
> > --- a/drivers/scsi/g_NCR5380.c
> > +++ b/drivers/scsi/g_NCR5380.c
> > @@ -533,7 +533,7 @@ static inline int generic_NCR5380_precv(struct
> >  			break;
> >
> >  		if (NCR5380_read(hostdata->c400_ctl_status) &
> > -		    CSR_HOST_BUF_NOT_RDY)
> > +		    CSR_GATED_53C80_IRQ && (NCR5380_read(hostdata->c400_ctl_status) &
> > CSR_HOST_BUF_NOT_RDY)) break;
> >
> >  		if (hostdata->io_port && hostdata->io_width == 2)
>
> But that means the transfer will continue even when CSR_HOST_BUF_NOT_RDY.
> Your original algorithm doesn't attempt that. Neither does the algorithm
> in the datasheet. We should try to omit this change.

Sorry for that, it's a bug. I got lost in the conditions.

> > @@ -546,10 +546,6 @@ static inline int generic_NCR5380_precv(struct
> >  		memcpy_fromio(dst + start,
> >  			hostdata->io + NCR53C400_host_buffer, 128);
> >  		start += 128;
> > -
> > -		if (NCR5380_read(hostdata->c400_ctl_status) &
> > -		    CSR_GATED_53C80_IRQ)
> > -			break;
> >  	}
> >
> >  	residual = len - start;
>
> I think we should keep the CSR_GATED_53C80_IRQ check for the other boards,
> if this bogus BASR_END_DMA_TRANSFER problem is confined to DTC436.
>
> How about this change? (to be applied on top of 6/6)

It does not apply. Changed while() {} -> do {} while() manually.

> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 3948f522b4e1..8e80379cfaaa 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -525,16 +525,22 @@ static inline int generic_NCR5380_precv(struct
> NCR5380_hostdata *hostdata, NCR5380_write(hostdata->c400_blk_cnt, len /
> 128);
>
>  	do {
> -		if (NCR5380_poll_politely2(hostdata, hostdata->c400_ctl_status,
> -		                           CSR_HOST_BUF_NOT_RDY, 0,
> -		                           hostdata->c400_ctl_status,
> -		                           CSR_GATED_53C80_IRQ,
> -		                           CSR_GATED_53C80_IRQ, HZ / 64) < 0)
> -			break;
> -
> -		if (NCR5380_read(hostdata->c400_ctl_status) &
> -		    CSR_HOST_BUF_NOT_RDY)
> -			break;
> +		if (hostdata->board == BOARD_DTC3181E) {
> +			/* Ignore bogus CSR_GATED_53C80_IRQ */
> +			if (NCR5380_poll_politely(hostdata, hostdata->c400_ctl_status,
> +			                          CSR_HOST_BUF_NOT_RDY, 0, HZ / 64) < 0)
> +				break;
> +		} else {
> +			if (NCR5380_poll_politely2(hostdata, hostdata->c400_ctl_status,
> +			                           CSR_HOST_BUF_NOT_RDY, 0,
> +			                           hostdata->c400_ctl_status,
> +			                           CSR_GATED_53C80_IRQ,
> +			                           CSR_GATED_53C80_IRQ, HZ / 64) < 0)
> +				break;
> +			if (NCR5380_read(hostdata->c400_ctl_status) &
> +			    CSR_HOST_BUF_NOT_RDY)
> +				break;
> +		}
>
>  		if (hostdata->io_port && hostdata->io_width == 2)
>  			insw(hostdata->io_port + hostdata->c400_host_buf,

It works but it looks really ugly (too many ifs). It also means that we detect 
disconnects only by waiting for timeout.

> @@ -546,10 +552,6 @@ static inline int generic_NCR5380_precv(struct
> NCR5380_hostdata *hostdata, memcpy_fromio(dst + start,
>  				hostdata->io + NCR53C400_host_buffer, 128);
>  		start += 128;
> -
> -		if (NCR5380_read(hostdata->c400_ctl_status) &
> -		    CSR_GATED_53C80_IRQ)
> -			break;
>  	} while (start < len);
>
>  	residual = len - start;
> @@ -600,6 +602,12 @@ static inline int generic_NCR5380_psend(struct
> NCR5380_hostdata *hostdata, break;
>
>  		if (NCR5380_read(hostdata->c400_ctl_status) &
> +		    CSR_HOST_BUF_NOT_RDY && start > 0) {
> +			start -= 128;
> +			break;
> +		}
> +
> +		if (NCR5380_read(hostdata->c400_ctl_status) &
>  		    CSR_GATED_53C80_IRQ)
>  			break;
>

This works too, although I'm not sure if the conditions are 100% correct. I'm 
getting lost again. That means that we roll back 128 bytes & "break" when the 
buffer is not ready and we already wrote something. We also "break" when IRQ 
arrives. But what if the buffer is not ready and start == 0?

> @@ -615,8 +623,7 @@ static inline int generic_NCR5380_psend(struct
> NCR5380_hostdata *hostdata, start += 128;
>  	} while (start < len);
>
> -	residual = max(len - start,
> -	               (int)NCR5380_read(hostdata->c400_blk_cnt) * 128);
> +	residual = len - start;
>
>  	if (residual != 0) {
>  		/* 53c80 interrupt or transfer timeout. Reset 53c400 logic. */


-- 
Ondrej Zary
