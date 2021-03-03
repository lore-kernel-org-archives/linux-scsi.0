Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFED6C4360C
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1B0D64E51
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241610AbhCDAcI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359478AbhCCOsf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:48:35 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BD8C0613A8
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:47:17 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id w7so5391641wmb.5
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EHdWW2swQWWLN2fON0JrG3mS4u0FbNeaPrg5kb6hkWU=;
        b=PV+MriZ79UvO8Un1KZdEI7jH/TmK2pAk1bDhwBgsfrqdMEl5aZHt1iJgNEUfpiLo1V
         wMmDAU5F94CjmyJAaRirgMQwwNLOuiM5CLMYXAJQpPU/B5SCDupT7VL1EX0ZO4xiwRnd
         G4ww+yglt+l42P+MUzEyGedFGTybK2/JquvE1mC2gNnEk49ND7Ep3cFkuhVqnWGGy1gv
         zedscH0PVDB9gtw5qZPZZaPP7mWnhP9zXT8wJk5SyEyh+YQHK1DeNvD1kGzNSLpRx1o/
         RsI8JCTFXug/3DmPQLgJKRDsD2/Hufl21NeCaOQeISGiSCRe8v9ODktA7G/5FJJi/UI3
         e4Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EHdWW2swQWWLN2fON0JrG3mS4u0FbNeaPrg5kb6hkWU=;
        b=WJ95oF3sTMOe6T2aS8axfFY86jlnJJcS2ZPQddgOyJN+A7XmYbeMkfpbrsIZ9m3Ccf
         0DYTVxA1CrMQTAi0IlDjJMDKbuMM499/77QhsPDNG64IqhGuAitK+m2HmJ2GnIyTQUu/
         bj4qaHaPcZKIiNrJaYGDtgCE5wt2Uf9pmbF3ehBnnxIp/+03tx7J7ukPzmvcgN8NCsWE
         Mb9VOt/eMAo0nLo0i1BCw5wU2w+cRGaCvYa3WU9tZA95pCdM43bUvej4G3zQe8Vtmqfm
         /cl3B0o1tculoOeU6t1WKht4w6umf8xRSjSx96pTrBFeDZ4J9VpxgPSlFyHMXweJ1t6a
         vxuA==
X-Gm-Message-State: AOAM5312T50EsUvwSQd65vcg+Q3OfaO3d39haczBcbydRUhTz+ugcW1e
        ixInLTIk+azR++7GGvB/KYEckPhpO+ksRQ==
X-Google-Smtp-Source: ABdhPJwr6HXMhNS0fRSUdIbEmUeBkONMcWjvSRrkPqHtMou00uULtcanI944/JGGWrmz6LNeITwM/A==
X-Received: by 2002:a1c:8005:: with SMTP id b5mr9578341wmd.130.1614782821020;
        Wed, 03 Mar 2021 06:47:01 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:46:58 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 11/30] scsi: pm8001: pm8001_sas: Provide function name 'pm8001_I_T_nexus_reset()' in header
Date:   Wed,  3 Mar 2021 14:46:12 +0000
Message-Id: <20210303144631.3175331-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/pm8001/pm8001_sas.c:989: warning: expecting prototype for and hard reset for(). Prototype was for pm8001_I_T_nexus_reset() instead

Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index a98d4496ff8b6..742c83bc45554 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -981,6 +981,7 @@ void pm8001_open_reject_retry(
 }
 
 /**
+ * pm8001_I_T_nexus_reset()
   * Standard mandates link reset for ATA  (type 0) and hard reset for
   * SSP (type 1) , only for RECOVERY
   * @dev: the device structure for the device to reset.
-- 
2.27.0

