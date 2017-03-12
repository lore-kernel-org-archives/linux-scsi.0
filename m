From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi] scsi: ufs: don't check unsigned type for a negative value
Date: Sun, 12 Mar 2017 12:22:02 +0200
Message-ID: <20170312102202.9889-1-tomas.winkler@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:38559 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755667AbdCLKXD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Mar 2017 06:23:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>

Fix compilation warning

drivers/scsi/ufs/ufshcd.c:7645:13: warning: comparison of unsigned
expression < 0 is always false [-Wtype-limits]
if ((value < UFS_PM_LVL_0) || (value >= UFS_PM_LVL_MAX))

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1359913bf840..e8c26e6e6237 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7642,7 +7642,7 @@ static inline ssize_t ufshcd_pm_lvl_store(struct device *dev,
 	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
-	if ((value < UFS_PM_LVL_0) || (value >= UFS_PM_LVL_MAX))
+	if (value >= UFS_PM_LVL_MAX)
 		return -EINVAL;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-- 
2.9.3
