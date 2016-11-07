From: John Garry <john.garry@huawei.com>
Subject: [PATCH 07/11] hisi_sas: delete repeated configuration in free_device_v2_hw()
Date: Mon, 7 Nov 2016 20:48:36 +0800
Message-ID: <1478522920-108145-8-git-send-email-john.garry@huawei.com>
References: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:30295 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbcKGMdy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2016 07:33:54 -0500
In-Reply-To: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, john.garry2@mail.dcu.ie, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>

From: Xiang Chen <chenxiang66@hisilicon.com>

Delete repeated configuration items for hisi_sas_device() when
we free a device. These items are now only set in
hisi_sas_dev_gone().

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 7567193..3081eec 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -739,8 +739,6 @@ static void free_device_v2_hw(struct hisi_hba *hisi_hba,
 			qw0 &= ~(1 << ITCT_HDR_VALID_OFF);
 			hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
 					 ENT_INT_SRC3_ITC_INT_MSK);
-			hisi_hba->devices[dev_id].dev_type = SAS_PHY_UNUSED;
-			hisi_hba->devices[dev_id].dev_status = HISI_SAS_DEV_NORMAL;
 
 			/* clear the itct */
 			hisi_sas_write32(hisi_hba, ITCT_CLR, 0);
-- 
1.9.1

