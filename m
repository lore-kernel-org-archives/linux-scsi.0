From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v6 0/6] g_NCR5380: PDMA fixes and cleanup
Date: Sun, 2 Jul 2017 13:11:27 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1707021008110.2389@nippy.intranet>
References: <cover.1498876618.git.fthain@telegraphics.com.au> <201707012349.04652.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201707012349.04652.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 1 Jul 2017, Ondrej Zary wrote:

> 
> The write corruption is still present - "start" must be rolled back in 
> both IRQ and timeout cases.

Your original algorithm aborts the transfer for a timeout. Same with mine.

The bug must be a elsewhere. 

> And 128 B is not enough , 256 is OK (why did it work last time?).

When I get contradictory results it usually means I booted the wrong build 
or built the wrong branch.

Actually, I think that adding 128 to the residual is correct in some 
sitations, and 256 is correct in other situations.

> We just wrote a buffer to the chip but the chip is writing the previous 
> one to the drive - so if a problem arises, both buffers are lost.
> 

I see. I guess we have to take buffer swaps into account.

> This fixes the corruption (although the "start > 0" check seems wrong now):
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -598,23 +598,17 @@ static inline int generic_NCR5380_psend(struct NCR5380_hostdata *hostdata,
>  		                           CSR_HOST_BUF_NOT_RDY, 0,
>  		                           hostdata->c400_ctl_status,
>  		                           CSR_GATED_53C80_IRQ,
> -		                           CSR_GATED_53C80_IRQ, HZ / 64) < 0)
> -                       break;
> -
> -		if (NCR5380_read(hostdata->c400_ctl_status) &
> -		    CSR_HOST_BUF_NOT_RDY) {
> +		                           CSR_GATED_53C80_IRQ, HZ / 64) < 0 ||
> +		    (NCR5380_read(hostdata->c400_ctl_status) &
> +		     (CSR_HOST_BUF_NOT_RDY | CSR_GATED_53C80_IRQ))) {

You could add a printk to the timeout branch. If it executes, something is 
seriously wrong. E.g.

-	break;
+	{ pr_err("send timeout %02x, %d/%d\n", NCR5380_read(hostdata->c400_ctl_status), start, len); break; }

>  			/* The chip has done a 128 B buffer swap but the first
>  			 * buffer still has not reached the SCSI bus.
>  			 */
>  			if (start > 0)
> -				start -= 128;
> +				start -= 256;
>  			break;
>  		}

BTW, that change carries the risk of 'start' going negative and the 
residual exceeding the length of the original transfer.

But I agree with you that there's a problem with the residual.

If I understand correctly, the 53c400 can't do a buffer swap until the 
disk acknowledges each of the 128 bytes from the buffer. But I guess the 
first buffer is special because the disk will not see the first byte of 
the transfer until after the first buffer swap.

And it appears that the last buffer is also special: we have to wait for 
CSR_HOST_BUF_NOT_RDY even after start == len otherwise we may not detect a 
failure and fix the residual. So I think the datasheet is right; we have 
to iterate until the block counter goes to zero.

I think it is safe to say that when CSR_HOST_BUF_NOT_RDY, 'start' is 
between 128 and 256 B ahead of the disk. Otherwise, the host buffer is 
empty and 'start' is no more than 128 B ahead of the disk.

>  
> -		if (NCR5380_read(hostdata->c400_ctl_status) &
> -		    CSR_GATED_53C80_IRQ)
> -			break;
> -
>  		if (hostdata->io_port && hostdata->io_width == 2)
>  			outsw(hostdata->io_port + hostdata->c400_host_buf,
>  			      src + start, 64);
> 
> 
> DTC seems to work too.
> 

OK. Thanks for testing. Please try the patch below on top of v6.

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 49312bf98068..74bbfaf0f397 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -525,8 +525,8 @@ static inline int generic_NCR5380_precv(struct NCR5380_hostdata *hostdata,
 	NCR5380_write(hostdata->c400_blk_cnt, len / 128);
 
 	do {
-		if (hostdata->board == BOARD_DTC3181E && start == len - 128) {
-			/* Ignore early CSR_GATED_53C80_IRQ */
+		if (start == len - 128) {
+			/* Ignore End of DMA interrupt for the last buffer */
 			if (NCR5380_poll_politely(hostdata, hostdata->c400_ctl_status,
 			                          CSR_HOST_BUF_NOT_RDY, 0, HZ / 64) < 0)
 				break;
@@ -603,17 +603,27 @@ static inline int generic_NCR5380_psend(struct NCR5380_hostdata *hostdata,
 
 		if (NCR5380_read(hostdata->c400_ctl_status) &
 		    CSR_HOST_BUF_NOT_RDY) {
-			/* The chip has done a 128 B buffer swap but the first
-			 * buffer still has not reached the SCSI bus.
-			 */
-			if (start > 0)
+			/* Both 128 B buffers are in use */
+			if (start >= 128)
+				start -= 128;
+			if (start >= 128)
 				start -= 128;
 			break;
 		}
 
+		if (start >= len && NCR5380_read(hostdata->c400_blk_cnt) == 0)
+			break;
+
 		if (NCR5380_read(hostdata->c400_ctl_status) &
-		    CSR_GATED_53C80_IRQ)
+		    CSR_GATED_53C80_IRQ) {
+			/* Host buffer is empty, other one is in use */
+			if (start >= 128)
+				start -= 128;
 			break;
+		}
+
+		if (start >= len)
+			continue;
 
 		if (hostdata->io_port && hostdata->io_width == 2)
 			outsw(hostdata->io_port + hostdata->c400_host_buf,
@@ -625,7 +635,7 @@ static inline int generic_NCR5380_psend(struct NCR5380_hostdata *hostdata,
 			memcpy_toio(hostdata->io + NCR53C400_host_buffer,
 			            src + start, 128);
 		start += 128;
-	} while (start < len);
+	} while (1);
 
 	residual = len - start;
 

-- 
