Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B4EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbiDLSZS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349095AbiDLSZM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:25:12 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567D160075
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:22:54 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id z6-20020a17090a398600b001cb9fca3210so3912442pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:22:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J/MJzNqvlCtUnHD68INLBgpjwK6/TYRS8vbqLhrtU/k=;
        b=VwZGXxJnyeSDBjmEaaDHy8W1tNIEn4zezU2EV1Oco3uBcz2CQeO7pMcNG0spx30K0f
         Oaf08Wqq78eFaKWIi6wlZFU1OQetE3BZUtz11vp/sm7S2h++mUwsJFLqhq6B+7j8XJs+
         2xoD4v8k+yZTtjlbehS2+sMvgPGNI8P5/K1bsYHpszclJspiPFOGH5Nwy93weXt3meom
         HvBDMV4ejpOiwLdX/3IY4dyEfWhi7NdVCD56Gslp7fIZ73FZeoDIxzp8WSQJIsKcvT2c
         IYDIJHU1vmS7m0nW8+AvXc3WPhQ775QddU7kttnUayQVvaMNbgrStW9s6d2hRiip+GhK
         kSwg==
X-Gm-Message-State: AOAM5330HN7yUOychABBAob/RF24v3kDNwuoxQg/vzpqoFe8enQtxj/X
        A3EMlRAfywpDowaHYFcQR0Y=
X-Google-Smtp-Source: ABdhPJxX+hV0ujRkfZ+7FmY558RtCsMEDbBBE42Y2JU63NmFpvG2Aws/SIA8wH1UEQaXGqjJgRs8Vg==
X-Received: by 2002:a17:902:9b92:b0:158:57d8:3a20 with SMTP id y18-20020a1709029b9200b0015857d83a20mr4717901plp.34.1649787773731;
        Tue, 12 Apr 2022 11:22:53 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:22:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Ye Bin <yebin10@huawei.com>,
        Dov Levenglick <dovl@codeaurora.org>
Subject: [PATCH v2 22/29] scsi: ufs: qcom: Fix ufs_qcom_resume()
Date:   Tue, 12 Apr 2022 11:18:46 -0700
Message-Id: <20220412181853.3715080-23-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clearing hba->is_sys_suspended if ufs_qcom_resume() succeeds is wrong. That
variable must only be cleared if all actions involved in a resume succeed.
Hence remove the statement that clears hba->is_sys_suspended from
ufs_qcom_resume().

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Fixes: 81c0fc51b7a7 ("ufs-qcom: add support for Qualcomm Technologies Inc platforms")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index dded29722880..98ed9e9f7e2e 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -640,12 +640,7 @@ static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			return err;
 	}
 
-	err = ufs_qcom_ice_resume(host);
-	if (err)
-		return err;
-
-	hba->is_sys_suspended = false;
-	return 0;
+	return ufs_qcom_ice_resume(host);
 }
 
 static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
