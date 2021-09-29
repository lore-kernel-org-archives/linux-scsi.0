Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F62C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4B9E61423
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347147AbhI2WJm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:42 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:33374 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347185AbhI2WJk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:40 -0400
Received: by mail-pg1-f180.google.com with SMTP id a73so1209777pge.0
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=skrAmBmXdhbbtXPNDmsGk4Mh42e48xm20jYpMF7O6uY=;
        b=oOksn0XCXnBDAWZSDD1dRRxSB6v7j+qjOjc5vBF1cMD2LK7gT3iQ8EIiTTYEihYfhR
         wTKqCzCBleFSaMaSq88JjYZiSMs81hkxhtmK2P/qcemaMyde8TXXsnDWnKMccNE1T6KY
         w3jBeDKIan769y1kDNfMbWC3m8M3vsrlq98sfzr17sIAvi/Ur6/K3HEqEura5srJuf1v
         7GDM0vECHay7+/+nSonTA8E2MdsdxQtlEWFIOPU7vRVzGqJcW8XKia0bAYmPk85cDwNH
         y6J5EQE3z6EQqOCqx3XCtqCGsqaZzrWi1rVBtK5UsXMdycGLaWM2bm6/Ju3PGBVmrdB6
         O4nA==
X-Gm-Message-State: AOAM531CUl4ygtyptblCEzI0G0cZnFLG1cvofIZovXNhc1i0dgtDB5v1
        vZuqKWqVOUaHqXgArWGizTw=
X-Google-Smtp-Source: ABdhPJwPTqNubU3AIa3KBsmeJpya2t5ajyMhE81OdcG7nnYSd3dUXoNG1ThBNCoaXzusaoRMIVLBzA==
X-Received: by 2002:a63:1a1b:: with SMTP id a27mr1476151pga.220.1632953278964;
        Wed, 29 Sep 2021 15:07:58 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:58 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 64/84] qla2xxx: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:40 -0700
Message-Id: <20210929220600.3509089-65-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
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
