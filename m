From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] scsi: ibmvscsis: Fix error return code in ibmvscsis_probe()
Date: Thu, 15 Sep 2016 03:25:23 +0000
Message-ID: <1473909923-30014-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34924 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758505AbcIOD02 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2016 23:26:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryant G . Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return error code -ENOMEM from the dma mapping error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 4dd8e5e..38b086e 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3449,6 +3449,7 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 	vscsi->map_ioba = dma_map_single(&vdev->dev, vscsi->map_buf, PAGE_SIZE,
 					 DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(&vdev->dev, vscsi->map_ioba)) {
+		rc = -ENOMEM;
 		dev_err(&vscsi->dev, "probe: error mapping command buffer\n");
 		goto free_buf;
 	}

