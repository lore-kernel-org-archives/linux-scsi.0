Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D8BEC433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BD02207DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DnDSJDuY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbgGHMDM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729214AbgGHMDJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:03:09 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A03C08E6DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:03:08 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id a6so3832839wmm.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3sXxKpQgrnotRyFJvyRPk0Xs+GRdftij+k/kTivXzV0=;
        b=DnDSJDuY3iQMxIY3ZoXbR8gf2IDWmP9iuqtYX0Ro69doTFbs451srECIXBPTjM4vRz
         jfzGby1S7dLMvMBAV1tEfIcXHUto6nk5UArtEQldbva/5wZ/W7Qg/XEAFwNRK3hOpAoZ
         3bNNuFcPStvvmPlkIAp7LDc736Q2vFJGwqmL+1McUykrXjme+1OR1unCiC5E4bexWf6U
         CJN9j47LLuj1u2A/xcgmsifxrce1xQ6FOAXwsDtAYqT8gcPkG2RCYLBwt+8SRs9vpJcy
         wz1sP2yu+ba9bZkAjpDXwqyub4JAWZHdphP3daDLoor9sd1y2dhB3caU9iuP4FkHZxv1
         LHWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3sXxKpQgrnotRyFJvyRPk0Xs+GRdftij+k/kTivXzV0=;
        b=uDY1QYiGExlqmLN0+rDIVao4Gt24zgxzfYw0KBfuCauna7krtRZRINp527ONUBlBOK
         /9WKsbbFxA0FWn9FVTAvswgxL+xsX0liiXlysHLG2HvzOQnzXFFxxwUQXZ4pglvH2XoN
         JuMMmi6XOo3794o0yU57arCD5rjJrv62jWzcSZigWDfBqxSZOYK6RZhF6kO7Y0k37yep
         /CT727ovxQAqQ0FCJ/sRjbxt+7rRZF9Xb4HML6sLS5tdMO0OGrEglcrcePvp3MZdDOS8
         AXZBJ0OyFIbtu17yqvCs3o1XcdCplPklBbZfQfhUsQ64qETw+/bfSd7+ZgOj+MIgIfpk
         BSCw==
X-Gm-Message-State: AOAM530hjSbNPSuMZ8jiJ/Tqld3R+NzeOIF/sDipMSCGzPm6Aow7M1K8
        89ubk5CtSBoCMRmwQBqWxwDdyxkPBGw=
X-Google-Smtp-Source: ABdhPJx/fai7U19D/GJCZpEsSrd9/JyRH2FHRiM3naVNNV8cPY0UhsCV5vBEpN4APbY6ozLX4DIqdA==
X-Received: by 2002:a1c:2402:: with SMTP id k2mr9021990wmk.138.1594209786967;
        Wed, 08 Jul 2020 05:03:06 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:03:06 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [PATCH 28/30] scsi: aic94xx: aic94xx_hwi: Repair kerneldoc formatting error and remove extra param
Date:   Wed,  8 Jul 2020 13:02:19 +0100
Message-Id: <20200708120221.3386672-29-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Function parameters need to be documented with format '@.*: '.

'to' is not longer asd_start_timers()'s function parameter.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic94xx/aic94xx_hwi.c:589: warning: Function parameter or member 'asd_ha' not described in 'asd_init_ctxmem'
 drivers/scsi/aic94xx/aic94xx_hwi.c:1157: warning: Excess function parameter 'to' description in 'asd_start_scb_timers'

Cc: Luben Tuikov <luben_tuikov@adaptec.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic94xx/aic94xx_hwi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
index c5a46c59d4f80..9256ab7b25227 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -575,7 +575,7 @@ static int asd_extend_cmdctx(struct asd_ha_struct *asd_ha)
 
 /**
  * asd_init_ctxmem -- initialize context memory
- * asd_ha: pointer to host adapter structure
+ * @asd_ha: pointer to host adapter structure
  *
  * This function sets the maximum number of SCBs and
  * DDBs which can be used by the sequencer.  This is normally
@@ -1146,7 +1146,6 @@ static void asd_swap_head_scb(struct asd_ha_struct *asd_ha,
 /**
  * asd_start_timers -- (add and) start timers of SCBs
  * @list: pointer to struct list_head of the scbs
- * @to: timeout in jiffies
  *
  * If an SCB in the @list has no timer function, assign the default
  * one,  then start the timer of the SCB.  This function is
-- 
2.25.1

