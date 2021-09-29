Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6709AC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F3EE61423
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347076AbhI2WIM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:12 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:45011 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347064AbhI2WII (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:08 -0400
Received: by mail-pg1-f181.google.com with SMTP id s11so4127557pgr.11
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Zvejwbxr0RoImsBn1iUhSjlzaoSFnI22+3R9qJ6IfA=;
        b=Fko3SEsOv5lNey0XgM+bjk4Pd69CqBsX0O2ebOxNV1+UAJkuhFw+kxZXW+KPjjfmbr
         cWx1tEy3LH+cC/tYzzg3Vcu4hSb3vyBhFSYZ43GUh33B0AvscM8JfZYb/NQ9OMB4Gkha
         OH/Axmb2f9OajF+ffiNKxAoO74SI0NRK5DheK98XenvA2RIPIoIx7Lj+co2CB8Z0Stf1
         4e9gelxad0ChtmKkK1bE2iZn3k7LkHoV7f3GM0gq1ilzAVJYAvJ6DYNumd9XgCVI8V5x
         XfaPyFuP22QOdc22+RLyzoI8dZzohzCsK73t4zKsj6DUVXPwGG5LeSym+ZQtDSdf1uuK
         dAcg==
X-Gm-Message-State: AOAM533dfQb5UGFIRTT4kn7fE6bwG/KFdVL25+tNseRhXHfHNndE5nFB
        i2s0XOvBM4K7lYQGoJOupSM=
X-Google-Smtp-Source: ABdhPJyiX+B7W3lU5MGG6rVd4outdabN3m+Hu8pPAs69PG2sZTiszZr+YBRK4fLtpjaHw4DcWfNJxA==
X-Received: by 2002:a62:5b45:0:b0:44b:e0f2:4fba with SMTP id p66-20020a625b45000000b0044be0f24fbamr787318pfb.54.1632953186588;
        Wed, 29 Sep 2021 15:06:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v2 07/84] zfcp_scsi: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:43 -0700
Message-Id: <20210929220600.3509089-8-bvanassche@acm.org>
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

Acked-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/s390/scsi/zfcp_fsf.c  | 2 +-
 drivers/s390/scsi/zfcp_scsi.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index c1f979296c1a..4f1e4385ce58 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2501,7 +2501,7 @@ static void zfcp_fsf_fcp_cmnd_handler(struct zfcp_fsf_req *req)
 	zfcp_dbf_scsi_result(scpnt, req);
 
 	scpnt->host_scribble = NULL;
-	(scpnt->scsi_done) (scpnt);
+	scsi_done(scpnt);
 	/*
 	 * We must hold this lock until scsi_done has been called.
 	 * Otherwise we may call scsi_done after abort regarding this
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 9da9b2b2a580..e0a6d8c1f198 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -60,7 +60,7 @@ static void zfcp_scsi_command_fail(struct scsi_cmnd *scpnt, int result)
 {
 	set_host_byte(scpnt, result);
 	zfcp_dbf_scsi_fail_send(scpnt);
-	scpnt->scsi_done(scpnt);
+	scsi_done(scpnt);
 }
 
 static
@@ -78,7 +78,7 @@ int zfcp_scsi_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scpnt)
 	if (unlikely(scsi_result)) {
 		scpnt->result = scsi_result;
 		zfcp_dbf_scsi_fail_send(scpnt);
-		scpnt->scsi_done(scpnt);
+		scsi_done(scpnt);
 		return 0;
 	}
 
