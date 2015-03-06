From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 22/41] hpsa: correct return values from driver functions.
Date: Fri, 06 Mar 2015 17:47:43 -0600
Message-ID: <20150306234743.29973.80226.stgit@brunhilda>
References: <20150306233504.29973.41322.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:37329 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040AbbCFXtN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 18:49:13 -0500
In-Reply-To: <20150306233504.29973.41322.stgit@brunhilda>
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
index 297ccf0..235962d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2694,9 +2694,9 @@ static int hpsa_get_raid_map(struct ctlr_info *h,
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
@@ -5458,7 +5458,7 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	if (iocommand.buf_size > 0) {
 		buff = kmalloc(iocommand.buf_size, GFP_KERNEL);
 		if (buff == NULL)
-			return -EFAULT;
+			return -ENOMEM;
 		if (iocommand.Request.Type.Direction & XFER_WRITE) {
 			/* Copy the data into the buffer we created */
 			if (copy_from_user(buff, iocommand.buf,
@@ -8007,7 +8007,7 @@ static int hpsa_alloc_ioaccel1_cmd_and_bft(struct ctlr_info *h)
 
 clean_up:
 	hpsa_free_ioaccel1_cmd_and_bft(h);
-	return 1;
+	return -ENOMEM;
 }
 
 /* Free ioaccel2 mode command blocks and block fetch table */

