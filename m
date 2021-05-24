Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDCB9C47083
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B17CA6115C
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhEXDME (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:12:04 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:34763 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232328AbhEXDMB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:12:01 -0400
Received: by mail-pg1-f173.google.com with SMTP id l70so19064694pga.1
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:10:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G7u7yOIHrMaairO+Op3MCSa1DYBCAhMTLm0X2oUr+iM=;
        b=dGv9Gcy/+JeBlSN0aDntrwH1oI3bMuYCHNCZBRmHWrCJrWXUi13Ycgy54XVnvA98a9
         npfXrLHrQ4sZiBBVclFFa4WbZqTIkFo4XFJ1SKpwGX26UCHpNWXRnkwAdK3eKsoWM9Cj
         lMgERR1XbpdjybxsujtLFJ0gj3w4RztwchaKXHCA/AgHaFy1TEtq+EfPgA8cJ9Hm+tsN
         4Zrwo1PJDTgbIJQ17qGnZWq4cB8t8aQ5hv0TH4omhujXVhtcbW0t6XkMQCdmnl1GfgVD
         YWVY9PH1t/Z5ZVb8GdQ7LFUvS0Mey0OznUXz5VSSwY94457z0VlzYS4O8eA2ANUx/lvJ
         aCAQ==
X-Gm-Message-State: AOAM530CZpGVfXNVmlivIS1pHofqp5tOjq4yBQMCi6rdMpm6Q7ESRVIf
        obiB9VAKWVNJq+h0PSCdiwQ=
X-Google-Smtp-Source: ABdhPJxYx9e9GblOinJg/kJKA3K47hWviHky34XJfr8XYXf+U4TnGacQC4eEvXiJauwEqpSjqs7qrQ==
X-Received: by 2002:aa7:8a1a:0:b029:2d4:a24:8967 with SMTP id m26-20020aa78a1a0000b02902d40a248967mr22422310pfa.11.1621825833166;
        Sun, 23 May 2021 20:10:33 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:10:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 51/51] core: Remove the request member from struct scsi_cmnd
Date:   Sun, 23 May 2021 20:08:56 -0700
Message-Id: <20210524030856.2824-52-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since all scsi_cmnd.request users are gone, remove the request pointer
from struct scsi_cmnd.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 1 -
 drivers/scsi/scsi_lib.c   | 1 -
 include/scsi/scsi_cmnd.h  | 3 ---
 3 files changed, 5 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 5af6d87e83aa..3c83e892284b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2390,7 +2390,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 
 	scmd = (struct scsi_cmnd *)(rq + 1);
 	scsi_init_command(dev, scmd);
-	scmd->request = rq;
 	scmd->cmnd = scsi_req(rq)->cmd;
 
 	scmd->scsi_done		= scsi_reset_provider_done_command;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2e9598c91cee..b5df3f94156e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1536,7 +1536,6 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 
 	scsi_init_command(sdev, cmd);
 
-	cmd->request = req;
 	cmd->tag = req->tag;
 	cmd->prot_op = SCSI_PROT_NORMAL;
 	if (blk_rq_bytes(req))
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index bd7f73f035be..984bfa5deab8 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -111,9 +111,6 @@ struct scsi_cmnd {
 				   reconnects.   Probably == sector
 				   size */
 
-	struct request *request;	/* The command we are
-				   	   working on */
-
 	unsigned char *sense_buffer;
 				/* obtained by REQUEST SENSE when
 				 * CHECK CONDITION is received on original
