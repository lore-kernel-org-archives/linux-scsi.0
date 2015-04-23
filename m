From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v5 22/42] hpsa: correct return values from driver functions.
Date: Thu, 23 Apr 2015 09:33:43 -0500
Message-ID: <20150423143343.18832.62630.stgit@brunhilda>
References: <20150423141637.18832.35621.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:37555 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966081AbbDWOev (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2015 10:34:51 -0400
Received: from g1t5425.austin.hp.com (g1t5425.austin.hp.com [15.216.225.55])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id EDA0C316E
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2015 14:34:50 +0000 (UTC)
In-Reply-To: <20150423141637.18832.35621.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

correct return codes for error conditions

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Hannes Reinecke <hare@Suse.de>
Signed-off-by: Robert Elliott <elliott@hp.com>
 igned-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c8ee240..4418ffd 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2655,9 +2655,9 @@ static int hpsa_get_raid_map(struct ctlr_info *h,
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
@@ -5405,7 +5405,7 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	if (iocommand.buf_size > 0) {
 		buff = kmalloc(iocommand.buf_size, GFP_KERNEL);
 		if (buff == NULL)
-			return -EFAULT;
+			return -ENOMEM;
 		if (iocommand.Request.Type.Direction & XFER_WRITE) {
 			/* Copy the data into the buffer we created */
 			if (copy_from_user(buff, iocommand.buf,
@@ -7954,7 +7954,7 @@ static int hpsa_alloc_ioaccel1_cmd_and_bft(struct ctlr_info *h)
 
 clean_up:
 	hpsa_free_ioaccel1_cmd_and_bft(h);
-	return 1;
+	return -ENOMEM;
 }
 
 /* Free ioaccel2 mode command blocks and block fetch table */

