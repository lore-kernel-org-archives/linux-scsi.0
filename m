From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/2] scsi: ufs: fix NULL dereference when no regulators are defined
Date: Tue, 18 Nov 2014 23:02:46 +0900
Message-ID: <1416319366-11539-3-git-send-email-akinobu.mita@gmail.com>
References: <1416319366-11539-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41044 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbaKRODR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Nov 2014 09:03:17 -0500
Received: by mail-pd0-f175.google.com with SMTP id y10so4636866pdj.6
        for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2014 06:03:16 -0800 (PST)
In-Reply-To: <1416319366-11539-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Akinobu Mita <mita@fixstars.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

If no voltage supply regulators are defined for the UFS devices (assumed
they are always-on), ufshcd_config_vreg_load() can be called on
suspend/resume paths with vreg == NULL as hba->vreg_info.vcc* equal to
NULL, and it causes NULL pointer dereference.

This fixes it by making ufshcd_config_vreg_{h,l}pm noop when no regulators
are defined.

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 59b6544..d18adc4 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4248,12 +4248,18 @@ static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
 static inline int ufshcd_config_vreg_lpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg)
 {
+	if (!vreg)
+		return 0;
+
 	return ufshcd_config_vreg_load(hba->dev, vreg, UFS_VREG_LPM_LOAD_UA);
 }
 
 static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg)
 {
+	if (!vreg)
+		return 0;
+
 	return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
 }
 
-- 
1.9.1

