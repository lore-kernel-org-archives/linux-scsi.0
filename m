From: John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: libsas: fix ata xfer length
Date: Thu, 16 Mar 2017 23:07:28 +0800
Message-ID: <1489676848-103256-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

The total ata xfer length may not be calculated properly,
in that we do not use the proper method to get an sg element
dma length.

According to the code comment, sg_dma_len() should be used
after dma_map_sg() is called.

This issue was found by turning on the SMMUv3 in front of
the hisi_sas controller in hip07. Multiple sg elements
were being combined into a single element, but the original
first element length was being use as the total xfer length.

Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 763f012..87f5e694 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -221,7 +221,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 		task->num_scatter = qc->n_elem;
 	} else {
 		for_each_sg(qc->sg, sg, qc->n_elem, si)
-			xfer += sg->length;
+			xfer += sg_dma_len(sg);
 
 		task->total_xfer_len = xfer;
 		task->num_scatter = si;
-- 
1.9.1
