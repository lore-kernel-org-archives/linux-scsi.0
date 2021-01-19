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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EECCC43142
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0439B22E00
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388659AbhASQjz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 11:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730770AbhASQjq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2021 11:39:46 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484F5C061575;
        Tue, 19 Jan 2021 08:39:04 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id by1so23004947ejc.0;
        Tue, 19 Jan 2021 08:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fUV+tS7I2S8Z0CYTM20ciXO46ZZ4AQc+YBzvhjKVauI=;
        b=LWXnWho/T83rLl5kTGyfeIrgeTvipjp8bMIxO/B7/kmDArkK0njxExzrfwz+t6u+WJ
         Y4dluOHojFpv1MBe+zYDy6RskKNTX9gFn3y6lTM1oA9A372vwc9r1jYE8NVnWRmiHxui
         YDU2LsT/tePlKnUT3yzVocbyGW4k+Y1DNXvicr0OQ4zoLLdhslg0Yc1TVaHXYmAlJ9C2
         8in9n0IwdPdzmttdVmx9DRctJTB88dKSIC1Ob7VhjwpyYh4P7SSPH8kWDSzREUmTIa17
         g/pA0b3OBlE/rwKc/hoKQB6WY1Xvccwj7cgA1zcG9U6XaWI1kULcSKS689kd53jaXctF
         nFKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fUV+tS7I2S8Z0CYTM20ciXO46ZZ4AQc+YBzvhjKVauI=;
        b=RteI1FIkgZl342xk1/PEPwPx3Agc7BDn8ZFMYuGbD7Mjr0f+yKqz+CHZpSzB93Hv53
         tnsMuH2MHhtDMgDu5iq5sdQRhPNxbO5wgGYihvJ0q9rN+LE/I8qwLeHs8TFjtitUBLYm
         lMmvfj5QHebaXPbrbUxPt0FWpWkAtSstBfjWlli5y4EpKfPzV5wMM4taB1sDUkNIErbz
         c4SeyJ6vQFdFAyNXXXg1C3ftqvKppYMq0mONoCJPbHsfa7kVGEHUqo9K8s/gaRqr9REX
         GM8PH0awStKkIXOH9oXFPxRQ7w7dY9Sgb9lEBK2ZfYMup4zJgaX2HV0Jt12kq/AaaTmH
         XSTA==
X-Gm-Message-State: AOAM533hNDt9OA1OqPzggc2HoH4KDuoOoLHuv6pHbULwLcaMXvlaSOeZ
        Ly00tLCBXOTevIbjNDduKu8=
X-Google-Smtp-Source: ABdhPJwbCZixWgQEkWMvccZyVy21y8cs6MAp4F2W43Q+6y+WU9Tv0eqYkQjUIJpOnbwG42s8p4r3lQ==
X-Received: by 2002:a17:906:dbf2:: with SMTP id yd18mr3462806ejb.45.1611074343000;
        Tue, 19 Jan 2021 08:39:03 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.gmail.com with ESMTPSA id k22sm9589993eji.101.2021.01.19.08.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 08:39:02 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 2/6] docs: ABI: Add wb_on documentation for new entry wb_on
Date:   Tue, 19 Jan 2021 17:38:43 +0100
Message-Id: <20210119163847.20165-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210119163847.20165-1-huobean@gmail.com>
References: <20210119163847.20165-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Adds UFS sysfs documentation for new entry wb_on.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index adc0d0e91607..f756fd0eba19 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1153,3 +1153,14 @@ Description:	This entry shows the configured size of WriteBooster buffer.
 		0400h corresponds to 4GB.
 
 		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/wb_on
+Date:		January 2021
+Contact:	Bean Huo <beanhuo@micron.com>
+Description:    This node is used to set or display whether UFS WriteBooster is
+        enabled. Echo 0 to this file to disable UFS WriteBooster or 1 to enable
+        it. The WriteBooster is enabled after power-on/reset, however, it will
+        be disabled/enable while CLK scaling down/up (if the platform supports
+        UFSHCD_CAP_CLK_SCALING). For a platform that doesn't support
+        UFSHCD_CAP_CLK_SCALING, we can disable/enable WriteBooster through this
+        sysfs node.
-- 
2.17.1

