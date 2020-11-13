Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B09C388F9
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Nov 2020 06:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEC6E21D7F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Nov 2020 06:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgKMGaS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Nov 2020 01:30:18 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:10406 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbgKMGaR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Nov 2020 01:30:17 -0500
IronPort-SDR: 6TctTulGF1gL+sBpL0IlknZ99Yw6dxVKYMIJu3fy+ScxCLq5NbEFjoVaF10nfo1U+4tLTLBiwA
 zofBxl78sY+ML/jMcf26hQi+tytcX87UyA6Z4Nqz4Gh/KhPe21AYNjvxPnPRje/HE/vbOvZeZF
 MfXXrLyyNiDNeJUZryNf5qbhWn6w8bNBFbf1CKiE+xHb2fyqA5Rq20fbNBoVGw6/VsiMKORGrB
 1ciEvBo/ncQYojrCP/PompnbIIaTtIFieuF/Q4RX9oruKQMI7MravJAuXZskjI5/oo0xawuCH/
 +BM=
X-IronPort-AV: E=Sophos;i="5.77,474,1596524400"; 
   d="scan'208";a="29276423"
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by labrats.qualcomm.com with ESMTP; 12 Nov 2020 22:30:17 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg01-sd.qualcomm.com with ESMTP; 12 Nov 2020 22:30:15 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id E48A321787; Thu, 12 Nov 2020 22:30:15 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH RFC v1 1/1] scsi: pm: Leave runtime resume along if block layer PM is enabled
Date:   Thu, 12 Nov 2020 22:30:08 -0800
Message-Id: <1605249009-13752-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605249009-13752-1-git-send-email-cang@codeaurora.org>
References: <1605249009-13752-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If block layer runtime PM is enabled for one SCSI device, then there is
no need to forcibly change the SCSI device and its request queue's runtime
PM status to active in scsi_dev_type_resume(), since block layer PM shall
resume the SCSI device on the demand of bios.

Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/scsi_pm.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 3717eea..278c27e 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -79,23 +79,22 @@ static int scsi_dev_type_resume(struct device *dev,
 	scsi_device_resume(to_scsi_device(dev));
 	dev_dbg(dev, "scsi resume: %d\n", err);
 
-	if (err == 0) {
-		pm_runtime_disable(dev);
-		err = pm_runtime_set_active(dev);
-		pm_runtime_enable(dev);
+	if (scsi_is_sdev_device(dev)) {
+		struct scsi_device *sdev;
 
+		sdev = to_scsi_device(dev);
 		/*
-		 * Forcibly set runtime PM status of request queue to "active"
-		 * to make sure we can again get requests from the queue
-		 * (see also blk_pm_peek_request()).
-		 *
-		 * The resume hook will correct runtime PM status of the disk.
+		 * If block layer runtime PM is enabled for the SCSI device,
+		 * let block layer PM handle its runtime PM routines.
 		 */
-		if (!err && scsi_is_sdev_device(dev)) {
-			struct scsi_device *sdev = to_scsi_device(dev);
+		if (sdev->request_queue->dev)
+			return err;
+	}
 
-			blk_set_runtime_active(sdev->request_queue);
-		}
+	if (err == 0) {
+		pm_runtime_disable(dev);
+		err = pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
 	}
 
 	return err;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

