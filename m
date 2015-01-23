From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 23/48] hpsa: get rid of cmd_special_alloc and
 cmd_special_free
Date: Fri, 23 Jan 2015 16:43:04 -0600
Message-ID: <20150123224304.14919.38736.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:39273 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbbAWWn6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:43:58 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

We have commands reserved for internal use.

This is laying the groundwork for removing the internal
queue of commands from the driver so that the locks that
protect that queue may be removed.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |  106 ++++++++++++++-------------------------------------
 drivers/scsi/hpsa.h |    2 -
 2 files changed, 31 insertions(+), 77 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 99c32a0..26e3e5b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -205,9 +205,7 @@ static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd,
 #endif
 
 static void cmd_free(struct ctlr_info *h, struct CommandList *c);
-static void cmd_special_free(struct ctlr_info *h, struct CommandList *c);
 static struct CommandList *cmd_alloc(struct ctlr_info *h);
-static struct CommandList *cmd_special_alloc(struct ctlr_info *h);
 static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 	void *buff, size_t size, u16 page_code, unsigned char *scsi3addr,
 	int cmd_type);
@@ -2057,10 +2055,10 @@ static int hpsa_scsi_do_inquiry(struct ctlr_info *h, unsigned char *scsi3addr,
 	struct CommandList *c;
 	struct ErrorInfo *ei;
 
-	c = cmd_special_alloc(h);
+	c = cmd_alloc(h);
 
 	if (c == NULL) {			/* trouble... */
-		dev_warn(&h->pdev->dev, "cmd_special_alloc returned NULL!\n");
+		dev_warn(&h->pdev->dev, "cmd_alloc returned NULL!\n");
 		return -ENOMEM;
 	}
 
@@ -2076,7 +2074,7 @@ static int hpsa_scsi_do_inquiry(struct ctlr_info *h, unsigned char *scsi3addr,
 		rc = -1;
 	}
 out:
-	cmd_special_free(h, c);
+	cmd_free(h, c);
 	return rc;
 }
 
@@ -2088,10 +2086,9 @@ static int hpsa_bmic_ctrl_mode_sense(struct ctlr_info *h,
 	struct CommandList *c;
 	struct ErrorInfo *ei;
 
-	c = cmd_special_alloc(h);
-
+	c = cmd_alloc(h);
 	if (c == NULL) {			/* trouble... */
-		dev_warn(&h->pdev->dev, "cmd_special_alloc returned NULL!\n");
+		dev_warn(&h->pdev->dev, "cmd_alloc returned NULL!\n");
 		return -ENOMEM;
 	}
 
@@ -2107,7 +2104,7 @@ static int hpsa_bmic_ctrl_mode_sense(struct ctlr_info *h,
 		rc = -1;
 	}
 out:
-	cmd_special_free(h, c);
+	cmd_free(h, c);
 	return rc;
 	}
 
@@ -2118,10 +2115,10 @@ static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr,
 	struct CommandList *c;
 	struct ErrorInfo *ei;
 
-	c = cmd_special_alloc(h);
+	c = cmd_alloc(h);
 
 	if (c == NULL) {			/* trouble... */
-		dev_warn(&h->pdev->dev, "cmd_special_alloc returned NULL!\n");
+		dev_warn(&h->pdev->dev, "cmd_alloc returned NULL!\n");
 		return -ENOMEM;
 	}
 
@@ -2137,7 +2134,7 @@ static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr,
 		hpsa_scsi_interpret_error(h, c);
 		rc = -1;
 	}
-	cmd_special_free(h, c);
+	cmd_free(h, c);
 	return rc;
 }
 
@@ -2245,26 +2242,26 @@ static int hpsa_get_raid_map(struct ctlr_info *h,
 	struct CommandList *c;
 	struct ErrorInfo *ei;
 
-	c = cmd_special_alloc(h);
+	c = cmd_alloc(h);
 	if (c == NULL) {
-		dev_warn(&h->pdev->dev, "cmd_special_alloc returned NULL!\n");
+		dev_warn(&h->pdev->dev, "cmd_alloc returned NULL!\n");
 		return -ENOMEM;
 	}
 	if (fill_cmd(c, HPSA_GET_RAID_MAP, h, &this_device->raid_map,
 			sizeof(this_device->raid_map), 0,
 			scsi3addr, TYPE_CMD)) {
 		dev_warn(&h->pdev->dev, "Out of memory in hpsa_get_raid_map()\n");
-		cmd_special_free(h, c);
+		cmd_free(h, c);
 		return -ENOMEM;
 	}
 	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE);
 	ei = c->err_info;
 	if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
 		hpsa_scsi_interpret_error(h, c);
