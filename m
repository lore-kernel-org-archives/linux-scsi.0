Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68FC4C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FA04216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405021AbfHIDCu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:02:50 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:47032 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404954AbfHIDCu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:02:50 -0400
Received: by mail-pg1-f196.google.com with SMTP id w3so7891646pgt.13
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:02:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2IXv6f0trox0t5CMz2ezG5XB/KALYoAhNvoHj9AJYgw=;
        b=IbRH5nzbByc7bPONNaPcHtZhJLY7dAKOY958woMx7XV54cUYXqWwQjyqwRk+dsdi5N
         icwj1BmkHZBJYHFOGW9RNH4i+GSU32OaYJydQlqm1Ssz8tQNotXRqR860GfSvPIizpt6
         2qarNvQvSu59rAAZxmCv8yO2xF2CHSJanP8FhEniw5qfitKOro1f4q13OoWfw93z5R1d
         3FZXFKqPvxCqPFI1PRuQJ7zHBFMRO4iL/ypCsa7Ntxn0y9PWz+skGRYr3hMMND2vRSls
         wyebh9i8eevZna+TwohB+PAOqAoDsB12oD4etLDhZ6bfvP8OpTQOKzcpAAcgcTYlTvwi
         vUXQ==
X-Gm-Message-State: APjAAAXD2DQtmU5DF59QNkMl5OoXBQw8p5Qoh24Fc9wouZl+w6fci90N
        uT5Ced/RkZX8Mcd2Bq/hDyI=
X-Google-Smtp-Source: APXvYqxAqGJBCzNvyr5NEF/0PIJHKanTf9GdkbgkSAY9PshcIliBX7iFc1USSGLXOMQ6jTkU8EVpSg==
X-Received: by 2002:a17:90a:380d:: with SMTP id w13mr7055086pjb.138.1565319769735;
        Thu, 08 Aug 2019 20:02:49 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 10/58] qla2xxx: Reduce the scope of three local variables in qla2xxx_queuecommand()
Date:   Thu,  8 Aug 2019 20:01:31 -0700
Message-Id: <20190809030219.11296-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch makes it clear that the tag, hwq and qpair variables are
only used in the mq path.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8f972e1b5215..a5acd5e2dfb1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -845,9 +845,6 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 	srb_t *sp;
 	int rval;
-	struct qla_qpair *qpair = NULL;
-	uint32_t tag;
-	uint16_t hwq;
 
 	if (unlikely(test_bit(UNLOADING, &base_vha->dpc_flags)) ||
 	    WARN_ON_ONCE(!rport)) {
@@ -856,6 +853,10 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	}
 
 	if (ha->mqenable) {
+		uint32_t tag;
+		uint16_t hwq;
+		struct qla_qpair *qpair = NULL;
+
 		tag = blk_mq_unique_tag(cmd->request);
 		hwq = blk_mq_unique_tag_to_hwq(tag);
 		qpair = ha->queue_pair_map[hwq];
-- 
2.22.0

