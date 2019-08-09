Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA8DC0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78399216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405294AbfHIDDg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:36 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40484 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405025AbfHIDDg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:36 -0400
Received: by mail-pg1-f195.google.com with SMTP id w10so45100005pgj.7
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HGNSO5+3+uWnPG1YjZPa6GKhlZFqugVNU7tiQFEGIfM=;
        b=kukjPSZVNKnDE+rqR+iu/ZN+wDnFo1RzQhStwsmL0hOUScphdeRDRenCfmzjzCAmdD
         sLau9qww7Nwj1b7LaKDkzK+PAs8Fsyof9Yt/h1c2vLBERAdJR4sl3uUvNXqZae4CccEV
         GLT3MTfbpComggfO/B9eYHwy8wWkSpteN+NVVh0jeT0DDEy02k79V9itz1O1B/G2Is4f
         xCMkv26FHiDZkP55MjFMgIo870ORjIR6MVRlNokayeJ6r6NJS2ukfj6wRXF+A31cp6Ss
         +VnRCZzSiR2afG2f7X98qYq8X9Fh6x/OqrACE8YeVlSZLiycZKBFaA98NuetFeo9K13q
         F92w==
X-Gm-Message-State: APjAAAVNQU1eb3nPrytyhXcGybKcetH2MhvkTxRJbXBeohUDhBZi58PF
        R5jJehG+H42lGIRYXTkxeWdGgw4j
X-Google-Smtp-Source: APXvYqxDyOMyNXoSSdUP9NuLVUU8QR86jieMAVkWr94pjfBQjz4nQu54vYsPMNHKY1u43dj/OO89CQ==
X-Received: by 2002:a63:fc52:: with SMTP id r18mr15502001pgk.378.1565319815133;
        Thu, 08 Aug 2019 20:03:35 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 44/58] qla2xxx: Introduce the function qla2xxx_init_sp()
Date:   Thu,  8 Aug 2019 20:02:05 -0700
Message-Id: <20190809030219.11296-45-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch does not change any functionality but makes the next patch
easier to read.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_inline.h | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index bf063c664352..0c3d907af769 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -152,6 +152,18 @@ qla2x00_chip_is_down(scsi_qla_host_t *vha)
 	return (qla2x00_reset_active(vha) || !vha->hw->flags.fw_started);
 }
 
+static void qla2xxx_init_sp(srb_t *sp, scsi_qla_host_t *vha,
+			    struct qla_qpair *qpair, fc_port_t *fcport)
+{
+	memset(sp, 0, sizeof(*sp));
+	sp->fcport = fcport;
+	sp->iocbs = 1;
+	sp->vha = vha;
+	sp->qpair = qpair;
+	sp->cmd_type = TYPE_SRB;
+	INIT_LIST_HEAD(&sp->elem);
+}
+
 static inline srb_t *
 qla2xxx_get_qpair_sp(scsi_qla_host_t *vha, struct qla_qpair *qpair,
     fc_port_t *fcport, gfp_t flag)
@@ -164,19 +176,9 @@ qla2xxx_get_qpair_sp(scsi_qla_host_t *vha, struct qla_qpair *qpair,
 		return NULL;
 
 	sp = mempool_alloc(qpair->srb_mempool, flag);
-	if (!sp)
-		goto done;
-
-	memset(sp, 0, sizeof(*sp));
-	sp->fcport = fcport;
-	sp->iocbs = 1;
-	sp->vha = vha;
-	sp->qpair = qpair;
-	sp->cmd_type = TYPE_SRB;
-	INIT_LIST_HEAD(&sp->elem);
-
-done:
-	if (!sp)
+	if (sp)
+		qla2xxx_init_sp(sp, vha, qpair, fcport);
+	else
 		QLA_QPAIR_MARK_NOT_BUSY(qpair);
 	return sp;
 }
-- 
2.22.0

