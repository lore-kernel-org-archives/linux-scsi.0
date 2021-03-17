Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A80DC43333
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58E2A64F9E
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhCQI54 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbhCQI5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 04:57:22 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C63C0613D9
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:21 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id e9so946906wrw.10
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uknjZgyKbyTHbovaIRwNwS9vIyXMZbr0zBj7lwglxO0=;
        b=jyM5AtVqD1gbwSyCgL+XC69BhPp58i7rui/GQduzTndKglMY0QDRJiMINMn9pqzRI9
         FacVRjketCFrOI9jkEpRwxco361TWUUJqNwJcZubfxro7ILh1mYgKldo0fvHDRPub1Z4
         MMdFipRIYAGSSeixDl1jFrYrvXr90kreByWKhCz6T8h6lrvRmu3BF129zP/QUEMXWWC8
         XM7pQWLyopi7Q5zrQaXQULTS9EBinMxlMAT9M1aimg8J7N0/GB33WAIK98KjRQIK7nIy
         mvv2pBjDOiculG/h4lyTapmXYGS2ihH5AbBRQzJsXfo2OZnD/1/AJmEGFhsbwmqzfUmv
         k82Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uknjZgyKbyTHbovaIRwNwS9vIyXMZbr0zBj7lwglxO0=;
        b=d8uTTOCjM6MBI0YJi2t/yy+DwcR3g0CqyDLzfVzVMrUIdcbZF8Vp7ovPntEkgkFCRp
         xgqPzZm26/nQZnM65H5xWfIH/J/u5sWfMZBuZcVdLiaesRpm0ZXdR5FcxRiY4o7HisqJ
         814gz3xZML+BO6Ij2Oa0fHCxKuiu8nEjMOCSIbrT/yBBrL2/yJVaYJZn8XMEKdL8pzAc
         5T2mnRkATC8DQjjwE0FdgrUE6g2ZxCq8+fg8C3N8T3wQGrOuj6/68g+FRTjiwOvENlLX
         qqc14vXrxwLa7NKEPc6d0Tfm7kPNX5HX86zK8mtAxdzAr9+zaDLe71nxd5w9qD5XvQmQ
         vpaw==
X-Gm-Message-State: AOAM531Glier5Wgxh+L6jMpwF4+wabzBU6VLqDh5NYTi725scQg64K+2
        hSdUhcXe2G28y69Y042jQXG9Tg==
X-Google-Smtp-Source: ABdhPJx+GlNNh0KH6vMpIl5u5vhs56iee2KFJdoue8jlx2OnR2y+cQgqHzC+YWhg2AlgZ3S8cr5uPg==
X-Received: by 2002:adf:e441:: with SMTP id t1mr3251524wrm.21.1615971440343;
        Wed, 17 Mar 2021 01:57:20 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id j123sm1807243wmb.1.2021.03.17.01.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:57:19 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Richard Hirst <richard@sleepie.demon.co.uk>,
        c by <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org
Subject: [PATCH 15/18] scsi: sim710: Remove unused variable 'err' from sim710_init()
Date:   Wed, 17 Mar 2021 08:56:58 +0000
Message-Id: <20210317085701.2891231-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317085701.2891231-1-lee.jones@linaro.org>
References: <20210317085701.2891231-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Take the opportunity to rework the comment a little.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/sim710.c: In function ‘sim710_init’:
 drivers/scsi/sim710.c:216:6: warning: variable ‘err’ set but not used [-Wunused-but-set-variable]

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Hirst <richard@sleepie.demon.co.uk>
Cc: c by <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/sim710.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
index 22302612e032b..e519df68d603d 100644
--- a/drivers/scsi/sim710.c
+++ b/drivers/scsi/sim710.c
@@ -213,21 +213,19 @@ static struct eisa_driver sim710_eisa_driver = {
 
 static int __init sim710_init(void)
 {
-	int err = -ENODEV;
-
 #ifdef MODULE
 	if (sim710)
 		param_setup(sim710);
 #endif
 
 #ifdef CONFIG_EISA
-	err = eisa_driver_register(&sim710_eisa_driver);
+	/*
+	 * FIXME: We'd really like to return -ENODEV if no devices have actually
+	 * been found.  However eisa_driver_register() only reports problems
+	 * with kobject_register() so simply return success for now.
+	 */
+	eisa_driver_register(&sim710_eisa_driver);
 #endif
-	/* FIXME: what we'd really like to return here is -ENODEV if
-	 * no devices have actually been found.  Instead, the err
-	 * above actually only reports problems with kobject_register,
-	 * so for the moment return success */
-
 	return 0;
 }
 
-- 
2.27.0

