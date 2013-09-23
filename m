From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 08/20] [SCSI] hpsa: remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 10:03:18 +0900
Message-ID: <000c01ceb7f8$b0dd5230$1297f690$%han@samsung.com>
References: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:42061 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3IWBDU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Sep 2013 21:03:20 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MTK00ABR09JGC00@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 23 Sep 2013 10:03:19 +0900 (KST)
In-reply-to: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>, "'Stephen M. Cameron'" <scameron@beardog.cce.hp.com>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/hpsa.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 891c86b..df72d4a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5018,7 +5018,6 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	kfree(h->hba_inquiry_data);
 	pci_disable_device(pdev);
 	pci_release_regions(pdev);
-	pci_set_drvdata(pdev, NULL);
 	kfree(h);
 }
 
-- 
1.7.10.4


