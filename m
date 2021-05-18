Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1220DC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA67D611AC
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351308AbhERRrE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:04 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:42542 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351315AbhERRrA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:47:00 -0400
Received: by mail-pg1-f171.google.com with SMTP id f22so6589443pgb.9
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ogxKBVUA+qnZSFDIFMlYzpoeiGL6xTjFQ59hVayAuMc=;
        b=S6NKjTlh7aD3td44oJltLzDk3yFF2getM6ZMaS2F4X/8n2dPuBl0O8cvo2BrPJ2+uB
         u2jixsRornaEh52+Mg2TF247S+NJR7+2b0jk/XPh7yo+1I1p+F9AptFdXeRRHGAOTbLZ
         ZQA1dqK1C6PSB5HU/zfQ/681CoWwOfekqdO9P6C4gMpjL+DQ/3qbv9uC0fChRBZhrMsS
         3NRjj3gj6gk4Ho5VRwFDoknXUN7bAHc7kpI5I1ZZ5U0L9Qj/MAjOjZ/2JOqBn6hLpodf
         KjPIBz708rxdu333XLeRYC3WQqkHBYLO51NOVMSqBcsFhCyR3tOi+A+xIiaW/PWKfVMR
         +WEw==
X-Gm-Message-State: AOAM530oIP7U4+L1BeB5+sNeMVikEB4r8X+fSct6rgQSnYOlZkGvnVWl
        VKMMeu7RtgZH+ue+8Fe1hOU=
X-Google-Smtp-Source: ABdhPJz5c0SG9XRuOcF7oqxD0IuQVELqfHbqQbSsuIvgVNrp2SCayuyXAzTiz92W+YsEWEM9xPKfTA==
X-Received: by 2002:a62:bd07:0:b029:2df:2c0a:d5e9 with SMTP id a7-20020a62bd070000b02902df2c0ad5e9mr974670pff.7.1621359942044;
        Tue, 18 May 2021 10:45:42 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 37/50] qla4xxx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:37 -0700
Message-Id: <20210518174450.20664-38-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
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
index cbd1e6ffcd67..d2e450831837 100644
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
index ad3afe30f617..88a37dacf90f 100644
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
