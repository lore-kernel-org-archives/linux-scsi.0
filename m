Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB9DC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07A97611CE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351312AbhERRvq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:51:46 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:36437 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351306AbhERRvo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:51:44 -0400
Received: by mail-pl1-f172.google.com with SMTP id a11so5532323plh.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:50:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kV5vH/2k+9lAn7dKl0YEjewBuVTafj5BJ9f1mVS5sYY=;
        b=LTGUaqWYx4SEDlpiUpwIuNDCcqs+MP2vmPnBGgak+xFxIg92I4fOqnxoqbmjVKaAOI
         SZpJ5KgaDr2r7NAX0zGNjrHBlVjjSc2XqkPXJ1+L5jIodSR+6WDIdhpK02HbH/JnCdkq
         4TFSyejLcijzgZNVm/4KFXv/I422YacQjLj0u+tyFzL/yXQYaz7CriDK/bGCKmHRrpX8
         +2V4xcjr/LucyWV6xgTR/EWqG+B0l+jng8LhN2umnFPlzIqlvHQgU5qSDmwzUPjo0DsC
         DVQ7NE93OnvDFla5izeJ9stkaupU9a+nTSpueLRLkrMKqEvQAo8afaKaDB3jzgPbFLik
         uG8Q==
X-Gm-Message-State: AOAM532I4F//q8oFzn26DDmn7kL41pMo4DX5stF8boKR71IXY/y3oqph
        SVdPKkbPth6+tF1zkDLyr1A=
X-Google-Smtp-Source: ABdhPJw8lPdgvMHSheksvaCw9YScXPLlROH6k4Dc6yYX73jsGVhZUTWpoGIZVFENecLLCC4ZQ9JONQ==
X-Received: by 2002:a17:90a:c42:: with SMTP id u2mr6573275pje.76.1621360226242;
        Tue, 18 May 2021 10:50:26 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id a2sm613762pfv.156.2021.05.18.10.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:50:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 3/3] Change the type of the second argument of scsi_host_complete_all_commands()
Date:   Tue, 18 May 2021 10:50:06 -0700
Message-Id: <20210518175006.21308-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518175006.21308-1-bvanassche@acm.org>
References: <20210518175006.21308-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow the compiler to verify the type of the second argument passed to
scsi_host_complete_all_commands().

Cc: Hannes Reinecke <hare@suse.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c     | 8 +++++---
 include/scsi/scsi_host.h | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index ba72bd4202a2..145e5672397a 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -652,10 +652,11 @@ EXPORT_SYMBOL_GPL(scsi_flush_work);
 static bool complete_all_cmds_iter(struct request *rq, void *data, bool rsvd)
 {
 	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
-	int status = *(int *)data;
+	enum scsi_host_status status = *(enum scsi_host_status *)data;
 
 	scsi_dma_unmap(scmd);
-	scmd->result = status << 16;
+	scmd->result = 0;
+	set_host_byte(scmd, status);
 	scmd->scsi_done(scmd);
 	return true;
 }
@@ -670,7 +671,8 @@ static bool complete_all_cmds_iter(struct request *rq, void *data, bool rsvd)
  * caller to ensure that concurrent I/O submission and/or
  * completion is stopped when calling this function.
  */
-void scsi_host_complete_all_commands(struct Scsi_Host *shost, int status)
+void scsi_host_complete_all_commands(struct Scsi_Host *shost,
+				     enum scsi_host_status status)
 {
 	blk_mq_tagset_busy_iter(&shost->tag_set, complete_all_cmds_iter,
 				&status);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index d0bf88d77f02..75363707b73f 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -764,7 +764,7 @@ extern void scsi_host_put(struct Scsi_Host *t);
 extern struct Scsi_Host *scsi_host_lookup(unsigned short);
 extern const char *scsi_host_state_name(enum scsi_host_state);
 extern void scsi_host_complete_all_commands(struct Scsi_Host *shost,
-					    int status);
+					    enum scsi_host_status status);
 
 static inline int __must_check scsi_add_host(struct Scsi_Host *host,
 					     struct device *dev)
