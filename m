Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2585AC2BB1D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 05:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 105AB206E9
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 05:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405482AbgDNFYj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 01:24:39 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:27979 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgDNFYi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2020 01:24:38 -0400
IronPort-SDR: cwVzQoT1a708KngoN6/rGhZ6Goc8X6sBW3XGm5tzr0FZOeyHoFcHrELRpDi4BOEi1N0idHz+Vt
 gBtYgQDR26w/pzWrL2X0D7kBSUOAsBxZw5iSk+s5I9918FJ8YXBJgcOqypDacKYT1twNQPd86L
 aC2H8hZa5B2/CyxzxGgIFJKIu//jbdb1zFHQw05Rl+0lRwBVUEaLXV8iR5dtkdRxDkBCTOurTq
 ywwuYWCejNDmweW0QR//0xeGP84mQrcNlxJHX0U8kz7aaaH2yiBM/nhKBXMyEkeOGlCrkb7P37
 Gvo=
X-IronPort-AV: E=Sophos;i="5.72,381,1580803200"; 
   d="scan'208";a="46834635"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 13 Apr 2020 22:24:37 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg02-sd.qualcomm.com with ESMTP; 13 Apr 2020 22:24:36 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id 000D03B21; Mon, 13 Apr 2020 22:24:36 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/1] scsi: pm: Balance pm_only counter of request queue during system resume
Date:   Mon, 13 Apr 2020 22:24:34 -0700
Message-Id: <1586841875-15667-1-git-send-email-cang@codeaurora.org>
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
	dev = 0xFFFFFF815B0511A0,

((struct device)0xFFFFFF815B0511A0)).power
	is_suspended = FALSE,
	runtime_status = RPM_ACTIVE,

(struct scsi_device)0xffffff815b051000
	request_queue = 0xFFFFFF815B69E938,
	sdev_state = SDEV_RUNNING,
	quiesced_by = 0x0,

B::v.f_/task_0xFFFFFF810C246940
-000|__switch_to(prev = 0xFFFFFF810C246940, next = 0xFFFFFF80A49357C0)
-001|context_switch(inline)
-001|__schedule(?)
-002|schedule()
-003|blk_queue_enter(q = 0xFFFFFF815B69E938, flags = 0)
-004|generic_make_request(?)
-005|submit_bio(bio = 0xFFFFFF80A8195B80)

Signed-off-by: Can Guo <cang@codeaurora.org>

Change since v1:
- Added more debugging context info

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

