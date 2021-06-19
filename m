Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 539CCC48BE8
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 00:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A2BD6124C
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 00:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbhFSAyx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 20:54:53 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:34505 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbhFSAyv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2021 20:54:51 -0400
Received: by mail-pg1-f176.google.com with SMTP id g22so9238945pgk.1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jun 2021 17:52:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xs9Yn3OcArO5zUE+M6A8rai0lidPDw6aT9ssHxvTPjM=;
        b=Sj/ZG8ffAFvggg8OcbPElI26HBJhxzUkajoflKGq8Q4HmNqa55f6Wb/18AMQQSB8b3
         f3vzk6UsZZF/aDbtEDE1hzK1woOaBYmHjYq7DSvGaURDfDucyezyCFg7YKIXTfH/9865
         ZZZBGlvrg4S3cmfiwSaEtuan8Le8MN5EHgGv5u+N85L7Or2rT/jgCxOe8ZUDpuS77bBC
         2YsTJHled27xARY/Qq1x2tcVoOnL/zhuwr1nCGnoWgc1KE2fc13XWeQtzqOWa2Opyx1J
         RwLnXWdIEtmUc7DinIqykCDHtfouq+IpVzcx6xHtY+Z1ElboHVsmUC/eKCPlbuUOFw12
         cwzw==
X-Gm-Message-State: AOAM533hEda3nTj3UqnFyLrFN6gEqhIp4cqydgqHCzpwOMZ63OizfxKw
        fklzEQ+ubEgkibbGmUuS8Hg=
X-Google-Smtp-Source: ABdhPJyWoWjeq3V3OQ/BWibgbP6W2w5hskI16c6D38+jY5ABOakAI1gB6oTUlBwOYiRT0fuHsD1sWQ==
X-Received: by 2002:a63:d710:: with SMTP id d16mr12407763pgg.214.1624063960665;
        Fri, 18 Jun 2021 17:52:40 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id p6sm9934460pjh.24.2021.06.18.17.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 17:52:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH RFC 1/4] ufs: Rename the second ufshcd_probe_hba() argument
Date:   Fri, 18 Jun 2021 17:52:25 -0700
Message-Id: <20210619005228.28569-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210619005228.28569-1-bvanassche@acm.org>
References: <20210619005228.28569-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename the second argument of ufshcd_probe_hba() such that the name of
that argument reflects its purpose instead of how the function is called.
See also commit 1b9e21412f72 ("scsi: ufs: Split ufshcd_probe_hba() based
on its called flow").

Cc: Bean Huo <beanhuo@micron.com>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Can Guo <cang@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 25fe18a36cd2..c230d2a6a55c 100644
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
