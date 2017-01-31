From: Finn Thain <fthain@telegraphics.com.au>
Subject: g_NCR5380 PDMA, was Re: [PATCH 0/6] ncr5380: Miscellaneous minor
 patches
Date: Tue, 31 Jan 2017 12:31:45 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1701311203001.16154@nippy.intranet>
References: <cover.1484523085.git.fthain@telegraphics.com.au> <201701282244.40207.linux@rainbow-software.org> <alpine.LNX.2.00.1701291204430.13727@nippy.intranet> <201701302252.13124.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201701302252.13124.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Mon, 30 Jan 2017, Ondrej Zary wrote:

> 
> Also tested two CD-ROM drives and they didn't work (machine hangs). They 
> didn't work before and looks like they never worked with PDMA.
> 
> The fundamental problem of PDMA is that it either transfers all required 
> data or it breaks horribly. Even when I added timeouts to the possibly 
> infinite loops (to avoid hangs), the chip remained in some bad state. 
> Sometimes the 53C80 gated IRQ check triggers. This can be hopefully 
> fixed but there is a HW limitation: if less than 128 bytes were read 
> from SCSI device, they get lost in chip buffer (the 128B buffers don't 
> swap until full).
> 

The core driver allows wrapper drivers to inhibit PDMA e.g. for inbound 
transfers smaller than 128 bytes. This is used by atari_scsi and sun3_scsi 
(as you probably realize). For example, atari_scsi now uses 
cmd->sc_data_direction to find out the direction of the DMA transfer.

> Fortunately, most of the requests for too much data are bogus. The 
> problem is that generic_NCR5380_dma_xfer_len() uses cmd->transfersize 
> which seems to be wrong. All other NCR5380 drivers use 
> cmd->SCp.this_residual.
> 

Yes, this always looked wrong to me. Much of the logic in 
generic_NCR5380_dma_xfer_len() looks suspicious but I see you've addressed 
this below. Thanks for looking into this.

> This is also why rescan-scsi-bus hangs (cmd->transfersize is 8192 but 
> cmd->SCp.this_residual is only 96).
> 

Great, that resolves that mystery.

> This quick fix allows CD-ROM and also rescan-scsi-bus to work.
> But it's not complete. Seems that we need:
>  - fix pread and pwrite to terminate gracefully

mac_scsi.c probably offers a reasonable example of a PDMA transfer 
algorithm that is resiliant to timeouts.

See also the cmd->device->borken logic in the core driver. This way, 
generic_NCR5380_pread() or generic_NCR5380_pwrite() can inhibit further 
PDMA to that device if need be.

>  - something like atari_scsi_dma_xfer_len to allow DMA only for block 
>    commands
> 

Are you trying to figure out which commands are going to disconnect during 
a transfer? This is really a function of the firmware in the target; there 
are no good heuristics AFAICT, so the PDMA algorithm has to be robust. 
mac_scsi has to cope with this too.

Does the problem go away when you assign no IRQ? When instance->irq == 
NO_IRQ, the core driver will inhibit disconnect privileges.

> @@ -588,22 +619,19 @@ static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
>  static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata,
>                                          struct scsi_cmnd *cmd)
>  {
> -       int transfersize = cmd->transfersize;
> +       int transfersize = cmd->SCp.this_residual;
> 
>         if (hostdata->flags & FLAG_NO_PSEUDO_DMA)
>                 return 0;
> 
> -       /* Limit transfers to 32K, for xx400 & xx406
> -        * pseudoDMA that transfers in 128 bytes blocks.
> -        */
> -       if (transfersize > 32 * 1024 && cmd->SCp.this_residual &&
> -           !(cmd->SCp.this_residual % transfersize))
> -               transfersize = 32 * 1024;
> -
>         /* 53C400 datasheet: non-modulo-128-byte transfers should use PIO */
>         if (transfersize % 128)
>                 transfersize = 0;
> 
> +       /* Limit transfers to 32K */
> +       if (transfersize > 32 * 1024)
> +               transfersize = 32 * 1024;
> +
>         return transfersize;

I would prefer to see,

#define G_NCR5380_DMA_MAX_SIZE	32768

...

	return min(transfersize, G_NCR5380_DMA_MAX_SIZE);

Thanks.

-- 

>  }
> 
> 
> 
> 
> 
