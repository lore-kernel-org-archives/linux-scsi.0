From: Colin King <colin.king@canonical.com>
Subject: [PATCH][scsi-next] scsi: myrb: remove shadowed and unassigned variable ldev_num
Date: Wed, 14 Feb 2018 16:23:41 +0000
Message-ID: <20180214162341.335-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41907 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032204AbeBNQXo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Feb 2018 11:23:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A lower-scoped variable ldev_num is never assigned and is shadowing
the higher scoped iterator ldev_num and should be removed to avoid
using garbage ldev_num values.

Detected by CoverityScan, CID#1465226 ("Uninitialized scalar variable")

Fixes: dd47c1072226 ("scsi: myrb: Add Mylex RAID controller (block interface)")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/myrb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 973a2250208f..65ade4d37b33 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -422,7 +422,6 @@ static unsigned short myrb_get_ldev_info(myrb_hba *cb)
 		myrb_ldev_info *old = NULL;
 		myrb_ldev_info *new = cb->ldev_info_buf[ldev_num];
 		struct scsi_device *sdev;
-		unsigned short ldev_num;
 		myrb_devstate old_state = DAC960_V1_Device_Offline;
 
 		sdev = scsi_device_lookup(shost, myrb_logical_channel(shost),
-- 
2.15.1
