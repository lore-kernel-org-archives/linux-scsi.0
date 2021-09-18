Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01133C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE81F60F51
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344073AbhIRAId (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:33 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:46981 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344221AbhIRAI3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:29 -0400
Received: by mail-pf1-f169.google.com with SMTP id 203so2788623pfy.13
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ovQNV5qhptRxXIfbyuBvRP4QwlTK0iTUTJpC6mbpyM4=;
        b=rfD2dsaNWnUfVD75o+EO3kS9o5ezy+/D2MIAKWe9QAUuS2oCf2Pu7nbU+dBWdHN/NL
         E9XrVZBy0m7eeGnBxzqdS2bbUKA09dQ3h8EKB3BwtMPhptQk/Xo6WxsJ0IpsVWgotvne
         p5r/vHQrgIOl+3lSxL3nMV57fFMlCzL9eOmHCPXl8ttX/sqoWwS5pwWWcwnMNlLLJ345
         AUZrV27P7UVE23W2NJmSvT/NqN5tw6vVJwqkAxzd5hctud2o9YDWAZezlR7mWAEqSIuB
         ptn//p2S65eUt9oaQFtnk8I67R/LCbnUV9uGgnBaGlR53c6zNQOKTMNBtRqwzSIG8WPB
         qBZw==
X-Gm-Message-State: AOAM532OrOz5KYOvD4LAEmGhB6PRwdIgbZ9KdDIZSFHwOfUNCa9mGO3s
        CRAaQl2VqdHY7McO2hNrSVA=
X-Google-Smtp-Source: ABdhPJy3MqrejEwN6HMD1gAGaqVsIMb/lgcWVqbIBCaarLudAEkq56teCL41IQwmA6VwLQhNiIdGBg==
X-Received: by 2002:a62:4e4a:0:b0:444:59c3:665e with SMTP id c71-20020a624e4a000000b0044459c3665emr8335819pfb.0.1631923626712;
        Fri, 17 Sep 2021 17:07:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 30/84] dpt_i2o: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:13 -0700
Message-Id: <20210918000607.450448-31-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
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
 
 
