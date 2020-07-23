Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81912C433EC
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 627A122B43
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xFC5+L6q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbgGWMZS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728960AbgGWMZR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:17 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D32C0619DC
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:16 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id 88so4978210wrh.3
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KuXFDEYVsnsDfXIKt9wKPHYtC5k1C4IDk7HQmnmIHX4=;
        b=xFC5+L6qTksxCecGRt3nk4ZWSrIfiJ5KB8fRopA2KjkpV8FmkuJa0jtIZRe/PclS1a
         /4M87SpuupjQwVaqi01RBVgXJOs5dZDHD7Uuik52ZLmXYonwu+Hr2hgN20b8+D66Bqxh
         2Zesy56tksWGu5NWopASjeu6yF+zoGxk0PRr5O6eYmqqGpl0i02ozM/sLvikCsSdKJ3K
         SNtVxe9K8vzqtiJRA595fYK+tDZ5N95wcXGNptCKciO7aSs34z5mGknLQAKaJ/T33nr+
         QYSatN0QX3DXlIcbKV+D/IeXyMfxhJCd0e30ZyyDCJJu/v/tyMvmpnW706QoSu9E1XSu
         823A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KuXFDEYVsnsDfXIKt9wKPHYtC5k1C4IDk7HQmnmIHX4=;
        b=Xvs2n3nOCFmZqu029Am//koTFr0uwUUJijC4xQGVjRIdlFaEoY5sLGeNCu9ugGZun8
         19lrGxjm3GSkklebiHmM36/FYc9jmrL1nkI/etv7g9uFdE5y/Nyd0T7QhCTjsJWl5NT4
         WT/4Mvgp8NVdcXJPyBNrsrebuwj1nv9pMRpxFn1d3HrNl12drzJ4VJQp1gMRvkZ9Utg+
         xQOWGK6BFhIqDEY68RbW874WXX4RAOSkjzUnyXEWiDvFC8iVDRLfvz8uB1t41zU0S+lK
         UY9TJllBIO0+FVgnA20fBWXx/QnBu3b6aOnKXmF0VJUmQdtvj0E0mHHqkiXWnOxuEpK6
         RO5g==
X-Gm-Message-State: AOAM531FhhW+3hEcwSRCsKacHFCQET1j28VueJhbq4w5X1eENx6YWJM9
        /GOQWZVKHBsofStwEbCvbo/Nkg==
X-Google-Smtp-Source: ABdhPJxCnxCGnN7MmoQVRH8Z3jCjXBAJHu7Hl1DfZ7kT2ofsa6YfNX2BVf1YuitsN9T7DAfEI8Gn7w==
X-Received: by 2002:adf:df06:: with SMTP id y6mr3706057wrl.89.1595507115674;
        Thu, 23 Jul 2020 05:25:15 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:15 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 22/40] scsi: csiostor: csio_hw_t5: Remove 2 unused variables {mc,edc}_bist_status_rdata_reg
Date:   Thu, 23 Jul 2020 13:24:28 +0100
Message-Id: <20200723122446.1329773-23-lee.jones@linaro.org>
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

 drivers/scsi/csiostor/csio_hw_t5.c: In function ‘csio_t5_mc_read’:
 drivers/scsi/csiostor/csio_hw_t5.c:151:11: warning: variable ‘mc_bist_status_rdata_reg’ set but not used [-Wunused-but-set-variable]
 151 | uint32_t mc_bist_status_rdata_reg, mc_bist_data_pattern_reg;
 | ^~~~~~~~~~~~~~~~~~~~~~~~
 drivers/scsi/csiostor/csio_hw_t5.c: In function ‘csio_t5_edc_read’:
 drivers/scsi/csiostor/csio_hw_t5.c:199:38: warning: variable ‘edc_bist_status_rdata_reg’ set but not used [-Wunused-but-set-variable]
 199 | uint32_t edc_bist_cmd_data_pattern, edc_bist_status_rdata_reg;
 | ^~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/csiostor/csio_hw_t5.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_hw_t5.c b/drivers/scsi/csiostor/csio_hw_t5.c
index f24def6c6fd1e..1df8891d37251 100644
--- a/drivers/scsi/csiostor/csio_hw_t5.c
+++ b/drivers/scsi/csiostor/csio_hw_t5.c
@@ -148,12 +148,11 @@ csio_t5_mc_read(struct csio_hw *hw, int idx, uint32_t addr, __be32 *data,
 {
 	int i;
 	uint32_t mc_bist_cmd_reg, mc_bist_cmd_addr_reg, mc_bist_cmd_len_reg;
-	uint32_t mc_bist_status_rdata_reg, mc_bist_data_pattern_reg;
+	uint32_t mc_bist_data_pattern_reg;
 
 	mc_bist_cmd_reg = MC_REG(MC_P_BIST_CMD_A, idx);
 	mc_bist_cmd_addr_reg = MC_REG(MC_P_BIST_CMD_ADDR_A, idx);
 	mc_bist_cmd_len_reg = MC_REG(MC_P_BIST_CMD_LEN_A, idx);
-	mc_bist_status_rdata_reg = MC_REG(MC_P_BIST_STATUS_RDATA_A, idx);
 	mc_bist_data_pattern_reg = MC_REG(MC_P_BIST_DATA_PATTERN_A, idx);
 
 	if (csio_rd_reg32(hw, mc_bist_cmd_reg) & START_BIST_F)
@@ -196,7 +195,7 @@ csio_t5_edc_read(struct csio_hw *hw, int idx, uint32_t addr, __be32 *data,
 {
 	int i;
 	uint32_t edc_bist_cmd_reg, edc_bist_cmd_addr_reg, edc_bist_cmd_len_reg;
-	uint32_t edc_bist_cmd_data_pattern, edc_bist_status_rdata_reg;
+	uint32_t edc_bist_cmd_data_pattern;
 
 /*
  * These macro are missing in t4_regs.h file.
@@ -208,7 +207,6 @@ csio_t5_edc_read(struct csio_hw *hw, int idx, uint32_t addr, __be32 *data,
 	edc_bist_cmd_addr_reg = EDC_REG_T5(EDC_H_BIST_CMD_ADDR_A, idx);
 	edc_bist_cmd_len_reg = EDC_REG_T5(EDC_H_BIST_CMD_LEN_A, idx);
 	edc_bist_cmd_data_pattern = EDC_REG_T5(EDC_H_BIST_DATA_PATTERN_A, idx);
-	edc_bist_status_rdata_reg = EDC_REG_T5(EDC_H_BIST_STATUS_RDATA_A, idx);
 #undef EDC_REG_T5
 #undef EDC_STRIDE_T5
 
-- 
2.25.1

