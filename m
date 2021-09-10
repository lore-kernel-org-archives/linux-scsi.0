Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEDBEC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9717161206
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbhIJXdt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 19:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbhIJXdf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 19:33:35 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953E8C061768
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:18 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id k24so3212799pgh.8
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6RaOTeQITjjS5RD7oWNsJ4O3kzDKzTz3KbH8dZABJIY=;
        b=Ik8AgBIACuEKCe7WnQ9yKdGUhKWYrUwtYTs5NYRpWTMrM4Jz6o9ZUTViwMRgDiWQRX
         Tcejy36I2tJytddvDvA8mTc8BazZOcvqNt+wZPJZaMmB4HRypIxW6zIRFd5zMJXFpqMr
         ME9acUvMFyqkL4WgD5+hbaagzNsxstq2msgEYX1QOr5e8GvgSF4dd5US6BTeqC3dJvbn
         P4B2jgdqqTmyeexvykXVdnCe8BMSn8myB7IxdULmVf6oUA7yiyjNFgsEKKbuH/hyZ8Qt
         ZvRMKxOXyaA5dDDT69Nf5Ad41rF1RRfHpBMQrciLtcvDuBEopQ8/R7+KSxfcq2exoUS4
         VEtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6RaOTeQITjjS5RD7oWNsJ4O3kzDKzTz3KbH8dZABJIY=;
        b=2ssoDPOgzmPkUt7S/zyacPClWWf6Zuy4pA7zSTaC90qZmut24S7beaNHvrVA8GeHzM
         NoIqz1oij/gcgxF5N9ebdnMW7bUniZI8vM4E/mlNvCm0wkIS0xeYMUnO+aPT9U0L4+0n
         P9Jz+imrX+EsolpKerXRknSD8Fd2QVKG+3G3Yv5llWzlXGvZp32RYviG9PhyUpv0+ZxI
         agq3agEZrXVqdNj5GbXQhIsE9efDuHAvLuqvxguB+6xWPPAv6xPtLU5Bx3H9SHiKQoKT
         tBU5i/IUC3iIX6a9Su6+6seReveNrvv1rU+cSaj6xXCM+7B//VUxq6qcpXUoKTn1F/xt
         hrDw==
X-Gm-Message-State: AOAM531dr4fypTXpxEYcZ4nvPbV77TeG+oyQL6BzaDQy6bwM6cvtsgM+
        wOATlGyTalQIEgYti6QfTz8///XZSQ75gqoN
X-Google-Smtp-Source: ABdhPJwh+fFThjBM4ijfHv7/95ZDGCrCldyyhqTjMZIUKE5P/Acu+ipbxzaIvCxCgzYZyQmIMKuXDg==
X-Received: by 2002:aa7:9570:0:b0:437:3bea:4366 with SMTP id x16-20020aa79570000000b004373bea4366mr84747pfq.16.1631316737927;
        Fri, 10 Sep 2021 16:32:17 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o15sm11325pfk.143.2021.09.10.16.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 16:32:17 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 10/14] lpfc: Adjust bytes received vales during cmf timer interval
Date:   Fri, 10 Sep 2021 16:31:55 -0700
Message-Id: <20210910233159.115896-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210910233159.115896-1-jsmart2021@gmail.com>
References: <20210910233159.115896-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The newly added congestion mgmt framework is seeing unexpected
congestion FPINs and signals.  In analysis, time values given to
the adapter are not at hard time intervals. Thus the drift vs the
transfer count seen is affecting how the framework manages things.

Adjust counters to cover the drift.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ea57151221cd..4637531f3b02 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5876,7 +5876,7 @@ lpfc_cmf_timer(struct hrtimer *timer)
 	uint32_t io_cnt;
 	uint32_t head, tail;
 	uint32_t busy, max_read;
-	uint64_t total, rcv, lat, mbpi;
+	uint64_t total, rcv, lat, mbpi, extra;
 	int timer_interval = LPFC_CMF_INTERVAL;
 	uint32_t ms;
 	struct lpfc_cgn_stat *cgs;
@@ -5943,7 +5943,19 @@ lpfc_cmf_timer(struct hrtimer *timer)
 	    phba->hba_flag & HBA_SETUP) {
 		mbpi = phba->cmf_last_sync_bw;
 		phba->cmf_last_sync_bw = 0;
-		lpfc_issue_cmf_sync_wqe(phba, LPFC_CMF_INTERVAL, total);
+		extra = 0;
+
+		/* Calculate any extra bytes needed to account for the
+		 * timer accuracy. If we are less than LPFC_CMF_INTERVAL
+		 * add an extra 3% slop factor, equal to LPFC_CMF_INTERVAL
+		 * add an extra 2%. The goal is to equalize total with a
+		 * time > LPFC_CMF_INTERVAL or <= LPFC_CMF_INTERVAL + 1
+		 */
+		if (ms == LPFC_CMF_INTERVAL)
+			extra = div_u64(total, 50);
+		else if (ms < LPFC_CMF_INTERVAL)
+			extra = div_u64(total, 33);
+		lpfc_issue_cmf_sync_wqe(phba, LPFC_CMF_INTERVAL, total + extra);
 	} else {
 		/* For Monitor mode or link down we want mbpi
 		 * to be the full link speed
-- 
2.26.2

