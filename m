From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 1/1] scsi: ufs-qcom: remove redundant condition check
Date: Fri, 17 Feb 2017 13:53:41 -0800
Message-ID: <1487368421-22903-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57952 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934994AbdBQVzy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Feb 2017 16:55:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> reported this:
---
The patch 9c46b8676271: "scsi: ufs-qcom: dump additional testbus
registers" from Feb 3, 2017, leads to the following static checker
warning:

    drivers/scsi/ufs/ufs-qcom.c:1531 ufs_qcom_testbus_cfg_is_ok()
    warn: impossible condition
		'(host->testbus.select_minor > 255) => (0-255 > 255)'

drivers/scsi/ufs/ufs-qcom.c
  1517  static bool ufs_qcom_testbus_cfg_is_ok(struct ufs_qcom_host *host)
  1518  {
  1519          if (host->testbus.select_major >= TSTBUS_MAX) {
  1520               dev_err(host->hba->dev,
  1521                 "%s: UFS_CFG1[TEST_BUS_SEL} may not equal 0x%05X\n",
  1522                  __func__, host->testbus.select_major);
  1523                  return false;
  1524          }
  1525
  1526          /*
  1527           * Not performing check for each individual select_major
  1528           * mappings of select_minor, since there is no harm in
  1529           * configuring a non-existent select_minor
  1530           */
  1531          if (host->testbus.select_minor > 0xFF) {
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It might make sense to keep this check.  I don't know.  But it's
confusing that 0xFF is a magic number.  Better to make it a define.

  1532                  dev_err(host->hba->dev,
  1533                       "%s: 0x%05X is not a legal testbus option\n",
  1534                        __func__, host->testbus.select_minor);
  1535                  return false;
  1536          }
  1537
  1538          return true;
  1539  }
---

As data type of "select_minor" is u8, above check is redundant. This change
removes it.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index ce5d023..c87d770 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1523,18 +1523,6 @@ static bool ufs_qcom_testbus_cfg_is_ok(struct ufs_qcom_host *host)
 		return false;
 	}
 
-	/*
-	 * Not performing check for each individual select_major
-	 * mappings of select_minor, since there is no harm in
-	 * configuring a non-existent select_minor
-	 */
-	if (host->testbus.select_minor > 0xFF) {
-		dev_err(host->hba->dev,
-			"%s: 0x%05X is not a legal testbus option\n",
-			__func__, host->testbus.select_minor);
-		return false;
-	}
-
 	return true;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
