Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACE0C433F4
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5109120702
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:01:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="M1jy5gJQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbgGMIAM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgGMIAL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:00:11 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109BCC061755
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:11 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id a6so12752572wmm.0
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xTqXVtAy6STm+CsKD82SFXkbTZ9Yyt2OGjfREOk+wxw=;
        b=M1jy5gJQ6q6Im0MkFHexnEREq0mj1rrikwdZtcYdA6zsdX/0IaDB10D+ciO2ksEULj
         jwtXJ3k/kj40jZ8nFulo3+wJ5a8rrkT1kZzZ2YCNAxDaxV1/Ffv7Issr8BJvRgocrr4M
         2SsslluBcGHQnu+v9r3QYQBFat4xkjWGmgGCwJ7lkGte4LdnM/a9K6DR/SlyPUDwgEXF
         UQDMakGne06+yKh1ighWESgggI9u+7C/6Js9c4kOL9EZVsA298m4B3xoBHwY9EArY0ZD
         4RWq3AQIonkUhmpq941Y3K6B+C8OBcTy/+Vmttz8vtBnU29zkqrndoIT/DDVWy6WnUyT
         n43w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xTqXVtAy6STm+CsKD82SFXkbTZ9Yyt2OGjfREOk+wxw=;
        b=rA2KaxRDew0Foo7/N6QB9NYZ1H+aJYP/qKQqNkEVqMunKnQxqOmYggekOAPtunv7ba
         QO+QYB+2g4cFaBILf0Fe9xfFl/7mGk7mIMKcax226DQhp0lfqePYamflQXhZXpzAX7ko
         15JYOdRi1RovgAJDsyEkDYERntyqnbYFw+nHXtB3WDxjV7YsL8bMu9Dc+sdqH4LHZJTY
         30x+yZCVI7j1oEYUAdSuccPN+0jg6w2FsVg0b+7z4U2uLhV8OcugmzWMjRk0jMfi4MWl
         Fm/c79g/9+mPqH91odrU2ej6hsAE4/d3MtGxFzCsH/awfFb66o/pqTXKQL2UWKI292iO
         8yxw==
X-Gm-Message-State: AOAM530lzVZW5IF/nNE9gy6GOTW2N24wuM0iFYSaRjc48G/OHPXzSGkH
        V4h5gkE/DVmFcaYV/67F/uj23A==
X-Google-Smtp-Source: ABdhPJyTMv5tMDSgCuhXi8HCsSyPHplkvrTob7qbPSgKoC+NvFButhbbYGnX22+SeXRtRZ3CXVx//g==
X-Received: by 2002:a1c:2349:: with SMTP id j70mr17327334wmj.22.1594627209769;
        Mon, 13 Jul 2020 01:00:09 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id 33sm24383549wri.16.2020.07.13.01.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 01:00:09 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Subject: [PATCH v2 02/24] scsi: aacraid: commctrl: Fix a few kerneldoc issues
Date:   Mon, 13 Jul 2020 08:59:39 +0100
Message-Id: <20200713080001.128044-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713080001.128044-1-lee.jones@linaro.org>
References: <20200713080001.128044-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Functions must follow imediately after the header documenting them and
all parameters must be present.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aacraid/commctrl.c:43: warning: Excess function parameter 'dev' description in 'AAC_DEBUG_PREAMBLE'
 drivers/scsi/aacraid/commctrl.c:43: warning: Excess function parameter 'arg' description in 'AAC_DEBUG_PREAMBLE'
 drivers/scsi/aacraid/commctrl.c:167: warning: Function parameter or member 'dev' not described in 'open_getadapter_fib'
 drivers/scsi/aacraid/commctrl.c:167: warning: Function parameter or member 'arg' not described in 'open_getadapter_fib'
 drivers/scsi/aacraid/commctrl.c:458: warning: Cannot understand  *
 on line 458 - I thought it was a doc line

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aacraid/commctrl.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 34e65dea992e4..59e82a832042f 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -32,6 +32,8 @@
 
 #include "aacraid.h"
 
+# define AAC_DEBUG_PREAMBLE	KERN_INFO
+# define AAC_DEBUG_POSTAMBLE
 /**
  *	ioctl_send_fib	-	send a FIB from userspace
  *	@dev:	adapter is being processed
@@ -40,9 +42,6 @@
  *	This routine sends a fib to the adapter on behalf of a user level
  *	program.
  */
-# define AAC_DEBUG_PREAMBLE	KERN_INFO
-# define AAC_DEBUG_POSTAMBLE
-
 static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 {
 	struct hw_fib * kfib;
@@ -158,11 +157,12 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 
 /**
  *	open_getadapter_fib	-	Get the next fib
+ *	@dev:	adapter is being processed
+ *	@arg:	arguments to the open call
  *
  *	This routine will get the next Fib, if available, from the AdapterFibContext
  *	passed in from the user.
  */
-
 static int open_getadapter_fib(struct aac_dev * dev, void __user *arg)
 {
 	struct aac_fib_context * fibctx;
@@ -234,7 +234,6 @@ static int open_getadapter_fib(struct aac_dev * dev, void __user *arg)
  *	This routine will get the next Fib, if available, from the AdapterFibContext
  *	passed in from the user.
  */
-
 static int next_getadapter_fib(struct aac_dev * dev, void __user *arg)
 {
 	struct fib_ioctl f;
@@ -455,11 +454,10 @@ static int check_revision(struct aac_dev *dev, void __user *arg)
 
 
 /**
- *
  * aac_send_raw_scb
- *
+ *	@dev:	adapter is being processed
+ *	@arg:	arguments to the send call
  */
-
 static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 {
 	struct fib* srbfib;
-- 
2.25.1

