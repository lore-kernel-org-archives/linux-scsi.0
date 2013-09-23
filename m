From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 10/20] [SCSI] mvumi: remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 10:05:19 +0900
Message-ID: <000e01ceb7f8$f8b6b920$ea242b60$%han@samsung.com>
References: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:32306 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3IWBFU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Sep 2013 21:05:20 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MTK00FP30CU56B0@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 23 Sep 2013 10:05:19 +0900 (KST)
In-reply-to: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>, 'Myron Stowe' <myron.stowe@redhat.com>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/mvumi.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index d0b6a03..3206ba3 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2583,7 +2583,6 @@ static int mvumi_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 fail_io_attach:
-	pci_set_drvdata(pdev, NULL);
 	mhba->instancet->disable_intr(mhba);
 	free_irq(mhba->pdev->irq, mhba);
 fail_init_irq:
@@ -2618,7 +2617,6 @@ static void mvumi_detach_one(struct pci_dev *pdev)
 	free_irq(mhba->pdev->irq, mhba);
 	mvumi_release_fw(mhba);
 	scsi_host_put(host);
-	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 	dev_dbg(&pdev->dev, "driver is removed!\n");
 }
-- 
1.7.10.4


