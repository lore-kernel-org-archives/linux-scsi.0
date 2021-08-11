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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2532C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Aug 2021 13:25:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D849260EE2
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Aug 2021 13:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhHKNZY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Aug 2021 09:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbhHKNZR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Aug 2021 09:25:17 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F1DC061799;
        Wed, 11 Aug 2021 06:24:53 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so9600431pjs.0;
        Wed, 11 Aug 2021 06:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7W29cLmj2qeifcnEP+7O9P/s+IF/H1sNoqJtFlRWsVM=;
        b=hnX6Fbn3sZNtOM0IiEjv1p5YklFP81Bx39I9A/hm6HUH+C+J57XpkEwFzHcIVlP3Ou
         hyOCZTAARs3+F3TCUwhzoWcybTIfu7twMhC+VPW9C5AzqkikmxFnNgu4Ch1Lgb+jbCEk
         esnijG6uQoRQ4SnFVBjdVjCHAuOWl2Mn61MlleatPIJyuLS6UaYQwGnmPvmjLIpTJa2S
         HpRguc5JtGBixyfV56y9+E5Csy/9F3iNtVtLVCp1O0cUJ6iHi77Z3dGBXlhhuwZkfO7G
         cERbkGm/efRUt3qUMW77gWk8w6ay9QX0RY9XUIjNf2yt7WJTVWNrHUtpDXbA11D7iukP
         q8sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7W29cLmj2qeifcnEP+7O9P/s+IF/H1sNoqJtFlRWsVM=;
        b=jaoCHeE+CDa5sZkhbNkkIwi5Q+Wgmdzj99ucu4wEFmfmP98y9yfQysMn5MHax0zxAh
         /luHG6FnWfhwNkTN+VW2xokbRUVV/5bg1V0GePkXyQmnY1hZSbbFbHnKoXugj1vER/2i
         P+eaXzU4d4chmDWtuWlYmxJmTw21mgEavTNKjE08i/1Bfdk1w0M3B9ExYrN8Pxht79Wa
         3E+PvXC3rVTZlCMPYPJ2tneQQwIXSyk4zBHLW0uVhZQvilxvTponGKh6daawbgMa4agx
         Hti+r27fNfQgJDBgM+CLtL3gLpe0rFB6WU5LREUcTx7Jh1cguCmInOuHYJAGnB0wdqSR
         3pNQ==
X-Gm-Message-State: AOAM530SQ/QftenBx6R3RRKbvoiqlC4vLcGmLiMearROYwZ9B4G9lNeR
        d65kFe4OhoT/vJ1KBL3R+/Y=
X-Google-Smtp-Source: ABdhPJwpFtYj0IsB7kGWdVscS5MzJTwhgZR+O1kLVBlilObCPUMi6o50vbf4pj2FDByS5trpGAgqxA==
X-Received: by 2002:a63:86c8:: with SMTP id x191mr244739pgd.166.1628688293331;
        Wed, 11 Aug 2021 06:24:53 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.103])
        by smtp.gmail.com with ESMTPSA id 11sm32404623pgh.52.2021.08.11.06.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 06:24:52 -0700 (PDT)
From:   Tuo Li <islituo@gmail.com>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH] scsi: mpt3sas: Fix a possible divide-by-zero bug in base_mod64()
Date:   Wed, 11 Aug 2021 06:24:39 -0700
Message-Id: <20210811132439.10370-1-islituo@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The variable divisor is checked in:
  if (!divisor)

This indicates that divisor can be NULL.
If so, a divide-by-zero bug will occur:
  remainder = do_div(dividend, divisor);

To fix the possible bug, the function returns 0 when divisor is zero.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 19b1c0cf5f2a..3550998ea38b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1594,8 +1594,10 @@ static u32 base_mod64(u64 dividend, u32 divisor)
 {
 	u32 remainder;
 
-	if (!divisor)
+	if (!divisor) {
 		pr_err("mpt3sas: DIVISOR is zero, in div fn\n");
+		return 0;
+	}
 	remainder = do_div(dividend, divisor);
 	return remainder;
 }
-- 
2.25.1

