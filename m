From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 16/17] hpsa:  Make fill_cmd() return void
Date: Wed, 11 Nov 2009 10:51:45 -0600
Message-ID: <20091111165145.17754.2859.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758247AbZKKQuZ@vger.kernel.org>
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

hpsa:  Make fill_cmd() return void, and BUG() if it is asked to
fill out an unknown command or command type, as that should simply
not happen as all the commands and command types are fixed, and
known ahead of time.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/scsi/hpsa.c |   73 +++++++++++++++++----------------------------------
 1 files changed, 25 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6dc7ce6..5097995 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -126,7 +126,7 @@ static void cmd_free(struct ctlr_info *h, struct CommandList *c);
 static void cmd_special_free(struct ctlr_info *h, struct CommandList *c);
 static struct CommandList *cmd_alloc(struct ctlr_info *h);
 static struct CommandList *cmd_special_alloc(struct ctlr_info *h);
-static int fill_cmd(struct CommandList *c, __u8 cmd, struct ctlr_info *h,
+static void fill_cmd(struct CommandList *c, __u8 cmd, struct ctlr_info *h,
 	void *buff, size_t size, __u8 page_code, unsigned char *scsi3addr,
 	int cmd_type);
 
@@ -1258,7 +1258,7 @@ static int hpsa_scsi_do_inquiry(struct ctlr_info *h, unsigned char *scsi3addr,
 			unsigned char page, unsigned char *buf,
 			unsigned char bufsize)
 {
-	int rc;
+	int rc = IO_OK;
 	struct CommandList *c;
 	struct ErrorInfo *ei;
 
@@ -1269,16 +1269,12 @@ static int hpsa_scsi_do_inquiry(struct ctlr_info *h, unsigned char *scsi3addr,
 		return -1;
 	}
 
-	rc = fill_cmd(c, HPSA_INQUIRY, h, buf, bufsize, page, scsi3addr,
-		TYPE_CMD);
-	if (rc == 0) {
-		hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE);
-		ei = c->err_info;
-		if (ei->CommandStatus != 0 &&
-		    ei->CommandStatus != CMD_DATA_UNDERRUN) {
-			hpsa_scsi_interpret_error(c);
-			rc = -1;
-		}
+	fill_cmd(c, HPSA_INQUIRY, h, buf, bufsize, page, scsi3addr, TYPE_CMD);
+	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE);
+	ei = c->err_info;
+	if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
+		hpsa_scsi_interpret_error(c);
+		rc = -1;
 	}
 	cmd_special_free(h, c);
 	return rc;
@@ -1286,7 +1282,7 @@ static int hpsa_scsi_do_inquiry(struct ctlr_info *h, unsigned char *scsi3addr,
 
 static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr)
 {
-	int rc;
+	int rc = IO_OK;
 	struct CommandList *c;
 	struct ErrorInfo *ei;
 
@@ -1297,11 +1293,7 @@ static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr)
 		return -1;
 	}
 
-	rc = fill_cmd(c, HPSA_DEVICE_RESET_MSG, h, NULL, 0, 0, scsi3addr,
-		TYPE_MSG);
-	if (rc != 0)
-		goto out;
-
+	fill_cmd(c, HPSA_DEVICE_RESET_MSG, h, NULL, 0, 0, scsi3addr, TYPE_MSG);
 	hpsa_scsi_do_simple_cmd_core(h, c);
 	/* no unmap needed here because no data xfer. */
 
@@ -1310,7 +1302,6 @@ static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr)
 		hpsa_scsi_interpret_error(c);
 		rc = -1;
 	}
-out:
 	cmd_special_free(h, c);
 	return rc;
 }
@@ -1357,7 +1348,7 @@ static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
 		struct ReportLUNdata *buf, int bufsize,
 		int extended_response)
 {
-	int rc;
+	int rc = IO_OK;
 	struct CommandList *c;
 	unsigned char scsi3addr[8];
 	struct ErrorInfo *ei;
@@ -1370,11 +1361,8 @@ static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
 
 	memset(&scsi3addr[0], 0, 8); /* address the controller */
 
-	rc = fill_cmd(c, logical ? HPSA_REPORT_LOG : HPSA_REPORT_PHYS, h,
+	fill_cmd(c, logical ? HPSA_REPORT_LOG : HPSA_REPORT_PHYS, h,
 		buf, bufsize, 0, scsi3addr, TYPE_CMD);
-	if (rc != 0)
-		goto out;
-
 	if (extended_response)
 		c->Request.CDB[1] = extended_response;
 	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE);
@@ -1384,7 +1372,6 @@ static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
 		hpsa_scsi_interpret_error(c);
 		rc = -1;
 	}
