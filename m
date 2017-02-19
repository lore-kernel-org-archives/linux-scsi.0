From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: g_NCR5380 PDMA, was Re: [PATCH 0/6] ncr5380: Miscellaneous minor
 patches
Date: Mon, 20 Feb 2017 10:19:14 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1702200848170.8597@nippy.intranet>
References: <cover.1484523085.git.fthain@telegraphics.com.au> <201702181210.08593.linux@rainbow-software.org> <alpine.LNX.2.00.1702191026310.7094@nippy.intranet> <201702191219.48554.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201702191219.48554.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Sun, 19 Feb 2017, Ondrej Zary wrote:

> 
> These two patches are enough to make PDMA work with CD-ROM drives on 
> 53C400(A), with IRQ enabled or not. They even improve transfer rates 
> with HDDs because of bigger block size.
> 

Nice! This is a great improvement.

> But DTC436 breaks with CDU-55S, immediately after modprobe.
> 1) Seems that IRQ timing is slightly different so I rewrote the wait for
> the host buffer to include check for CSR_GATED_53C80_IRQ. This allows some
> data to be transferred but
> 2) DTC436 likes to hang (return only 0xff from all registers - like it's
> not even present on the bus) on repeating CSR register reads and maybe some
> other actions too. This problem already appeared before in pwrite() where
> I added the udelay(4) workaround. Now I added udelay(100) to the waits but
> it still crashes sometimes (randomly after tenths or hundreds of MB).
> 

That is not a regression, right? If there are no regressions, I'd like to 
merge this patch (with some minor tweaks, rebased on the latest driver).

The problem with these Domex chips is that the manufacturer doesn't 
respond to repeated requests for information.

If you want to pursue this bug, when working on undocumented proprietary 
hardware from manufacturers like this one, what I recommend is to look for 
clues in the code for alternative implementations (NetBSD etc) and try 
wiggling parameters until the behaviour changes (e.g. reduce the transfer 
size to 128 bytes, introduce delays at key places. Probably the same sort 
of thing you already tried.) Snooping the device register accessess made 
by a DOS/Windows driver is another approach.

> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 6f9665d..9d0cfd4 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -585,26 +585,20 @@ static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
>  	return 0;
>  }
>  
> +#define G_NCR5380_DMA_MAX_SIZE	32768

Please put this at the top with the other definitions. (As you will 
recall, the macro definitions were moved around in the latest driver.)

>  static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata,
>                                          struct scsi_cmnd *cmd)
>  {
> -	int transfersize = cmd->transfersize;
> +	int transfersize = cmd->SCp.this_residual;
>  
>  	if (hostdata->flags & FLAG_NO_PSEUDO_DMA)
>  		return 0;
>  
> -	/* Limit transfers to 32K, for xx400 & xx406
> -	 * pseudoDMA that transfers in 128 bytes blocks.
> -	 */
> -	if (transfersize > 32 * 1024 && cmd->SCp.this_residual &&
> -	    !(cmd->SCp.this_residual % transfersize))
> -		transfersize = 32 * 1024;
> -
>  	/* 53C400 datasheet: non-modulo-128-byte transfers should use PIO */
>  	if (transfersize % 128)
>  		transfersize = 0;
>  
> -	return transfersize;
> +	return min(transfersize, G_NCR5380_DMA_MAX_SIZE);
>  }
>  
>  /*
> 
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 9d0cfd4..797115e 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -453,15 +453,15 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
>  	int blocks = len / 128;
>  	int start = 0;
>  
> +	hostdata->pdma_residual = 0;
> +
>  	NCR5380_write(hostdata->c400_ctl_status, CSR_BASE | CSR_TRANS_DIR);
>  	NCR5380_write(hostdata->c400_blk_cnt, blocks);
>  	while (1) {
>  		if (NCR5380_read(hostdata->c400_blk_cnt) == 0)
>  			break;
> -		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ) {
> -			printk(KERN_ERR "53C400r: Got 53C80_IRQ start=%d, blocks=%d\n", start, blocks);
> -			return -1;
> -		}
> +		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ)
> +			goto out_wait;

This algorithm basically says that, if the IRQ is late (or missing) we 
will go through the main loop, information transfer and DMA setup steps 
again. That's fine, but it means that we have to exit the pread/pwrite 
routines with the chip in a suitable state for back-to-back PDMA 
transfers.

NCR5380_dma_complete() takes care of things for the 53C80 core, but maybe 
the DTC436 logic might need a bit more work (?) For example, if we exit 
with a partially filled buffer, will the buffer switching logic break? The 
53C400 datasheet mentions a "Resume Transfer Register" which makes me a 
bit suspicious about chip state after a DISCONNECT... just a thought.

>  		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
>  			; /* FIXME - no timeout */
>  
> @@ -499,13 +499,13 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
>  
>  	if (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ))
>  		printk("53C400r: no 53C80 gated irq after transfer");
> -
> +out_wait:
>  	/* wait for 53C80 registers to be available */
>  	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG))
>  		;
>  
>  	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER))
> -		printk(KERN_ERR "53C400r: no end dma signal\n");
> +		hostdata->pdma_residual = blocks * 128;


Can we unconditionally assign pdma_residual? For example,

 	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER))
-		printk(KERN_ERR "53C400r: no end dma signal\n");
+		pr_err("%s: No end dma signal (%d/%d)\n", __func__, start, len);

+	hostdata->pdma_residual = len - start;
 
 	return 0;
 }

Since the new 'goto' can cause the while loop to terminate early, it is 
easier to reason about driver behaviour if this assignment is not 
conditional on the End of DMA signal.

> @@ -526,13 +526,13 @@ static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
>  	int blocks = len / 128;
>  	int start = 0;
>  
> +	hostdata->pdma_residual = 0;
> +
>  	NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
>  	NCR5380_write(hostdata->c400_blk_cnt, blocks);
>  	while (1) {
> -		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ) {
> -			printk(KERN_ERR "53C400w: Got 53C80_IRQ start=%d, blocks=%d\n", start, blocks);
> -			return -1;
> -		}
> +		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ)
> +			goto out_wait;
>  
>  		if (NCR5380_read(hostdata->c400_blk_cnt) == 0)
>  			break;
> @@ -569,16 +569,15 @@ static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
>  		start += 128;
>  		blocks--;
>  	}
> -
> +out_wait:
>  	/* wait for 53C80 registers to be available */
>  	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG)) {
>  		udelay(4); /* DTC436 chip hangs without this */
>  		/* FIXME - no timeout */
>  	}
>  
> -	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER)) {
> -		printk(KERN_ERR "53C400w: no end dma signal\n");
> -	}
> +	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER))
> +		hostdata->pdma_residual = blocks * 128;
>  

Same here.


>  	while (!(NCR5380_read(TARGET_COMMAND_REG) & TCR_LAST_BYTE_SENT))
>  		; 	// TIMEOUT
> @@ -601,6 +600,11 @@ static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata,
>  	return min(transfersize, G_NCR5380_DMA_MAX_SIZE);
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
> 
> 
> 

Thanks.

-- 
