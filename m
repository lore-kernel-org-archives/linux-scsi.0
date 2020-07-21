Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1647C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0171207BB
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:42:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qZglsEg/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbgGUQmw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730792AbgGUQmv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:51 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D48C0619DC
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:51 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 17so3554593wmo.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2DBsVEJKGCC5YJL3pZe82NopzwIlKx0+CMXRDFakN9w=;
        b=qZglsEg/JapQgen4C4xsLqh+id8LKXXzAE3ecRqt2TSBdmUoHZ+oYUmhRIGREGIe7X
         U3wt2Vod63USCUMPVNuPOgSuvkWRUuUF+s/YcbLS9ZDKG/g5u7R74lz/nCrY9/U5Zb+O
         HVHjRV8/lQl297ZeNz9MdYfybIxVOuGoOps7BOzYpXU23bYMQsRv4KXf9M1i/cWy9ODS
         bkVsy2yGk/BhcI6tHU9On/bHeZzpIOKZZX8tYHc5VwDz8e5ccWIZOM/tDWPgnqjLGKms
         ry5CyVweOeCbMHQfb6QZN89m5hnvT7EursFf850DJG7V57FG+G7O+nYkOvswqDPGZ1PP
         fwbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2DBsVEJKGCC5YJL3pZe82NopzwIlKx0+CMXRDFakN9w=;
        b=G+YYh07DwiervHQqGsIYC4w1tr1wQZyTLFgR+s5zwcjB5hBck3do+8ovai3JWQPX2o
         90g/esuNHdt1VMGy4ye48uU+ko+EzJen9d1AGIjQY+pbAA2rRr8J4SVd0j5ZIH70CUS7
         bO/VKlxC36nU4Zn2kvBlNhdjQ+4WX4aVEhMxdrQxF18/fKHUl3FD8PZCVahygnVoT5Fb
         Q6T/Zx4C1adLJoRaUT66XPjenLF9t2ufX5yt7sppJ7840FT45FPut03WohU6pWt2sOqu
         V2q7SETsxmTVZWimQH61PPcMnLzQG27zMneyy/10/L8/zccfUG0bqGZgTEWXji7s2+2w
         zdYA==
X-Gm-Message-State: AOAM530b+KuVeOg6xrI9yckZRg33eqzTSKv2LHGOzbvp2XOkPOlLSU2R
        6KRJ50gnBaZhWtVW9i7IT7ef8VLCUes=
X-Google-Smtp-Source: ABdhPJziOyX89+1Qj1UlNBE6Z9MJnd/L0PsYTUc7YzyidbNmxtRyjWyl/rvW7CeV7Q7/wFEEo/kT0Q==
X-Received: by 2002:a1c:f219:: with SMTP id s25mr4638297wmc.2.1595349770312;
        Tue, 21 Jul 2020 09:42:50 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:49 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Matthew Wilcox <willy@infradead.org>,
        Gerard Roudier <groudier@free.fr>,
        Wolfgang Stanglmeier <wolf@cologne.de>,
        Stefan Esser <se@mi.Uni-Koeln.de>,
        Richard Waltham <dormouse@farsrobt.demon.co.uk>
Subject: [PATCH 38/40] scsi: sym53c8xx_2: sym_hipd: Ensure variable has the same stipulations as code using it
Date:   Tue, 21 Jul 2020 17:41:46 +0100
Message-Id: <20200721164148.2617584-39-lee.jones@linaro.org>
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

Only declare 'tp' and 'lp' if they are going to be used.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/sym53c8xx_2/sym_hipd.c: In function ‘sym_complete_error’:
 drivers/scsi/sym53c8xx_2/sym_hipd.c:5356:18: warning: variable ‘lp’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/sym53c8xx_2/sym_hipd.c: In function ‘sym_complete_ok’:
 drivers/scsi/sym53c8xx_2/sym_hipd.c:5485:18: warning: variable ‘lp’ set but not used [-Wunused-but-set-variable]

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Gerard Roudier <groudier@free.fr>
Cc: Wolfgang Stanglmeier <wolf@cologne.de>
Cc: Stefan Esser <se@mi.Uni-Koeln.de>
Cc: Richard Waltham <dormouse@farsrobt.demon.co.uk>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/sym53c8xx_2/sym_hipd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index a428cae4535b7..8410117d5aa44 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -5352,8 +5352,10 @@ void sym_complete_error(struct sym_hcb *np, struct sym_ccb *cp)
 {
 	struct scsi_device *sdev;
 	struct scsi_cmnd *cmd;
+#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 	struct sym_tcb *tp;
 	struct sym_lcb *lp;
+#endif
 	int resid;
 	int i;
 
@@ -5370,11 +5372,13 @@ void sym_complete_error(struct sym_hcb *np, struct sym_ccb *cp)
 			cp->host_status, cp->ssss_status, cp->host_flags);
 	}
 
+#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 	/*
 	 *  Get target and lun pointers.
 	 */
 	tp = &np->target[cp->target];
 	lp = sym_lp(tp, sdev->lun);
+#endif
 
 	/*
 	 *  Check for extended errors.
@@ -5481,8 +5485,10 @@ if (resid)
  */
 void sym_complete_ok (struct sym_hcb *np, struct sym_ccb *cp)
 {
+#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 	struct sym_tcb *tp;
 	struct sym_lcb *lp;
+#endif
 	struct scsi_cmnd *cmd;
 	int resid;
 
@@ -5498,11 +5504,13 @@ void sym_complete_ok (struct sym_hcb *np, struct sym_ccb *cp)
 	 */
 	cmd = cp->cmd;
 
+#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 	/*
 	 *  Get target and lun pointers.
 	 */
 	tp = &np->target[cp->target];
 	lp = sym_lp(tp, cp->lun);
+#endif
 
 	/*
 	 *  If all data have been transferred, given than no
-- 
2.25.1

