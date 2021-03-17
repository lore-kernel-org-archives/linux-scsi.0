Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AFCC4360C
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7082964F33
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhCQJNF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhCQJMu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:12:50 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FD8C061760
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:50 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id d8-20020a1c1d080000b029010f15546281so616967wmd.4
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+cTXQTsH/Sbo5QzGWeCU2MjhmNBDgdRBi7pc9b8SsmM=;
        b=VYhSNkK+JDvxaEmc3cWAiu0oGoUR+6g+rSTKcBpFdz8wa43BR/IgIZj5E8XtoWoQpW
         SquXLOqc70jaB0HmeT4WGikLKxwDP4k8D4xwliE/brjI+/xnZ9hIM/juN/LNu3xw+Xnf
         A1Ok6qqfvoV7mRusCOcAGvafZNT3c1mIRTMmvew9G+LEtUisK+e+SfPTBDJJBCv8ZQ2e
         ssINX80lsZIijxEIMMtgvf9lTfLJO2j8ZVYWvHZOuLw404fiTjkOgePdQRnVsJrBHm5N
         TbPMQZrw798p5fPCCJkf4I4Z+oSumTsauziu0BvMYuSHs66hyMpTmkp7aKTAdEAN+nP8
         OERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+cTXQTsH/Sbo5QzGWeCU2MjhmNBDgdRBi7pc9b8SsmM=;
        b=qH9i2yTnO9+IKGtI1O6r0DRWmGAi1rUKaBL8dLNo5D+9CShcbtijQkdY9oLfxYYyjD
         UtTYYsnoPogaf3wz/EGUmCWlBLM2afM1Bq3MfFtnUL5zuEIIpIcSQ581jYRj7E+cp9aV
         2/FNYQ9tBImIJYWHtCJcfv3NKldXPLdQ6XcWBxBi3EJZWxEGz3vSOyNbRe8DSnSlz7/n
         IRKvwLLYXEcWuUPMAG/d7UWZrFTs/iaLHC8UnBwAPtjliTo+0zzDRMiiyvCAwYWA/esg
         H2/17xD/27BKYk/ZEax8AqB3p5xOGs3bGCLp2vB+ZwXbtlzBOj+S53UNPefPuuE0+1qp
         FpGw==
X-Gm-Message-State: AOAM533JmX1WFcibtwew9ZclcI9PkprJJIJMffhYx3txIKTTQVKdxvvu
        DNSr7xz8Hb91rfyAekT7EJbn9g==
X-Google-Smtp-Source: ABdhPJwZCa2AE19dHCjnrYQNeHohRMm19sA+K9A0b+yfc3ONTDGtCEo2MmZswFOSIbAQMugGGvWgOw==
X-Received: by 2002:a1c:7519:: with SMTP id o25mr2646901wmc.35.1615972368750;
        Wed, 17 Mar 2021 02:12:48 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:12:48 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "C.L. Huang" <ching@tekram.com.tw>,
        Erich Chen <erich@tekram.com.tw>,
        Kurt Garloff <garloff@suse.de>, dc395x@twibble.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 09/36] scsi: dc395x: Fix some function param descriptions
Date:   Wed, 17 Mar 2021 09:12:03 +0000
Message-Id: <20210317091230.2912389-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/dc395x.c:4353: warning: Function parameter or member 'acb' not described in 'adapter_init'
 drivers/scsi/dc395x.c:4353: warning: Function parameter or member 'io_port_len' not described in 'adapter_init'
 drivers/scsi/dc395x.c:4353: warning: Excess function parameter 'host' description in 'adapter_init'

Cc: Oliver Neukum <oliver@neukum.org>
Cc: Ali Akcaagac <aliakc@web.de>
Cc: Jamie Lenehan <lenehan@twibble.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "C.L. Huang" <ching@tekram.com.tw>
Cc: Erich Chen <erich@tekram.com.tw>
Cc: Kurt Garloff <garloff@suse.de>
Cc: dc395x@twibble.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/dc395x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index e28f8931e23f8..5503230006f87 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4341,8 +4341,9 @@ static void adapter_init_chip(struct AdapterCtlBlk *acb)
  * tables etc etc. This basically gets all adapter information all up
  * to date, initialised and gets the chip in sync with it.
  *
- * @host:	This hosts adapter structure
+ * @acb:	The adapter which we are to init.
  * @io_port:	The base I/O port
+ * @io_port_len: The I/O port size
  * @irq:	IRQ
  *
  * Returns 0 if the initialization succeeds, any other value on
-- 
2.27.0

