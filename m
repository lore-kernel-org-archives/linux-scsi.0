From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: Unregister integrity profile
Date: Tue, 14 Apr 2015 16:56:23 -0400
Message-ID: <1429044983-3584-1-git-send-email-martin.petersen@oracle.com>
References: <552D45B5.1040801@dev.mellanox.co.il>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49906 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbbDNU4g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2015 16:56:36 -0400
In-Reply-To: <552D45B5.1040801@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org.#.v3.17+

The new integrity code did not correctly unregister the profile for SD
disks. Call blk_integrity_unregister() when we release a disk.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reported-by: Sagi Grimberg <sagig@dev.mellanox.co.il>
CC: stable@vger.kernel.org # v3.17+
---
 drivers/scsi/sd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6b78476d04bb..3290a3ed5b31 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3100,6 +3100,7 @@ static void scsi_disk_release(struct device *dev)
 	ida_remove(&sd_index_ida, sdkp->index);
 	spin_unlock(&sd_index_lock);
 
+	blk_integrity_unregister(disk);
 	disk->private_data = NULL;
 	put_disk(disk);
 	put_device(&sdkp->device->sdev_gendev);
-- 
1.9.3

