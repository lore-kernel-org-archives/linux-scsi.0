Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C0E1757D
	for <linux-scsi@vger.kernel.org>; Tue,  2 Apr 2024 03:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712030384; cv=none; b=ISe6D+yyKsWI6an/oLLn2ypxG9wO69IuQ0R5aRJ2yVplmbm4MlwmFtnDZ2xwB0PCHrxQJOErpGoDtb7HAcBTDyRHOnco9XCsXCYFVGkgRA5mA445yWpdXjbKEaHjCenyjCD7HKKzrP3OR5dlpX+P69CsEFGgpZ4d3Dye15uOCJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712030384; c=relaxed/simple;
	bh=AxW2vImOCAh2HYWzIG6JCt23QG0rOfQjr//ZYZDC7dM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SOVEZxulkM0hDanaSsuKZ8cX+ZadudN6Hr7VkshBpQZGf1x5g28vS3X33EDgDvH6D30mSDpI2FQSjpYulWrgDy7QAYBGu+1V4cJkI1QfxAOAmtrRWVWlrykUgfQT/ZrwaI+fCbcmsZM4eYzvZSpGYq8kK2kpmZuUSgsbviGtA84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4V7vFx4K5Jz1R9nw;
	Tue,  2 Apr 2024 11:56:53 +0800 (CST)
Received: from kwepemd200015.china.huawei.com (unknown [7.221.188.21])
	by mail.maildlp.com (Postfix) with ESMTPS id 83AF41A0172;
	Tue,  2 Apr 2024 11:59:38 +0800 (CST)
Received: from huawei.com (10.67.165.2) by kwepemd200015.china.huawei.com
 (7.221.188.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.28; Tue, 2 Apr
 2024 11:59:38 +0800
From: chenxiang <chenxiang66@hisilicon.com>
To: <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC: <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 1/2] scsi: hisi_sas: Handle the NCQ error returned by D2H frame
Date: Tue, 2 Apr 2024 11:55:12 +0800
Message-ID: <20240402035513.2024241-2-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20240402035513.2024241-1-chenxiang66@hisilicon.com>
References: <20240402035513.2024241-1-chenxiang66@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemd200015.china.huawei.com (7.221.188.21)

From: Xiang Chen <chenxiang66@hisilicon.com>

We find that some disks use D2H frame instead of SDB frame to return NCQ
error. Currently, only the I/O corresponding to the D2H frame is processed
in this scenario, which does not meet the processing requirements of the
NCQ error scenario.
So we set dev_status to HISI_SAS_DEV_NCQ_ERR and abort all I/Os of the disk
in this scenario.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 7d2a33514538..34f96cc35342 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2244,7 +2244,15 @@ slot_err_v3_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
 	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
 		if ((dw0 & CMPLT_HDR_RSPNS_XFRD_MSK) &&
 		    (sipc_rx_err_type & RX_FIS_STATUS_ERR_MSK)) {
-			ts->stat = SAS_PROTO_RESPONSE;
+			if (task->ata_task.use_ncq) {
+				struct domain_device *device = task->dev;
+				struct hisi_sas_device *sas_dev = device->lldd_dev;
+
+				sas_dev->dev_status = HISI_SAS_DEV_NCQ_ERR;
+				slot->abort = 1;
+			} else {
+				ts->stat = SAS_PROTO_RESPONSE;
+			}
 		} else if (dma_rx_err_type & RX_DATA_LEN_UNDERFLOW_MSK) {
 			ts->residual = trans_tx_fail_type;
 			ts->stat = SAS_DATA_UNDERRUN;
-- 
2.30.0

