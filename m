From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 06/13] cciss: fix board status waiting code
Date: Fri, 08 Oct 2010 15:06:32 -0500
Message-ID: <20101008200632.24279.34389.stgit@beardog.cce.hp.com>
References: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com
Cc: akpm@linux-foundation.org, thenzl@redhat.com, mike.miller@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

After a reset, we should first wait for the board to become "not ready",
and then wait for it to become "ready", instead of immediately
waiting for it to become "ready", and do this waiting *after*
restoring PCI config space registers.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   43 +++++++++++++++++++++++++++++++++++--------
 drivers/block/cciss.h |    4 ++++
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ca900ea..9fe6acf 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3986,18 +3986,31 @@ static int __devinit cciss_pci_find_memory_BAR(struct pci_dev *pdev,
 	return -ENODEV;
 }
 
-static int __devinit cciss_wait_for_board_ready(ctlr_info_t *h)
+static int __devinit cciss_wait_for_board_state(struct pci_dev *pdev,
+	void __iomem *vaddr, int wait_for_ready)
+#define BOARD_READY 1
+#define BOARD_NOT_READY 0
 {
-	int i;
+	int i, iterations;
 	u32 scratchpad;
 
-	for (i = 0; i < CCISS_BOARD_READY_ITERATIONS; i++) {
-		scratchpad = readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
-		if (scratchpad == CCISS_FIRMWARE_READY)
-			return 0;
+	if (wait_for_ready)
+		iterations = CCISS_BOARD_READY_ITERATIONS;
+	else
+		iterations = CCISS_BOARD_NOT_READY_ITERATIONS;
+
+	for (i = 0; i < iterations; i++) {
+		scratchpad = readl(vaddr + SA5_SCRATCHPAD_OFFSET);
+		if (wait_for_ready) {
+			if (scratchpad == CCISS_FIRMWARE_READY)
+				return 0;
+		} else {
+			if (scratchpad != CCISS_FIRMWARE_READY)
+				return 0;
+		}
 		msleep(CCISS_BOARD_READY_POLL_INTERVAL_MSECS);
 	}
-	dev_warn(&h->pdev->dev, "board not ready, timed out.\n");
+	dev_warn(&pdev->dev, "board not ready, timed out.\n");
 	return -ENODEV;
 }
 
@@ -4163,7 +4176,7 @@ static int __devinit cciss_pci_init(ctlr_info_t *h)
 		err = -ENOMEM;
 		goto err_out_free_res;
 	}
-	err = cciss_wait_for_board_ready(h);
+	err = cciss_wait_for_board_state(h->pdev, h->vaddr, BOARD_READY);
 	if (err)
 		goto err_out_free_res;
 	err = cciss_find_cfgtables(h);
@@ -4514,6 +4527,20 @@ static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 	   need a little pause here */
 	msleep(CCISS_POST_RESET_PAUSE_MSECS);
 
+	/* Wait for board to become not ready, then ready. */
+	dev_info(&pdev->dev, "Waiting for board to become ready.\n");
+	rc = cciss_wait_for_board_state(pdev, vaddr, BOARD_NOT_READY);
+	if (rc) /* Don't bail, might be E500, etc. which can't be reset */
+		dev_warn(&pdev->dev,
+			"failed waiting for board to become not ready\n");
+	rc = cciss_wait_for_board_state(pdev, vaddr, BOARD_READY);
+	if (rc) {
+		dev_warn(&pdev->dev,
+			"failed waiting for board to become ready\n");
+		goto unmap_cfgtable;
+	}
+	dev_info(&pdev->dev, "board ready.\n");
+
 	/* Controller should be in simple mode at this point.  If it's not,
 	 * It means we're on one of those controllers which doesn't support
 	 * the doorbell reset method and on which the PCI power management reset
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index ae340ff..4b8933d 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -200,10 +200,14 @@ struct ctlr_info
  * the above.
  */
 #define CCISS_BOARD_READY_WAIT_SECS (120)
+#define CCISS_BOARD_NOT_READY_WAIT_SECS (10)
 #define CCISS_BOARD_READY_POLL_INTERVAL_MSECS (100)
 #define CCISS_BOARD_READY_ITERATIONS \
 	((CCISS_BOARD_READY_WAIT_SECS * 1000) / \
 		CCISS_BOARD_READY_POLL_INTERVAL_MSECS)
+#define CCISS_BOARD_NOT_READY_ITERATIONS \
+	((CCISS_BOARD_NOT_READY_WAIT_SECS * 1000) / \
+		CCISS_BOARD_READY_POLL_INTERVAL_MSECS)
 #define CCISS_POST_RESET_PAUSE_MSECS (3000)
 #define CCISS_POST_RESET_NOOP_INTERVAL_MSECS (1000)
 #define CCISS_POST_RESET_NOOP_RETRIES (12)
