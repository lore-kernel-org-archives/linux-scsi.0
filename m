From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 16/20] [SCSI] stex: remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 10:12:06 +0900
Message-ID: <001401ceb7f9$eba9b330$c2fd1990$%han@samsung.com>
References: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:43810 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3IWBMI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Sep 2013 21:12:08 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MTK006CO0MLHR40@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 23 Sep 2013 10:12:07 +0900 (KST)
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
 drivers/scsi/stex.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 325c31c..1aa4bef 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1790,8 +1790,6 @@ static void stex_remove(struct pci_dev *pdev)
 
 	scsi_remove_host(hba->host);
 
-	pci_set_drvdata(pdev, NULL);
-
 	stex_hba_stop(hba);
 
 	stex_hba_free(hba);
-- 
1.7.10.4


