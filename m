Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC4FC49EA5
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 23:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7FB76120D
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 23:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhFXXcg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 19:32:36 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:47025 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhFXXce (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2021 19:32:34 -0400
Received: by mail-pj1-f42.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso4436938pjp.5
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2021 16:30:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7DmPFW6z9ZmlZUUD/fOLybWq0R8kO/aYu1f2AMM5L0M=;
        b=QhmZOCqfowcmEkJtpf6LnKSgJCWNdaA1wn2Pc1kwfm77e4CQFJzn4CrI9+HX1FDrGb
         rh2ItyQOXXYv5cDw74c9xTCjJf83vazv/n1gOFZde13mB67R/w7AyHW+zuhXeetPQR5U
         dy+ticE+HS3sxpVloxgulFbwn13ajfyG3BJ+zC6ezCN3lPMLhYh5ibZd9NfdOczbSsHx
         KMPw77E92aHKu6aAuW4tO3TQdu0oFFHCUD6D9/S/ikm0Gi1KBc0CT4/PRqj5462E7e2U
         /FD6u4ONBJFQeAoRR42XOS4loNxQiN0Ice1SKqwI1bGTBN+5pTedhhv7wpDpa67eMTpv
         wJhA==
X-Gm-Message-State: AOAM530P+dayyL0k/q/G7Dmj3fSkkoXGKuBBgGYwBYJrg7sZm5CIZg3S
        5GR7wIS1kaCKUoO/xRwmFK8=
X-Google-Smtp-Source: ABdhPJyru5IlYTqtcO41XOeX4IRsXIxEwcYd/0C/2hEO6RzM8sCofzqkm3wyjfgR5kadY3hu3KLsmw==
X-Received: by 2002:a17:90b:490f:: with SMTP id kr15mr460016pjb.111.1624577414801;
        Thu, 24 Jun 2021 16:30:14 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id j16sm3599908pgh.69.2021.06.24.16.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 16:30:14 -0700 (PDT)
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
Subject: [PATCH v2 2/3] ufs: Rename the second ufshcd_probe_hba() argument
Date:   Thu, 24 Jun 2021 16:29:56 -0700
Message-Id: <20210624232957.6805-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210624232957.6805-1-bvanassche@acm.org>
References: <20210624232957.6805-1-bvanassche@acm.org>
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
Cc: Bean Huo <beanhuo@micron.com>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Can Guo <cang@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f097720b6b5e..fb493533c034 100644
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
