Return-Path: <SRS0=dDgG=ZB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD0AC43331
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 04:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B30B215EA
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 04:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfKIEVo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 23:21:44 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41398 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfKIEVn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 23:21:43 -0500
Received: by mail-pl1-f193.google.com with SMTP id d29so5183017plj.8
        for <linux-scsi@vger.kernel.org>; Fri, 08 Nov 2019 20:21:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J9HdkuW4uJM91FmSyx+W41EjUI+qWVMQt6WNUJJR7jU=;
        b=mHFRSzKVF3jLrb3FE/tEcCGNMNIlv5Qa9xjjpsFzbQ8OCKOYlZzytn9dARxx+gn0nF
         Jn/9vGseMip/9EFCiNSMhlGTZGaqq03u3fQNrZEaCbfXXgYcNrk2/tWZHDIjG2MXMsUx
         42i2eDKTFJMfUd6OPW4FGQB4HCcQXAM+U006UM0w8aqyPy/txccBx7aCa53nlWaxhPTy
         q87HN/G5HSABhuYznySs9HUCt6YggQiGZmr5b1XkSQpu+5D8ZexGhb2EQJC9ZVmapwr8
         YPq2v6rgQTbURP1J+dvZIklRZiR+WP8ftBAvetr7WF7Wqxq38d9AdKq1APtH3afMz6A/
         oK5A==
X-Gm-Message-State: APjAAAWAtmyyP38b41/rz9M63a3oZzSJ71QY6HygVkebi4gne6VekSjN
        +cmGd4yhIdTcJAi8Ljh6q78TvRATzFM=
X-Google-Smtp-Source: APXvYqxj/5IpUjjaqMmKkDIWKwbeSPydf1bSiZ8x3j3ak7QXhmsqnKUk/2CbeSwS3ZzLd6iZP+K69w==
X-Received: by 2002:a17:902:6ac8:: with SMTP id i8mr2514995plt.30.1573273302845;
        Fri, 08 Nov 2019 20:21:42 -0800 (PST)
Received: from localhost.net ([2601:647:4000:a8:64c1:7f03:d411:a61])
        by smtp.gmail.com with ESMTPSA id q70sm9488232pjq.26.2019.11.08.20.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 20:21:41 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH] Revert "qla2xxx: Fix Nport ID display value"
Date:   Fri,  8 Nov 2019 20:21:35 -0800
Message-Id: <20191109042135.12125-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The commit mentioned in the subject breaks point-to-point mode for at least
the QLE2562 HBA. Restore point-to-point support by reverting that commit.

Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Fixes: 0aabb6b699f7 ("scsi: qla2xxx: Fix Nport ID display value")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index b25f87ff8cde..cfd686fab1b1 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2656,10 +2656,9 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 	els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
 	els_iocb->port_id[1] = sp->fcport->d_id.b.area;
 	els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
-	/* For SID the byte order is different than DID */
-	els_iocb->s_id[1] = vha->d_id.b.al_pa;
-	els_iocb->s_id[2] = vha->d_id.b.area;
-	els_iocb->s_id[0] = vha->d_id.b.domain;
+	els_iocb->s_id[0] = vha->d_id.b.al_pa;
+	els_iocb->s_id[1] = vha->d_id.b.area;
+	els_iocb->s_id[2] = vha->d_id.b.domain;
 
 	if (elsio->u.els_logo.els_cmd == ELS_DCMD_PLOGI) {
 		els_iocb->control_flags = 0;
-- 
2.23.0

