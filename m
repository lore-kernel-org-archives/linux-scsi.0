Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C4ACC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D5D020720
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:47:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LZAtex/W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbgGMHrT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729408AbgGMHrS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:47:18 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7640C061755
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:17 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a6so14662136wrm.4
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3sXxKpQgrnotRyFJvyRPk0Xs+GRdftij+k/kTivXzV0=;
        b=LZAtex/WvZHUpRfBeIZuZKGHFkUEF40F92oWBBEHmfCNjAnSVVxMm34PN6BoS2WVBR
         KYr1bV+zFda1yL2IObHPGtXWzfFJEGpKUzjdRuvs3HDedNofLTE6NLNjnzxRcOd+Ards
         wA7tDnCIGATq+LFB7AgoBTKCJ0tsXjcRqLrFmjdYvkXpCT1sLQ7Vpp9gi+pLf2sWWWfG
         sR39e13edBAyWagxr31HeBUwhCgNqplIi15GyHABbVhdMFjB7/TBZAzAn1rPM7pP82hL
         UVraZPM3LCSfFxR+7TY1H46QW8UjSKNRhVcy1bSB6JY+4Ip/HZexJKDyijDXIgcEdqh7
         XAWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3sXxKpQgrnotRyFJvyRPk0Xs+GRdftij+k/kTivXzV0=;
        b=RqfW+/eR5JLgeWLHxDmPlU61R24FoUCMXE8ZAgHrx/6C3vVkcyHU5dFjvJk7J2ECKp
         MiJQ624BE3znLzrgEHGhZjuPPUDzh1T6YHhd4/cH2N3CsVJLU4JUfxT3VXqZMG0b6n9c
         OvSiFgG+ySwMj8YZo4E/7IzcJYMq3u6632hGmdnSH3gSkDKgPwyh6ohJPvw9nkWGdryZ
         jM/7AVyjMmeJlXyJW+58dU5GUfmxzkpUybJJ8F0nuICUKayDPYKQpxUCULx79RVfLeXl
         zYQCDyLL7kiyCf0ltwV0IpPUIUPGJpRQDAzSLqsFyepeHS4JUH9xScfD89fIV31iHQHS
         lv5g==
X-Gm-Message-State: AOAM531eC/8lTCVD9FrfgtSF18tnVgvXkUSb+XelQ9bHCWY4qig+p0yW
        mP3Rwj1N/MYI3lWYyrNqyj+29A==
X-Google-Smtp-Source: ABdhPJyJUEE2qprj118VrHMoVD4MJ7gID9qoJfCl9yCER6q4U+8w9qO0a1w6J+az2L3+e7K3DtVznQ==
X-Received: by 2002:adf:f20a:: with SMTP id p10mr83083836wro.41.1594626436567;
        Mon, 13 Jul 2020 00:47:16 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:47:16 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [PATCH v2 27/29] scsi: aic94xx: aic94xx_hwi: Repair kerneldoc formatting error and remove extra param
Date:   Mon, 13 Jul 2020 08:46:43 +0100
Message-Id: <20200713074645.126138-28-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
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

