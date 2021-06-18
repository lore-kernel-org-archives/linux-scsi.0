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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B95B7C48BDF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 16:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E9EC613D1
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 16:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbhFRQrc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 12:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235701AbhFRQrb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2021 12:47:31 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4230C061574;
        Fri, 18 Jun 2021 09:45:21 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id r20so8025815qtp.3;
        Fri, 18 Jun 2021 09:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SlRhINCkDHV1IRhp7Zp5ld96OYqv7fiIsGZ4mAFsnAA=;
        b=gcxlnqb8U0xKOTAqGd7G9Rz8ixdZcDzVWYcqX3qmP7US/Ky3FdK0RIMJCFTTmR2Lfo
         Kh4MMRYkjftLBLMAh/VJ3AfWRX2lV3cTyWZja3AwB3WGTXiGr35UdAXYpR1EUwSZ6clR
         UWabVE0WCSz3KIEV/Tq/9ljt75y5YmFz+akGBUlDAVCTSpKeAk1ynm8jsc24ydi748CH
         l9idgporYxrQhrbGBKBAI/Lzi7m1bixfGAdfaAIkO1d9pUlbmsZjnml58ElQEIkUDw2w
         OJjfLrIV2u21ub+WM2kYkyuOaPXOZOTFYT3cNrDFX0fty8ShA42yH0LSxyoc6FdOobMW
         Nraw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SlRhINCkDHV1IRhp7Zp5ld96OYqv7fiIsGZ4mAFsnAA=;
        b=iRHq32vKmg552BmBWgu9y+81qNr25UKvR6QcnKml6BZoqj6wkzQsUTNsmIm+RCnlFx
         kPDbgSftN6UP631TC/6xMVkgA2MzcQkGuspcppC+5O68Lk0zwvEfXzX0oB98adodrzae
         pkof2ID83yls9jRg5zlnCHy4LBP5dhcwiJH5tLZP2st0KR6muO42KgVA5CEHJw/kfkVg
         8p8T4Ho8hTqTeYYRfDyUk21vJA/B0vqmGSpx+t5iO43LVv0raU1y2K9dLxD3v0/ZSCca
         dxYHrR9YTuuN/PnZhCHZj+Op0kznzKNBgQTKABowIUUKfJyh8T3JgoUfu+RhRqAUn8W3
         U9FA==
X-Gm-Message-State: AOAM530symcb/PXI3Wog8n4Nk4c7HThzA0o1rpt4WWUxXiaVNfBaKPiy
        OZYpTdhG+rI65aCypEVY+uk=
X-Google-Smtp-Source: ABdhPJwUgRwMahO4Bqfyt7+kkZIqrOPpOspcilVvH7lgehZq2++ADOtal19xlVGYHkqJhzH3j/Y6wQ==
X-Received: by 2002:ac8:7c9c:: with SMTP id y28mr11311727qtv.192.1624034720817;
        Fri, 18 Jun 2021 09:45:20 -0700 (PDT)
Received: from localhost.localdomain (ec2-35-169-212-159.compute-1.amazonaws.com. [35.169.212.159])
        by smtp.gmail.com with ESMTPSA id b10sm4383878qkh.45.2021.06.18.09.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 09:45:20 -0700 (PDT)
From:   SeongJae Park <sj38.park@gmail.com>
To:     skashyap@marvell.com
Cc:     jhasan@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        himanshu.madhani@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sjpark@amazon.de>
Subject: [PATCH] scsi: bnx2fc: Remove meaningless 'bnx2fc_abts_cleanup()' return value assignment
Date:   Fri, 18 Jun 2021 16:45:14 +0000
Message-Id: <20210618164514.6299-1-sj38.park@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

Commit 122c81c563b0 ("scsi: bnx2fc: Return failure if io_req is already
in ABTS processing") made 'bnx2fc_eh_abort()' to return 'FAILED'
when 'io_req' is alrady in ABTS processing, regardless of the return
value of 'bnx2fc_abts_cleanup()'.  But, it left the assignment of the
return value of 'bnx2fc_abts_cleanup()' to 'rc', which is meaningless
now.  This commit removes it.

This issue was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Fixes: 122c81c563b0 ("scsi: bnx2fc: Return failure if io_req is already in ABTS processing")
Signed-off-by: SeongJae Park <sjpark@amazon.de>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index ed300a279a38..f2996a9b2f63 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1213,7 +1213,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		 * cleanup the command and return that I/O was successfully
 		 * aborted.
 		 */
-		rc = bnx2fc_abts_cleanup(io_req);
+		bnx2fc_abts_cleanup(io_req);
 		/* This only occurs when an task abort was requested while ABTS
 		   is in progress.  Setting the IO_CLEANUP flag will skip the
 		   RRQ process in the case when the fw generated SCSI_CMD cmpl
-- 
2.17.1

