Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5086DC43332
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F7A564EBD
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392014AbhCDAci (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359710AbhCCOuf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:50:35 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F504C0613BF
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:47:41 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id b18so17491040wrn.6
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FzboMeGsvBVDTSqmL3mV6e6l8GqozBpIfKeksb4g5kA=;
        b=YHkspBQQ+39QTR0mZ+hTCWl23QI8cmDaM7sJJmbKHgwkIQAxZ/6CixJ0LpZxwmvMl/
         0lv4xqrrilnI9Zxl5fJShO5FDsLSm7Pqy89cFahNAgLa/jofVwDJTigG21l7oRmakU/M
         WGUTwTe3rmkRA4vpHd0uoP1vc7QVibqNs4D+N/8IXqCxtmmq5AIl6Bd9TPPAiNB2T17d
         EIk8E8mfieDFe+WtTAqwV5E6CYWYgQtUUOJcR8YWUvE/1fsYvprFTSvOqAkhBFJ5/AKk
         rDRjfKHIEVM/HRDTAmcHDRU/gR9/WNqbHD062ac17p5A/oK+1MvwBHRDguT5KS107CQO
         2jbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FzboMeGsvBVDTSqmL3mV6e6l8GqozBpIfKeksb4g5kA=;
        b=AvOVZo/YphFvNEGBuwxtIENrRXbrp5XMEiWIT5RsCpNrEsM0dqXnkXRgtqY9jTZ+gp
         BtXdhl8gIUI4dPAKYV7WlwfGFPEzbh1kTlqaduaVxMCkkEg6RZzj2FQyfGymnGycBLFk
         Hj/GwisAGI3thL+F7muOt2v1KJrh3rhCuuWvyr+FrKYhqfNWz/GUEUrTOLVLATJD7v0A
         ZurBvq2EM4CPH8ZYoLQ/fsUX0IJJuieVURjPuQRrMcFmJbyE5rxjA10cgSetWUmRJfti
         iO+tcHr6jzY6bGUZQl1hb8/LGSiuAVzjxb4uaBAu0k8gdd8cPhJ9pSwmppILlwSmOHVi
         BdHQ==
X-Gm-Message-State: AOAM530SFrGJWbRFa0xBwRch2vU7neAJZLXXIhkTbXZjY7yi4BIdh7Xp
        k9ehPFQ7uznkLQ6FmHg6upsuWw==
X-Google-Smtp-Source: ABdhPJw8noLs57ZQV8IKy3ecX1MyBIzUpkPiAEVpk3Q6N3xq05oll6q3quvNKVy+57RMtglsew1LQQ==
X-Received: by 2002:adf:c101:: with SMTP id r1mr27901802wre.38.1614782859933;
        Wed, 03 Mar 2021 06:47:39 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:47:39 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 22/30] scsi: pm8001: pm80xx_hwi: Fix a bunch of doc-rotted function headers
Date:   Wed,  3 Mar 2021 14:46:23 +0000
Message-Id: <20210303144631.3175331-23-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/pm8001/pm80xx_hwi.c:1427: warning: expecting prototype for pm8001_chip_init(). Prototype was for pm80xx_chip_init() instead
 drivers/scsi/pm8001/pm80xx_hwi.c:1584: warning: expecting prototype for pm8001_chip_soft_rst(). Prototype was for pm80xx_chip_soft_rst() instead
 drivers/scsi/pm8001/pm80xx_hwi.c:1711: warning: expecting prototype for pm8001_chip_interrupt_enable(). Prototype was for pm80xx_chip_intx_interrupt_enable() instead
 drivers/scsi/pm8001/pm80xx_hwi.c:1722: warning: expecting prototype for pm8001_chip_intx_interrupt_disable(). Prototype was for pm80xx_chip_intx_interrupt_disable() instead
 drivers/scsi/pm8001/pm80xx_hwi.c:1733: warning: expecting prototype for pm8001_chip_interrupt_enable(). Prototype was for pm80xx_chip_interrupt_enable() instead
 drivers/scsi/pm8001/pm80xx_hwi.c:1752: warning: expecting prototype for pm8001_chip_interrupt_disable(). Prototype was for pm80xx_chip_interrupt_disable() instead
 drivers/scsi/pm8001/pm80xx_hwi.c:4192: warning: expecting prototype for pm8001_chip_smp_req(). Prototype was for pm80xx_chip_smp_req() instead
 drivers/scsi/pm8001/pm80xx_hwi.c:4775: warning: expecting prototype for pm8001_chip_phy_stop_req(). Prototype was for pm80xx_chip_phy_stop_req() instead
 drivers/scsi/pm8001/pm80xx_hwi.c:4907: warning: expecting prototype for pm8001_chip_isr(). Prototype was for pm80xx_chip_isr() instead

Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 84315560e8e1a..74ed072209f47 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1420,7 +1420,7 @@ static int pm80xx_encrypt_update(struct pm8001_hba_info *pm8001_ha)
 }
 
 /**
- * pm8001_chip_init - the main init function that initialize whole PM8001 chip.
+ * pm80xx_chip_init - the main init function that initialize whole PM8001 chip.
  * @pm8001_ha: our hba card information
  */
 static int pm80xx_chip_init(struct pm8001_hba_info *pm8001_ha)
