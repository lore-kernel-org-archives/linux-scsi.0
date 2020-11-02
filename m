Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92429C00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28CF92072C
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:25:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PK2B9zbt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgKBOZk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 09:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgKBOYL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 09:24:11 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E59C061A48
        for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2020 06:24:10 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id n18so14816196wrs.5
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2020 06:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h8LR5dZvOr6PkOQa4lRXQ4kxM6PQGBwW0R1DcsSPVnc=;
        b=PK2B9zbtXtwEsr0trilNkP0DNyi/vt6CJVGoj2YYvE2VTqZmxKpirBT3VMYFniQViQ
         ko8A/B1XuFNNOdoyOSkfPmkIZ1HXJ9VswPoNsNsAQXaEBlEKkGFfjH7wmliWGJpgDmGN
         oSMBn2d2KBSHqDuFaByTKB/4GVTXl9i9Q1nKzVoaHl6ViKy8Z6Y2RUbMx4qN9L2YTlFd
         OlRmBmNxkpjUWU8iLGEfz5EaHrGcF5qrFU1aQjP0e+ovezsw1Bu+SLd6FsBBtrf1xCfR
         laePreZqQyPsMdahpU7NEwiA+SLk/18WC3tJI7jQRIjzoUPUp8CRxWrVQyL64QpT07MD
         4RYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h8LR5dZvOr6PkOQa4lRXQ4kxM6PQGBwW0R1DcsSPVnc=;
        b=DMdij0wrXWDVH/10G0mqWz+/V7+wIqqVjwVtURYCq9rirYs9TrkGbZDOCE7bqNUg8f
         +01Sxp/3HnJ+RaRBSoPpQ2Hk56pilt1/5do0badP7aiOccZZBH3YHtXrkB7OUXwpyXvO
         IkPc5qct5+LfNjb7Jx8O29JqXNBFh6B7G+wZvN5l88FxDjn2p5mbMffkxuCHZ+OKrb9I
         7Gmj6cQEShYbTkkygEWANkxY4lxy+Rd3ojOG4RRMTLJDVTZb7O+d1JkHBdowqG9ErnFz
         Z37S9YYds850eCXL40fXQFtv891QI2APhY7wXaXhahVU8CTJUVTNgiXMtXhRDq8WsfC5
         rwuA==
X-Gm-Message-State: AOAM531vGuLSxhp2f3OmiJz92RuExlSTj3DNUMN+qGbNsM268MkZ7PI+
        thk7OH3oz/LV9nkwOjLG5y5qTw==
X-Google-Smtp-Source: ABdhPJwx0V1DilINXPwjiX/57vYvQ4ylON3gH1C10luon9dgChKri4PN+9TVqog8U9mKO2m2LdnAkQ==
X-Received: by 2002:a5d:4e8f:: with SMTP id e15mr10294423wru.390.1604327049404;
        Mon, 02 Nov 2020 06:24:09 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id f7sm23542501wrx.64.2020.11.02.06.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 06:24:08 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [RESEND 04/19] scsi: lpfc: lpfc_attr: Demote kernel-doc format for redefined functions
Date:   Mon,  2 Nov 2020 14:23:44 +0000
Message-Id: <20201102142359.561122-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102142359.561122-1-lee.jones@linaro.org>
References: <20201102142359.561122-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Kernel-doc does not understand this use-case.

