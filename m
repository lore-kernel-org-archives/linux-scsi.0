Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A649C11F6A
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 305CC61410
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbhGAVPH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:15:07 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:46746 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbhGAVPG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:15:06 -0400
Received: by mail-pf1-f179.google.com with SMTP id x16so7053498pfa.13
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:12:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=caE3JCMw0qHxX8kc6TJlEycE7r7gX0Ula91LI/ec5ns=;
        b=R6ZnsFAaIF6/6a2RicFIeUcgIBCdeFL7sH4npPyz6tJUWCwdGkze3V9SoVUxNhAA0H
         vFeu+o9oVO0uVZ4sYIqRgl0j3lMmwZ8vGfQH7Km8enWY/uvMDqLVfLoNCvNLPCDwV3A/
         VlyMyzf41DtHaSL4m/yA+tPb/EFVHvgGHDq0m/xvM2lBuX472/Q9XNNZMv75TbeERgEj
         zt8eHZEIyvJgEoPfrV6luQg6V47Lf5bH04m98g3ueNTnO1bda9wiQ5l9Bx3ppJkUj3Gt
         Je/jzbiitB9t0K3QUl+SLW/WMn0aUMJnWLJuXWNXoj9Igus9IcMqECXhpoP4LKK4UVah
         asWg==
X-Gm-Message-State: AOAM530keobBUSdRPMdU5BmUTelc7nl5hyrnUZpVJd5iabZexaheXqko
        44NnEzn0PdvYoUCsA2GvDbw=
X-Google-Smtp-Source: ABdhPJxhcZnofVEkXEpHSnsX3WoUg8SW28nvtfb96OPzXSwwotU1uRMHRdwtzlXWqibXIv/yTGQuTg==
X-Received: by 2002:aa7:989c:0:b029:30a:13ef:2bbd with SMTP id r28-20020aa7989c0000b029030a13ef2bbdmr1691781pfl.20.1625173954857;
        Thu, 01 Jul 2021 14:12:34 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:12:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 01/21] Fix the documentation of the scsi_execute() time parameter
Date:   Thu,  1 Jul 2021 14:12:04 -0700
Message-Id: <20210701211224.17070-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701211224.17070-1-bvanassche@acm.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The unit of the scsi_execute() timeout parameter is 1/HZ seconds instead of
one second, just like the timeouts used in the block layer. Fix the
documentation header above the definition of the scsi_execute() macro.

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Fixes: "[SCSI] use scatter lists for all block pc requests and simplify hw handlers" # v2.6.16.28
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7184f93dfe15..4b56e06faa5e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -194,7 +194,7 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
  * @bufflen:	len of buffer
  * @sense:	optional sense buffer
  * @sshdr:	optional decoded sense header
- * @timeout:	request timeout in seconds
+ * @timeout:	request timeout in HZ
  * @retries:	number of times to retry request
  * @flags:	flags for ->cmd_flags
  * @rq_flags:	flags for ->rq_flags
