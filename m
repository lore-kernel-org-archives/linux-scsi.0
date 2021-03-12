Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E32F4C28E87
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB50664FDA
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbhCLJsr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbhCLJsR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:48:17 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72F1C0613D9
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:16 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id 61so1405118wrm.12
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jXzZsgME51o5a4S3G/qD/qZyWpfOm8qpjFIuUNjewrU=;
        b=RzDHHxJIrMTYsGLtnjmh448nDAU6vYH3+2i3jhfv9Yf7Bum4BYw4rNx29JA4HMXlZr
         GxvreTK/UTMpv2fgwZUqNITRSEtDrRDoTYeIy4i0v6XyvSUP/LXNjws7sKFl7xvHR28t
         L7KansPbqqzqOVIlWPwjjQAXwqyYutcuqDI1IEmGJzo6s0Rb2ryGPRrWAh6ETFs1MQKN
         bUsQzUYjqKkmbDQSSm3PPwkUOKIQOXogUANenFZMZAdeovFMJAsIzY9qDYnZClEuLIOB
         DP55HmbJ6u7ZDqmMz3fuwrgH4pvZ6bbdOOXAhc0k9pFfiP6M99cjitSgd/MMUNaG3/lZ
         D5iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jXzZsgME51o5a4S3G/qD/qZyWpfOm8qpjFIuUNjewrU=;
        b=HjYp5UbnLfZKKkl+Gn5yssMdqMrPMZGtF7JJHPduG6hZ6sJkHIike/tNlGmvGtyJ+O
         2f07QvSpZ9QBpoupd7yQGS6JSNUDFNh1pxG6RdX6iMNDoZaWob5Q+vRBYFsF6Gpp0PKf
         XwxAF7ajZufexNLiYM58IefEqWvYJORZfi0cpxJldezXMW8UDbqgDEXm23CchRTz6CDf
         2Z3tNF9BbR/67RvkJ4I0/z3jaZxfaXububLtCu3jyghMLyWHjGJANYe9RHkwOGsv/VLf
         SmbJykuDvR+iOfsGRNXpQhkbdVxFf7Y/vD+RIhS5Y9FC+4MjI5nMdThqsBLCq5Rkv0tk
         IB3Q==
X-Gm-Message-State: AOAM533g4ZlzjJiRNH74XiYaW906oNVZ83uTqQz3E9FU+nXpTjyreFqG
        5lig20w74KTXk9DfMQjLUQzemg==
X-Google-Smtp-Source: ABdhPJxYl7bqyU5JTM3AB7hrDocTa5Yda5nTYn2IUc7mVithIahnHmSDLT/pNp3q/FF6TYv0lTQGZw==
X-Received: by 2002:adf:a418:: with SMTP id d24mr12943172wra.187.1615542495551;
        Fri, 12 Mar 2021 01:48:15 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:48:15 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux GmbH <hare@suse.com>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 27/30] scsi: myrs: Remove a couple of unused 'status' variables
Date:   Fri, 12 Mar 2021 09:47:35 +0000
Message-Id: <20210312094738.2207817-28-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/myrs.c: In function ‘consistency_check_show’:
 drivers/scsi/myrs.c:1193:16: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/myrs.c: In function ‘myrs_get_resync’:
 drivers/scsi/myrs.c:1984:5: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]

Cc: Hannes Reinecke <hare@kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Linux GmbH <hare@suse.com>
Cc: "Leonard N. Zubkoff" <lnz@dandelion.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/myrs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 4adf9ded296aa..48e399f057d5c 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1190,7 +1190,6 @@ static ssize_t consistency_check_show(struct device *dev,
 	struct myrs_hba *cs = shost_priv(sdev->host);
 	struct myrs_ldev_info *ldev_info;
 	unsigned short ldev_num;
-	unsigned char status;
 
 	if (sdev->channel < cs->ctlr_info->physchan_present)
 		return snprintf(buf, 32, "physical device - not checking\n");
@@ -1199,7 +1198,7 @@ static ssize_t consistency_check_show(struct device *dev,
 	if (!ldev_info)
 		return -ENXIO;
 	ldev_num = ldev_info->ldev_num;
-	status = myrs_get_ldev_info(cs, ldev_num, ldev_info);
+	myrs_get_ldev_info(cs, ldev_num, ldev_info);
 	if (ldev_info->cc_active)
 		return snprintf(buf, 32, "checking block %zu of %zu\n",
 				(size_t)ldev_info->cc_lba,
@@ -1981,14 +1980,13 @@ myrs_get_resync(struct device *dev)
 	struct myrs_hba *cs = shost_priv(sdev->host);
 	struct myrs_ldev_info *ldev_info = sdev->hostdata;
 	u64 percent_complete = 0;
-	u8 status;
 
 	if (sdev->channel < cs->ctlr_info->physchan_present || !ldev_info)
 		return;
 	if (ldev_info->rbld_active) {
 		unsigned short ldev_num = ldev_info->ldev_num;
 
-		status = myrs_get_ldev_info(cs, ldev_num, ldev_info);
+		myrs_get_ldev_info(cs, ldev_num, ldev_info);
 		percent_complete = ldev_info->rbld_lba * 100;
 		do_div(percent_complete, ldev_info->cfg_devsize);
 	}
-- 
2.27.0

