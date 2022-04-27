Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E78C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Apr 2022 23:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiD0Xmm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Apr 2022 19:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiD0Xmk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2022 19:42:40 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA0C5F25F
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 16:39:28 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id j8so2856943pll.11
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 16:39:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pys2NjB9kTY7mpqLXwuixnBV6CiqLHWCJ4i7tBt5VTM=;
        b=uA9OxPwd02jNzW9TrH1PxxPwTfun0yCaQksQJ9shX/an3XzbWt7h32h5XuGLDjR+ov
         xfzXfjNxz025wXFJdSL3McdxF/BjQGEEWYuObTp4MeUg1A3g1bpstquWABGNTHIrCWF+
         K5Co3DfwzyYn+95OBNzf2MCg2R9C0d0ogdRCOdHlMjpxgLcWX2uSC0eG0Buw6r6fq+Cx
         eZ2bmXQxQBDl+TDw7XqifCGQTv/vqTfCuxIW76upEyA3WyJHtJdUHz+RuFcijvRggVFL
         bXTAmXCdX7EGebac8K1XAGYGi9xe6DobFL4DK9RZIJafnixlmXB5w3Lzi7Fwo7pxeDfT
         HuDg==
X-Gm-Message-State: AOAM530O8O2sgeQb1/K5ffTaMuF8o+OQqRKqrqnl6WjCDfEhBzT0j+fs
        /ngyG52WfQgA9QoOznYXtAg=
X-Google-Smtp-Source: ABdhPJz8NAbN9/KSmWUr2ajTpbmMemRQIL6LTdgLMRvyN7d8YJcjurrKGXJo2C0SIaKO7zXPKiX/8g==
X-Received: by 2002:a17:90b:3a81:b0:1d9:54a0:9362 with SMTP id om1-20020a17090b3a8100b001d954a09362mr23533290pjb.144.1651102767900;
        Wed, 27 Apr 2022 16:39:27 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6cbb:d78e:9b3:bb62])
        by smtp.gmail.com with ESMTPSA id f16-20020aa78b10000000b0050a81508653sm19817580pfd.198.2022.04.27.16.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 16:39:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 3/4] scsi: ufs: Pass the clock scaling timeout as an argument
Date:   Wed, 27 Apr 2022 16:38:54 -0700
Message-Id: <20220427233855.2685505-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
In-Reply-To: <20220427233855.2685505-1-bvanassche@acm.org>
References: <20220427233855.2685505-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for adding an additional ufshcd_clock_scaling_prepare() call
with a different timeout.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3c83f4049031..60ba11b68735 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1108,6 +1108,12 @@ static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
 	return pending;
 }
 
+/*
+ * Wait until all pending SCSI commands and TMFs have finished or the timeout
+ * has expired.
+ *
+ * Return: 0 upon success; -EBUSY upon timeout.
+ */
 static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 					u64 wait_timeout_us)
 {
@@ -1212,9 +1218,14 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
 	return ret;
 }
 
-static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
+/*
+ * Wait until all pending SCSI commands and TMFs have finished or the timeout
+ * has expired.
+ *
+ * Return: 0 upon success; -EBUSY upon timeout.
+ */
+static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
 {
-	#define DOORBELL_CLR_TOUT_US		(1000 * 1000) /* 1 sec */
 	int ret = 0;
 	/*
 	 * make sure that there are no outstanding requests when
@@ -1223,7 +1234,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	ufshcd_scsi_block_requests(hba);
 	down_write(&hba->clk_scaling_lock);
 
-	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
+	if (ufshcd_wait_for_doorbell_clr(hba, timeout_us)) {
 		ret = -EBUSY;
 		up_write(&hba->clk_scaling_lock);
 		ufshcd_scsi_unblock_requests(hba);
@@ -1264,7 +1275,7 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 	if (!hba->clk_scaling.is_allowed)
 		return -EBUSY;
 
-	ret = ufshcd_clock_scaling_prepare(hba);
+	ret = ufshcd_clock_scaling_prepare(hba, 1 * USEC_PER_SEC);
 	if (ret)
 		return ret;
 
