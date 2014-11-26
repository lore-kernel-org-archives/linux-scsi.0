From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH -next] scsi: ufs: don't kfree() devm_kzalloc()'ed memory
Date: Thu, 27 Nov 2014 00:37:37 +0900
Message-ID: <1417016257-9693-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:51510 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbaKZPiH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Nov 2014 10:38:07 -0500
Received: by mail-pd0-f179.google.com with SMTP id w10so2987175pde.24
        for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2014 07:38:06 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Akinobu Mita <mita@fixstars.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Maya Erez <merez@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

In ufshcd_parse_clock_info(), temporary memory allocated by
devm_kzalloc() is released by kfree().  The devres mechanism cannot
track the release and it causes trouble when removing the driver.

Fix it by allocating it with plain kcalloc() instead of devm_kzalloc()
as the temporary memory is always freed in that function.

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>
Cc: Sahitya Tummala <stummala@codeaurora.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 0c030ad..67b1f6c 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -99,8 +99,7 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 		goto out;
 	}
 
-	clkfreq = devm_kzalloc(dev, sz * sizeof(*clkfreq),
-			GFP_KERNEL);
+	clkfreq = kcalloc(sz, sizeof(*clkfreq), GFP_KERNEL);
 	if (!clkfreq) {
 		ret = -ENOMEM;
 		goto out;
-- 
1.9.1

