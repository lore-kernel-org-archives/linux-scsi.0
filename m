Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47CDCC433EA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 268532080D
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="m9JWVP+m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgGWMZE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728898AbgGWMZD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:03 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36CEC0619DC
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:02 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f139so4997922wmf.5
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RyWxawKp9Typ2OK2kYwM9lNUQGGOHxUK9uVUiznh4iw=;
        b=m9JWVP+mBsEvLIFtV/f+vnUB7TStzaLFXhdln3XW9MyO5nMKj0mhqVrEsOr3/72ZOg
         D/gGVJfmAT1LBe8gluCI9Rj5JyMXIy/ch7m3aFLuSg8qzbymEE8ZtshvIfPebbZmdVzH
         Guu3lK4HK0mbufcMXCqgHPttP6wxh6tQAxmyzvhsjKYcqx0zCuQppXVov3h8yhGIz0s4
         9oZKNeheT38TzMxfXcm3DNYW2m010bQqp55Nz+KfdC2YevYApztjwcNRhISXpj+aNryK
         b8B4XTvhcKZF8wa8WHDgpqZ7eCVDFiIqlx/dKmcvgw3hk2PrgHXI7egNAByIHcbGXRwK
         zASw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RyWxawKp9Typ2OK2kYwM9lNUQGGOHxUK9uVUiznh4iw=;
        b=ttjYQiOuHeh4JkN1BZmpoReL/MiR/gwlpZz5Be1gQdfDTn18tKEL6pNlLUZutpQzlx
         4yQ34Vi8tJ5UsdHHOHjm/ZXxaC2QephWQ2OlDZ+/ZE6arN2yiDcI5u11BzUUjJViGf3k
         W3eQXjTRmoZZmNAoAVoUBuD3oCRDzGRBUZh4bICV698hObCVmUdEj+pMQVMocvk6RYIn
         QNIGz+Gxld74FjPzA01j0GJN4+kU/wiMCy3bkqN9i65YJhLs0dJiaH4MWZmYR5qwZ0eH
         8Yde28WtBdfoJQnLrlE8nyVC7wD0FgvtDNHDcrUnA4TWr4jW9nlpkzfn62Acg11fJSeg
         iDNQ==
X-Gm-Message-State: AOAM531fK96LU7KE66zYgdoLdMYJikmSKDKHCM0qBHqGo+5crDXnBlGL
        Nqw6BKkl5no4DHggFpkNImD0fA==
X-Google-Smtp-Source: ABdhPJyWYbvequ+SPWxMPfV21jB7z9+Xdz0970BgnkdBLiAkCSe0A8XOOpulClfgQGvnYSA5HZfnow==
X-Received: by 2002:a1c:14e:: with SMTP id 75mr4153379wmb.151.1595507101637;
        Thu, 23 Jul 2020 05:25:01 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:01 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Subject: [PATCH 10/40] scsi: bfa: bfa_fcpim: Demote seemingly unintentional kerneldoc header
Date:   Thu, 23 Jul 2020 13:24:16 +0100
Message-Id: <20200723122446.1329773-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is the only use of kerneldoc in the source file and no
descriptions are provided.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/bfa/bfa_fcpim.c:3829: warning: Function parameter or member 'bfa' not described in 'bfa_fcpim_get_throttle_cfg'
 drivers/scsi/bfa/bfa_fcpim.c:3829: warning: Function parameter or member 'drv_cfg_param' not described in 'bfa_fcpim_get_throttle_cfg'

Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bfa/bfa_fcpim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index f6bf24084a47a..29f99561dfc3a 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -3812,7 +3812,7 @@ bfa_iotag_attach(struct bfa_fcp_mod_s *fcp)
 }
 
 
-/**
+/*
  * To send config req, first try to use throttle value from flash
  * If 0, then use driver parameter
  * We need to use min(flash_val, drv_val) because
-- 
2.25.1

