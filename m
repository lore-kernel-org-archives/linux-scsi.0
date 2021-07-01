Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B810C11F69
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2400361410
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbhGAVPP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:15:15 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:47004 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbhGAVPP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:15:15 -0400
Received: by mail-pg1-f181.google.com with SMTP id w15so7342741pgk.13
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:12:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oqPM4lNZ6z54UNmi+AdbSSWncdPGPDnM588q5GCDzpw=;
        b=e9f5VxKYjUlyB64D7wgFW0+8ajAUb7y7/pNhARRlvmHyj6NA9pbH89pIgKrFkZk3Du
         nirrru+lXIAU/9ck9xG6nvLlnp2ahdHIkjNEjZ7uSdbFzeiTftHWS7vnaB/siAdB/qyQ
         SCJ01xYy/gAhvsez1ELxP3NZTJ5DiJvfJ3eg7NxBMRWV0RFMGQZB36Er2gag/6rfFbmu
         aluAqmscrIZHvft9VrzaGC6RAm9LEsAiDNo33Q4qEg2wEocIahOdPZmH7+fvbTW3kTUZ
         hYhBIIPK7/ClPETRb7T3opxoe+loOj3vO5yNZndMWaJfPPzLZNUc5ZB7oX5zV0tbDv0h
         oLpA==
X-Gm-Message-State: AOAM532OX/C3DhpcRlwQcy+3y0lhG8+ZL5mOGoiIuqPO+VtOo4dLSSxb
        A2bsv3Z6DLN2y2mnw4OVyIY=
X-Google-Smtp-Source: ABdhPJy0Uu+gI/2keVNCazT7x3fsRkxlVo45fFYO8z+mciR2DneOQtxbszm5Gn2w7+ftqs2l2AKgXg==
X-Received: by 2002:a63:a45:: with SMTP id z5mr1445917pgk.227.1625173963477;
        Thu, 01 Jul 2021 14:12:43 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:12:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Yufen Yu <yuyufen@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 04/21] libsas: Stop clearing host_eh_scheduled from the error handler
Date:   Thu,  1 Jul 2021 14:12:07 -0700
Message-Id: <20210701211224.17070-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701211224.17070-1-bvanassche@acm.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that the caller of sas_scsi_recover_host(), namely scsi_error_handler(),
clears host_eh_scheduled, remove the assignment from sas_scsi_recover_host()
that clears this member variable.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libsas/sas_scsi_host.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 95e4d58ab9d4..ae6c273e743e 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -770,10 +770,8 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 	/* check if any new eh work was scheduled during the last run */
 	spin_lock_irq(&ha->lock);
 	ha->eh_running = false;
-	if (ha->eh_active == 0) {
-		shost->host_eh_scheduled = 0;
+	if (ha->eh_active == 0)
 		retry = false;
-	}
 	spin_unlock_irq(&ha->lock);
 
 	if (retry)
