From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] mac_esp: fix to pass correct device identity to free_irq()
Date: Wed, 26 Apr 2017 15:43:59 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1704261540340.26898@nippy.intranet>
References: <20170425030845.7809-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33328 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035661AbdDZFnr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2017 01:43:47 -0400
In-Reply-To: <20170425030845.7809-1-weiyj.lk@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

free_irq() expects the same device identity that was passed to
corresponding request_irq(), otherwise the IRQ is not freed.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---

Rebased on jejb-scsi/misc.

diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 26c67c4..999699d 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -587,7 +587,7 @@ static int esp_mac_probe(struct platform_device *dev)
 	esp_chips[dev->id] = NULL;
 	if (esp_chips[!dev->id] == NULL) {
 		spin_unlock(&esp_chips_lock);
-		free_irq(host->irq, esp);
+		free_irq(host->irq, NULL);
 	} else
 		spin_unlock(&esp_chips_lock);
 fail_free_priv:
