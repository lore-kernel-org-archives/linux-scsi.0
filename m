Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67008C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42F6A216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405379AbfHIDDy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:54 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41633 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404533AbfHIDDx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:53 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so45234647pff.8
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MbGH3HcnceA60PUu874eDpFATkH1Jd/xIsvy/AU7OA0=;
        b=nB0tXmG4Vw1DOzsOdnv61tlsA4lJYciWaUVQ2riC0P6aEEhJjBdia7PnSqvd9diC5D
         a7bVA6NDOpbFHBXRaZ2S/T3KQM/gpNNMNxss55KyRkh223x92iJxLXS7VgHuWOhx2Dd6
         aO6odYJULMQEgQnvRSSTSwYQSxCTk+b0H6fxN4KZVFLAkQiTGXkO42ihDnYFFTZDU4tS
         aQ8Xgt4SFiKQ+1+ET8SQRxOv8ykX5WccYejh5q/1ZHiuXHWZ2d9CgAe6r5uYRiRvCJoR
         aAwX4ia1/jabnIrf9FE1N6LwuZaz/j3lmPfw0heKPXkDqGrCdwbSIO8z0vHKEdSdmbAV
         YfoA==
X-Gm-Message-State: APjAAAVkOlpdJoOcAROimc7Gis4pUYyHR+flQ/u7VcZT98LeRlKBbmUu
        CBHmzptk3tGS07AHnJXV4yo=
X-Google-Smtp-Source: APXvYqzAp8OlQE2rxRN1OFlYcncEl4Lgofs60zEZ/0F7RmXhPrWvQPULl/+GPifqiJ/5hf3RusuTtQ==
X-Received: by 2002:aa7:9dcd:: with SMTP id g13mr19364379pfq.204.1565319832951;
        Thu, 08 Aug 2019 20:03:52 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 57/58] qla2xxx: Simplify qla24xx_async_abort_cmd()
Date:   Thu,  8 Aug 2019 20:02:18 -0700
Message-Id: <20190809030219.11296-58-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the code easier to read by converting 'goto' statements into
'return' statements.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c9cb6856f82e..535dc21ef56e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -136,7 +136,7 @@ static int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 	sp = qla2xxx_get_qpair_sp(cmd_sp->vha, cmd_sp->qpair, cmd_sp->fcport,
 				  GFP_ATOMIC);
 	if (!sp)
-		goto done;
+		return rval;
 
 	abt_iocb = &sp->u.iocb_cmd;
 	sp->type = SRB_ABT_CMD;
@@ -160,20 +160,18 @@ static int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 	       cmd_sp->type);
 
 	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS)
-		goto done_free_sp;
+	if (rval != QLA_SUCCESS) {
+		sp->free(sp);
+		return rval;
+	}
 
 	if (wait) {
 		wait_for_completion(&abt_iocb->u.abt.comp);
 		rval = abt_iocb->u.abt.comp_status == CS_COMPLETE ?
 			QLA_SUCCESS : QLA_FUNCTION_FAILED;
-	} else {
-		goto done;
+		sp->free(sp);
 	}
 
-done_free_sp:
-	sp->free(sp);
-done:
 	return rval;
 }
 
-- 
2.22.0

