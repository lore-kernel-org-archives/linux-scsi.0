Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A1F2C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 208346109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbhDTALU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:20 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:37538 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233990AbhDTAK4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:56 -0400
Received: by mail-pf1-f178.google.com with SMTP id y62so489972pfg.4
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ASLqISoXi80AzlK2K9XJj9n3xm0g6SWAmvntVC9g0Gk=;
        b=j9ipiC47W8YEu1DfbsEhQMnIQX2SSUgphCkTnq6Rhjn/CnEbYMBdUdOSXKjv/w8KUr
         23ECrlsPr2AJDLuzy6WzBZC32pCPKd4DSC1g7lqupuKU/gSUQIVcNq9hhHY2jx4MXZxA
         Q2tA7eEOMO2HhjKZWxfB6LCs/aAy7feGq3R5i8b+M94br8+x4PUpWn8sPSMVamOXDlXP
         yBTs+y6amSSggFUohv6jNHBVvhlVHyVnCF6ng/SOZTcQwwW+HqB+qiNcgDOyRygNLZPy
         8bmjHNVCUjmAucClsiX5kcvthRXaRWYiG0NE8BT5/JjEwncMDFHXC34u4OfZnOAdQwZi
         Kc+Q==
X-Gm-Message-State: AOAM531+mbtGUwVBUQreRdRxP4A+kEDTjEEZrpyH2Rqxom7I5u05b7nJ
        pPxyzWjgRt4TE5yjiJwae1w=
X-Google-Smtp-Source: ABdhPJygOp54mQGAJIcC1AwT8iQ+Wv3CiOT8VbMUVddqnClGwbXAV0F6WsSs+0VBfFmspOxaJdJgww==
X-Received: by 2002:aa7:9108:0:b029:251:7caf:cec with SMTP id 8-20020aa791080000b02902517caf0cecmr21777158pfh.13.1618877424106;
        Mon, 19 Apr 2021 17:10:24 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 080/117] ppa: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:08:08 -0700
Message-Id: <20210420000845.25873-81-bvanassche@acm.org>
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
 drivers/scsi/ppa.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index aa41f7ac91cb..9f1f6e6f01a6 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -164,7 +164,7 @@ static inline void ppa_fail(ppa_struct *dev, int error_code)
 {
 	/* If we fail a device then we trash status / message bytes */
 	if (dev->cur_cmd) {
-		dev->cur_cmd->result = error_code << 16;
+		dev->cur_cmd->status.combined = error_code << 16;
 		dev->failed = 1;
 	}
 }
@@ -625,7 +625,7 @@ static void ppa_interrupt(struct work_struct *work)
 	}
 	/* Command must of completed hence it is safe to let go... */
 #if PPA_DEBUG > 0
-	switch ((cmd->result >> 16) & 0xff) {
+	switch ((cmd->status.combined >> 16) & 0xff) {
 	case DID_OK:
 		break;
 	case DID_NO_CONNECT:
@@ -654,7 +654,7 @@ static void ppa_interrupt(struct work_struct *work)
 		break;
 	default:
 		printk(KERN_WARNING "ppa: bad return code (%02x)\n",
-		       (cmd->result >> 16) & 0xff);
+		       (cmd->status.combined >> 16) & 0xff);
 	}
 #endif
 
@@ -765,7 +765,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 		fallthrough;
 
 	case 6:		/* Phase 6 - Read status/message */
-		cmd->result = DID_OK << 16;
+		cmd->status.combined = DID_OK << 16;
 		/* Check for data overrun */
 		if (ppa_wait(dev) != (unsigned char) 0xf0) {
 			ppa_fail(dev, DID_ERROR);
@@ -775,7 +775,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 			/* Check for optional message byte */
 			if (ppa_wait(dev) == (unsigned char) 0xf0)
 				ppa_in(dev, &h, 1);
-			cmd->result =
+			cmd->status.combined =
 			    (DID_OK << 16) + (h << 8) + (l & STATUS_MASK);
 		}
 		return 0;	/* Finished */
@@ -799,7 +799,7 @@ static int ppa_queuecommand_lck(struct scsi_cmnd *cmd,
 	dev->jstart = jiffies;
 	dev->cur_cmd = cmd;
 	cmd->scsi_done = done;
-	cmd->result = DID_ERROR << 16;	/* default return code */
+	cmd->status.combined = DID_ERROR << 16;	/* default return code */
 	cmd->SCp.phase = 0;	/* bus free */
 
 	schedule_delayed_work(&dev->ppa_tq, 0);
