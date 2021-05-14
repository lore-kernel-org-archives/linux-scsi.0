Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F30C43462
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F1A561442
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbhENVfr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:35:47 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:33735 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhENVfq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:35:46 -0400
Received: by mail-pj1-f46.google.com with SMTP id b13-20020a17090a8c8db029015cd97baea9so1961848pjo.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:34:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=42ckW6LU8oo00tgEtvvvObYtPpqzKDgelcuguXzF2mk=;
        b=aFsZhcIbxjx+77Hf3GUoUXnYW21vhNHijjGIrcFkxnd1Go8TUjGeV69rfNBLfbxKoA
         Ydf+VZpOi2CYXnQ2RjWDJrc9EktvUSU9jKDm460e7rPJTw178JGVhuPJB20JCfsxjGmG
         ImzE8AbE1Qj52s8t9MZi47/ODMXJoMX2VBnetfECnfiM7M+wz1oBudUmo94glGcPyJHB
         ImK6XizweFfuGX/w/WdS3npcr9kJ0tpMgZvhbJiJzJ2nA/DBehoRByxlIGm5gpH5pYQN
         H+b57rx6qELO0IXR+z/vM/yNbBb8kEKLke3DV9XnwfP6UhOr/PjM07r/XyajgxopdqsK
         gy1Q==
X-Gm-Message-State: AOAM530QFYM+RlgZB+lmswFLSxGB+nOdlTnvvNg8KSgToJkUd+folaHT
        UODpBl05Zu5XHqU+GyMANKQ=
X-Google-Smtp-Source: ABdhPJy49s2rpakM1EpWfeDyjnMB8rJWaWG4oR3x8r/BeEmz5D/6DULF5REdv3423p6kcaF6VghXHg==
X-Received: by 2002:a17:903:3106:b029:e9:15e8:250e with SMTP id w6-20020a1709033106b02900e915e8250emr47450035plc.33.1621028073038;
        Fri, 14 May 2021 14:34:33 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:34:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 16/50] csiostor: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:31 -0700
Message-Id: <20210514213356.5264-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/csiostor/csio_scsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 56b9ad0a1ca0..234e0baec091 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1786,7 +1786,7 @@ csio_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmnd)
 	struct csio_scsi_qset *sqset;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 
-	sqset = &hw->sqset[ln->portid][blk_mq_rq_cpu(cmnd->request)];
+	sqset = &hw->sqset[ln->portid][blk_mq_rq_cpu(blk_req(cmnd))];
 
 	nr = fc_remote_port_chkready(rport);
 	if (nr) {
@@ -1989,13 +1989,13 @@ csio_eh_abort_handler(struct scsi_cmnd *cmnd)
 		csio_info(hw,
 			"Aborted SCSI command to (%d:%llu) tag %u\n",
 			cmnd->device->id, cmnd->device->lun,
-			cmnd->request->tag);
+			blk_req(cmnd)->tag);
 		return SUCCESS;
 	} else {
 		csio_info(hw,
 			"Failed to abort SCSI command, (%d:%llu) tag %u\n",
 			cmnd->device->id, cmnd->device->lun,
-			cmnd->request->tag);
+			blk_req(cmnd)->tag);
 		return FAILED;
 	}
 }
