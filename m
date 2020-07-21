Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6203BC433F1
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40C35207BB
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QnpTahW5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730470AbgGUQoh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730516AbgGUQmJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:09 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344F4C0619DA
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:09 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f139so3530686wmf.5
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U4057VEQknR+gIhh04CnggTUTUY/8B8thVt6VLtwHGM=;
        b=QnpTahW57R2FYzZg5OTn+jcF7DBe+JUfkRNtuX/j6vG2VdCGebKk+uprWqRD3AQPIW
         ckJNHjucJKxw8tmkIMiaubdO8mTyW8pP2rVfkXYaoX84NHjQ9q6Mtburk2fuJm0M0FMs
         /i6t127QWh+yBV/n66Lws+cepy+3id+i35GSOpRdU0o3kBSkSMY6LrXRyuesjKFwk52K
         RBBedq5iblML9Evk7n1yVEXEQ/KNHcu5ieB8Rld2MHzWxcIx07pJvnxfLM3G6IyTU0xK
         DKFaMWRC5L6hs3kWWaRIREs8NUak0Cz1qQw5/Hri6CcXTsJAI5I5lODXfkoSBJhZEEET
         2G4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U4057VEQknR+gIhh04CnggTUTUY/8B8thVt6VLtwHGM=;
        b=hPnlFD282LnOHC4/fC0+q6aqT77QfGpp1R/LMKsTcgezelx/Y1VuE8V+xTOhxWTnpe
         BjdJrJcvK9vQLO55S3rKglUh3Ft8UHP/cj4daEB4k7/jFX92c5+NWqqesoatf2/jvwTW
         0+oC0yvJ4XEelYe++uj+0WU+8ssR9cb2fdDBP3IzS4kbEvJJ9Wfhk3Ew4bBbkcouc6aj
         XPmx67YJq8XfHZ1PTQEb3ReQ3xuDydxYOyoXLyyJc+o7CZP40TxuThoeVIDd5+An80nh
         5oYpTH7X6i/RBJFj53k2gIHjnnqypXV+n/UP1gOXZGAUtqFsfFcDA/l7ncS5A1pmVhgg
         C02w==
X-Gm-Message-State: AOAM531vMBJkAhqHY/8F571PQOjhHHrgWxBg0K8Sn3nZSznZ8TcugRBw
        T1gO9IEbXdII5v273OBB5GlYeA==
X-Google-Smtp-Source: ABdhPJzrnwafVPORG1U4Vm6Oo3cqf4RKcBMVvuECB86C2Exrw3p7dALwOlz4y3sFIDuWRdtAM+zaMA==
X-Received: by 2002:a1c:3954:: with SMTP id g81mr4796624wma.73.1595349727915;
        Tue, 21 Jul 2020 09:42:07 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:07 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 09/40] scsi: pm8001: pm8001_sas: Fix strncpy() warning
Date:   Tue, 21 Jul 2020 17:41:17 +0100
Message-Id: <20200721164148.2617584-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We're assuming that the string should be NUL terminated here.

If not, then memcpy() might be more appropriate.

Fixes the following W=1 kernel build warning(s):

 from drivers/scsi/pm8001/pm8001_sas.c:41:
 In function ‘strncpy’,
 inlined from ‘pm8001_issue_ssp_tmf’ at drivers/scsi/pm8001/pm8001_sas.c:919:2:
 include/linux/string.h:297:30: warning: ‘__builtin_strncpy’ specified bound 8 equals destination size [-Wstringop-truncation]
 297 | #define __underlying_strncpy __builtin_strncpy
 | ^
 include/linux/string.h:307:9: note: in expansion of macro ‘__underlying_strncpy’
 307 | return __underlying_strncpy(p, q, size);
 | ^~~~~~~~~~~~~~~~~~~~

Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index b7cbc312843e9..941f783897d8e 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -916,7 +916,7 @@ static int pm8001_issue_ssp_tmf(struct domain_device *dev,
 	if (!(dev->tproto & SAS_PROTOCOL_SSP))
 		return TMF_RESP_FUNC_ESUPP;
 
-	strncpy((u8 *)&ssp_task.LUN, lun, 8);
+	strscpy((u8 *)&ssp_task.LUN, lun, sizeof(ssp_task.LUN));
 	return pm8001_exec_internal_tmf_task(dev, &ssp_task, sizeof(ssp_task),
 		tmf);
 }
-- 
2.25.1

