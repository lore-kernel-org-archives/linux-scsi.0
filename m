Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1CDCC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 23:23:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96AEC61264
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 23:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbhENXYc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 19:24:32 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:38805 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbhENXYc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 19:24:32 -0400
Received: by mail-pl1-f171.google.com with SMTP id 69so158750plc.5
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 16:23:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7oNfiC+U3jD5xLuFSaadzHbqdpF0G3gUfnWmCF3qVi4=;
        b=p9Z3eqam2Iz3GDyNvbSwU+DYZBuFK7hkHLWcPmx7BcopM5bdzuy+y+BZgt7AHnUMCO
         dKqImu959Yk6BIL/XWAYDBa2xyfCecRptIth5L4SAFMGepupZxqk8tYmjoEnoBih/JYs
         +bmebTGnRzqLmyVLNzNQrtbeSHN/2zRCsXxvPBRj0MWlhgJky0c5ROzfRPBSEP0LUIZE
         HK2L2ufJcBHcvmGGlx8nXK5YcvA/PunmczuqAAFXGj3co3TzWQ0264m5iwe0vHtI3267
         43zXsi5NDIBy36dw2CxEFYDvKMvUR0NlEOYA7NddpajE8ogSoM9Db7YGCFpRem4T97Do
         OFXA==
X-Gm-Message-State: AOAM5338+H7xA7dY2uHpn26ouhKogln5xqTfpGFI4IlCXzmw2/+HX5Io
        cs5unZUw2MCHgt21RoGpDeI=
X-Google-Smtp-Source: ABdhPJw1QWUrAIxiQFOFc1GqIG+WyjT0pBu6PJjNG5inhjqeuFcvdX2srE3PJ9dtqAslx5/HyfBphg==
X-Received: by 2002:a17:90a:17c5:: with SMTP id q63mr40472660pja.136.1621034600117;
        Fri, 14 May 2021 16:23:20 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id a7sm4623106pfo.211.2021.05.14.16.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 16:23:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 3/3] Change the type of the second argument of scsi_host_complete_all_commands()
Date:   Fri, 14 May 2021 16:23:08 -0700
Message-Id: <20210514232308.7826-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514232308.7826-1-bvanassche@acm.org>
References: <20210514232308.7826-1-bvanassche@acm.org>
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
index 697c09ef259b..81b9e607b215 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -652,10 +652,11 @@ EXPORT_SYMBOL_GPL(scsi_flush_work);
 static bool complete_all_cmds_iter(struct request *rq, void *data, bool rsvd)
 {
 	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
-	int status = *(int *)data;
+	enum host_status status = *(enum host_status *)data;
 
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
+				     enum host_status status)
 {
 	blk_mq_tagset_busy_iter(&shost->tag_set, complete_all_cmds_iter,
 				&status);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index d0bf88d77f02..31b5c0db4657 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -764,7 +764,7 @@ extern void scsi_host_put(struct Scsi_Host *t);
 extern struct Scsi_Host *scsi_host_lookup(unsigned short);
 extern const char *scsi_host_state_name(enum scsi_host_state);
 extern void scsi_host_complete_all_commands(struct Scsi_Host *shost,
-					    int status);
+					    enum host_status status);
 
 static inline int __must_check scsi_add_host(struct Scsi_Host *host,
 					     struct device *dev)
