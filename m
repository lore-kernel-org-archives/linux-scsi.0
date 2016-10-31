From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] mvsas: fix error return code in mvs_task_prep()
Date: Mon, 31 Oct 2016 15:04:10 +0000
Message-ID: <1477926250-10292-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35924 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943793AbcJaPEe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2016 11:04:34 -0400
Received: by mail-pf0-f193.google.com with SMTP id n85so8965095pfi.3
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2016 08:04:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Wilfried Weissmann <Wilfried.Weissmann@gmx.at>, Luis de Bethencourt <luisbg@osg.samsung.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>, Baoyou Xie <baoyou.xie@linaro.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/scsi/mvsas/mv_sas.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 86eb199..c7cc803 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -791,8 +791,10 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 	slot->slot_tag = tag;
 
 	slot->buf = pci_pool_alloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
-	if (!slot->buf)
+	if (!slot->buf) {
+		rc = -ENOMEM;
 		goto err_out_tag;
+	}
 	memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
 
 	tei.task = task;

