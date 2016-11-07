From: John Garry <john.garry@huawei.com>
Subject: [PATCH 06/11] hisi_sas: modify return value of hisi_sas_query_task()
Date: Mon, 7 Nov 2016 20:48:35 +0800
Message-ID: <1478522920-108145-7-git-send-email-john.garry@huawei.com>
References: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:25342 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbcKGMXs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2016 07:23:48 -0500
In-Reply-To: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, john.garry2@mail.dcu.ie, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>

From: Xiang Chen <chenxiang66@hisilicon.com>

sas_scsi_find_task() only deals with return value
TMF_RESP_FUNC_FAILED/TMF_RESP_FUNC_SUCC/TMF_RESP_FUNC_COMPLETE of
query task. So for LLDD errors just return TMF_RESP_FUNC_FAILED.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9133238..504cbcf 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -961,6 +961,9 @@ static int hisi_sas_query_task(struct sas_task *task)
 		case TMF_RESP_FUNC_FAILED:
 		case TMF_RESP_FUNC_COMPLETE:
 			break;
+		default:
+			rc = TMF_RESP_FUNC_FAILED;
+			break;
 		}
 	}
 	return rc;
-- 
1.9.1

