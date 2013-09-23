From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 15/20] [SCSI] qla4xxx: remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 10:11:08 +0900
Message-ID: <001301ceb7f9$c8f14d80$5ad3e880$%han@samsung.com>
References: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:43600 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab3IWBLJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Sep 2013 21:11:09 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MTK003XP0MKHBE0@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 23 Sep 2013 10:11:08 +0900 (KST)
In-reply-to: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>, 'Vikas Chaudhary' <vikas.chaudhary@qlogic.com>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f8a0a26..1be6cef 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -7400,7 +7400,6 @@ static void qla4xxx_remove_adapter(struct pci_dev *pdev)
 
 	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 }
 
 /**
-- 
1.7.10.4


