Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59826C43333
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A23E64F37
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhCQJNE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhCQJMt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:12:49 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154A8C061762
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:49 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id z2so1002513wrl.5
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JOb+P/qw104YPM5H9Pk4ZXuOVMmz3snbpqZtEzxVXZA=;
        b=F1h9XpvvlAIfIaTIkV910sK2Dtfb9XwkVVfR/pBYqkkhyXvxA6dE/288OwsBxgb0+h
         kuNekb0Wva2qFigdWkqcNEOXvOoiAUK7KKb20zkPxk3Lo2IBg4gCQ/S7x40AXiIcVXBt
         xaHoN3HLXxGGbrOLe0/O1u3xMDQtPiK6bM0lD2QhG48Qfskhi+Qc4vaT/ImCWVMN8h1n
         UhSpU54xHEmcIz6v14p2tFZ5sMcJjalNQWiOrErgbSYL3499emaJbMxxwmsVHwIBIrTy
         W4lX0d9BiGRxtBPKYqxWnFJwWRZq/dfZ/SQpX9SDzU9Jwc9sBPlDwqV8+oMhIluNllQ0
         TMLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JOb+P/qw104YPM5H9Pk4ZXuOVMmz3snbpqZtEzxVXZA=;
        b=e+8y2rqxFxWMBQQmERfhR4K7XW9Bvan+o2UQ7i0MsLlkJ9f1WPSe4QtQKRdmOPhCjq
         wokkvxl4MrXa5wZf8MlW8y5IMKTKR48XCcyktqgD/jq8FDNLdI4Xxo8P98Z4SnRfEWw2
         U+3gIKe9kSoHExLOzmk9coJEyhTWrxtjJLc+v3F4lweEC2ZIebARMfK9WAHRiyLCXm+F
         2FE7VNs2vg4U5P8T+tJXdqG2rX4dPg5RoKVIBot6fZkh7g5/SxuH0Xv92AzEOxAmEI4b
         OHZpjSrLg4ADfUI+9YI7y0xKZoxS1jCozdNVL+8RzXqrih43KWaUg7YKwm5sIYzErkrm
         8GuQ==
X-Gm-Message-State: AOAM533tbGsa/HEK4Gm1VlsZQjoILiHWqCqaF/v4rWbVQVOFLvSOdZkQ
        Z9VI+X7lsnVLdSFIfQs3gs6WmpXLKblZlg==
X-Google-Smtp-Source: ABdhPJwyw3IY56GgaarfpoxnIhJ43nSxiB70jKffGjLrw+e5KuXQi2wAjXliozYP4OSdytEqE1mBMw==
X-Received: by 2002:adf:df10:: with SMTP id y16mr3323925wrl.372.1615972367856;
        Wed, 17 Mar 2021 02:12:47 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:12:47 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-drivers@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH 08/36] scsi: be2iscsi: be_main: Ensure function follows directly after its header
Date:   Wed, 17 Mar 2021 09:12:02 +0000
Message-Id: <20210317091230.2912389-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/be2iscsi/be_main.c:4935: warning: expecting prototype for beiscsi_show_boot_tgt_info(). Prototype was for BEISCSI_SYSFS_ISCSI_BOOT_FLAGS() instead

Cc: Subbu Seetharaman <subbu.seetharaman@broadcom.com>
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-drivers@broadcom.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/be2iscsi/be_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index ab32ca535078d..eac67878b2b1b 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4926,14 +4926,13 @@ void beiscsi_start_boot_work(struct beiscsi_hba *phba, unsigned int s_handle)
 	schedule_work(&phba->boot_work);
 }
 
+#define BEISCSI_SYSFS_ISCSI_BOOT_FLAGS	3
 /**
  * beiscsi_show_boot_tgt_info()
  * Boot flag info for iscsi-utilities
  * Bit 0 Block valid flag
  * Bit 1 Firmware booting selected
  */
-#define BEISCSI_SYSFS_ISCSI_BOOT_FLAGS	3
-
 static ssize_t beiscsi_show_boot_tgt_info(void *data, int type, char *buf)
 {
 	struct beiscsi_hba *phba = data;
-- 
2.27.0

