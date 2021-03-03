Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5950C4360C
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF15464F02
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388405AbhCDAb5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244583AbhCCOs0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:48:26 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640F7C0613E6
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:46:48 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id w7so5390105wmb.5
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:46:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GDZddnpJba/Pn4dRuDBATAXJPUWXaNHEAc/aEwqe0w8=;
        b=Ua/75M0QhR8/drEWLtFBQrIsnqyLuPVFUJjnLiJNBN2hoIsvh/UU52in5+buLcIkFa
         d8c2BpEoZIupANMs+/h10v8Gvxf25g8awXnaTNzkUmJDNro9b43l9kcMzGa37d/s7lUw
         9qrP5XrmGetmklGmKz5c/183AaUjzzuqcG+j4/3fANVPrIQUnOhaF+TodFznz4At4Slf
         RdRijxmLIilHcYZ7q/r5uZofsjrQvKGpOIuQO30Xsy18fDKlowOWX0RnbkoJKnx14MR6
         5PBu3HVkW47lwQV/QCHy5OC2gOj4zmM4bhatPOh8leUXuvllrKOKE1SX60aHQxLG/TJi
         VdIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GDZddnpJba/Pn4dRuDBATAXJPUWXaNHEAc/aEwqe0w8=;
        b=g9SV1o4GrVYxcd4YSMmUk+6oXClP0Cn4OhyVZqoMkZH6p7BUs8M6axnDNq/QKGHeoO
         A3THljB3J2xFi3w3FjcnX8eMlGL+ejBFLR0wTfl52Jxlkpwo0U/z/MQfGt25gBqyzMsx
         qLfn1l5gKgeCRfZBJ8RwMivJm7AS2eqsbypYfK9RxwaPPdpY2JdL4mtQ9oRT5JYrCtcB
         sPt/1mOndgK6sHKL/oW5SuFsijfDINt54LSR56O0XtTGj1wZnPkf34kiRK43tqSaEWHw
         HkGrtVRVSu/pgfdcaRlFUPjrlzn7GrlhVFgxZ5LvQGK510BpAdjwDZBkH6DTI90qKYUK
         YzNQ==
X-Gm-Message-State: AOAM532j3th2wQoaaanj0I7EXqBTikRYnwZw7VzB0PhC0Mi+lw+iV8Rs
        if86J124euNTNiRvRWVnuE7t8w==
X-Google-Smtp-Source: ABdhPJzC/yJRQcCFUJ3VLRPBZ1oNcc73HDGPnWdcOLFcyKW4fuXspgpB4PoiOZB3LiEGlIbp6koTTw==
X-Received: by 2002:a7b:c3c1:: with SMTP id t1mr9352438wmj.47.1614782807074;
        Wed, 03 Mar 2021 06:46:47 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:46:46 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Luben Tuikov <luben_tuikov@adaptec.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 06/30] scsi: aic94xx: aic94xx_hwi: Fix a couple of misnamed function names
Date:   Wed,  3 Mar 2021 14:46:07 +0000
Message-Id: <20210303144631.3175331-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic94xx/aic94xx_hwi.c:910: warning: expecting prototype for ads_rbi_exsi_isr(). Prototype was for asd_rbi_exsi_isr() instead
 drivers/scsi/aic94xx/aic94xx_hwi.c:1156: warning: expecting prototype for asd_start_timers(). Prototype was for asd_start_scb_timers() instead

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic94xx/aic94xx_hwi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
index 9256ab7b25227..3dd1101434715 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -903,7 +903,7 @@ static void asd_dch_sas_isr(struct asd_ha_struct *asd_ha)
 }
 
 /**
- * ads_rbi_exsi_isr -- process external system interface interrupt (INITERR)
+ * asd_rbi_exsi_isr -- process external system interface interrupt (INITERR)
  * @asd_ha: pointer to host adapter structure
  */
 static void asd_rbi_exsi_isr(struct asd_ha_struct *asd_ha)
@@ -1144,7 +1144,7 @@ static void asd_swap_head_scb(struct asd_ha_struct *asd_ha,
 }
 
 /**
- * asd_start_timers -- (add and) start timers of SCBs
+ * asd_start_scb_timers -- (add and) start timers of SCBs
  * @list: pointer to struct list_head of the scbs
  *
  * If an SCB in the @list has no timer function, assign the default
-- 
2.27.0

