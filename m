Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A151C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 06:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCA2664F6B
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 06:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbhCSGxa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 02:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233818AbhCSGx3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2021 02:53:29 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8171C06174A;
        Thu, 18 Mar 2021 23:53:29 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t20so2512129plr.13;
        Thu, 18 Mar 2021 23:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3pNQHIB8THzQo+YXqA14LvlkiUNLJvfkX4mQllvTqn4=;
        b=HYaOl0UwmSnfFuGF94pJEju9/4fil/0jPyeENRiCgPr4Nyfc97hm1tkZhY3g9MwrDm
         5J+vhrdLkKbblDlPYb2V3gJdxrp1pfNbS+d9qDBGchxkFgM7M+Gnaq2p5okHCkUfhTnh
         qMddatOjwkI2itkScURAlkXc7jCWNbpNhy1GbRg7mufqiM1IwSRH9qWfWAX7yjrBTfGQ
         1SEPx4bqaRFnWjcPVprhrBv9rOYPrKV9+o56QCm9QNaf1/tBmAp21pAIqn7brO6B5I6Z
         PfjjHwA8UQ1PdYbPffKCHRoXd8Su+cW8/DJJgn96fCGRPi6TOdu0VkxPNW1FXhxNLn/C
         AL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3pNQHIB8THzQo+YXqA14LvlkiUNLJvfkX4mQllvTqn4=;
        b=dHWyET7a3ehAKesnBGJyn/prKzaQidcsK/ZbmacHU+TBSOx4n0j5kEjKH6Ibv4V/6r
         AB9Q9sxoVUE1Evor/ZmmrmgOEmssLZst8OZgduzxxXXxFepZ3R1kGkeovvd32E949rmd
         qI9cgrYerZ8PSwiglrKwUwJIS8LN0uP0SRYPBJyv/1hOPAevoOvTfra2io3SfIRWzVwV
         XFmlgMfslQm4CTxkjG9Ht/4LCI2dF0N+a5phJidPpvoiDj58F54C2v/RkZ4rK4jSbiSP
         aVqg1lSQ3y1kCNtOUvrt12ESbjk6VOgniq/d+k/sxj+Bc1/Ns/v97zCAtO0ZJFn+ON0I
         6r/g==
X-Gm-Message-State: AOAM532pdaqR2kuXEYCnysg1IhDrmaB0r2Le5MQ0HBl71cyW+2cQaUC4
        Mr95nUNU3FwvBd4rn3xMLo0=
X-Google-Smtp-Source: ABdhPJyOVo1RiJxFTxSlNAvIFd9RTdVhnl/PX/DW8fNik+MixSmamHzlIwH8cOI2nl4jQsj3yd2CdQ==
X-Received: by 2002:a17:902:da81:b029:e5:de44:af5b with SMTP id j1-20020a170902da81b02900e5de44af5bmr13365391plx.27.1616136809190;
        Thu, 18 Mar 2021 23:53:29 -0700 (PDT)
Received: from tj.ccdomain.com ([103.220.76.197])
        by smtp.gmail.com with ESMTPSA id g7sm3809659pgb.10.2021.03.18.23.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 23:53:28 -0700 (PDT)
From:   Yue Hu <zbestahu@gmail.com>
To:     martin.petersen@oracle.com, avri.altman@wdc.com,
        jejb@linux.ibm.com, alim.akhtar@samsung.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, huyue2@yulong.com, zbestahu@163.com
Subject: [PATCH] scsi: ufs: Don't check UFSHCD_CAP_WB_EN capability in ufshcd_wb_toggle{_flush}
Date:   Fri, 19 Mar 2021 14:53:05 +0800
Message-Id: <20210319065305.2188-1-zbestahu@gmail.com>
X-Mailer: git-send-email 2.29.2.windows.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yue Hu <huyue2@yulong.com>

There are several redundant calls to ufshcd_is_wb_allowed() as below:

ufshcd_wb_config()
  |-> ufshcd_is_wb_allowed()
  |-> ufshcd_wb_toggle() -> ufshcd_is_wb_allowed()
  |-> ufshcd_wb_toggle_flush() -> ufshcd_is_wb_allowed()

wb_on_store()
  |-> ufshcd_is_wb_allowed()
  |-> ufshcd_wb_toggle() -> ufshcd_is_wb_allowed()

Considering code handling in wb_on_store(), let's remove needless
ufshcd_is_wb_allowed() in ufshcd_wb_toggle(). Meanwhile, keep the
check in caller ufshcd_devfreq_scale(). Accordingly, also remove
the redundant check in ufshcd_wb_toggle_flush().

Signed-off-by: Yue Hu <huyue2@yulong.com>
---
 drivers/scsi/ufs/ufshcd.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b6bfc80..ee71cba 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1260,7 +1260,8 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 	/* Enable Write Booster if we have scaled up else disable it */
 	downgrade_write(&hba->clk_scaling_lock);
 	is_writelock = false;
-	ufshcd_wb_toggle(hba, scale_up);
+	if (ufshcd_is_wb_allowed(hba))
+		ufshcd_wb_toggle(hba, scale_up);
 
 out_unprepare:
 	ufshcd_clock_scaling_unprepare(hba, is_writelock);
@@ -5438,9 +5439,6 @@ int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable)
 {
 	int ret;
 
-	if (!ufshcd_is_wb_allowed(hba))
-		return 0;
-
 	if (!(enable ^ hba->dev_info.wb_enabled))
 		return 0;
 
@@ -5477,8 +5475,7 @@ static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
 {
 	int ret;
 
-	if (!ufshcd_is_wb_allowed(hba) ||
-	    hba->dev_info.wb_buf_flush_enabled == enable)
+	if (hba->dev_info.wb_buf_flush_enabled == enable)
 		return;
 
 	ret = __ufshcd_wb_toggle(hba, enable, QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN);
-- 
1.9.1

