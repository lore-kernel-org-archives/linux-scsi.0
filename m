Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9B3C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03EB960F9D
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbhJGUfM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:35:12 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:45869 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242621AbhJGUdL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:11 -0400
Received: by mail-pf1-f178.google.com with SMTP id i65so3352144pfe.12
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zfxVhZCFvk45D3OUj/xVsg8PqFWL9WcofwLGfuG8Jpw=;
        b=uRoTg1kvXN/VRmqn+dJkULWg3fW6KTdcoUu6COpsKtaj9VUImO0Q6WOAmYZfe1qksq
         6rKhdI9juZYHG0ShgNGFugIMPMOMOvfiJmOSRz5JdHrlUIJ/uxkKPQjPu7tnVPqL4Ycu
         fEpIqQeLIaav4H4ny23hfQaalt0FRRZgfTUf4apkDfNgXjoHYJwRT4kYhRV9vtpA3zqt
         a3FKiz0T5dOK7aOp/HYm5V3kM1OhJZ3bKRF67VBzGn+J9nuqhYrksB/nEzf1hnXqoXJH
         oBKaJvDCYu5HcQLpoFq/aIFoOFJ8MXgTlqf0DlZwlea/4XjT7VO681wOWRAey+oq09XY
         71/g==
X-Gm-Message-State: AOAM532wdYBfioz2w4FHfngzB2/rpJX88cO/2FmK87Kz9oWxeOKOK0T6
        Xh4bgHjOFW6JPymSY8BTe+w=
X-Google-Smtp-Source: ABdhPJydY0gzK3cr57nd5/2/o9RooUg5eyagBkUWegI+cSMYA66gPado9Oxc47wppBxfdVQKCw0udg==
X-Received: by 2002:aa7:88cc:0:b0:431:c124:52ba with SMTP id k12-20020aa788cc000000b00431c12452bamr6058160pff.63.1633638677511;
        Thu, 07 Oct 2021 13:31:17 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 61/88] ppa: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:56 -0700
Message-Id: <20211007202923.2174984-62-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ppa.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 977315fdc254..799ad8562e24 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -665,7 +665,7 @@ static void ppa_interrupt(struct work_struct *work)
 
 	dev->cur_cmd = NULL;
 
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 }
 
 static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
@@ -798,7 +798,6 @@ static int ppa_queuecommand_lck(struct scsi_cmnd *cmd,
 	dev->failed = 0;
 	dev->jstart = jiffies;
 	dev->cur_cmd = cmd;
-	cmd->scsi_done = done;
 	cmd->result = DID_ERROR << 16;	/* default return code */
 	cmd->SCp.phase = 0;	/* bus free */
 
