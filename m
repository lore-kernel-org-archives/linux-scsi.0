Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE41C07E9D
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 508E961260
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhGVCyh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 22:54:37 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:42501 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhGVCyh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 22:54:37 -0400
Received: by mail-pj1-f41.google.com with SMTP id i16-20020a17090acf90b02901736d9d2218so3611965pju.1
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2021 20:35:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G2MF5bnircQnxJthwB/xNQ1YlfiMwCda0AznENpU+zw=;
        b=kR+LGjPABHyleUE264/4uFEKPxzNq5cJEaIUJ2FGZ9+T3S0h+oL/VYXf9HEGHsHCf+
         gZHYO0dx8lw9i1fBqQiDknQLZmXmqeW6dWcQmyPM6agcQzex0K3gTOuVvI19PqovwPeh
         9dixTPqC8zawSfGY360D9y8gyFveepjj2pIqN9ZgmG0JZfHtxNSdNtpoU5TnH+dzMFIE
         A/XLMpPIwAbUudZD6F95WHHyKQzgOitUSlz3r7z3VN6GYL47IWIPoKMBR9bt7z5Cfngu
         FARQLXrNU0KwkeCwzgGCY30R+WB1eYGYQ8fUQpWfwhkqS9RmKw+sPYT3uESZPw5HHj/z
         jYxQ==
X-Gm-Message-State: AOAM533Mr4jzawNvJ/VPfjSXwWb6R1VmOg6ACKDTC/69JVrjHSwaaOHc
        9sNN2FM3os1EDonDXMOXroQ=
X-Google-Smtp-Source: ABdhPJx8yP1YKDua9fE4136TN92Uuh5TRMNsOT2wf+2YHG8orfdCj5Oh/JugsL97tVnN7b4CjINfeA==
X-Received: by 2002:a17:90b:3a89:: with SMTP id om9mr7152204pjb.55.1626924911618;
        Wed, 21 Jul 2021 20:35:11 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:30e2:954a:f4a0:3224])
        by smtp.gmail.com with ESMTPSA id n6sm32060258pgb.60.2021.07.21.20.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 20:35:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 04/18] scsi: ufs: Rename the second ufshcd_probe_hba() argument
Date:   Wed, 21 Jul 2021 20:34:25 -0700
Message-Id: <20210722033439.26550-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722033439.26550-1-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename the second argument of ufshcd_probe_hba() such that the name of
that argument reflects its purpose instead of how the function is called.
See also commit 1b9e21412f72 ("scsi: ufs: Split ufshcd_probe_hba() based
on its called flow").

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Can Guo <cang@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0503ebe197f6..36b60afcce34 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7968,13 +7968,13 @@ static int ufshcd_clear_ua_wluns(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_probe_hba - probe hba to detect device and initialize
+ * ufshcd_probe_hba - probe hba to detect device and initialize it
  * @hba: per-adapter instance
- * @async: asynchronous execution or not
+ * @init_dev_params: whether or not to call ufshcd_device_params_init().
  *
  * Execute link-startup and verify device initialization
  */
-static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
+static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 {
 	int ret;
 	unsigned long flags;
@@ -8006,7 +8006,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 	 * Initialize UFS device parameters used by driver, these
 	 * parameters are associated with UFS descriptors.
 	 */
-	if (async) {
+	if (init_dev_params) {
 		ret = ufshcd_device_params_init(hba);
 		if (ret)
 			goto out;
