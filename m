From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 3/7] hpsa: add timeouts for driver initiated commands
Date: Wed, 27 Apr 2016 17:13:51 -0500
Message-ID: <146179523157.31195.3103071823535194809.stgit@brunhilda>
References: <146179474454.31195.15135625511559409075.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0094.outbound.protection.outlook.com ([207.46.100.94]:14304
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751731AbcD0W2o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 18:28:44 -0400
In-Reply-To: <146179474454.31195.15135625511559409075.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

faulty drives can cause the driver to hang during a
scan operation.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 035117a..fa4ba34 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2831,7 +2831,7 @@ static int hpsa_scsi_do_inquiry(struct ctlr_info *h, unsigned char *scsi3addr,
 		goto out;
 	}
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
-					PCI_DMA_FROMDEVICE, NO_TIMEOUT);
+					PCI_DMA_FROMDEVICE, DEFAULT_TIMEOUT);
 	if (rc)
 		goto out;
 	ei = c->err_info;
@@ -2857,7 +2857,7 @@ static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr,
 	/* fill_cmd can't fail here, no data buffer to map. */
 	(void) fill_cmd(c, reset_type, h, NULL, 0, 0,
 			scsi3addr, TYPE_MSG);
-	rc = hpsa_scsi_do_simple_cmd(h, c, reply_queue, NO_TIMEOUT);
+	rc = hpsa_scsi_do_simple_cmd(h, c, reply_queue, DEFAULT_TIMEOUT);
 	if (rc) {
 		dev_warn(&h->pdev->dev, "Failed to send reset command\n");
 		goto out;
@@ -3105,7 +3105,7 @@ static int hpsa_get_raid_map(struct ctlr_info *h,
 		return -1;
 	}
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
-					PCI_DMA_FROMDEVICE, NO_TIMEOUT);
+					PCI_DMA_FROMDEVICE, DEFAULT_TIMEOUT);
 	if (rc)
 		goto out;
 	ei = c->err_info;
@@ -3148,7 +3148,7 @@ static int hpsa_bmic_sense_subsystem_information(struct ctlr_info *h,
 	c->Request.CDB[9] = (bmic_device_index >> 8) & 0xff;
 
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
-				PCI_DMA_FROMDEVICE, NO_TIMEOUT);
+				PCI_DMA_FROMDEVICE, DEFAULT_TIMEOUT);
 	if (rc)
 		goto out;
 	ei = c->err_info;
@@ -3176,7 +3176,7 @@ static int hpsa_bmic_id_controller(struct ctlr_info *h,
 		goto out;
 
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
-		PCI_DMA_FROMDEVICE, NO_TIMEOUT);
+		PCI_DMA_FROMDEVICE, DEFAULT_TIMEOUT);
 	if (rc)
 		goto out;
 	ei = c->err_info;
@@ -3207,7 +3207,7 @@ static int hpsa_bmic_id_physical_device(struct ctlr_info *h,
 	c->Request.CDB[9] = (bmic_device_index >> 8) & 0xff;
 
 	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE,
-						NO_TIMEOUT);
+						DEFAULT_TIMEOUT);
 	ei = c->err_info;
 	if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
 		hpsa_scsi_interpret_error(h, c);
@@ -3275,7 +3275,7 @@ static void hpsa_get_enclosure_info(struct ctlr_info *h,
 		c->Request.CDB[5] = 0;
 
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE,
-						NO_TIMEOUT);
+						DEFAULT_TIMEOUT);
 	if (rc)
 		goto out;
 
@@ -3487,7 +3487,7 @@ static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
 	if (extended_response)
 		c->Request.CDB[1] = extended_response;
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
-					PCI_DMA_FROMDEVICE, NO_TIMEOUT);
+					PCI_DMA_FROMDEVICE, DEFAULT_TIMEOUT);
 	if (rc)
 		goto out;
 	ei = c->err_info;
