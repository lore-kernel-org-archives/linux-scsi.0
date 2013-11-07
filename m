From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 03/11] hpsa: add 5 second delay after doorbell reset
Date: Thu, 07 Nov 2013 10:45:40 -0600
Message-ID: <20131107164540.3504.61950.stgit@beardog.cce.hp.com>
References: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:26967 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3KGQpk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2013 11:45:40 -0500
In-Reply-To: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

The hardware guys tell us that after initiating a software
reset via the doorbell register we need to wait 5 seconds before
attempting to talk to the board *at all*.  This means that we
cannot watch the board to verify it transitions from "ready" to
to "not ready" then back "ready", since this transition will
most likely happen during those 5 seconds (though we can still
verify the reset happens by watching the "driver version" field
get cleared.)

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   32 +++++++++++++++++++++++---------
 1 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 20fc598..fff5fd3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3781,6 +3781,13 @@ static int hpsa_controller_hard_reset(struct pci_dev *pdev,
 		 */
 		dev_info(&pdev->dev, "using doorbell to reset controller\n");
 		writel(use_doorbell, vaddr + SA5_DOORBELL);
+
+		/* PMC hardware guys tell us we need a 5 second delay after
+		 * doorbell reset and before any attempt to talk to the board
+		 * at all to ensure that this actually works and doesn't fall
+		 * over in some weird corner cases.
+		 */
+		msleep(5000);
 	} else { /* Try to do it the PCI power state way */
 
 		/* Quoting from the Open CISS Specification: "The Power
@@ -3977,15 +3984,22 @@ static int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	   need a little pause here */
 	msleep(HPSA_POST_RESET_PAUSE_MSECS);
 
-	/* Wait for board to become not ready, then ready. */
-	dev_info(&pdev->dev, "Waiting for board to reset.\n");
-	rc = hpsa_wait_for_board_state(pdev, vaddr, BOARD_NOT_READY);
-	if (rc) {
-		dev_warn(&pdev->dev,
-			"failed waiting for board to reset."
-			" Will try soft reset.\n");
-		rc = -ENOTSUPP; /* Not expected, but try soft reset later */
-		goto unmap_cfgtable;
+	if (!use_doorbell) {
+		/* Wait for board to become not ready, then ready.
+		 * (if we used the doorbell, then we already waited 5 secs
+		 * so the "not ready" state is already gone by so we
+		 * won't catch it.)
+		 */
+		dev_info(&pdev->dev, "Waiting for board to reset.\n");
+		rc = hpsa_wait_for_board_state(pdev, vaddr, BOARD_NOT_READY);
+		if (rc) {
+			dev_warn(&pdev->dev,
+				"failed waiting for board to reset."
+				" Will try soft reset.\n");
+			/* Not expected, but try soft reset later */
+			rc = -ENOTSUPP;
+			goto unmap_cfgtable;
+		}
 	}
 	rc = hpsa_wait_for_board_state(pdev, vaddr, BOARD_READY);
 	if (rc) {

