Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C664C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347166AbiDSXBM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347127AbiDSXBG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:06 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2F338781
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:23 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id c23so143065plo.0
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kFrJiGoPLc1JlPkJ2qqLkZ4QwtfRPN1jzG22aAKAJhk=;
        b=LpMqQTIgbL7tZfJ2OgZcMg8dKOOHZ8xslgJc4RH9s3RK/ADPMfo+T2SDGMu6fKh6Sf
         BAsmgjy+wLYmP7WkwsPPNqdQ88Ws7kxcD9qYt9L/wi9bclqHxs3+41b3ZYLhYtRHv5p4
         /7SrNWt2Wqi/mXBszsNFlafq/oYHAJCvefaGw5Fdlctj9kLTTX/nm4mtrT7UeJIOqXyg
         Txv14HvZH/pBagpcs98OzHNMIWrHi5uo1+bgRjx46GWX8xHtoGDFpp0YuuXH7YXpY9j7
         zmDbj/AnPjtiRW2B6wZTp85vGWP1b2ktwhZ2BvZsZcjzKzddCZ9p5nh2xTj4QWHchCus
         oYOQ==
X-Gm-Message-State: AOAM533VZUed15ZFbUvYwLGF1zPmlTmErnoUf6j7JhXoQkDPZWlnLeUK
        YhrcgTJNIH7wz7j+rrJdmAM=
X-Google-Smtp-Source: ABdhPJxpuWFZ0Zh9A/v1o+e+OWV1VS4+f/1AHuigN5xnTvS6k7NTVz6OnYBqV2/EXtijo6Xa+zXnew==
X-Received: by 2002:a17:90b:1e0b:b0:1d2:dabc:9929 with SMTP id pg11-20020a17090b1e0b00b001d2dabc9929mr980995pjb.39.1650409102610;
        Tue, 19 Apr 2022 15:58:22 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH v3 02/28] scsi: ufs: Declare ufshcd_wait_for_register() static
Date:   Tue, 19 Apr 2022 15:57:45 -0700
Message-Id: <20220419225811.4127248-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Declare this function static since it is only used inside the ufshcd.c
source file.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 drivers/scsi/ufs/ufshcd.h | 3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3f9caafa91bf..dbf50b50870b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -639,7 +639,7 @@ EXPORT_SYMBOL_GPL(ufshcd_delay_us);
  * Return:
  * -ETIMEDOUT on error, zero on success.
  */
-int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
+static int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
 				u32 val, unsigned long interval_us,
 				unsigned long timeout_ms)
 {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 88c20f3608c2..949427714d0e 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1030,9 +1030,6 @@ void ufshcd_remove(struct ufs_hba *);
 int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
 int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
 void ufshcd_delay_us(unsigned long us, unsigned long tolerance);
-int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
-				u32 val, unsigned long interval_us,
-				unsigned long timeout_ms);
 void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba, struct clk *refclk);
 void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val);
 void ufshcd_hba_stop(struct ufs_hba *hba);
