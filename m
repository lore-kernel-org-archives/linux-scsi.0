Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708DEC4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5083760BD3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242618AbhHETUC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:02 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:55152 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242867AbhHETUB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:20:01 -0400
Received: by mail-pj1-f53.google.com with SMTP id a8so11291291pjk.4
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y4ZY0he3Ub7V9kWp/mfBG6tcfkSMEe3662viUpbU8Pk=;
        b=iqDBmbgsNbfj2RY5K0ZKXdkXgRwJzHtadvC+4Sy0XLYzvY2uJnv+0lHM2StOAzUKXi
         eTw7gKh1palWQ4Bg4BiZCl+a8TKH4mZ4NEMpVr1YH974EeaXFNNQh1EI65RXTDyzXWUg
         ippSBur5Ek5klswTx6W9Swr9y64GUHZNMrouaEWOcVVR0PiRjNR/5Hqtwk8wTr+dgEHK
         kYUcJ5N32r9Jad26hu6KJA3CB7mqrg57SGeo0xTiGiiSRS3jbTwOvlbjPE56l42yULdl
         0w5iSXbJdD3SziOtKasOM+qrFhE+chiQqqcI7F2MsIaInAYqGyQuvRa1WyuxpRA0XnGz
         o3rw==
X-Gm-Message-State: AOAM5325tKoOIevQq8XBUq0B8nSFeSqZeyv2m+8Ekp+0cKK8X4zoILL2
        UeYa13AXJU/8PrZpdbkePOU=
X-Google-Smtp-Source: ABdhPJxSNwMm1Ht3SYE1oP8Mx4BnhkZlJyhJ64QVj4wE/uV0ygi6Hwe4MykddyHFD+AFqCPiwqR9vg==
X-Received: by 2002:a63:5815:: with SMTP id m21mr519196pgb.363.1628191186877;
        Thu, 05 Aug 2021 12:19:46 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 36/52] qedi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:12 -0700
Message-Id: <20210805191828.3559897-37-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qedi/qedi_fw.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 71333d3c5c86..ac99e980bb31 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -609,14 +609,7 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
 		goto error;
 	}
 
-	if (!sc_cmd->request) {
-		QEDI_WARN(&qedi->dbg_ctx,
-			  "sc_cmd->request is NULL, sc_cmd=%p.\n",
-			  sc_cmd);
-		goto error;
-	}
-
-	if (!sc_cmd->request->q) {
+	if (!scsi_cmd_to_rq(sc_cmd)->q) {
 		QEDI_WARN(&qedi->dbg_ctx,
 			  "request->q is NULL so request is not valid, sc_cmd=%p.\n",
 			  sc_cmd);
