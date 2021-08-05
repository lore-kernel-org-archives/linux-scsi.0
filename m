Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AEEAC4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71C2661078
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242553AbhHETUM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:12 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:43729 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242893AbhHETUH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:20:07 -0400
Received: by mail-pj1-f54.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so12006948pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:19:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8THQL4IBWnjCFG34wAR/rrdTZqIKDZOaWTk3GhOvU/Y=;
        b=tEZ5Q5KL9PtBcBxctmgUcSJUnVyJrU7h6PoYu1057JebJ2NfdrYwOBA1bX+D4uFmtB
         5KyNJ48jrUJYYu9afG9DSt1Cd4HIT/3NvOzDD/88o5+V+W3AcFplq4l6Xn1Uta919eVg
         PlVFEonJhNGqRysjYbDyanGsJa58VE3c37cbFf+w7784m4/Yoh740X26wCLqnmTVjgBs
         UyVPIqN/kJmQCRnpSCqsYB09E6ZmI7TnkwimkAua1iIfcRnyLCKYiemQxg/QGkzX1tqp
         lcDVtnnXC9rw0o4lUCIW5FQE/g9I0wEj6wFCcaRZtRsF2/4X/ktYs9+af4v91gMl80CN
         ChUQ==
X-Gm-Message-State: AOAM533i6yEVWpG94DPLUWZbHa8IxyCovoWSTxoJAqdEmpXYJ2lmp4zU
        mJHBRudVzRLIqmHv1oZXJn3ZRdUydS6O4ihyC30=
X-Google-Smtp-Source: ABdhPJzX1e2+6AZ1XEitXtzdEaJhcETZhRTSQ66wiM84ZhTAAN0GyhS7GLMiNg6jpo2+CyGCBofQEQ==
X-Received: by 2002:a63:f64d:: with SMTP id u13mr1953531pgj.156.1628191191674;
        Thu, 05 Aug 2021 12:19:51 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:19:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 39/52] qla4xxx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:15 -0700
Message-Id: <20210805191828.3559897-40-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla4xxx/ql4_iocb.c | 2 +-
 drivers/scsi/qla4xxx/ql4_os.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index c57cec6fff6d..28eab07935ba 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -288,7 +288,7 @@ int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb)
 	/* Acquire hardware specific lock */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	index = (uint32_t)cmd->request->tag;
+	index = scsi_cmd_to_rq(cmd)->tag;
 
 	/*
 	 * Check to see if adapter is online before placing request on
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 3f7737386193..f1ea65c6e5f5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -9282,7 +9282,7 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 	DEBUG2(printk(KERN_INFO
 		      "scsi%ld: DEVICE_RESET cmd=%p jiffies = 0x%lx, to=%x,"
 		      "dpc_flags=%lx, status=%x allowed=%d\n", ha->host_no,
-		      cmd, jiffies, cmd->request->timeout / HZ,
+		      cmd, jiffies, scsi_cmd_to_rq(cmd)->timeout / HZ,
 		      ha->dpc_flags, cmd->result, cmd->allowed));
 
 	rval = qla4xxx_isp_check_reg(ha);
@@ -9349,7 +9349,7 @@ static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
 	DEBUG2(printk(KERN_INFO
 		      "scsi%ld: TARGET_DEVICE_RESET cmd=%p jiffies = 0x%lx, "
 		      "to=%x,dpc_flags=%lx, status=%x allowed=%d\n",
-		      ha->host_no, cmd, jiffies, cmd->request->timeout / HZ,
+		      ha->host_no, cmd, jiffies, scsi_cmd_to_rq(cmd)->timeout / HZ,
 		      ha->dpc_flags, cmd->result, cmd->allowed));
 
 	rval = qla4xxx_isp_check_reg(ha);
