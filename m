From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 76/71] ncr5380: Enable PDMA for DTC chips
Date: Sun, 6 Dec 2015 14:40:56 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1512051013200.31458@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <1449263854-14436-1-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449263854-14436-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Fri, 4 Dec 2015, Ondrej Zary wrote:

> Add I/O register mapping for DTC chips and enable PDMA mode.
> 
> These chips have 16-bit wide HOST BUFFER register (counter register at
> offset 0x0d increments by 2 on each HOST BUFFER read). Detect it
> automatically.
> 
> Large PIO transfers crash at least the DTCT-436P chip (all reads result
> in 0xFF) so this patch actually makes it work.
> 
> The chip also crashes when we bang the C400 host status register too
> heavily after PDMA write - a small udelay is needed.
> 
> Tested on DTCT-436P and verified that it does not break 53C400A.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/scsi/g_NCR5380.c |   59 ++++++++++++++++++++++++++++------------------
>  drivers/scsi/g_NCR5380.h |    4 +++-
>  2 files changed, 39 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 85da3c2..9816b81 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -328,7 +328,7 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  			ports = ncr_53c400a_ports;
>  			break;
>  		case BOARD_DTC3181E:
> -			flags = FLAG_NO_PSEUDO_DMA;
> +			flags = FLAG_NO_DMA_FIXUP;

Nice!

