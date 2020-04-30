Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0022EC83001
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 04:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB6FD2073E
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 04:10:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="sI5jE6IA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgD3EKW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 00:10:22 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:41994 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725280AbgD3EKW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 00:10:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588219821; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=zY3h7WyYFL9pgdVpyH23IWdwL6hQCkZYVkn4m8ZIaOI=; b=sI5jE6IAaiotPH9CPJg42Nx3mBWxrLcjsxTekafphEpxzLvOEAF4latdfKWqH5nCJ4j/njoV
 60CKjnke75AoXogmaS5pPsBLcXX77ov4mOpeSZR/7+77U/sCNcnLrYyaaq7qZxtGekqgJT/7
 4nuPQjku3buVJ0FuyTSJ0BaHuFE=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eaa4fa9.7fc768d196c0-smtp-out-n03;
 Thu, 30 Apr 2020 04:10:17 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EF649C43637; Thu, 30 Apr 2020 04:10:16 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4FD30C433CB;
        Thu, 30 Apr 2020 04:10:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4FD30C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        stanley.chu@mediatek.com, alim.akhtar@samsung.com,
        beanhuo@micron.com, Avri.Altman@wdc.com,
        bjorn.andersson@linaro.org, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 1/1] scsi: pm: Balance pm_only counter of request queue during system resume
Date:   Wed, 29 Apr 2020 21:10:05 -0700
Message-Id: <1588219805-25794-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
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

(struct scsi_device)0xFFFFFF815b051000
	request_queue = 0xFFFFFF815B69E938,
	sdev_state = SDEV_RUNNING,
	quiesced_by = 0x0,

B::v.f_/task_
-000|__switch_to
-001|context_switch
-001|__schedule
-002|schedule
-003|blk_queue_enter(q = 0xFFFFFF815B69E938, flags = 0)
-004|generic_make_request
-005|submit_bio

Signed-off-by: Can Guo <cang@codeaurora.org>
---

Change since v2:
- Rebased on 5.8-scsi-queue

Change since v1:
- Added more debugging context info

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
