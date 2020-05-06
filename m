Return-Path: <SRS0=GN0H=6U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B746CC4725C
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 04:56:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8706A20714
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 04:56:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Qn6wzS3l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbgEFE4s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 May 2020 00:56:48 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:39908 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725796AbgEFE4r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2020 00:56:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588741006; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=QX8Zhtt2ZI9PyrjDSVNOucmxgJDf+kNLava4CsP69mA=; b=Qn6wzS3lJaoKyONR9GX+4S5HkkXmnAFYhWCrT44/H5LjGBkWn/d2sEGYrYBHIKxNFghrE+I1
 f4S28+6x/mWeJKga7wtVsXwQBYxgjQbGFM1Pr+45fr7AGdA6ml5bIbwYaViE+NfGraBV98p+
 fDvCLMFjRTriOqWXjPD6LZ/kUyM=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6DB40C44792; Wed,  6 May 2020 04:56:44 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A6838C433D2;
        Wed,  6 May 2020 04:56:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A6838C433D2
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
Subject: [PATCH v4 1/1] scsi: pm: Balance pm_only counter of request queue during system resume
Date:   Tue,  5 May 2020 21:55:35 -0700
Message-Id: <1588740936-28846-1-git-send-email-cang@codeaurora.org>
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
blk_post_runtime_resume() if a sdev's RPM status was RPM_SUSPENDED.

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
---

Change since v3:
- Instead of relying on pm_only counter, rely on the runtime status of a sdev. (Based on the discussion with Bart)

Change since v2:
- Rebased on 5.8-scsi-queue

Change since v1:
- Added more debugging context info

 drivers/scsi/scsi_pm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 3717eea..5f0ad8b 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -80,6 +80,10 @@ static int scsi_dev_type_resume(struct device *dev,
 	dev_dbg(dev, "scsi resume: %d\n", err);
 
 	if (err == 0) {
+		bool was_runtime_suspended;
+
+		was_runtime_suspended = pm_runtime_suspended(dev);
+
 		pm_runtime_disable(dev);
 		err = pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
@@ -93,8 +97,10 @@ static int scsi_dev_type_resume(struct device *dev,
 		 */
 		if (!err && scsi_is_sdev_device(dev)) {
 			struct scsi_device *sdev = to_scsi_device(dev);
-
-			blk_set_runtime_active(sdev->request_queue);
+			if (was_runtime_suspended)
+				blk_post_runtime_resume(sdev->request_queue, 0);
+			else
+				blk_set_runtime_active(sdev->request_queue);
 		}
 	}
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

