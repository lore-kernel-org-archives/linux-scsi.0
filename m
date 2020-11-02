Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED11C388F2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3B16206F8
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:24:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OEPURfW0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgKBOY0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 09:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgKBOYY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 09:24:24 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4490EC061A04
        for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2020 06:24:24 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id 33so4037194wrl.7
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2020 06:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UpntW8qOQ6pR3vVGmsTYcGUv23Vlc0jF5vAOPXJRUnY=;
        b=OEPURfW0F5vM6exWKOpcJkjQrhV9jXWZbcAdjngWRPRcaLOP5W4ZwGGQxQN54fY3Sd
         GVCokXyaAlkA5Bsoe5Wfn3xNV0rp05HNqMNKoMAbXEQTSXw1XhgMvgb9YBLzuxmUX5Z4
         xg8rMBp2jc4OInxJy6pp9N9Enz5eNE9JlYt3m0j8VJkUXaRvpLHvwmi08unDt4fj4YEL
         nbTYzBcn0/ySR2Yt9A8hwP59HbNyd/81GX4zaAPuEmodgnyUZa+Q/F8YiwwSwp8NiR48
         qWB6Hi0pC7gL+i7ej267J9nVvhfx3o/E2zUi+ULF3k2ZVkRrvWfiiZ2SvcXYv+AWiNuz
         Oy/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UpntW8qOQ6pR3vVGmsTYcGUv23Vlc0jF5vAOPXJRUnY=;
        b=GZSDH29NViLJOEqGJEpL5XIGIG3HG5tCId/MxXmCina8mCDH3BcM9opOO6sjxaa25U
         4+3M/eGstMi35vv1kerUsQbUQCkRJgiQj8IA2LcoBbWJoYkGSqu1QGRnuDM7NKfEaQu4
         bB8PuUcF9LojjZlCI4Pr0H07ol7FIxncSdTA/BssBKG5ugNS+5wAEHqUApRZznidI/nZ
         zcOu7sUnn33zC5XBhysTSN1JqwUWq00wyWD7Wvh3dsb5cN4kDnQ9xHI9smL/vIdNP2T0
         aqvQJnBqd5T5rcw4yu6a4XuJeCpXMlmF3wtQLVDxgcUY4IIl0tXyWkF4FCzNaPwk73D1
         Jvig==
X-Gm-Message-State: AOAM533TXUozyPo1fGWwh8hQ5tK8o4XEV5rxKLza6fZTyqw9xBsLfzfP
        Yj338YC4TY96UCGHomM4zJIV/Q==
X-Google-Smtp-Source: ABdhPJzqM4zHDC6zJHOrG9oqJ8YwdfCQNaNJtkjJOKY1K4M2Wce/LLBycsCbeSVNpuImTr2/U1Kyog==
X-Received: by 2002:adf:f20e:: with SMTP id p14mr19910515wro.376.1604327062980;
        Mon, 02 Nov 2020 06:24:22 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id f7sm23542501wrx.64.2020.11.02.06.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 06:24:22 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Bradley Grove <linuxdrivers@attotech.com>
Subject: [RESEND 15/19] scsi: esas2r: esas2r_main: Demote non-conformant kernel-doc header
Date:   Mon,  2 Nov 2020 14:23:55 +0000
Message-Id: <20201102142359.561122-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102142359.561122-1-lee.jones@linaro.org>
References: <20201102142359.561122-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/esas2r/esas2r_main.c:911: warning: Function parameter or member 'a' not described in 'esas2r_check_active_queue'
 drivers/scsi/esas2r/esas2r_main.c:911: warning: Function parameter or member 'abort_request' not described in 'esas2r_check_active_queue'
 drivers/scsi/esas2r/esas2r_main.c:911: warning: Function parameter or member 'cmd' not described in 'esas2r_check_active_queue'
 drivers/scsi/esas2r/esas2r_main.c:911: warning: Function parameter or member 'queue' not described in 'esas2r_check_active_queue'

Cc: Bradley Grove <linuxdrivers@attotech.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/esas2r/esas2r_main.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 7b49e2e9fcdec..923e6e5ddbf90 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -894,15 +894,11 @@ static void complete_task_management_request(struct esas2r_adapter *a,
 	esas2r_free_request(a, rq);
 }
 
-/**
+/*
  * Searches the specified queue for the specified queue for the command
  * to abort.
  *
- * @param [in] a
- * @param [in] abort_request
- * @param [in] cmd
- * t
- * @return 0 on failure, 1 if command was not found, 2 if command was found
+ * Return 0 on failure, 1 if command was not found, 2 if command was found
  */
 static int esas2r_check_active_queue(struct esas2r_adapter *a,
 				     struct esas2r_request **abort_request,
-- 
2.25.1

