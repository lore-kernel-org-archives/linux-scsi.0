From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 02/13] hpsa: fix board status waiting code
Date: Fri, 08 Oct 2010 15:06:11 -0500
Message-ID: <20101008200611.24279.34840.stgit@beardog.cce.hp.com>
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
restoring PCI config space registers.  Also, only wait 10 secs
for board to become "not ready" after a reset (it should quickly
become not ready.)

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   44 ++++++++++++++++++++++++++++++++++++--------
 drivers/scsi/hpsa.h |    4 ++++
 2 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c5d0606..030a880 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -181,6 +181,10 @@ static int __devinit hpsa_find_cfg_addrs(struct pci_dev *pdev,
 static int __devinit hpsa_pci_find_memory_BAR(struct pci_dev *pdev,
 	unsigned long *memory_bar);
 static int __devinit hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id);
+static int __devinit hpsa_wait_for_board_state(struct pci_dev *pdev,
+	void __iomem *vaddr, int wait_for_ready);
+#define BOARD_NOT_READY 0
+#define BOARD_READY 1
 
 static DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
 static DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
@@ -3260,6 +3264,20 @@ static __devinit int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	   need a little pause here */
 	msleep(HPSA_POST_RESET_PAUSE_MSECS);
 
+	/* Wait for board to become not ready, then ready. */
+	dev_info(&pdev->dev, "Waiting for board to become ready.\n");
+	rc = hpsa_wait_for_board_state(pdev, vaddr, BOARD_NOT_READY);
+	if (rc)
+		dev_warn(&pdev->dev,
+			"failed waiting for board to become not ready\n");
+	rc = hpsa_wait_for_board_state(pdev, vaddr, BOARD_READY);
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
@@ -3455,18 +3473,28 @@ static int __devinit hpsa_pci_find_memory_BAR(struct pci_dev *pdev,
 	return -ENODEV;
 }
 
-static int __devinit hpsa_wait_for_board_ready(struct ctlr_info *h)
+static int __devinit hpsa_wait_for_board_state(struct pci_dev *pdev,
+	void __iomem *vaddr, int wait_for_ready)
 {
-	int i;
+	int i, iterations;
 	u32 scratchpad;
+	if (wait_for_ready)
+		iterations = HPSA_BOARD_READY_ITERATIONS;
+	else
+		iterations = HPSA_BOARD_NOT_READY_ITERATIONS;
 
-	for (i = 0; i < HPSA_BOARD_READY_ITERATIONS; i++) {
-		scratchpad = readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
-		if (scratchpad == HPSA_FIRMWARE_READY)
-			return 0;
+	for (i = 0; i < iterations; i++) {
+		scratchpad = readl(vaddr + SA5_SCRATCHPAD_OFFSET);
+		if (wait_for_ready) {
+			if (scratchpad == HPSA_FIRMWARE_READY)
+				return 0;
+		} else {
+			if (scratchpad != HPSA_FIRMWARE_READY)
+				return 0;
+		}
 		msleep(HPSA_BOARD_READY_POLL_INTERVAL_MSECS);
 	}
-	dev_warn(&h->pdev->dev, "board not ready, timed out.\n");
+	dev_warn(&pdev->dev, "board not ready, timed out.\n");
 	return -ENODEV;
 }
 
@@ -3658,7 +3686,7 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 		err = -ENOMEM;
 		goto err_out_free_res;
 	}
-	err = hpsa_wait_for_board_ready(h);
+	err = hpsa_wait_for_board_state(h->pdev, h->vaddr, BOARD_READY);
 	if (err)
 		goto err_out_free_res;
 	err = hpsa_find_cfgtables(h);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index a203ef6..9595c57 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -155,12 +155,16 @@ struct ctlr_info {
  * HPSA_BOARD_READY_ITERATIONS are derived from those.
  */
 #define HPSA_BOARD_READY_WAIT_SECS (120)
+#define HPSA_BOARD_NOT_READY_WAIT_SECS (10)
 #define HPSA_BOARD_READY_POLL_INTERVAL_MSECS (100)
 #define HPSA_BOARD_READY_POLL_INTERVAL \
 	((HPSA_BOARD_READY_POLL_INTERVAL_MSECS * HZ) / 1000)
 #define HPSA_BOARD_READY_ITERATIONS \
 	((HPSA_BOARD_READY_WAIT_SECS * 1000) / \
 		HPSA_BOARD_READY_POLL_INTERVAL_MSECS)
+#define HPSA_BOARD_NOT_READY_ITERATIONS \
+	((HPSA_BOARD_NOT_READY_WAIT_SECS * 1000) / \
+		HPSA_BOARD_READY_POLL_INTERVAL_MSECS)
 #define HPSA_POST_RESET_PAUSE_MSECS (3000)
 #define HPSA_POST_RESET_NOOP_RETRIES (12)
 
