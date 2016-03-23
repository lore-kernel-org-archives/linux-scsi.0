From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 20/23] atari_scsi: Set a reasonable default for cmd_per_lun
Date: Wed, 23 Mar 2016 21:10:29 +1100
Message-ID: <20160323101014.431736517@telegraphics.com.au>
References: <20160323101009.341929635@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_scsi-cmd_per_lun
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

This setting does not need to be conditional on Atari ST or TT.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---

Changed since v1:
- Set the default cmd_per_lun to 4 based on test results.

Changed since v2:
- Revert the default cmd_per_lun to 2, like in the v1 patch, because
a uniform default across all ten 5380 wrapper drivers is worth more
than a tiny improvement in one particular microbenchmark on one system.
Michael tells me that 2 is also the best setting for his Atari Falcon.

---
 drivers/scsi/atari_scsi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2016-03-23 21:09:53.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2016-03-23 21:10:03.000000000 +1100
@@ -752,6 +752,7 @@ static struct scsi_host_template atari_s
 	.eh_abort_handler	= atari_scsi_abort,
 	.eh_bus_reset_handler	= atari_scsi_bus_reset,
 	.this_id		= 7,
+	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.cmd_size		= NCR5380_CMD_SIZE,
 };
@@ -788,11 +789,9 @@ static int __init atari_scsi_probe(struc
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
 
