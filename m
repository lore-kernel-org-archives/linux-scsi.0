From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v5 0/6] g_NCR5380: PDMA fixes and cleanup
Date: Thu, 29 Jun 2017 20:30:45 +0200
Message-ID: <201706292030.46340.linux@rainbow-software.org>
References: <cover.1498713600.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:58697 "EHLO
        smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753157AbdF2Sa7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2017 14:30:59 -0400
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

This fixes the DTC read corruption, although I don't like the repeated
ctl_status register reads:
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -533,7 +533,7 @@ static inline int generic_NCR5380_precv(struct NCR5380_hostdata *hostdata,
 			break;

 		if (NCR5380_read(hostdata->c400_ctl_status) &
-		    CSR_HOST_BUF_NOT_RDY)
+		    CSR_GATED_53C80_IRQ && (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY))
 			break;

                if (hostdata->io_port && hostdata->io_width == 2)
@@ -546,10 +546,6 @@ static inline int generic_NCR5380_precv(struct NCR5380_hostdata *hostdata,
 			memcpy_fromio(dst + start,
 				hostdata->io + NCR53C400_host_buffer, 128);
 		start += 128;
-
-		if (NCR5380_read(hostdata->c400_ctl_status) &
-		    CSR_GATED_53C80_IRQ)
-			break;
 	}
 
 	residual = len - start;

Writes seem to work correctly.

-- 
Ondrej Zary
