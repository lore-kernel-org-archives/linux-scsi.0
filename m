Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55BB3C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F92A6140F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347164AbhI2WJX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:23 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:36393 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347135AbhI2WJR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:17 -0400
Received: by mail-pj1-f44.google.com with SMTP id u1-20020a17090ae00100b0019ec31d3ba2so5220418pjy.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DJBgsWve89r6EQiYQIKa9laf17NfQSydbKr57a9+zWo=;
        b=sNNMN0xVHcdehw9KLcR6jX1gIvBjU8Zc9gegL5Mj3rmQe+V8ZTJbGzQdA3aYJfVwG/
         oKmI/0r3YBVMlG3xWnZvzMGhUR+e6BgNNTwDquHJdEXw+J+99/Ld/qFPuQ3S4UOtLPXV
         XJSt5fOiomEQBPxSTcXBT4vdcjpXcBS7ifX5yEEAkfCMTIYE+xHDo5BX7+BSGjS4Beid
         Iv5g6CcqtzvYDjXdq0Tnya7yQ3KqrM4Cd5k5/zd0B4xqJAfsZ7Kqq4CRl3GBBdfqcSy/
         EuvF/nlmuvaUcXlWNzdd/JBTnhB5naBU8IGkWI1eJbz1pV+FdtPQx3PXAlTzdhMxIoBo
         b8XQ==
X-Gm-Message-State: AOAM533rq06GENDqVcYW7a8wBTersO5A9fpYVWlHzT5iTc9COTkmaqS8
        wvp89eA0EdfgQHcsOeF8/Lc=
X-Google-Smtp-Source: ABdhPJy67BRlHFSjuoD85XQxerTrsXo7WP6WFaDLMZL9aSB4QxGnVY1Gy72I8IfPM5M7M3DC3rUnjQ==
X-Received: by 2002:a17:90a:d802:: with SMTP id a2mr8982791pjv.194.1632953255464;
        Wed, 29 Sep 2021 15:07:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 49/84] megaraid: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:25 -0700
Message-Id: <20210929220600.3509089-50-bvanassche@acm.org>
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
