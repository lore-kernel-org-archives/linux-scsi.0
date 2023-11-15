Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF9EC2BB3F
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Nov 2023 19:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbjKOTdz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Nov 2023 14:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234275AbjKOTdw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2023 14:33:52 -0500
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6935E19D
        for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2023 11:33:47 -0800 (PST)
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-5c1714df2d8so11435a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2023 11:33:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700076827; x=1700681627;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qkk83oDjuClwUJXgfo5YGGdHWJCCcQwSmDVARKmz/Io=;
        b=M3s+g1JaQtVO4867Tb+iHz820O1v9pTXg5oMDDfmL5RuSxwlsDJRxfIvEkkznFJ8Fh
         EqQXsE0Reht8rj+IUO/3r+sHyOFlb2bwtAbqKLEI3IVtfp6o3pFAhbTt3LJsUCuuAQQg
         ew8suHrfpyUtTe2tJerXkdg7RT9hObXtf/e3c09gCBP9i6dVxdW2Z5Yndo7g2/SC2T7y
         5ctZ04T18SJG8+Hm+wsd05YsiPfYI1J+OWA+8lz0Djlz8qm0TFhpD3RsB/a2xAaFiunQ
         8z/yWOqJgekRLNA7Ly24tPuRd/Q4npawkHW/+ehUKKUADKf4tszsJYGZSZJrztPrh82d
         jb4A==
X-Gm-Message-State: AOJu0Yyee1796VuMYijNFRYsKkHV1/b6I1/q2fxdm4PppLvy+Iulx3xN
        5LATZ4DfpjjS7gFKlzeuv4D3SxLVzF2w4Q==
X-Google-Smtp-Source: AGHT+IHt+ZPML0Yxl9x1Ng81V1LXc5mySv+h7TqdZQJ0BlnFIqTdo1gD3bKL+BqMQHAYuLhC6fFO/g==
X-Received: by 2002:a05:6a21:9815:b0:187:6fb0:85c0 with SMTP id ue21-20020a056a21981500b001876fb085c0mr1963289pzb.23.1700076826700;
        Wed, 15 Nov 2023 11:33:46 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:56f1:2160:3a2a:2645])
        by smtp.gmail.com with ESMTPSA id f10-20020a056a001aca00b006bdd1ce6915sm3127642pfv.193.2023.11.15.11.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 11:33:46 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH] scsi: core: Add a precondition check in scsi_eh_scmd_add()
Date:   Wed, 15 Nov 2023 11:33:43 -0800
Message-ID: <20231115193343.2262013-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Calling scsi_eh_scmd_add() may cause the error handler never to be woken
up because this may result in shost->host_failed to become larger than
scsi_host_busy(shost). Hence complain if scsi_eh_scmd_add() is called
after SCMD_STATE_INFLIGHT has been cleared.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d7f2d90719fd..0734b3f30ef5 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -290,6 +290,7 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
 	int ret;
 
 	WARN_ON_ONCE(!shost->ehandler);
+	WARN_ON_ONCE(!test_bit(SCMD_STATE_INFLIGHT, &scmd->state));
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_RECOVERY)) {
