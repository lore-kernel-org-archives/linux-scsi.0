From: John Garry <john.garry@huawei.com>
Subject: [PATCH] hisi_sas: fix v1 hw check for slot error
Date: Wed, 27 Jan 2016 01:31:17 +0800
Message-ID: <1453829477-40725-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:62596 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966846AbcAZRVJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2016 12:21:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ricardo.salveti@linaro.org, John Garry <john.garry@huawei.com>

Completion header bit CMPLT_HDR_RSPNS_XFRD flags
whether the response frame is received into host memory,
and not whether the response frame has an error.
As such, change the decision on whether a slot has
an error.
Also redundant check on CMPLT_HDR_CMD_CMPLT_MSK is
removed.

Fixes: 27a3f229 ("hisi_sas: Add cq interrupt handler")

Signed-off-by: John Garry <john.garry@huawei.com>
Tested-by: Ricardo Salveti <ricardo.salveti@linaro.org>

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 057fdeb..eea24d7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1289,13 +1289,10 @@ static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 		goto out;
 	}
 
-	if (cmplt_hdr_data & CMPLT_HDR_ERR_RCRD_XFRD_MSK) {
-		if (!(cmplt_hdr_data & CMPLT_HDR_CMD_CMPLT_MSK) ||
-		    !(cmplt_hdr_data & CMPLT_HDR_RSPNS_XFRD_MSK))
-			ts->stat = SAS_DATA_OVERRUN;
-		else
-			slot_err_v1_hw(hisi_hba, task, slot);
+	if (cmplt_hdr_data & CMPLT_HDR_ERR_RCRD_XFRD_MSK &&
+		!(cmplt_hdr_data & CMPLT_HDR_RSPNS_XFRD_MSK)) {
 
+		slot_err_v1_hw(hisi_hba, task, slot);
 		goto out;
 	}
 
-- 
1.9.1

