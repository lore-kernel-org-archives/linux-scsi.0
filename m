Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0A3C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46A9660F23
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242545AbhJGUd2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:28 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:41775 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242673AbhJGUdR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:17 -0400
Received: by mail-pf1-f174.google.com with SMTP id p1so6290921pfh.8
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=skrAmBmXdhbbtXPNDmsGk4Mh42e48xm20jYpMF7O6uY=;
        b=Hzhhx+BS1g4hlDHIfF/0r8OiwausXxU+3Hv1PNU53BzMCxf2sJZycdtw3t+LJUQxMg
         gsrhLClEYB67SI526sCn0wVEJilBqNVjk6A9/dy6tXQOzSVJ0EM0y99LZmPgwQYHWF0e
         CWGvwb3u+VUVe4Ne25EIvnXab5Df3P/mk/EvLc0wZMePFJLyPWFo25euLl25qqq25fPs
         7aKLiasSsEEJC2eCrX7/7C0Xml8PmuldTvQSMcDeR29Bl4bPkVF6ZqlGE5e7ZFeVupkc
         rQc+/wLFIJwzzOxA6IQo22I+6dtYVTKSMsMPTViiKXqOxb9EDPaRxKIeDuXLwLutPG3t
         iq0A==
X-Gm-Message-State: AOAM531vK6ij33IGHDCLNWsx0/DCyvKe5xOiEC1PqIUjvAlX+/Joie0G
        PQfplx9yF5RQJ2HmBEJh8/Q6ZH3aEyU=
X-Google-Smtp-Source: ABdhPJyr15dfsnNCU80xpSFfrUw/tS9htBr/Zn51x17+qnfmHrrJ5hMsGlp26LizY4cNPt8tR+ws4A==
X-Received: by 2002:a63:d017:: with SMTP id z23mr1377993pgf.108.1633638683313;
        Thu, 07 Oct 2021 13:31:23 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 65/88] qla2xxx: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:29:00 -0700
Message-Id: <20211007202923.2174984-66-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
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
