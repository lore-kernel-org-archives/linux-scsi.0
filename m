Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA71C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51C2261002
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237059AbhHIXFy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:54 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:33707 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236260AbhHIXFv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:51 -0400
Received: by mail-pj1-f47.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so250787pje.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:05:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pe/i7NHwGLMp09YGkFixTOKu2VqoRlITK4RnDEIHQlU=;
        b=cWL1DZ2DRZ2kpbpI3Cv6lwmWo5jc/7Szqu74JSkfFXdtBsgV6YKA2iJuF7nCUrNbeE
         CwRHuXF2cfR17wEpvPgnTRoeEyoa9ADXShYPOIxA+SiZqrLxahVGGX56yXh6D1ZGtp7P
         aVzVO0Y1qub4Rzvkrrycw6ovc4V5sCDHWvFD88A4MKZuEcQbZlocYH8vNdPSnCgEDiA3
         zxLk5ELIcyP5qO3FJzm+ZJyMC2WXogSfg8U+Q8CiSqCZiFXCCCP8Ny8KPqrHQV/wOQRu
         2GZ1vxJwkYKw6pSMRks2EKi54wQAhsOCsR7LCbQjE52R2JrNkL7ldg+otLll3ND8aba5
         vzcQ==
X-Gm-Message-State: AOAM5313iZ7QOhJ8l8kLXYFRlbgTLe0byK9SBEaxbiQH/DI7W9F0Jdtp
        kikvQ5tDY02k6dlTBY3ar9c=
X-Google-Smtp-Source: ABdhPJwEhSd9Rm6cLkjMW5Xq5heUH/HPAj7lP3R9+UzhvuMHwCf+tfA55eSL0wDaHSQnna9B/pcGAA==
X-Received: by 2002:a62:db85:0:b029:3cd:cd0a:3137 with SMTP id f127-20020a62db850000b02903cdcd0a3137mr911101pfg.11.1628550330073;
        Mon, 09 Aug 2021 16:05:30 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:05:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 52/52] core: Remove the request member from struct scsi_cmnd
Date:   Mon,  9 Aug 2021 16:03:55 -0700
Message-Id: <20210809230355.8186-53-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
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
index d85d308a0683..b6c86cce57bf 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2377,7 +2377,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 
 	scmd = (struct scsi_cmnd *)(rq + 1);
 	scsi_init_command(dev, scmd);
-	scmd->request = rq;
 	scmd->cmnd = scsi_req(rq)->cmd;
 
 	scmd->scsi_done		= scsi_reset_provider_done_command;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 909a422ec8f4..9ba1aa7530a9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1540,7 +1540,6 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 
 	scsi_init_command(sdev, cmd);
 
-	cmd->request = req;
 	cmd->tag = req->tag;
 	cmd->prot_op = SCSI_PROT_NORMAL;
 	if (blk_rq_bytes(req))
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index b9265b15d37a..ddc9671b325b 100644
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
