From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 4/7] scsi: mac_scsi: Increase PIO/PDMA transfer length
 threshold
Date: Sun, 02 Jun 2019 11:24:12 +1000
Message-ID: <666248afffd5a75c3259f06737ddcfb2b833b1f7.1559438652.git.fthain@telegraphics.com.au>
References: <cover.1559438652.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1559438652.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Some targets introduce delays when handshaking the response to certain
commands. For example, a disk may send a 96-byte response to an INQUIRY
command (or a 24-byte response to a MODE SENSE command) too slowly.

Apparently the first 12 or 14 bytes are handshaked okay but then the
system bus error timeout is reached while transferring the next word.

Since the scsi bus phase hasn't changed, the driver then sets the target
borken flag to prevent further PDMA transfers. The driver also logs the
warning, "switching to slow handshake".

Raise the PDMA threshold to 512 bytes so that PIO transfers will be used
for these commands. This default is sufficiently low that PDMA will still
be used for READ and WRITE commands.

The existing threshold (16 bytes) was chosen more or less at random.
However, best performance requires the threshold to be as low as possible.
Those systems that don't need the PIO workaround at all may benefit from
mac_scsi.setup_use_pdma=1

Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: stable@vger.kernel.org # v4.14+
Fixes: 3a0f64bfa907 ("mac_scsi: Fix pseudo DMA implementation")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/mac_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 8b4b5b1a13d7..ba1afcaadae8 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -52,7 +52,7 @@ static int setup_cmd_per_lun = -1;
 module_param(setup_cmd_per_lun, int, 0);
 static int setup_sg_tablesize = -1;
 module_param(setup_sg_tablesize, int, 0);
-static int setup_use_pdma = -1;
+static int setup_use_pdma = 512;
 module_param(setup_use_pdma, int, 0);
 static int setup_hostid = -1;
 module_param(setup_hostid, int, 0);
@@ -305,7 +305,7 @@ static int macscsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
                                 struct scsi_cmnd *cmd)
 {
 	if (hostdata->flags & FLAG_NO_PSEUDO_DMA ||
-	    cmd->SCp.this_residual < 16)
+	    cmd->SCp.this_residual < setup_use_pdma)
 		return 0;
 
 	return cmd->SCp.this_residual;
-- 
2.21.0
