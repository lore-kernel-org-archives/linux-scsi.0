Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9E2C15503
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DFAA64E62
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355606AbhCDAcF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345260AbhCCOsf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:48:35 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFC3C0613EF
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:46:53 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o7-20020a05600c4fc7b029010a0247d5f0so2974050wmq.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nK4eefo6NrFTl4crSl1/DHJIw7UTb4L0OHxeSI3Uc2E=;
        b=ML8ij0NytYJdYa1UhFHNKItuAT7SeWi4ZjzKZ0lUoHQamtkkVYhMwjU9x0r0j5nBI5
         O08WuH9ercltleOgu7V92WnWMunllo5s4r9gedetm3BRxkMWRRPJKR8nb5a7YdnWGDVF
         vb73w39mKLlaeYHr7hAAx46giWMELjHP2vf9qTpwBZUabhLhUHmfqJM1nL45R2OE7GhE
         XXp+NoL8fu8iNML10qDc42jkuzWvhhKWn901TJWhVY6HDZPDNM2ZlSEeQQn7qfX7WUuH
         FghJDjqoVbUVhK9345mMChpriaCPV7mqBWMVB6mHKixI1Pxn+n3/wjXBoHNnpSHjPvAt
         7Ryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nK4eefo6NrFTl4crSl1/DHJIw7UTb4L0OHxeSI3Uc2E=;
        b=eF/H7NcyZWeDZ++lRt1DFSeDUqxlElSri/bn6gBd76h2REqWYset8rFhjM5Zo/vS1t
         yYai9XS1NFTYxpYUNxmuS4GkpnbLmp6AuB7WrHosDgKxAI8GjXNFcQfeZHg8RhvaXidd
         /1yQVJZJ+HA/DnmzITDIyf8yOBzbnPpz2r3Zn1XO9/gIH975anJu9F0hnkWr7lnF7t31
         f7YOrhnKvMtp4A9DATHgQBkym8VP/Ej2bCfm1ZVdmYuUarR76riyS+2DSZEcnWjFiO4Z
         T9XUtSgqOApMTzTSD/GmOHL349WO+LdyCHlwR9qANiOBRDnaIMPkwHOhitU7rMkwglVP
         bf3Q==
X-Gm-Message-State: AOAM533PWpTWXumPTMEObK35Y++KtZp/Uj9aHEMkaqC6/H50IfPxKduu
        58pT4SwVAGHsRz9BWK/EsLtJUQ==
X-Google-Smtp-Source: ABdhPJz3HUn1iV4Mr3ACScTkwR7ze/a6od0APWdQI8cJupILZPBEJcNfDu4EJ/WCQKO9jNkbxq8r2g==
X-Received: by 2002:a1c:7210:: with SMTP id n16mr9171547wmc.13.1614782811891;
        Wed, 03 Mar 2021 06:46:51 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:46:49 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>,
        Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>,
        Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 08/30] scsi: pm8001: pm8001_init: Provide function name and fix a misspelling
Date:   Wed,  3 Mar 2021 14:46:09 +0000
Message-Id: <20210303144631.3175331-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/pm8001/pm8001_init.c:192: warning: expecting prototype for tasklet for 64 msi(). Prototype was for pm8001_tasklet() instead
 drivers/scsi/pm8001/pm8001_init.c:872: warning: expecting prototype for pm8001_set_phy_settings_ven_117c_12Gb(). Prototype was for pm8001_set_phy_settings_ven_117c_12G() instead

Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Cc: Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>
Cc: Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/pm8001/pm8001_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index bd626ef876dac..bbb6b23aa6b1c 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -184,7 +184,7 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
 #ifdef PM8001_USE_TASKLET
 
 /**
- * tasklet for 64 msi-x interrupt handler
+ * pm8001_tasklet() - tasklet for 64 msi-x interrupt handler
  * @opaque: the passed general host adapter struct
  * Note: pm8001_tasklet is common for pm8001 & pm80xx
  */
@@ -864,7 +864,7 @@ void pm8001_get_phy_mask(struct pm8001_hba_info *pm8001_ha, int *phymask)
 }
 
 /**
- * pm8001_set_phy_settings_ven_117c_12Gb : Configure ATTO 12Gb PHY settings
+ * pm8001_set_phy_settings_ven_117c_12G() : Configure ATTO 12Gb PHY settings
  * @pm8001_ha : our adapter
  */
 static
-- 
2.27.0

