From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 1/6] scsi: ufs: avoid using hostdata after scsi_host_put()
Date: Sun,  2 Aug 2015 02:19:15 +0900
Message-ID: <1438449560-4106-2-git-send-email-akinobu.mita@gmail.com>
References: <1438449560-4106-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33024 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbbHARTm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Aug 2015 13:19:42 -0400
Received: by padck2 with SMTP id ck2so59211755pad.0
        for <linux-scsi@vger.kernel.org>; Sat, 01 Aug 2015 10:19:42 -0700 (PDT)
In-Reply-To: <1438449560-4106-1-git-send-email-akinobu.mita@gmail.com>
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
index b0ade73..e25f919 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5363,12 +5363,12 @@ void ufshcd_remove(struct ufs_hba *hba)
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
 
@@ -5671,9 +5671,9 @@ exit_gating:
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

