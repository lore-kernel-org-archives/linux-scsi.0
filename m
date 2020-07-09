Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA2DC433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7906E207D0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wDr3kLbs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgGIRq2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728670AbgGIRq1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:27 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928BDC08C5DC
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:26 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g10so6731226wmc.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XXWcsoi+xGgOcFmbeWP75diSxyhw0hWfzUHSepxSy6k=;
        b=wDr3kLbsMlSQP8EqutTozrPjOoRfxz5PEnYOYYWvcXRrI8a5KqDDTCU3WMEGYfdgJ0
         5Iv8QeDtcrccOVwVUgkgxN0ALNJ/bjH0lnQR94pxVMiPyNJOGTvkbYgwsNJGyW638YTg
         NfISb7/cCrla8la77CfL1/K1/vwVTFviyWjYH7injCTwF2Ij4VWdXhOTB0ZkmTR/DZ7F
         jhrdgceBGakpaJoDqbTR/QGjiBkHRaxAAUHQ+vgnVV7DHjiioTP0RK+kLNf87FENOCuD
         rwof33dAqHwBO6HyrILWgvtJ8xu9tYIAGUek2gLPUKDKp/VscUeKrykiv6W1QTzVbG1y
         77PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XXWcsoi+xGgOcFmbeWP75diSxyhw0hWfzUHSepxSy6k=;
        b=hMAs5wBSC90vlN8OpmGGwv0VIo934wpzzyZUZKJv7XcuDi7yUewgjHEp6IpkkkaRD1
         bqmYz5468MF7lW7WXvFWg0NJv1l5ZLfUff1ZVNvzOrC9aPDOBlOjwJmhT7xwi55WELJo
         7zKOPaSlKTxtxTcgwALew331XPSmYImZuH0bn8BKybKfWnx4rKgxCWuxW2UFj+RW6tU0
         QppffLTFcuUKTlE8wfjfp7aJTZ2uYBIs3HZj4VNqGnKN4GuK7T6s2BCH1bT1Xubm6E8e
         JeVsZ7LG8OojbpuGGf0OdOA//6hl8i6/cx8g/LMgb4tl7tN7/GFoAAFS+FNTz+5Z0u/+
         6MQQ==
X-Gm-Message-State: AOAM53383/xHXKFBiP/QoffjxFOssiTkkCLoFbd29mDIMyMmpAlxRtmx
        G6lTVJBxj2VPrKtnG17b/aRWrA==
X-Google-Smtp-Source: ABdhPJzbrtSZAFEyQ4E+0JitG1cOyHzPhs5DdTvwJhoh6WiCBXI2eHJP4dFjE32RWo0G57WV9pKm4Q==
X-Received: by 2002:a05:600c:2295:: with SMTP id 21mr1076958wmf.29.1594316785279;
        Thu, 09 Jul 2020 10:46:25 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:24 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 23/24] scsi: aic7xxx: aic79xx_osm: Fix 'amount_xferred' set but not used issue
Date:   Thu,  9 Jul 2020 18:45:55 +0100
Message-Id: <20200709174556.7651-24-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'amount_xferred' is used, but only in certain circumstances.  Place
the same stipulations on the defining/allocating of 'amount_xferred'
as is placed when using it.

We've been careful not to change any of the ordering semantics here.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic7xxx/aic79xx_osm.c: In function ‘ahd_done’:
 drivers/scsi/aic7xxx/aic79xx_osm.c:1796:12: warning: variable ‘amount_xferred’ set but not used [-Wunused-but-set-variable]

Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 8e43ff86e0a60..3782a20d58885 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1787,10 +1787,12 @@ ahd_done(struct ahd_softc *ahd, struct scb *scb)
 	 */
 	cmd->sense_buffer[0] = 0;
 	if (ahd_get_transaction_status(scb) == CAM_REQ_INPROG) {
+#ifdef AHD_REPORT_UNDERFLOWS
 		uint32_t amount_xferred;
 
 		amount_xferred =
 		    ahd_get_transfer_length(scb) - ahd_get_residual(scb);
+#endif
 		if ((scb->flags & SCB_TRANSMISSION_ERROR) != 0) {
 #ifdef AHD_DEBUG
 			if ((ahd_debug & AHD_SHOW_MISC) != 0) {
-- 
2.25.1