@@ -1574,7 +1574,7 @@ pm80xx_fatal_errors(struct pm8001_hba_info *pm8001_ha)
 }
 
 /**
- * pm8001_chip_soft_rst - soft reset the PM8001 chip, so that the clear all
+ * pm80xx_chip_soft_rst - soft reset the PM8001 chip, so that the clear all
  * the FW register status to the originated status.
  * @pm8001_ha: our hba card information
  */
@@ -1703,7 +1703,7 @@ static void pm80xx_hw_chip_rst(struct pm8001_hba_info *pm8001_ha)
 }
 
 /**
- * pm8001_chip_interrupt_enable - enable PM8001 chip interrupt
+ * pm80xx_chip_intx_interrupt_enable - enable PM8001 chip interrupt
  * @pm8001_ha: our hba card information
  */
 static void
@@ -1714,7 +1714,7 @@ pm80xx_chip_intx_interrupt_enable(struct pm8001_hba_info *pm8001_ha)
 }
 
 /**
- * pm8001_chip_intx_interrupt_disable- disable PM8001 chip interrupt
+ * pm80xx_chip_intx_interrupt_disable - disable PM8001 chip interrupt
  * @pm8001_ha: our hba card information
  */
 static void
@@ -1724,7 +1724,7 @@ pm80xx_chip_intx_interrupt_disable(struct pm8001_hba_info *pm8001_ha)
 }
 
 /**
- * pm8001_chip_interrupt_enable - enable PM8001 chip interrupt
+ * pm80xx_chip_interrupt_enable - enable PM8001 chip interrupt
  * @pm8001_ha: our hba card information
  * @vec: interrupt number to enable
  */
@@ -1743,7 +1743,7 @@ pm80xx_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 }
 
 /**
- * pm8001_chip_interrupt_disable- disable PM8001 chip interrupt
+ * pm80xx_chip_interrupt_disable - disable PM8001 chip interrupt
  * @pm8001_ha: our hba card information
  * @vec: interrupt number to disable
  */
@@ -4183,7 +4183,7 @@ static void build_smp_cmd(u32 deviceID, __le32 hTag,
 }
 
 /**
- * pm8001_chip_smp_req - send a SMP task to FW
+ * pm80xx_chip_smp_req - send a SMP task to FW
  * @pm8001_ha: our hba card information.
  * @ccb: the ccb information this request used.
  */
@@ -4766,7 +4766,7 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
 }
 
 /**
- * pm8001_chip_phy_stop_req - start phy via PHY_STOP COMMAND
+ * pm80xx_chip_phy_stop_req - start phy via PHY_STOP COMMAND
  * @pm8001_ha: our hba card information.
  * @phy_id: the phy id which we wanted to start up.
  */
@@ -4898,7 +4898,7 @@ static u32 pm80xx_chip_is_our_interrupt(struct pm8001_hba_info *pm8001_ha)
 }
 
 /**
- * pm8001_chip_isr - PM8001 isr handler.
+ * pm80xx_chip_isr - PM8001 isr handler.
  * @pm8001_ha: our hba card information.
  * @vec: irq number.
  */
-- 
2.27.0

