From: Akinobu Mita <mita@fixstars.com>
Subject: [PATCH v2 3/3] ufs: don't stop controller before scsi_remove_host()
Date: Sat, 20 Jul 2013 09:41:25 +0900
Message-ID: <1374280885-11526-4-git-send-email-mita@fixstars.com>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo.fixstars.hdemail.jp ([176.34.54.138]:45364 "EHLO
	mo.fixstars.hdemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab3GTAqG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jul 2013 20:46:06 -0400
In-Reply-To: <1374280885-11526-1-git-send-email-mita@fixstars.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <mita@fixstars.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

scsi_remove_host() sends SYNCHRONIZE CACHE commands for write cache
enabled scsi disk devices.  So stopping controller working shouldn't
be done before scsi_remove_host().

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b743bd6..bd4d418 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1657,11 +1657,11 @@ EXPORT_SYMBOL_GPL(ufshcd_resume);
  */
 void ufshcd_remove(struct ufs_hba *hba)
 {
+	scsi_remove_host(hba->host);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
 	ufshcd_hba_stop(hba);
 
-	scsi_remove_host(hba->host);
 	scsi_host_put(hba->host);
 }
 EXPORT_SYMBOL_GPL(ufshcd_remove);
-- 
1.8.3.1

