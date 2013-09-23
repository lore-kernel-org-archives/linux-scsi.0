From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 13/20] [SCSI] pmcraid: remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 10:09:38 +0900
Message-ID: <001101ceb7f9$93012ab0$b9038010$%han@samsung.com>
References: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:43317 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab3IWBJj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Sep 2013 21:09:39 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MTK0069M0JVHR40@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 23 Sep 2013 10:09:38 +0900 (KST)
In-reply-to: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>, 'Anil Ravindranath' <anil_ravindranath@pmc-sierra.com>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/pmcraid.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 1eb7b028..e43db77 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -6049,7 +6049,6 @@ out_release_regions:
 
 out_disable_device:
 	atomic_dec(&pmcraid_adapter_count);
-	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 	return -ENODEV;
 }
-- 
1.7.10.4


