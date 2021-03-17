Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC9DC43331
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1452164F6A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhCQI5y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbhCQI5T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 04:57:19 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B545CC06174A
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:18 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id f22-20020a7bc8d60000b029010c024a1407so2928929wml.2
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lgdjb93mQlErKIT9nxRZ2QkPnfSG57zjDQqjLAihewI=;
        b=MwCP4itucxztl9l8FkEqeHILNX3nzDKtzAzs/tgBHBSDafSTLboWBRYxz76cEG3V8x
         2xPAdCZJokzSSlLfv+qzwK97CvIP36SaiFEwnjBxG2YqcnPTFOG6Y8yGU/sc93iJTImW
         Sf5oXGbJujAphZM9Z0eQHUk+a2N9aMmyEM0TD+JA736pUUbP4J1B/a6m2ATgyhF3av6r
         9PegckNneVMjHCE/+3dm96hlEVMIKRRWWqENGlNOfKX0L4FDpm7LBalWvzUiccsqDZMU
         HhC7Z4Xa2Vj8iKt1skT9IvgA7GqwKfwWY1Dw/Gju/4U+Isx7ARnIEOgV0eQfxeHAvSaN
         lflg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lgdjb93mQlErKIT9nxRZ2QkPnfSG57zjDQqjLAihewI=;
        b=FYeQJ/+OWQavxxxRTrMdW4HbXk1jBIxoXsY6modd5QJNKYGCJJejA8k/7xgBE2hj29
         OPfxHenrF7NK6mnodMn+Rb6XdYrnpqrFkI+iDxxFK9DI0SfDRAf/nTCIDCihHRvb46Hh
         jZ+KHZD+q1tzUdAHwWKmyuECLB1ea6azw+adhX9qJDlz6NE2WH/EQJVgTJO5Gy/Hejes
         MmlnpSf1icTB7TGjYlvSKO21YAESqal7oYoDCuWwqSKHRrYjN7d+R27aVK6/pZis1TgR
         1WmmwWDKCLgDdLCVQsSlwvTBlULP99caorbkpAXag9kN/eKW13Th3pJiwulS03uONvOL
         gHFg==
X-Gm-Message-State: AOAM532I7r6ZleNlvIIRrHoK1iIn1Nx2cPuLoYUVQnAf7tyqGkCMARNy
        DAZVmHL2wcETLBWfmEhPmUPeLw==
X-Google-Smtp-Source: ABdhPJxll19rFgByW4rcQdYz1/5AVych4qQyQK4k9X/sQF6vr/f0gl2tfL8uDge4nac7kZTlwFpC3w==
X-Received: by 2002:a05:600c:4ed1:: with SMTP id g17mr2645321wmq.67.1615971437511;
        Wed, 17 Mar 2021 01:57:17 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id j123sm1807243wmb.1.2021.03.17.01.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:57:17 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 12/18] scsi: 3w-sas: Remove unused variables 'sglist' and 'tw_dev'
Date:   Wed, 17 Mar 2021 08:56:55 +0000
Message-Id: <20210317085701.2891231-13-lee.jones@linaro.org>
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

 drivers/scsi/3w-sas.c: In function ‘twl_scsiop_execute_scsi’:
 drivers/scsi/3w-sas.c:298:22: warning: variable ‘sglist’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/3w-sas.c: In function ‘twl_scsi_biosparam’:
 drivers/scsi/3w-sas.c:1411:23: warning: variable ‘tw_dev’ set but not used [-Wunused-but-set-variable]

Cc: Adam Radford <aradford@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/3w-sas.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 3db0e42e9aa75..383f6f204c24b 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -295,14 +295,11 @@ static int twl_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 	TW_Command_Apache *command_packet;
 	int i, sg_count;
 	struct scsi_cmnd *srb = NULL;
-	struct scatterlist *sglist = NULL, *sg;
+	struct scatterlist *sg;
 	int retval = 1;
 
-	if (tw_dev->srb[request_id]) {
+	if (tw_dev->srb[request_id])
 		srb = tw_dev->srb[request_id];
-		if (scsi_sglist(srb))
-			sglist = scsi_sglist(srb);
-	}
 
 	/* Initialize command packet */
 	full_command_packet = tw_dev->command_packet_virt[request_id];
@@ -1408,9 +1405,6 @@ static int twl_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_res
 static int twl_scsi_biosparam(struct scsi_device *sdev, struct block_device *bdev, sector_t capacity, int geom[])
 {
 	int heads, sectors;
-	TW_Device_Extension *tw_dev;
-
-	tw_dev = (TW_Device_Extension *)sdev->host->hostdata;
 
 	if (capacity >= 0x200000) {
 		heads = 255;
-- 
2.27.0

