Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36EF2C4160E
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C1CC64E51
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355660AbhCDAcW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359658AbhCCOuP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:50:15 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD0AC0613B9
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:47:26 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id n22so5409311wmc.2
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xZLBI/8SqO3lQnkC11OaIHS0M/CameoMxsEwafnsB1c=;
        b=sV0WJ5awppAN6jeDvroI2TUJPkOXgTrWX5NupraTKExh6YFI7ps6gOgZAKZ9PMBR3C
         6A+S+kKhkHNj3O/BwjvwukRsBxHH00pwRuqAb9rfA7npMqIhVuVTi9hUIBx4679upMva
         1QKIGrinWSdP08ex0VNEAtfkzjK5acsN9tOd+SyuTycvsTUszESnVVgWwQB22ty0ClPr
         ccyw6AG4M8EafLYlPyjWwFzzw4UEQwoknxE13W9ggiT3TCheOJm5MSBoZnnJF1FuFJx+
         XgKggaTJ5yx5b1fXfN1ofpPTiCvKnrhNbTKUKwT/yLNt/pXZUmrtG1FEeMJ62HyZ72de
         SwEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xZLBI/8SqO3lQnkC11OaIHS0M/CameoMxsEwafnsB1c=;
        b=tz8m5t5ttEBkClIdrnhkw735SRCuRCvO2YOsuPbOF4J6ONfb4mN/nrmS1R3oKvg1Oh
         MpMFIQI7QzUCcGhM/ghSTc3+06Zu3I9UxOh6YlIqyTltG681l2PHnWsOs4ekfuPHFnGN
         SJJ6+IGM2nnWUfXbeCDZ9FmiCDeeBUVr9F0ofEduLsGYqtCWmyXxg6GQF+PFwk7ejgmI
         Ndv1NU4V2KfJ2ToaOBrMb0+Zle9k0pwT5QwQKWZr4jQzkORLa4XWpH8AAJozQ0er7/I5
         rxyufrJMIEda/f0ZqyQbGh5Ed+lJmlce39fU/eOJ/YZ/RAO2ghYIr7sk38ct36wNTT+a
         hZ2g==
X-Gm-Message-State: AOAM5311dr5TbEC6YMOGMBfru840gNdQ0gNIBbXjtiJhzE2WbWNgRcrz
        iwRqfdQ5ZmTaAZQqZ27nUYTJqw==
X-Google-Smtp-Source: ABdhPJwe8JD1NLxuRyWvUDwBYH+oG7tZAH6fZ5CsYEXhUT3tkZWH8K+UTsMamm4CoavJaq0kgLGmUA==
X-Received: by 2002:a1c:730a:: with SMTP id d10mr9232298wmb.53.1614782845136;
        Wed, 03 Mar 2021 06:47:25 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:47:24 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 18/30] scsi: pm8001: pm8001_hwi: Fix some misnamed function descriptions
Date:   Wed,  3 Mar 2021 14:46:19 +0000
Message-Id: <20210303144631.3175331-19-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/pm8001/pm8001_hwi.c:1183: warning: expecting prototype for pm8001_chip_interrupt_enable(). Prototype was for pm8001_chip_intx_interrupt_enable() instead
 drivers/scsi/pm8001/pm8001_hwi.c:1257: warning: expecting prototype for pm8001_chip_intx_interrupt_disable(). Prototype was for pm8001_chip_interrupt_disable() instead
 drivers/scsi/pm8001/pm8001_hwi.c:3235: warning: expecting prototype for asd_get_attached_sas_addr(). Prototype was for pm8001_get_attached_sas_addr() instead
 drivers/scsi/pm8001/pm8001_hwi.c:3555: warning: expecting prototype for fw_flash_update_resp(). Prototype was for pm8001_mpi_fw_flash_update_resp() instead

Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 49bf2f70a470e..6b600e33e9e8d 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1175,7 +1175,7 @@ void pm8001_chip_iounmap(struct pm8001_hba_info *pm8001_ha)
 
 #ifndef PM8001_USE_MSIX
 /**
- * pm8001_chip_interrupt_enable - enable PM8001 chip interrupt
+ * pm8001_chip_intx_interrupt_enable - enable PM8001 chip interrupt
  * @pm8001_ha: our hba card information
  */
 static void
@@ -1248,7 +1248,7 @@ pm8001_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 }
 
 /**
- * pm8001_chip_intx_interrupt_disable- disable PM8001 chip interrupt
+ * pm8001_chip_interrupt_disable - disable PM8001 chip interrupt
  * @pm8001_ha: our hba card information
  * @vec: unused
  */
@@ -3219,7 +3219,7 @@ void pm8001_get_lrate_mode(struct pm8001_phy *phy, u8 link_rate)
 }
 
 /**
- * asd_get_attached_sas_addr -- extract/generate attached SAS address
+ * pm8001_get_attached_sas_addr - extract/generate attached SAS address
  * @phy: pointer to asd_phy
  * @sas_addr: pointer to buffer where the SAS address is to be written
  *
@@ -3546,7 +3546,7 @@ int pm8001_mpi_dereg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 }
 
 /**
- * fw_flash_update_resp - Response from FW for flash update command.
+ * pm8001_mpi_fw_flash_update_resp - Response from FW for flash update command.
  * @pm8001_ha: our hba card information
  * @piomb: IO message buffer
  */
-- 
2.27.0

