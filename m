Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E3DC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 15:22:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBF3F225AC
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 15:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbhAKPVo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 10:21:44 -0500
Received: from comms.puri.sm ([159.203.221.185]:56902 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729200AbhAKPVo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 10:21:44 -0500
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id C0AABDFD21;
        Mon, 11 Jan 2021 07:21:03 -0800 (PST)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id URKHmkTJRGSk; Mon, 11 Jan 2021 07:21:03 -0800 (PST)
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        stern@rowland.harvard.edu, bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: [PATCH 3/3] scsi: sd: add support for expect_media_change_suspend flag
Date:   Mon, 11 Jan 2021 16:20:29 +0100
Message-Id: <20210111152029.28426-4-martin.kepplinger@puri.sm>
In-Reply-To: <20210111152029.28426-1-martin.kepplinger@puri.sm>
References: <20210111152029.28426-1-martin.kepplinger@puri.sm>
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the sd driver act appropriately when the user has set
expect_media_change_suspend for a device.

Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
---
 drivers/scsi/sd.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a3d2d4bc4a3d..ad89f8c76a27 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -608,7 +608,7 @@ static const struct dev_pm_ops sd_pm_ops = {
 	.poweroff		= sd_suspend_system,
 	.restore		= sd_resume,
 	.runtime_suspend	= sd_suspend_runtime,
-	.runtime_resume		= sd_resume,
+	.runtime_resume		= sd_resume_runtime,
 };
 
 static struct scsi_driver sd_template = {
@@ -3699,6 +3699,25 @@ static int sd_resume(struct device *dev)
 	return ret;
 }
 
+static int sd_resume_runtime(struct device *dev)
+{
+	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	int ret;
+
+	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
+		return 0;
+
+	/*
+	 * expect_media_change_suspend is the userspace setting and
+	 * expecting_media_change is what is checked and cleared in the
+	 * error path if we set it here.
+	 */
+	if (sdkp->device->expect_media_change_suspend)
+		sdkp->device->expecting_media_change = 1;
+
+	return sd_resume(dev);
+}
+
 /**
  *	init_sd - entry point for this driver (both when built in or when
  *	a module).
-- 
2.20.1

