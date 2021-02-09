Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E69C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 14:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00DEF64E4F
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 14:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbhBIOcz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 09:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbhBIOcj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 09:32:39 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734EBC06178B;
        Tue,  9 Feb 2021 06:31:59 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id u20so18063373qku.7;
        Tue, 09 Feb 2021 06:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z4RbdotA04C5B3ThdFiLXJ4zTAivJHaUQ7uU1yZj3aA=;
        b=XYc+i519sq9/P2+HCHRkrwo5aRhblNzDDiQiAr8VJdzHkv+Fw7Ho++jkmNAeKiSTuf
         X2mWzkFw0od/fbKaCl6+n2RUSeAxB5WsfJ7uDFHCllBtmCJVdhkCwziTShMwSCg3QPsm
         sDUyTFdlc2Ph6FAkZ2/QcMqCvu9jOQmiW7EHPvW95SOj7cyb9c1jhc4W1SCL96Q88KW/
         IyDSRE0OwbPMxHFwmT1Ph2vn1GY/5HCmhicbl9lHklq7T5Phd1iD4MdVuGil7K5bmiHT
         FmqxxbfewUGZ9tyMPid8sSXYbwhuT7MGBNe9+UBMF2z3/is81JQaI7A5zjl/8I6rBIAd
         xpJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z4RbdotA04C5B3ThdFiLXJ4zTAivJHaUQ7uU1yZj3aA=;
        b=ldeaFYQ9mJElh3AcC9gtpCDQaVFrHjUKlln61jcbnw6XJyJNWjvxqA7F+dSmapPWTp
         VoeHnRCk4OWNPFa89h5QeEn/500GIh7JBtWQ9W0n6vTlxqAgevkmCr3NqLRugp8wWy6x
         W/rSHoIUjTNDw71w5P4lYSqOJ7WpVtVgyawYOWPg9aND1Hh01kwtPBSUOefe3+IEOfyV
         jU/4N7pT5C24cMUzVnKby7FKivdZhUq1SM/D5lHfUJ+Be/n52+WF3kIR1YQ1BK4bz/HR
         tWKfzm3M3Q0QfUgGhiZaC00pOhlp3ChqPHIAy0oP2ap3/LZaTz6fcyVoDCwoydZmQ6Ba
         Dg6A==
X-Gm-Message-State: AOAM532AHxyHH58L2cqA3gp/92fg5qz4QEsGt9mHYSsiX750+tjoJ2QH
        /c+wctj8UpPXv6h9zW78gAs=
X-Google-Smtp-Source: ABdhPJyYu//mrtl5BlfX2DeubgcH5BasnO/N4NO/ThhKr67QjUYr3EZymd9I6wCLU/JdwpsA+YrrQw==
X-Received: by 2002:a37:b96:: with SMTP id 144mr10730254qkl.314.1612881118762;
        Tue, 09 Feb 2021 06:31:58 -0800 (PST)
Received: from localhost.localdomain ([156.146.37.186])
        by smtp.gmail.com with ESMTPSA id n20sm8276567qke.128.2021.02.09.06.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 06:31:58 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] drivers: scsi: aic7xxx: Fix the spelling verson to version in the file aic79xx.h
Date:   Tue,  9 Feb 2021 20:01:46 +0530
Message-Id: <20210209143146.3987352-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


s/verson/version/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/scsi/aic7xxx/aic79xx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index dd5dfd4f30a5..c31e48fcebc7 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -1175,7 +1175,7 @@ struct ahd_softc {
 	uint8_t			  tqinfifonext;

 	/*
-	 * Cached verson of the hs_mailbox so we can avoid
+	 * Cached version of the hs_mailbox so we can avoid
 	 * pausing the sequencer during mailbox updates.
 	 */
 	uint8_t			  hs_mailbox;
--
2.30.0

