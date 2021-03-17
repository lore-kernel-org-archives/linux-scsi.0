Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC967C4321A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90F9A64F26
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhCQI55 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbhCQI5V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 04:57:21 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2482CC061764
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:14 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id b2-20020a7bc2420000b029010be1081172so825417wmj.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=im+Evr3MfJAtsbpRKrSvBZYIR3R8HYWcJI2GsyeTWRU=;
        b=DM1ORFPtKVJaRVNMisxtioWMH2mlZJEFFRCvJipOaWkDHZB63Rem+T6nvpCOVzeY8q
         NZp+UaPQrGC+vQ/evx+UneOrjxZMFwIJ8DWaxESSZN544FxOVNje/CsPouZ+/l/dQXRo
         sk0zzzGiYEjyLYjkXeYU/7UIXcKUXYvsZ7xdBHGjWi0+CnfzG7WHDINxuGoIBzUscPxc
         5idmZvijQBsKN1M5I+LzcN2E4EjAN6A+YQypx3IUXAQn4ZFXfGZ2uIbqsRLAqIQM9C5x
         BpJmHm4lQFHacPfuWXw+Svk06up4lWy6aqB4wWxqsrFFRF874LoyFzl/4y4qQHsytKaY
         8JAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=im+Evr3MfJAtsbpRKrSvBZYIR3R8HYWcJI2GsyeTWRU=;
        b=YU9sNBud2YtH/ao+0U0X6NVSL9VTgFHI3/KDWu9yQrElt+dMrpxrnXyZ+zB9i6VHRA
         Gp48bohCWAXepv4wMDrQi8+cyFiMmb+xiKMuwGO1W0PePkbYRUaLFtkR7sTrGmuU2aIG
         ittqScdsMDmuWOH2C/ShFcdlt1gprBd7/Zgp678Tj0HLJKQlrAj7V5Gemwe9ajKuREy7
         1uiHbwkktSzucyiz73GLunfiEzMVWiU4SXgSfnw5VJJNjY16k5zL4W7eqcEwvvN2+f0k
         J0fg46lKn4CSXb1YJOA3kGhkqGa+YgMyDYln6G2JxqQtklcqiYzRc11RORC5UxwVmNZn
         PeHA==
X-Gm-Message-State: AOAM530YWSUYCHSisoSbGhqFwbqDTuSjIiDit2KXogFiism5GpK2ZD7H
        dfYFqANKz/awMbMntju1UMjEcw==
X-Google-Smtp-Source: ABdhPJz29XYZWfGQGPHyM7puMmx9SI7VFt1GZ6uHPJidpB+OMbJRhfyZHKT8jmSsGRT/UCHPsOrPBQ==
X-Received: by 2002:a7b:c195:: with SMTP id y21mr2634320wmi.178.1615971432922;
        Wed, 17 Mar 2021 01:57:12 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id j123sm1807243wmb.1.2021.03.17.01.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:57:12 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bas Vermeulen <bvermeul@blackstar.xs4all.nl>,
        Christoph Hellwig <hch@lst.de>,
        Brian Macy <bmacy@sunshinecomputing.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 07/18] scsi: initio: Remove unused variable 'prev'
Date:   Wed, 17 Mar 2021 08:56:50 +0000
Message-Id: <20210317085701.2891231-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317085701.2891231-1-lee.jones@linaro.org>
References: <20210317085701.2891231-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/initio.c: In function ‘initio_find_busy_scb’:
 drivers/scsi/initio.c:869:30: warning: variable ‘prev’ set but not used [-Wunused-but-set-variable]

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bas Vermeulen <bvermeul@blackstar.xs4all.nl>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Brian Macy <bmacy@sunshinecomputing.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/initio.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 814acc57069dc..926a7045c2e5c 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -866,17 +866,16 @@ static void initio_unlink_busy_scb(struct initio_host * host, struct scsi_ctrl_b
 
 struct scsi_ctrl_blk *initio_find_busy_scb(struct initio_host * host, u16 tarlun)
 {
-	struct scsi_ctrl_blk *tmp, *prev;
+	struct scsi_ctrl_blk *tmp;
 	u16 scbp_tarlun;
 
 
-	prev = tmp = host->first_busy;
+	tmp = host->first_busy;
 	while (tmp != NULL) {
 		scbp_tarlun = (tmp->lun << 8) | (tmp->target);
 		if (scbp_tarlun == tarlun) {	/* Unlink this SCB              */
 			break;
 		}
-		prev = tmp;
 		tmp = tmp->next;
 	}
 #if DEBUG_QUEUE
-- 
2.27.0

