Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D93C433F4
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3406920758
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:00:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="APX1w6TO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbgGMIAg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729408AbgGMIAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:00:34 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BCBC08C5E0
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:33 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j4so14747184wrp.10
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=npmbMmGwXmpaLu61Oedwmcs3qT0N7Ml8rtlLxMj9sy4=;
        b=APX1w6TO5R4QsdjlBqeQiqIQhMT/DzJAbNzzDPLQgY8v+ka1s0CEwFP+HC5FjiVKPa
         aIydkPNZ8PXZcGLx3vaXRayTMs8CFEB9A1S4lqCDeHMnxin9INC9o3R4TLNSrH/ceis8
         2+X5uw1wy8l+NxIzzrfL5RuQdmMBtC7L4P8Zz+58YamuEQ/tXKHA88LW0Tr6b6Q5NCZD
         Z9kKUUWYXJ1N42K6IblfFKi41V3gE2Aiaj+2QF24pxlPm1E1fxflXd7fVI3EuVjt3rfr
         Oj90KpV6xoB4pL3WZDOer2uQ2UL2fIQONBkMpqrCKEmTAtGnhnFuwgpOdliiZVmNei4I
         JrdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=npmbMmGwXmpaLu61Oedwmcs3qT0N7Ml8rtlLxMj9sy4=;
        b=ZOhQX+iynedWvPPwHSJqCXj3+co1eCm67QzwoDd1G/nNcnQSVvlV7iaSeRQAstpTks
         W0B0kG2o+4PxdOrEUsQtNT0Ru8e8c1aj6RFv0EDW4lUOeJbELyRolVM98+x9pLUzD49o
         QGJJ19QkWnYdd5cEzU4u2fpFDIZptEOHImsF96K+OhEon0ICF0ggac2Z3IbXJRcCGFB5
         CPH419pKLkdJJES2WgyKHe/evchGzNGxaI+1vroSYNGGtXT5QsNlmtTnlqbjaeXhnfIf
         7lhtLN4swepWVd4MN0aOwJj8p6dA913ZaI8VeEJ3vJDT5+bypwdIYG3slO/E0JycIxfv
         sLfA==
X-Gm-Message-State: AOAM5328wrUbeJpGbl5GZTsm8/x2CJIUjdcSGiHXi7OLQF/LMtWdYpzN
        WLKy1Xf214NlH53yfSg611O9qQ==
X-Google-Smtp-Source: ABdhPJzt1vyY0wLt3BkPV81+xo69yg56tvMoTNlS7V34SedX4cwfVC8whYNbsJXeEv7RYwMr9W6U6A==
X-Received: by 2002:adf:dd4a:: with SMTP id u10mr77435205wrm.169.1594627232116;
        Mon, 13 Jul 2020 01:00:32 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id 33sm24383549wri.16.2020.07.13.01.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 01:00:31 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH v2 22/24] scsi: aic7xxx: aic79xx_osm: Remove unused variables 'wait' and 'paused'
Date:   Mon, 13 Jul 2020 08:59:59 +0100
Message-Id: <20200713080001.128044-23-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713080001.128044-1-lee.jones@linaro.org>
References: <20200713080001.128044-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It looks like they have never actually been used.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic7xxx/aic79xx_osm.c: In function ‘ahd_linux_dev_reset’:
 drivers/scsi/aic7xxx/aic79xx_osm.c:782:9: warning: variable ‘wait’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/aic7xxx/aic79xx_osm.c:781:9: warning: variable ‘paused’ set but not used [-Wunused-but-set-variable]

Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 9235b6283c0b3..8e43ff86e0a60 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -775,16 +775,13 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
 	struct scb *reset_scb;
 	u_int  cdb_byte;
 	int    retval = SUCCESS;
-	int    paused;
-	int    wait;
 	struct	ahd_initiator_tinfo *tinfo;
 	struct	ahd_tmode_tstate *tstate;
 	unsigned long flags;
 	DECLARE_COMPLETION_ONSTACK(done);
 
 	reset_scb = NULL;
-	paused = FALSE;
-	wait = FALSE;
+
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 
 	scmd_printk(KERN_INFO, cmd,
-- 
2.25.1

