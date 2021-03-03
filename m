Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B2ACC433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0576A64E51
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359761AbhCDAck (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbhCCOv1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:51:27 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95AE2C0610CF
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:47:43 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id e10so23732720wro.12
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JU+OzGlISHB+ge1qgBUvVjRrdCnCO3htiJjDL9pREeI=;
        b=HMc50qQh9cd09cYIG6QD01/h5niTz8bCPw+HzI7Uoq2lfsa5UdM82wOWPB4CaMvNCB
         D12iH/DnSU77N2Wqbifg4N4gogw7biGBujJaDOOOiGZhRwfOO9/+QwDOIsjZ3A2D39sd
         AGaYWCydcZHeKZSrddaxPyCsL15QNbl9PodDCfhfbujtibFR27Sz7pNwfQX8x9JWpuTY
         jhpgpYvM0NrNPI3eRk3SCJRj4XKVTE9doLezAu3T3lLtPAXeZwbKnc64RqecWYidCBTK
         OOluURq+Rj5P4br22cS8LNl8wuFHlc6nCUh5hVplBTIqdybzDQH22lNeleZDOjJULbAO
         /DTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JU+OzGlISHB+ge1qgBUvVjRrdCnCO3htiJjDL9pREeI=;
        b=AaUX7fVWJpTP63WP/XT+rsLE58rvM7VuIJo2BK71oBXRIC0BMc8XXrf2ILCMknu7j8
         6MAjz8N6hjcFwUTHog1kAgW/+AM+AB+EGlJffQxKV3RO9G8S/BK4DxbuvHUNfpvYut0p
         7IYcJ6ou7xaRvbwEngK0uVWjs3x1C0sT6ySUEq8S9EruSqdV4qrvd+pnZsPYQ9mDuf4Z
         s51EB5fCRiw53zuOu2rIYknd9KvLJd7lze56FCCwaQbBQP0dlri9VEABEmv8uBkV7G2t
         a8A0seA4cWM9M+s9qmex1PJzGxcJmDMVRzA+Z3RppH1O/hNOuSWI0CvNndzLprqaUs8F
         /4Lw==
X-Gm-Message-State: AOAM532nVkx+UPnf+LSC7F76sLtkEh/ff9kHzNppxiQJJFMMOXqmh+Fw
        g21KqqqcGtvz2/Uoth43W24hbA==
X-Google-Smtp-Source: ABdhPJxhtMo2M6F/ShADs7uYEfBexSffsMa/v3IkcujKLhJKFjIkQau6EXGVtp2IPZS/6KsyLAriMg==
X-Received: by 2002:adf:80c8:: with SMTP id 66mr28035909wrl.344.1614782862246;
        Wed, 03 Mar 2021 06:47:42 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:47:41 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 24/30] scsi: aacraid: rx: Fix misspelling of _aac_rx_init()
Date:   Wed,  3 Mar 2021 14:46:25 +0000
Message-Id: <20210303144631.3175331-25-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aacraid/rx.c:544: warning: expecting prototype for aac_rx_init(). Prototype was for _aac_rx_init() instead

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aacraid/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index cdccf9abcdc40..e06ff83b69ce2 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -532,7 +532,7 @@ int aac_rx_select_comm(struct aac_dev *dev, int comm)
 }
 
 /**
- *	aac_rx_init	-	initialize an i960 based AAC card
+ *	_aac_rx_init	-	initialize an i960 based AAC card
  *	@dev: device to configure
  *
  *	Allocate and set up resources for the i960 based AAC variants. The 
-- 
2.27.0

