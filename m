Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1514AC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F12A661179
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343717AbhIRAJD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:03 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:43897 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344276AbhIRAIq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:46 -0400
Received: by mail-pj1-f50.google.com with SMTP id k23-20020a17090a591700b001976d2db364so8536680pji.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=voPB9MyaX+yuJZJpJFu6Wk8N5p4rk7uB2b08YZfpq04=;
        b=vz2yzhYxwqDE0cI2RgXrqQZ4GRfGfhebQ3E5/ZH3vox2HCqz66zhFHm4KR5A14ZbuE
         fI9dsGE/A/Sg3ydGuBiFOhQOkZ1LDf8p8uwudT2V083wxr+je4GQbGGXikY++J9A4cBG
         hI7sbxoWl2St2Bqh7AEuSpUCR8JS5+vCZCZnTlIFGang3vYqkl8g8TdTbB5z+f+52qm3
         TrP4M896AsvTfYE7iZoIyr1I3WI+0LKGtChgyQOfVEJPhnIid3GQ9LZefbbSupjX4XlT
         q/1QBoa1C1Yzv4qdFwpcMwsYb4WClOIAzrkH7fPws5kR9bx862iVThzkLZZpFbOI2ZO+
         yP4Q==
X-Gm-Message-State: AOAM533dz8pr0AXfeC0N7112vkyB2ytgIEzRsdeBWxJqC89PnIlgcLqi
        LaFAzfa/lgbmCwUWVkJoM84=
X-Google-Smtp-Source: ABdhPJwSitQDAzyMUtrbPTs61tqA0nwjZBZrXUManoGSlToXT/7mh0IO5KgNHzgttFXRoQhQcT3JcQ==
X-Received: by 2002:a17:90a:a513:: with SMTP id a19mr24584577pjq.26.1631923643933;
        Fri, 17 Sep 2021 17:07:23 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 42/84] ips: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:25 -0700
Message-Id: <20210918000607.450448-43-bvanassche@acm.org>
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
 drivers/scsi/ips.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index cdd94fb2aab7..0c93ec359e9b 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -936,7 +936,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 
 		while ((scb = ips_removeq_scb_head(&ha->scb_activelist))) {
 			scb->scsi_cmd->result = DID_ERROR << 16;
-			scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+			scsi_done(scb->scsi_cmd);
 			ips_freescb(ha, scb);
 		}
 
@@ -946,7 +946,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 
 		while ((scsi_cmd = ips_removeq_wait_head(&ha->scb_waitlist))) {
 			scsi_cmd->result = DID_ERROR;
-			scsi_cmd->scsi_done(scsi_cmd);
+			scsi_done(scsi_cmd);
 		}
 
 		ha->active = FALSE;
@@ -965,7 +965,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 
 		while ((scb = ips_removeq_scb_head(&ha->scb_activelist))) {
 			scb->scsi_cmd->result = DID_ERROR << 16;
-			scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+			scsi_done(scb->scsi_cmd);
 			ips_freescb(ha, scb);
 		}
 
@@ -975,7 +975,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 
 		while ((scsi_cmd = ips_removeq_wait_head(&ha->scb_waitlist))) {
 			scsi_cmd->result = DID_ERROR << 16;
-			scsi_cmd->scsi_done(scsi_cmd);
+			scsi_done(scsi_cmd);
 		}
 
 		ha->active = FALSE;
@@ -994,7 +994,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 
 	while ((scb = ips_removeq_scb_head(&ha->scb_activelist))) {
 		scb->scsi_cmd->result = DID_RESET << 16;
-		scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+		scsi_done(scb->scsi_cmd);
 		ips_freescb(ha, scb);
 	}
 
@@ -1064,8 +1064,6 @@ static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *)
 		return (0);
 	}
 
-	SC->scsi_done = done;
-
 	DEBUG_VAR(2, "(%s%d): ips_queue: cmd 0x%X (%d %d %d)",
 		  ips_name,
 		  ha->host_num,
@@ -1099,7 +1097,7 @@ static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *)
 			ha->ioctl_reset = 1;	/* This reset request is from an IOCTL */
 			__ips_eh_reset(SC);
 			SC->result = DID_OK << 16;
-			SC->scsi_done(SC);
+			scsi_done(SC);
 			return (0);
 		}
 
@@ -2579,7 +2577,7 @@ ips_next(ips_ha_t * ha, int intr)
 		case IPS_FAILURE:
 			if (scb->scsi_cmd) {
 				scb->scsi_cmd->result = DID_ERROR << 16;
-				scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+				scsi_done(scb->scsi_cmd);
 			}
 
 			ips_freescb(ha, scb);
@@ -2587,7 +2585,7 @@ ips_next(ips_ha_t * ha, int intr)
 		case IPS_SUCCESS_IMM:
 			if (scb->scsi_cmd) {
 				scb->scsi_cmd->result = DID_OK << 16;
-				scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+				scsi_done(scb->scsi_cmd);
 			}
 
 			ips_freescb(ha, scb);
@@ -2712,7 +2710,7 @@ ips_next(ips_ha_t * ha, int intr)
 		case IPS_FAILURE:
 			if (scb->scsi_cmd) {
 				scb->scsi_cmd->result = DID_ERROR << 16;
-				scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+				scsi_done(scb->scsi_cmd);
 			}
 
 			if (scb->bus)
@@ -2723,7 +2721,7 @@ ips_next(ips_ha_t * ha, int intr)
 			break;
 		case IPS_SUCCESS_IMM:
 			if (scb->scsi_cmd)
-				scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+				scsi_done(scb->scsi_cmd);
 
 			if (scb->bus)
 				ha->dcdb_active[scb->bus - 1] &=
@@ -3206,7 +3204,7 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 			case IPS_FAILURE:
 				if (scb->scsi_cmd) {
 					scb->scsi_cmd->result = DID_ERROR << 16;
-					scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+					scsi_done(scb->scsi_cmd);
 				}
 
 				ips_freescb(ha, scb);
@@ -3214,7 +3212,7 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 			case IPS_SUCCESS_IMM:
 				if (scb->scsi_cmd) {
 					scb->scsi_cmd->result = DID_ERROR << 16;
-					scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+					scsi_done(scb->scsi_cmd);
 				}
 
 				ips_freescb(ha, scb);
@@ -3231,7 +3229,7 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 		ha->dcdb_active[scb->bus - 1] &= ~(1 << scb->target_id);
 	}
 
-	scb->scsi_cmd->scsi_done(scb->scsi_cmd);
+	scsi_done(scb->scsi_cmd);
 
 	ips_freescb(ha, scb);
 }
