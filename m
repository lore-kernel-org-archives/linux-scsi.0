Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1B5C43381
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 424DD64F33
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhCQJN3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhCQJMz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:12:55 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA019C061763
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:54 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id y124-20020a1c32820000b029010c93864955so2934364wmy.5
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vmhs1GwnoiVlAu7kb1g3Gxa90rFDalixOIK/s/KOHnE=;
        b=DbaKw0VJMPZu4EklwZJbn7HC7mc2LNcUskiTdj1Bmpr9nnc4e8ck82Tf3PTQv11emI
         G7YzPOxZEm8xGfmFa8AAHd7wotLOLG8M+SZkdf/ZbJu16JaIhblAuLvW0fDp7ejclX88
         7zni7JUf0+WWWDSwGrJQnPK94pVCPVAwkZ64EqdpOXx/lBmEv0x1jyNX0Q7h9gx0zBKL
         KHehJsdYnuENu2Vd1ziFe2rvWUydLFz/2d4MkNz7ExahjUxPUh/6r/Q7dlgrLTQft+EV
         Y1vf1BwT6gBuZOkWIfnvotyW243Z/n2frAvHLD885kINTjKEVehs6WZK6xk8UGk0myk2
         WrPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vmhs1GwnoiVlAu7kb1g3Gxa90rFDalixOIK/s/KOHnE=;
        b=J2C5KfDLp496wqAIv9GqpUeOU6Ynb6Y1YrlrGBwYIkZ+iVt8hrOgk4pg8qNHyazkjm
         lj5UC9hYLuZMUXugZCpYm4R7MnMh1jQ9TH0gGUF6+KZ2ATvGTHKhrLnNssSyEEBqa38u
         oivk8FHs46BTHXlp0dU39Q+5rOsnGSYGZL4STAvcGH4d4drzafvJUxVX0Y2JBvmoIk6x
         Ih/8eerrUnAvCkAqER+QTGm3++b443dKXNaEQ8A014jb3uR6jWgqDs5Up5rCmiOJsqek
         1GHGRGm2f/tyWYOlq8/Nl/2FTRD7sE5aX4CY/Dtq2ZTYWuymfLqO8jVHotiQsuYEf88C
         BsVg==
X-Gm-Message-State: AOAM532DRsGuV5HZlHtdPEr7rG9DeVYp1X5n41VT72v3w0XAq48flqhZ
        mi1IZ2AwxPlaUyKR5q6PCCz/LQ==
X-Google-Smtp-Source: ABdhPJyn5Dl4t4/JYqiw7Km1fxvkhu2T+51ibkMmREQnsN39vxMUqwkZ3swoJhP1+uD5I+XIqCt72g==
X-Received: by 2002:a1c:c244:: with SMTP id s65mr2729640wmf.96.1615972373507;
        Wed, 17 Mar 2021 02:12:53 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:12:53 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 13/36] scsi: pmcraid: Correct function name pmcraid_show_adapter_id() in header
Date:   Wed, 17 Mar 2021 09:12:07 +0000
Message-Id: <20210317091230.2912389-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/pmcraid.c:4079: warning: expecting prototype for pmcraid_show_io_adapter_id(). Prototype was for pmcraid_show_adapter_id() instead

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/pmcraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index c98e39eb04b24..bffd9a9349e72 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4063,7 +4063,7 @@ static struct device_attribute pmcraid_driver_version_attr = {
 };
 
 /**
- * pmcraid_show_io_adapter_id - Display driver assigned adapter id
+ * pmcraid_show_adapter_id - Display driver assigned adapter id
  * @dev: class device struct
  * @attr: unused
  * @buf: buffer
-- 
2.27.0

