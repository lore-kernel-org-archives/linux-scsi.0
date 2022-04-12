Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D0CC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236948AbiDLSXV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358688AbiDLSXU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:23:20 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAA04DF55
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:21:00 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id z16so18227790pfh.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:21:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=msoxtyUmQMPR1br4wFMJMr/YuaIVdEfrrF3GptbzXVo=;
        b=fLznWz9Xx2gxmiBQFyofUdxuEZJ7ypzkbAcFabRVwhssL+O4H02AAIc07jJNrW1y4L
         N5IWgo56woRSFE4xG9aVILpuFtQdki9XQUBawjYhp78hEkjnWPxolVD9MIkOONLqkg0y
         gy2iUXgCzMRRMOIgzxzayHnCype3YGLBHLLXcFsSAbakt3YoZN3pjvooCPgjJMuGJ+fS
         JhO2LcWO4ntuYM/23x/OFkK/0ZQ96wLdVyeIT5VPuJWkdN0DcOkqgvXAZRr2KwtqTdpd
         Io93OKQAkp7j7K5m4RIEzXirIP25Oxg6PpUAthmWtH/8VKYgyztTfMnnOQYN5cdOROn5
         mwMw==
X-Gm-Message-State: AOAM532PFrTlxTulzGoVN7BTK2FJEmDAzkSQZ/nXk1/jkHmNg1XBRrZT
        78QgSKT97HQ96q9E0+TmjCc=
X-Google-Smtp-Source: ABdhPJwtXpgTHAjH9u6aORQ4F3Ll/mfH0yT+DKU6v+ciHNbpTALj21oDOUQhSFEvJEP9Y5KO/6rIig==
X-Received: by 2002:a05:6a00:218a:b0:505:aa03:ba57 with SMTP id h10-20020a056a00218a00b00505aa03ba57mr15578852pfi.84.1649787660023;
        Tue, 12 Apr 2022 11:21:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:20:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>
Subject: [PATCH v2 11/29] scsi: ufs: Invert the return value of ufshcd_is_hba_active()
Date:   Tue, 12 Apr 2022 11:18:35 -0700
Message-Id: <20220412181853.3715080-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It is confusing that ufshcd_is_hba_active() returns 'true' if the HBA is
not active. Clear up this confusion by inverting the return value of
ufshcd_is_hba_active(). This patch does not change any functionality.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a1ebfbb6f1b9..eabc6b6156fd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -917,12 +917,11 @@ static inline void ufshcd_hba_start(struct ufs_hba *hba)
  * ufshcd_is_hba_active - Get controller state
  * @hba: per adapter instance
  *
- * Returns false if controller is active, true otherwise
+ * Returns true if and only if the controller is active.
  */
 static inline bool ufshcd_is_hba_active(struct ufs_hba *hba)
 {
-	return (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) & CONTROLLER_ENABLE)
-		? false : true;
+	return ufshcd_readl(hba, REG_CONTROLLER_ENABLE) & CONTROLLER_ENABLE;
 }
 
 u32 ufshcd_get_local_unipro_ver(struct ufs_hba *hba)
@@ -4552,7 +4551,7 @@ static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
 	int retry_inner;
 
 start:
-	if (!ufshcd_is_hba_active(hba))
+	if (ufshcd_is_hba_active(hba))
 		/* change controller state to "reset state" */
 		ufshcd_hba_stop(hba);
 
@@ -4578,7 +4577,7 @@ static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
 
 	/* wait for the host controller to complete initialization */
 	retry_inner = 50;
-	while (ufshcd_is_hba_active(hba)) {
+	while (!ufshcd_is_hba_active(hba)) {
 		if (retry_inner) {
 			retry_inner--;
 		} else {
