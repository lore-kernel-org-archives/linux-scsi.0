From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 10/16] hpsa: clarify messages around reset behavior
Date: Tue, 03 May 2011 14:59:36 -0500
Message-ID: <20110503195936.5478.97874.stgit@beardog.cce.hp.com>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

When waiting for the board to become "not ready"
don't print a message saying "waiting for board to
become ready" (possibly followed by a message saying
"failed waiting for board to become not ready".  Instead,
it should be "waiting for board to reset" and "failed
waiting for board to reset."

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 97db2e5..2a90e9a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3334,11 +3334,11 @@ static __devinit int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	msleep(HPSA_POST_RESET_PAUSE_MSECS);
 
 	/* Wait for board to become not ready, then ready. */
-	dev_info(&pdev->dev, "Waiting for board to become ready.\n");
+	dev_info(&pdev->dev, "Waiting for board to reset.\n");
 	rc = hpsa_wait_for_board_state(pdev, vaddr, BOARD_NOT_READY);
 	if (rc)
 		dev_warn(&pdev->dev,
-			"failed waiting for board to become not ready\n");
+			"failed waiting for board to reset\n");
 	rc = hpsa_wait_for_board_state(pdev, vaddr, BOARD_READY);
 	if (rc) {
 		dev_warn(&pdev->dev,
@@ -3837,6 +3837,7 @@ static __devinit int hpsa_init_reset_devices(struct pci_dev *pdev)
 		return -ENODEV;
 
 	/* Now try to get the controller to respond to a no-op */
+	dev_warn(&pdev->dev, "Waiting for controller to respond to no-op\n");
 	for (i = 0; i < HPSA_POST_RESET_NOOP_RETRIES; i++) {
 		if (hpsa_noop(pdev) == 0)
 			break;
