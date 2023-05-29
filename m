Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0729C7EE2C
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 19:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjE2Tup (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 15:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjE2Tuo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 15:50:44 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6A192;
        Mon, 29 May 2023 12:50:43 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-64d24136685so2499330b3a.1;
        Mon, 29 May 2023 12:50:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685389843; x=1687981843;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MAnY68W9tQQFxirzvgmzIs7axxvCCPBIV4gB1cEwbKs=;
        b=ey6ouAopKAJDiZeKbVFX9s+CVDuD10jD5MWXQljszeVh2DZHev4oRpUMiaFuPlpVkm
         4qITVaW0Bc2KFdlVxiHiLCDnVGCLSlV6DP8fBvPkt66cJE4YZ6yrgJ7EDNQ6n5OcEITn
         JPGtvwTG89XJMwbPJ7XgzrUEp8rTe2Lxy7gZtoAHud2/5jiBn3CWm3ysNz+/l4aoxtxQ
         0RsYzdtopRExUMaH+pP943U32mE96JlRyUXQpH+rGNrLPQjtsL+wWmNbOgAmMnL6pbRs
         Fu1IiGqjOelh8520LV6m7Rr0Wls9fQL66NsWFE/BnB9XtX+Z3wuWnHKu8f+SSWSqdzcO
         uCig==
X-Gm-Message-State: AC+VfDx5as0dsV5glI2pGB2Sv3DRX3UyETq6ku4fgOrI0E69c6FQ1k5f
        N0FSqK1MjahSRRz5+RsxJSc=
X-Google-Smtp-Source: ACHHUZ6T2OA24hg6NpIMcaquz8fMTD2Jb28OB83h0iUNjjnk4ddaFAddVClwWGvb75oWJ0bBbCA3mg==
X-Received: by 2002:a05:6a00:10ca:b0:64f:d4a8:8fa9 with SMTP id d10-20020a056a0010ca00b0064fd4a88fa9mr580815pfu.9.1685389841765;
        Mon, 29 May 2023 12:50:41 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id e10-20020a62ee0a000000b0063b488f3305sm273360pfi.155.2023.05.29.12.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 12:50:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH] scsi: stex: Fix gcc 13 warnings
Date:   Mon, 29 May 2023 12:50:34 -0700
Message-Id: <20230529195034.3077-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

gcc 13 may assign another type to enumeration constants than gcc 12. Split
the large enum at the top of source file stex.c such that the type of the
constants used in time expressions is changed back to the same type chosen
by gcc 12. This patch suppresses compiler warnings like this one:

In file included from ./include/linux/bitops.h:7,
                 from ./include/linux/kernel.h:22,
                 from drivers/scsi/stex.c:13:
drivers/scsi/stex.c: In function ‘stex_common_handshake’:
./include/linux/typecheck.h:12:25: error: comparison of distinct pointer types lacks a cast [-Werror]
   12 |         (void)(&__dummy == &__dummy2); \
      |                         ^~
./include/linux/jiffies.h:106:10: note: in expansion of macro ‘typecheck’
  106 |          typecheck(unsigned long, b) && \
      |          ^~~~~~~~~
drivers/scsi/stex.c:1035:29: note: in expansion of macro ‘time_after’
 1035 |                         if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
      |                             ^~~~~~~~~~

See also https://gcc.gnu.org/bugzilla/show_bug.cgi?id=107405.

Cc: stable@vger.kernel.org
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/stex.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 5b230e149c3d..8ffb75be99bc 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -109,7 +109,9 @@ enum {
 	TASK_ATTRIBUTE_HEADOFQUEUE		= 0x1,
 	TASK_ATTRIBUTE_ORDERED			= 0x2,
 	TASK_ATTRIBUTE_ACA			= 0x4,
+};
 
+enum {
 	SS_STS_NORMAL				= 0x80000000,
 	SS_STS_DONE				= 0x40000000,
 	SS_STS_HANDSHAKE			= 0x20000000,
@@ -121,7 +123,9 @@ enum {
 	SS_I2H_REQUEST_RESET			= 0x2000,
 
 	SS_MU_OPERATIONAL			= 0x80000000,
+};
 
+enum {
 	STEX_CDB_LENGTH				= 16,
 	STATUS_VAR_LEN				= 128,
 
