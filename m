From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [RFC PATCH 76/71] ncr5380: Enable PDMA for DTC chips
Date: Fri, 4 Dec 2015 20:08:21 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1512041951470.13680@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <1449183781-2163-1-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1449183781-2163-1-git-send-email-linux@rainbow-software.org>
Sender: linux-m68k-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Fri, 4 Dec 2015, Ondrej Zary wrote:

> Add I/O register mapping for DTC chips and enable PDMA mode.
> 
> These chips have 16-bit wide HOST BUFFER register (counter register at 
> offset 0x0d increments by 2 on each HOST BUFFER read).
> 
> Large PIO transfers crash at least the DTCT-436P chip (all reads result 
> in 0xFF) so this patch actually makes it work.
> 
> The chip also crashes when we bang the C400 host status register too
> heavily after PDMA write - a small udelay is needed.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
> # hdparm -t --direct /dev/sdb
> 
> /dev/sdb:
>  Timing O_DIRECT disk reads:   4 MB in  3.78 seconds =   1.06 MB/sec
> 
> 
>  drivers/scsi/NCR5380.h   |    1 +
>  drivers/scsi/g_NCR5380.c |   47 +++++++++++++++++++++++-----------------------
>  2 files changed, 25 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
> index 5092580..e3b8149 100644
> --- a/drivers/scsi/NCR5380.h
> +++ b/drivers/scsi/NCR5380.h
> @@ -222,6 +222,7 @@
>  
>  #define FLAG_NO_DMA_FIXUP		1	/* No DMA errata workarounds */
>  #define FLAG_NO_PSEUDO_DMA		8	/* Inhibit DMA */
> +#define FLAG_16BIT			16	/* 16-bit PDMA */

Can we give this a better name? FLAG_16BIT could be taken to mean "16-bit 
ISA card" but do we really want a flag for that? How about 
FLAG_16BIT_BUF_REG or FLAG_WORD_IO_BUF?

All active flags appear in the console log, thanks to prepare_info(). It 
might be helpful to include this one; FLAG_DTC3181E is likely to 
disappear.

-- 

>  #define FLAG_LATE_DMA_SETUP		32	/* Setup NCR before DMA H/W */
>  #define FLAG_TAGGED_QUEUING		64	/* as X3T9.2 spelled it */
>  #define FLAG_TOSHIBA_DELAY		128	/* Allow for borken CD-ROMs */
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index fae4332..04f6c29 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -331,7 +331,7 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  			ports = ncr_53c400a_ports;
>  			break;
>  		case BOARD_DTC3181E:
> -			flags = FLAG_NO_PSEUDO_DMA;
> +			flags = FLAG_NO_DMA_FIXUP | FLAG_16BIT;
>  			ports = dtc_3181e_ports;
>  			break;
>  		}
> @@ -415,7 +415,8 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  			hostdata->c400_blk_cnt = 1;
>  			hostdata->c400_host_buf = 4;
>  		}
> -		if (overrides[current_override].board == BOARD_NCR53C400A) {
> +		if (overrides[current_override].board == BOARD_NCR53C400A ||
> +		    overrides[current_override].board == BOARD_DTC3181E) {
>  			hostdata->c400_ctl_status = 9;
>  			hostdata->c400_blk_cnt = 10;
>  			hostdata->c400_host_buf = 8;
> @@ -434,7 +435,8 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  			goto out_unregister;
>  
>  		if (overrides[current_override].board == BOARD_NCR53C400 ||
> -		    overrides[current_override].board == BOARD_NCR53C400A)
> +		    overrides[current_override].board == BOARD_NCR53C400A ||
> +		    overrides[current_override].board == BOARD_DTC3181E)
>  			NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
>  
>  		NCR5380_maybe_reset_bus(instance);
> @@ -561,11 +563,10 @@ static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst,
>  		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY);
>  
>  #ifndef SCSI_G_NCR5380_MEM
> -		{
> -			int i;
> -			for (i = 0; i < 128; i++)
> -				dst[start + i] = NCR5380_read(hostdata->c400_host_buf);
> -		}
> +		if (hostdata->flags & FLAG_16BIT)
> +			insw(instance->io_port + hostdata->c400_host_buf, dst + start, 64);
> +		else
> +			insb(instance->io_port + hostdata->c400_host_buf, dst + start, 128);
>  #else
>  		/* implies SCSI_G_NCR5380_MEM */
>  		memcpy_fromio(dst + start,
> @@ -582,11 +583,10 @@ static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst,
>  		}
>  
>  #ifndef SCSI_G_NCR5380_MEM
> -		{
> -			int i;	
> -			for (i = 0; i < 128; i++)
> -				dst[start + i] = NCR5380_read(hostdata->c400_host_buf);
> -		}
> +		if (hostdata->flags & FLAG_16BIT)
> +			insw(instance->io_port + hostdata->c400_host_buf, dst + start, 64);
> +		else
> +			insb(instance->io_port + hostdata->c400_host_buf, dst + start, 128);
>  #else
>  		/* implies SCSI_G_NCR5380_MEM */
>  		memcpy_fromio(dst + start,
> @@ -645,10 +645,10 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
>  		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
>  			; // FIXME - timeout
>  #ifndef SCSI_G_NCR5380_MEM
> -		{
> -			for (i = 0; i < 128; i++)
> -				NCR5380_write(hostdata->c400_host_buf, src[start + i]);
> -		}
> +		if (hostdata->flags & FLAG_16BIT)
> +			outsw(instance->io_port + hostdata->c400_host_buf, src + start, 64);
> +		else
> +			outsb(instance->io_port + hostdata->c400_host_buf, src + start, 128);
>  #else
>  		/* implies SCSI_G_NCR5380_MEM */
>  		memcpy_toio(hostdata->iomem + NCR53C400_host_buffer,
> @@ -660,12 +660,11 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
>  	if (blocks) {
>  		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
>  			; // FIXME - no timeout
> -
>  #ifndef SCSI_G_NCR5380_MEM
> -		{
> -			for (i = 0; i < 128; i++)
> -				NCR5380_write(hostdata->c400_host_buf, src[start + i]);
> -		}
> +		if (hostdata->flags & FLAG_16BIT)
> +			outsw(instance->io_port + hostdata->c400_host_buf, src + start, 64);
> +		else
> +			outsb(instance->io_port + hostdata->c400_host_buf, src + start, 128);
>  #else
>  		/* implies SCSI_G_NCR5380_MEM */
>  		memcpy_toio(hostdata->iomem + NCR53C400_host_buffer,
> @@ -685,8 +684,10 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
>  	/* All documentation says to check for this. Maybe my hardware is too
>  	 * fast. Waiting for it seems to work fine! KLL
>  	 */
> -	while (!(i = NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ))
> +	while (!(i = NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ)) {
> +		udelay(4); /* DTC436 chip hangs without this */
>  		;	// FIXME - no timeout
> +	}
>  
>  	/*
>  	 * I know. i is certainly != 0 here but the loop is new. See previous
> 
