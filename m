Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E23CBC4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C57936113B
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242696AbhHETTs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:19:48 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:40851 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233095AbhHETTq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:19:46 -0400
Received: by mail-pj1-f51.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so14097644pji.5
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kyOahvkq1h3DOY3qITSDD5gFbmTjhnTK0RoyJ9/ojBg=;
        b=hM8chBI1olUOhoENsLJdfarP6B5RAhva+rQG/wDGhb0iYUi5+beWSCFacwBOFpVJDw
         6N6Pb06Q6OmGAql+ud3WQ5/DrlpdYqgNLFnh9lVhFWrBf3KeALsmeea/t3xDcDA4QozD
         yicMxvc5BQMYtrgNp+ZdiTZKNtyXIwPWstnlcUDuGUEGPWqz7Buqmfqs39UO1XnYbI5M
         4YKUUEwseWBBoh0G94IUloRuYBhHGest181ScqlSN1pIHKxWNUbFzgarS2c+55sW8j8e
         MgbPQvhUPoZwqlB0Vso9D4ZuumrQ5VzTv96RB/nzLom1+g6RQl38qstMCs+fUpiwMdf0
         P2IA==
X-Gm-Message-State: AOAM533LyN94n9fbajNd5slxtrPPJRr3URhQxWauxYZjRgJPHmtfG+DY
        H7H60H7ngk0fxgAFejRu61M=
X-Google-Smtp-Source: ABdhPJxn/4Q4kVPWfYAABN7zs9XauNi6TobgZJ0pzNFK/+8vdMmCbLSaBNjtglDiFWxZ8CL+WmHlNA==
X-Received: by 2002:a17:902:ab88:b029:12b:d2ee:c26f with SMTP id f8-20020a170902ab88b029012bd2eec26fmr5628938plr.38.1628191171712;
        Thu, 05 Aug 2021 12:19:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        Liu Shixin <liushixin2@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jolly Shah <jollys@google.com>, Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v4 26/52] libsas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:02 -0700
Message-Id: <20210805191828.3559897-27-bvanassche@acm.org>
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
 drivers/scsi/libsas/sas_ata.c       | 2 +-
 drivers/scsi/libsas/sas_scsi_host.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 1e0df6b17227..a315715b3622 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -596,7 +596,7 @@ void sas_ata_task_abort(struct sas_task *task)
 
 	/* Bounce SCSI-initiated commands to the SCSI EH */
 	if (qc->scsicmd) {
-		blk_abort_request(qc->scsicmd->request);
+		blk_abort_request(scsi_cmd_to_rq(qc->scsicmd));
 		return;
 	}
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 5db10248f187..08ffb8788290 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -908,7 +908,7 @@ void sas_task_abort(struct sas_task *task)
 	if (dev_is_sata(task->dev))
 		sas_ata_task_abort(task);
 	else
-		blk_abort_request(sc->request);
+		blk_abort_request(scsi_cmd_to_rq(sc));
 }
 
 int sas_slave_alloc(struct scsi_device *sdev)
