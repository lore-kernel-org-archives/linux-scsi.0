Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 639B5C433EA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41B69208E4
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Phg9qHMV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbgGWMZj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729119AbgGWMZi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:38 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7A8C0619DC
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:38 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id y3so4978809wrl.4
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zt4gQ5fBquDOsunevc+xn2q97qXGNvH/uHrfGiyo69A=;
        b=Phg9qHMV73qlHdXhbakwTt6Vb+7ozqNYazBc72hJL/WdpwWv+ovB7Llu1p8IIVxpt3
         qSeAXsvji3rtYgDMJT+kESSiOxr/HYE8PLq4UpveLCEf2NBvWTmCHkuSWVgH34e5NXpn
         nxhFDKkQptRrXCFT7j1+Fpcf3CG6/cQAi9S5fJJlhJW1GbU37o5rT6rGyx44X4pnH1iE
         kYn2fVn0+Jfa74Qvn/Cl+jYSqWly6gPiel27OMYykJ1EkP7rciIe0IOOBaMHYoJxyF+b
         ShVbMaJVKAJNpjzXMgMZtwTzmdYTKYk+rqBSpG+EDKiIm3IIVmoA0/ONF2nflNJIHgjs
         5K0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zt4gQ5fBquDOsunevc+xn2q97qXGNvH/uHrfGiyo69A=;
        b=j79Ee3yR3yEVMBk4md9iC1N386KtL+EAaPU5yhQIqLvm2PCkyZKmM7ktxSVfgg2146
         gPCafXfJmCwPVOfranqv1fnc4qn7J+QHqTlu+uwgIwk9AdX/42F4aal9lP1eazmrUxMz
         xGZY6o07wfw9YSXhHfSM/AXsRRD2hRTmfxdrGtQM63UPOCYHcwLbOmGDeNW+FiGcvpC4
         GrBXiJOhofHZNUH59jUmsohOgh9cr/D61E4ibBXpZ3+jUSMcz20CHz2x2L9jq0oImeMT
         20JOHYu66YIuORglUa3CYqd4NoFIMmvfrPZ4Sm06QidR/NTh2/Q7coUY1Yq+FvpYc4+u
         iXCw==
X-Gm-Message-State: AOAM530RgI+RZiUPdh5oUylqbDWZnAdkPIwvi9DKFA/ocJlUYrBXssjm
        jsdcEscPsNHIylLWWO18HmVAnQ==
X-Google-Smtp-Source: ABdhPJyfTicJl5ewFF503iUoLLoflgMDe4eIajSk2w6TXoQayLk/F7If1jxpAb/Ef4jZheNv4PAA4Q==
X-Received: by 2002:adf:fd41:: with SMTP id h1mr4146529wrs.124.1595507137010;
        Thu, 23 Jul 2020 05:25:37 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:36 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Subject: [PATCH 38/40] scsi: bfa: bfa_ioc: Ensure a blank line precedes next function/header
Date:   Thu, 23 Jul 2020 13:24:44 +0100
Message-Id: <20200723122446.1329773-39-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following checkpatch warning:

 CHECK: Please use a blank line after function/struct/union/enum declarations
 #129: FILE: drivers/scsi/bfa/bfa_ioc.c:6913:
  }
 +/*

Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bfa/bfa_ioc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index be48a7e31e803..dd5821dfcac2d 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -6910,6 +6910,7 @@ bfa_flash_read_check(void __iomem *pci_bar)
 
 	return 0;
 }
+
 /*
  * @brief
  * End flash read operation.
-- 
2.25.1

