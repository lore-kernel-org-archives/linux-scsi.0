Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE92C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D136860F51
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345004AbhIRAIz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:55 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:46629 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344504AbhIRAIm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:42 -0400
Received: by mail-pj1-f47.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so8518540pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=asTCRK8UCuP9cf3jAjV+qpw0oMPn5K4gL3nWXJ5ZJ6g=;
        b=ZpNTOlzkY0r3Plcxx7cGOPeYNzZDDoeHvSJjdF9YHhWPkMVgJuHggpFJ/qbyOuE4Gh
         jcRW719tvpxViAr2erMPrzabvcGvsmvGLqkgOZ2n+E36H2cT25N6K6P609WXTrL1vGWe
         jKHqj/NbrWAuG97w0nTghwIwg0Dq4J+JCTxwLagBs9cF3G4Y9JGxaXbaba3qG54UFnTZ
         jgcRlkoor20BrS8V6BicuqZmfSpsFWltDAVxfE+mgjCDG31nTTih+JJ8WLBRbRTgk8Gc
         eYLpZGCgguH2ARhgT1EsW2Hn0Xm4AT8GAO+FXm21r94iM5kafDla+J2lbaGv9n/vEQYI
         d5Fg==
X-Gm-Message-State: AOAM531qIPqUfaPd9MAtskidoFlsJDc0PJg7VIpk27IAwrMqhugpnQ97
        oDG/WDI3XXk3Yj0ZUUUbecad5s7LvvM=
X-Google-Smtp-Source: ABdhPJwmf5ZAWnztWiULlpv5mHn67QwIOXUQOD+PRL1DUAs5Nqk4g/IAFUfcWiJ565PAjTf5NbXKVA==
X-Received: by 2002:a17:90b:1b45:: with SMTP id nv5mr23992032pjb.222.1631923639642;
        Fri, 17 Sep 2021 17:07:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 39/84] imm: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:22 -0700
Message-Id: <20210918000607.450448-40-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/imm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 943c9102a7eb..be8edcff0177 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -769,7 +769,7 @@ static void imm_interrupt(struct work_struct *work)
 
 	spin_lock_irqsave(host->host_lock, flags);
 	dev->cur_cmd = NULL;
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 	spin_unlock_irqrestore(host->host_lock, flags);
 	return;
 }
@@ -922,7 +922,6 @@ static int imm_queuecommand_lck(struct scsi_cmnd *cmd,
 	dev->failed = 0;
 	dev->jstart = jiffies;
 	dev->cur_cmd = cmd;
-	cmd->scsi_done = done;
 	cmd->result = DID_ERROR << 16;	/* default return code */
 	cmd->SCp.phase = 0;	/* bus free */
 
