From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] scsi: ufs: ensure clk gating work is finished before module unloading
Date: Mon, 24 Nov 2014 14:24:18 +0900
Message-ID: <1416806658-7349-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:40388 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaKXFZF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 00:25:05 -0500
Received: by mail-pa0-f53.google.com with SMTP id kq14so8829749pab.12
        for <linux-scsi@vger.kernel.org>; Sun, 23 Nov 2014 21:25:03 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Akinobu Mita <mita@fixstars.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Maya Erez <merez@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

When dynamic clk gating feature is enabled, delayed workqueue machanism
is used in order to detect certain period of inactivity.  But there is no
guarantee that scheduled gating work is completed before module unloading.
So it can cause kernel crash by accessing memory after it was freed.

Fix it by cancelling clk gating and ungating works and ensure that its
execution is finished before module unloading.

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
 drivers/scsi/ufs/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d18adc4..713420b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -744,6 +744,8 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 	if (!ufshcd_is_clkgating_allowed(hba))
 		return;
 	device_remove_file(hba->dev, &hba->clk_gating.delay_attr);
+	cancel_work_sync(&hba->clk_gating.ungate_work);
+	cancel_delayed_work_sync(&hba->clk_gating.gate_work);
 }
 
 /* Must be called with host lock acquired */
-- 
1.9.1

