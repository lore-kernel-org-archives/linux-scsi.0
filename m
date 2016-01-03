From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 13/78] ncr5380: Remove redundant register writes
Date: Sun, 03 Jan 2016 16:05:14 +1100
Message-ID: <20160103050504.491828436@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-double-register-writes
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove the duplicate write to the Select Enable Register that appeared
in v1.1.38.

Also remove the redundant write to Initiator Command Register prior to
calling do_abort().

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |    2 --
 drivers/scsi/atari_NCR5380.c |    3 ---
 2 files changed, 5 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:03:13.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:03:14.000000000 +1100
@@ -1384,7 +1384,6 @@ part2:
 		cmd->scsi_done(cmd);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		dprintk(NDEBUG_SELECTION, "scsi%d : target did not respond within 250ms\n", instance->host_no);
-		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		return 0;
 	}
 	hostdata->targets_present |= (1 << scmd_id(cmd));
@@ -2076,7 +2075,6 @@ static void NCR5380_information_transfer
 						scmd_printk(KERN_INFO, cmd,
 							    "switching to slow handshake\n");
 						cmd->device->borken = 1;
-						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
 						sink = 1;
 						do_abort(instance);
 						cmd->result = DID_ERROR << 16;
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:13.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:14.000000000 +1100
@@ -1640,7 +1640,6 @@ static int NCR5380_select(struct Scsi_Ho
 		cmd->scsi_done(cmd);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		dprintk(NDEBUG_SELECTION, "scsi%d: target did not respond within 250ms\n", HOSTNO);
-		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		return 0;
 	}
 
@@ -2192,8 +2191,6 @@ static void NCR5380_information_transfer
 						scmd_printk(KERN_INFO, cmd,
 							"switching to slow handshake\n");
 						cmd->device->borken = 1;
-						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
-							ICR_ASSERT_ATN);
 						sink = 1;
 						do_abort(instance);
 						cmd->result = DID_ERROR << 16;
