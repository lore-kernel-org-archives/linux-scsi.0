From: chenxiang <chenxiang66@hisilicon.com>
Subject: [PATCH v2 3/4] scsi: mvsas: fix dma_unmap_sg() parameter
Date: Thu, 4 Jan 2018 10:36:44 +0800
Message-ID: <1515033405-37477-4-git-send-email-chenxiang66@hisilicon.com>
References: <1515033405-37477-1-git-send-email-chenxiang66@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:54755 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752004AbeADChg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Jan 2018 21:37:36 -0500
In-Reply-To: <1515033405-37477-1-git-send-email-chenxiang66@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: john.garry@huawei.com, linux-scsi@vger.kernel.org, linuxarm@huawei.com, bryantly@linux.vnet.ibm.com, mikecyr@linux.vnet.ibm.com, artur.paszkiewicz@intel.com, dan.j.williams@intel.com, yuxiangl@marvell.com, jgarzik@pobox.com, jack_wang@usish.com, lindar_liu@usish.com, chenxiang <chenxiang66@hisilicon.com>

For function dma_unmap_sg(), the <nents> parameter should be number of
elements in the scatterlist prior to the mapping, not after the mapping.
Fix this usage.

Cc: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Fixes: 0b15fb1fd("[SCSI]mvsas: add support for Task collector mode and fixed relative
bugs")
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/mvsas/mv_sas.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index cff43bd..4b2cf36 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -848,7 +848,7 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 	dev_printk(KERN_ERR, mvi->dev, "mvsas prep failed[%d]!\n", rc);
 	if (!sas_protocol_ata(task->task_proto))
 		if (n_elem)
-			dma_unmap_sg(mvi->dev, task->scatter, n_elem,
+			dma_unmap_sg(mvi->dev, task->scatter, task->num_scatter,
 				     task->data_dir);
 prep_out:
 	return rc;
@@ -899,7 +899,7 @@ static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *task,
 	if (!sas_protocol_ata(task->task_proto))
 		if (slot->n_elem)
 			dma_unmap_sg(mvi->dev, task->scatter,
-				     slot->n_elem, task->data_dir);
+				     task->num_scatter, task->data_dir);
 
 	switch (task->task_proto) {
 	case SAS_PROTOCOL_SMP:
-- 
1.9.1
