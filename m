Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF74C43381
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E33286146D
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355646AbhCDAcQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359583AbhCCOti (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:49:38 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17845C0613B0
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:47:22 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id o2so6076447wme.5
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KhH1xvkfKyHob/JVHWX/WPbUcPF6tAGWDv8dCHz7P4Y=;
        b=aztHD8iVRoFpmuHKdT4/MeQg+lOMUbxq/ZfeR5CxyTLSl8NBTnotat+PqLnXumvZlp
         M+vVkh7tXtuB0HvlDcyuWo3828I0feAqCoa8oftRH2OTGIVMR9ZuFfWCRXJ5mLkSXGnl
         rg/6YZC9jab/1cJLDlGL9Dw+VwEOe5ezTNVfBksLOE+d3pFsTL8T50cCxDzjrJPeBQ2W
         x7/ZthhURKXRI99h3ospu68ZisK+qWkvVRPczXuKofg362I5Vh9D2bGkXacfj07yj7Qg
         vMbqfaw1jq/WYEytpGSn5Uw8wLY2Pi+zh7Dohp/J0DY//GJJ+w/AFzWo8VFB+yQOsq6P
         aB7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KhH1xvkfKyHob/JVHWX/WPbUcPF6tAGWDv8dCHz7P4Y=;
        b=l6U2Y2tDqEEwlEjLbHIS0gxJog2W0sLVNy3FkIVU6uPkoUl/uO75gysJqj6xm0EtAb
         HQ5ZX+zhkfqw4eT2PdEQmqZN7mXyCjtpvNjOY1AsIXdCkZoL7DcLIxarK7UMHS8070GM
         UygJ0GYawPp017qVjQ8ugvJdQxaXZsBHMmaBXDqFB69udy9Fe708ToL/DVA2MrcXd1ru
         Mn36R6tbsTQRnhflBjDiXYDAi4s14ck2NM26APJwxIJYPlu/jpzUFWSZC5sadmkShqTj
         o5jmxFHzGVl5XH2w0p+IuHCWbkLfFl/U6MFPlkQ1omp3kXrYDwxeWmRNs3POt6tHISth
         0waQ==
X-Gm-Message-State: AOAM533vo/lpZ9XcDSV1E3EQN4kZ0vBkNUeAao1cqUHzwPffNa6TrFjy
        BuMTFHnIFT0alZecpRDybDFaaQ==
X-Google-Smtp-Source: ABdhPJwMrWETbcDsqW4KaMV/belvEGPoi8GPHErlEc6coWhJiwt+46GaHhzZ22UTHQ8ul4iKRosikA==
X-Received: by 2002:a1c:8041:: with SMTP id b62mr9856101wmd.0.1614782840669;
        Wed, 03 Mar 2021 06:47:20 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:47:20 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 15/30] scsi: qla2xxx: qla_iocb: Replace __qla2x00_marker()'s missing underscores
Date:   Wed,  3 Mar 2021 14:46:16 +0000
Message-Id: <20210303144631.3175331-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qla2xxx/qla_iocb.c:508: warning: expecting prototype for qla2x00_marker(). Prototype was for __qla2x00_marker() instead

Cc: Nilesh Javali <njavali@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8b41cbaf8535b..e765ee4ce162a 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -491,7 +491,7 @@ qla2x00_start_iocbs(struct scsi_qla_host *vha, struct req_que *req)
 }
 
 /**
- * qla2x00_marker() - Send a marker IOCB to the firmware.
+ * __qla2x00_marker() - Send a marker IOCB to the firmware.
  * @vha: HA context
  * @qpair: queue pair pointer
  * @loop_id: loop ID
-- 
2.27.0

