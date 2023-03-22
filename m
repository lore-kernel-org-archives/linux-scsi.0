Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1704C76196
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjCVT5A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjCVT4n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:56:43 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36B15B5CF
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:35 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id o2so12884365plg.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679514995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H9QNk6q17I8CdJSB5JsrnuqP/ZBn9pNyTOjnOStZX4E=;
        b=OkSZBPv3L5XE+QtJE7aVzsGlFa0KM5SDl6KJAKfhLhxfGy4gA7ufaGXeuWLPzX40vz
         9jMiS1ZaH+SntJqdc+6bG0b/QS74pCvtdc6ftA0Pum6TQMaRBgwasoIkA9QJFwy4OnYg
         RE3zl3wVoRIhkWeg+4viR4Pga/oTnQtx3ioFOc2q6HxOEEH8M7Iev239jtP+gkDaBFro
         rYO7wpd8wGlU0kTKmydXOfvhN4ZGHlN4KE0IRHyOpFGHpSpfYgpeSQKt1KG0DFA1gKN9
         E7pa2UserpeSPR9OL1fsoMI44E+jR1BaKXaEBbFw98W4GwM2jIOPhcUBXkIzonw8ESc1
         AGwA==
X-Gm-Message-State: AO0yUKWWJAj7XJLc+ZLKs/jGiWEhcCG+JyESRcDHV7B+xydApHWF1480
        3ZV3nkfYmTDHd/beyTwAIRg=
X-Google-Smtp-Source: AK7set/SxTj9zihr+Mu1q7hG62qnY/tprk3ivF2U3ZV/Z0W9eb2d07Imkr6QhKcU+NP6nbimDN+YvA==
X-Received: by 2002:a17:90b:1d8c:b0:237:b4c0:e15b with SMTP id pf12-20020a17090b1d8c00b00237b4c0e15bmr4938606pjb.44.1679514995473;
        Wed, 22 Mar 2023 12:56:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:56:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 13/80] scsi: a100u2w: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:08 -0700
Message-Id: <20230322195515.1267197-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/a100u2w.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index d02eb5b213d0..b95147fb18b0 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1065,7 +1065,7 @@ static irqreturn_t inia100_intr(int irqno, void *devid)
 	return res;
 }
 
-static struct scsi_host_template inia100_template = {
+static const struct scsi_host_template inia100_template = {
 	.proc_name		= "inia100",
 	.name			= inia100_REVID,
 	.queuecommand		= inia100_queue,
