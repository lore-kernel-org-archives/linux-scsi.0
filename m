Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EFDBC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 23:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiGHX6B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 19:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGHX55 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 19:57:57 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEC864E20
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 16:57:56 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id h19-20020a9d6f93000000b0061c1ad77d5fso264081otq.6
        for <linux-scsi@vger.kernel.org>; Fri, 08 Jul 2022 16:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tWF/s9fPBWfw5t609Fn2UK+Vk7f88dQdzrSOQJuRbMo=;
        b=sZlMvWRLQe30/XJ0aLol9/n5HlBPhw2IW0PLYT07CsN/xcCztxNCC87uQMOOnYXU9M
         g36FZIriTtbmenTISxgRuqKawPOblsdV6Is5zNzLZ0Ucny9htBl9ljNDxKSev/1zv2Vg
         kBgC3ZV2UMqY5EZIr+RSXX8OaqtjprKSrePRSlovdqXOIlEIlCAxtCYgSia2OukXmc9Y
         x/GXyaDoO8GrcSTedfor1w3QXi6VFU0Y3xSNr/P8u7nnAsiJjB/CwhaGA9q9Dw0Pslc5
         t62FZAD21Y5y+M+O912z0fCD0k+XE51+nSb5cW8B6f/Er3Hy4ivaaB1yMpoFo+ylNyoJ
         9IMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tWF/s9fPBWfw5t609Fn2UK+Vk7f88dQdzrSOQJuRbMo=;
        b=JbQmzj4Ey+STL4eWabLyT8j5K2TjFJFJm41zo2XlqfoBwIAvq00rhOknuQmWWONXuQ
         dcT2CJP8ow6U0JxV7IoiuRyZbjOGiYGgBkgCHLq05N1ZO3HLMPnUQk2ITJmhopRNrVu1
         W+0TDK7crU6IdSU46klvMYO1CkatSAXDlc5MKXSrrzQk58TQAo/qqaSQdGB+9MmnvMFJ
         iHHfpjRTmzlLQZk5MegxNv0VyufJad7aJr+z5iJ9hWOODy7vLH93h3n2qQQ1RN1iOTul
         6qTD0DejzIq70zpE/d4635Ldr2UXgZ4ljblKo+OL7UGgaa82LvSRP/DaQR2vW3gJpL63
         319g==
X-Gm-Message-State: AJIora9EVy7EloRyGXdJEzE5+/GzMmeeB74AE60Ry3l8QHTyTW5sC5u0
        VSAFAIUpIWMKme+3bF2+nnDdxw==
X-Google-Smtp-Source: AGRyM1sayYZveNaBAdkzox5wgW0QyMHzCBPj+d8pjevlxGkJlR44N1/sjrM+bBqpGH8+0D35Q4Wqng==
X-Received: by 2002:a05:6830:418c:b0:616:8635:4b26 with SMTP id r12-20020a056830418c00b0061686354b26mr2709612otu.12.1657324675653;
        Fri, 08 Jul 2022 16:57:55 -0700 (PDT)
Received: from ripper.. (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id cm12-20020a056830650c00b0061c2edb5117sm176907otb.1.2022.07.08.16.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 16:57:55 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Yue Hu <huyue2@yulong.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: ufshcd: Drop loglevel of WriteBoost message
Date:   Fri,  8 Jul 2022 17:00:27 -0700
Message-Id: <20220709000027.3929970-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit '3b5f3c0d0548 ("scsi: ufs: core: Tidy up WB configuration code")'
changed the log level of the write boost enable/disable notification
from debug to info, this results in a lot of noise in the kernel log
during normal operation.

Drop it back to debug level to avoid this.

Fixes: 3b5f3c0d0548 ("scsi: ufs: core: Tidy up WB configuration code")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 22042ee3af14..be65d5bf123e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5747,7 +5747,7 @@ int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable)
 	}
 
 	hba->dev_info.wb_enabled = enable;
-	dev_info(hba->dev, "%s Write Booster %s\n",
+	dev_dbg(hba->dev, "%s Write Booster %s\n",
 			__func__, enable ? "enabled" : "disabled");
 
 	return ret;
-- 
2.35.1

