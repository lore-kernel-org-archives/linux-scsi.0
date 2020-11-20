Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B7BC5519F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 08:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33DDA22249
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 08:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgKTIh1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 03:37:27 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:10613 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgKTIh1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2020 03:37:27 -0500
IronPort-SDR: 35AcR+M7M+hd8eMihQgueRi4jX/bEC4baNV0C2/YDDjIwIpT8iImrAL71rDqQLMHIV9CAgmqVN
 Wcw6IeVn7GhBI402CzUv63Mcfd7rXwZdkBQE0yut24d9odSJIXepkMaMy5d8y2hOEmwovC1Y/K
 MLCPvNnCa/hyl6BCwfmdjYBqLyLjr4AX/AAZSi8t2w0WX0xyHNgeEdF/ymL9a58UXIApCLu6Lm
 +zhHSJhgMVtx0DCi7YxAxVOWu2x3LV59EMYhXEs2fGd8CEd64h2Sm0HOmaOhGE5FO+mUWLqY2/
 jP4=
X-IronPort-AV: E=Sophos;i="5.78,356,1599548400"; 
   d="scan'208";a="47489928"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 20 Nov 2020 00:37:27 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 20 Nov 2020 00:37:25 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 02FBD217B5; Fri, 20 Nov 2020 00:37:25 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH RFC v2 1/1] scsi: pm: Leave runtime PM status alone during system resume/thaw/restore
Date:   Fri, 20 Nov 2020 00:37:22 -0800
Message-Id: <1605861443-11459-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Runtime resume is handled by runtime PM framework, no need to forcibly
set runtime PM status to RPM_ACTIVE during system resume/thaw/restore.

Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Can Guo <cang@codeaurora.org>
---

Changes since v1:
- Incorporated Bart's comments

---
 drivers/scsi/scsi_pm.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 3717eea..908f27f 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -79,25 +79,6 @@ static int scsi_dev_type_resume(struct device *dev,
 	scsi_device_resume(to_scsi_device(dev));
 	dev_dbg(dev, "scsi resume: %d\n", err);
 
-	if (err == 0) {
-		pm_runtime_disable(dev);
-		err = pm_runtime_set_active(dev);
-		pm_runtime_enable(dev);
-
-		/*
-		 * Forcibly set runtime PM status of request queue to "active"
-		 * to make sure we can again get requests from the queue
-		 * (see also blk_pm_peek_request()).
-		 *
-		 * The resume hook will correct runtime PM status of the disk.
-		 */
-		if (!err && scsi_is_sdev_device(dev)) {
-			struct scsi_device *sdev = to_scsi_device(dev);
-
-			blk_set_runtime_active(sdev->request_queue);
-		}
-	}
-
 	return err;
 }
 
@@ -165,11 +146,8 @@ static int scsi_bus_resume_common(struct device *dev,
 		 */
 		if (strncmp(scsi_scan_type, "async", 5) != 0)
 			async_synchronize_full_domain(&scsi_sd_pm_domain);
-	} else {
-		pm_runtime_disable(dev);
-		pm_runtime_set_active(dev);
-		pm_runtime_enable(dev);
 	}
+
 	return 0;
 }
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