>  			ports = dtc_3181e_ports;
>  			break;
>  		}
> @@ -412,10 +412,12 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  			hostdata->c400_blk_cnt = 1;
>  			hostdata->c400_host_buf = 4;
>  		}
> -		if (overrides[current_override].board == BOARD_NCR53C400A) {
> +		if (overrides[current_override].board == BOARD_NCR53C400A ||
> +		    overrides[current_override].board == BOARD_DTC3181E) {
>  			hostdata->c400_ctl_status = 9;
>  			hostdata->c400_blk_cnt = 10;
>  			hostdata->c400_host_buf = 8;
> +			hostdata->c400_host_idx = 13;
>  		}
>  #else
>  		instance->base = overrides[current_override].NCR5380_map_name;
> @@ -430,8 +432,20 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  		if (NCR5380_init(instance, flags))
>  			goto out_unregister;
>  
> +#ifndef SCSI_G_NCR5380_MEM
> +		/* read initial value of index register */
> +		i = NCR5380_read(hostdata->c400_host_idx);
> +		/* read something from host buffer */
> +		NCR5380_read(hostdata->c400_host_buf);
> +		/* I/O width = index register increment */
> +		hostdata->io_width = NCR5380_read(hostdata->c400_host_idx) - i;
> +		if (hostdata->io_width < 0)
> +			hostdata->io_width += 128;
> +#endif

Will the result depend on the initial state of the chip, such as
CSR_TRANS_DIR or CSR_HOST_BUF_NOT_RDY?

It is possible to generate an interrupt with the buffer read, which should 
be masked at the chip.

This buffer read may cause the 53C400 control logic to signal the 53C80 
core. I suppose it is unlikely to cause any signalling on the SCSI bus 
unless the 53C80 happened to be in DMA mode.

The possibility that io_width == 0 is not handled; wouldn't this result 
indicate that PDMA shouldn't be used?

io_width can be calculated without a conditional statement, which may be 
easier to read.

Can we be confident that detection will fail for all devices that don't 
support word-sized IO, to avoid a regression?

The patch seems to assume that no memory-mapped card needs word-sized IO 
for PDMA. Can you confirm?

The previous version of this patch was simpler and more predictable. You 
enabled word-size IO for DTC3181E which is testable. Does this version 
benefit any other cards?

> +
>  		if (overrides[current_override].board == BOARD_NCR53C400 ||
> -		    overrides[current_override].board == BOARD_NCR53C400A)
> +		    overrides[current_override].board == BOARD_NCR53C400A ||
> +		    overrides[current_override].board == BOARD_DTC3181E)
>  			NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
>  
>  		NCR5380_maybe_reset_bus(instance);
> @@ -558,11 +572,10 @@ static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst,
>  		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY);
>  
>  #ifndef SCSI_G_NCR5380_MEM
> -		{
> -			int i;
> -			for (i = 0; i < 128; i++)
> -				dst[start + i] = NCR5380_read(hostdata->c400_host_buf);
> -		}
> +		if (hostdata->io_width == 2)
> +			insw(instance->io_port + hostdata->c400_host_buf, dst + start, 64);
> +		else
> +			insb(instance->io_port + hostdata->c400_host_buf, dst + start, 128);
>  #else
>  		/* implies SCSI_G_NCR5380_MEM */
>  		memcpy_fromio(dst + start,
> @@ -579,11 +592,10 @@ static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst,
>  		}
>  
>  #ifndef SCSI_G_NCR5380_MEM
> -		{
> -			int i;	
> -			for (i = 0; i < 128; i++)
> -				dst[start + i] = NCR5380_read(hostdata->c400_host_buf);
> -		}
> +		if (hostdata->io_width == 2)
> +			insw(instance->io_port + hostdata->c400_host_buf, dst + start, 64);
> +		else
> +			insb(instance->io_port + hostdata->c400_host_buf, dst + start, 128);
>  #else
>  		/* implies SCSI_G_NCR5380_MEM */
>  		memcpy_fromio(dst + start,
> @@ -642,10 +654,10 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
>  		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
>  			; // FIXME - timeout
>  #ifndef SCSI_G_NCR5380_MEM
> -		{
> -			for (i = 0; i < 128; i++)
> -				NCR5380_write(hostdata->c400_host_buf, src[start + i]);
> -		}
> +		if (hostdata->io_width == 2)
> +			outsw(instance->io_port + hostdata->c400_host_buf, src + start, 64);
> +		else
> +			outsb(instance->io_port + hostdata->c400_host_buf, src + start, 128);
>  #else
>  		/* implies SCSI_G_NCR5380_MEM */
>  		memcpy_toio(hostdata->iomem + NCR53C400_host_buffer,
> @@ -657,12 +669,11 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
>  	if (blocks) {
>  		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
>  			; // FIXME - no timeout
> -
>  #ifndef SCSI_G_NCR5380_MEM
> -		{
> -			for (i = 0; i < 128; i++)
> -				NCR5380_write(hostdata->c400_host_buf, src[start + i]);
> -		}
> +		if (hostdata->io_width == 2)
> +			outsw(instance->io_port + hostdata->c400_host_buf, src + start, 64);
> +		else
> +			outsb(instance->io_port + hostdata->c400_host_buf, src + start, 128);
>  #else
>  		/* implies SCSI_G_NCR5380_MEM */
>  		memcpy_toio(hostdata->iomem + NCR53C400_host_buffer,
> @@ -682,8 +693,10 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
>  	/* All documentation says to check for this. Maybe my hardware is too
>  	 * fast. Waiting for it seems to work fine! KLL
>  	 */
> -	while (!(i = NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ))
> +	while (!(i = NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ)) {
> +		udelay(4); /* DTC436 chip hangs without this */
>  		;	// FIXME - no timeout
> +	}

When you added the braces, the lone semicolon became redundant. But I 
think the entire loop is bogus.

Why do we wait for CSR_GATED_53C80_IRQ? I can understand testing it during 
a transfer but why afterwards? (The core driver could test for the IRQ 
flag in the Bus and Status Register, at the end of a DMA, if this scsi 
host has no IRQ line.)

The comments and the 53C400 datasheet say we should instead wait for 
CSR_53C80_REG. I agree. The g_NCR5380 wrapper driver can't safely return 
control to the core driver unless the 53C80 registers are available.

The algorithm in the datasheet waits for CSR_53C80_REG before checking 
BASR_END_DMA_TRANSFER, checking interrupt flags, disabling DMA mode etc. 

g_NCR5380.c has an '#if 0' around the BASR_END_DMA_TRANSFER check, because 
it doesn't wait for CSR_53C80_REG. Does NCR's algorithm work with your 
cards?

>  
>  	/*
>  	 * I know. i is certainly != 0 here but the loop is new. See previous
> diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
> index c5e57b7..b3936aa 100644
> --- a/drivers/scsi/g_NCR5380.h
> +++ b/drivers/scsi/g_NCR5380.h
> @@ -44,7 +44,9 @@
>  #define NCR5380_implementation_fields \
>  	int c400_ctl_status; \
>  	int c400_blk_cnt; \
> -	int c400_host_buf;
> +	int c400_host_buf; \
> +	int c400_host_idx; \
> +	int io_width;
>  
>  #else 
>  /* therefore SCSI_G_NCR5380_MEM */
> 

-- 
