From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v5 0/6] g_NCR5380: PDMA fixes and cleanup
Date: Thu, 29 Jun 2017 20:06:55 +0200
Message-ID: <201706292006.56377.linux@rainbow-software.org>
References: <cover.1498713600.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:54506 "EHLO
        smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752320AbdF2SHM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2017 14:07:12 -0400
In-Reply-To: <cover.1498713600.git.fthain@telegraphics.com.au>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>

On Thursday 29 June 2017 07:24:18 Finn Thain wrote:
> Ondrej, would you please test this new series?
>
> Changed since v1:
> - PDMA transfer residual is calculated earlier.
> - End of DMA flag check is now polled (if there is any residual).
>
> Changed since v2:
> - Bail out of transfer loops when Gated IRQ gets asserted.
> - Make udelay conditional on board type.
> - Drop sg_tablesize patch due to performance regression.
>
> Changed since v3:
> - Add Ondrej's workaround for corrupt WRITE commands on DTC boards.
> - Reset the 53c400 logic after any short PDMA transfer.
> - Don't fail the transfer if the 53c400 logic got a reset.
>
> Changed since v4:
> - Bail out of transfer loops when Gated IRQ gets asserted. (Again.)
> - Always call wait_for_53c80_registers() at end of transfer.
> - Drain chip buffers after PDMA receive is interrupted.
> - Rework residual calculation.
> - Add new patch to correct DMA terminology.
>
>
> Finn Thain (2):
>   g_NCR5380: Cleanup comments and whitespace
>   g_NCR5380: Use unambiguous terminology for PDMA send and receive
>
> Ondrej Zary (4):
>   g_NCR5380: Fix PDMA transfer size
>   g_NCR5380: End PDMA transfer correctly on target disconnection
>   g_NCR5380: Limit PDMA send to 512 B to avoid data corruption on
>     DTC3181E
>   g_NCR5380: Re-work PDMA loops
>
>  drivers/scsi/g_NCR5380.c | 260
> +++++++++++++++++++++++++---------------------- 1 file changed, 139
> insertions(+), 121 deletions(-)

The write corruption is still there. I'm afraid it can't be fixed without
rolling "start" back (or inceasing residual) if an error occured, something like this:
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -619,6 +621,9 @@ static inline int generic_NCR5380_psend(struct NCR5380_hostdata *hostdata,
 	               (int)NCR5380_read(hostdata->c400_blk_cnt) * 128);

 	if (residual != 0) {
+		residual += 128;
 		/* 53c80 interrupt or transfer timeout. Reset 53c400 logic. */
 		NCR5380_write(hostdata->c400_ctl_status, CSR_RESET);
 		NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);

(seems to work - wrote 230MB and read it back with no differences)

The corruption mechanism is:
1. Host buffer is ready so we write 128 B of data there and increment "start".
2. Chip swaps the buffers, decrements the block counter and starts writing the
data to drive.
3. Drive does not like it (e.g. its buffer is full) so it disconnects.
4. Chip stops writing and asserts an IRQ.
5. We detect the IRQ. The block counter is already decremented, "start" is
already incremented but the data was not written to the drive.



No more log spamming on DTC but reads are corrupted even more than before.
The IRQ check after data transfer increases the chance of catching an IRQ
before the buffer could become ready. This patch:
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -548,8 +548,10 @@ static inline int generic_NCR5380_precv(struct NCR5380_hostdata *hostdata,
 		start += 128;
 
 		if (NCR5380_read(hostdata->c400_ctl_status) &
-		    CSR_GATED_53C80_IRQ)
+		    CSR_GATED_53C80_IRQ) {
+			printk("r irq at start=%d basr=0x%02x\n", start, NCR5380_read(BUS_AND_STATUS_REG));
 			break;
+		}
 	}
 
 	residual = len - start;

produces lots of these lines:
[  896.194054] r irq at start=128 basr=0x98
[  896.197758] r irq at start=3968 basr=0x98


-- 
Ondrej Zary
