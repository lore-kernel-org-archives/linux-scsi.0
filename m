Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE3FC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7557B61423
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347162AbhI2WJQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:16 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:56031 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347135AbhI2WJL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:11 -0400
Received: by mail-pj1-f48.google.com with SMTP id pg10so2258842pjb.5
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ONXeMNkqe9GTgH43ExyLxPro5i69s8hPd8EyS4Bv+98=;
        b=gznxHQv9YxE6NwHb2smyq6nyNO6bwz7pz0DYQl2uZ/r3x/vN9ZueW3dlaAf3ak2jTw
         odQgWKERIq3dAtpC9zHPeodssgXvjbkZuj9cGxUF6gwhMKuzMxn2haTiOBE9BClEYzZk
         3tzG5bcUVFD+bmphA+CHLgT8MYAAFNLK0Wu5NHTPwbEizsWQ+4L8OJJvNvoNWqg+JbMv
         yYv8AGD4f7tVJCpgEo78TvGPxZtAQ7SJlRYTVX77LkPfsuG1StFDHzbc4q/TLEKqpPWM
         4P3OCojTGn0x1JIzzsCHvpruEW5EPhSrKEYYoNDO32FPJ2wZ1FYrrhBmEyZRYtkehZHM
         HLAQ==
X-Gm-Message-State: AOAM531KLXFJIbhL3p8ieL3TNnZC6qYBHnnXm6Hon2jCJO8HRl5O6LM3
        1meywGD/RLAPGyMa3lkzRXI=
X-Google-Smtp-Source: ABdhPJwAgSIQJTWGgwXyDuLB03OijENHmoMK0z7D9x9Q7tH5nGe9joYQz6VPHp7rG9lsvFVM6rhvnA==
X-Received: by 2002:a17:90a:514b:: with SMTP id k11mr2268051pjm.103.1632953250001;
        Wed, 29 Sep 2021 15:07:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Lee Duncan <lduncanb@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>, Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v2 45/84] libsas: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:21 -0700
Message-Id: <20210929220600.3509089-46-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Reviewed-by: Lee Duncan <lduncanb@suse.com>
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
