Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BFDAC43334
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jul 2022 21:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbiGOV0F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jul 2022 17:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbiGOVZ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2022 17:25:59 -0400
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D50F79EFA
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 14:25:55 -0700 (PDT)
Received: by mail-pg1-f181.google.com with SMTP id q16so2373740pgq.6
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 14:25:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vf3d4T6ckpl5sc6NUdI7j1z51d7qLNRgPs7pebeIVtY=;
        b=LB2w/OiEmV/OOIEptmaFa/U+Sib93z+rLkR1XuEa+2XCtc59F4EZb4FKWq2l2D1Wy6
         Rn7i0sgJKh6wRRPcoNmyLNhdNHSJAAK2C+iF5x0pI6Qh+IHtVEr2ZdnhnsK9b77vFzj0
         TwFgJgHzYe0h7drTVh5NcsiBReNVExcBIdbdQbAtOFi0doVWs1mkGYhLCdTjYaTNcCL3
         gxiPVhisyl/ekfz9hJ+NMHSJ8Ip0m1871ZsogNxwgn0AjGuTiAY6bcgws7m3DpKAILrQ
         0pQPGb9AThcKOLoxL3Z1xKS0OrIQ07FQykC9h6zabShI+HNaig2IQFLhH23N4Tvk0Y9E
         3cqw==
X-Gm-Message-State: AJIora8QfxN3CunlVDpwUPOXa9OsEOZcLi6oES5j81n7YQUIQE383YSs
        TLmCvBhhKsuwNT1w3DBC8us=
X-Google-Smtp-Source: AGRyM1sFhRVTd2u5AxNSzbW10XIccN6T4PjMIvE8QrjdA31KvFr0aoeMaArlgYySOvIqP2c42imKJA==
X-Received: by 2002:a05:6a00:1a8c:b0:52b:3eed:13d8 with SMTP id e12-20020a056a001a8c00b0052b3eed13d8mr4843943pfv.74.1657920354656;
        Fri, 15 Jul 2022 14:25:54 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:276e:f777:f438:e01d])
        by smtp.gmail.com with ESMTPSA id e35-20020a630f23000000b0040c40b022fbsm3535944pgl.94.2022.07.15.14.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 14:25:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 3/5] scsi: ufs: Pass the clock scaling timeout as an argument
Date:   Fri, 15 Jul 2022 14:25:13 -0700
Message-Id: <20220715212515.347664-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
In-Reply-To: <20220715212515.347664-1-bvanassche@acm.org>
References: <20220715212515.347664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for adding an additional ufshcd_clock_scaling_prepare() call
with a different timeout.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f7af5cd3124e..5739e9d1b970 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1116,6 +1116,12 @@ static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
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
@@ -1220,9 +1226,14 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
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
@@ -1231,7 +1242,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	ufshcd_scsi_block_requests(hba);
 	down_write(&hba->clk_scaling_lock);
 
-	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
+	if (ufshcd_wait_for_doorbell_clr(hba, timeout_us)) {
 		ret = -EBUSY;
 		up_write(&hba->clk_scaling_lock);
 		ufshcd_scsi_unblock_requests(hba);
@@ -1272,7 +1283,7 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 	if (!hba->clk_scaling.is_allowed)
 		return -EBUSY;
 
-	ret = ufshcd_clock_scaling_prepare(hba);
+	ret = ufshcd_clock_scaling_prepare(hba, 1 * USEC_PER_SEC);
 	if (ret)
 		return ret;
 