-		cmd_special_free(h, c);
+		cmd_free(h, c);
 		return -1;
 	}
-	cmd_special_free(h, c);
+	cmd_free(h, c);
 
 	/* @todo in the future, dynamically allocate RAID map memory */
 	if (le32_to_cpu(this_device->raid_map.structure_size) >
@@ -2384,9 +2381,9 @@ static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
 	unsigned char scsi3addr[8];
 	struct ErrorInfo *ei;
 
-	c = cmd_special_alloc(h);
+	c = cmd_alloc(h);
 	if (c == NULL) {			/* trouble... */
-		dev_err(&h->pdev->dev, "cmd_special_alloc returned NULL!\n");
+		dev_err(&h->pdev->dev, "cmd_alloc returned NULL!\n");
 		return -1;
 	}
 	/* address the controller */
@@ -2414,7 +2411,7 @@ static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
 		}
 	}
 out:
-	cmd_special_free(h, c);
+	cmd_free(h, c);
 	return rc;
 }
 
@@ -4102,7 +4099,7 @@ static int wait_for_device_to_become_ready(struct ctlr_info *h,
 	int waittime = 1; /* seconds */
 	struct CommandList *c;
 
-	c = cmd_special_alloc(h);
+	c = cmd_alloc(h);
 	if (!c) {
 		dev_warn(&h->pdev->dev, "out of memory in "
 			"wait_for_device_to_become_ready.\n");
@@ -4148,7 +4145,7 @@ static int wait_for_device_to_become_ready(struct ctlr_info *h,
 	else
 		dev_warn(&h->pdev->dev, "device is ready.\n");
 
-	cmd_special_free(h, c);
+	cmd_free(h, c);
 	return rc;
 }
 
@@ -4230,9 +4227,9 @@ static int hpsa_send_abort(struct ctlr_info *h, unsigned char *scsi3addr,
 	struct ErrorInfo *ei;
 	__le32 tagupper, taglower;
 
-	c = cmd_special_alloc(h);
+	c = cmd_alloc(h);
 	if (c == NULL) {	/* trouble... */
-		dev_warn(&h->pdev->dev, "cmd_special_alloc returned NULL!\n");
+		dev_warn(&h->pdev->dev, "cmd_alloc returned NULL!\n");
 		return -ENOMEM;
 	}
 
@@ -4261,7 +4258,7 @@ static int hpsa_send_abort(struct ctlr_info *h, unsigned char *scsi3addr,
 		rc = -1;
 		break;
 	}
-	cmd_special_free(h, c);
+	cmd_free(h, c);
 	dev_dbg(&h->pdev->dev, "%s: Tag:0x%08x:%08x: Finished.\n",
 		__func__, tagupper, taglower);
 	return rc;
@@ -4610,40 +4607,6 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 	return c;
 }
 
-/* For operations that can wait for kmalloc to possibly sleep,
- * this routine can be called. Lock need not be held to call
- * cmd_special_alloc. cmd_special_free() is the complement.
- */
-static struct CommandList *cmd_special_alloc(struct ctlr_info *h)
-{
-	struct CommandList *c;
-	dma_addr_t cmd_dma_handle, err_dma_handle;
-
-	c = pci_zalloc_consistent(h->pdev, sizeof(*c), &cmd_dma_handle);
-	if (c == NULL)
-		return NULL;
-
-	c->cmd_type = CMD_SCSI;
-	c->cmdindex = -1;
-
-	c->err_info = pci_zalloc_consistent(h->pdev, sizeof(*c->err_info),
-					    &err_dma_handle);
-
-	if (c->err_info == NULL) {
-		pci_free_consistent(h->pdev,
-			sizeof(*c), c, cmd_dma_handle);
-		return NULL;
-	}
-
-	INIT_LIST_HEAD(&c->list);
-	c->busaddr = (u32) cmd_dma_handle;
-	c->ErrDesc.Addr = cpu_to_le64(err_dma_handle);
-	c->ErrDesc.Len = cpu_to_le32(sizeof(*c->err_info));
-
-	c->h = h;
-	return c;
-}
-
 static void cmd_free(struct ctlr_info *h, struct CommandList *c)
 {
 	int i;
@@ -4653,15 +4616,6 @@ static void cmd_free(struct ctlr_info *h, struct CommandList *c)
 		  h->cmd_pool_bits + (i / BITS_PER_LONG));
 }
 
-static void cmd_special_free(struct ctlr_info *h, struct CommandList *c)
-{
-	pci_free_consistent(h->pdev, sizeof(*c->err_info),
-			    c->err_info,
-			    (dma_addr_t) le64_to_cpu(c->ErrDesc.Addr));
-	pci_free_consistent(h->pdev, sizeof(*c),
-			    c, (dma_addr_t) (c->busaddr & DIRECT_LOOKUP_MASK));
-}
-
 #ifdef CONFIG_COMPAT
 
 static int hpsa_ioctl32_passthru(struct scsi_device *dev, int cmd,
@@ -4840,7 +4794,7 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 			memset(buff, 0, iocommand.buf_size);
 		}
 	}
