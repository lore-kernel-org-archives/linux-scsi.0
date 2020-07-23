Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803FEC433FC
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56F3322D03
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kyiVKBqF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbgGWM0E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729079AbgGWMZb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:31 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BCBC0619E5
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:31 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 9so4774272wmj.5
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B2RqnTIG0uteLiyJB2KJla0FyHDSlH3XX5iZpJkogwU=;
        b=kyiVKBqFHyRIZ1JMpgAVtFSaEM23aouz0l5QQ49XYc2VCwG+/kgIftAS8DqXDBL5AU
         qd6V5yeI3N5++kJJJmHDEXW5XzlDzOX1DHnPr7NLQAktoJDF3hM1dro0LkJNM9WeVNva
         +BcwpmB1t2NLLGafuFKHrCF2cHKxiyC6AncSTxHOQrASL25IkuYpPuQzAdRtZ6zpWvGt
         zCxZ9yOUH9ZUCLSt7qrc2IwPEYpxxUeg703CkVjjWjGEkw90tzfXLIM1lLsgmskzaGwL
         uEruf6nUfzvy42sacxgrTTJ0r7+6fu39ReYjNpmtC5OYJcgypdXM5lHeAYropnacPtvs
         VRWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B2RqnTIG0uteLiyJB2KJla0FyHDSlH3XX5iZpJkogwU=;
        b=JdpYAghPMSpn+dD8wqtfA0s5W6VOTzkBDnp+mv6+jbT9fJzBBh17KEUQ8azdlfQ3xK
         cA7S53BaqMqVMHTC00u+f9TB9KFrtyodLj1LWcVPBNxxKpTpQhLXOO1tpt8IfiQ2QIv1
         wxNmPD6BXuLNiTq6ldpHfKSuhXIcrYIXKy+hI3SGE17QeLaXxsrH7//6Ih3SU9AuzuaO
         AShh6K6ZhqTqMD0oB04lLLkUQmDI+SxU0RTd+sHhbCtXhbU9ra9+j+jZO9lTRGDrP2C6
         KhWeIHQ7yLev6RGB7T2gSEQyqQINCbnKxakf/WStfJ6ZDtJDjaPKzyQk0trCCeySAgE6
         /pVQ==
X-Gm-Message-State: AOAM5316QaukFGWhLNhGDChvGehsUJRShEHGwnUzZSfSF6NdkPof7bgs
        bEYB/GvfH+Zktl7RBs44Kc8jyA==
X-Google-Smtp-Source: ABdhPJy/2FZPI2tqrty53VNSn9/ithCZuQ+O91QiKWyLh6bBIfkjYia8sXFXtYA1gT9kiyO+t+M/qQ==
X-Received: by 2002:a1c:7719:: with SMTP id t25mr4166425wmi.144.1595507130048;
        Thu, 23 Jul 2020 05:25:30 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:29 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Subject: [PATCH 33/40] scsi: bfa: bfa_ioc: Demote non-kerneldoc headers down to standard comment blocks
