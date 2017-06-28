From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 0/5] g_NCR5380: PDMA fixes and cleanup
Date: Wed, 28 Jun 2017 00:04:36 -0400 (EDT)
Message-ID: <cover.1498622056.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Ondrej, would you please test this new series?

Changed since v1:
- PDMA transfer residual is calculated earlier.
- End of DMA flag check is now polled (if there is any residual).

Changed since v2:
- Bail out of transfer loops when Gated IRQ gets asserted.
- Make udelay conditional on board type.
- Drop sg_tablesize patch due to performance regression.

Changed since v3:
- Add Ondrej's workaround for corrupt WRITE commands on DTC boards.
- Reset the 53c400 logic after any short PDMA transfer.
- Don't fail the transfer if the 53c400 logic got a reset.


Finn Thain (1):
  g_NCR5380: Cleanup comments and whitespace

Ondrej Zary (4):
  g_NCR5380: Fix PDMA transfer size
  g_NCR5380: End PDMA transfer correctly on target disconnection
  g_NCR5380: Limit PDMA send to 512 B to avoid random corruption on
    DTC3181E
  g_NCR5380: Re-work PDMA loops

 drivers/scsi/g_NCR5380.c | 239 ++++++++++++++++++++++++-----------------------
 1 file changed, 120 insertions(+), 119 deletions(-)

-- 
2.13.0
