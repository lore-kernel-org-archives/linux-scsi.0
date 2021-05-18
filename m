Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E33C43616
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97D78611CE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351311AbhERRrF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:05 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:44653 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351319AbhERRrB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:47:01 -0400
Received: by mail-pg1-f180.google.com with SMTP id y32so7516969pga.11
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nOVo62aD3xBlvWPJJ5wlCyfpxi8Hex+qVuCS0WhbLxU=;
        b=fjyTLBZOc2XhJ4F4EHLy/Y+j0BrB+Hw7FcNQh5wp0oSO/sQmoj6P5SIa91PzmvMTqg
         7EXIMdJ/mTRvTj+Io6wIReD4F+DtZuowXWCD1j6mO6c32Cn+Qh49jUIGAC3OJUVuQPPt
         nv2QuTki7CZ7S+rsgVRu69tt8QxRW/dyksZ/TO2BvdaDetXU9BmnPSDsblW+hQQv8Neh
         EjHUhKXwuBatqKGJUY9mzYRL7sixq4j1pycUqQtT9iJfDVhltKLEF3YGKAf8OceeK00+
         DfYJZkMQsDZmnX4Q1oMTRjjdfWN/8HOb5SPXJrzBatzONVM8gbBcJBg035/GkQhQ0ylk
         QvHw==
X-Gm-Message-State: AOAM530uvfLk7mHYtOrpy925PFuLv0Vq9IAnTrzr6VZys69Xg+11lypK
        iQv4smEjjd1aT3PPn12mEW8=
X-Google-Smtp-Source: ABdhPJwHVpxGZkXuzuefU7EypTimhwpjToD95u2YS2v917xluRbwKIuPCrZ0TZ61IWm9UXDpNCLbKg==
X-Received: by 2002:aa7:8896:0:b029:2de:a06d:a52f with SMTP id z22-20020aa788960000b02902dea06da52fmr3206155pfe.4.1621359943035;
        Tue, 18 May 2021 10:45:43 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 38/50] qlogicpti: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:38 -0700
Message-Id: <20210518174450.20664-39-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qlogicpti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index d84e218d32cb..8e7e833a36cc 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -890,7 +890,7 @@ static inline void cmd_frob(struct Command_Entry *cmd, struct scsi_cmnd *Cmnd,
 		cmd->control_flags |= CFLAG_WRITE;
 	else
 		cmd->control_flags |= CFLAG_READ;
-	cmd->time_out = Cmnd->request->timeout/HZ;
+	cmd->time_out = scsi_cmd_to_rq(Cmnd)->timeout / HZ;
 	memcpy(cmd->cdb, Cmnd->cmnd, Cmnd->cmd_len);
 }
 
