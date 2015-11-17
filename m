From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 38/52] atp870u: Use n_io_port in request_region and release_region
Date: Tue, 17 Nov 2015 19:24:14 +0100
Message-ID: <1447784668-23713-39-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56529 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126AbbKQSgx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:36:53 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 7f53a50..a06a0a4 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1610,16 +1610,8 @@ flash_ok_885:
 		shpnt->irq = pdev->irq;		
 	} 
 		spin_unlock_irqrestore(shpnt->host_lock, flags);
-		if(ent->device==ATP885_DEVID) {
-			if(!request_region(base_io, 0xff, "atp870u")) /* Register the IO ports that we use */
-				goto request_io_fail;
-		} else if((ent->device==ATP880_DEVID1)||(ent->device==ATP880_DEVID2)) {
-			if(!request_region(base_io, 0x60, "atp870u")) /* Register the IO ports that we use */
-				goto request_io_fail;
-		} else {
-			if(!request_region(base_io, 0x40, "atp870u")) /* Register the IO ports that we use */
-				goto request_io_fail;
-		}				
+		if (!request_region(base_io, shpnt->n_io_port, "atp870u"))
+			goto request_io_fail;
 		count++;
 		if (scsi_add_host(shpnt, &pdev->dev))
 			goto scsi_add_fail;
@@ -1631,13 +1623,7 @@ flash_ok_885:
 
 scsi_add_fail:
 	printk("atp870u_prob:scsi_add_fail\n");
-	if(ent->device==ATP885_DEVID) {
-		release_region(base_io, 0xff);
-	} else if((ent->device==ATP880_DEVID1)||(ent->device==ATP880_DEVID2)) {
-		release_region(base_io, 0x60);
-	} else {
-		release_region(base_io, 0x40);
-	}
+	release_region(base_io, shpnt->n_io_port);
 request_io_fail:
 	printk("atp870u_prob:request_io_fail\n");
 	free_irq(pdev->irq, shpnt);
-- 
Ondrej Zary