Fixes the following W=1 kernel build warning(s):

 from drivers/scsi/lpfc/lpfc_attr.c:26:
 inlined from ‘lpfc_stat_data_ctrl_store’ at drivers/scsi/lpfc/lpfc_attr.c:4164:3:
 drivers/scsi/lpfc/lpfc_attr.c:2315: warning: Excess function parameter 'dev' description in 'lpfc_param_show'
 drivers/scsi/lpfc/lpfc_attr.c:2315: warning: Excess function parameter 'buf' description in 'lpfc_param_show'
 drivers/scsi/lpfc/lpfc_attr.c:2343: warning: Excess function parameter 'dev' description in 'lpfc_param_hex_show'
 drivers/scsi/lpfc/lpfc_attr.c:2343: warning: Excess function parameter 'buf' description in 'lpfc_param_hex_show'
 drivers/scsi/lpfc/lpfc_attr.c:2377: warning: Function parameter or member 'attr' not described in 'lpfc_param_init'
 drivers/scsi/lpfc/lpfc_attr.c:2377: warning: Function parameter or member 'default' not described in 'lpfc_param_init'
 drivers/scsi/lpfc/lpfc_attr.c:2377: warning: Function parameter or member 'minval' not described in 'lpfc_param_init'
 drivers/scsi/lpfc/lpfc_attr.c:2377: warning: Function parameter or member 'maxval' not described in 'lpfc_param_init'
 drivers/scsi/lpfc/lpfc_attr.c:2377: warning: Excess function parameter 'phba' description in 'lpfc_param_init'
 drivers/scsi/lpfc/lpfc_attr.c:2377: warning: Excess function parameter 'val' description in 'lpfc_param_init'
 drivers/scsi/lpfc/lpfc_attr.c:2414: warning: Function parameter or member 'attr' not described in 'lpfc_param_set'
 drivers/scsi/lpfc/lpfc_attr.c:2414: warning: Function parameter or member 'default' not described in 'lpfc_param_set'
 drivers/scsi/lpfc/lpfc_attr.c:2414: warning: Function parameter or member 'minval' not described in 'lpfc_param_set'
 drivers/scsi/lpfc/lpfc_attr.c:2414: warning: Function parameter or member 'maxval' not described in 'lpfc_param_set'
 drivers/scsi/lpfc/lpfc_attr.c:2414: warning: Excess function parameter 'phba' description in 'lpfc_param_set'
 drivers/scsi/lpfc/lpfc_attr.c:2414: warning: Excess function parameter 'val' description in 'lpfc_param_set'
 drivers/scsi/lpfc/lpfc_attr.c:2454: warning: Excess function parameter 'dev' description in 'lpfc_param_store'
 drivers/scsi/lpfc/lpfc_attr.c:2454: warning: Excess function parameter 'buf' description in 'lpfc_param_store'
 drivers/scsi/lpfc/lpfc_attr.c:2454: warning: Excess function parameter 'count' description in 'lpfc_param_store'
 drivers/scsi/lpfc/lpfc_attr.c:2478: warning: Excess function parameter 'dev' description in 'lpfc_vport_param_show'
 drivers/scsi/lpfc/lpfc_attr.c:2478: warning: Excess function parameter 'buf' description in 'lpfc_vport_param_show'
 drivers/scsi/lpfc/lpfc_attr.c:2503: warning: Excess function parameter 'dev' description in 'lpfc_vport_param_hex_show'
 drivers/scsi/lpfc/lpfc_attr.c:2503: warning: Excess function parameter 'buf' description in 'lpfc_vport_param_hex_show'
 drivers/scsi/lpfc/lpfc_attr.c:2536: warning: Function parameter or member 'attr' not described in 'lpfc_vport_param_init'
 drivers/scsi/lpfc/lpfc_attr.c:2536: warning: Function parameter or member 'default' not described in 'lpfc_vport_param_init'
 drivers/scsi/lpfc/lpfc_attr.c:2536: warning: Function parameter or member 'minval' not described in 'lpfc_vport_param_init'
 drivers/scsi/lpfc/lpfc_attr.c:2536: warning: Function parameter or member 'maxval' not described in 'lpfc_vport_param_init'
 drivers/scsi/lpfc/lpfc_attr.c:2536: warning: Excess function parameter 'phba' description in 'lpfc_vport_param_init'
 drivers/scsi/lpfc/lpfc_attr.c:2536: warning: Excess function parameter 'val' description in 'lpfc_vport_param_init'
 drivers/scsi/lpfc/lpfc_attr.c:2572: warning: Function parameter or member 'attr' not described in 'lpfc_vport_param_set'
 drivers/scsi/lpfc/lpfc_attr.c:2572: warning: Function parameter or member 'default' not described in 'lpfc_vport_param_set'
 drivers/scsi/lpfc/lpfc_attr.c:2572: warning: Function parameter or member 'minval' not described in 'lpfc_vport_param_set'
 drivers/scsi/lpfc/lpfc_attr.c:2572: warning: Function parameter or member 'maxval' not described in 'lpfc_vport_param_set'
 drivers/scsi/lpfc/lpfc_attr.c:2572: warning: Excess function parameter 'phba' description in 'lpfc_vport_param_set'
 drivers/scsi/lpfc/lpfc_attr.c:2572: warning: Excess function parameter 'val' description in 'lpfc_vport_param_set'
 drivers/scsi/lpfc/lpfc_attr.c:2607: warning: Function parameter or member 'attr' not described in 'lpfc_vport_param_store'
 drivers/scsi/lpfc/lpfc_attr.c:2607: warning: Excess function parameter 'cdev' description in 'lpfc_vport_param_store'
 drivers/scsi/lpfc/lpfc_attr.c:2607: warning: Excess function parameter 'buf' description in 'lpfc_vport_param_store'
 drivers/scsi/lpfc/lpfc_attr.c:2607: warning: Excess function parameter 'count' description in 'lpfc_vport_param_store'
 drivers/scsi/lpfc/lpfc_attr.c:7081: warning: Function parameter or member 'field' not described in 'lpfc_rport_show_function'
 drivers/scsi/lpfc/lpfc_attr.c:7081: warning: Function parameter or member 'format_string' not described in 'lpfc_rport_show_function'
 drivers/scsi/lpfc/lpfc_attr.c:7081: warning: Function parameter or member 'sz' not described in 'lpfc_rport_show_function'
 drivers/scsi/lpfc/lpfc_attr.c:7081: warning: Function parameter or member 'cast' not described in 'lpfc_rport_show_function'
 drivers/scsi/lpfc/lpfc_attr.c:7081: warning: Excess function parameter 'cdev' description in 'lpfc_rport_show_function'
 drivers/scsi/lpfc/lpfc_attr.c:7081: warning: Excess function parameter 'buf' description in 'lpfc_rport_show_function'

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_attr.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 0673d944c2a81..6a33f0607cc8b 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1501,6 +1501,7 @@ lpfc_sli4_pdev_status_reg_wait(struct lpfc_hba *phba)
 /**
  * lpfc_sli4_pdev_reg_request - Request physical dev to perform a register acc
  * @phba: lpfc_hba pointer.
+ * @opcode: The sli4 config command opcode.
  *
  * Description:
  * Request SLI4 interface type-2 device to perform a physical register set
@@ -2284,7 +2285,7 @@ lpfc_enable_bbcr_set(struct lpfc_hba *phba, uint val)
 	return -EINVAL;
 }
 
-/**
+/*
  * lpfc_param_show - Return a cfg attribute value in decimal
  *
  * Description:
@@ -2310,7 +2311,7 @@ lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
 			phba->cfg_##attr);\
 }
 
-/**
+/*
  * lpfc_param_hex_show - Return a cfg attribute value in hex
  *
  * Description:
@@ -2338,7 +2339,7 @@ lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
 			phba->cfg_##attr);\
 }
 
-/**
+/*
  * lpfc_param_init - Initializes a cfg attribute
  *
  * Description:
@@ -2372,7 +2373,7 @@ lpfc_##attr##_init(struct lpfc_hba *phba, uint val) \
 	return -EINVAL;\
 }
 
-/**
+/*
  * lpfc_param_set - Set a cfg attribute value
  *
  * Description:
@@ -2409,7 +2410,7 @@ lpfc_##attr##_set(struct lpfc_hba *phba, uint val) \
 	return -EINVAL;\
 }
 
-/**
+/*
  * lpfc_param_store - Set a vport attribute value
  *
  * Description:
@@ -2449,7 +2450,7 @@ lpfc_##attr##_store(struct device *dev, struct device_attribute *attr, \
 		return -EINVAL;\
 }
 
-/**
+/*
  * lpfc_vport_param_show - Return decimal formatted cfg attribute value
  *
  * Description:
@@ -2473,7 +2474,7 @@ lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
 	return scnprintf(buf, PAGE_SIZE, "%d\n", vport->cfg_##attr);\
 }
 
-/**
+/*
  * lpfc_vport_param_hex_show - Return hex formatted attribute value
  *
  * Description:
@@ -2498,7 +2499,7 @@ lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
 	return scnprintf(buf, PAGE_SIZE, "%#x\n", vport->cfg_##attr);\
 }
 
-/**
+/*
  * lpfc_vport_param_init - Initialize a vport cfg attribute
  *
  * Description:
@@ -2531,7 +2532,7 @@ lpfc_##attr##_init(struct lpfc_vport *vport, uint val) \
 	return -EINVAL;\
 }
 
-/**
+/*
  * lpfc_vport_param_set - Set a vport cfg attribute
  *
  * Description:
@@ -2567,7 +2568,7 @@ lpfc_##attr##_set(struct lpfc_vport *vport, uint val) \
 	return -EINVAL;\
 }
 
-/**
+/*
  * lpfc_vport_param_store - Set a vport attribute
  *
  * Description:
@@ -7061,7 +7062,7 @@ lpfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 #endif
 }
 
-/**
+/*
  * lpfc_rport_show_function - Return rport target information
  *
  * Description:
-- 
2.25.1

