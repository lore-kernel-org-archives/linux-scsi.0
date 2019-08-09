Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05394C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8F02216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405377AbfHIDDw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:52 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39873 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404533AbfHIDDw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:52 -0400
Received: by mail-pg1-f196.google.com with SMTP id u17so45099920pgi.6
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/e4ChgfA6oBk12qtgQHBqVtWp7ViAw7JJivh5W2ujVc=;
        b=U9xFkgBWmwK45odFh4gFYottZphHVR7/APfc4AJuEKJekDlaIKJD4v3PbsoHEER+xj
         wE63uYflB+EXoeAIlAYsP1SYuvmC3FlZByZfqWQNTCjiu7RTwTpiKlnpf6jt5GQg/6FR
         FTP5Pr07G4O3ks74jddSzO1WqnBDztcJuKRhOpySif68e2JrtTq3IsYiMjp3OgyF+/Q0
         6j5xoT+M7sgDpCJF59qeh+GDBpbLNjxo4DL9Zjx4UpFlyEJ808pB7S7WXwUqBAg82EmZ
         NGrhxLCvfr64nYN/R/jpxkpgpIP7yGhVwyEV3WBZ2R6MNjPaZEjDKCbWQ6RXC7RPzb1r
         /0BA==
X-Gm-Message-State: APjAAAXhmkBCTVYzTdwwTqeybjIrsKqx8a7zExwIUOnHy2xH8VXuQ6Hu
        SpW8s+sDC2sCvm4jpYI+q+s=
X-Google-Smtp-Source: APXvYqy2GvaTBIaLlXd89WiGWH7SRuHm5MKBSFVJt6E8wAJF+HJmSgh66Yw58LtcFx0vWXz9pch/Fw==
X-Received: by 2002:a63:fc52:: with SMTP id r18mr15502966pgk.378.1565319831671;
        Thu, 08 Aug 2019 20:03:51 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 56/58] qla2xxx: Remove two superfluous if-tests
Date:   Thu,  8 Aug 2019 20:02:17 -0700
Message-Id: <20190809030219.11296-57-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following Coverity complaint:

Null-checking sp->u.iocb_cmd.u.ctarg.rsp suggests that it may be null, but
it has already been dereferenced on all paths leading to the check.

See also commit e374f9f59281 ("scsi: qla2xxx: Migrate switch registration commands away from mailbox interface") # v4.16.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index bf8b30c4827c..03f94eb372b6 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3295,20 +3295,17 @@ static void qla2x00_async_gpnid_sp_done(srb_t *sp, int res)
 	e = qla2x00_alloc_work(vha, QLA_EVT_UNMAP);
 	if (!e) {
 		/* please ignore kernel warning. otherwise, we have mem leak. */
-		if (sp->u.iocb_cmd.u.ctarg.req) {
-			dma_free_coherent(&vha->hw->pdev->dev,
-				sp->u.iocb_cmd.u.ctarg.req_allocated_size,
-				sp->u.iocb_cmd.u.ctarg.req,
-				sp->u.iocb_cmd.u.ctarg.req_dma);
-			sp->u.iocb_cmd.u.ctarg.req = NULL;
-		}
-		if (sp->u.iocb_cmd.u.ctarg.rsp) {
-			dma_free_coherent(&vha->hw->pdev->dev,
-				sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
-				sp->u.iocb_cmd.u.ctarg.rsp,
-				sp->u.iocb_cmd.u.ctarg.rsp_dma);
-			sp->u.iocb_cmd.u.ctarg.rsp = NULL;
-		}
+		dma_free_coherent(&vha->hw->pdev->dev,
+				  sp->u.iocb_cmd.u.ctarg.req_allocated_size,
+				  sp->u.iocb_cmd.u.ctarg.req,
+				  sp->u.iocb_cmd.u.ctarg.req_dma);
+		sp->u.iocb_cmd.u.ctarg.req = NULL;
+
+		dma_free_coherent(&vha->hw->pdev->dev,
+				  sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
+				  sp->u.iocb_cmd.u.ctarg.rsp,
+				  sp->u.iocb_cmd.u.ctarg.rsp_dma);
+		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 
 		sp->free(sp);
 		return;
-- 
2.22.0

