From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 15/22] dmx3191d: Drop max_sectors limit
Date: Mon, 14 Mar 2016 15:27:15 +1100
Message-ID: <20160314042704.546012961@telegraphics.com.au>
References: <20160314042700.596192247@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:52676 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbcCNEmS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2016 00:42:18 -0400
Content-Disposition: inline; filename=dmx3191d-max_sectors
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>

The dmx3191d driver is not capable of DMA or PDMA so all transfers
use PIO. Now that large slow PIO transfers periodically stop and call
cond_resched(), the max_sectors limit can go away.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/dmx3191d.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2016-03-14 15:26:39.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2016-03-14 15:26:49.000000000 +1100
@@ -67,7 +67,6 @@ static struct scsi_host_template dmx3191
 	.cmd_per_lun		= 2,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.cmd_size		= NCR5380_CMD_SIZE,
-	.max_sectors		= 128,
 };
 
 static int dmx3191d_probe_one(struct pci_dev *pdev,


