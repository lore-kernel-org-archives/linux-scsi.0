From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v6 0/6] g_NCR5380: PDMA fixes and cleanup
Date: Sat, 1 Jul 2017 23:49:03 +0200
Message-ID: <201707012349.04652.linux@rainbow-software.org>
References: <cover.1498876618.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1498876618.git.fthain@telegraphics.com.au>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Saturday 01 July 2017 04:40:53 Finn Thain wrote:
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
> Changed since v5:
> - Rework residual calculation to account for on-chip buffer swap.
> - Attempt to retain the disconnect/IRQ detection in the DTC436 workaround.
> - Move all DTC436 workarounds to final patch.
>
>
> Finn Thain (2):
>   g_NCR5380: Cleanup comments and whitespace
>   g_NCR5380: Use unambiguous terminology for PDMA send and receive
>
> Ondrej Zary (4):
>   g_NCR5380: Fix PDMA transfer size
>   g_NCR5380: End PDMA transfer correctly on target disconnection
>   g_NCR5380: Re-work PDMA loops
>   g_NCR5380: Various DTC436 workarounds
>
>  drivers/scsi/g_NCR5380.c | 273
> ++++++++++++++++++++++++++--------------------- 1 file changed, 151
> insertions(+), 122 deletions(-)

The write corruption is still present - "start" must be rolled back in both
IRQ and timeout cases. And 128 B is not enough , 256 is OK (why did it work
last time?). We just wrote a buffer to the chip but the chip is writing the
previous one to the drive - so if a problem arises, both buffers are lost.

This fixes the corruption (although the "start > 0" check seems wrong now):
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -598,23 +598,17 @@ static inline int generic_NCR5380_psend(struct NCR5380_hostdata *hostdata,
 		                           CSR_HOST_BUF_NOT_RDY, 0,
 		                           hostdata->c400_ctl_status,
 		                           CSR_GATED_53C80_IRQ,
-		                           CSR_GATED_53C80_IRQ, HZ / 64) < 0)
-                       break;
-
-		if (NCR5380_read(hostdata->c400_ctl_status) &
-		    CSR_HOST_BUF_NOT_RDY) {
+		                           CSR_GATED_53C80_IRQ, HZ / 64) < 0 ||
+		    (NCR5380_read(hostdata->c400_ctl_status) &
+		     (CSR_HOST_BUF_NOT_RDY | CSR_GATED_53C80_IRQ))) {
 			/* The chip has done a 128 B buffer swap but the first
 			 * buffer still has not reached the SCSI bus.
 			 */
 			if (start > 0)
-				start -= 128;
+				start -= 256;
 			break;
 		}
 
-		if (NCR5380_read(hostdata->c400_ctl_status) &
-		    CSR_GATED_53C80_IRQ)
-			break;
-
 		if (hostdata->io_port && hostdata->io_width == 2)
 			outsw(hostdata->io_port + hostdata->c400_host_buf,
 			      src + start, 64);


DTC seems to work too.

-- 
Ondrej Zary
