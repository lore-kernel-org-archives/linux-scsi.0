Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E960CC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D098661139
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242426AbhJGUdA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:00 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:36571 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242435AbhJGUc5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:57 -0400
Received: by mail-pj1-f52.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so7824575pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=raghMrXmrq+nxI9vNhRRAV3vPKh2ubpRSJoXmk7pkFQ=;
        b=ErVd701sQtKBL0bB0VI58XvT9dGkZK8dSpr9wOJ83pD4JmY7DnlwAyxooLowSPsoYV
         7ATmsDBKQj5lZPSn7+VanxzwE2j78WjKZVqmie9CXZMyLQLOEyvGHRiDlxjMtjHTtZKw
         JFeTZxjA29GvIxtff5jN0KIY+PKW3ExOTgwMoUPKt2xAww2wvRVeGeO1sgoDnZHI7Xx9
         EU7yiswu5iq9jZ24BGB2A7P73Fxi8/KNf0Mv5ZcmJByyHUQr317pQk3vf9aeL11h77mv
         FQGGGwWKCM3VLsbw/Zfb2OrIoFiT4idnf7qqNUym8jaPYirKUIqBpVRcrxG9HkarAPwO
         5tXg==
X-Gm-Message-State: AOAM533G3p2+43Sn8XKGk7p/aiLL38yFAhjZ7LH3k680zO7qye3f2Bo3
        ESu4DqiUQe8Xzsk460/+Zoc=
X-Google-Smtp-Source: ABdhPJyjzUoapPM2MW+fkDmATWNOiRRmS/uIIlCvuDiJYB1976Ik6khvrfmCdVYbolXb03O++yTtUQ==
X-Received: by 2002:a17:902:a38b:b0:13d:9c41:92ec with SMTP id x11-20020a170902a38b00b0013d9c4192ecmr5950716pla.39.1633638663292;
        Thu, 07 Oct 2021 13:31:03 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 53/88] mvumi: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:48 -0700
Message-Id: <20211007202923.2174984-54-bvanassche@acm.org>
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
 drivers/scsi/mvumi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 4d251bf630a3..904de62c974c 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1328,7 +1328,7 @@ static void mvumi_complete_cmd(struct mvumi_hba *mhba, struct mvumi_cmd *cmd,
 		dma_unmap_sg(&mhba->pdev->dev, scsi_sglist(scmd),
 			     scsi_sg_count(scmd),
 			     scmd->sc_data_direction);
-	cmd->scmd->scsi_done(scmd);
+	scsi_done(scmd);
 	mvumi_return_cmd(mhba, cmd);
 }
 
@@ -2104,7 +2104,7 @@ static int mvumi_queue_command(struct Scsi_Host *shost,
 
 out_return_cmd:
 	mvumi_return_cmd(mhba, cmd);
-	scmd->scsi_done(scmd);
+	scsi_done(scmd);
 	spin_unlock_irqrestore(shost->host_lock, irq_flags);
 	return 0;
 }
