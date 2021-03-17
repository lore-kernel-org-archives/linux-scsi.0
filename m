Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11FEAC43381
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE50164F33
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhCQJLy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhCQJLe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:11:34 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14AAC061762
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:11:33 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id r15-20020a05600c35cfb029010e639ca09eso2949310wmq.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RHS0YjWdwFJSN1VWVbYNsptYDs5Fwc3UmjtJJxuBnoI=;
        b=MjWxRv6k5hwZ7z+yy2GEto8m0k1ZTUoQHP4n+U62lGEzb55ZY8hmVQdepdlLI8bOCS
         vqOfFQpyywjCJk49Dt2+D0lFqtkpSvO44Po84uDduEu2INKSYC9hkniJsmSObBtinMi8
         IHtWrXlK0LGbg+hDra/UnyBbhh9yCHwF4V133NENV0Tvi9xY5OKTeE6wrlP1bHtfuKGX
         7P3LRKNeAkzJzpthui5wmwBWpLuKauVWmtg291gSkziJMTbFUah+20zXjeZXsgpazPAS
         oSjVRW59brJkF13KhMcfNg1qiIDNad4hl2belSbdcRhrs8H1pMFq2/pE9CHFw+kh2+Aq
         TxEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RHS0YjWdwFJSN1VWVbYNsptYDs5Fwc3UmjtJJxuBnoI=;
        b=LUVdaw200G8+ULCTk2ytuPhT71oB6hCPoGRoiHRtCZL30nwZz/hr44Ib26SFIVbY2l
         yvEL30ZD5y6tpOoEfvnMFCSZDf0r7PsG25TPvk2Gdg0NULiajBiCOFwGSIvOOFBmwHRu
         54LjXBEDSyYVM9wTdZlJEXRMZbH18i/r4912Mv1NLueczGvnqQjj3gmTGzUWshT/MgsQ
         E3VKhoGlPbYVAmNR+uwJpNRDjWtLaI3WmFc2aa6kPlN30aZwPg8W5+i9Q6U/bOPRxmRZ
         Cg0IMQ27GlC02PbzidhPvIMFOzta7QBZikDz0VWYF/w5FJOXa0RjBvaEjkd6vm1UlFML
         ubmA==
X-Gm-Message-State: AOAM533wxzwb8jOjJEV8s3C057y2+RJsYS7FKUT0U72NixcvnELpoqnv
        Kn+EFxIGk5U2SERrJ+jxKCsKtg==
X-Google-Smtp-Source: ABdhPJzmRudb3r2YxFsn4gf3SfTw9ZYImzroHS1YjbgsqyqNqSNfYauD1RL9/MKHGVWgFWjyqqpMSg==
X-Received: by 2002:a1c:2857:: with SMTP id o84mr2675735wmo.181.1615972292529;
        Wed, 17 Mar 2021 02:11:32 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id s83sm1709279wms.16.2021.03.17.02.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:11:31 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 4/8] scsi: FlashPoint: Remove unused variable 'TID' from 'FlashPoint_AbortCCB()'
Date:   Wed, 17 Mar 2021 09:11:21 +0000
Message-Id: <20210317091125.2910058-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091125.2910058-1-lee.jones@linaro.org>
References: <20210317091125.2910058-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/FlashPoint.c: In function ‘FlashPoint_AbortCCB’:
 drivers/scsi/FlashPoint.c:1618:16: warning: variable ‘TID’ set but not used [-Wunused-but-set-variable]

Cc: Khalid Aziz <khalid@gonehiking.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/FlashPoint.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index f479c542e787c..0464e37c806a4 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -1615,7 +1615,6 @@ static int FlashPoint_AbortCCB(void *pCurrCard, struct sccb *p_Sccb)
 
 	unsigned char thisCard;
 	CALL_BK_FN callback;
-	unsigned char TID;
 	struct sccb *pSaveSCCB;
 	struct sccb_mgr_tar_info *currTar_Info;
 
@@ -1652,9 +1651,6 @@ static int FlashPoint_AbortCCB(void *pCurrCard, struct sccb *p_Sccb)
 			}
 
 			else {
-
-				TID = p_Sccb->TargID;
-
 				if (p_Sccb->Sccb_tag) {
 					MDISABLE_INT(ioport);
 					if (((struct sccb_card *)pCurrCard)->
-- 
2.27.0

