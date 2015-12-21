From: John Garry <john.garry@huawei.com>
Subject: [PATCH 3/3] hisi_sas: use u64 for qw0 in free_device_v1_hw()
Date: Mon, 21 Dec 2015 19:35:09 +0800
Message-ID: <1450697709-120516-4-git-send-email-john.garry@huawei.com>
References: <1450697709-120516-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:48346 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbbLULUj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2015 06:20:39 -0500
In-Reply-To: <1450697709-120516-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>

By reading in itct.qw0 into a 32b variable the top
32 bits were being lost.
In practice this was OK as they were zeroes.

Fixes: 27a3f229 ("hisi_sas: Add cq interrupt")

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 38ff575..057fdeb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -539,7 +539,8 @@ static void free_device_v1_hw(struct hisi_hba *hisi_hba,
 {
 	u64 dev_id = sas_dev->device_id;
 	struct hisi_sas_itct *itct = &hisi_hba->itct[dev_id];
-	u32 qw0, reg_val = hisi_sas_read32(hisi_hba, CFG_AGING_TIME);
+	u64 qw0;
+	u32 reg_val = hisi_sas_read32(hisi_hba, CFG_AGING_TIME);
 
 	reg_val |= CFG_AGING_TIME_ITCT_REL_MSK;
 	hisi_sas_write32(hisi_hba, CFG_AGING_TIME, reg_val);
-- 
1.9.1

