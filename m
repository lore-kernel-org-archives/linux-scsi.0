Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B86C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0702D6143F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbhENVgX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:23 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:42828 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbhENVgW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:22 -0400
Received: by mail-pf1-f169.google.com with SMTP id h127so642000pfe.9
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TlBSfGOkRDloBNFq8/A2UkRZK3YjZI1/M4VMfWPNoUw=;
        b=dWCBQTzi/WtWyi2Znnc+jggEhLSwKlyzdtVzDPvs44XcxRwrTfTXHnRi0nXcDprCqf
         hUChReBTY5odXek72Myj1cLcglq27aOePq9aslMVkTOPwq7bBbF9dB9EZYslgy8V/cu8
         BQgYje0CElE7jBCed6XymI95ov+TZFS3Bri8MEfYeLK3IkpUrhXyKGn8dioFZsxg14Dx
         gpe1ztGNdWe+2y+lcKnN00OShqaEEl3wi+Z7vW/4rRf2FeWA3eQN08Nh2AjECcm9Ovjj
         inZq8WXEbl3ePSeLfnVgkEj5GEnAMBHk59ZsjhgNwoANchAKhx2XXl6R8gQMhkecxgqJ
         fxag==
X-Gm-Message-State: AOAM530PNMAIM2k8ksd3kYjz12yfVttlQJqYQtd5zTVlX/ZcjP0K48ya
        C9UIJh86S/SmTX8vNRy8QqKV92xLpLXVzg==
X-Google-Smtp-Source: ABdhPJzdkJ4Zar06owU9U2d2BqmXsVUx5jgjQ7lTYebuFrzoaksdIA4VWJ+xl0YgoebWQpuy8OQShQ==
X-Received: by 2002:a65:48c5:: with SMTP id o5mr49252113pgs.101.1621028109381;
        Fri, 14 May 2021 14:35:09 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 37/50] qla4xxx: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:32:52 -0700
Message-Id: <20210514213356.5264-38-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla4xxx/ql4_iocb.c | 2 +-
 drivers/scsi/qla4xxx/ql4_os.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index cbd1e6ffcd67..eac4b201360b 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -288,7 +288,7 @@ int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb)
 	/* Acquire hardware specific lock */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	index = (uint32_t)cmd->request->tag;
+	index = blk_req(cmd)->tag;
 
 	/*
 	 * Check to see if adapter is online before placing request on
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ad3afe30f617..8429ac66305d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -9282,7 +9282,7 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 	DEBUG2(printk(KERN_INFO
 		      "scsi%ld: DEVICE_RESET cmd=%p jiffies = 0x%lx, to=%x,"
 		      "dpc_flags=%lx, status=%x allowed=%d\n", ha->host_no,
-		      cmd, jiffies, cmd->request->timeout / HZ,
+		      cmd, jiffies, blk_req(cmd)->timeout / HZ,
 		      ha->dpc_flags, cmd->result, cmd->allowed));
 
 	rval = qla4xxx_isp_check_reg(ha);
@@ -9349,7 +9349,7 @@ static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
 	DEBUG2(printk(KERN_INFO
 		      "scsi%ld: TARGET_DEVICE_RESET cmd=%p jiffies = 0x%lx, "
 		      "to=%x,dpc_flags=%lx, status=%x allowed=%d\n",
-		      ha->host_no, cmd, jiffies, cmd->request->timeout / HZ,
+		      ha->host_no, cmd, jiffies, blk_req(cmd)->timeout / HZ,
 		      ha->dpc_flags, cmd->result, cmd->allowed));
 
 	rval = qla4xxx_isp_check_reg(ha);
