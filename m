Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDDBCC4332D
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF66764F45
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhCQJNB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhCQJMp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:12:45 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C823BC06174A
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:44 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id 61so990807wrm.12
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4JQChJrJ8kh/QX5GDHmU/NgjW9SKy0ixrD8GB81+Yao=;
        b=okAQv3RjlV9ZaNNVDcKjLsomhYzxhr4oD6fJFOAwmr5rRTu8VFX8yb2E3SHIselm0l
         I0cWZkRI6AR1WjHsNnzSNL3y2aO9KF/FmdS/M4Ul9LpbLnylwWiGXp0crsoX6KldnEWy
         a/50lCBknJ0UC536Vn+04VKmyMl5ObPWHb0e5ysqVlu9rkdR6pZHtxQMfNGlQH0NUxAA
         CqGWDSC1jBc+ZJJ0LsIleZ894Srcji12b1tGe53uUvWyAyZZ3M5monKS/dEMD/ANs7Vq
         oKtKmW6mYFIILSm1X3pJ/jRZ1007toWHnF/dkRw0AhljPTU/XIJA2TzUGZfOQ69hl3j0
         HE0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4JQChJrJ8kh/QX5GDHmU/NgjW9SKy0ixrD8GB81+Yao=;
        b=qqlXFvXwWI7I3GNAhW6u16QnqD1AqlKayOtWyNvOikTi4P/y9uub9Rtz0T3boDmTNG
         KEcTrsyiK3Kprbvmq63G6yt4E86239RnQVMDWuTqM8Eb0k8X01+u+zjOF0okgscd1cCo
         T8Efo62DhO8PKQcpr8LqsKu1SJU8I51GcNvluETSC1RKe4wYy9XJjwh6auSPwTA4ApCx
         s5E/idlkacuytvNf8QeU6rJTU1v1dm3LYwUJ9aIEk45rmO76tCpFJfek52Qc82rHbfdE
         LhZgc7J0M4xUDXThmzaVggkeT4jspNvzNqQqX6gs+IVv+zL9XMqcIAmxM8WNdfnx7D95
         +yrA==
X-Gm-Message-State: AOAM533Q/jK/KvB6LnaiNq/piOeGWJNQccPeUAlJap6U2yq3CXzDi0P0
        k31a/df/Wv934UC+Uj6+KhiIGoKYXJWMWw==
X-Google-Smtp-Source: ABdhPJzrjGJ14rqOz4j2ylZJl+rxT1yYNDgxlBe1p+wbFshm3If+itDmT3lSktI7JdoScVZTwK5vCw==
X-Received: by 2002:adf:eb8e:: with SMTP id t14mr3340153wrn.20.1615972363572;
        Wed, 17 Mar 2021 02:12:43 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:12:43 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Le Moal <damien.lemoal@hgst.com>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 04/36] scsi: sd_zbc: Place function name into header
Date:   Wed, 17 Mar 2021 09:11:58 +0000
Message-Id: <20210317091230.2912389-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/sd_zbc.c:137: warning: wrong kernel-doc identifier on line:

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Le Moal <damien.lemoal@hgst.com>
Cc: Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/sd_zbc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index ee558675eab4a..232f624c3704f 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -134,7 +134,7 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 }
 
 /**
- * Allocate a buffer for report zones reply.
+ * sd_zbc_alloc_report_buffer() - Allocate a buffer for report zones reply.
  * @sdkp: The target disk
  * @nr_zones: Maximum number of zones to report
  * @buflen: Size of the buffer allocated
-- 
2.27.0

