Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C82BFC433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A233464F75
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhCQI5x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhCQI5R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 04:57:17 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA35C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:16 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id b2-20020a7bc2420000b029010be1081172so825519wmj.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6g1k4NOJoIyIgRaKDu88zZvT9OX+R02WPv1Cq13vbSs=;
        b=hVH8+7CFeF6siiczN9gEWSrkhgR3nF4LXv4BI4Ad0JT/kkz7DTW4CeTubJyFJ9q5bm
         aPSvCFSUWFNTxYdf4oWBZIYNZzMP9eOxCyDRsuOlDQ8A6sDUPFmg0zdVFyubcjCos8Jl
         UGi4zJyEX2/JHBUj18rdFIC5n1ATFa4PcS20X8R5swmyBHtrhU01Jw2D+d44uW7m2Odd
         M9nYUm7zYpGHg+3d6MX0Bc0XAXIsR0zP+D+wdKSfwatOWxuz93xyV/avQkstg1NY6um0
         e4Qcl6wLJZJKxcM8TYP/Xk8ZTkrZ3cPCqHI+Ok1J4IUOgJda2dbYNmdX5+LBPM5Zx20x
         uKsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6g1k4NOJoIyIgRaKDu88zZvT9OX+R02WPv1Cq13vbSs=;
        b=JHlEfvu1obOV5AO/ts57jmByzuxBRMPatgA0PxDKDLiLlfNIfk8evGN77nrKMfqlSt
         mrJ2cjHvkYGW1FMNo4r42PnZLI8rJsgRLTe9wWuMymt5oDgVkIT+v6YosO37HJ2R7OtW
         5LvAnwCVdO2q0EW6Q4OAcTBRYK6S8K39q4JLYNBArQj4O9wSguWCW5N8o8jrS86fEIj9
         yODEy+MH0rVZ8/LZaRs3Uh3XJZ3taMCmqxEYlXkVz+8yXzVjPPviN+o9J/bqhadLMuEW
         r4IqfwsDh1McK/EFHaQe35IUek69oEMWQJ0rJynblmxH8tk2FcYfGb3aOOqaP3LK25tm
         tN7A==
X-Gm-Message-State: AOAM532jUlIhWDpE1l44ngluLqOF3WjNdCZEvyzGP0DX5THGUH+DQj7N
        qM5wyZevLKOqKJ/4ZATWd0Zs8Q==
X-Google-Smtp-Source: ABdhPJyLSZWYr2mFxAPz9Gy5xkXS9CsUhB6rhcee0PrYTBO5lXZ/0AcSY4E/DXguUxbsNyTfOM+OBQ==
X-Received: by 2002:a05:600c:4f10:: with SMTP id l16mr2736082wmq.46.1615971435682;
        Wed, 17 Mar 2021 01:57:15 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id j123sm1807243wmb.1.2021.03.17.01.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:57:15 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Joel Jacobson <linux@3ware.com>,
        de Melo <acme@conectiva.com.br>,
        Andre Hedrick <andre@suse.com>, linux-scsi@vger.kernel.org
Subject: [PATCH 10/18] scsi: 3w-xxxx: Remove 2 unused variables 'response_que_value' and 'tw_dev'
Date:   Wed, 17 Mar 2021 08:56:53 +0000
Message-Id: <20210317085701.2891231-11-lee.jones@linaro.org>
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

 drivers/scsi/3w-xxxx.c: In function ‘tw_empty_response_que’:
 drivers/scsi/3w-xxxx.c:463:24: warning: variable ‘response_que_value’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/3w-xxxx.c: In function ‘tw_scsi_biosparam’:
 drivers/scsi/3w-xxxx.c:1345:23: warning: variable ‘tw_dev’ set but not used [-Wunused-but-set-variable]

Cc: Adam Radford <aradford@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Joel Jacobson <linux@3ware.com>
Cc: de Melo <acme@conectiva.com.br>
Cc: Andre Hedrick <andre@suse.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/3w-xxxx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index d90b9fca4aea2..a7292883b72bc 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -460,12 +460,12 @@ static int tw_check_errors(TW_Device_Extension *tw_dev)
 /* This function will empty the response que */
 static void tw_empty_response_que(TW_Device_Extension *tw_dev)
 {
-	u32 status_reg_value, response_que_value;
+	u32 status_reg_value;
 
 	status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
 
 	while ((status_reg_value & TW_STATUS_RESPONSE_QUEUE_EMPTY) == 0) {
-		response_que_value = inl(TW_RESPONSE_QUEUE_REG_ADDR(tw_dev));
+		inl(TW_RESPONSE_QUEUE_REG_ADDR(tw_dev));
 		status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
 	}
 } /* End tw_empty_response_que() */
@@ -1342,10 +1342,8 @@ static int tw_scsi_biosparam(struct scsi_device *sdev, struct block_device *bdev
 			     sector_t capacity, int geom[])
 {
 	int heads, sectors, cylinders;
-	TW_Device_Extension *tw_dev;
 
 	dprintk(KERN_NOTICE "3w-xxxx: tw_scsi_biosparam()\n");
-	tw_dev = (TW_Device_Extension *)sdev->host->hostdata;
 
 	heads = 64;
 	sectors = 32;
-- 
2.27.0

