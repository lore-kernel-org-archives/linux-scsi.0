Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F335C43381
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBA5164FFB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhCLJse (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbhCLJsE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:48:04 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0D0C061765
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:03 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id j4-20020a05600c4104b029010c62bc1e20so14792030wmi.3
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JI6G3CFZx8fwaZ+wMXfyA1uTc9sykYtKryE0jb27AH8=;
        b=LvZZjQqh+hYVHovFbGfa2YimjbNcopAKf2FZ41k0JafVuhVFK5teA3JpIbZo04IirG
         T3FE3HwLMHe3hRd4f1e7pYFuzKcngzqClIHRJv58wKOf6YLyHr3oW4NEZFrlvIPqiAAD
         umvPHJzcpzO3EazANHiX3Z7AWtRY+KMq52oDleuaqE9FW91NrAZefDoeKN0dTnaSosX7
         2x2qTmSphRDpvMTdnfVqbdq2Tp0ry+NQoyXkK+cxZOn14bKVik5jWKcbf0LTIfBpgqwi
         qvPSsYPc25e6pL72RE1CUAk1N+qZT0yk5IYUEdanwW0Ul3rymue2UDxEZXoyyu9DE5ab
         7TXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JI6G3CFZx8fwaZ+wMXfyA1uTc9sykYtKryE0jb27AH8=;
        b=mbJr13CPrVOoYFSy2PXwxha8IxmbxeOHS++4rRKKTqKScKWPaso+4Gdyv0nUG+10FI
         gcafGQRisUlkZq+c5RmI+usdikrzruKNgvItIjMMSBGr18D4UjF3J7AcVWEU6Dg5p4WA
         izN4WVvTtNF5emtCS6XgF3F35qoMH3sJX6EWWwfacWx9HXcd+tIg6Aslv+7w6sBRIgVq
         9DGWw3u2eB6EaRMn6d3SAU9Tp0dvHcbRQ0QcSsgwceDXYMVeTc1flwIzI+nEQDeJYYY2
         1D+QcFZL5hhjlV9er3GpANKaCC0RI4ziKQ5+6oLncoaHk/GwfXiK69BRoSJvJ0IMjNZS
         3ERA==
X-Gm-Message-State: AOAM530jdWo4RAoGFF9pnQV4z9PlVZ8g6jHRHFB5HKFQmNL7rieIfd8y
        GulIGZ/585mmWYNERW9WQn3OSg==
X-Google-Smtp-Source: ABdhPJwgu+dYkUSJIPzhrkavhgPa19SJxwU7Gw7kkrY+EIpO5oTC5zDDwsUJvZSioQsoR2R3olJXOQ==
X-Received: by 2002:a1c:9817:: with SMTP id a23mr12073936wme.57.1615542482068;
        Fri, 12 Mar 2021 01:48:02 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:48:01 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 12/30] scsi: lpfc: lpfc_debugfs: Fix incorrectly documented function lpfc_debugfs_commonxripools_data()
Date:   Fri, 12 Mar 2021 09:47:20 +0000
Message-Id: <20210312094738.2207817-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_debugfs.c:405: warning: expecting prototype for lpfc_debugfs_common_xri_data(). Prototype was for lpfc_debugfs_commonxripools_data() instead

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index ec5328f7f1d41..c23a535ac89ac 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -381,7 +381,7 @@ lpfc_debugfs_hbqinfo_data(struct lpfc_hba *phba, char *buf, int size)
 static int lpfc_debugfs_last_xripool;
 
 /**
- * lpfc_debugfs_common_xri_data - Dump Hardware Queue info to a buffer
+ * lpfc_debugfs_commonxripools_data - Dump Hardware Queue info to a buffer
  * @phba: The HBA to gather host buffer info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
-- 
2.27.0

