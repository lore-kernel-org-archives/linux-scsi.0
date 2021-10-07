Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56DF3C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4427F61074
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242399AbhJGUcw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:52 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:40762 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242220AbhJGUcv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:51 -0400
Received: by mail-pl1-f179.google.com with SMTP id j15so4693821plh.7
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DJBgsWve89r6EQiYQIKa9laf17NfQSydbKr57a9+zWo=;
        b=ckTX6jM/nre/QAJkeJBmZiGOdKLFnfSks93rx/hFusOHY7FAxWTcmUcWtmdPQbTfcG
         aalvUcDdoPE4oLxN8tp8J7+ZITh+27HSVoKqHxsneG/ybjurTTbBUyLNmIVCgG2dlY2G
         Letq07Ok7ot6shnLDyJDI29Ls0k0QxHXb22SMxGryo6PCDJUk+y6UcsEHfXQ7GnxKeql
         lMbBNRYmIl8gF+M7urWmC2mf9zq5Z88K2wGOckoEzD7zQb+GckGSvSPHbwA/7FtCgHGl
         zCfKLf9I9W3ekjmunDbWF6BKt6YGujkVM32aOHYfYG0sQ7tFjg2MsPD0nKJqWKBmC+0C
         WWVw==
X-Gm-Message-State: AOAM530p3N11fNGeRcT8iPDUXiOour6zoxaMBLIH4/opyI2VAY5qse3s
        hjTKS/nZCey9O2LINI9J3No=
X-Google-Smtp-Source: ABdhPJxTcykaH9zegMabculSVUnfSGgYxWzU0LoV3ou14Jp2SwGLsqK5XDiJbqyRywBbxZpJoI6rzw==
X-Received: by 2002:a17:90a:910:: with SMTP id n16mr7675715pjn.246.1633638657631;
        Thu, 07 Oct 2021 13:30:57 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 49/88] megaraid: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:44 -0700
Message-Id: <20211007202923.2174984-50-bvanassche@acm.org>
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
