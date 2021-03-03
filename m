Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06530C4332D
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0C5764EBB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348203AbhCDAcP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359542AbhCCOtN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:49:13 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD37AC0613AE
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:47:20 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id e10so23731354wro.12
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=03tsdJPhWuYiSI0vJFPWzGstz88JASegtGpotthaiZA=;
        b=fxop5XSojvd0qLVyjl9NSYYbfO289XRBh7TnVKZ8AUP7qlQqhkVMDCsaBbmh1o8N1m
         IZTj/mkXgBPTbgHCOzPwMYut7OGfeTAOa9Fwj5DTRahGmahmNp885YfS+9T7Ja7hlRth
         gNpliWedUAWddaYJVPX+f6aJ/8Paqa0l14ml083Y4hOE8e00Ecmm1mMkd3H59Sj/zTHR
         BXbCWL0jp5xZpzXPR+cdCxDL9LVTlh3J/gl8lzL87CY7TVfAw+BSPInONJe5ANgh41ID
         PnIDFaUSnAvxuVNJe8fTyKhiz7rlJjnDXG5mrvRV8Z3OkHtwivQzK4VuzJ2CBaPKYjD5
         plBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=03tsdJPhWuYiSI0vJFPWzGstz88JASegtGpotthaiZA=;
        b=USyIMomD3LH/qmE3LC3m9kPnJqkUYlDHmjZDhZnuNGZuQ0aMX9PgDJ5g0yjRDw2rjE
         x1uPuC/9fb5+PYl9v8j9Mfvd4iVSXqP0W4Lynz88qxMhcvA7F2m1GjRw4aGV1qMwS35H
         qYVjbOvHbv3oqmizSklW0qTH19cmBRVCEJENBCDumtuo635XSrKzFRaAMdSW96sXWNQ7
         gXP322HzjGlE9fzN7YCwF0EVwDzipDs7HaAHlwyfI5eCmORzc27fWlw3zzrFO6Az8ygN
         Q6ZqtL/jesfeyb8KZYcgvOVMdVwDW2Tak5F2xawbEY0nM7KBRLoP9ToaNu0Ztx6wlhJP
         CHCA==
X-Gm-Message-State: AOAM530CpYb5BBcmBVhQhNvZJCdikvLNNke3SOa/rTTFfsyhACIQipce
        BeXLPOlk4SyNdiSLWZAh+TdeLQ==
X-Google-Smtp-Source: ABdhPJxvyd/Qrr/gP4Z+wpquuQecyDRePOIyvznf9CTCYZ5472NrUWvunZfzpLhAklmGcrL1V5fIwQ==
X-Received: by 2002:adf:8445:: with SMTP id 63mr28130475wrf.222.1614782839508;
        Wed, 03 Mar 2021 06:47:19 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:47:18 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Luben Tuikov <luben_tuikov@adaptec.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 14/30] scsi: aic94xx: aic94xx_sds: Fix asd_erase_nv_sector()'s header
Date:   Wed,  3 Mar 2021 14:46:15 +0000
Message-Id: <20210303144631.3175331-15-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic94xx/aic94xx_sds.c:1253: warning: expecting prototype for asd_hwi_erase_nv_sector(). Prototype was for asd_erase_nv_sector() instead

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jason Yan <yanaijie@huawei.com>
Cc: John Garry <john.garry@huawei.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic94xx/aic94xx_sds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index 105adba559a1e..297a66770260c 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -1244,7 +1244,7 @@ int asd_chk_write_status(struct asd_ha_struct *asd_ha,
 }
 
 /**
- * asd_hwi_erase_nv_sector - Erase the flash memory sectors.
+ * asd_erase_nv_sector - Erase the flash memory sectors.
  * @asd_ha: pointer to the host adapter structure
  * @flash_addr: pointer to offset from flash memory
  * @size: total bytes to erase.
-- 
2.27.0

