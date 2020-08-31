Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E8DC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 02:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65BDA2076D
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 02:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgHaCyK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Aug 2020 22:54:10 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33545 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgHaCyJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Aug 2020 22:54:09 -0400
Received: by mail-pl1-f194.google.com with SMTP id h2so2361511plr.0
        for <linux-scsi@vger.kernel.org>; Sun, 30 Aug 2020 19:54:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S8GnYufv9MZP7N22DryU0jHU7x5XYfvZ5ydievKhN2I=;
        b=nj7YUQBlTcKnv8ItHN6MJwKS9XUgAAJy/VEsfl0kXy2tc6RsZptIkThHpu/pnrYKx3
         zygP5sCFgmtwlD5PsKOTDKvgHw40/8lAfFhCcuhFqmQ5OyuvXzhE1VGLQLe8apavqmTM
         ezJksUbGty3GVa8v+KKOKee8XvOowqOEvpshMHneS+Mu9gu4ctuI5jeWOltBpfxK0332
         SUynII4OK+qQfKOnW2xjMxP5n8zl3hMquQ5xg4W2uvzvIh1MG9I+EyAww9tv3A9vFDEO
         UEIwzdkbTf5G9dWjFP2lQ91UBk1uLDLPdM5CsFe8AqgjVyly8L2hX0im4G9TDf6cncmc
         C3sQ==
X-Gm-Message-State: AOAM531utQesqxYQdgRmxVE8kmwbPtRfqcQnOcghP/evKhj5IIr2pPT2
        omEELCZX1aQGf/H7Vnq1QN8=
X-Google-Smtp-Source: ABdhPJxiV2BNFdqYaNOGPLBxH1mY8UlWyz3nQaUUXvxkxoPgH80f0ydipEcvLbdRkQVqvfEQwQCOdg==
X-Received: by 2002:a17:90a:af84:: with SMTP id w4mr8678964pjq.94.1598842448395;
        Sun, 30 Aug 2020 19:54:08 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id l123sm583569pgl.24.2020.08.30.19.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 19:54:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-scsi@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Can Guo <cang@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH RFC 1/6] ide: Do not set the RQF_PREEMPT flag for sense requests
Date:   Sun, 30 Aug 2020 19:53:52 -0700
Message-Id: <20200831025357.32700-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200831025357.32700-1-bvanassche@acm.org>
References: <20200831025357.32700-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RQF_PREEMPT is used for two different purposes in the legacy IDE code:
1. To mark power management requests.
2. To mark requests that should preempt another request. An (old)
   explanation of that feature is as follows:
   "The IDE driver in the Linux kernel normally uses a series of busywait
   delays during its initialization. When the driver executes these
   busywaits, the kernel does nothing for the duration of the wait. The
   time spent in these waits could be used for other initialization
   activities, if they could be run concurrently with these waits.

   More specifically, busywait-style delays such as udelay() in module
   init functions inhibit kernel preemption because the Big Kernel Lock
   is held, while yielding APIs such as schedule_timeout() allow preemption.
   This is true because the kernel handles the BKL specially and releases
   and reacquires it across reschedules allowed by the current thread.

   This IDE-preempt specification requires that the driver eliminate these
   busywaits and replace them with a mechanism that allows other work to
   proceed while the IDE driver is initializing."

Since I haven't found an implementation of (2), do not set the PREEMPT
flag for sense requests. This patch causes sense requests to be
postponed while a drive is suspended instead of being submitted to
ide_queue_rq().

If it would ever be necessary to restore the IDE PREEMPT functionality,
that can be done by introducing a new flag in struct ide_request.

This patch is a first step towards removing the PREEMPT flag from the
block layer.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ide/ide-atapi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 2162bc80f09e..013ad33fbbc8 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -223,7 +223,6 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 	sense_rq->rq_disk = rq->rq_disk;
 	sense_rq->cmd_flags = REQ_OP_DRV_IN;
 	ide_req(sense_rq)->type = ATA_PRIV_SENSE;
-	sense_rq->rq_flags |= RQF_PREEMPT;
 
 	req->cmd[0] = GPCMD_REQUEST_SENSE;
 	req->cmd[4] = cmd_len;
