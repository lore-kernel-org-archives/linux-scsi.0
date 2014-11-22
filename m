From: "Subhash Jadavani" <subhashj@codeaurora.org>
Subject: RE: [PATCH 2/2] scsi: ufs: fix NULL dereference when no regulators are defined
Date: Fri, 21 Nov 2014 17:21:29 -0800
Message-ID: <000001d005f2$a4f616c0$eee24440$@codeaurora.org>
References: <1416319366-11539-1-git-send-email-akinobu.mita@gmail.com> <1416319366-11539-3-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:58291 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaKVBVb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Nov 2014 20:21:31 -0500
In-Reply-To: <1416319366-11539-3-git-send-email-akinobu.mita@gmail.com>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Akinobu Mita' <akinobu.mita@gmail.com>, linux-scsi@vger.kernel.org
Cc: 'Akinobu Mita' <mita@fixstars.com>, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Dolev Raviv' <draviv@codeaurora.org>, 'Sujit Reddy Thumma' <sthumma@codeaurora.org>, 'Yaniv Gardi' <ygardi@codeaurora.org>, 'Christoph Hellwig' <hch@lst.de>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-----Original Message-----
From: Akinobu Mita [mailto:akinobu.mita@gmail.com] 
Sent: Tuesday, November 18, 2014 6:03 AM
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita; Akinobu Mita; Vinayak Holikatti; Subhash Jadavani; Dolev
Raviv; Sujit Reddy Thumma; Yaniv Gardi; Christoph Hellwig; James E.J.
Bottomley
Subject: [PATCH 2/2] scsi: ufs: fix NULL dereference when no regulators are
defined

If no voltage supply regulators are defined for the UFS devices (assumed
they are always-on), ufshcd_config_vreg_load() can be called on
suspend/resume paths with vreg == NULL as hba->vreg_info.vcc* equal to NULL,
and it causes NULL pointer dereference.

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

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
59b6544..d18adc4 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4248,12 +4248,18 @@ static int ufshcd_config_vreg_load(struct device
*dev, struct ufs_vreg *vreg,  static inline int
ufshcd_config_vreg_lpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg)
 {
+	if (!vreg)
+		return 0;
+
 	return ufshcd_config_vreg_load(hba->dev, vreg,
UFS_VREG_LPM_LOAD_UA);  }
 
 static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg)
 {
+	if (!vreg)
+		return 0;
+
 	return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);  }
 
--
1.9.1


