Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A46C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 23:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiKHXeT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiKHXeR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 18:34:17 -0500
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FDA40900
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 15:34:16 -0800 (PST)
Received: by mail-pj1-f48.google.com with SMTP id d59-20020a17090a6f4100b00213202d77e1so285506pjk.2
        for <linux-scsi@vger.kernel.org>; Tue, 08 Nov 2022 15:34:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CHCnAXPPmp2IpgajiXHrcVTx/+rpqECCL4FFj/zhSbc=;
        b=K2ALgMS8hiyDZFC7Gcntej9jIBVYrHNxP5vuC/y7Szm343XCvApxPdvSFYcndTenwh
         KvLq+Ic9+xBW8o3JfG6dfK5xu/gOIUHw2A+6D6H4gW18QZEpl3zFxLU3n1dnmfR8rcKt
         oNEA/KWAWGJt8M8Z9XD29V0FL4Bn0e71H7Mr5vYbkuhqlQurOle0ZJiJ7KOoJAIYDchm
         iDkaqJrrH89IXhMJi5aE8xUyoKedyuXPfRq5sdjzK8i0iJr3ZjD9y1e9aWTFOQsUyB65
         JmLSuScL2vgrM4SA0b38ryoTMV6Sa9h8ECtWqqFmyQE5qwUDi8qPzCUE3NLFW/Ad6r6c
         ASBA==
X-Gm-Message-State: ACrzQf18m3YIN2E7wqLDLyQtsSR/kWoQbwnv3zSysHSTuFyDnUzzY8KB
        PqHcVgTcFZaZAqVn8zENcbo=
X-Google-Smtp-Source: AMsMyM6RuBiKSg01Mm99CdwTPZLr5EGaftdxJHUHD3dP4XkuTnhVFRVMRxHpIG/IIYNGpEshfVhbeg==
X-Received: by 2002:a17:902:b944:b0:187:28c4:69a3 with SMTP id h4-20020a170902b94400b0018728c469a3mr46958635pls.134.1667950455308;
        Tue, 08 Nov 2022 15:34:15 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:44ad:aec5:7cab:4532])
        by smtp.gmail.com with ESMTPSA id q10-20020aa7982a000000b005618189b0ffsm6918088pfl.104.2022.11.08.15.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 15:34:14 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v3 3/5] scsi: ufs: Pass the clock scaling timeout as an argument
Date:   Tue,  8 Nov 2022 15:33:37 -0800
Message-Id: <20221108233339.412808-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
In-Reply-To: <20221108233339.412808-1-bvanassche@acm.org>
References: <20221108233339.412808-1-bvanassche@acm.org>
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
index 195261e3521c..7b2948592c4a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1121,6 +1121,12 @@ static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
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
@@ -1225,9 +1231,14 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
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
@@ -1236,7 +1247,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	ufshcd_scsi_block_requests(hba);
 	down_write(&hba->clk_scaling_lock);
 
-	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
+	if (ufshcd_wait_for_doorbell_clr(hba, timeout_us)) {
 		ret = -EBUSY;
 		up_write(&hba->clk_scaling_lock);
 		ufshcd_scsi_unblock_requests(hba);
@@ -1277,7 +1288,7 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 	if (!hba->clk_scaling.is_allowed)
 		return -EBUSY;
 
-	ret = ufshcd_clock_scaling_prepare(hba);
+	ret = ufshcd_clock_scaling_prepare(hba, 1 * USEC_PER_SEC);
 	if (ret)
 		return ret;
 
