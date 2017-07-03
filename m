From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v7 0/6] g_NCR5380: PDMA fixes and cleanup
Date: Mon,  3 Jul 2017 03:59:05 -0400 (EDT)
Message-ID: <cover.1499067144.git.fthain@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:58168 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752329AbdGCH7I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jul 2017 03:59:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>

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

Changed since v4:
- Bail out of transfer loops when Gated IRQ gets asserted. (Again.)
- Always call wait_for_53c80_registers() at end of transfer.
- Drain chip buffers after PDMA receive is interrupted.
- Rework residual calculation.
- Add new patch to correct DMA terminology.

Changed since v5:
- Rework residual calculation to account for on-chip buffer swap.
- Attempt to retain the disconnect/IRQ detection in the DTC436 workaround.
- Move all DTC436 workarounds to final patch.

Changed since v6:
- Fix residual calculation for the buffer timeout case.
- Iterate after sending final 128 bytes to check for buffer timeout.
- Don't log the residual value when it is known to be zero.


Finn Thain (2):
  g_NCR5380: Cleanup comments and whitespace
  g_NCR5380: Use unambiguous terminology for PDMA send and receive

Ondrej Zary (4):
  g_NCR5380: Fix PDMA transfer size
  g_NCR5380: End PDMA transfer correctly on target disconnection
  g_NCR5380: Re-work PDMA loops
  g_NCR5380: Two DTC436 PDMA workarounds

 drivers/scsi/g_NCR5380.c | 277 ++++++++++++++++++++++++++---------------------
 1 file changed, 155 insertions(+), 122 deletions(-)

-- 
2.13.0
