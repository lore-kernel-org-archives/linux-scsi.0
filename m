Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7FFC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242518AbiCaWiK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242646AbiCaWiD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:38:03 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21701D08F2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:36:15 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so844913pjm.0
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:36:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9wTIiLFsILVTDJzCqSy8yVc9kctCuu2o055jBgU0Ypk=;
        b=A1xGD572pSsrY9/Dy3MICedFM+rJE7YzsWcL9IXGG8bvUfzmleg25ZV3ZDSawq+VoF
         heQbutCLaN7GRKN9Ve4CnUi3CzwbMMErWSqKUDgPkm7FPLB57kM9GjVMtzSOfOzalcoy
         Aa68NBsSL1UQbx7KlVuWhoyM5Qd2VL/YLKbcHd4rIkNw6yRjKkipNElT7Rlka8Y3hFii
         uKvYXjW0UBgkFcOsgrW3aAAI8dKXIcPw8lvcYC4tIxJjxJQ8Y5bifhjCyzDogsAZrcaG
         8HQWs2noUTsa3+NJ9TI1IAN4EddsUc1XwVvIWPcK74VOg8y3Yb5tXQs/JaOc6PdYdjHZ
         M4Ew==
X-Gm-Message-State: AOAM532xSCuuwBr8WWab0cdwtsQLyDxhzMl3fa2TGIQfCJOddUtp/19+
        rbXBP3q4rBJNvfOA5MfmpJg=
X-Google-Smtp-Source: ABdhPJx50oj4/LsLZkCTn4M3yK1hOrlnHti9aykVEKQpg6IkViu1pWYlczuuHB7JiPUbEvNHZR+GXg==
X-Received: by 2002:a17:90b:4c8f:b0:1c7:7bc0:954a with SMTP id my15-20020a17090b4c8f00b001c77bc0954amr8416831pjb.214.1648766175317;
        Thu, 31 Mar 2022 15:36:15 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:36:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 10/29] scsi: ufs: Invert the return value of ufshcd_is_hba_active()
Date:   Thu, 31 Mar 2022 15:34:05 -0700
Message-Id: <20220331223424.1054715-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It is confusing that ufshcd_is_hba_active() returns 'true' if the HBA is
not active. Clear up this confusion by inverting the return value of
ufshcd_is_hba_active(). This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 931ce620fc34..1ed54f6aef82 100644
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
