From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v7 0/6] g_NCR5380: PDMA fixes and cleanup
Date: Tue, 4 Jul 2017 22:54:19 +0200
Message-ID: <201707042254.20791.linux@rainbow-software.org>
References: <cover.1499067144.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1499067144.git.fthain@telegraphics.com.au>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Monday 03 July 2017 09:59:05 Finn Thain wrote:
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
> Changed since v6:
> - Fix residual calculation for the buffer timeout case.
> - Iterate after sending final 128 bytes to check for buffer timeout.
> - Don't log the residual value when it is known to be zero.
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
>   g_NCR5380: Two DTC436 PDMA workarounds
>
>  drivers/scsi/g_NCR5380.c | 277
> ++++++++++++++++++++++++++--------------------- 1 file changed, 155
> insertions(+), 122 deletions(-)

Everything works fine! No corruption, no hangs, rescan-scsi-bus works.

Tested cards:
Canon FG2-5202 (53C400 chip, MMIO)
DTC-3181L (DTCT-436P chip, PIO)
HP C2502 (53C400A chip, PIO)

Tested devices:
QUANTUM  LP240S GM240S01X 4.6
IBM      DORS-32160       WA0A
SONY     CD-ROM CDU-415   1.1g
SONY     CD-ROM CDU-55S   1.0t

Tested-by: Ondrej Zary <linux@rainbow-software.org>

-- 
Ondrej Zary