-	c = cmd_special_alloc(h);
+	c = cmd_alloc(h);
 	if (c == NULL) {
 		rc = -ENOMEM;
 		goto out_kfree;
@@ -4899,7 +4853,7 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		}
 	}
 out:
-	cmd_special_free(h, c);
+	cmd_free(h, c);
 out_kfree:
 	kfree(buff);
 	return rc;
@@ -4977,7 +4931,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		data_ptr += sz;
 		sg_used++;
 	}
-	c = cmd_special_alloc(h);
+	c = cmd_alloc(h);
 	if (c == NULL) {
 		status = -ENOMEM;
 		goto cleanup1;
@@ -5034,7 +4988,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	}
 	status = 0;
 cleanup0:
-	cmd_special_free(h, c);
+	cmd_free(h, c);
 cleanup1:
 	if (buff) {
 		int i;
@@ -6188,7 +6142,7 @@ static int hpsa_supports_chained_sg_blocks(struct ctlr_info *h)
 static void hpsa_find_board_params(struct ctlr_info *h)
 {
 	hpsa_get_max_perf_mode_cmds(h);
-	h->nr_cmds = h->max_commands - 4; /* Allow room for some ioctls */
+	h->nr_cmds = h->max_commands;
 	h->maxsgentries = readl(&(h->cfgtable->MaxScatterGatherElements));
 	h->fw_support = readl(&(h->cfgtable->misc_fw_support));
 	if (hpsa_supports_chained_sg_blocks(h)) {
@@ -7064,9 +7018,9 @@ static void hpsa_flush_cache(struct ctlr_info *h)
 	if (!flush_buf)
 		return;
 
-	c = cmd_special_alloc(h);
+	c = cmd_alloc(h);
 	if (!c) {
-		dev_warn(&h->pdev->dev, "cmd_special_alloc returned NULL!\n");
+		dev_warn(&h->pdev->dev, "cmd_alloc returned NULL!\n");
 		goto out_of_memory;
 	}
 	if (fill_cmd(c, HPSA_CACHE_FLUSH, h, flush_buf, 4, 0,
@@ -7078,7 +7032,7 @@ static void hpsa_flush_cache(struct ctlr_info *h)
 out:
 		dev_warn(&h->pdev->dev,
 			"error flushing cache on controller\n");
-	cmd_special_free(h, c);
+	cmd_free(h, c);
 out_of_memory:
 	kfree(flush_buf);
 }
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 5ee6c6a..06c9e43 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -170,7 +170,7 @@ struct ctlr_info {
 	unsigned long transMethod;
 
 	/* cap concurrent passthrus at some reasonable maximum */
-#define HPSA_MAX_CONCURRENT_PASSTHRUS (20)
+#define HPSA_MAX_CONCURRENT_PASSTHRUS (10)
 	spinlock_t passthru_count_lock; /* protects passthru_count */
 	int passthru_count;
 

