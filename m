From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] scsi: csiostor: fail probe if fw does not support FCoE
Date: Mon, 31 Jul 2017 22:02:55 +0530
Message-ID: <1501518775-8889-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:7892 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752473AbdGaQdE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2017 12:33:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com, rajesh.kumar@chelsio.com

Fail probe if FCoE capability is not enabled in the
firmware.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/csiostor/csio_hw.c   |  4 +++-
 drivers/scsi/csiostor/csio_init.c | 12 ++++++++----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index 2029ad2..5be0086 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -3845,8 +3845,10 @@ csio_hw_start(struct csio_hw *hw)
 
 	if (csio_is_hw_ready(hw))
 		return 0;
-	else
+	else if (csio_match_state(hw, csio_hws_uninit))
 		return -EINVAL;
+	else
+		return -ENODEV;
 }
 
 int
diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index ea0c310..dcd0741 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -969,10 +969,14 @@ static int csio_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_drvdata(pdev, hw);
 
-	if (csio_hw_start(hw) != 0) {
-		dev_err(&pdev->dev,
-			"Failed to start FW, continuing in debug mode.\n");
-		return 0;
+	rv = csio_hw_start(hw);
+	if (rv) {
+		if (rv == -EINVAL) {
+			dev_err(&pdev->dev,
+				"Failed to start FW, continuing in debug mode.\n");
+			return 0;
+		}
+		goto err_lnode_exit;
 	}
 
 	sprintf(hw->fwrev_str, "%u.%u.%u.%u\n",
-- 
2.0.2
