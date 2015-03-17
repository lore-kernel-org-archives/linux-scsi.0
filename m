From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 29/42] hpsa: refactor and rework support for sending
 TEST_UNIT_READY
Date: Tue, 17 Mar 2015 15:05:01 -0500
Message-ID: <20150317200501.19856.33095.stgit@brunhilda>
References: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:55104 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335AbbCQUGk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:06:40 -0400
In-Reply-To: <20150317200139.19856.87982.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Webb Scales <webbnh@hp.com>

Factor out the code which sends the TEST_UNIT_READY from
wait_for_device_to_become_ready() into its own function.

Move the code which waits for the TEST_UNIT_READY from
wait_for_device_to_become_ready() into its own function.

If a logical drive has failed, resetting it will ensure
outstanding commands are completed, but polling it with
TURs after the reset will not work because the TURs will
never report good status.  So successful TUR should not
be a condition of success for the device reset error
handler.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Webb Scales <webbnh@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |  117 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 87 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1cae336..3751df3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4822,51 +4822,108 @@ static int hpsa_register_scsi(struct ctlr_info *h)
 	return -ENOMEM;
 }
 
-static int wait_for_device_to_become_ready(struct ctlr_info *h,
-	unsigned char lunaddr[])
+/*
+ * Send a TEST_UNIT_READY command to the specified LUN using the specified
+ * reply queue; returns zero if the unit is ready, and non-zero otherwise.
+ */
+static int hpsa_send_test_unit_ready(struct ctlr_info *h,
+				struct CommandList *c, unsigned char lunaddr[],
+				int reply_queue)
+{
+	int rc;
+
+	/* Send the Test Unit Ready, fill_cmd can't fail, no mapping */
+	(void) fill_cmd(c, TEST_UNIT_READY, h,
+			NULL, 0, 0, lunaddr, TYPE_CMD);
+	rc = hpsa_scsi_do_simple_cmd(h, c, reply_queue, NO_TIMEOUT);
+	if (rc)
+		return rc;
+	/* no unmap needed here because no data xfer. */
+
+	/* Check if the unit is already ready. */
+	if (c->err_info->CommandStatus == CMD_SUCCESS)
+		return 0;
+
+	/*
+	 * The first command sent after reset will receive "unit attention" to
+	 * indicate that the LUN has been reset...this is actually what we're
+	 * looking for (but, success is good too).
+	 */
+	if (c->err_info->CommandStatus == CMD_TARGET_STATUS &&
+		c->err_info->ScsiStatus == SAM_STAT_CHECK_CONDITION &&
+			(c->err_info->SenseInfo[2] == NO_SENSE ||
+			 c->err_info->SenseInfo[2] == UNIT_ATTENTION))
+		return 0;
+
+	return 1;
+}
+
+/*
+ * Wait for a TEST_UNIT_READY command to complete, retrying as necessary;
+ * returns zero when the unit is ready, and non-zero when giving up.
+ */
+static int hpsa_wait_for_test_unit_ready(struct ctlr_info *h,
+				struct CommandList *c,
+				unsigned char lunaddr[], int reply_queue)
 {
 	int rc;
 	int count = 0;
 	int waittime = 1; /* seconds */
-	struct CommandList *c;
-
-	c = cmd_alloc(h);
 
 	/* Send test unit ready until device ready, or give up. */
-	while (count < HPSA_TUR_RETRY_LIMIT) {
+	for (count = 0; count < HPSA_TUR_RETRY_LIMIT; count++) {
 
-		/* Wait for a bit.  do this first, because if we send
+		/*
+		 * Wait for a bit.  do this first, because if we send
 		 * the TUR right away, the reset will just abort it.
 		 */
 		msleep(1000 * waittime);
-		count++;
-		rc = 0; /* Device ready. */
+
+		rc = hpsa_send_test_unit_ready(h, c, lunaddr, reply_queue);
+		if (!rc)
+			break;
 
 		/* Increase wait time with each try, up to a point. */
 		if (waittime < HPSA_MAX_WAIT_INTERVAL_SECS)
-			waittime = waittime * 2;
+			waittime *= 2;
 
-		/* Send the Test Unit Ready, fill_cmd can't fail, no mapping */
-		(void) fill_cmd(c, TEST_UNIT_READY, h,
-				NULL, 0, 0, lunaddr, TYPE_CMD);
-		rc = hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE,
-						NO_TIMEOUT);
-		if (rc)
-			goto do_it_again;
-		/* no unmap needed here because no data xfer. */
+		dev_warn(&h->pdev->dev,
+			 "waiting %d secs for device to become ready.\n",
+			 waittime);
+	}
 
-		if (c->err_info->CommandStatus == CMD_SUCCESS)
-			break;
+	return rc;
+}
 
-		if (c->err_info->CommandStatus == CMD_TARGET_STATUS &&
-			c->err_info->ScsiStatus == SAM_STAT_CHECK_CONDITION &&
-			(c->err_info->SenseInfo[2] == NO_SENSE ||
-			c->err_info->SenseInfo[2] == UNIT_ATTENTION))
+static int wait_for_device_to_become_ready(struct ctlr_info *h,
+					   unsigned char lunaddr[],
+					   int reply_queue)
+{
+	int first_queue;
+	int last_queue;
+	int rq;
+	int rc = 0;
+	struct CommandList *c;
+
+	c = cmd_alloc(h);
+
+	/*
+	 * If no specific reply queue was requested, then send the TUR
+	 * repeatedly, requesting a reply on each reply queue; otherwise execute
+	 * the loop exactly once using only the specified queue.
+	 */
+	if (reply_queue == DEFAULT_REPLY_QUEUE) {
+		first_queue = 0;
+		last_queue = h->nreply_queues - 1;
+	} else {
+		first_queue = reply_queue;
+		last_queue = reply_queue;
+	}
+
+	for (rq = first_queue; rq <= last_queue; rq++) {
+		rc = hpsa_wait_for_test_unit_ready(h, c, lunaddr, rq);
+		if (rc)
 			break;
-do_it_again:
-		dev_warn(&h->pdev->dev, "waiting %d secs "
-			"for device to become ready.\n", waittime);
-		rc = 1; /* device not ready. */
 	}
 
 	if (rc)
@@ -4935,7 +4992,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	/* send a reset to the SCSI LUN which the command was sent to */
 	rc = hpsa_send_reset(h, dev->scsi3addr, HPSA_RESET_TYPE_LUN,
 			     DEFAULT_REPLY_QUEUE);
-	if (rc == 0 && wait_for_device_to_become_ready(h, dev->scsi3addr) == 0)
+	if (rc == 0)
 		return SUCCESS;
 
 	dev_warn(&h->pdev->dev,
@@ -5131,7 +5188,7 @@ static int hpsa_send_reset_as_abort_ioaccel2(struct ctlr_info *h,
 	}
 
 	/* wait for device to recover */
-	if (wait_for_device_to_become_ready(h, psa) != 0) {
+	if (wait_for_device_to_become_ready(h, psa, reply_queue) != 0) {
 		dev_warn(&h->pdev->dev,
 			"Reset as abort: Failed: Device never recovered from reset: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
 			psa[0], psa[1], psa[2], psa[3],

