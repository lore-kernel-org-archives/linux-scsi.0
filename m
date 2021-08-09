Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C10CC4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5247361002
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbhHIXFK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:10 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:35351 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237008AbhHIXFG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:06 -0400
Received: by mail-pj1-f43.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so1520625pjs.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g+0Ck8dy5TPeVAkD586vBi6F/1plVC6dlDMEyM3vKjA=;
        b=jdbzhnKx2OKdLPWXM+uAYZdcRBcAKPwPGIT0zEdriSgT+3CNjQ13tXOhscNp+cH/iu
         axW3tmkWBC/PhclQx9brUjGzJ6r1eAEm+TgR2/2yQStiY6HRbovUfHGUFpw0N1IPTJBo
         kaWoqpOLYi86i1KEhOgTxtVtkd9LG6Xq/O0F3WrYvQO54V33i+TbRQLJ0mpup+rsTAzH
         xR8u3nIdbXQZ3nROWXmOQk1G/J3hRKl9RZqgKGBfLgYelmLB0HSy7GxgWmp/jVUEAHbP
         hZDAd1RnIGFnguqbpIH2oD1/mzWwuZ1rwCZDtarBXUjFd2tLSj/uhMcqtplZ4YBGxLoE
         2oOw==
X-Gm-Message-State: AOAM530aOXvZvtLsoT0Vg3TIvbIwsnKK4Wf/FgZF1AlJOvn2sYX32aHx
        Fjss3qznmZAgq+n9Z5abv00=
X-Google-Smtp-Source: ABdhPJzc4E79KopLx8C1t9mmuRlRGSB4zKvjcI1zq70KVO1WFDZhqxbWyLI9eV9Qw3TCuDCfJ2LwEw==
X-Received: by 2002:a63:cd4d:: with SMTP id a13mr85419pgj.364.1628550284824;
        Mon, 09 Aug 2021 16:04:44 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        Liu Shixin <liushixin2@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jolly Shah <jollys@google.com>, Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v5 26/52] libsas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:29 -0700
Message-Id: <20210809230355.8186-27-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Reviewed-by: John Garry <john.garry@huawei.com>
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
