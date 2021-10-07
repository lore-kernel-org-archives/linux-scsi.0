Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A2DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08C9A61074
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbhJGUdY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:24 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:35334 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242630AbhJGUdN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:13 -0400
Received: by mail-pf1-f177.google.com with SMTP id c29so6329400pfp.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dKE9o/+g4929dyCq2nGwYGFLUetIkYpKTXBeXH0/mTc=;
        b=BkccR8ROhXF0NtLEo1BK3IiNuIuS/R1chAP4RFLT9Oa8Xz5waWHvtgvAEMGaN0q2lP
         rOeuu/zEYImn46PS7HF7yHVxT0fScf7axI0nKdDH/49zSFUvJ93ZWi0QbtX6lIOt0/b/
         GsAPGIe60iZqZ9NOHwTb4hGZ1P0hbEWiT23X0ri+5NlWJJRkc58RmOevxkgi0OmfqceA
         QcERp5IJ2DgpEnO7IyHnemzlpiqPEpR5wMdtMxkhJcODlNBOXVC5ZC0kOzBiIRo1JA2n
         Tyip1jv/jowoLlaEjkJHE0BV6spF16eCRwGOklD5WPbspEvvvHgNkEt8apxR0feo1LkU
         hj9Q==
X-Gm-Message-State: AOAM531BfROQvcB1LMw42hbymJhRtJkjM+GFr+pYrAXENI1zDGxfVN/q
        VMPtnOjhhaHxHkfvpJYXdybdRZIGKSA=
X-Google-Smtp-Source: ABdhPJwIFNT5ms3mHpetddof4sUxT7Evl/CL8tsGQaNZvbxr1BZQh9aT844o5/6aL8/ILZNf9wCdBQ==
X-Received: by 2002:a62:5215:0:b0:44c:d170:ed7b with SMTP id g21-20020a625215000000b0044cd170ed7bmr2286284pfb.61.1633638678870;
        Thu, 07 Oct 2021 13:31:18 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Geoff Levand <geoff@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v3 62/88] ps3rom: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:57 -0700
Message-Id: <20211007202923.2174984-63-bvanassche@acm.org>
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
 drivers/scsi/ps3rom.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index 0f4b99d92f12..08e970300b3f 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -209,7 +209,6 @@ static int ps3rom_queuecommand_lck(struct scsi_cmnd *cmd,
 	int res;
 
 	priv->curr_cmd = cmd;
-	cmd->scsi_done = done;
 
 	opcode = cmd->cmnd[0];
 	/*
@@ -237,7 +236,7 @@ static int ps3rom_queuecommand_lck(struct scsi_cmnd *cmd,
 		scsi_build_sense(cmd, 0, ILLEGAL_REQUEST, 0, 0);
 		cmd->result = res;
 		priv->curr_cmd = NULL;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 	}
 
 	return 0;
@@ -321,7 +320,7 @@ static irqreturn_t ps3rom_interrupt(int irq, void *data)
 
 done:
 	priv->curr_cmd = NULL;
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 	return IRQ_HANDLED;
 }
 
