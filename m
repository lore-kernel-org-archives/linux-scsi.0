From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [RFC PATCH 74/71] ncr5380: Enable PDMA for NCR53C400A
Date: Mon, 30 Nov 2015 22:52:32 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1511301658290.17198@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <1448789980-30094-2-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1448789980-30094-2-git-send-email-linux@rainbow-software.org>
Sender: linux-m68k-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Sun, 29 Nov 2015, Ondrej Zary wrote:

> Add I/O register mapping for NCR53C400A and enable PDMA mode to
> improve performance and fix non-working IRQ.
> 
> Tested with HP C2502 (and user-space enabler).
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/scsi/g_NCR5380.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index ce444da..c3abe48 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -324,7 +324,10 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  #endif
>  			break;
>  		case BOARD_NCR53C400A:
> +			flags = FLAG_NO_DMA_FIXUP;
> +#ifndef PSEUDO_DMA
>  			flags = FLAG_NO_PSEUDO_DMA;
> +#endif

FLAG_NO_PSEUDO_DMA is not tested unless defined(PSEUDO_DMA), so it 
shouldn't be set here. I know I made the same mistake in patch 8; it will 
be fixed in the next submission.

-- 

>  			ports = ncr_53c400a_ports;
>  			break;
>  		case BOARD_DTC3181E:
> @@ -412,6 +415,11 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  			hostdata->c400_blk_cnt = 1;
>  			hostdata->c400_host_buf = 4;
>  		}
> +		if (overrides[current_override].board == BOARD_NCR53C400A) {
> +			hostdata->c400_ctl_status = 9;
> +			hostdata->c400_blk_cnt = 10;
> +			hostdata->c400_host_buf = 8;
> +		}
>  #else
>  		instance->base = overrides[current_override].NCR5380_map_name;
>  		hostdata->iomem = iomem;
> @@ -425,7 +433,8 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
>  		if (NCR5380_init(instance, flags))
>  			goto out_unregister;
>  
> -		if (overrides[current_override].board == BOARD_NCR53C400)
> +		if (overrides[current_override].board == BOARD_NCR53C400 ||
> +		    overrides[current_override].board == BOARD_NCR53C400A)
>  			NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
>  
>  		NCR5380_maybe_reset_bus(instance);
> 
