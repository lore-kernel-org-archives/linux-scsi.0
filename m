From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 15/17] hpsa: Remove sendcmd,
	in no case are we required to poll for completions.
Date: Wed, 11 Nov 2009 10:51:40 -0600
Message-ID: <20091111165140.17754.58024.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758226AbZKKQuV@vger.kernel.org>
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

hpsa: Remove sendcmd, there are no instances in which we must poll for
command completion.  This means sendcmd_core() and pollcomplete()
can be removed as well.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/scsi/hpsa.c |  156 ---------------------------------------------------
 1 files changed, 0 insertions(+), 156 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index d171a55..6dc7ce6 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -117,8 +117,6 @@ static int number_of_controllers;
 static irqreturn_t do_hpsa_intr(int irq, void *dev_id);
 static int hpsa_ioctl(struct scsi_device *dev, int cmd, void *arg);
 static void start_io(struct ctlr_info *h);
-static int sendcmd(__u8 cmd, struct ctlr_info *h, void *buff, size_t size,
-		   __u8 page_code, unsigned char *scsi3addr, int cmd_type);
 
 #ifdef CONFIG_COMPAT
 static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd, void *arg);
@@ -131,7 +129,6 @@ static struct CommandList *cmd_special_alloc(struct ctlr_info *h);
 static int fill_cmd(struct CommandList *c, __u8 cmd, struct ctlr_info *h,
 	void *buff, size_t size, __u8 page_code, unsigned char *scsi3addr,
 	int cmd_type);
-static int sendcmd_core(struct ctlr_info *h, struct CommandList *c);
 
 static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
 		void (*done)(struct scsi_cmnd *));
@@ -2685,159 +2682,6 @@ static int fill_cmd(struct CommandList *c, __u8 cmd, struct ctlr_info *h,
 }
 
 /*
- *   Wait polling for a command to complete.
- *   The memory mapped FIFO is polled for the completion.
- *   Used only at init time, interrupts from the HBA are disabled.
- */
-static unsigned long pollcomplete(struct ctlr_info *h)
-{
-	unsigned long done;
-	int i;
-
-	/* Wait (up to HPSA_MAX_POLL_TIME_SECS) for a command to complete */
-	for (i = HPSA_MAX_POLL_TIME_SECS * HZ; i > 0; i--) {
-		done = h->access.command_completed(h);
-		if (done == FIFO_EMPTY)
-			schedule_timeout_uninterruptible(1);
-		else
-			return done;
-	}
-	/* Invalid address to tell caller we ran out of time */
-	dev_warn(&h->pdev->dev, "pollcomplete(): returning 1\n");
-	return 1;
-}
-
-/* Send command c to controller h and poll for it to complete.
- * Turns interrupts off on the board.  Used at driver init time
- * and during SCSI error recovery.
- */
-static int sendcmd_core(struct ctlr_info *h, struct CommandList *c)
-{
-	int i;
-	unsigned long complete;
-	int status = IO_ERROR;
-
-resend_cmd1:
-	/*
-	 * Disable interrupt
-	 */
-	h->access.set_intr_mask(h, HPSA_INTR_OFF);
-
-	/* Make sure there is room in the command FIFO
-	 * Actually it should be completely empty at this time
-	 * unless we are in here doing error handling for the scsi
-	 * side of the driver.
-	 */
-	for (i = 200000; i > 0; i--) {
-		/* if fifo isn't full go */
-		if (!(h->access.fifo_full(h)))
-			break;
-		udelay(10);
-		dev_warn(&h->pdev->dev, "sendcmd FIFO full, waiting!\n");
-	}
-	h->access.submit_command(h, c); /* Send the cmd */
-	do {
-		complete = pollcomplete(h);
-
-		if (complete == 1) {
-			dev_warn(&h->pdev->dev,
-			       "sendcmd timeout, no command list address "
-				"returned!\n");
-			status = IO_ERROR;
-			break;
-		}
-
-		/* If it's not the cmd we're looking for, save it for later */
-		if ((complete & ~HPSA_ERROR_BIT) != c->busaddr) {
-			dev_warn(&h->pdev->dev, "unexpected command "
-				"completion.\n");
-			continue;
-		}
-
-		/* It is our command.  If no error, we're done. */
-		if (!(complete & HPSA_ERROR_BIT)) {
-			status = IO_OK;
-			break;
-		}
-
-		/* There is an error... */
-
-		/* if data overrun or underun on Report command ignore it */
-		if (((c->Request.CDB[0] == HPSA_REPORT_LOG) ||
-			(c->Request.CDB[0] == HPSA_REPORT_PHYS) ||
-			(c->Request.CDB[0] == HPSA_INQUIRY)) &&
-			((c->err_info->CommandStatus == CMD_DATA_OVERRUN) ||
-			(c->err_info->CommandStatus == CMD_DATA_UNDERRUN))) {
-			complete = c->busaddr;
-			status = IO_OK;
-			break;
-		}
-		if (c->err_info->CommandStatus == CMD_UNSOLICITED_ABORT) {
-			dev_warn(&h->pdev->dev, "unsolicited abort %p\n", c);
-			if (c->retry_count < MAX_CMD_RETRIES) {
-				dev_warn(&h->pdev->dev, "retrying %p\n", c);
-				c->retry_count++;
-				/* erase the old error information */
-				memset(c->err_info, 0, sizeof(c->err_info));
-				goto resend_cmd1;
-			}
-			dev_warn(&h->pdev->dev,
-				"retried %p too many times\n", c);
-			status = IO_ERROR;
-			goto cleanup1;
-		}
-		if (c->err_info->CommandStatus == CMD_UNABORTABLE) {
-			dev_warn(&h->pdev->dev,
-				"command could not be aborted.\n");
-			status = IO_ERROR;
-			goto cleanup1;
-		}
-		dev_warn(&h->pdev->dev, "sendcmd error\n");
-		dev_warn(&h->pdev->dev,
-			"cmd = 0x%02x, CommandStatus = 0x%02x\n",
-			c->Request.CDB[0], c->err_info->CommandStatus);
-		if (c->err_info->CommandStatus == CMD_TARGET_STATUS) {
-			dev_warn(&h->pdev->dev, "target status = 0x%02x\n",
-				c->err_info->ScsiStatus);
-			if (c->err_info->ScsiStatus == 2) /* chk cond */
-				dev_warn(&h->pdev->dev, "sense key = 0x%02x\n",
-					0xf & c->err_info->SenseInfo[2]);
-		}
-
-		status = IO_ERROR;
-		goto cleanup1;
-
-	} while (1);
-
-cleanup1:
-	hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_BIDIRECTIONAL);
-	return status;
-}
-
-/*
- * Send a command to the controller, and wait for it to complete.
- * Used at init time, and during SCSI error recovery.
- */
-static int sendcmd(__u8 cmd, struct ctlr_info *h, void *buff, size_t size,
-		   __u8 page_code, unsigned char *scsi3addr, int cmd_type)
-{
-	struct CommandList *c;
-	int status;
-
-	c = cmd_alloc(h);
-	if (c == NULL) {
-		dev_warn(&h->pdev->dev, "unable to get memory");
-		return IO_ERROR;
-	}
-	status = fill_cmd(c, cmd, h, buff, size, page_code,
-		scsi3addr, cmd_type);
-	if (status == IO_OK)
-		status = sendcmd_core(h, c);
-	cmd_free(h, c);
-	return status;
-}
-
-/*
  * Map (physical) PCI mem into (virtual) kernel space
  */
 static void __iomem *remap_pci_mem(ulong base, ulong size)
