From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: aacraid: rcode is unsigned, so can never be less than zero
Date: Tue,  7 Feb 2017 11:27:38 +0000
Message-ID: <20170207112738.18486-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46228 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751532AbdBGL3O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2017 06:29:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The check on rcode >= 0 is always true because rcode is unsigned
and can never be less than zero.  Remove the redundant check.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/aacraid/aachba.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 3b5ddf4..ddfd726 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1848,7 +1848,7 @@ int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr, int rescan)
 			FsaNormal, 1, 1, NULL, NULL);
 
 	/* analyse data */
-	if (rcode >= 0 && phys_luns->resp_flag == 2) {
+	if (phys_luns->resp_flag == 2) {
 		/* ok and extended reporting */
 		aac_update_hba_map(dev, phys_luns, rescan);
 	}
-- 
2.10.2
