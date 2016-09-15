From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Subject: [PATCH] [SCSI] wd719x: Avoid calling request_firmware under spinlock
Date: Thu, 15 Sep 2016 19:18:31 +0530
Message-ID: <1473947311-9573-1-git-send-email-vaishali.thakkar@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17084 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757592AbcIONth (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2016 09:49:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Vaishali Thakkar <vaishali.thakkar@oracle.com>

It is preferrable to use request_firmware where sleeping is
allowed. Using it under spinlock can cause blocking. Here,
the function wd719x_chip_init calls request_firmware while
holding a spinlock. So, let's access it outside the spinlock.

Coccinelle is used to detect the issue.

Signed-off-by: Vaishali Thakkar <vaishali.thakkar@oracle.com>
---
Please note that the patch is compile-tested only. And this change
may require driver testing.
---
 drivers/scsi/wd719x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index e3da1a2..b8e57f3 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -518,13 +518,14 @@ static int wd719x_host_reset(struct scsi_cmnd *cmd)
 	int result;
 
 	dev_info(&wd->pdev->dev, "host reset requested\n");
-	spin_lock_irqsave(wd->sh->host_lock, flags);
+
 	/* Try to reinit the RISC */
 	if (wd719x_chip_init(wd) == 0)
 		result = SUCCESS;
 	else
 		result = FAILED;
 
+	spin_lock_irqsave(wd->sh->host_lock, flags);
 	/* flush all SCBs */
 	list_for_each_entry_safe(scb, tmp, &wd->active_scbs, list) {
 		struct scsi_cmnd *tmp_cmd = scb->cmd;
-- 
2.1.4

