Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4489CC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 294F861454
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbhENVgE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:04 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:40563 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbhENVgD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:03 -0400
Received: by mail-pj1-f49.google.com with SMTP id b9-20020a17090a9909b029015cf9effaeaso2319519pjp.5
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YjbCN+/ijmvuqqPceQBK4jOlOh9NBJBvK5kjlObAKoI=;
        b=IFiBbzmELjUCYPFlqJuB9JLqjTCmQxxN6fH6DjRDqA+TsKBxASZgYxvedGxHEGmbaC
         8utjnxYM8pbRFjPaITTFYaFzpxgzzFfXMEQKXWlwMVjXKixmb1uu9HbKAnzedRXxcPmr
         +hpoNF1GATdrXccbHWJ0ASENLp037vw5wgHwR/JEl4ewj8HlRquq96qzrlHRpZr/wu6R
         qi7op9U/H5VAWx3xOgYnMbhApctvo2phnY6NalpsEDz8Y5srb2Sf4tr08QzACv3P2evS
         vGKybl91ZkgLH8SO7h01BPlQ1VInmtX2+qO4ps2e/VowvDPcqZPT9ck4DF+8gnA4am5c
         OHAw==
X-Gm-Message-State: AOAM5309csaU5cp8dVg8CQBRkjlZuCjWyIvcfmTMCqw0CRQxnu6NZTnw
        x6YEC7IG62L9k+Oem5d7C4w=
X-Google-Smtp-Source: ABdhPJzHpQx7XPMLGpEX2Kjy7mYppNz82ghckoJTfme596KplHJYjj4vUvvWZoquYJJEJq8RDHyEvw==
X-Received: by 2002:a17:90b:1c05:: with SMTP id oc5mr9735345pjb.38.1621028090603;
        Fri, 14 May 2021 14:34:50 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Jolly Shah <jollys@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 25/50] libsas: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:40 -0700
Message-Id: <20210514213356.5264-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libsas/sas_ata.c       | 2 +-
 drivers/scsi/libsas/sas_scsi_host.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index e9a86128f1f1..6736e69f4062 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -595,7 +595,7 @@ void sas_ata_task_abort(struct sas_task *task)
 
 	/* Bounce SCSI-initiated commands to the SCSI EH */
 	if (qc->scsicmd) {
-		blk_abort_request(qc->scsicmd->request);
+		blk_abort_request(blk_req(qc->scsicmd));
 		return;
 	}
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 1bf939818c98..438f14f7c1a0 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -908,7 +908,7 @@ void sas_task_abort(struct sas_task *task)
 	if (dev_is_sata(task->dev))
 		sas_ata_task_abort(task);
 	else
-		blk_abort_request(sc->request);
+		blk_abort_request(blk_req(sc));
 }
 
 void sas_target_destroy(struct scsi_target *starget)
