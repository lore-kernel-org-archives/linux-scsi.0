From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 6/6] atari_scsi: Reset DMA during bus reset only under ST-DMA
 lock
Date: Sun, 15 Jan 2017 18:50:57 -0500 (EST)
Message-ID: <89cbf4e7bb8924af18ad6ae4c3bea2de8c490f7a.1484523085.git.fthain@telegraphics.com.au>
References: <cover.1484523085.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1484523085.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The atari_scsi driver should not access Falcon DMA chip registers
unless it has acquired exclusive access to that chip. If the driver
doesn't have exclusive access then there's no need for a DMA reset
as there are no scsi commands in progress.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/atari_scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index b2ffab65..f792420 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -682,7 +682,8 @@ static int atari_scsi_bus_reset(struct scsi_cmnd *cmd)
 	if (IS_A_TT()) {
 		tt_scsi_dma.dma_ctrl = 0;
 	} else {
-		st_dma.dma_mode_status = 0x90;
+		if (stdma_is_locked_by(scsi_falcon_intr))
+			st_dma.dma_mode_status = 0x90;
 		atari_dma_active = 0;
 		atari_dma_orig_addr = NULL;
 	}
-- 
2.10.2
