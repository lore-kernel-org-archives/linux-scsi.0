Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C08C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358412AbiDSXCJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358402AbiDSXB6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:58 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB6738BF2
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:59:12 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso217292pjj.2
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:59:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=loZN4P8PpEJMzWmmaiVmJVuchCHtJ8qGAORX0RHp8rk=;
        b=4tIPld7t1qXOg0y24yaiXsQj+3EbZ5VkRgPTaCSp77gkt2UxYZ9rDIwSzze1xC8msI
         WxigR7Bq1zEdsG9xmayMg66/sgrKGF2DBAWsta8gG5J49LzM3Wcs46TPsjIpC0lbmBn3
         6YgU37THAOd902h6IKQaUj2PRskF1RCecRKulcAdKIqIq7RO3FQvOXd8/QQYBCrjJmdN
         5z/gOD1BGOv7LbxLfyOSNG8eKKYeeLr0PZD/OrP9CilswF4nIzvEP3wC2U8fmTWPMVeQ
         bLDZdG1/JgWtsfalZknGDZU9WP0/wyQUZZf4UtH29OdrNYgpmiT3aTVQswjsI23iH5qb
         JrKw==
X-Gm-Message-State: AOAM530OPBGJk5un8mxLCyXf6Ep80tx4egkNgezRcG0rAkkJOnApQX5e
        12vyVJFS7k/TKmoH0DL9j7Y=
X-Google-Smtp-Source: ABdhPJwQjdl1VH0HPRKVMbVwOHvEwfkK3mKKQi+SZhKr78C2j36HRy7pZJQ6SYeyVCfFLMJxfHNo9Q==
X-Received: by 2002:a17:90a:1c08:b0:1cd:474a:a4f8 with SMTP id s8-20020a17090a1c0800b001cd474aa4f8mr994665pjs.82.1650409152206;
        Tue, 19 Apr 2022 15:59:12 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:59:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 27/28] scsi: ufs: Move the struct ufs_ref_clk definition
Date:   Tue, 19 Apr 2022 15:58:10 -0700
Message-Id: <20220419225811.4127248-28-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the definition of this data structure since it is only used in a
single source file.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs.h    | 5 -----
 drivers/scsi/ufs/ufshcd.c | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 225b5b4a2a7e..f52173b8ad96 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -415,11 +415,6 @@ enum ufs_ref_clk_freq {
 	REF_CLK_FREQ_INVAL	= -1,
 };
 
-struct ufs_ref_clk {
-	unsigned long freq_hz;
-	enum ufs_ref_clk_freq val;
-};
-
 /* Query response result code */
 enum {
 	QUERY_RESULT_SUCCESS                    = 0x00,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index da8beed2767c..198bef3eb4b2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7959,6 +7959,11 @@ static int ufshcd_device_geo_params_init(struct ufs_hba *hba)
 	return err;
 }
 
+struct ufs_ref_clk {
+	unsigned long freq_hz;
+	enum ufs_ref_clk_freq val;
+};
+
 static struct ufs_ref_clk ufs_ref_clk_freqs[] = {
 	{19200000, REF_CLK_FREQ_19_2_MHZ},
 	{26000000, REF_CLK_FREQ_26_MHZ},
