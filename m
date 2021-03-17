Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B25C4332D
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0366F64F77
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhCQJLz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhCQJLg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:11:36 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70095C061763
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:11:36 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id g8so1011102wmd.4
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tIEkLMKAtbUUByHxgsDytjqimEjUNe0j+Mn0l5iX50M=;
        b=beT5usMG3If2KF1utJqGVevHtxdNjcQepVLaxWYxU1o3CpqNnj4tOgQTOQbx9uvuLX
         XAhIUvVibTUp+QlH5m+orjgjE/+qs/LKGKnd2ek1DXKyzpkUCLq1FAU8PhKV38RtXpqb
         P6uU8D4hoC+FnIoDIvHhFK5CN/uF9UneLa7ytP9q77xdL6XbiQCKM437reUVhm4Iud5p
         +kIQ2VSGGI6U9A7m/wjWyEcD5WBQ49pNr7Jays6D6HECETN3wCNkcaEVg8177PEFoJvO
         pWkHO/n/Quxy+54eNEpA5SnYpHALHwveSqjT8auzMH+onsAsK5jRKETYKNXix+ZJfFU3
         ZrWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tIEkLMKAtbUUByHxgsDytjqimEjUNe0j+Mn0l5iX50M=;
        b=L9EM3wC28blBzSHPAPhilWEdZHoz2GPY7o985g60QUM/LR6WH47Sg9EjEs5PR7UBUf
         ajsQH0ygx9/ZAG1EjSU6z5Pel0lWNq7WqwOxV6SNkLxT2NIJahoTLwSns3n6OkHHq9pY
         nsa8/crBGI5whlzM6UaRS3iCtlpBLnTVc0xmO9awhaTHMU/tDwAJnwnWtFkCdwruiGn1
         Urx7cmtKmOz/52WFULg8vnZmq4413RN+5IX1BJc3suZOtST9A/hVcSjg2IHkK2TcixR/
         Te4Oey2EGtwy2nh0mtKu9iGkzIBqfP6qZQBp+OTyFAf2KiqfY6gh/2TDFYPb2EqQjNkH
         eCsA==
X-Gm-Message-State: AOAM53347BxvysJQYkqyVNeX2dgbD7LUDDKcHUZXXgB99jdiJ0dpiOfE
        4tqYOFfRg1ScekykkwM1KdLbGw==
X-Google-Smtp-Source: ABdhPJxesWgN9n7epwFj7KRVaeP+ukmkLVjhbB7GXclayYOZWP60lGWAJlD20eoju237hkY9sJ2WtA==
X-Received: by 2002:a1c:318b:: with SMTP id x133mr2752054wmx.154.1615972295255;
        Wed, 17 Mar 2021 02:11:35 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id s83sm1709279wms.16.2021.03.17.02.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:11:34 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 7/8] scsi: isci: port: Make local function 'port_state_name()' static
Date:   Wed, 17 Mar 2021 09:11:24 +0000
Message-Id: <20210317091125.2910058-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091125.2910058-1-lee.jones@linaro.org>
References: <20210317091125.2910058-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/isci/port.c:65:13: warning: no previous prototype for ‘port_state_name’ [-Wmissing-prototypes]

Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/isci/port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 448a8c31ba359..5a362ba76d63f 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -62,7 +62,7 @@
 
 #undef C
 #define C(a) (#a)
-const char *port_state_name(enum sci_port_states state)
+static const char *port_state_name(enum sci_port_states state)
 {
 	static const char * const strings[] = PORT_STATES;
 
-- 
2.27.0

