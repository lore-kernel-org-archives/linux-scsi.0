From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 04/20] [SCSI] bfa: remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 09:59:09 +0900
Message-ID: <000801ceb7f8$1c3c0130$54b40390$%han@samsung.com>
References: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:62501 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3IWA7K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Sep 2013 20:59:10 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MTK00HRD01ZCZC0@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 23 Sep 2013 09:59:09 +0900 (KST)
In-reply-to: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>, 'Anil Gurumurthy' <agurumur@brocade.com>, 'Vijaya Mohan Guvva' <vmohan@brocade.com>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/bfa/bfad.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index f8ca7be..2e6e3ac 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -833,7 +833,6 @@ bfad_pci_uninit(struct pci_dev *pdev, struct bfad_s *bfad)
 	/* Disable PCIE Advanced Error Recovery (AER) */
 	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 }
 
 bfa_status_t
-- 
1.7.10.4


