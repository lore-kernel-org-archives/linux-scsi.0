Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB47DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C14B860E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242282AbhJGUcX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:23 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:41849 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbhJGUcU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:20 -0400
Received: by mail-pj1-f50.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so6139679pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ovQNV5qhptRxXIfbyuBvRP4QwlTK0iTUTJpC6mbpyM4=;
        b=bkDp6yDkKxeZF6UeGlQgqOUFmTeq1y98Rhk0xVbKAc55hMj5zEntLx/Y7JSyEmffGc
         CPxPJjVoknLo3397wsll3y+Xy34aWxKow2vjeoRHMUOI4dvErGSYIUCHydOzUbZrIzp4
         h/Ea/XTphdK/Nu6Sg8AalsjI06JcS/Z9hsWtj2Kh9cFbTRKWCYS7ni/FcDGNGSJiWk+c
         6uXgXyJ1hIPdTrV3sAR2JRXCF0yX4IPXBRfbWM6EunV4wZzduScdntgll8t9wNHh795/
         oRwRbylCKKvLUu8HhbNTuWF0kNSSwPABGqEVvdKJVT0uwISJtXDudzGQ+a7tLrbh9xup
         GbfA==
X-Gm-Message-State: AOAM531JNFJd2rcRaUt8ESdEs3uIkOKnpn9J9zJ8/M16YGs6iVBflOS9
        xH+nctH37O42i0tVw7Ak6og=
X-Google-Smtp-Source: ABdhPJx9y4Y6Fpbkp9XhZmaudFHiNfl7VPnFT6PlGoPze4rUMdM8bfH+SBcYdF0MiTgzjsbwPGMCDQ==
X-Received: by 2002:a17:902:b7c8:b0:13e:ae33:6862 with SMTP id v8-20020a170902b7c800b0013eae336862mr5876058plz.13.1633638626298;
        Thu, 07 Oct 2021 13:30:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 29/88] dpt_i2o: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:24 -0700
Message-Id: <20211007202923.2174984-30-bvanassche@acm.org>
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
 drivers/scsi/dpt_i2o.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 7af96d14c9bc..1f00afcfe440 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -421,7 +421,6 @@ static int adpt_queue_lck(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd
 	adpt_hba* pHba = NULL;
 	struct adpt_device* pDev = NULL;	/* dpt per device information */
 
-	cmd->scsi_done = done;
 	/*
 	 * SCSI REQUEST_SENSE commands will be executed automatically by the 
 	 * Host Adapter for any errors, so they should not be executed 
@@ -431,7 +430,7 @@ static int adpt_queue_lck(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd
 
 	if ((cmd->cmnd[0] == REQUEST_SENSE) && (cmd->sense_buffer[0] != 0)) {
 		cmd->result = (DID_OK << 16);
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 		return 0;
 	}
 
@@ -456,7 +455,7 @@ static int adpt_queue_lck(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd
 			// TODO: if any luns are at this bus, scsi id then fake a TEST_UNIT_READY and INQUIRY response 
 			// with type 7F (for all luns less than the max for this bus,id) so the lun scan will continue.
 			cmd->result = (DID_NO_CONNECT << 16);
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 			return 0;
 		}
 		cmd->device->hostdata = pDev;
@@ -2227,7 +2226,7 @@ static s32 adpt_scsi_to_i2o(adpt_hba* pHba, struct scsi_cmnd* cmd, struct adpt_d
 			printk(KERN_WARNING"%s: scsi opcode 0x%x not supported.\n",
 			     pHba->name, cmd->cmnd[0]);
 			cmd->result = (DID_ERROR <<16);
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 			return 	0;
 		}
 	}
@@ -2451,9 +2450,7 @@ static void adpt_i2o_scsi_complete(void __iomem *reply, struct scsi_cmnd *cmd)
 
 	cmd->result |= (dev_status);
 
-	if(cmd->scsi_done != NULL){
-		cmd->scsi_done(cmd);
-	} 
+	scsi_done(cmd);
 }
 
 
