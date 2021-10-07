Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F66C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DA1660F4A
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhJGUdg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:36 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:36674 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbhJGUdV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:21 -0400
Received: by mail-pf1-f175.google.com with SMTP id m26so6326930pff.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=urS2XjYsdGd+sO9di0sTi7CmC+0ofkzpdFIqCfBC0cc=;
        b=uOX0q2b3Jop57WStDcfg8hlHzx9zjbcaPqoYn7/OtzzcJ0MYAMJF0Tf65NZhkJoSE8
         0ZLQw8nlIuxdf7KO5/jiQQQvW4HbWY1lyxPHW8bTj4aKQqxyFYQLaexaOCEm5xus5DVa
         5o8HdPgttZ3ZZEiOTyVShRb6g2S0R2P6pwzemBOeKKkATkosMQhoKE/lDN394FFl20Ai
         ghSKmtzPQPOxl0VtHfTdP5LwcoLqcq5bJnSkN8g9p6iy1w+aSRg6xJtXzuPWPmKe0YMM
         BPGjWej71H8m7igHxJm7MdMrZmRrV5CQdcc/KL6sdu8FGpYrmCgXX3VTVvEMLYwqnEfz
         jqNg==
X-Gm-Message-State: AOAM53062pWBCfTNMmQrGFWt1Z0iMy64Qv93ScKjrjX6R7yHELh96Fn3
        MFzutEri8X1Ku1XXYV6JoD8=
X-Google-Smtp-Source: ABdhPJwUDUw25sSe+kXhXSpwNTaeQC17dp35KYn6Q7cbmHoyDNtM06vGrbaJ8hrycnt4Pnqb73DUPw==
X-Received: by 2002:a63:cc49:: with SMTP id q9mr1350166pgi.463.1633638687386;
        Thu, 07 Oct 2021 13:31:27 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 68/88] qlogicpti: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:29:03 -0700
Message-Id: <20211007202923.2174984-69-bvanassche@acm.org>
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
 drivers/scsi/qlogicpti.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 8e7e833a36cc..30b5e98b5de0 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1021,8 +1021,6 @@ static int qlogicpti_queuecommand_lck(struct scsi_cmnd *Cmnd, void (*done)(struc
 	u_int out_ptr;
 	int in_ptr;
 
-	Cmnd->scsi_done = done;
-
 	in_ptr = qpti->req_in_ptr;
 	cmd = (struct Command_Entry *) &qpti->req_cpu[in_ptr];
 	out_ptr = sbus_readw(qpti->qregs + MBOX4);
@@ -1214,7 +1212,7 @@ static irqreturn_t qpti_intr(int irq, void *dev_id)
 			struct scsi_cmnd *next;
 
 			next = (struct scsi_cmnd *) dq->host_scribble;
-			dq->scsi_done(dq);
+			scsi_done(dq);
 			dq = next;
 		} while (dq != NULL);
 	}
