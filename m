From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 20/22] atari_scsi: Set a reasonable default for cmd_per_lun
Date: Mon, 14 Mar 2016 15:27:20 +1100
Message-ID: <20160314042705.846189331@telegraphics.com.au>
References: <20160314042700.596192247@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_scsi-cmd_per_lun
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

This setting does not need to be conditional on Atari ST or TT.

Without TCQ support, cmd_per_lun == 2 is probably reasonable...

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/atari_scsi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2016-03-14 15:26:45.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2016-03-14 15:26:55.000000000 +1100
@@ -750,6 +750,7 @@ static struct scsi_host_template atari_s
 	.eh_abort_handler	= atari_scsi_abort,
 	.eh_bus_reset_handler	= atari_scsi_bus_reset,
 	.this_id		= 7,
+	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.cmd_size		= NCR5380_CMD_SIZE,
 };
@@ -786,11 +787,9 @@ static int __init atari_scsi_probe(struc
 	 */
 	if (ATARIHW_PRESENT(TT_SCSI)) {
 		atari_scsi_template.can_queue    = 16;
-		atari_scsi_template.cmd_per_lun  = 8;
 		atari_scsi_template.sg_tablesize = SG_ALL;
 	} else {
 		atari_scsi_template.can_queue    = 8;
-		atari_scsi_template.cmd_per_lun  = 1;
 		atari_scsi_template.sg_tablesize = SG_NONE;
 	}
 
