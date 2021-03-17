Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF733C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F97264F33
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhCQJLw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhCQJLa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:11:30 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8972FC061760
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:11:30 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j7so1008325wrd.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bN4fpSzo8exezj3x7f+Hv5XSvvEKZvIRblLuzQg15wk=;
        b=VkIJrz36/HXe6e+FwdGdkS73nKnV9YjVMOH/+Im9wrZJGKMfaBStj8UO2zNOyszrOp
         Ed2mZ2zpbuY9dhE691tTGxUlMhqhqIT7skBo/1fYeJMmJW2DK3sEAELLkp/LYusolm3f
         qmZfeXwtXHlClMgZj0QD9srG9K1zDtA0c4OpcnrMWuCaABq1Qe3zprGSzyW3T9HfqgD6
         44cy8CqbD9mS+An7QASyBFPFeIjJP43lZxtQ7/HuaaNM32FNB3qvIZiFbpxsZf3+amiX
         ncJ7V/aBdKh6lDFrfxoYDitOTcj1HNcfYzrYqjLmEVIbkKmmgN40lGxV7OKQkupECLlJ
         8EIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bN4fpSzo8exezj3x7f+Hv5XSvvEKZvIRblLuzQg15wk=;
        b=uXv/d4CNKUG8Ona7QDnCsQhrgJLEwziD60IQYKQGrBrMNbwzUlp4o/w9qU3Xn1A0KW
         QdFnLJBrItVdsHI431BRSc4JceMi3mV2i7C8MjkZx0rRjPv5dDi2u8KqK1LabjhyDdqb
         CYjxAEDPJudrZq/a44ZjD6Wga0GzTuXjPXncvc9lkwlQyjf9m7KN894xwVX8SlrTOKfH
         oLjrG79pEuSJ0S5Q9OLpMAb/CwE199qlP+Bt9AG0w5fQZV1lUur75nBrZCLuwDYfrEQD
         OUW+ZK9zKolUuOW199FZEggG1jJ12jXR63SeRZ8rlMHAcsOvP4TIyBOA0j/RU7M8kBgl
         UGow==
X-Gm-Message-State: AOAM531sC5AjJimfQU9LjTOWW2HTIehMLCYm+6G2oSW60mM5Eq4fAeA+
        oavGyIV206h/uSBGeCJMz6JQKQ==
X-Google-Smtp-Source: ABdhPJzdUfSyxp16Fxr4les5oIJRzRmIzCuQsiDIzk7b0x1kydxLSr8PnX+L9g67uz/0ILyGmTdSGQ==
X-Received: by 2002:a5d:5906:: with SMTP id v6mr3335177wrd.137.1615972289312;
        Wed, 17 Mar 2021 02:11:29 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id s83sm1709279wms.16.2021.03.17.02.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:11:28 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 1/8] scsi: BusLogic: Supply __printf(x, y) formatting for blogic_msg()
Date:   Wed, 17 Mar 2021 09:11:18 +0000
Message-Id: <20210317091125.2910058-2-lee.jones@linaro.org>
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

 In file included from drivers/scsi/BusLogic.c:51:
 drivers/scsi/BusLogic.c: In function ‘blogic_msg’:
 drivers/scsi/BusLogic.c:3591:2: warning: function ‘blogic_msg’ might be a candidate for ‘gnu_printf’ format attribute [-Wsuggest-attribute=format]

Cc: Khalid Aziz <khalid@gonehiking.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Leonard N. Zubkoff" <lnz@dandelion.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/BusLogic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index ccb061ab0a0ad..0ac3f713fc212 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3578,7 +3578,7 @@ Target	Requested Completed  Requested Completed  Requested Completed\n\
 /*
   blogic_msg prints Driver Messages.
 */
-
+__printf(2, 4)
 static void blogic_msg(enum blogic_msglevel msglevel, char *fmt,
 			struct blogic_adapter *adapter, ...)
 {
-- 
2.27.0

