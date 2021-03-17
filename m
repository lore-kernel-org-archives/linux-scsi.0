Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD69C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69FB264E33
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhCQI6C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhCQI5Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 04:57:24 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6C0C06175F
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:23 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id g25so1022079wmh.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=omHoCGEAHHfzGsCXWaSPZZFL53Kydw/eMLAhlkpH1KI=;
        b=G22gc9eNVnSkGmoUYNFy4wacYM1Maa4UM98OSYfR32gD/HkmzQQWbgY4P4UFvjX9q5
         1/K4tKYkgq+Tyz3T4Y8Mgze3tuG2JcwIvk9CWMjQuhvsY23GVjfNmJ0aem8lw+qe5UN7
         FPVmfjzgOicF0uFBQf6QL3Vj1K77BtaL/xksuNliBeu5VB6q6r30sr+Bkh6BrsKtV71N
         UnXMXD6kbvh09KJOuR8zcUy4hvQu11++xqFYTYuhf4q1E4zbXFNqkxjwgVsmqzqHBz4Y
         BDz3TZqJ4293Xc0y6RflScVaLt9bBm9iP0S+qSk34h7Cz46M4A8WS6I3GSOT+Wlls5BQ
         vKXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=omHoCGEAHHfzGsCXWaSPZZFL53Kydw/eMLAhlkpH1KI=;
        b=OwDoZC7Ik5gmkOsQR0ByqYvKzWK1wupgi1utDfve1vXI5NvblIqevgone9dO410x7o
         NrOGPgjzIhklqdWdQde4bMzag744iVYuM/zRhhFScXOeki4zxS6lgwXEQ4v8AawbRHBx
         JgfcFTsCfTzv4IGQXH0p5OsgN10IIO7WyihZOLwMH8xWrNFmj5KqRZLq4s3J6m2RaXjw
         O4Sk1PST08OSpdp2H7Ik4j7pVq5/03MbXmYkYR1gSPNJ3+zuugc5W+/AhJDcb0K4jVk/
         bDWblCGzoFnMUdb8X9gpxzGp3uJJVaJDaWh76IaUHrBrx/hrvYnQ4MoYqHChR8JwNvA/
         ms8w==
X-Gm-Message-State: AOAM530QrUtODP1lcToxzXv+W/9SeWb4SKXGKRL1t1NFQyoPgmUY4kp9
        /2ab2x6tEmO0YgFsr6rY5H5J8g==
X-Google-Smtp-Source: ABdhPJw8Ddp7YdzjeheW5smSSk4SsocDHz5sUQEXKz8atEvBpoI8V+wWuKLJ2mg9P8iILIz+DV1vuA==
X-Received: by 2002:a1c:3c8a:: with SMTP id j132mr683090wma.127.1615971442290;
        Wed, 17 Mar 2021 01:57:22 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id j123sm1807243wmb.1.2021.03.17.01.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:57:21 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 17/18] scsi: isci: remote_device: Make local function isci_remote_device_wait_for_resume_from_abort() static
Date:   Wed, 17 Mar 2021 08:57:00 +0000
Message-Id: <20210317085701.2891231-18-lee.jones@linaro.org>
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

 drivers/scsi/isci/remote_device.c:1387:6: warning: no previous prototype for ‘isci_remote_device_wait_for_resume_from_abort’ [-Wmissing-prototypes]

Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/isci/remote_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index c3f540b556895..b1276f7e49c89 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -1384,7 +1384,7 @@ static bool isci_remote_device_test_resume_done(
 	return done;
 }
 
-void isci_remote_device_wait_for_resume_from_abort(
+static void isci_remote_device_wait_for_resume_from_abort(
 	struct isci_host *ihost,
 	struct isci_remote_device *idev)
 {
-- 
2.27.0

