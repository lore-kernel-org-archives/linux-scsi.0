Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94CAC433EA
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 978BD207BB
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mIRfzIwC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730620AbgGUQoZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730592AbgGUQmV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:21 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D583AC0619DC
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:20 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id r12so21754810wrj.13
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ad78EnXv9h8fjtbbXBbN7LPQV5/Z4yR8tESs5C1s6bU=;
        b=mIRfzIwC5lXKHPYqj3Wv3vSmTGZB5Gk0wd0747TdqI/p0aDLP3Jr2F+G7YtZ3er/uS
         RwjBLxf3VuQllDK8t+RRVxtRTAhIhO7eTBWPUnpRwVZ1eBNGbMPtNYtNQdol1zc39joq
         GsrSQnvnhi5GskBBjvqrdShPYUInOsn8WvJnVySsNP/rV4gCbXWsvo3ppkxQrT2zVcE2
         iXt+ICEDJjuNjebMtRozAKXH+hw+gi/DQC16Fj7LJaCEhdnLf5hiwSqoAm6dNMvmpwBG
         /EkYC2rGLs4BTr7kzpNpCxh3REAZ0cExsf86UTxuXrIMpr0O29EIzExT0YoJ+6x3U2dL
         Vslw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ad78EnXv9h8fjtbbXBbN7LPQV5/Z4yR8tESs5C1s6bU=;
        b=Se3KvWkJ7wSlo7JnTlPLJA1HOHK2NM52+2mf4vQgaCMgMxhijjtEalxHVc3H1R3S9+
         6eQSMcV1wjk47mGEWODupcHssCDl2z0n8NJ4TN1+fFDUnRHS0PRWOC+LvzlmbFK9LR5N
         tvvWN27X8kB1YXz4Wo/CFA+Lib9C1g1WM/2kb3AfJjGe8FORJYtLNevmSlvnsBVVKm90
         2dnaxjfn6quARtyqcWBIkeYDgci4whzeay9nx45K2SvalS0oRlQa81S2IMg2bFs6Awq8
         NmfHAjJIm4uel4URs8rRhE5WltZeC8Coxu6wcnEz3P2gSsMUU+gLZBEPxTtZhvZU7lx+
         eq0Q==
X-Gm-Message-State: AOAM531YA4DZ6SeM1EVIkUu1KNNLObXc+sOaLuWD8NWf7o+8AmKASqTS
        dJUblDd/Py8PDa4uE1jkc0gFow==
X-Google-Smtp-Source: ABdhPJxl63xn+BN4Gni5a5wvPRlB6SXqtv1SiGIL99fykbtwiIA2JjlD1iU0HlbgK0SIABUh4sie3g==
X-Received: by 2002:adf:a299:: with SMTP id s25mr13274893wra.106.1595349739581;
        Tue, 21 Jul 2020 09:42:19 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:19 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 15/40] scsi: aic7xxx: aic79xx_core: Remove set but unused variables 'targ_info' and 'value'
Date:   Tue, 21 Jul 2020 17:41:23 +0100
Message-Id: <20200721164148.2617584-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Also remove 'tstate' which became unused after this patch.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic7xxx/aic79xx_core.c: In function ‘ahd_handle_seqint’:
 drivers/scsi/aic7xxx/aic79xx_core.c:1907:32: warning: variable ‘targ_info’ set but not used [-Wunused-but-set-variable]
 1907 | struct ahd_initiator_tinfo *targ_info;
 | ^~~~~~~~~
 drivers/scsi/pm8001/pm8001_hwi.c: In function ‘mpi_set_phys_g3_with_ssc’:
 drivers/scsi/pm8001/pm8001_hwi.c:413:6: warning: variable ‘value’ set but not used [-Wunused-but-set-variable]
 413 | u32 value, offset, i;
 | ^~~~~

Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 243e763085a61..c912d29b8bdf7 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -1904,8 +1904,6 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int intstat)
 		{
 			struct	ahd_devinfo devinfo;
 			struct	scb *scb;
-			struct	ahd_initiator_tinfo *targ_info;
-			struct	ahd_tmode_tstate *tstate;
 			u_int	scbid;
 
 			/*
@@ -1933,11 +1931,6 @@ ahd_handle_seqint(struct ahd_softc *ahd, u_int intstat)
 					    SCB_GET_LUN(scb),
 					    SCB_GET_CHANNEL(ahd, scb),
 					    ROLE_INITIATOR);
-			targ_info = ahd_fetch_transinfo(ahd,
-							devinfo.channel,
-							devinfo.our_scsiid,
-							devinfo.target,
-							&tstate);
 			ahd_set_width(ahd, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
 				      AHD_TRANS_ACTIVE, /*paused*/TRUE);
 			ahd_set_syncrate(ahd, &devinfo, /*period*/0,
-- 
2.25.1

