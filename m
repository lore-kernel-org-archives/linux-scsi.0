From: John Garry <john.garry@huawei.com>
Subject: [PATCH 2/3] hisi_sas: fix typo in setup_itct_v1_hw()
Date: Mon, 21 Dec 2015 19:35:08 +0800
Message-ID: <1450697709-120516-3-git-send-email-john.garry@huawei.com>
References: <1450697709-120516-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:48405 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbbLULUn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2015 06:20:43 -0500
In-Reply-To: <1450697709-120516-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>

We were doing a arithmetic comparison instead
of logical shift by accident.
Mis-programming the itct did not seem to make
a difference to operation.

Fixes: abda97c2fe874 ("hisi_sas: Add dev_found")

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 0af682c..38ff575 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -528,10 +528,10 @@ static void setup_itct_v1_hw(struct hisi_hba *hisi_hba,
 	itct->sas_addr = __swab64(itct->sas_addr);
 
 	/* qw2 */
-	itct->qw2 = cpu_to_le64((500 < ITCT_HDR_IT_NEXUS_LOSS_TL_OFF) |
-				(0xff00 < ITCT_HDR_BUS_INACTIVE_TL_OFF) |
-				(0xff00 < ITCT_HDR_MAX_CONN_TL_OFF) |
-				(0xff00 < ITCT_HDR_REJ_OPEN_TL_OFF));
+	itct->qw2 = cpu_to_le64((500ULL << ITCT_HDR_IT_NEXUS_LOSS_TL_OFF) |
+				(0xff00ULL << ITCT_HDR_BUS_INACTIVE_TL_OFF) |
+				(0xff00ULL << ITCT_HDR_MAX_CONN_TL_OFF) |
+				(0xff00ULL << ITCT_HDR_REJ_OPEN_TL_OFF));
 }
 
 static void free_device_v1_hw(struct hisi_hba *hisi_hba,
-- 
1.9.1

