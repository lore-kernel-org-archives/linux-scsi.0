From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 15/23] dmx3191d: Drop max_sectors limit
Date: Wed, 23 Mar 2016 21:10:24 +1100
Message-ID: <20160323101013.171777342@telegraphics.com.au>
References: <20160323101009.341929635@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=dmx3191d-max_sectors
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

The dmx3191d driver is not capable of DMA or PDMA so all transfers
use PIO. Now that large slow PIO transfers periodically stop and call
cond_resched(), the max_sectors limit can go away.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---
 drivers/scsi/dmx3191d.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2016-03-23 21:09:47.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2016-03-23 21:09:57.000000000 +1100
@@ -67,7 +67,6 @@ static struct scsi_host_template dmx3191
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.cmd_size		= NCR5380_CMD_SIZE,
-	.max_sectors		= 128,
 };
 
 static int dmx3191d_probe_one(struct pci_dev *pdev,
