Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97E4C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242404AbiCaWmC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbiCaWmB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:42:01 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4DF1C2DAA
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:40:13 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id b130so877682pga.13
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:40:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hs/kv5F4yfQQtLRA7MASxT/I+Xi7z8qHp+bDF9gdasc=;
        b=ZqhDYtk/qpWvIYO6MHdy1zCboDyGaPwWXEapQL/72QthzEHFp/W4Qf5iNwt7svpN80
         AtL3gE2uA2o53inAcwiWap067WeLyclycKbWOfc+lbC8kE15JppV5rhmWJgABBJ4vodz
         MpJlW/Mw38OJSzISWj2P9XhwHBkT3Ov8wKdemU9Mso3nYCvA2UHyg1t9TU/SnchMesdl
         PGY9U7piT+1a3CbfdX0iCjMsPOtcvmnNNYtoV3JM3wepKUH43C6uRxB3XfjNf68Rs2T2
         I+bUujH0Mvo7/Wg0ZxkMN3JUGGsRe4Hcc+29HYdfgeVu2zvnM59ZtyGcaBbIvQxmcA53
         jgqw==
X-Gm-Message-State: AOAM5300KQJpkW768PVP4tjCt5mYFD6ubPsnL4rhDWPSuLtQd8gZjSLU
        vzs7VHKcKw15n7cZSpnWiJ8=
X-Google-Smtp-Source: ABdhPJxc5CGbUw8uT9eIIEqEBb2ei+vBhJQ4HTeHeZq7+AXI6L3KbQWymf8hKCnoeoxXFiMWVyrFvA==
X-Received: by 2002:a63:e241:0:b0:375:9f87:eb1f with SMTP id y1-20020a63e241000000b003759f87eb1fmr12633429pgj.216.1648766413373;
        Thu, 31 Mar 2022 15:40:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:40:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH 27/29] scsi: ufs: Move the struct ufs_ref_clk definition
Date:   Thu, 31 Mar 2022 15:34:22 -0700
Message-Id: <20220331223424.1054715-28-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the definition of this data structure since it is only used in a
single source file.

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
index bab0f1ee41e6..27738f24c4a8 100644
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
