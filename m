Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B1BC433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8588461027
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236598AbhDLBcc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 21:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236582AbhDLBc0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 21:32:26 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E818C06138E
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:09 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id s11so8173008pfm.1
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BwieeigzeFoBENMJF8wPUXuqGom8K+mWt4e9vDun6Ps=;
        b=GgERgGyTMVDGwIWEUR8EbgVahsEKeSRHNpu1Roi3lBm47+U0tjvFFzTe3DhEmP3bIc
         k4Gii1hT/vjg1d/MmY052bJR6c1z1fLsMNuofX7MSqH4Tkch7dfWIohopGLjAKLMD7nY
         tkuv9mKXSrtgCm/+yRpL0dWiunHth9/mTRMwBFKG7H7usC5RSCHe0uSnc5V9VCOa2vNY
         rQwfjylpYkDllTN/5myVHuqOG+NVEl2xbKG5Qha+YfPlqrUmoJTzDyVHgeyIhPci123S
         T3S3fT7T9g56FkWmoX6iqzk+Qp72b7LJy5L84ATIwkWbtxOtJrqKrma9rc4Z5Yr8HyPq
         5qdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BwieeigzeFoBENMJF8wPUXuqGom8K+mWt4e9vDun6Ps=;
        b=ds5rwLUv/TWO8mEYMxq0ZGfEHjAN6auycB7J0//mCiLB4wFmN6AexHpyOS6r06FwFn
         D/HtZju2+2lcQDhSUhNfQbOWBixRWVQR6QkPzJWmAJ4+456hyLmdMxF9wr42+b3DRL60
         QTjdgs3z8BPNc6pRYXDO0jSzYw6lpmC+1iRO2ghrq0C3ltpyTHM57URcQohnqq7oesEx
         4MsRGKYhUqfswzfJ4TlQ1q0WoeqFL/0lfSwEmGTVVDwmENxgfduObYHKbPqxDGVmnt1c
         dXSWAuw7sc4C9R6toTpVk0/LrHDP8ncwRoZhbVHMuBa/qq2H/53N/KEJ41aqm4y8Z7Xf
         wPSw==
X-Gm-Message-State: AOAM532S1RvjVJ2evY3nkNeOUY3r8BpBNyV7j94YXW09wsjRIB/CdWIs
        3qbCaTL08J9Wa79UmubYoBU4afeS8GY=
X-Google-Smtp-Source: ABdhPJx7WX7Y4lT961ehVBiuyMdJPfYBpLR9cKEkzgFTay2mZj15oc9GFyIyEQPtKp4vfprIAdBBAg==
X-Received: by 2002:a65:5088:: with SMTP id r8mr23977099pgp.434.1618191128646;
        Sun, 11 Apr 2021 18:32:08 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id i17sm8153163pfd.84.2021.04.11.18.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:32:08 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2 14/16] lpfc: Eliminate use of LPFC_DRIVER_NAME in lpfc_attr.c
Date:   Sun, 11 Apr 2021 18:31:25 -0700
Message-Id: <20210412013127.2387-15-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210412013127.2387-1-jsmart2021@gmail.com>
References: <20210412013127.2387-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During code inspection, several cases of creating a dynamic attribute
names in logs messages using a define was found. This is unnecessary.

Place the native symbol name in the log messages.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index de5a21998b96..34993df21e2b 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2274,14 +2274,14 @@ lpfc_enable_bbcr_set(struct lpfc_hba *phba, uint val)
 {
 	if (lpfc_rangecheck(val, 0, 1) && phba->sli_rev == LPFC_SLI_REV4) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"3068 %s_enable_bbcr changed from %d to %d\n",
-				LPFC_DRIVER_NAME, phba->cfg_enable_bbcr, val);
+				"3068 lpfc_enable_bbcr changed from %d to "
+				"%d\n", phba->cfg_enable_bbcr, val);
 		phba->cfg_enable_bbcr = val;
 		return 0;
 	}
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"0451 %s_enable_bbcr cannot set to %d, range is 0, 1\n",
-			LPFC_DRIVER_NAME, val);
+			"0451 lpfc_enable_bbcr cannot set to %d, range is 0, "
+			"1\n", val);
 	return -EINVAL;
 }
 
@@ -2724,8 +2724,8 @@ lpfc_soft_wwn_enable_store(struct device *dev, struct device_attribute *attr,
 	 */
 	if (vvvl == 1 && cpu_to_be32(*fawwpn_key) == FAPWWN_KEY_VENDOR) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				 "0051 "LPFC_DRIVER_NAME" soft wwpn can not"
-				 " be enabled: fawwpn is enabled\n");
+				"0051 lpfc soft wwpn can not be enabled: "
+				"fawwpn is enabled\n");
 		return -EINVAL;
 	}
 
@@ -5210,8 +5210,8 @@ lpfc_cq_max_proc_limit_init(struct lpfc_hba *phba, int val)
 	}
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"0371 "LPFC_DRIVER_NAME"_cq_max_proc_limit: "
-			"%d out of range, using default\n",
+			"0371 lpfc_cq_max_proc_limit: %d out of range, using "
+			"default\n",
 			phba->cfg_cq_max_proc_limit);
 
 	return 0;
@@ -6045,8 +6045,8 @@ lpfc_sg_seg_cnt_init(struct lpfc_hba *phba, int val)
 		return 0;
 	}
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"0409 "LPFC_DRIVER_NAME"_sg_seg_cnt attribute cannot "
-			"be set to %d, allowed range is [%d, %d]\n",
+			"0409 lpfc_sg_seg_cnt attribute cannot be set to %d, "
+			"allowed range is [%d, %d]\n",
 			val, LPFC_MIN_SG_SEG_CNT, LPFC_MAX_SG_SEG_CNT);
 	phba->cfg_sg_seg_cnt = LPFC_DEFAULT_SG_SEG_CNT;
 	return -EINVAL;
-- 
2.26.2

