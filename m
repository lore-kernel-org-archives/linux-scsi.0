Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBD2C433FC
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89C8E20720
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sJc+wnQu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730711AbgGUQmg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730259AbgGUQmg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:36 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841FFC0619DF
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:34 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 22so3480847wmg.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pFkpQlvxyH9m9yB35YYUzSgG662tMobXEVb8ZoPNfoU=;
        b=sJc+wnQurbWJb00o0fdA4+jdNsgo8gZNOC8c4HTgdRTiy4vdVSQJL1Zc7GFRhwmxPo
         Z57x4K+9dLUTah6uPq0WMNK4CYfBedF87wqf26/ku4UV6Bu3rs/wJhlPPktNYIfpFRh4
         HYO79VT6F0v8WlzOlGYwCkSz73lERBDR2m5kY79eoD+tMhhnHwg4C8/aupr/nAIDWuzN
         gEK4UvwwhAHA3GryANfPyATKeqgTdnkVzNdybiyjkVntEHGnIp0Wd2G470Xbs5dff0rP
         n0PLiCr4ZGyp15GNIWxSkXA+EnFPuMzfdOQkq7e8a/J3JEifqXofDxe+3ywsnIjTP7r1
         Xlpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pFkpQlvxyH9m9yB35YYUzSgG662tMobXEVb8ZoPNfoU=;
        b=nhCraYbbb5FENJVWKZ8pwgUYGMzlEyajFh38pORXDbtsqb7YYvVr9p0pSgnU4uKLgh
         5aMwhakUNmja/hqp/v4K5u099VxuCMebtyClw4/6zKFkdaOhm/FzVVQjKhF9y24jfkas
         qIaH43NqY4XMrILqYajxBOPbWHoa0N9qbYMpu9ta7HTfPrrc5kN+24vGi42hsVDwH01T
         w/SHrH3SJACvY51UEObgC73u8AjzIoVC71PrfBGROsWZNZqoxmCe2aZMZvmKz7gWX1lX
         tatPOwo/ML+Wa3pg3fVb+4PUEYsC8zxpSL5kDrWKBYyECgAA7awQjvgKSAHIb96eLMGJ
         BgKQ==
X-Gm-Message-State: AOAM5305o0gk/bjhIA+DSxszHhvusjNKNsHnriDoM21uTT7QAWm/Y0qR
        r5IgURlk4TC0A321GcLwl3eiDQ==
X-Google-Smtp-Source: ABdhPJy1WDmEn1QrVB1dFbGylTGQByPmw8QD4sheyz5KhZ3Q75KO7eL1BVb6X0oQ8KJIjbQ+9b8vmg==
X-Received: by 2002:a7b:c8c8:: with SMTP id f8mr5019468wml.142.1595349753304;
        Tue, 21 Jul 2020 09:42:33 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:32 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 25/40] scsi: pm8001: pm80xx_hwi: Staticify 'pm80xx_pci_mem_copy' and 'mpi_set_phy_profile_req'
Date:   Tue, 21 Jul 2020 17:41:33 +0100
Message-Id: <20200721164148.2617584-26-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These are not invoked externally.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/pm8001/pm80xx_hwi.c:69:6: warning: no previous prototype for ‘pm80xx_pci_mem_copy’ [-Wmissing-prototypes]
 69 | void pm80xx_pci_mem_copy(struct pm8001_hba_info *pm8001_ha, u32 soffset,
 | ^~~~~~~~~~~~~~~~~~~
 drivers/scsi/pm8001/pm80xx_hwi.c:5016:6: warning: no previous prototype for ‘mpi_set_phy_profile_req’ [-Wmissing-prototypes]
 5016 | void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
 | ^~~~~~~~~~~~~~~~~~~~~~~

Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index abcbd47162d64..b42f41d1ed49a 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -66,7 +66,7 @@ int pm80xx_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shift_value)
 	return 0;
 }
 
-void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u32 soffset,
+static void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u32 soffset,
 				const void *destination,
 				u32 dw_count, u32 bus_base_number)
 {
@@ -5013,8 +5013,9 @@ pm80xx_chip_isr(struct pm8001_hba_info *pm8001_ha, u8 vec)
 	return IRQ_HANDLED;
 }
 
-void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
-	u32 operation, u32 phyid, u32 length, u32 *buf)
+static void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
+				    u32 operation, u32 phyid,
+				    u32 length, u32 *buf)
 {
 	u32 tag , i, j = 0;
 	int rc;
-- 
2.25.1

