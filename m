From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 3/3] [SCSI] be2iscsi: Remove casting the return value which is
 a void pointer
Date: Mon, 09 Sep 2013 14:48:02 +0900
Message-ID: <005b01cead20$25db97b0$7192c710$%han@samsung.com>
References: <005901cead1f$ab029e30$0107da90$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:45283 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab3IIFsE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Sep 2013 01:48:04 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSU0019LG3U4BN0@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 09 Sep 2013 14:48:02 +0900 (KST)
In-reply-to: <005901cead1f$ab029e30$0107da90$%han@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'James Bottomley' <jejb@kernel.org>, 'Jayamohan Kallickal' <jayamohan.kallickal@emulex.com>, 'Jingoo Han' <jg1.han@samsung.com>

Casting the return value which is a void pointer is redundant.
The conversion from void pointer to any other pointer type is
guaranteed by the C programming language.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index a1f5ac7..c6cdd7d 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4836,7 +4836,7 @@ static void beiscsi_shutdown(struct pci_dev *pcidev)
 
 	struct beiscsi_hba *phba = NULL;
 
-	phba = (struct beiscsi_hba *)pci_get_drvdata(pcidev);
+	phba = pci_get_drvdata(pcidev);
 	if (!phba) {
 		dev_err(&pcidev->dev, "beiscsi_shutdown called with no phba\n");
 		return;
-- 
1.7.10.4


