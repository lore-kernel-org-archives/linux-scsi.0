Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E61BC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7518F61074
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242429AbhJGUct (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:49 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:37814 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbhJGUcp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:45 -0400
Received: by mail-pj1-f53.google.com with SMTP id oa6-20020a17090b1bc600b0019ffc4b9c51so7767700pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CdxnOeKQUGghUW2BbV8JYduqTuwcB5YkDQE7oaEaTsc=;
        b=Fk/BvUK8NJWDhFmQmZ7DGQ+OE57vd4B2Gv8I0Rr0iVy1UL4vEkxxEc2awYY6Ga44Jg
         dzgwRPEB3NUyU0tMi65oHJYz+55kgJT/YCvptuTHTgnx5B799dm2mtubdqCXEgHHlEnM
         cT+tT1K9X3+SKuGPHWJvJZ780YWOF1YsCbn/UZi/WpKFnLlJLXzcVS+B2t0Kt6xLhDxr
         Rhm+mR9tfhl+efU23YUltwFXVdMwxtZajwwisL+qMBm9647BtILsUdLnTFlcxt9nDekR
         /OV8on/kiRLxgcTInXx/oubWG61Kbc9ZOYKcGzsbuSUbqUL19h6eqb31t1hgZ/kgyItD
         aBgg==
X-Gm-Message-State: AOAM530ZbIqU5RPno/RXdI5bSK4qHkq3IA1pyq7Q6j5scJzFo3wuxOuj
        DxgSYbdycvztD1yBmR+mcWQ=
X-Google-Smtp-Source: ABdhPJx1ajN23faOgg3ilovolejeXcfuqxtRQT6tktns48n9TvtUIu9pMo8BErU1Vm6HgvYm5bDO1w==
X-Received: by 2002:a17:90a:4207:: with SMTP id o7mr7156311pjg.192.1633638651707;
        Thu, 07 Oct 2021 13:30:51 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jason Yan <yanaijie@huawei.com>, Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v3 45/88] libsas: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:40 -0700
Message-Id: <20211007202923.2174984-46-bvanassche@acm.org>
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

Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libsas/sas_scsi_host.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 2bf37151623e..d337fdf1b9ca 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -125,7 +125,7 @@ static void sas_scsi_task_done(struct sas_task *task)
 	}
 
 	sas_end_task(sc, task);
-	sc->scsi_done(sc);
+	scsi_done(sc);
 }
 
 static struct sas_task *sas_create_task(struct scsi_cmnd *cmd,
@@ -198,7 +198,7 @@ int sas_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	else
 		cmd->result = DID_ERROR << 16;
 out_done:
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(sas_queuecommand);
