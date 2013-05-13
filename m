From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] [SCSI] mvsas: fix error return code in mvs_task_prep()
Date: Mon, 13 May 2013 14:53:48 +0800
Message-ID: <CAPgLHd90hmH+WozPSftAU9OKOkG_-hSL0sAdJM8s8B6_3gtPFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:52643 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3EMGyK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 May 2013 02:54:10 -0400
Received: by mail-bk0-f54.google.com with SMTP id it16so34402bkc.13
        for <linux-scsi@vger.kernel.org>; Sun, 12 May 2013 23:53:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, dan.j.williams@intel.com, majianpeng@gmail.com, gregkh@linuxfoundation.org, dan.carpenter@oracle.com
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the pci_pool_alloc() error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/scsi/mvsas/mv_sas.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index c9e2449..801cd35 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -790,8 +790,10 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 	slot->slot_tag = tag;
 
 	slot->buf = pci_pool_alloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_dma);
-	if (!slot->buf)
+	if (!slot->buf) {
+		rc = -ENOMEM;
 		goto err_out_tag;
+	}
 	memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
 
 	tei.task = task;

