From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 22/43] hpsa: correct return values from driver functions.
Date: Sat, 21 Feb 2015 16:19:29 -0600
Message-ID: <20150221221929.21954.74644.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:55787 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbbBUWUt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:20:49 -0500
Received: from g6t1524.atlanta.hp.com (g6t1524.atlanta.hp.com [15.193.200.67])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id D01C27A0
	for <linux-scsi@vger.kernel.org>; Sat, 21 Feb 2015 22:20:48 +0000 (UTC)
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

correct return codes for error conditions

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b7223e6..af0439b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2707,9 +2707,9 @@ static int hpsa_get_raid_map(struct ctlr_info *h,
 	if (fill_cmd(c, HPSA_GET_RAID_MAP, h, &this_device->raid_map,
 			sizeof(this_device->raid_map), 0,
 			scsi3addr, TYPE_CMD)) {
-		dev_warn(&h->pdev->dev, "Out of memory in hpsa_get_raid_map()\n");
-		rc = -ENOMEM;
-		goto out;
+		dev_warn(&h->pdev->dev, "hpsa_get_raid_map fill_cmd failed\n");
+		cmd_free(h, c);
+		return -1;
 	}
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
 					PCI_DMA_FROMDEVICE, NO_TIMEOUT);
@@ -5467,7 +5467,7 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	if (iocommand.buf_size > 0) {
 		buff = kmalloc(iocommand.buf_size, GFP_KERNEL);
 		if (buff == NULL)
-			return -EFAULT;
+			return -ENOMEM;
 		if (iocommand.Request.Type.Direction & XFER_WRITE) {
 			/* Copy the data into the buffer we created */
 			if (copy_from_user(buff, iocommand.buf,
@@ -8015,7 +8015,7 @@ static int hpsa_alloc_ioaccel1_cmd_and_bft(struct ctlr_info *h)
 
 clean_up:
 	hpsa_free_ioaccel1_cmd_and_bft(h);
-	return 1;
+	return -ENOMEM;
 }
 
 /* Free ioaccel2 mode command blocks and block fetch table */

