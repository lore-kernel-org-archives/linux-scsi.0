Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C96EC433FB
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AF5F206D7
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S7iTBu6T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbgGWM0r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728919AbgGWMZJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:09 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF6DC0619E4
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:09 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z15so4955758wrl.8
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EocuI/v8dMGAgziexe3ETAgpgON59vWZbZOU+TdWcao=;
        b=S7iTBu6TIjSJT9lhyIg+YJr8IZo3qTqoKB4l1HwFH6Yxl5aaRRU4n+oBwQu130P2Ks
         sq2howsZNiIYBIUOPdPJjji/uqA574RfrXiW+g3GQgpongvY0tmmZ5j9GDJO5IP8N0sf
         aI+l6KjfNk3Yp+P6QIMHWINQKS94OLgynWUI4uLFXCwoovOEmUs+kLgPBMENG4jxPOQ2
         3CMxtks+EOf+T7KV/anCeQJt+/p4LoiNftuqImi2Ua9LeFcD+rx96t2pCu5DOlD1Lkeg
         WuUvgX3aTE+a2OETnGp4WsXka1VhtlCAK8zisNcSsoNizljQjq4qG9Jp8RYPPBb2rn5a
         oX4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EocuI/v8dMGAgziexe3ETAgpgON59vWZbZOU+TdWcao=;
        b=OUKEvzkkQpDOTYN2GiqESfd1/lBoq+yO7FexGM9rhKdjhX65sdzyjKG0XV+USilyPs
         c/yRiK+P6xjmp5XHt7MZ5w67HCqxmSPkxpCzo4wvXDhDiEtu9Wxh8CP3xgXyXT4r9kXw
         0bJnVwWSLUpHFlAgakUuuLry3UCK3fxzRd3hqe/Kzysa1KHrlm+4FuwxSrWZxG347dZY
         l8f6CzY8Sg9agx/pHa4gTQDjQUf4+poPe35OZrGqkRln2pVpw3sZuADaZI6vQpEmKoWY
         HlxDzB1D/u7t8URPjKtnssnIqPlfLfDLFp+Pvq94EKGBef/02uYqV37g6fDiba1ikipG
         p27Q==
X-Gm-Message-State: AOAM533X4u1wSBNuExHlCjz5TQVc6cYtQQKD1dG+o9JcMWWWEmxvt7W7
        Ds6f1SWwDw9uQzd9Yb2sskusow==
X-Google-Smtp-Source: ABdhPJyJvzXQnTwZ1RNq92ZfHV+XpgztidF3x8njT7epkUJHrqMDSd6v6B+D1Xc4vP1zy5QOwPXs6w==
X-Received: by 2002:adf:c401:: with SMTP id v1mr3678093wrf.379.1595507107890;
        Thu, 23 Jul 2020 05:25:07 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:07 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 15/40] scsi: lpfc: lpfc_init: Use __printf() format notation
Date:   Thu, 23 Jul 2020 13:24:21 +0100
Message-Id: <20200723122446.1329773-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_init.c: In function ‘lpfc_dbg_print’:
 drivers/scsi/lpfc/lpfc_init.c:14212:6: warning: function ‘lpfc_dbg_print’ might be a candidate for ‘gnu_printf’ format attribute [-Wsuggest-attribute=format]
 14212 | sizeof(phba->dbg_log[idx].log), fmt, args);
 | ^~~~~~

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 20edf001fdd97..ccfae1c0c0963 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -14187,6 +14187,7 @@ void lpfc_dmp_dbg(struct lpfc_hba *phba)
 	atomic_set(&phba->dbg_log_dmping, 0);
 }
 
+__printf(2, 3)
 void lpfc_dbg_print(struct lpfc_hba *phba, const char *fmt, ...)
 {
 	unsigned int idx;
-- 
2.25.1

