Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B88C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBABE64EEC
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355715AbhCDAdI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244781AbhCCPLo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 10:11:44 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DBCC0613DC
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:46:40 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id h98so23950385wrh.11
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VTZlxPdC6tOaR4YW3uOVh3ivUP3wQLpmLCn/3aAS9PY=;
        b=fHCmsZu4raHnHQdTB+i+6PySCzKOYbYFaifk/WckOWyAjgve29tbXBa6Be1cQrc79F
         ngac8XpdaE5Xc/hEzofa3UtRMpHDeMyWg2ICUo55hs/OrXdsWXl+RPwfY7SxGK43DEIB
         ruf2LppCaWuY4eex3GF1A2DIRzdRoU0iB5wPAbz3jXoHo6HnTmIELcLYC+FXNjexOszd
         imO6OZKqdmR9vNwMrfiYslj570x1ajiD8NrE7bGNw3cbBAbVxxV4IGh+2NW83K8poJwu
         fExiuIhrUERigsEzlhnAItndOI0rU2shY/RBOczE/4U00yrLbWMuwAtg9RbeZSF8lG5m
         biHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VTZlxPdC6tOaR4YW3uOVh3ivUP3wQLpmLCn/3aAS9PY=;
        b=uP3B85Mtt/RUD51w5qz6YbGzjU+jeK25oETA96yYEdXyIIsr4POsn6do6igFPlUX7Q
         vvv8+Q1NmN1E+f/3+wgwHR3+5I5KnVBIMFtC2LbHvKofpYr+XG8Gqj09jcU8WSt8zKDw
         MNzI2Zffcp63jq8I710IEkrL/n8UpLX2AK1Toim1XlymySTnt9pTG+xbdBO+BZedQBO8
         GcuSllWqu5NARolPODk9uA8KvitGSbGhfVvtRg9VMaSh9ORj8NwUo5FE0LEWJZ+S/HyU
         lxmhJl+t33t0s70squTrbco2GpkdYvdG7FP5zlFzfiorSrfJJ/+sroCwV5YUzEnO4uxf
         G1XA==
X-Gm-Message-State: AOAM5303Z7r/9B8GLajQvC3nirRhm4cXDihB+Y0xa8Nti8Esa9oY9OGa
        9daywWXBE8F58SQlEJkCEOQ/bg==
X-Google-Smtp-Source: ABdhPJyFhsQoQvy6uw89GqgZ4zZnoNULvP5/4EAZhI7MUnzj4Z1DHvRJ1ti+fxtn80e4nur4abD8HQ==
X-Received: by 2002:adf:a2d3:: with SMTP id t19mr27314761wra.299.1614782799353;
        Wed, 03 Mar 2021 06:46:39 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:46:38 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH 02/30] scsi: megaraid: megaraid_sas_base: Fix a bunch of misnamed functions in their headers
Date:   Wed,  3 Mar 2021 14:46:03 +0000
Message-Id: <20210303144631.3175331-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/megaraid/megaraid_sas_base.c:483: warning: expecting prototype for megasas_clear_interrupt_xscale(). Prototype was for megasas_clear_intr_xscale() instead
 drivers/scsi/megaraid/megaraid_sas_base.c:666: warning: expecting prototype for megasas_clear_interrupt_ppc(). Prototype was for megasas_clear_intr_ppc() instead
 drivers/scsi/megaraid/megaraid_sas_base.c:795: warning: expecting prototype for megasas_clear_interrupt_skinny(). Prototype was for megasas_clear_intr_skinny() instead
 drivers/scsi/megaraid/megaraid_sas_base.c:943: warning: expecting prototype for megasas_clear_interrupt_gen2(). Prototype was for megasas_clear_intr_gen2() instead
 drivers/scsi/megaraid/megaraid_sas_base.c:4902: warning: expecting prototype for opcode(). Prototype was for megasas_host_device_list_query() instead
 drivers/scsi/megaraid/megaraid_sas_base.c:5173: warning: expecting prototype for megasas_get_controller_info(). Prototype was for megasas_get_ctrl_info() instead

Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: megaraidlinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 63a4f48bdc755..7f5fb714347e3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -475,7 +475,7 @@ megasas_read_fw_status_reg_xscale(struct megasas_instance *instance)
 	return readl(&instance->reg_set->outbound_msg_0);
 }
 /**
- * megasas_clear_interrupt_xscale -	Check & clear interrupt
+ * megasas_clear_intr_xscale -	Check & clear interrupt
  * @instance:	Adapter soft state
  */
 static int
@@ -658,7 +658,7 @@ megasas_read_fw_status_reg_ppc(struct megasas_instance *instance)
 }
 
 /**
- * megasas_clear_interrupt_ppc -	Check & clear interrupt
+ * megasas_clear_intr_ppc -	Check & clear interrupt
  * @instance:	Adapter soft state
  */
 static int
@@ -787,7 +787,7 @@ megasas_read_fw_status_reg_skinny(struct megasas_instance *instance)
 }
 
 /**
- * megasas_clear_interrupt_skinny -	Check & clear interrupt
+ * megasas_clear_intr_skinny -	Check & clear interrupt
  * @instance:	Adapter soft state
  */
 static int
@@ -935,7 +935,7 @@ megasas_read_fw_status_reg_gen2(struct megasas_instance *instance)
 }
 
 /**
- * megasas_clear_interrupt_gen2 -      Check & clear interrupt
+ * megasas_clear_intr_gen2 -      Check & clear interrupt
  * @instance:	Adapter soft state
  */
 static int
@@ -4884,6 +4884,7 @@ megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
 }
 
 /**
+ * megasas_host_device_list_query
  * dcmd.opcode            - MR_DCMD_CTRL_DEVICE_LIST_GET
  * dcmd.mbox              - reserved
  * dcmd.sge IN            - ptr to return MR_HOST_DEVICE_LIST structure
@@ -5161,7 +5162,7 @@ void megasas_get_snapdump_properties(struct megasas_instance *instance)
 }
 
 /**
- * megasas_get_controller_info -	Returns FW's controller structure
+ * megasas_get_ctrl_info -	Returns FW's controller structure
  * @instance:				Adapter soft state
  *
  * Issues an internal command (DCMD) to get the FW's controller structure.
-- 
2.27.0

