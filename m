Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501EEC433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Feb 2022 18:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiBGSLj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Feb 2022 13:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353483AbiBGSFZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2022 13:05:25 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B385C0401D9
        for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2022 10:05:24 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so14419457pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 07 Feb 2022 10:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6xOnRo1Z7PPIqIudF7phH8u1+taouQWD8xyYRjZSRz8=;
        b=UJ7Lqyzel56R1TWZGeHu3Q1xKL5STrAltB9oGvkFS22m6LY6Ngfy5JeKWBIQPl1ytB
         q2/SXwNDK/j+hNvf1Iz4aqsrCn0vEzE6UjBn9UnlT6HdyOO/n6jFfBvkfDjXRKAHaR2x
         W7A+v9LGeA9EuI5EV5RYkEnwkJWjnAQT6OHwSC8IZNcDsjFlqbF+8RuILI8VZp2NDuGD
         /XyrzE/YjoWSfeCB6N8czVbmjP5cuWeNot8KcP6nQb998HGLGuUka0d1THw3I/hJSTcu
         uaplJIyoRGWxMKrhknKV6+dUiKnknlcp0peCvz/eOnXqk6klmtTs3AxH33kJ0cSWZr+s
         ONtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6xOnRo1Z7PPIqIudF7phH8u1+taouQWD8xyYRjZSRz8=;
        b=PjjpOEnavNv8lUxfBqGXU5e708zKVIJtBZKRcmJGoWxhAJgQkT2FBbIpQR3M7psbxI
         l+aU/2813Y7Y4Ova9ucCJIRPWjxAkuOewrfENMZJ9B6nZUUePJufxJ+j9Ck6nUrLHBcY
         QVUQ52jyPJyyxtyATvBVDvQ/foqix3TPEgo98IWdts2zRxBVKCab8UoJsVwq2JJGj+U1
         /Q5BAmmpuU/9PzzAWa0ut4+lPubv46TTJmIKfYk3HsaWxwP4oBsFKRJMn5zDkt7HgDb6
         s5Rs7gPH+5Ay99LgqOHvp/0l1k2meSQOUZc1QvMDvbkhmRZgTVoHegWPz7pBDO9ky7jx
         J+hQ==
X-Gm-Message-State: AOAM533aAZSJodYVzjX33Bi6tR+QO030oL3aC034cXC8KonqDd7jx8PN
        hlJlmyyprYzhlkAb90AR+23TG25zZ0M=
X-Google-Smtp-Source: ABdhPJz//iSjgg4iYcGirBioH99yR2iWjp/d4cOhhjpa36TAlyk2BYbsL9xS8JvlT/zOF0aIhO9UOQ==
X-Received: by 2002:a17:90a:6585:: with SMTP id k5mr151166pjj.94.1644257123936;
        Mon, 07 Feb 2022 10:05:23 -0800 (PST)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u9sm4722019pfi.19.2022.02.07.10.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 10:05:23 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH] lpfc: Remove NVME protocol support of kernel has NVME_FC support disabled
Date:   Mon,  7 Feb 2022 10:05:16 -0800
Message-Id: <20220207180516.73052-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver is intiating NVME PRLI's to determine NVME support to devices.
This should not be occurring if CONFIG_NVME_FC support is disabled.

Corrected by changing the default value for FC4 support. Currently it
defaults to FCP and NVME. With change, when NVME_FC support is not enabled
in the kernel, the default value is just SCSI.

Cut against 5.18/scsi-queue

Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h      | 13 ++++++++++---
 drivers/scsi/lpfc/lpfc_attr.c |  4 ++--
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 4878c94761f9..a1e0a106c132 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1161,6 +1161,16 @@ struct lpfc_hba {
 	uint32_t cfg_hostmem_hgp;
 	uint32_t cfg_log_verbose;
 	uint32_t cfg_enable_fc4_type;
+#define LPFC_ENABLE_FCP  1
+#define LPFC_ENABLE_NVME 2
+#define LPFC_ENABLE_BOTH 3
+#if (IS_ENABLED(CONFIG_NVME_FC))
+#define LPFC_MAX_ENBL_FC4_TYPE LPFC_ENABLE_BOTH
+#define LPFC_DEF_ENBL_FC4_TYPE LPFC_ENABLE_BOTH
+#else
+#define LPFC_MAX_ENBL_FC4_TYPE LPFC_ENABLE_FCP
+#define LPFC_DEF_ENBL_FC4_TYPE LPFC_ENABLE_FCP
+#endif
 	uint32_t cfg_aer_support;
 	uint32_t cfg_sriov_nr_virtfn;
 	uint32_t cfg_request_firmware_upgrade;
@@ -1182,9 +1192,6 @@ struct lpfc_hba {
 	uint32_t cfg_ras_fwlog_func;
 	uint32_t cfg_enable_bbcr;	/* Enable BB Credit Recovery */
 	uint32_t cfg_enable_dpp;	/* Enable Direct Packet Push */
-#define LPFC_ENABLE_FCP  1
-#define LPFC_ENABLE_NVME 2
-#define LPFC_ENABLE_BOTH 3
 	uint32_t cfg_enable_pbde;
 	uint32_t cfg_enable_mi;
 	struct nvmet_fc_target_port *targetport;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 7a7f17d71811..bac78fbce8d6 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3978,8 +3978,8 @@ LPFC_ATTR_R(nvmet_mrq_post,
  *                    3 - register both FCP and NVME
  * Supported values are [1,3]. Default value is 3
  */
-LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_BOTH,
-	    LPFC_ENABLE_FCP, LPFC_ENABLE_BOTH,
+LPFC_ATTR_R(enable_fc4_type, LPFC_DEF_ENBL_FC4_TYPE,
+	    LPFC_ENABLE_FCP, LPFC_MAX_ENBL_FC4_TYPE,
 	    "Enable FC4 Protocol support - FCP / NVME");
 
 /*
-- 
2.26.2