Date:   Thu, 23 Jul 2020 13:24:39 +0100
Message-Id: <20200723122446.1329773-34-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is probably historical (Doxygen?).

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/bfa/bfa_ioc.c:6646: warning: Cannot understand  * @brief hardware error definition
 drivers/scsi/bfa/bfa_ioc.c:6661: warning: Cannot understand  * @brief flash command register data structure
 drivers/scsi/bfa/bfa_ioc.c:6685: warning: Cannot understand  * @brief flash device status register data structure
 drivers/scsi/bfa/bfa_ioc.c:6711: warning: Cannot understand  * @brief flash address register data structure
 drivers/scsi/bfa/bfa_ioc.c:6732: warning: Function parameter or member 'pci_bar' not described in 'bfa_flash_set_cmd'
 drivers/scsi/bfa/bfa_ioc.c:6732: warning: Function parameter or member 'wr_cnt' not described in 'bfa_flash_set_cmd'
 drivers/scsi/bfa/bfa_ioc.c:6732: warning: Function parameter or member 'rd_cnt' not described in 'bfa_flash_set_cmd'
 drivers/scsi/bfa/bfa_ioc.c:6732: warning: Function parameter or member 'ad_cnt' not described in 'bfa_flash_set_cmd'
 drivers/scsi/bfa/bfa_ioc.c:6732: warning: Function parameter or member 'op' not described in 'bfa_flash_set_cmd'
 drivers/scsi/bfa/bfa_ioc.c:6768: warning: Cannot understand  * @brief
 drivers/scsi/bfa/bfa_ioc.c:6807: warning: Cannot understand  * @brief
 drivers/scsi/bfa/bfa_ioc.c:6852: warning: Cannot understand  * @brief
 drivers/scsi/bfa/bfa_ioc.c:6898: warning: Cannot understand  * @brief
 drivers/scsi/bfa/bfa_ioc.c:6914: warning: Cannot understand  * @brief
 drivers/scsi/bfa/bfa_ioc.c:6940: warning: Cannot understand  * @brief

Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bfa/bfa_ioc.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 10c12b5a36b84..be48a7e31e803 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -6642,8 +6642,8 @@ enum bfa_flash_cmd {
 	BFA_FLASH_READ_STATUS	= 0x05,	/* read status */
 };
 
-/**
- * @brief hardware error definition
+/*
+ * Hardware error definition
  */
 enum bfa_flash_err {
 	BFA_FLASH_NOT_PRESENT	= -1,	/*!< flash not present */
@@ -6657,8 +6657,8 @@ enum bfa_flash_err {
 	BFA_FLASH_ERR_LEN	= -9,	/*!< invalid length */
 };
 
-/**
- * @brief flash command register data structure
+/*
+ * Flash command register data structure
  */
 union bfa_flash_cmd_reg_u {
 	struct {
@@ -6681,8 +6681,8 @@ union bfa_flash_cmd_reg_u {
 	u32	i;
 };
 
-/**
- * @brief flash device status register data structure
+/*
+ * Flash device status register data structure
  */
 union bfa_flash_dev_status_reg_u {
 	struct {
@@ -6707,8 +6707,8 @@ union bfa_flash_dev_status_reg_u {
 	u32	i;
 };
 
-/**
- * @brief flash address register data structure
+/*
+ * Flash address register data structure
  */
 union bfa_flash_addr_reg_u {
 	struct {
@@ -6723,7 +6723,7 @@ union bfa_flash_addr_reg_u {
 	u32	i;
 };
 
-/**
+/*
  * dg flash_raw_private Flash raw private functions
  */
 static void
@@ -6764,7 +6764,7 @@ bfa_flash_cmd_act_check(void __iomem *pci_bar)
 	return 0;
 }
 
-/**
+/*
  * @brief
  * Flush FLI data fifo.
  *
@@ -6803,7 +6803,7 @@ bfa_flash_fifo_flush(void __iomem *pci_bar)
 	return 0;
 }
 
-/**
+/*
  * @brief
  * Read flash status.
  *
@@ -6848,7 +6848,7 @@ bfa_flash_status_read(void __iomem *pci_bar)
 	return ret_status;
 }
 
-/**
+/*
  * @brief
  * Start flash read operation.
  *
@@ -6894,7 +6894,7 @@ bfa_flash_read_start(void __iomem *pci_bar, u32 offset, u32 len,
 	return 0;
 }
 
-/**
+/*
  * @brief
  * Check flash read operation.
  *
@@ -6910,7 +6910,7 @@ bfa_flash_read_check(void __iomem *pci_bar)
 
 	return 0;
 }
-/**
+/*
  * @brief
  * End flash read operation.
  *
@@ -6936,7 +6936,7 @@ bfa_flash_read_end(void __iomem *pci_bar, u32 len, char *buf)
 	bfa_flash_fifo_flush(pci_bar);
 }
 
-/**
+/*
  * @brief
  * Perform flash raw read.
  *
-- 
2.25.1

