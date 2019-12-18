Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB09C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 01:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FE2124650
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 01:42:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ecRHVN3Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfLRBm2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 20:42:28 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36414 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfLRBm2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2019 20:42:28 -0500
Received: by mail-oi1-f193.google.com with SMTP id c16so283592oic.3;
        Tue, 17 Dec 2019 17:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N+bs2iNFWfw8K4kc9VbekWaGMeOdYHefRD+wtZgGsIg=;
        b=ecRHVN3QxjPmXu/OGHNX3KkhC4Gw7arD5IGwKraGon4GcCc5a3LHIWVGmuoIxRXC1G
         Q7acVs/R7eyN41d0RpgisRAaELzJdDyh9Wso8d+KN/HCR6OQdizosgOihcGfMHQ6IgFk
         +81aToAfygpEbhCDsvD5489bTuS/gqQYlvMcmilDenHb0LLk4sRQzGHzCyQpHmj52lIU
         p6vJBA/Z+FDvxGYqgYxae2uCuAzGFO8gsqcF4j812f8Gyu1jMSb1EeBGm5MJD5Gx6BUh
         U77xiDfQ+OX2nD57HP3AcUmxxH30q/K+CyfuFutCVBbCzA9ciYFJGP2P4IeS/nl8+liC
         HzJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N+bs2iNFWfw8K4kc9VbekWaGMeOdYHefRD+wtZgGsIg=;
        b=VcbfNqStKlaKlqUGfBbSWgLU6t0M3PSjLpFBqSaM9bI95rwcjrKP1WDruHslBb/tSf
         SA2eISL84E0pAozEBdSJ0y2WuW7sk1rKmDAiR40nQtrZ6+Km0wmgXMeb8DkaIwO6/Wcg
         UdLpYbni1mL7UIDVRd8ak/BGIYCn0508CVEdiMnrpAdRU5hB86vWyd/ohKlcv3uGWnKq
         9t/W6HfeBWVOzxt11YHCfAKeOws1f3D7QqYPfh4U9saZEbJgoRlDzHaouthJHeEVEZ1u
         hP0T0ccXx2RZuL9p1eoDDIc2Z6vgLJwv6EA12T/0hsQVTEtq+NetkweyIiktqtprBz2X
         4U4Q==
X-Gm-Message-State: APjAAAVHnq/59xJe+qZZZNKMIUU702Ogw9/EAxf/3Foo8SDbI00UJd9t
        2aWmy3bp47kgJ55FjNFZMA9voTre
X-Google-Smtp-Source: APXvYqwK75exxun+25KzMqZtBIlf8NvNj2yKQBQoFyGOJlSWHDS84TqIRtTVjLsMDYVJ4652keUdNA==
X-Received: by 2002:aca:5f87:: with SMTP id t129mr115076oib.36.1576633347229;
        Tue, 17 Dec 2019 17:42:27 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id n2sm248564oia.58.2019.12.17.17.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 17:42:26 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] scsi: aic7xxx: Adjust indentation in ahc_find_syncrate
Date:   Tue, 17 Dec 2019 18:42:20 -0700
Message-Id: <20191218014220.52746-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clang warns:

../drivers/scsi/aic7xxx/aic7xxx_core.c:2317:5: warning: misleading
indentation; statement is not part of the previous 'if'
[-Wmisleading-indentation]
                        if ((syncrate->sxfr_u2 & ST_SXFR) != 0)
                        ^
../drivers/scsi/aic7xxx/aic7xxx_core.c:2310:4: note: previous statement
is here
                        if (syncrate == &ahc_syncrates[maxsync])
                        ^
1 warning generated.

This warning occurs because there is a space amongst the tabs on this
line. Remove it so that the indentation is consistent with the Linux
kernel coding style and clang no longer warns.

This has been a problem since the beginning of git history hence no
fixes tag.

Link: https://github.com/ClangBuiltLinux/linux/issues/817
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index a9d40d3b90ef..4190a025381a 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -2314,7 +2314,7 @@ ahc_find_syncrate(struct ahc_softc *ahc, u_int *period,
 			 * At some speeds, we only support
 			 * ST transfers.
 			 */
-		 	if ((syncrate->sxfr_u2 & ST_SXFR) != 0)
+			if ((syncrate->sxfr_u2 & ST_SXFR) != 0)
 				*ppr_options &= ~MSG_EXT_PPR_DT_REQ;
 			break;
 		}
-- 
2.24.1

