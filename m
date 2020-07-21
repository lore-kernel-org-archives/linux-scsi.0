Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554F8C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34B7F207CD
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WlD0Nb67"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730525AbgGUQmJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730415AbgGUQmH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:07 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE28C061794
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:07 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f139so3530572wmf.5
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7sxu1jbEWn+xKjpwedzdpJeBJH9YjYJe8NW/889Oy78=;
        b=WlD0Nb67gecFuk9T7JfSK7LTEGWK3GJqExw+7Oa3stNXp06OVJG4wM6Oo5ZjpVuFFU
         qrc8bjZnaNp87YuUrl3b8g27g+iNBsyGynBkEYgUqo0iv9vBzAclZIbuOmw+jPa1YAsC
         hd9LtS67R/uX4bXSqOdA/8OvNhcMtg/mBIrEu6jJNf63PovkLKPNvyGJ1HjiKf+3wS7H
         DIDAvWzUqhMubTugTbQVJjK2rD9IiZM8j0+qVR7dX4WPPBXPHxKWcETltMcpM8xpFfie
         ke6LUacPgzj0QNz+xSckGe0G5J5EAR3RbEANwSecvJO/2Pm2REmKz6jBlPMeFYhkwA2U
         KggA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7sxu1jbEWn+xKjpwedzdpJeBJH9YjYJe8NW/889Oy78=;
        b=jkk+cUED9UR6U7Wk36/NurKzAtbru6ckYDKtDgCY/W7vOMM8iAo+krjZmeYHA+BaZt
         XoJp8pXrDctvQJAGPLCVCZCzibVGliUp2+YMMhhIdiW2TAMd01ve4t4MsF7cjY2iNSGu
         dD3YSHwnyq9p7C0iznTerHt+GGqh65nqnwW/M6Xvg759BaZlzmnVyPnWFDXqo2FNMRQ2
         v9suT1EQS+8avaPECMEFcG1rF03izrrFaphlArrNxubeHpK3OMAL0v3T+nFMpHz83j0x
         HpLdqcN+f1jckKUiUebi+xLrH+ySlhJDj7ndNpiAMOcnCOg5I/nWOwq/3ZAtc2+U6K0j
         yNSA==
X-Gm-Message-State: AOAM533O1LoCFe5dB0XNfnfgM9q8l5rBBZ2G+E8AFzOtHSU8njVd3vLF
        fxEvBOv4i1Rogx7NXSoaArvwOQ==
X-Google-Smtp-Source: ABdhPJx0EfRcZV6tPKftma2BQ9N918h1qoeUPcy7BWvDrf1KPUNqlWhjsZjklzXyzDRQR7plJnOJTQ==
X-Received: by 2002:a1c:5ac3:: with SMTP id o186mr4780211wmb.39.1595349725986;
        Tue, 21 Jul 2020 09:42:05 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:05 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [PATCH 08/40] scsi: aic94xx: aic94xx_tmf: Fix kerneldoc formatting issue with 'task'
Date:   Tue, 21 Jul 2020 17:41:16 +0100
Message-Id: <20200721164148.2617584-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Kerneldoc expects attributes/parameters to be in '@*.: ' format.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic94xx/aic94xx_tmf.c:685: warning: Function parameter or member 'task' not described in 'asd_query_task'

Cc: Luben Tuikov <luben_tuikov@adaptec.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic94xx/aic94xx_tmf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index f814026f26fa7..1fcee65193a33 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -673,7 +673,7 @@ int asd_lu_reset(struct domain_device *dev, u8 *lun)
 
 /**
  * asd_query_task -- send a QUERY TASK TMF to an I_T_L_Q nexus
- * task: pointer to sas_task struct of interest
+ * @task: pointer to sas_task struct of interest
  *
  * Returns: TMF_RESP_FUNC_COMPLETE if the task is not in the task set,
  * or TMF_RESP_FUNC_SUCC if the task is in the task set.
-- 
2.25.1

