Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F1AC4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Aug 2021 13:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B833760EE2
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Aug 2021 13:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhHKNRn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Aug 2021 09:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbhHKNRm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Aug 2021 09:17:42 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49538C061765;
        Wed, 11 Aug 2021 06:17:19 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id l11so2659416plk.6;
        Wed, 11 Aug 2021 06:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AurmHbnu8tfyA/yzKLIfssWMJAWF2LYw49Rd9z7EAkk=;
        b=dZwrnERaSbZZNDXN+dyFAet/wCemiwH1eUgrw9DGNN7uvH775b2YuDSDDyNAza72vU
         lPcRL2Mwm+atA3ek24Hz8D5Xgm766noYbhqjO8yG+PKWfcY4ah2sR63Og1JO9mxP4QCv
         groTxtG5alNaP0greoq/Fyav3UJXYQ+tPP7UAvp94itF5gVKODNvAICbF5valSAhQa8K
         AkvH+x2IPku9Xu+GNiJPKGPI5g+A5oVHNJg9OVC/EQnGarsLgbcKzkZw3eMpfXLe5csP
         gAvECrewBVBBsFL3xrv5fkTkaEa2gZAghE0ybYmLU6h0rnTEVjj2vaISuGMcsfSqXePe
         uCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AurmHbnu8tfyA/yzKLIfssWMJAWF2LYw49Rd9z7EAkk=;
        b=ZPaCLiDdqDXrVPsk/LOd7+L7A6LGnVWXTSvpXsU/g449OCh7MB0Q90yyIKr5BUW62T
         tVUP9ipdVbOYT0MhRsEkeWnTi4861LSyK22vmGo+QAw2GvNhswpLIshPgBsM/BiLelVz
         DPRKV02fdYZUKEP1oTk0uX1MGM+3qxb4e4aGdG6lxbg1p70CUNri2xmAkc+SulaGgsSC
         Cp6wjF7HQhNAzptie4UsnHEAu7BgzWp8wmx7p38T35MOyUUUOaWv7i7hE7SPqRp4gARH
         5u2KxX6urNYgIFttfgY2KtM2CB9tnZnx8FgkpgGOLR3OmxXPiyhzGE+Ofw+r48VfnetQ
         ntew==
X-Gm-Message-State: AOAM532WfYzzxPy6aH0sRiOIUcqJd4Kyr0dD6cGG+a6PpxYcvtudB3mG
        ySlMk7ZtXGvhN/tXweI9nMI=
X-Google-Smtp-Source: ABdhPJz65d07WF/BHnXwATnHXb5Mrw6MDXV1vO+KkYtuH3CYo83l807tZO8lx1fcHfUv27K9rm1dnQ==
X-Received: by 2002:a63:5802:: with SMTP id m2mr298909pgb.171.1628687838850;
        Wed, 11 Aug 2021 06:17:18 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.103])
        by smtp.gmail.com with ESMTPSA id bk24sm6651019pjb.26.2021.08.11.06.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 06:17:18 -0700 (PDT)
From:   Tuo Li <islituo@gmail.com>
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH] [SCSI] megaraid_sas: Fix possible divide-by-zero bugs in megaraid_sas_fp.c
Date:   Wed, 11 Aug 2021 06:16:47 -0700
Message-Id: <20210811131647.9300-1-islituo@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the function mega_mod64(). the variable is checked in:
  if (!divisor)

This indicates that divisor can be zero.
If so, a divide-by-zero bug will occur:
  remainder = do_div(d, divisor);

Also, in the function mega_div64_32(), a divide-by-zero bug can also occur 
if divisor is NULL.

To fix these divide-by-zero bugs, the functions return 0 if divisor is 
zero.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 83f69c33b01a..05eb0d201aed 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -72,8 +72,10 @@ u32 mega_mod64(u64 dividend, u32 divisor)
 	u64 d;
 	u32 remainder;
 
-	if (!divisor)
+	if (!divisor) {
 		printk(KERN_ERR "megasas : DIVISOR is zero, in div fn\n");
+		return 0;
+	}
 	d = dividend;
 	remainder = do_div(d, divisor);
 	return remainder;
@@ -90,8 +92,10 @@ static u64 mega_div64_32(uint64_t dividend, uint32_t divisor)
 {
 	u64 d = dividend;
 
-	if (!divisor)
+	if (!divisor) {
 		printk(KERN_ERR "megasas : DIVISOR is zero in mod fn\n");
+		return 0;
+	}
 
 	do_div(d, divisor);
 
-- 
2.25.1

