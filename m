Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C71D7C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 09:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8BED2173E
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 09:45:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="iAtIDBuB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgHEJpu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 05:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbgHEJpT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 05:45:19 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BA4C06174A
        for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2020 02:45:19 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id p8so8019409pgn.13
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2020 02:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jZ7zBAmaLTbB7ZI7UK6uP32mQ4MxQ7D03hfaE9GRXSs=;
        b=iAtIDBuB4LCaHZkty6Oo33MbxRRjP/d6KzD3Yu5QX4NjwpY53HaAaQM2zmswmk4Pdi
         WdBtF7U/AwSmQ23pUbASK7E8LCVI1m0hED7uJocwj78mi4AG+10utBFovxyeSrSEah0n
         J+qjeaJ3x0rBIExnJbwxKZPBP5HuMDpO/q6co=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jZ7zBAmaLTbB7ZI7UK6uP32mQ4MxQ7D03hfaE9GRXSs=;
        b=NS/gNfFHBcpEnTFglBCFElcbg4JykUr9A+3A3pDaxRwOUrpXmy3JlHMWm71RukNdRI
         bLCNYuxCt6qlPpbrJkBQQqu0OTjf0DbZbGzIOVIVRajmA1OlmVqzAn0KRtpjcUY3tmF3
         vhImNPg9AHzBkG8LxFWL0LYzUdqR6ltmM+BXOaG7zI8f9je840RtTJ9dRBgZ/Uo3ECbV
         wt3kgPPO3SyVsN6hwDQ69+7ntaxVSnUJEfovr9kk617SgdBVFQlYO8qKjUfSbrE6f0Ok
         BqJxywvuU6r/C1fmeeBHS3oCt9UzchOlGD5qezKkpCl7rnAxarF2y4iVamV/QN+QcMxn
         a3IQ==
X-Gm-Message-State: AOAM531fIgM1431gBPWegFciB1ozGadAkAQr0G+J6rQ8tKoqxaxZ5nL+
        cl96bY1wGXUScQz57+BuGhjVBkyWTNGTWxR6IV+wqgBNUcQ0ArQCKyLHy68vXeHn5gr3qf80FvH
        Vxwe++V0YurseurDzvitfECm0C5AAvezn9bC8dOfByCP8+R8cqMgN0JXRp7DF/+s7Pa0BvdMEww
        c7Tr4DfQ==
X-Google-Smtp-Source: ABdhPJxnM4Oq4U58Z/1FpDbdrc1HB69X3JD9kba2w3o6Vr0YuvAMgBo9WzrU25Czdl8E/TPGH1QPRQ==
X-Received: by 2002:aa7:9314:: with SMTP id 20mr2415977pfj.65.1596620718358;
        Wed, 05 Aug 2020 02:45:18 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id e9sm2632346pfh.151.2020.08.05.02.45.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2020 02:45:17 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     hare@suse.de, jsmart2021@gmail.com, emilne@redhat.com,
        mkumar@redhat.com, Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH 2/5] scsi: Clear state bit SCMD_NORETRIES_ABORT of scsi_cmd before start request
Date:   Wed,  5 Aug 2020 08:20:59 +0530
Message-Id: <1596595862-11075-3-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clearing the SCMD_NORETRIES_ABORT bit in state flag of scsi_cmd if the
block layer didn't complete the request due to a timeout injection so that
the timeout handler will see it needs to escalate its own error recovery.
Also clearing the SCMD_NORETRIES_ABORT bit in state flag before
blk_mq_start_request.

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
---
 drivers/scsi/scsi_lib.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 27b52fc..3da6402 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1594,12 +1594,15 @@ static void scsi_mq_done(struct scsi_cmnd *cmd)
 
 	/*
 	 * If the block layer didn't complete the request due to a timeout
-	 * injection, scsi must clear its internal completed state so that the
+	 * injection, scsi must clear its internal completed state and
+	 * SCMD_NORETRIES_ABORT bit in state field  so that the
 	 * timeout handler will see it needs to escalate its own error
 	 * recovery.
 	 */
-	if (unlikely(!blk_mq_complete_request(cmd->request)))
+	if (unlikely(!blk_mq_complete_request(cmd->request))) {
 		clear_bit(SCMD_STATE_COMPLETE, &cmd->state);
+		clear_bit(SCMD_NORETRIES_ABORT, &cmd->state);
+	}
 }
 
 static void scsi_mq_put_budget(struct blk_mq_hw_ctx *hctx)
@@ -1652,6 +1655,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		req->rq_flags |= RQF_DONTPREP;
 	} else {
 		clear_bit(SCMD_STATE_COMPLETE, &cmd->state);
+		clear_bit(SCMD_NORETRIES_ABORT, &cmd->state);
 		blk_mq_start_request(req);
 	}
 
-- 
1.8.3.1

