Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4FDC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3976D20738
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KrbNLXwc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgGGOBK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 10:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbgGGOBJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 10:01:09 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B6BC08C5E1
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2020 07:01:09 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j4so42841568wrp.10
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2020 07:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SuL/Iy3i9aJ7SLBRjyYkn8G6jFvDgmCt3JP0c6V0JmE=;
        b=KrbNLXwcM8rh7ttMrR97DE+xAoJyroqlKx/hR/xRcE7XSM/PPL+3Y5pbiBajeyuHjs
         iwOG7qmicRXCfX9aM5vTp+l7L0enOJ2k5L9GG2WqKPgF0X/8UFD2zr8hsrCygaQB+5ew
         g6ICyCXsMEe62zk8uaCUHebsDC0ksQJj5YxhAI7fDooRZnuS1aSUzc8Ewr+1UJNvoLnw
         nS3Pw1pCEHpHltVJxgrmzM623dDKzXOJ9U+shmarEjFRGXpWilqb+I42YqXgX13E8CJG
         KFUAi2r8sYjC2qvzSd1/gXekLpbG6wzlgphw0M/6BVGjO3F8xguuvqcj45ujKGcKIzJv
         i+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SuL/Iy3i9aJ7SLBRjyYkn8G6jFvDgmCt3JP0c6V0JmE=;
        b=TfTHEPFX3sJnBzglh8l3icD/bV+M2galq0RLt4sUSZdXPnnjCz+XkZF4OJmVNERLba
         7I7SxKC51bCV0F2QzpOStnvPARnAnGKxk/xTWFDvljo1jPV7tjSmgnem/qPOeS1UGVO0
         LcEGJaXsoWFg9ze1HjickAPOKeOEgJp33c83I42TnQDEfGrytBJPZuvjD+zqBOJDkW+U
         uc0QVD0+TZxlp5wwmcHGPWuTIzJ5QhVuUdFBQCemzsjsqOdrMJvdqAB+qfdyN0khLP7N
         VCuzBG7zFLLIhzQK8PBxNaJdHDtvFu1saDIBJ0sb1so/Xgo5GjZQJF3vt7cX/4PX95zu
         ogFA==
X-Gm-Message-State: AOAM531b2UyzPp1kNIHmehjYRpsxPKnfDAtuPe+Fr2/PT766X5OmpxFA
        F89+gNHGHRJ/oomIaeF7fS+5IA==
X-Google-Smtp-Source: ABdhPJxaRi+woMXn5JnprKx9kBC1w1ggUCROAZwIh9PhadVOAR9gFiaF++i4sJSD9Z6S4KQFuF4TBg==
X-Received: by 2002:adf:eec8:: with SMTP id a8mr54760951wrp.421.1594130467935;
        Tue, 07 Jul 2020 07:01:07 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id z25sm1102823wmk.28.2020.07.07.07.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 07:01:07 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: [PATCH 07/10] scsi: pcmcia: nsp_cs: Use new __printf() format notation
Date:   Tue,  7 Jul 2020 15:00:52 +0100
Message-Id: <20200707140055.2956235-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200707140055.2956235-1-lee.jones@linaro.org>
References: <20200707140055.2956235-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/pcmcia/nsp_cs.c: In function ‘nsp_cs_message’:
 drivers/scsi/pcmcia/nsp_cs.c:143:2: warning: function ‘nsp_cs_message’ might be a candidate for ‘gnu_printf’ format attribute [-Wsuggest-attribute=format]
 drivers/scsi/pcmcia/nsp_cs.c: In function ‘nsp_fifo_count’:
 drivers/scsi/pcmcia/nsp_cs.c:692:24: warning: variable ‘dummy’ set but not used [-Wunused-but-set-variable]

Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/pcmcia/nsp_cs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index d79ce97a04bd7..57a78f84f97ab 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -134,6 +134,7 @@ static inline void nsp_inc_resid(struct scsi_cmnd *SCpnt, int residInc)
 	scsi_set_resid(SCpnt, scsi_get_resid(SCpnt) + residInc);
 }
 
+__printf(4, 5)
 static void nsp_cs_message(const char *func, int line, char *type, char *fmt, ...)
 {
 	va_list args;
-- 
2.25.1

