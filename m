Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B823C3A5A6
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 20:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DA4F22CEA
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 20:00:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ljvhUTB5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbfH2UAK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 16:00:10 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35013 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbfH2UAJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2019 16:00:09 -0400
Received: by mail-pl1-f196.google.com with SMTP id gn20so2094497plb.2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2019 13:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LnwOSHW+qkIfwX+CEo6pre2vAtIHSJHM7Ipb0uTKcN8=;
        b=ljvhUTB5kgie6mZn/Katfok8X2WrFwgXFmGKAsJBCEExxJK+Nxf6/5JnDHhk1LxGzy
         GYRAppVUeZ1sd1GoWZIlw7jgdNHty21ipU5Xwbsjv2pDu76zTUuu2M0TYKjBIGiG+5/U
         z01+UGUU35QOWpFRzt7fPcfbQ99aFBb2fmxT0/oIwQsg9/ldDduJhzRqeDTeL/2cT+fn
         xZEkAhbQh16HdO3N3dLit2heuBIRhD2aWB6bocU4JidBTKhPZUvGLVHHMbcSP5Om8Rkn
         fjF4IfC7pe9zuVYT61BgDPYNoG1OUc1oLDYMoO1xaeTde3LKzueqjrs2vOyE7CXBh8Pc
         jvRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LnwOSHW+qkIfwX+CEo6pre2vAtIHSJHM7Ipb0uTKcN8=;
        b=BFeYaqcO4n/MTfph7lbtNffZNzhgVggBbsMkk9PrSJDJ8TiXhWDTIDMg2Th7FYzQ7w
         n9+I5GV7YlvJaWdkOTgahMip4z4BgCG9NvzHva4Z4G858SY96r/N5LewHSRzquXUJMit
         PJL7n81AQ4vIcV1uFTFOKjm7YQjofbLRTT28+Ipxu0Sx5gkQnkuIN8+DKaUZgT8btw2K
         kjqz57UdbFmpxKGvaYd1diCXs+aYvslUsEQeBiNzsCeo2YfB9xcJurh3TtuhCW3QbLr2
         5rZZqgFRryZRHgzQrTu7Y9wOgsOondJeuAWh+eIPSAgytTPyIiAfuNqWzJPIH7O1pIzO
         iBRA==
X-Gm-Message-State: APjAAAV3bGAq7kdlyP7KigeczPIRkHOArBbwifS6C+DyfaRzDfky1KB5
        MbbAZPqjNPvHaaZIaDOS6NNA8Q==
X-Google-Smtp-Source: APXvYqwdxPRjNZXc7J371kYMqpuaaLwSfZc+tGFJrILbQTyvwMq61GQBgGE76g8xmKy3HX0ZAhYEFg==
X-Received: by 2002:a17:902:9a07:: with SMTP id v7mr12015218plp.245.1567108808730;
        Thu, 29 Aug 2019 13:00:08 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id u7sm3053766pgr.94.2019.08.29.13.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 13:00:08 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     architt@codeaurora.org, a.hajda@samsung.com,
        Laurent.pinchart@ideasonboard.com, airlied@linux.ie, jsarha@ti.com,
        tomi.valkeinen@ti.com, vinholikatti@gmail.com,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [BACKPORT 4.19.y 3/3] drm/tilcdc: Register cpufreq notifier after we have initialized crtc
Date:   Thu, 29 Aug 2019 14:00:01 -0600
Message-Id: <20190829200001.17092-4-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829200001.17092-1-mathieu.poirier@linaro.org>
References: <20190829200001.17092-1-mathieu.poirier@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jyri Sarha <jsarha@ti.com>

commit 432973fd3a20102840d5f7e61af9f1a03c217a4c upstream

Register cpufreq notifier after we have initialized the crtc and
unregister it before we remove the ctrc. Receiving a cpufreq notify
without crtc causes a crash.

Reported-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Jyri Sarha <jsarha@ti.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/gpu/drm/tilcdc/tilcdc_drv.c | 34 ++++++++++++++---------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
index 0fb300d41a09..e1868776da25 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -184,6 +184,12 @@ static void tilcdc_fini(struct drm_device *dev)
 {
 	struct tilcdc_drm_private *priv = dev->dev_private;
 
+#ifdef CONFIG_CPU_FREQ
+	if (priv->freq_transition.notifier_call)
+		cpufreq_unregister_notifier(&priv->freq_transition,
+					    CPUFREQ_TRANSITION_NOTIFIER);
+#endif
+
 	if (priv->crtc)
 		tilcdc_crtc_shutdown(priv->crtc);
 
@@ -198,12 +204,6 @@ static void tilcdc_fini(struct drm_device *dev)
 	drm_mode_config_cleanup(dev);
 	tilcdc_remove_external_device(dev);
 
-#ifdef CONFIG_CPU_FREQ
-	if (priv->freq_transition.notifier_call)
-		cpufreq_unregister_notifier(&priv->freq_transition,
-					    CPUFREQ_TRANSITION_NOTIFIER);
-#endif
-
 	if (priv->clk)
 		clk_put(priv->clk);
 
@@ -274,17 +274,6 @@ static int tilcdc_init(struct drm_driver *ddrv, struct device *dev)
 		goto init_failed;
 	}
 
-#ifdef CONFIG_CPU_FREQ
-	priv->freq_transition.notifier_call = cpufreq_transition;
-	ret = cpufreq_register_notifier(&priv->freq_transition,
-			CPUFREQ_TRANSITION_NOTIFIER);
-	if (ret) {
-		dev_err(dev, "failed to register cpufreq notifier\n");
-		priv->freq_transition.notifier_call = NULL;
-		goto init_failed;
-	}
-#endif
-
 	if (of_property_read_u32(node, "max-bandwidth", &priv->max_bandwidth))
 		priv->max_bandwidth = TILCDC_DEFAULT_MAX_BANDWIDTH;
 
@@ -361,6 +350,17 @@ static int tilcdc_init(struct drm_driver *ddrv, struct device *dev)
 	}
 	modeset_init(ddev);
 
+#ifdef CONFIG_CPU_FREQ
+	priv->freq_transition.notifier_call = cpufreq_transition;
+	ret = cpufreq_register_notifier(&priv->freq_transition,
+			CPUFREQ_TRANSITION_NOTIFIER);
+	if (ret) {
+		dev_err(dev, "failed to register cpufreq notifier\n");
+		priv->freq_transition.notifier_call = NULL;
+		goto init_failed;
+	}
+#endif
+
 	if (priv->is_componentized) {
 		ret = component_bind_all(dev, ddev);
 		if (ret < 0)
-- 
2.17.1

