Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE056C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2B7D61151
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhEXDLj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:39 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:33618 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbhEXDLg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:36 -0400
Received: by mail-pf1-f169.google.com with SMTP id f22so11309292pfn.0
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:10:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ogxKBVUA+qnZSFDIFMlYzpoeiGL6xTjFQ59hVayAuMc=;
        b=qG6zAM5J1/WshXJoIs0v1m9pqIMSPIjVVK/h4GzOe1wqHIHYNTF47caPRYyC8xtXIw
         AmBBlyhBMM/xhy19OH0ThTsnk4YsCHUP+5MIhqTBn8wnJ7uoxN4TEwBAU8p3PJTG5y0g
         WWIG+9ZXVJKx/e2QBXB/j3o0ru1oNEzRPE4VwVElDOxkD+PBGzJlbTfqpd4e6zmWK7rt
         YyNoaNDY4S/q3cffnMrqfFr6xsdchKG6DJFFg0ue605hUY1+zbRVn3Fd16vE4Iw2m9vp
         eMwJAmDkxz82VBKbktbq4n3VTG1lTZko9zB6q+UlZns5F3VgLmetda3ZLXFrRO6BERxo
         7UtQ==
X-Gm-Message-State: AOAM530CIaIQjNef4FxTJ9WPuudyGQApRnsi2fI3nmiLoVBwSafacG5R
        m++hBHy9FzS9pC1ndvWyJGQ=
X-Google-Smtp-Source: ABdhPJzzandR2zP4FfAaGz/pe7m8oNO+zssXIAfEWG8AhX37FdfFAScVCeG4LkqIbpVUdaK1t6RGJg==
X-Received: by 2002:a62:2e04:0:b029:2db:4c99:614f with SMTP id u4-20020a622e040000b02902db4c99614fmr22430569pfu.47.1621825808733;
        Sun, 23 May 2021 20:10:08 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:10:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 38/51] qla4xxx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:43 -0700
Message-Id: <20210524030856.2824-39-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
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
