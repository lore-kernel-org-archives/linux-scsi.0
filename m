Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5F8C4320A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E180E60F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbhHIXF0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:26 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:44579 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237011AbhHIXFZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:25 -0400
Received: by mail-pj1-f48.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so2396032pjb.3
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:05:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8THQL4IBWnjCFG34wAR/rrdTZqIKDZOaWTk3GhOvU/Y=;
        b=du1bH7oY+RIClm8Ll+MxVimjoHv4bVFH1rkSduXbVBbY5GeuCZCVMGp8W63KWN7rkR
         wy9bFeCzS4gfp2yopfzDYQm329fuaXQ/aa9mVp8pc1ah8RgjSXjSn2fWBHSfIMgzez0I
         fYLMs2aFx34ySupL/L2pvvPlMT/ZZMJqHK7BKuu7xW2QyR2YpdsoqhmMtgoRNGYkZpR6
         JHbIxmgpYskFnvLDk+tvSIafZtU1mWbzrhTPaHSW6WZ3VR2APpDxcvtf4YWT+Xv4Ra+K
         6OOFEiTjtk50bA16Rh54+rtRheeQCcs9oVMepg5A7fKu7cMKvvVVJKtz0lKToDEbnSOK
         8cQg==
X-Gm-Message-State: AOAM533ku8tRJMWQr/RgtHTr0tHUSen6afm9ygfXLGMMWrKThQ09LbUq
        qIxXgy/TRe75qfcNkytzpNBf4Wy1CHlu4Q==
X-Google-Smtp-Source: ABdhPJwZKch0pjIwxyDxyEv2DOXzUoA1R1nhUuWMsdcSiepJjB9G+JJdrwkUJOlNTsDfjN/r8uE3gA==
X-Received: by 2002:a17:90a:514f:: with SMTP id k15mr14453983pjm.95.1628550303775;
        Mon, 09 Aug 2021 16:05:03 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:05:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 39/52] qla4xxx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:42 -0700
Message-Id: <20210809230355.8186-40-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
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
