From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 07/20] [SCSI] gdth: remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 10:02:38 +0900
Message-ID: <000b01ceb7f8$98b7ae30$ca270a90$%han@samsung.com>
References: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:25037 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3IWBCj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Sep 2013 21:02:39 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MTK003QO07T3C70@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 23 Sep 2013 10:02:38 +0900 (KST)
In-reply-to: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>, 'Achim Leubner' <achim_leubner@adaptec.com>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/gdth.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 6d55b4e..ee4fa40 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -594,8 +594,6 @@ static void gdth_pci_remove_one(struct pci_dev *pdev)
 {
 	gdth_ha_str *ha = pci_get_drvdata(pdev);
 
-	pci_set_drvdata(pdev, NULL);
-
 	list_del(&ha->list);
 	gdth_remove_one(ha);
 
-- 
1.7.10.4


