Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B5FC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A7776109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbhDTAKp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:45 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:53066 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhDTAK3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:29 -0400
Received: by mail-pj1-f46.google.com with SMTP id lr7so2720706pjb.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jfJ2P62rQrrg/7/aHOa0ytPQGyb23H0tV8yY2Ykjs8M=;
        b=NVyiCaGoXC7meUqozYCXjnZ0NlWNcmLzHSxJIhV+Kmfi6eNXmkLMJIJjKdLem1JXZh
         +/fOV0fNiSmo4RsbiHS/YPwkCa2stVeNfzgcu41+45bo9dFDmNKstYJblrezF+4qs2Mz
         77BvCXXEQ6Ax4ZZu57qIfiXvFZ/3pKtdeknd3dEFO3Iyx83tkF1SErVWPUFrOzgA+nbc
         wQp8Hiav/17ojMiduTQ52CfJr0eXTG7zT8RvcAvIq7kUuP6j1DmHPVffwO0p4tbsURVE
         93DQfRcyHtAaKPjTZ2xD9cjFi+ai+dwydQ4fZWbRXWNHPd6Jz1bTdFhgH4YGR65wSgrY
         KM6A==
X-Gm-Message-State: AOAM531JgcLP7v33ltAzoR44oYlWpyfpRS6bdjHbCzNpfPY3DtISE6jt
        +DodcgoY9AD1mElyEV0saUY=
X-Google-Smtp-Source: ABdhPJxje7MqQdzNwRHe8N3bwNWlPIQmxeOGKrXkTCbz5yzLdxV34fMuHj7RhrF2JjEMHnCDpOuHjA==
X-Received: by 2002:a17:90a:94c4:: with SMTP id j4mr1746469pjw.14.1618877398838;
        Mon, 19 Apr 2021 17:09:58 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:58 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 058/117] imm: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:46 -0700
Message-Id: <20210420000845.25873-59-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/imm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 862d35a098cf..a425127aa35f 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -158,7 +158,7 @@ imm_fail(imm_struct *dev, int error_code)
 {
 	/* If we fail a device then we trash status / message bytes */
 	if (dev->cur_cmd) {
-		dev->cur_cmd->result = error_code << 16;
+		dev->cur_cmd->status.combined = error_code << 16;
 		dev->failed = 1;
 	}
 }
@@ -729,7 +729,7 @@ static void imm_interrupt(struct work_struct *work)
 	}
 	/* Command must of completed hence it is safe to let go... */
 #if IMM_DEBUG > 0
-	switch ((cmd->result >> 16) & 0xff) {
+	switch ((cmd->status.combined >> 16) & 0xff) {
 	case DID_OK:
 		break;
 	case DID_NO_CONNECT:
@@ -758,7 +758,7 @@ static void imm_interrupt(struct work_struct *work)
 		break;
 	default:
 		printk("imm: bad return code (%02x)\n",
-		       (cmd->result >> 16) & 0xff);
+		       (cmd->status.combined >> 16) & 0xff);
 	}
 #endif
 
@@ -894,7 +894,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
 			/* Check for optional message byte */
 			if (imm_wait(dev) == (unsigned char) 0xb8)
 				imm_in(dev, &h, 1);
-			cmd->result = (DID_OK << 16) | (l & STATUS_MASK);
+			cmd->status.combined = (DID_OK << 16) | (l & STATUS_MASK);
 		}
 		if ((dev->mode == IMM_NIBBLE) || (dev->mode == IMM_PS2)) {
 			w_ctr(ppb, 0x4);
@@ -923,7 +923,7 @@ static int imm_queuecommand_lck(struct scsi_cmnd *cmd,
 	dev->jstart = jiffies;
 	dev->cur_cmd = cmd;
 	cmd->scsi_done = done;
-	cmd->result = DID_ERROR << 16;	/* default return code */
+	cmd->status.combined = DID_ERROR << 16;	/* default return code */
 	cmd->SCp.phase = 0;	/* bus free */
 
 	schedule_delayed_work(&dev->imm_tq, 0);
