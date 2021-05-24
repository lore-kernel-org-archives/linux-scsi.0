Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 908D3C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74F6F61166
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbhEXDLC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:02 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:34568 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbhEXDK7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:10:59 -0400
Received: by mail-pj1-f53.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso9570768pjx.1
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wjHPmJeqPk5ydGEPAsbeM+wR0ly8Ex7oFJ5KgXs11aQ=;
        b=q2P83Krw+AsQGjrxcVyPp46+Z2JmNXdkkZrP6i3iYEpfQkbVWYUEiXw+SQ63uVvG01
         SBQJoQqN2CZvMtopqfOFl3pmjDHT5dGmGsOe3o1r9eQ8/LL1FMi+ygQ4mZ58ewtd/2M3
         2tzocF9Tf/U+duQjJZhvZj9QmNGL5BhtynJjI1nAEsw7/o3yPQwUb8cW8GEGLzfdAhjg
         Bpft18oiwUcUP/DJ8IDGq20tcCQ6Y8gjIkQcujnjcVIZai7xti6bQyn+cHQXNq3RQf8P
         4xxSAywZ6VB5kBb9NM6wX+24Z8g671dh36xaUp7k4TviXPJX/kS40JFrASh+KYZIjdQ0
         S6PQ==
X-Gm-Message-State: AOAM532IVuGlq2E2zpiP9mRYQOMgwZ3LoX2GhWP5NSQH8MhQZRCaw1jL
        LawXntplu4qoGa1LOSiLnGg=
X-Google-Smtp-Source: ABdhPJzKRF4v36EwbfQZF9HSgw6maz6+eJH4/HhkdkKCVMuR8w296wzp2ilWYPvUTLSnGjDgEfYxnw==
X-Received: by 2002:a17:90b:17c9:: with SMTP id me9mr23296299pjb.13.1621825771585;
        Sun, 23 May 2021 20:09:31 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v3 17/51] csiostor: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:22 -0700
Message-Id: <20210524030856.2824-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/csiostor/csio_scsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 56b9ad0a1ca0..3b2eb6ce1fcf 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1786,7 +1786,7 @@ csio_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmnd)
 	struct csio_scsi_qset *sqset;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 
-	sqset = &hw->sqset[ln->portid][blk_mq_rq_cpu(cmnd->request)];
+	sqset = &hw->sqset[ln->portid][blk_mq_rq_cpu(scsi_cmd_to_rq(cmnd))];
 
 	nr = fc_remote_port_chkready(rport);
 	if (nr) {
@@ -1989,13 +1989,13 @@ csio_eh_abort_handler(struct scsi_cmnd *cmnd)
 		csio_info(hw,
 			"Aborted SCSI command to (%d:%llu) tag %u\n",
 			cmnd->device->id, cmnd->device->lun,
-			cmnd->request->tag);
+			scsi_cmd_to_rq(cmnd)->tag);
 		return SUCCESS;
 	} else {
 		csio_info(hw,
 			"Failed to abort SCSI command, (%d:%llu) tag %u\n",
 			cmnd->device->id, cmnd->device->lun,
-			cmnd->request->tag);
+			scsi_cmd_to_rq(cmnd)->tag);
 		return FAILED;
 	}
 }
