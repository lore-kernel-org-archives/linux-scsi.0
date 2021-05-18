Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87499C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D5A1611BF
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351305AbhERRrE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:04 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:46779 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351306AbhERRq7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:59 -0400
Received: by mail-pl1-f181.google.com with SMTP id s20so5507830plr.13
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bPGevx85bLU+6qi7Uvzpo6mDMJ9dy3nzpBNYNSqgdm8=;
        b=qf1ESwsit7Z5JOOfhqE+di8enD6ZFG8NvHf+cOkzmG5eFPm+oh+Sx07SItzZfs7EwD
         +GJxeG1GWUh8naz6CNvomcoljSM/b8U0PMxAm/dpdEMHCXIw9fL+AnKV8JM9AQVT+lfH
         cRUhhEluHn3wlJPn0jv8AOA8gCCYMvSUPBRQUoqFecDXx2FgXbshJzoVPvFQWyBTS8RU
         ANYLUFYH0NeRXo8sUuKNHST6SbUNNlMDIQkQKV8BoH7sb0EayxQEvP8dew86Z+4RMgz4
         oCOLpRXvULUnrf6QzOJYL6fLgzhlNMLmx6g2621GajzDQcRKuZkcdwwnUMdpWjIwMJZF
         045Q==
X-Gm-Message-State: AOAM532IRvV/Xd7bbzwzQABuHdecizRbGVy0XBYLMF10cyE7SyXKRNPI
        QdpRXaedDBhG/c7GTsN2fp4=
X-Google-Smtp-Source: ABdhPJy3SaevF2aChsJ5AdA7QAk31Vrj8dKj63x3sbhPAxEhciWBJ+Lt6MRpvshrj0zSHsSLdNkmtQ==
X-Received: by 2002:a17:902:7284:b029:ee:a57c:1dc9 with SMTP id d4-20020a1709027284b02900eea57c1dc9mr5885901pll.36.1621359940958;
        Tue, 18 May 2021 10:45:40 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 36/50] qla2xxx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:36 -0700
Message-Id: <20210518174450.20664-37-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4eab564ea6a0..c65e85db87d5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -849,7 +849,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		uint16_t hwq;
 		struct qla_qpair *qpair = NULL;
 
-		tag = blk_mq_unique_tag(cmd->request);
+		tag = blk_mq_unique_tag(scsi_cmd_to_rq(cmd));
 		hwq = blk_mq_unique_tag_to_hwq(tag);
 		qpair = ha->queue_pair_map[hwq];
 
@@ -1742,7 +1742,7 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 		}
 
 		spin_lock_irqsave(qp->qp_lock_ptr, *flags);
-		if (ret_cmd && blk_mq_request_started(cmd->request))
+		if (ret_cmd && blk_mq_request_started(scsi_cmd_to_rq(cmd)))
 			sp->done(sp, res);
 	} else {
 		sp->done(sp, res);
