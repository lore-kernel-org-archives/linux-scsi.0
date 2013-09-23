From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 03/20] [SCSI] atp870u: remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 09:58:08 +0900
Message-ID: <000701ceb7f7$f7b4a7e0$e71df7a0$%han@samsung.com>
References: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:30435 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3IWA6J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Sep 2013 20:58:09 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MTK002ID00TKMA0@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 23 Sep 2013 09:58:08 +0900 (KST)
In-reply-to: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/atp870u.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 15a629d..a795d81 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -3144,8 +3144,6 @@ static void atp870u_remove (struct pci_dev *pdev)
 	atp870u_free_tables(pshost);
 	printk(KERN_INFO "scsi_host_put : %p\n",pshost);
 	scsi_host_put(pshost);
-	printk(KERN_INFO "pci_set_drvdata : %p\n",pdev);
-	pci_set_drvdata(pdev, NULL);	
 }
 MODULE_LICENSE("GPL");
 
-- 
1.7.10.4


