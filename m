From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v4 0/5] g_NCR5380: PDMA fixes and cleanup
Date: Wed, 28 Jun 2017 23:28:06 +0200
Message-ID: <201706282328.06806.linux@rainbow-software.org>
References: <cover.1498622056.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:39193 "EHLO
        smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbdF1V22 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2017 17:28:28 -0400
In-Reply-To: <cover.1498622056.git.fthain@telegraphics.com.au>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>

On Wednesday 28 June 2017 06:04:36 Finn Thain wrote:
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
>
> Finn Thain (1):
>   g_NCR5380: Cleanup comments and whitespace
>
> Ondrej Zary (4):
>   g_NCR5380: Fix PDMA transfer size
>   g_NCR5380: End PDMA transfer correctly on target disconnection
>   g_NCR5380: Limit PDMA send to 512 B to avoid random corruption on
>     DTC3181E
>   g_NCR5380: Re-work PDMA loops
>
>  drivers/scsi/g_NCR5380.c | 239
> ++++++++++++++++++++++++----------------------- 1 file changed, 120
> insertions(+), 119 deletions(-)

Now read seems to work on non-DTC chips.
Writes continue in PDMA after disconnect but there's a corruption - one 128 B 
block missing on disconnect.


On DTC, the log is spammed with errors like this:
sd 2:0:1:0: [sdb] tag#0 generic_NCR5380_pread: End of DMA timeout (0)

They're cause by read corruption on DTC:
pread() is breaking at start=3968 because of an end-of-DMA IRQ (BASR=0x98) but 
pdma_residual is set to zero (block counter is zero because the data was read 
into the buffer but we did not read it from there). So we lose one buffer of 
data on each 4 KB read.
The PDMA is then reset which probably means BASR_END_DMA_TRANSFER will not be 
asserted.


-- 
Ondrej Zary
