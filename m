Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BDBDC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242518AbiCaWgp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbiCaWgo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:36:44 -0400
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C911EDA0F
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:34:51 -0700 (PDT)
Received: by mail-pl1-f170.google.com with SMTP id x2so871249plm.7
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:34:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HP5tdaSSRZbipYzj16Pu7kPdrjFGAukXr/+nxUq3bCs=;
        b=cRoSu5oGH89xJj3lW1eSHYwdp/jgiozuBBwNXzBhcUac/cfqxaYDq/DC3BBWuDGdkb
         tophPjFsrizQq8QYNa+2s98T/y15GGBUmqkP/cin0/l09i3QhQ3uTo1r+DHDbfE0wmF8
         KRpJbn8MWHKWAq19ZSb6mCDZ0d3IGz//HeNndOfM6pgVNinAEW1RBZv37/aKkf0XZ5TI
         TxRt6IKWrTL6AakDZTvUMI+OezDSKZEIpGkVmK0wl24d7qpghzS6PDAVp9EUPF6EF1Yv
         am7oElrDdMziwtdsjhMiTTq2uHtDFQpgHakOJW6n3uuVGPIlNMqhZmxr2iKooHSD0JVt
         2tww==
X-Gm-Message-State: AOAM532yT4hZsiIVFWw+C9csGkuCWk34EXIvNTZHMC1uScLap4zLsTUL
        r5p47YCNYoHp38R5Bd5cHMo=
X-Google-Smtp-Source: ABdhPJzNSbSFaO0ALWJUpU8sH97FHapAiJCdL9pH7uQG2frPC64asQET7947Yys87L2a54ijzlmcvA==
X-Received: by 2002:a17:902:d5c3:b0:154:c472:de80 with SMTP id g3-20020a170902d5c300b00154c472de80mr7168592plh.87.1648766091159;
        Thu, 31 Mar 2022 15:34:51 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:34:50 -0700 (PDT)
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
Subject: [PATCH 01/29] scsi: ufs: Declare ufshcd_wait_for_register() static
Date:   Thu, 31 Mar 2022 15:33:56 -0700
Message-Id: <20220331223424.1054715-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Declare this function static since it is only used inside the ufshcd.c
source file.

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
