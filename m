Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B728DC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98558611EE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351200AbhERRqh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:37 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:55062 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351241AbhERRqe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:34 -0400
Received: by mail-pj1-f51.google.com with SMTP id g24so5904258pji.4
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wjHPmJeqPk5ydGEPAsbeM+wR0ly8Ex7oFJ5KgXs11aQ=;
        b=ANX/2bg0HCTMWYsOxgkfeVCaFquqYz2rhtg1fT0y2Mnfx255c0OZNcfeyclVywpkCN
         HXIz9kIRp6PZ+iPN6gQ3U9cVzsxxcNHdVZHjpMBSUVWORpBtrgNOw6p80yVzzFfNMfLY
         qlBBoht0O3QFGiVKb7wj9yO5q5ApzYK85g2hB2j4uOLrX1gyEFrS11MzIqYoBYssETRx
         HUyBoy4kL2TOPDYuNvE6Fv3v7xyC4rNFu8zMKMFt8SKfVy2pezhWuq6xSn4/k/fi4QiU
         DzQMdq6KPPt8i4H3YfHwMstvRRgf9DPcmCxWJd0kPV/zS5qbQCP+AnGZXj9xdU576CGy
         bC5g==
X-Gm-Message-State: AOAM5304LdM+j+NeZ6HqazhJGwgn8Myjay9iRt9XRRxSGWeiQNwFL20C
        yhq87SMPhW7Qw/riI9cjvZk=
X-Google-Smtp-Source: ABdhPJy5K4qjzcC1JTF9qpfWK/qDKgeiLUGGl0TbGNaWom07YiPVwurqSkJanp3Aw7NMfbokkZW4Qg==
X-Received: by 2002:a17:902:7d87:b029:ef:176:843b with SMTP id a7-20020a1709027d87b02900ef0176843bmr5827713plm.61.1621359916388;
        Tue, 18 May 2021 10:45:16 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH v2 16/50] csiostor: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:16 -0700
Message-Id: <20210518174450.20664-17-bvanassche@acm.org>
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
