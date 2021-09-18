Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FD8C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2224560F48
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344454AbhIRAKK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:10:10 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:44894 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345008AbhIRAJZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:25 -0400
Received: by mail-pj1-f51.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso8526779pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:08:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=skrAmBmXdhbbtXPNDmsGk4Mh42e48xm20jYpMF7O6uY=;
        b=PKlTjJKni5mhdUBrO+DuclbZUVsdcu1EScuLaVM5Z7iYMY9TAtAlCAg2sPcBCWoB+Q
         U/cuVWX2JwkQivcMPBC1NFVNQyWdA4b4jp8BtUI2B2jLX3TXVu7+EPFcLisnPDaoBAH/
         20iAPIJOjIrrBbUql6HsQSMX6RBbvKoEDAnhpdAXwhAMY3u4nBBlDtCnrNITeO3P3mhP
         WV0VMdy0lOil7t+2N2TOVeKZrOKWrYpp3JQX94AIF4oWmj3ZsXeFmsguitcT2o2fjwX1
         drBi6iMc81VuTsjhtY4tGT0bbpBbN/aWikXpMKVoz6tbpdiMf9Ev8r4dEDuYcWws8X9+
         NRcA==
X-Gm-Message-State: AOAM533NVbz+oNLCOVQtVgbb3zqCnjVo7Nog1SVCl/x57J4IDRU9931j
        mjgDNEhzMt6etQDg5cejUK4=
X-Google-Smtp-Source: ABdhPJzjY1wgRnaks9Ec7LMAlJIfr55Urs4i4Vg1a5nlfkXfa8yuv1m2OTmgxMLW7xTrrA9n7MVgpQ==
X-Received: by 2002:a17:902:cec8:b0:13b:9ce1:b3ef with SMTP id d8-20020a170902cec800b0013b9ce1b3efmr11949823plg.4.1631923682288;
        Fri, 17 Sep 2021 17:08:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:08:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 64/84] qla2xxx: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:47 -0700
Message-Id: <20210918000607.450448-65-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 03ff2596715b..5d576a3ba14f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -737,7 +737,7 @@ void qla2x00_sp_compl(srb_t *sp, int res)
 	sp->free(sp);
 	cmd->result = res;
 	CMD_SP(cmd) = NULL;
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 	if (comp)
 		complete(comp);
 }
@@ -828,7 +828,7 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
 	sp->free(sp);
 	cmd->result = res;
 	CMD_SP(cmd) = NULL;
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 	if (comp)
 		complete(comp);
 }
@@ -950,7 +950,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 qc24_fail_command:
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 
 	return 0;
 }
@@ -1038,7 +1038,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 qc24_fail_command:
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 
 	return 0;
 }
