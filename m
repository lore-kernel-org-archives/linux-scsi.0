Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B189C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ACC1216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405084AbfHIDDB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:01 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36535 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404951AbfHIDDA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:00 -0400
Received: by mail-pf1-f194.google.com with SMTP id r7so45224927pfl.3
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6dfnj41h5Ffx/clPgWBpZ+cil8VTPAkQJwXxXrXFmmw=;
        b=qhUg5svfJzClv/y9dXVqkhqiMQuOkyqxPPT7L4MfPS0rDfzathlBOPbGrrlpRkN++N
         E6Q8t32n1qT3GaPkZCnMG2n4L+E23WH2FEhUf97efksNxdnTIzX8ZmxCMYbRss6vYf24
         Gml+zFMiAjFcXNuR2N34Yhz2kmJQ0aXbGUXd/vAcfYOmjOwNVwv/guy9H5AKWYjU9Rw4
         1aoVMGcHLduFI9RitEjh9LDHU5zzi/YL81AkMm6NHe1i+1y6vq4Y1GMbHfehpjO8Uc9I
         UUlKcHWS0FDDQBTtokrUh4yFG/Q3989sSBZaJizEwFyRkhG1XYFmkfqeg1a37otIhotE
         t4gg==
X-Gm-Message-State: APjAAAV9VGiVuSSInM2qaNiET2wYnkyr6LgtS2LI3wIUVxLDqnUAasiv
        dwz1lvxeqNWDkyhBHoRbzWQ3xjQV
X-Google-Smtp-Source: APXvYqzGWV/Ne2mG5PyQSGGxZVpm2CTVE2OyW4m6bUcEOyyOfqH0G0zCNn+gIRU1zSMbSkPKRAevFQ==
X-Received: by 2002:aa7:8817:: with SMTP id c23mr19207515pfo.146.1565319780092;
        Thu, 08 Aug 2019 20:03:00 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 18/58] qla2xxx: Simplify qla24xx_abort_sp_done()
Date:   Thu,  8 Aug 2019 20:01:39 -0700
Message-Id: <20190809030219.11296-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of explicitly checking whether a timeout has occurred, ignore
the del_timer() return value.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c24d7667d3c9..cab5f2f90714 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -122,13 +122,11 @@ static void qla24xx_abort_sp_done(void *ptr, int res)
 	srb_t *sp = ptr;
 	struct srb_iocb *abt = &sp->u.iocb_cmd;
 
-	if ((res == QLA_OS_TIMER_EXPIRED) ||
-	    del_timer(&sp->u.iocb_cmd.timer)) {
-		if (sp->flags & SRB_WAKEUP_ON_COMP)
-			complete(&abt->u.abt.comp);
-		else
-			sp->free(sp);
-	}
+	del_timer(&sp->u.iocb_cmd.timer);
+	if (sp->flags & SRB_WAKEUP_ON_COMP)
+		complete(&abt->u.abt.comp);
+	else
+		sp->free(sp);
 }
 
 static int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
-- 
2.22.0

