Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE18C2BBFD
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 04:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75701206E9
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 04:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405349AbgDNEcg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 00:32:36 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:28669 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405346AbgDNEcg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2020 00:32:36 -0400
IronPort-SDR: AqygS4iz8rqHb3ccwLOSOzGmPELU/rLathjOqjghR+RBFjseX8NSoaWk0ri0Vu8jj7/uVleG1R
 W1AZp3h1fhjxa4Mud7dWHSdixFc7Xa/FAqLrwM8simRhvzcbYabrq7HbDoBjmD2YOuNripQ76J
 r/kMsd6IIJDTbQUXS3ipsy4V38c4Ce2apOnKhaeMccwsptIGtG2rDZB8y5SIroQjeuXpLf/Xjz
 Kb0Fz8EUDzO5as+mexjMlMXCOuRyLePRfBukpuxU/t1T2ZWqyfyIYUjghJm1IPSMRtNXRJ7TJi
 gx0=
X-IronPort-AV: E=Sophos;i="5.72,381,1580803200"; 
   d="scan'208";a="28728371"
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by labrats.qualcomm.com with ESMTP; 13 Apr 2020 21:32:35 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg01-sd.qualcomm.com with ESMTP; 13 Apr 2020 21:32:34 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id 486883B20; Mon, 13 Apr 2020 21:32:34 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 1/1] scsi: pm: Balance pm_only counter of request queue during system resume
Date:   Mon, 13 Apr 2020 21:32:30 -0700
Message-Id: <1586838751-549-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During system resume, scsi_resume_device() decreases a request queue's
pm_only counter if the scsi device was quiesced before. But after that,
if the scsi device's RPM status is RPM_SUSPENDED, the pm_only counter is
still held (non-zero). Current scsi resume hook only sets the RPM status
of the scsi device and its request queue to RPM_ACTIVE, but leaves the
pm_only counter unchanged. This may make the request queue's pm_only
counter remain non-zero after resume hook returns, hence those who are
waiting on the mq_freeze_wq would never be woken up. Fix this by calling
blk_post_runtime_resume() if pm_only is non-zero to balance the pm_only
counter which is held by the scsi device's RPM ops.

(struct request_queue)0xFFFFFF815B69E938
	pm_only = (counter = 2),
	rpm_status = 0,

B::v.f_/task_0xFFFFFF810C246940
-000|__switch_to(prev = 0xFFFFFF810C246940, next = 0xFFFFFF80A49357C0)
-001|context_switch(inline)
-001|__schedule(?)
-002|schedule()
-003|blk_queue_enter(q = 0xFFFFFF815B69E938, flags = 0)
-004|generic_make_request(?)
-005|submit_bio(bio = 0xFFFFFF80A8195B80)

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/scsi_pm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 3717eea..4804029 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -93,8 +93,10 @@ static int scsi_dev_type_resume(struct device *dev,
 		 */
 		if (!err && scsi_is_sdev_device(dev)) {
 			struct scsi_device *sdev = to_scsi_device(dev);
-
-			blk_set_runtime_active(sdev->request_queue);
+			if (blk_queue_pm_only(sdev->request_queue))
+				blk_post_runtime_resume(sdev->request_queue, 0);
+			else
+				blk_set_runtime_active(sdev->request_queue);
 		}
 	}
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

