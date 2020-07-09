Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E41C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C02C207D0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S9JQfJkt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgGIRqD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgGIRqC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:02 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B386C08C5DC
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:02 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a6so3294400wrm.4
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xTqXVtAy6STm+CsKD82SFXkbTZ9Yyt2OGjfREOk+wxw=;
        b=S9JQfJkt74EhytPvboT0wPEsWVg4OmCFYcNqHiChFX9Ce69gEUSsHaVYbxBjlOfqzF
         /Z5WmgD7mCxQg5qL9vEsu+Ok+V/Rsrryoi6l02scA1Hp6owww0VU8y3sEvSqqbaLHtkP
         p6A5jxcrfRIPw+t5kSrT+MbLgovNOInkeVtQL5FfEA7GEXtlnQSsvBYSvh6mj9QH+MsL
         47WOD0IDDYXu9eIBYe1IR1i8tupG8AKOP6Qr5ERENBCFo5mnzFykllrvh1WHaW52QNaR
         Y9fZjksMUNTw+KXQ8rJtik2x8pxjCka8wpUJCN4CbVDDeCbC+b2mR/Dt9z04/sYrfpu2
         doyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xTqXVtAy6STm+CsKD82SFXkbTZ9Yyt2OGjfREOk+wxw=;
        b=l1YyvOmXE6c9AM6hPUGuoANxROWCnNr+WNPHY2aL3YG9bHyr2ngdBGaSZF5yn1Opv7
         d9CPY0spi0J+n89rALL3mTNA1eR9qt7yo73PGBn9qs52xeDo4R59KAxLHD7vxQYyvIRi
         rwvn+Psw9M/KNlyYocahV+2qq9BKdu1ele1Y3XgHOy/nAlvXslViaqxLYAfqo0jXPvSt
         UqMyPEiqTMZER0m3BGwODhAgEGuEvhdWceZGsHEwh8SbjJYSFeWJRsyzSB7+1wbvkmzA
         2FsIkzwrWv0hljBhNhby6OzQlSkOOrsCz7NtwM4Mn5kQkXEv9zmP64WMTCyh9M/oJm52
         F69w==
X-Gm-Message-State: AOAM533vyppM8CIqvZkqUdKrZ9Ct88rV4siE9FXDChqrwiESq2S9vHT3
        +FWV9MDIXWAGY/ivR1CiUVmqBw==
X-Google-Smtp-Source: ABdhPJwmxoKBk0V1ybPQdpN3mHBUNT+ChaQuAGzu5i0BAePdNB2eXh4C37EVHiTyJIFG4bMLogHgiw==
X-Received: by 2002:a5d:55c9:: with SMTP id i9mr63242054wrw.404.1594316761133;
        Thu, 09 Jul 2020 10:46:01 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:00 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Subject: [PATCH 02/24] scsi: aacraid: commctrl: Fix a few kerneldoc issues
Date:   Thu,  9 Jul 2020 18:45:34 +0100
Message-Id: <20200709174556.7651-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
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

