From: chenxiang <chenxiang66@hisilicon.com>
Subject: [PATCH v2 2/4] scsi: isci: fix dma_unmap_sg() parameter
Date: Thu, 4 Jan 2018 10:36:43 +0800
Message-ID: <1515033405-37477-3-git-send-email-chenxiang66@hisilicon.com>
References: <1515033405-37477-1-git-send-email-chenxiang66@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:54791 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752043AbeADChg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Jan 2018 21:37:36 -0500
In-Reply-To: <1515033405-37477-1-git-send-email-chenxiang66@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: john.garry@huawei.com, linux-scsi@vger.kernel.org, linuxarm@huawei.com, bryantly@linux.vnet.ibm.com, mikecyr@linux.vnet.ibm.com, artur.paszkiewicz@intel.com, dan.j.williams@intel.com, yuxiangl@marvell.com, jgarzik@pobox.com, jack_wang@usish.com, lindar_liu@usish.com, chenxiang <chenxiang66@hisilicon.com>

For function dma_unmap_sg(), the <nents> parameter should be number of
elements in the scatterlist prior to the mapping, not after the mapping.
Fix this usage.

Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Fixes: d9dcb4ba7("isci: unify isci_host and scic_sds_controller")
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/isci/request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index ed197bc..225d947 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -2914,7 +2914,7 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
 					 task->total_xfer_len, task->data_dir);
 		else  /* unmap the sgl dma addresses */
 			dma_unmap_sg(&ihost->pdev->dev, task->scatter,
-				     request->num_sg_entries, task->data_dir);
+				     task->num_scatter, task->data_dir);
 		break;
 	case SAS_PROTOCOL_SMP: {
 		struct scatterlist *sg = &task->smp_task.smp_req;
-- 
1.9.1
