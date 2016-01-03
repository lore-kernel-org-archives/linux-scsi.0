From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 46/78] ncr5380: Fix NDEBUG_NO_DATAOUT flag
Date: Sun, 03 Jan 2016 16:05:47 +1100
Message-ID: <20160103050513.201785199@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-fix-NDEBUG_NO_DATAOUT
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

NDEBUG_NO_DATAOUT should not disable DATA IN phases too. Fix this.
(This bug has long been fixed in atari_NCR5380.c.)

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---
 drivers/scsi/NCR5380.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:04:00.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:04:02.000000000 +1100
@@ -1838,7 +1838,6 @@ static void NCR5380_information_transfer
 				continue;
 			}
 			switch (phase) {
-			case PHASE_DATAIN:
 			case PHASE_DATAOUT:
 #if (NDEBUG & NDEBUG_NO_DATAOUT)
 				printk("scsi%d : NDEBUG_NO_DATAOUT set, attempted DATAOUT aborted\n", instance->host_no);
@@ -1848,6 +1847,7 @@ static void NCR5380_information_transfer
 				cmd->scsi_done(cmd);
 				return;
 #endif
+			case PHASE_DATAIN:
 				/* 
 				 * If there is no room left in the current buffer in the
 				 * scatter-gather list, move onto the next one.
