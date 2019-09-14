Return-Path: <SRS0=hn2k=XJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8379CC4CEC9
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Sep 2019 15:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C95C2081B
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Sep 2019 15:47:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tLOjApsf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfINPr7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Sep 2019 11:47:59 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40558 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbfINPr6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Sep 2019 11:47:58 -0400
Received: by mail-pf1-f193.google.com with SMTP id x127so19888577pfb.7
        for <linux-scsi@vger.kernel.org>; Sat, 14 Sep 2019 08:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=V8YrCBigTbUXJydGl38V2x7OLxNmNlTnznLQxQ1z8nc=;
        b=tLOjApsfKwqeinPuGBKgpGgcw6dOpXOmCzOfsrAWkphGyPsu6q9+R0yaFa/mUfvslz
         7IFWDm3Z8v364qORx+fpLYzHEFUExuUCZK2qLWN7qWDR+jq2svMSl8MIkLJfbnH2Rx29
         eVj8zEb8WGeGjVRkyKkApEKVFywUQkwxS043knmzhJrzgs6jhlv9Rh4HRncdIABbqab5
         wEoMnzp+6cXTJ25Nkoe5MM0y3Mtl5DL6SKiY7nv7UyDz9yO4tzMcHJBY4MGQ331ipYeS
         1GVbZ+k2sOVNpX7lT2xgzadZZ7epFe6coTnS/E+Axr/7TFUu12D7WaCBXQh43fZWmNls
         CCNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=V8YrCBigTbUXJydGl38V2x7OLxNmNlTnznLQxQ1z8nc=;
        b=X0mHykNRrnr+wTI1JXddPdihIxeS0zUUGlkvX1+eWdDZR5TwF10oVfa4oBli4aqEug
         nkkBSw1iSzyVNtQIWTLQSM9FcYxAJy7slcC/Bibzf8r8jcmVq+uV8YZf/o70kv/I3qBz
         ZatSk6SoIcs/MGqZayKX1hPaG9HLzdL+rgDhZQlYo6mmTqQy7yDXNR2WXqhYMMBwu3p8
         Hjw43kwkG2329e+M+hL6mz6oCPRjpDBTiLWqsUVjeZmX41khNIgStWEmq2LkRVd9CNVr
         lQGgC3kGBtzBmlpaV+7r0+Il50MzzOynTkfcNrXac66iVNFECc87F4/MtV9740bNiuX9
         s71A==
X-Gm-Message-State: APjAAAU3IFTvlDY0s0cUre9nSDUV5diyP+lceTamBYV283I+quHXIgQN
        cKevcotFDkKGaEdkrt/tgI0=
X-Google-Smtp-Source: APXvYqy9xHgzNy70QO84tnqugbcEp/L94KoOezBPCqDhYRQmfMcr3xPzYDZbYBHvXfaOpOuIQS0+Lw==
X-Received: by 2002:a17:90a:3748:: with SMTP id u66mr11479319pjb.4.1568476076474;
        Sat, 14 Sep 2019 08:47:56 -0700 (PDT)
Received: from localhost.localdomain ([103.228.147.172])
        by smtp.gmail.com with ESMTPSA id x5sm32939376pfn.149.2019.09.14.08.47.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Sep 2019 08:47:55 -0700 (PDT)
From:   aliasgar.surti500@gmail.com
To:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     Aliasgar Surti <aliasgar.surti500@gmail.com>
Subject: [PATCH] drivers: scsi: aic7xxx: made use of kmemdup
Date:   Sat, 14 Sep 2019 21:17:43 +0530
Message-Id: <20190914154743.24227-1-aliasgar.surti500@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Aliasgar Surti <aliasgar.surti500@gmail.com>

There is usage of kmalloc following memcpy in this driver file.

Instead of using these functions, this change is made to use kmemdup
which has the same functionality.

Signed-off-by: Aliasgar Surti <aliasgar.surti500@gmail.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 7e5044bf05c0..245f3132ac1c 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -9442,10 +9442,10 @@ ahd_loadseq(struct ahd_softc *ahd)
 	if (cs_count != 0) {
 
 		cs_count *= sizeof(struct cs);
-		ahd->critical_sections = kmalloc(cs_count, GFP_ATOMIC);
+		ahd->critical_sections = kmemdup(cs_table, cs_count,
+						 GFP_ATOMIC);
 		if (ahd->critical_sections == NULL)
 			panic("ahd_loadseq: Could not malloc");
-		memcpy(ahd->critical_sections, cs_table, cs_count);
 	}
 	ahd_outb(ahd, SEQCTL0, PERRORDIS|FAILDIS|FASTMODE);
 
-- 
2.17.1

