From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 18/20] [SCSI] vmw_pvscsi: remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 10:13:41 +0900
Message-ID: <001601ceb7fa$24144be0$6c3ce3a0$%han@samsung.com>
References: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:8947 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab3IWBNm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Sep 2013 21:13:42 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MTK00H3H0QSCZE0@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 23 Sep 2013 10:13:42 +0900 (KST)
In-reply-to: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>, 'Arvind Kumar' <arvindkumar@vmware.com>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/vmw_pvscsi.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 3bfaa66..b9755ec 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1405,7 +1405,6 @@ out_release_resources:
 out_free_host:
 	scsi_host_put(host);
 out_disable_device:
-	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 
 	return error;
@@ -1445,7 +1444,6 @@ static void pvscsi_remove(struct pci_dev *pdev)
 
 	scsi_host_put(host);
 
-	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 }
 
-- 
1.7.10.4