-out:
 	cmd_special_free(h, c);
 	return rc;
 }
@@ -1944,7 +1931,7 @@ static int hpsa_register_scsi(struct ctlr_info *h)
 static int wait_for_device_to_become_ready(struct ctlr_info *h,
 	unsigned char lunaddr[])
 {
-	int rc;
+	int rc = 0;
 	int count = 0;
 	int waittime = HZ;
 	struct CommandList *c;
@@ -1971,15 +1958,7 @@ static int wait_for_device_to_become_ready(struct ctlr_info *h,
 			waittime = waittime * 2;
 
 		/* Send the Test Unit Ready */
-		rc = fill_cmd(c, TEST_UNIT_READY, h, NULL, 0, 0,
-			lunaddr, TYPE_CMD);
-		if (rc != 0) {
-			/* We don't expect to get in here */
-			dev_warn(&h->pdev->dev, "fill_cmd failed at %s:%d\n",
-				__FILE__, __LINE__);
-			break;
-		}
-
+		fill_cmd(c, TEST_UNIT_READY, h, NULL, 0, 0, lunaddr, TYPE_CMD);
 		hpsa_scsi_do_simple_cmd_core(h, c);
 		/* no unmap needed here because no data xfer. */
 
@@ -2558,7 +2537,7 @@ static int hpsa_ioctl(struct scsi_device *dev, int cmd, void *arg)
 	}
 }
 
-static int fill_cmd(struct CommandList *c, __u8 cmd, struct ctlr_info *h,
+static void fill_cmd(struct CommandList *c, __u8 cmd, struct ctlr_info *h,
 	void *buff, size_t size, __u8 page_code, unsigned char *scsi3addr,
 	int cmd_type)
 {
@@ -2631,7 +2610,8 @@ static int fill_cmd(struct CommandList *c, __u8 cmd, struct ctlr_info *h,
 			break;
 		default:
 			dev_warn(&h->pdev->dev, "unknown command 0x%c\n", cmd);
-			return IO_ERROR;
+			BUG();
+			return;
 		}
 	} else if (cmd_type == TYPE_MSG) {
 		switch (cmd) {
@@ -2655,11 +2635,11 @@ static int fill_cmd(struct CommandList *c, __u8 cmd, struct ctlr_info *h,
 		default:
 			dev_warn(&h->pdev->dev, "unknown message type %d\n",
 				cmd);
-			return IO_ERROR;
+			BUG();
 		}
 	} else {
 		dev_warn(&h->pdev->dev, "unknown command type %d\n", cmd_type);
-		return IO_ERROR;
+		BUG();
 	}
 
 	switch (c->Request.Type.Direction) {
@@ -2678,7 +2658,7 @@ static int fill_cmd(struct CommandList *c, __u8 cmd, struct ctlr_info *h,
 
 	hpsa_map_one(h->pdev, c, buff, size, pci_dir);
 
-	return IO_OK;
+	return;
 }
 
 /*
@@ -3429,7 +3409,6 @@ static void hpsa_flush_cache(struct ctlr_info *h)
 {
 	char *flush_buf;
 	struct CommandList *c;
-	int rc;
 
 	flush_buf = kzalloc(4, GFP_KERNEL);
 	if (!flush_buf)
@@ -3440,14 +3419,12 @@ static void hpsa_flush_cache(struct ctlr_info *h)
 		dev_warn(&h->pdev->dev, "cmd_special_alloc returned NULL!\n");
 		goto out_of_memory;
 	}
-	rc = fill_cmd(c, HPSA_CACHE_FLUSH, h, flush_buf, 4, 0,
+	fill_cmd(c, HPSA_CACHE_FLUSH, h, flush_buf, 4, 0,
 		RAID_CTLR_LUNID, TYPE_CMD);
-	if (rc == 0) {
-		hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_TODEVICE);
-		if (c->err_info->CommandStatus != 0)
-			dev_warn(&h->pdev->dev,
-				"error flushing cache on controller\n");
-	}
+	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_TODEVICE);
+	if (c->err_info->CommandStatus != 0)
+		dev_warn(&h->pdev->dev,
+			"error flushing cache on controller\n");
 	cmd_special_free(h, c);
 out_of_memory:
 	kfree(flush_buf);
