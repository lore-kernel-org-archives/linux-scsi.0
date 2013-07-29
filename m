From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 7/9] ufs: don't stop controller before scsi_remove_host()
Date: Tue, 30 Jul 2013 00:36:03 +0530
Message-ID: <1375124765-4110-8-git-send-email-santoshsy@gmail.com>
References: <1375124765-4110-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:40212 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3G2TIK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jul 2013 15:08:10 -0400
Received: by mail-pb0-f43.google.com with SMTP id md12so4992974pbc.2
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 12:08:09 -0700 (PDT)
In-Reply-To: <1375124765-4110-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Akinobu Mita <mita@fixstars.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Santosh Y <santoshsy@gmail.com>

From: Akinobu Mita <mita@fixstars.com>

scsi_remove_host() sends SYNCHRONIZE CACHE commands for write cache
enabled scsi disk devices.  So stopping controller working shouldn't
be done before scsi_remove_host().

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1f2caa0..b36ca9a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2603,11 +2603,11 @@ EXPORT_SYMBOL(ufshcd_runtime_idle);
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

