Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCDACC4360C
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD796613C5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhENVgv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:51 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:51090 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233455AbhENVgp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:45 -0400
Received: by mail-pj1-f51.google.com with SMTP id t11so552864pjm.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+u5h4uPf8KfdnguoDucGeAYgNag4EDwJPMJl7vidv4k=;
        b=beFAIeAwABZeHLlkPtF6Ya1M9UtNR2I2y2qJbHuow3QrW24Du195NK+/3EcBr1j5/P
         cFfz60eGhs5hCi0arHmB3EJOOxMoqgCAOp/Bjh4f8oucgEay2IMQapdkZ/JGiFFLJsf4
         Fwotry1pYbXg64qq9k1cwFtoCOFV6zMtr5h1t0092JUimo57W78iQuu4LNVYPCYkMkCH
         Z//CgXLLMf/9soTXQocrsgVeVskASXvqIuPJ/JrMni3H6nrQNKKSAKTojXwts6hZwVkg
         tCXIM87jQueyTcGxlkXxtEy6EGVsTgBAtEqGO7dMBf33NnsGZ+c+SnvsCbPduZIymYIo
         E1sw==
X-Gm-Message-State: AOAM533DCGfbvCX0zE6aDASpl2s6kfyHo7+UmWIjS1/U7TaTrecgVvLE
        IcuFte3NSwDiAWpEUByyotY=
X-Google-Smtp-Source: ABdhPJx8ggpkYia33dPRZcM+QaMRkDtXDNflFeP1ubZrFE7jB4KdvAPoxj10fHNCfcznhtWPyv3XdQ==
X-Received: by 2002:a17:902:aa46:b029:ef:8a47:ca53 with SMTP id c6-20020a170902aa46b02900ef8a47ca53mr14212576plr.74.1621028132749;
        Fri, 14 May 2021 14:35:32 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 50/50] core: Remove the request member from struct scsi_cmnd
Date:   Fri, 14 May 2021 14:33:05 -0700
Message-Id: <20210514213356.5264-51-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since all scsi_cmnd.request users are gone, remove this pointer from
the scsi_cmnd structure.

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
index 8846e5066f92..1dac2725fd96 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2390,7 +2390,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 
 	scmd = (struct scsi_cmnd *)(rq + 1);
 	scsi_init_command(dev, scmd);
-	scmd->request = rq;
 	scmd->cmnd = scsi_req(rq)->cmd;
 
 	scmd->scsi_done		= scsi_reset_provider_done_command;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e88ce8f747ee..f03a42f239d8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1534,7 +1534,6 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 
 	scsi_init_command(sdev, cmd);
 
-	cmd->request = req;
 	cmd->tag = req->tag;
 	cmd->prot_op = SCSI_PROT_NORMAL;
 	if (blk_rq_bytes(req))
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a68521e6ce57..265fe4599b3e 100644
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
