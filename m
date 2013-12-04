From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 8/9] hpsa: do not require board "not ready" status after hard
	reset
Date: Wed, 04 Dec 2013 17:10:31 -0600
Message-ID: <20131204231031.21798.9717.stgit@beardog.cce.hp.com>
References: <20131204230123.21798.93593.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:48831 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3LDXKc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2013 18:10:32 -0500
In-Reply-To: <20131204230123.21798.93593.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Immediately following a hard board reset, There are some
mandatory delays during which we must not access the board
and during which we might miss the "not ready" status,
therefore it is a mistake to look for and expect to see
the "not ready" status.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 162405e..693c801 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4047,23 +4047,6 @@ static int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	   need a little pause here */
 	msleep(HPSA_POST_RESET_PAUSE_MSECS);
 
-	if (!use_doorbell) {
-		/* Wait for board to become not ready, then ready.
-		 * (if we used the doorbell, then we already waited 5 secs
-		 * so the "not ready" state is already gone by so we
-		 * won't catch it.)
-		 */
-		dev_info(&pdev->dev, "Waiting for board to reset.\n");
-		rc = hpsa_wait_for_board_state(pdev, vaddr, BOARD_NOT_READY);
-		if (rc) {
-			dev_warn(&pdev->dev,
-				"failed waiting for board to reset."
-				" Will try soft reset.\n");
-			/* Not expected, but try soft reset later */
-			rc = -ENOTSUPP;
-			goto unmap_cfgtable;
-		}
-	}
 	rc = hpsa_wait_for_board_state(pdev, vaddr, BOARD_READY);
 	if (rc) {
 		dev_warn(&pdev->dev,

