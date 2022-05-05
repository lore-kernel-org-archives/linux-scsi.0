Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC22AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  5 May 2022 13:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380017AbiEENvE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 09:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378990AbiEENvA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 09:51:00 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085ED56C33;
        Thu,  5 May 2022 06:47:21 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id i19so8828880eja.11;
        Thu, 05 May 2022 06:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wgJcAl0zdpAYB0IRw4jP+ujI4F2jFIRqxBwg3WITVhs=;
        b=MuaSVcTMd+thraNYAa4NKcji97XxwjFN1oHZIK+EzVi6hCxF4NYDaPIC6ZFNASNAwy
         7mVmJvI6S0gT4ndvD65Y5hWOEnSfvBu5FNW63ye+F1HuQB3Rzt4XfXDCxJVE3BtAoB/b
         98bk6RV54sZq8NySLiAuGb6emx3nNqLX1wurZTmCHveYWEqxiIHP002SShjvC+wdGCtI
         TW0rGGycs/C5X4DAaLfmN3eWVacvQg1IrgRnZO6gVMAnjB2EhZ7uWSqW36GzfA+A4TQ1
         LRji3bnPc3qFCRjEbGwHgICsSz2DwePH9g9DK/Pubbh76cV5yfN8EM6RI9gpPbpEiIhD
         HPyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wgJcAl0zdpAYB0IRw4jP+ujI4F2jFIRqxBwg3WITVhs=;
        b=mOreMok/0dH86n9GliBpHNAmd3erb1V4NeNheQFtcyvcrEAYZSA6n0s+M8TedSE04D
         HxVRNhD3TlFEsEsN9edpPZMtj2uWiKYUhnY2O/rIql3FC+XQJocirGHLVfgAg7o361k8
         Q9lMW+apMqe0eCwPfIFGPNLDjYaf8eenvonq4w1OMxnWp75v8MvHIzHIFgOpGGJ4r6IT
         RUfdTBQ4bkUaV9EnDXEdmS9fT5m7qI0p95mHVaLh6ts81lLnankrH4adzzdyglRtEqcy
         9XhlCF+jABpQ+gj+5wfSEZtMABvPPs2DLLqGBc5jUF7PaafPdsvjl71hCQND0eo6fITy
         QFpQ==
X-Gm-Message-State: AOAM532l/ImmZ/UoMeFGq0pfm3vpKkbr5WZDsPdPBaYB5d2Wc0OrMaxN
        GSEUNbpmHoR0omb4Ez1GacI=
X-Google-Smtp-Source: ABdhPJxORWKnRfcZPZwwnLI1KSyTx5JbDcA6A9ooISwo1rpw/WSqWqEBcp9Dga4hYHkL8slA/eCFzg==
X-Received: by 2002:a17:906:2652:b0:6f3:a042:6b51 with SMTP id i18-20020a170906265200b006f3a0426b51mr26415172ejc.565.1651758439635;
        Thu, 05 May 2022 06:47:19 -0700 (PDT)
Received: from linux.. (p5dd1ed70.dip0.t-ipconnect.de. [93.209.237.112])
        by smtp.gmail.com with ESMTPSA id 26-20020a170906301a00b006f3ef214e69sm728324ejz.207.2022.05.05.06.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 06:47:19 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com,
        peter.wang@mediatek.com, powen.kao@mediatek.com,
        keosung.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/6] scsi: ufshpb: Remove 0 assignment for enum value
Date:   Thu,  5 May 2022 15:47:03 +0200
Message-Id: <20220505134707.35929-3-huobean@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220505134707.35929-1-huobean@gmail.com>
References: <20220505134707.35929-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

If the first enumerator has no initializer, the value of the corresponding
constant is zero.

Reviewed-by: Keoseong Park <keosung.park@samsung.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshpb.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 7aa0dc58ee9f..b83b9ec9044a 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -59,8 +59,8 @@ enum UFSHPB_MODE {
 };
 
 enum UFSHPB_STATE {
-	HPB_INIT = 0,
-	HPB_PRESENT = 1,
+	HPB_INIT,
+	HPB_PRESENT,
 	HPB_SUSPEND,
 	HPB_FAILED,
 	HPB_RESET,
-- 
2.34.1