@@ -3594,7 +3594,8 @@ static int hpsa_volume_offline(struct ctlr_info *h,
 	c = cmd_alloc(h);
 
 	(void) fill_cmd(c, TEST_UNIT_READY, h, NULL, 0, 0, scsi3addr, TYPE_CMD);
-	rc = hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE, NO_TIMEOUT);
+	rc = hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE,
+					DEFAULT_TIMEOUT);
 	if (rc) {
 		cmd_free(h, c);
 		return 0;
@@ -3669,7 +3670,8 @@ static int hpsa_device_supports_aborts(struct ctlr_info *h,
 	c = cmd_alloc(h);
 
 	(void) fill_cmd(c, HPSA_ABORT_MSG, h, &tag, 0, 0, scsi3addr, TYPE_MSG);
-	(void) hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE, NO_TIMEOUT);
+	(void) hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE,
+					DEFAULT_TIMEOUT);
 	/* no unmap needed here because no data xfer. */
 	ei = c->err_info;
 	switch (ei->CommandStatus) {
@@ -5439,7 +5441,7 @@ static int hpsa_send_test_unit_ready(struct ctlr_info *h,
 	/* Send the Test Unit Ready, fill_cmd can't fail, no mapping */
 	(void) fill_cmd(c, TEST_UNIT_READY, h,
 			NULL, 0, 0, lunaddr, TYPE_CMD);
-	rc = hpsa_scsi_do_simple_cmd(h, c, reply_queue, NO_TIMEOUT);
+	rc = hpsa_scsi_do_simple_cmd(h, c, reply_queue, DEFAULT_TIMEOUT);
 	if (rc)
 		return rc;
 	/* no unmap needed here because no data xfer. */
@@ -5663,7 +5665,7 @@ static int hpsa_send_abort(struct ctlr_info *h, unsigned char *scsi3addr,
 		0, 0, scsi3addr, TYPE_MSG);
 	if (h->needs_abort_tags_swizzled)
 		swizzle_abort_tag(&c->Request.CDB[4]);
-	(void) hpsa_scsi_do_simple_cmd(h, c, reply_queue, NO_TIMEOUT);
+	(void) hpsa_scsi_do_simple_cmd(h, c, reply_queue, DEFAULT_TIMEOUT);
 	hpsa_get_tag(h, abort, &taglower, &tagupper);
 	dev_dbg(&h->pdev->dev, "%s: Tag:0x%08x:%08x: do_simple_cmd(abort) completed.\n",
 		__func__, tagupper, taglower);
@@ -5828,7 +5830,7 @@ static int hpsa_send_abort_ioaccel2(struct ctlr_info *h,
 	c = cmd_alloc(h);
 	setup_ioaccel2_abort_cmd(c, h, abort, reply_queue);
 	c2 = &h->ioaccel2_cmd_pool[c->cmdindex];
-	(void) hpsa_scsi_do_simple_cmd(h, c, reply_queue, NO_TIMEOUT);
+	(void) hpsa_scsi_do_simple_cmd(h, c, reply_queue, DEFAULT_TIMEOUT);
 	hpsa_get_tag(h, abort, &taglower, &tagupper);
 	dev_dbg(&h->pdev->dev,
 		"%s: Tag:0x%08x:%08x: do_simple_cmd(ioaccel2 abort) completed.\n",
@@ -6373,7 +6375,8 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		c->SG[0].Len = cpu_to_le32(iocommand.buf_size);
 		c->SG[0].Ext = cpu_to_le32(HPSA_SG_LAST); /* not chaining */
 	}
-	rc = hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE, NO_TIMEOUT);
+	rc = hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE,
+					DEFAULT_TIMEOUT);
 	if (iocommand.buf_size > 0)
 		hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_BIDIRECTIONAL);
 	check_ioctl_unit_attention(h, c);
@@ -6505,7 +6508,8 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		}
 		c->SG[--i].Ext = cpu_to_le32(HPSA_SG_LAST);
 	}
-	status = hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE, NO_TIMEOUT);
+	status = hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE,
+						DEFAULT_TIMEOUT);
 	if (sg_used)
 		hpsa_pci_unmap(h->pdev, c, sg_used, PCI_DMA_BIDIRECTIONAL);
 	check_ioctl_unit_attention(h, c);
@@ -8728,7 +8732,7 @@ static void hpsa_flush_cache(struct ctlr_info *h)
 		goto out;
 	}
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
-					PCI_DMA_TODEVICE, NO_TIMEOUT);
+					PCI_DMA_TODEVICE, DEFAULT_TIMEOUT);
 	if (rc)
 		goto out;
 	if (c->err_info->CommandStatus != 0)
@@ -8767,7 +8771,7 @@ static void hpsa_disable_rld_caching(struct ctlr_info *h)
 		goto errout;
 
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
-		PCI_DMA_FROMDEVICE, NO_TIMEOUT);
+		PCI_DMA_FROMDEVICE, DEFAULT_TIMEOUT);
 	if ((rc != 0) || (c->err_info->CommandStatus != 0))
 		goto errout;
 
@@ -8779,7 +8783,7 @@ static void hpsa_disable_rld_caching(struct ctlr_info *h)
 		goto errout;
 
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
-		PCI_DMA_TODEVICE, NO_TIMEOUT);
+		PCI_DMA_TODEVICE, DEFAULT_TIMEOUT);
 	if ((rc != 0)  || (c->err_info->CommandStatus != 0))
 		goto errout;
 
@@ -8789,7 +8793,7 @@ static void hpsa_disable_rld_caching(struct ctlr_info *h)
 		goto errout;
 
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
-		PCI_DMA_FROMDEVICE, NO_TIMEOUT);
+		PCI_DMA_FROMDEVICE, DEFAULT_TIMEOUT);
 	if ((rc != 0)  || (c->err_info->CommandStatus != 0))
 		goto errout;
 

