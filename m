Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E6EFC4332E
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D3A565004
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbhCLJsB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbhCLJrz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:47:55 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520B1C061762
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:47:55 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id t9so1398571wrn.11
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PrQ+7ZH8hdEcqjDJ1NufGAV5+lAKZ7pUReLcSfydwew=;
        b=mMwokNhJjxNU809LhihTYAds9RepOe5eVxyE8Z+0Ds2XHVQtNvJADEYpqs7Ff8fhgQ
         6eEjbED6trnXLdfLDqGKqbkUXgajYwKVPGO0NfNxqZth8ytHV7tC8470j2KCMrHn3npG
         Hn8MLrujWL0yUpgrMJFSJwkDEsnIwAVR/LG5bANdWP3ITy5lKRUGHUpTbfpKRbn9nSCn
         zsw3GeDVaW/be8dLiUCMiXgYy/EUPsvd9w5GAoNgC/j8E5nZ2UelIXAzJrVryBrbW4/2
         5NZDiDCXKp6/GydfiZhdn0vWnSKFTXdll6z0ODb6WFhlxw2ekYmiQCiCYViDGVa0/x39
         7Giw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PrQ+7ZH8hdEcqjDJ1NufGAV5+lAKZ7pUReLcSfydwew=;
        b=bTbaMd8e/XTl05a8gwq7wosPg0wvAclYwBwab9CZZp8rQeSmoPE8/swp79lWSNeA7a
         rCTaTuh3SLnNhhMVYLaaM20Yg7dFZNKThZviKe9Z1ovXOOpudoCdK2VMrk9KedNIZN5W
         nh4ctNj4er3W5Vhb/z/CcNzZlBa/2/KSiuZt0+DSEkEuz5YwJCUQY+1UgQb6zToLWU7C
         H5bWQQQAujeXNVEW8cj03li9gPu2yNiLa5CK475sNDDvwWlrEm9sFzxLreael85dYSFm
         p06eSB1YXEmAWYXGhEZUC18a1o0SisoPjdIJCLLRhcF1YDHNatiKTvS2y+fXmddHQ7Tr
         eOFw==
X-Gm-Message-State: AOAM533Cw37PLer6uiwNQAWMLGszaOWmlJlrpjFK5kDNL7/uwhAVyYR1
        J9lQQMByQo8ZqgtrLlpc8l3uM0DzKLEw4g==
X-Google-Smtp-Source: ABdhPJwJxrqDbaV2u+c1ECEngaI6sJkBMUGycupvuKzIBQ3A/3nJ1G9UCu2s9XtmyFZmpwfnEA8eCw==
X-Received: by 2002:a05:6000:245:: with SMTP id m5mr13371283wrz.284.1615542474086;
        Fri, 12 Mar 2021 01:47:54 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:47:53 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 05/30] scsi: libfc: fc_rport: Fix incorrect naming of fc_rport_adisc_resp()
Date:   Fri, 12 Mar 2021 09:47:13 +0000
Message-Id: <20210312094738.2207817-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/libfc/fc_rport.c:1500: warning: expecting prototype for fc_rport_els_adisc_resp(). Prototype was for fc_rport_adisc_resp() instead

Cc: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/libfc/fc_rport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 56003208d2e7c..cd0fb8ca2425d 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1486,7 +1486,7 @@ static void fc_rport_enter_logo(struct fc_rport_priv *rdata)
 }
 
 /**
- * fc_rport_els_adisc_resp() - Handler for Address Discovery (ADISC) responses
+ * fc_rport_adisc_resp() - Handler for Address Discovery (ADISC) responses
  * @sp:	       The sequence the ADISC response was on
  * @fp:	       The ADISC response frame
  * @rdata_arg: The remote port that sent the ADISC response
-- 
2.27.0

