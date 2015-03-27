From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/3] scsi: ufs: avoid using hostdata after scsi_host_put()
Date: Sat, 28 Mar 2015 08:51:45 +0900
Message-ID: <1427500307-5649-2-git-send-email-akinobu.mita@gmail.com>
References: <1427500307-5649-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35952 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbbC0XwJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2015 19:52:09 -0400
Received: by padcy3 with SMTP id cy3so109317614pad.3
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 16:52:09 -0700 (PDT)
In-Reply-To: <1427500307-5649-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Hannes Reinecke <hare@suse.de>, Sahitya Tummala <stummala@codeaurora.org>

The hostdata array, which is denoted by 'hba' in ufs driver, should
not be accessed after calling scsi_host_put().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sahitya Tummala <stummala@codeaurora.org>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5d60a86..4e4de32 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5239,12 +5239,12 @@ void ufshcd_remove(struct ufs_hba *hba)
 	ufshcd_disable_intr(hba, hba->intr_mask);
 	ufshcd_hba_stop(hba);
 
-	scsi_host_put(hba->host);
-
 	ufshcd_exit_clk_gating(hba);
 	if (ufshcd_is_clkscaling_enabled(hba))
 		devfreq_remove_device(hba->devfreq);
 	ufshcd_hba_exit(hba);
+
+	scsi_host_put(hba->host);
 }
 EXPORT_SYMBOL_GPL(ufshcd_remove);
 
@@ -5547,9 +5547,9 @@ exit_gating:
 	ufshcd_exit_clk_gating(hba);
 out_disable:
 	hba->is_irq_enabled = false;
-	scsi_host_put(host);
 	ufshcd_hba_exit(hba);
 out_error:
+	scsi_host_put(host);
 	return err;
 }
 EXPORT_SYMBOL_GPL(ufshcd_init);
-- 
1.9.1

