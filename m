Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D17C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C7706115C
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhEXDLT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:19 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:45737 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbhEXDLS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:18 -0400
Received: by mail-pf1-f176.google.com with SMTP id d16so19662832pfn.12
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YTQf18PY057XfTxxTl3s/jAPWP9llmvWNhQ3KG2h6kk=;
        b=DM3ti+/IgUI6DJWapE85nAeovJUf0DWPg5CVvhR5rzuyS/1mXMpIftK9+uEr3VWobs
         BtkfWxhH9Alij00xW+Awg8N9mR3gvC5mEh69QpzKL3EG5abtHZBRsVZHMJA9yAH68EIa
         Lszv1RG82uhF/an+egdfo6/rSoQCmUvXTkM4ZzGNny/t8jlFvDx5Ih3hrCFF2LcW9P2Y
         ZBNl+JL1PpvnzSsGm/3XnYyeGiv7SaaSykbic7Y7fOzzJOp5v747nzW9qKDJvNW8HNZx
         KGjRgG3Eia2GGLZG9MIbuQ4PtT24pPqltKSWCblTVDGVwgJxnsSbIIYmHz/B7Sj5o98d
         MowA==
X-Gm-Message-State: AOAM532oo4mxMk50PcIwLB3sBl0HuwZrJlharVVcE0J3gZ2uznMS5UT1
        K3iL+0WvokeUhoOC/k76rdw=
X-Google-Smtp-Source: ABdhPJx9XjiHHuob8PeF7L65KPbi/Z8r6waLWTBJPtwOhQnUMI+uhcYsDDmUS+IgRX19asdhnW/Raw==
X-Received: by 2002:a05:6a00:1a8b:b029:28e:7b62:5118 with SMTP id e11-20020a056a001a8bb029028e7b625118mr22167203pfv.49.1621825789872;
        Sun, 23 May 2021 20:09:49 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:49 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jolly Shah <jollys@google.com>,
        Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH v3 26/51] libsas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:31 -0700
Message-Id: <20210524030856.2824-27-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Tested-by: John Garry <john.garry@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libsas/sas_ata.c       | 2 +-
 drivers/scsi/libsas/sas_scsi_host.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index e9a86128f1f1..d007a5714923 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -595,7 +595,7 @@ void sas_ata_task_abort(struct sas_task *task)
 
 	/* Bounce SCSI-initiated commands to the SCSI EH */
 	if (qc->scsicmd) {
-		blk_abort_request(qc->scsicmd->request);
+		blk_abort_request(scsi_cmd_to_rq(qc->scsicmd));
 		return;
 	}
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 1bf939818c98..b6cd9d87fbd0 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -908,7 +908,7 @@ void sas_task_abort(struct sas_task *task)
 	if (dev_is_sata(task->dev))
 		sas_ata_task_abort(task);
 	else
-		blk_abort_request(sc->request);
+		blk_abort_request(scsi_cmd_to_rq(sc));
 }
 
 void sas_target_destroy(struct scsi_target *starget)
