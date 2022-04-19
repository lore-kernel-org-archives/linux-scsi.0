Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814E5C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358385AbiDSXBe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347267AbiDSXBZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:25 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5A8387A7
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:41 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id d23-20020a17090a115700b001d2bde6c234so2297696pje.1
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=msoxtyUmQMPR1br4wFMJMr/YuaIVdEfrrF3GptbzXVo=;
        b=DQ49B1i0YGm/qmMzVqgM0pIWePm1EIrG4Ii37vA5xbNoE7jgiBF8qTbQRcnnZAky7N
         GX7LNkHkME/j4iIuhAw1rCnTZKIfAt8OR7lL00mHhpj42KV8DNojPz/TMU9NsECPyEx9
         OL0SZtMdSK/SQFRzVHwJHmPw35TCFVhTExiKNjDhKccAI6/dB7T7nUDQjbiZo0GH3J4e
         MIJVjvYV9Pqk4K5tOX28HLOcxo6ezjDG43GHfjb/BHgfy83ta+DTBBQQzpTf4JeQgETH
         Oo6ood178q7swsevOLK0GyiN3fJb2uCKJqmyy4FQj9C4/r5Ftu22YpTmAMume8+V/WJf
         yehA==
X-Gm-Message-State: AOAM533uSCJ9L0RapOABk6lkbYTyoVbT74CeV07RXYiaM3lVRB2jBqeV
        9i3e2YDdDg8wjs+RSVuTQceRS/RQ5eHasw==
X-Google-Smtp-Source: ABdhPJwDNUuM171EG8m5ybNNKuzC4lNbhZQVMwL6wPpxgQqHRbv7UY+D5nNHte9vungdcmjl23d+/Q==
X-Received: by 2002:a17:90a:f3d6:b0:1cb:a0aa:5e60 with SMTP id ha22-20020a17090af3d600b001cba0aa5e60mr957584pjb.161.1650409120948;
        Tue, 19 Apr 2022 15:58:40 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 11/28] scsi: ufs: Invert the return value of ufshcd_is_hba_active()
Date:   Tue, 19 Apr 2022 15:57:54 -0700
Message-Id: <20220419225811.4127248-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
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
