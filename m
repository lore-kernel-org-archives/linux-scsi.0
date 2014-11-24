From: "Subhash Jadavani" <subhashj@codeaurora.org>
Subject: RE: [PATCH] scsi: ufs: ensure clk gating work is finished before module unloading
Date: Mon, 24 Nov 2014 12:31:05 -0800
Message-ID: <001201d00825$92ee3040$b8ca90c0$@codeaurora.org>
References: <1416806658-7349-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:44135 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaKXUbH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 15:31:07 -0500
In-Reply-To: <1416806658-7349-1-git-send-email-akinobu.mita@gmail.com>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Akinobu Mita' <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org
Cc: 'Akinobu Mita' <mita@fixstars.com>, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Dolev Raviv' <draviv@codeaurora.org>, 'Yaniv Gardi' <ygardi@codeaurora.org>, 'Sujit Reddy Thumma' <sthumma@codeaurora.org>, 'Maya Erez' <merez@codeaurora.org>, 'Sahitya Tummala' <stummala@codeaurora.org>, 'Christoph Hellwig' <hch@lst.de>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Akinobu Mita
Sent: Sunday, November 23, 2014 9:24 PM
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita; Akinobu Mita; Vinayak Holikatti; Dolev Raviv; Subhash
Jadavani; Yaniv Gardi; Sujit Reddy Thumma; Maya Erez; Sahitya Tummala;
Christoph Hellwig; James E.J. Bottomley
Subject: [PATCH] scsi: ufs: ensure clk gating work is finished before module
unloading

When dynamic clk gating feature is enabled, delayed workqueue machanism is
used in order to detect certain period of inactivity.  But there is no
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

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
d18adc4..713420b 100644
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

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

