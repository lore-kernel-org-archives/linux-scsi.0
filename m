Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6685BC43461
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42E72611AE
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbhDJRbL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 13:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbhDJRbI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 13:31:08 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D77DC06138B
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:53 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id n38so6391927pfv.2
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BwieeigzeFoBENMJF8wPUXuqGom8K+mWt4e9vDun6Ps=;
        b=syBmdUcbyYnKEYZApOWp3ZGijnmoyJ5Q/+ye+RPLFCDk7p+4QWU78DLF+9MHjItRUn
         1FnASg23zcmBsimXHyjQoV8oTbTV+druJajHaFaysi27IN4IrBrd1y+H/q8iIQ+JrNB6
         xpV4LHruVyyc045ukUHFl3hJtlyRgziF16dAQ+9MmIRCQYUPKW9ijaZGbqmrYIZqw0m2
         +ktdCoOd7EsnvHg0eVdOHLl8yC52Th7K5b2hbK35UxoNkGhxOaJrw6IMT0M3zFY7XK/X
         VteRTOm9QM+sMjthcpJ6s1bNjzN2oHUIEXV3npDF78SRHZjSuFfHFYv9MM8M1EezhJlp
         ovjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BwieeigzeFoBENMJF8wPUXuqGom8K+mWt4e9vDun6Ps=;
        b=thJDqs8v9GIBgedBWcYfk9tWXCu8/jIcTh6tcHhDxfczuJjrbhuPYNHjvnzJSb2qJB
         ProeiOtExg+4zIhwpMt9CIIJ+xHsrZepwUGNkla1fMp/wZVQEIlR6uUiaubPtpE/4dNs
         k0wDCdfz5d3hc778R7CBB07U9EQW46ucuVGVT0EXDb+7mJfpyzrrC7QR4lVAokBHcN9V
         guR0HH4e9QItyBOQngz/+VkU432lG8tw0lK72OZyJ4HWqLhdU9mQZq+c1IHoFwwMjkZe
         fML0BzO9/SNMFulA6W7fFsZJ0GxQGzOrCu6XGLFQvU09CCmTcs6DcSQZZoD94Jat2UMo
         ovBQ==
X-Gm-Message-State: AOAM53273X8OgiFXSZt7gShnxOA64+2+CHaezQD40F+lvDlks3GXPWNP
        /kPZcF5GbexQy2KEVYnlkCERFqoAxc8=
X-Google-Smtp-Source: ABdhPJwgdnFa3/v7QzIRzWjbeo9zpfS0rGsvzpIUWDk4AWmtaXvQL+xBEmFzWJlSqrH52bMOYVMVfg==
X-Received: by 2002:a63:d61:: with SMTP id 33mr18919969pgn.201.1618075852952;
        Sat, 10 Apr 2021 10:30:52 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x25sm5578861pfu.189.2021.04.10.10.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 10:30:52 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 14/16] lpfc: Eliminate use of LPFC_DRIVER_NAME in lpfc_attr.c
Date:   Sat, 10 Apr 2021 10:30:32 -0700
Message-Id: <20210410173034.67618-15-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210410173034.67618-1-jsmart2021@gmail.com>
References: <20210410173034.67618-1-jsmart2021@gmail.com>
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

