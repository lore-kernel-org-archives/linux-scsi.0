Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC59C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Oct 2022 16:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiJQQfq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 12:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiJQQfp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 12:35:45 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8AA642EE
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2022 09:35:44 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id t25so6978319qkm.2
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2022 09:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ir1jATq+agAdz0wDmIw25l9q7fuV09eeZfqEofI1bGQ=;
        b=dGRwYm609S2iDQQCw76sVvdLxJWWv7xDSxDNvXTN9kUK+6og1b9IiQ+X6Wz6WViRDM
         LcrqFX5jPKRDMDS3/IeeWld7VW794yb4UqkuEhLpbkIIrrG6z+MJ+41q8FYAEs47QDCc
         TpoTL5IOsQzwxE1GTS6lXb86bwQE5asG2629vnwQf+eTeEAHIa19gKAHkCt0A5iSrT+J
         /lMb41s6c+vLDHVIGpmJq6m0ur58wm4SSbv/i2/YQEEKQYjGfbE4cgEtWLawNNDqyWOg
         LW5K5VSazNlMHkbC1UL9Zmm7+1Bp8ieHigMQtmbumOhQTEYtWNshXfJEpztcNAFsIe3Q
         Gp7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ir1jATq+agAdz0wDmIw25l9q7fuV09eeZfqEofI1bGQ=;
        b=uUxxz8QCYUk4q9CULy+GIclohceMXOtVllZlICTVKDvADL7OATbMk7wgbux31WAIfG
         pPQhaTzYZ3b6bzy1bT7hUl2XoLdd6cCOKH28egjDQGnDA3JXPHirRtnVQQ4yONGlkNsq
         7T10oR4dXjyfZpkZ9qv71EWgTd6ebieeAAKFeo8WBjMozwvk9fEH6b1mWYKItY7wU9/s
         nVcLyM1wpkUHiq5AqsZiNnBsrh8lnKMJ7cLJg8icoHWM6bdXh0gfXXddrgLr+Z3fBAgF
         nEZlmLHdt9KZLjV2tROD7guKmh7MTrsUI+lOqY2D9ldKSegmcHqFmYC8FrBBo6Lm6PUc
         fqlQ==
X-Gm-Message-State: ACrzQf1BhbkQzBLBP13+Qnvz/bENEK9Th6LOYWuQDAF+FAlFwV8b2PPH
        4320dsYr4jTtLXP+NeLdtBa8znxbSYo=
X-Google-Smtp-Source: AMsMyM7xwHdMENwlSyFNikSyjfD1hblB1zJKIUxqEIGEhM80GrZ6NtumUwjv0Hm+dN9uofNa4T8JnA==
X-Received: by 2002:a05:620a:408e:b0:6da:aac5:390d with SMTP id f14-20020a05620a408e00b006daaac5390dmr8151780qko.745.1666024543091;
        Mon, 17 Oct 2022 09:35:43 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r2-20020ae9d602000000b006ceb933a9fesm152235qkk.81.2022.10.17.09.35.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Oct 2022 09:35:42 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, Justin Tee <justintee8345@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 3/5] lpfc: Log when congestion management limits are in effect
Date:   Mon, 17 Oct 2022 09:43:21 -0700
Message-Id: <20221017164323.14536-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0.83.gd420dda057
In-Reply-To: <20221017164323.14536-1-justintee8345@gmail.com>
References: <20221017164323.14536-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When bandwidth reduces from or recovers back to 100% due to congestion
management, log the event.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 86ba45ac91c8..d25afc9dde14 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1848,6 +1848,18 @@ lpfc_cmf_sync_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				  phba->cmf_link_byte_count);
 		bwpcent = div64_u64(bw * 100 + slop,
 				    phba->cmf_link_byte_count);
+
+		if (phba->cmf_max_bytes_per_interval < bw &&
+		    bwpcent > 95)
+			lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
+					"6208 Congestion bandwidth "
+					"limits removed\n");
+		else if ((phba->cmf_max_bytes_per_interval > bw) &&
+			 ((bwpcent + pcent) <= 100) && ((bwpcent + pcent) > 95))
+			lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
+					"6209 Congestion bandwidth "
+					"limits in effect\n");
+
 		if (asig) {
 			lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
 					"6237 BW Threshold %lld%% (%lld): "
-- 
2.38.0.83.gd420dda057

