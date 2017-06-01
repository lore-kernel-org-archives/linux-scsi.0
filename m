From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] scsi: csiostor: add check for supported fw version
Date: Thu,  1 Jun 2017 12:48:33 +0530
Message-ID: <1496301513-3544-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:28301 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751013AbdFAHS7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2017 03:18:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com, rajesh.kumar@chelsio.com

T6 FCoE support is added in fw version 1.16.45.0 so
return error if fw version < 1.16.45.0 for T6 adapters.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/csiostor/csio_hw.c | 19 +++++++++++++++++++
 drivers/scsi/csiostor/csio_hw.h |  1 +
 2 files changed, 20 insertions(+)

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index c6e1814..2029ad2 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -2068,6 +2068,17 @@ csio_hw_flash_fw(struct csio_hw *hw, int *reset)
 	return ret;
 }
 
+static int csio_hw_check_fwver(struct csio_hw *hw)
+{
+	if (csio_is_t6(hw->pdev->device & CSIO_HW_CHIP_MASK) &&
+	    (hw->fwrev < CSIO_MIN_T6_FW)) {
+		csio_hw_print_fw_version(hw, "T6 unsupported fw");
+		return -1;
+	}
+
+	return 0;
+}
+
 /*
  * csio_hw_configure - Configure HW
  * @hw - HW module
@@ -2135,6 +2146,10 @@ csio_hw_configure(struct csio_hw *hw)
 		if (rv != 0)
 			goto out;
 
+		rv = csio_hw_check_fwver(hw);
+		if (rv < 0)
+			goto out;
+
 		/* If the firmware doesn't support Configuration Files,
 		 * return an error.
 		 */
@@ -2162,6 +2177,10 @@ csio_hw_configure(struct csio_hw *hw)
 		}
 
 	} else {
+		rv = csio_hw_check_fwver(hw);
+		if (rv < 0)
+			goto out;
+
 		if (hw->fw_state == CSIO_DEV_STATE_INIT) {
 
 			hw->flags |= CSIO_HWF_USING_SOFT_PARAMS;
diff --git a/drivers/scsi/csiostor/csio_hw.h b/drivers/scsi/csiostor/csio_hw.h
index 62758e8..9acb895 100644
--- a/drivers/scsi/csiostor/csio_hw.h
+++ b/drivers/scsi/csiostor/csio_hw.h
@@ -71,6 +71,7 @@
 #define CSIO_MAX_CMD_PER_LUN	32
 #define CSIO_MAX_DDP_BUF_SIZE	(1024 * 1024)
 #define CSIO_MAX_SECTOR_SIZE	128
+#define CSIO_MIN_T6_FW		0x01102D00  /* FW 1.16.45.0 */
 
 /* Interrupts */
 #define CSIO_EXTRA_MSI_IQS	2	/* Extra iqs for INTX/MSI mode
-- 
2.0.2
