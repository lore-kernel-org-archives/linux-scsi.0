Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C7CEC43381
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E48E564FDA
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbhCLJsA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbhCLJrv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:47:51 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199C9C061761
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:47:51 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo14771711wmq.4
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FaOSlT3H+eLXLTdCz81SgFAQniGwqDSS0DXaq2Iu+DQ=;
        b=KiZ4XpaI61DeKGuGWBl7FK9Y5syYuFXSX02jgJnKdo5mMroLsTF4k0qdKK4z8qu4ZE
         IYuzbaZXcXEehNeTOGANduXzjvCFt3O9I2VNdFxF2ubIsi216dYjkqrkYgejgQB8E7mN
         WsN0LksSO8bu1HYw+7f+yTDrh3T3bXFh3Rqu355eNwcQXAFPfypEwZ3j8NlR3jTWs5dh
         8R9hDO+h4ciNlJCi1SKIxZ444K1JWLqmGF51CAIWK9m2E69xOVR4pxM6utG/o8lfRdva
         xmDhUjoVz9W66ju6i4Hym9mPMkM9FpprKMMZE0xR6LWY3PPGY6NaMRgO/qgk0zHqZJGZ
         9AkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FaOSlT3H+eLXLTdCz81SgFAQniGwqDSS0DXaq2Iu+DQ=;
        b=sEchJdsIaJeS8NlJIKXkRKlgRD7BhOWKzVdbX5RgeCC9GN2dMT6x1B8CFlfqMbecGd
         sEIxauppBMDL8Bm9kgPmLFMZV39Ya4lOckck7yZKgqYlIgBfQ8ikJV+YATSkeqHThEJh
         r0/A8+Fumd9FvnL9ueQPY+XqZT/wW01WMZwVVRDVv16ph2CRKDp/xGUP+i902m7tMg4x
         bmNJ9pWohrOuPBiO23Ei7JY7YWsIQ+hN/pH6PzJ8JJOhzqk5c741pLTNH4gf8+JkjnTs
         JjY/Mj8bwI3i/vtRYQrDJn+8G/wGD4hQ1M//zs3ygmqSeDBbV9GVZIOqt+vmHEjRhHcQ
         WKyg==
X-Gm-Message-State: AOAM533veZ1XbCv3Wjzv9t+Y00SYogXHf2OutpGrlzboO/OpuedhASwm
        lksFGeI1ivHxzYKgQbu6Jmwb3g==
X-Google-Smtp-Source: ABdhPJw+ik8nZsC9jBBcKw7vvpmX8TD2loT8Bag8vlVBF2NCbKhx4t5FH5klfoUhZ+kaY21mQLE2cg==
X-Received: by 2002:a7b:cf18:: with SMTP id l24mr11821999wmg.182.1615542469782;
        Fri, 12 Mar 2021 01:47:49 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:47:49 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@avagotech.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH 01/30] scsi: mpt3sas: mpt3sas_config: Fix a bunch of potential naming doc-rot
Date:   Fri, 12 Mar 2021 09:47:09 +0000
Message-Id: <20210312094738.2207817-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/mpt3sas/mpt3sas_config.c:1795: warning: expecting prototype for mpt3sas_config_set_driver_trigger_pg0(). Prototype was for _config_set_driver_trigger_pg0() instead
 drivers/scsi/mpt3sas/mpt3sas_config.c:1929: warning: expecting prototype for mpt3sas_config_set_driver_trigger_pg1(). Prototype was for _config_set_driver_trigger_pg1() instead
 drivers/scsi/mpt3sas/mpt3sas_config.c:2080: warning: expecting prototype for mpt3sas_config_set_driver_trigger_pg2(). Prototype was for _config_set_driver_trigger_pg2() instead
 drivers/scsi/mpt3sas/mpt3sas_config.c:2240: warning: expecting prototype for mpt3sas_config_set_driver_trigger_pg3(). Prototype was for _config_set_driver_trigger_pg3() instead
 drivers/scsi/mpt3sas/mpt3sas_config.c:2397: warning: expecting prototype for mpt3sas_config_set_driver_trigger_pg4(). Prototype was for _config_set_driver_trigger_pg4() instead

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@avagotech.com
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/mpt3sas/mpt3sas_config.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 8238843523b53..55cd329089246 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -1781,7 +1781,7 @@ mpt3sas_config_get_driver_trigger_pg0(struct MPT3SAS_ADAPTER *ioc,
 }
 
 /**
- * mpt3sas_config_set_driver_trigger_pg0 - write driver trigger page 0
+ * _config_set_driver_trigger_pg0 - write driver trigger page 0
  * @ioc: per adapter object
  * @mpi_reply: reply mf payload returned from firmware
  * @config_page: contents of the config page
@@ -1915,7 +1915,7 @@ mpt3sas_config_get_driver_trigger_pg1(struct MPT3SAS_ADAPTER *ioc,
 }
 
 /**
- * mpt3sas_config_set_driver_trigger_pg1 - write driver trigger page 1
+ * _config_set_driver_trigger_pg1 - write driver trigger page 1
  * @ioc: per adapter object
  * @mpi_reply: reply mf payload returned from firmware
  * @config_page: contents of the config page
@@ -2066,7 +2066,7 @@ mpt3sas_config_get_driver_trigger_pg2(struct MPT3SAS_ADAPTER *ioc,
 }
 
 /**
- * mpt3sas_config_set_driver_trigger_pg2 - write driver trigger page 2
+ * _config_set_driver_trigger_pg2 - write driver trigger page 2
  * @ioc: per adapter object
  * @mpi_reply: reply mf payload returned from firmware
  * @config_page: contents of the config page
@@ -2226,7 +2226,7 @@ mpt3sas_config_get_driver_trigger_pg3(struct MPT3SAS_ADAPTER *ioc,
 }
 
 /**
- * mpt3sas_config_set_driver_trigger_pg3 - write driver trigger page 3
+ * _config_set_driver_trigger_pg3 - write driver trigger page 3
  * @ioc: per adapter object
  * @mpi_reply: reply mf payload returned from firmware
  * @config_page: contents of the config page
@@ -2383,7 +2383,7 @@ mpt3sas_config_get_driver_trigger_pg4(struct MPT3SAS_ADAPTER *ioc,
 }
 
 /**
- * mpt3sas_config_set_driver_trigger_pg4 - write driver trigger page 4
+ * _config_set_driver_trigger_pg4 - write driver trigger page 4
  * @ioc: per adapter object
  * @mpi_reply: reply mf payload returned from firmware
  * @config_page: contents of the config page
-- 
2.27.0

