Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73158C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ACA461406
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347125AbhI2WIu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:50 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:34682 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347037AbhI2WIq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:46 -0400
Received: by mail-pl1-f181.google.com with SMTP id b22so2540264pls.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ovQNV5qhptRxXIfbyuBvRP4QwlTK0iTUTJpC6mbpyM4=;
        b=wEtIO7vb3LBqZBOu4rS4kjeLvr9RdubZGE+p7QPeIBcNvYdVnWvRyipY0FXJ1tL2uf
         OGkeOc/MnFvh7vIZgHi79VJWQdGL/Zr/HddW6MkikuspMMNafNca5KxY2ELDoSX7xOZ2
         t+qkAe/QSFku3d8e7fd0+XUepd1kHOOq426yIzaTIexdSGdeEdd4jEQexWjJDfYIZlvc
         GhuXzirUkZ1luasIyuOE3CGvpJ/49JPKzBw1O+o8sJwR08jEfAaP4STnSMXaGiNzP4ru
         426Fqk+V41IJxtuvXbE3j2PCHsLUETN8Mcv5J4bRTBWD5+SKi5RtyVnwDQbzVyzfT74O
         P4Zg==
X-Gm-Message-State: AOAM532xLYAvsT/ClU/ocZ4Svbd0MTO9Zq34DM82Ncv4P7IjsobS2jrD
        k+XAamWkgv2X29zbwE4uOzfWIJxaTdI=
X-Google-Smtp-Source: ABdhPJyu4DDb1YBUQyiDNp5Cvb+INWy4fSIzw1sQrVJMuHyX7d3cKyB9i65ZXc/V0pyzoKIhL4oDow==
X-Received: by 2002:a17:90a:1d8:: with SMTP id 24mr8959674pjd.69.1632953225135;
        Wed, 29 Sep 2021 15:07:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 29/84] dpt_i2o: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:05 -0700
Message-Id: <20210929220600.3509089-30-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
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
 
 
