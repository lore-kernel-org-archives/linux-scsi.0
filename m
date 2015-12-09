From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v2 74/71] ncr5380: Enable PDMA for NCR53C400A
Date: Wed, 9 Dec 2015 14:39:06 +0100
Message-ID: <201512091439.07424.linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au> <1449440489-9986-1-git-send-email-linux@rainbow-software.org> <alpine.LNX.2.00.1512081242490.18196@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1512081242490.18196@nippy.intranet>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday 08 December 2015 03:05:11 Finn Thain wrote:
> 
> On Sun, 6 Dec 2015, Ondrej Zary wrote:
> 
> > Add I/O register mapping for NCR53C400A and enable PDMA mode to
> > improve performance and fix non-working IRQ.
> > 
> > Tested with HP C2502 (and user-space enabler).
> > 
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > ---
> >  drivers/scsi/g_NCR5380.c |   14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> > index 86740fd..099fdac 100644
> > --- a/drivers/scsi/g_NCR5380.c
> > +++ b/drivers/scsi/g_NCR5380.c
> > @@ -324,7 +324,7 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
> >  #endif
> >  			break;
> >  		case BOARD_NCR53C400A:
> > -			flags = FLAG_NO_PSEUDO_DMA;
> > +			flags = FLAG_NO_DMA_FIXUP;
> >  			ports = ncr_53c400a_ports;
> >  			break;
> >  		case BOARD_DTC3181E:
> > @@ -406,11 +406,18 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
> >  		 * On NCR53C400 boards, NCR5380 registers are mapped 8 past
> >  		 * the base address.
> >  		 */
> > -		if (overrides[current_override].board == BOARD_NCR53C400) {
> > +		switch (overrides[current_override].board) {
> > +		case BOARD_NCR53C400:
> >  			instance->io_port += 8;
> >  			hostdata->c400_ctl_status = 0;
> >  			hostdata->c400_blk_cnt = 1;
> >  			hostdata->c400_host_buf = 4;
> > +			break;
> > +		case BOARD_NCR53C400A:
> > +			hostdata->c400_ctl_status = 9;
> > +			hostdata->c400_blk_cnt = 10;
> > +			hostdata->c400_host_buf = 8;
> > +			break;
> >  		}
> >  #else
> >  		instance->base = overrides[current_override].NCR5380_map_name;
> 
> 
> For SCSI_G_NCR5380_MEM and BOARD_NCR53C400A (or BOARD_DTC3181E), you have 
> not assigned c400_ctl_status, c400_blk_cnt and c400_host_buf. Perhaps we 
> should throw an error, something like this?
> 
>  		hostdata->iomem = iomem;
> -		if (overrides[current_override].board == BOARD_NCR53C400) {
> +		switch (overrides[current_override].board) {
> +		case BOARD_NCR53C400:
>  			hostdata->c400_ctl_status = 0x100;
>  			hostdata->c400_blk_cnt = 0x101;
>  			hostdata->c400_host_buf = 0x104;
> +			break;
> +		case BOARD_NCR53C400A:
> +			pr_err(DRV_MODULE_NAME ": unknown register offsets\n");
> +			goto out_unregister;
>  		}
>  #endif

We don't need to fail, just disable PDMA by setting:
flags = FLAG_NO_PSEUDO_DMA;

And BTW. this:
                if (overrides[current_override].board == BOARD_NCR53C400 ||
                    overrides[current_override].board == BOARD_NCR53C400A)
                        NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);

should then be, solving the problem of growing if condition:
		if (!(flags & FLAG_NO_PSEUDO_DMA))
                        NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);

-- 
Ondrej Zary
