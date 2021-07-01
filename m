Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 299F1C11F67
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 146EA6128A
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhGAVPi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:15:38 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:44023 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbhGAVPh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:15:37 -0400
Received: by mail-pl1-f180.google.com with SMTP id i13so4372738plb.10
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:13:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MMdVnriU+0MznJ/BnQqiwR0VpVYruaB3sRdsHxBFvEc=;
        b=UxQpNPxbrLqI2CkSk+NZWUpBRo9/fXm5i7oKZg7lK5VQwRPQtM83sJ40J6zmLkYz+W
         kGj4dCQBrJ5TLHKS0mCwMAIs26ksbhtn1LlEUgzgZ23bwq9qFsma7SIYUdy0QEo/pyhH
         eLphvWDj75rbDX2YyDf7Vvrlhd/Xq4RbO9X87DfKxIXygYYFZMXX0NwBUmKVsjEb6eLw
         E7PfnF5N2OOTl+O+xyc1c/gJ6tzn6dZvdaaKiCV5tCjYHbdjljXCnqh3o/VMOhYL3Yvt
         glD+2USd4O+tDQVHXbAdWV2tDXZH9U3xGtBJy/cy0U3Up7KL3GwGf5Grmh521QPtws8u
         MYJg==
X-Gm-Message-State: AOAM533sBBXl8o6O08Owm+ecYBoXaYwhr4ntcddbs5EQE5OC0SHuqkBY
        fn7VIS39ZlXlOByfpCOxN70=
X-Google-Smtp-Source: ABdhPJwMCznoVHxu3yu56oxQyadp6o3C5smyx5a+V1HZm0PA3lwv7RtvNeXp49vo+SULK6jSYuTLjg==
X-Received: by 2002:a17:902:8308:b029:129:220a:c455 with SMTP id bd8-20020a1709028308b0290129220ac455mr1533640plb.74.1625173985815;
        Thu, 01 Jul 2021 14:13:05 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:13:04 -0700 (PDT)
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
Subject: [PATCH 08/21] ufs: Rename the second ufshcd_probe_hba() argument
Date:   Thu,  1 Jul 2021 14:12:11 -0700
Message-Id: <20210701211224.17070-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701211224.17070-1-bvanassche@acm.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
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
index 37302a8b3937..86ca9e1ce5aa 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7964,13 +7964,13 @@ static int ufshcd_clear_ua_wluns(struct ufs_hba *hba)
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
@@ -8002,7 +8002,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 	 * Initialize UFS device parameters used by driver, these
 	 * parameters are associated with UFS descriptors.
 	 */
-	if (async) {
+	if (init_dev_params) {
 		ret = ufshcd_device_params_init(hba);
 		if (ret)
 			goto out;
