Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1568AC43331
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3B0464F45
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhCQJND (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhCQJMs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:12:48 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6D2C061760
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:47 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id g20so1017541wmk.3
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ju0nafCi1O1H+VksywNmGUTcL4SOkVENGA5NZEQLAiw=;
        b=pWT5ZE/udqJFqJG/0FLccNuDLSdqXLiitLqZdOFgO0hqwLKkt9UhHjYinOUBujTEd2
         v/mjiGlFXO+o8TM9wOckdKXlDG8XD+j0rtLpdOn/v45uM73eic62HdOQ7W2B79bY1EHh
         wqDF8Kw3KxUDs5t1GoEZ0Nll2D58WdQAtZPK2uFp2FoSugqV3J1p7MuAlP4OTGvM8IO4
         tIVXY3iHUI3pzVsnYY6Dz6PgT9CPn/cN9UxUvs/IJXq7TkkK/3j3iGAK6ZAQUMBIPvT5
         2osJrCW1aqJS7GG0EECxLHUGN3FajseSgKoMcKC1/kJ1IKsqoKIsvuzD2Q5ds4WkLRHX
         1KaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ju0nafCi1O1H+VksywNmGUTcL4SOkVENGA5NZEQLAiw=;
        b=mch7LDZ8UJmyRZcQ176QKQBnQ4IylvD+X/sdK5ZjUJ/4sSbBduZHY8VUdxeGZ8/dl4
         WD0QHG1r3OwL6aNcrH0F/7/8bUcQ+CWAftU8GMzuqkcLQSghV0APEBjWXonReOlLJ8ua
         isHb8pjXikEedIoz7VypzlX6sfnV+EGf5CKWF/EgFlU+Cf7d59jydxVeZb1MyEX/Hqrv
         p+2XDsvIjlt8uVjUGSDHrTNNeDzy4XIPXW8DqpQ1Y7QaZxK8N4eMVj/bnSA91v/4wILE
         X6WOdRo1+HsVckQ5cBzRvn1rn3sKRQPz0f6ZcLLnUw/yUmKb4jzCuZ3b5r9XSoLxYj9U
         b47A==
X-Gm-Message-State: AOAM5323XScYjk6pyGLnTQvTpk5Qg41T/To7MJ5WPfR1gUPgYSijqJAA
        EXmsonkO5LthswFtFvKaL9HAYQ==
X-Google-Smtp-Source: ABdhPJwRgswtvnRvWmFxwq4bYg9tZg2LYH4oaYC8jpe1xxph450bFliooSTjYLLfgeLKyD52PTjI2g==
X-Received: by 2002:a05:600c:9:: with SMTP id g9mr2772291wmc.134.1615972366574;
        Wed, 17 Mar 2021 02:12:46 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:12:46 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Chaw <david_chaw@adaptec.com>,
        Luben Tuikov <luben_tuikov@adaptec.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 07/36] scsi: aic94xx: aic94xx_dump: Correct misspelling of function asd_dump_seq_state()
Date:   Wed, 17 Mar 2021 09:12:01 +0000
Message-Id: <20210317091230.2912389-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic94xx/aic94xx_dump.c:729: warning: expecting prototype for ads_dump_seq_state(). Prototype was for asd_dump_seq_state() instead

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: David Chaw <david_chaw@adaptec.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic94xx/aic94xx_dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_dump.c b/drivers/scsi/aic94xx/aic94xx_dump.c
index 47a663a39dcce..552f1913e95ec 100644
--- a/drivers/scsi/aic94xx/aic94xx_dump.c
+++ b/drivers/scsi/aic94xx/aic94xx_dump.c
@@ -721,7 +721,7 @@ static void asd_dump_lseq_state(struct asd_ha_struct *asd_ha, int lseq)
 }
 
 /**
- * ads_dump_seq_state -- dump CSEQ and LSEQ states
+ * asd_dump_seq_state -- dump CSEQ and LSEQ states
  * @asd_ha: pointer to host adapter structure
  * @lseq_mask: mask of LSEQs of interest
  */
-- 
2.27.0

