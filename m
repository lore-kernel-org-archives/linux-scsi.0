From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 05/20] [SCSI] csiostor: remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 10:00:34 +0900
Message-ID: <000901ceb7f8$4f1c7300$ed555900$%han@samsung.com>
References: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:31045 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab3IWBAl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Sep 2013 21:00:41 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MTK00FDA04F56B0@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 23 Sep 2013 10:00:35 +0900 (KST)
In-reply-to: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>, 'Naresh Kumar Inna' <naresh@chelsio.com>, 'Arvind Bhushan' <arvindb@chelsio.com>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/csiostor/csio_init.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 00346fe..1aafc33 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -1010,7 +1010,6 @@ err_lnode_exit:
 	csio_hw_stop(hw);
 	spin_unlock_irq(&hw->lock);
 	csio_lnodes_unblock_request(hw);
-	pci_set_drvdata(hw->pdev, NULL);
 	csio_lnodes_exit(hw, 0);
 	csio_hw_free(hw);
 err_pci_exit:
@@ -1044,7 +1043,6 @@ static void csio_remove_one(struct pci_dev *pdev)
 
 	csio_lnodes_exit(hw, 0);
 	csio_hw_free(hw);
-	pci_set_drvdata(pdev, NULL);
 	csio_pci_exit(pdev, &bars);
 }
 
-- 
1.7.10.4


