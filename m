From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] [SCSI] mac_esp: fix to pass correct device identity to free_irq()
Date: Tue, 25 Apr 2017 03:08:45 +0000
Message-ID: <20170425030845.7809-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35957 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S980188AbdDYDIu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 23:08:50 -0400
Received: by mail-pf0-f195.google.com with SMTP id v14so6262781pfd.3
        for <linux-scsi@vger.kernel.org>; Mon, 24 Apr 2017 20:08:50 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

free_irq() expects the same device identity that was passed to
corresponding request_irq(), otherwise the IRQ is not freed.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/scsi/mac_esp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index bb567d3..dda4da2 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -580,7 +580,7 @@ static int esp_mac_probe(struct platform_device *dev)
 
 fail_free_irq:
 	if (esp_chips[!dev->id] == NULL)
-		free_irq(host->irq, esp);
+		free_irq(host->irq, NULL);
 fail_free_priv:
 	kfree(mep);
 fail_free_command_block:
