Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A75DCC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 910B7610C7
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344651AbhIRAJG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:06 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:37488 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344529AbhIRAJA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:00 -0400
Received: by mail-pj1-f41.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so10462065pjb.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DJBgsWve89r6EQiYQIKa9laf17NfQSydbKr57a9+zWo=;
        b=iO5DMHa7X1ho7KFhTIAr65luJ3wDy1deqFsQ3p0om8BvP9Kshjm599ivw7sBKV33hz
         nhvRCbtJBXEIZjKQKQ6vpXxkLmFE/O+vZ6JsB4F+NBLNq75u4gH7Nxv9BCcE4LY+w2JS
         sz7tY15KQHjkAuUNJK/X9v8907muta46kt3lrVw45+pv3oz+jaGxq5IwToug7rVKmts0
         wjEZHCDOstwp1nxSyZ4Gu446IdawaJ+4zmRDYA0FJZua2vyX6RdiXnoek/1o5vRY2iSG
         xLyXXX5YRFpC4thovYbMz35lHxjG4eYvknPtIatz1L/1RUDebWbBiNCI+CSWnSV7kEw5
         WnYA==
X-Gm-Message-State: AOAM532SPoOumWouZJsVFuuNOu+q3Wb9AVIYca1Uwe/uMCceS4LwsEhc
        ZXQ+iJEPeUImzSsOm1QgQrQ=
X-Google-Smtp-Source: ABdhPJxcP1wXIZ2uv3otumfzuJL8pNO7dK27FNRvGC4TNWpmfRtxJ6KzSyD1X5suEowgzM0oyQSVng==
X-Received: by 2002:a17:90a:ef0b:: with SMTP id k11mr24289548pjz.209.1631923657741;
        Fri, 17 Sep 2021 17:07:37 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 49/84] megaraid: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:32 -0700
Message-Id: <20210918000607.450448-50-bvanassche@acm.org>
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
 drivers/scsi/megaraid.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 56910e94dbf2..c4ea833586e0 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -380,9 +380,6 @@ megaraid_queue_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 
 	adapter = (adapter_t *)scmd->device->host->hostdata;
 
-	scmd->scsi_done = done;
-
-
 	/*
 	 * Allocate and build a SCB request
 	 * busy flag will be set if mega_build_cmd() command could not
@@ -586,7 +583,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 		/* have just LUN 0 for each target on virtual channels */
 		if (cmd->device->lun) {
 			cmd->result = (DID_BAD_TARGET << 16);
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 			return NULL;
 		}
 
@@ -605,7 +602,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 
 		if(ldrv_num > max_ldrv_num ) {
 			cmd->result = (DID_BAD_TARGET << 16);
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 			return NULL;
 		}
 
@@ -617,7 +614,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 			 * devices
 			 */
 			cmd->result = (DID_BAD_TARGET << 16);
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 			return NULL;
 		}
 	}
@@ -637,7 +634,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 			 */
 			if( !adapter->has_cluster ) {
 				cmd->result = (DID_OK << 16);
-				cmd->scsi_done(cmd);
+				scsi_done(cmd);
 				return NULL;
 			}
 
@@ -655,7 +652,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 			return scb;
 #else
 			cmd->result = (DID_OK << 16);
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 			return NULL;
 #endif
 
@@ -670,7 +667,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 			kunmap_atomic(buf - sg->offset);
 
 			cmd->result = (DID_OK << 16);
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 			return NULL;
 		}
 
@@ -866,7 +863,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 			if( ! adapter->has_cluster ) {
 
 				cmd->result = (DID_BAD_TARGET << 16);
-				cmd->scsi_done(cmd);
+				scsi_done(cmd);
 				return NULL;
 			}
 
@@ -889,7 +886,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 
 		default:
 			cmd->result = (DID_BAD_TARGET << 16);
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 			return NULL;
 		}
 	}
@@ -1654,7 +1651,7 @@ mega_rundoneq (adapter_t *adapter)
 		struct scsi_pointer* spos = (struct scsi_pointer *)pos;
 
 		cmd = list_entry(spos, struct scsi_cmnd, SCp);
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 	}
 
 	INIT_LIST_HEAD(&adapter->completed_list);
