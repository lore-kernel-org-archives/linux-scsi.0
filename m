Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D8BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C5F960E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242246AbhJGUcv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:51 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:43877 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242220AbhJGUcu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:50 -0400
Received: by mail-pl1-f175.google.com with SMTP id y1so4640752plk.10
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PHJESjgdyxa26Di0j/uGul1OKjj6KfkU4+ZM7netnEc=;
        b=Mm/2PqidKWeS/XB+w3fQhaAJIXlO56jf3YCzk2Rj99xv4IJmEhdYkUuNB+BIfoaeB6
         CXq29sGXsB97C62ifYw4yUiuNRCeUeYb+zpw2VEuPjMuOaP6TCnzNitfGFuCiVJVR3n+
         LJIF7a5OTkL9WpF+K4ahn2CZh31368adNG/GfClZuNCmcRyZukahJgThHTL6J1xKFC7w
         tNB3bIMByZ4DBMNnyFAX154HWwN91F8ms9UUUtRcbAf0IG7fZkLHwvljU9XDhvg9yWDy
         uzvNAFscUa7jLRhr0wsNClDlqdlabz8JcKr0Y+RBpDAYryVIP8HJS0QoTP271QyE2Wrp
         rJ6A==
X-Gm-Message-State: AOAM532UcjRbIM9Ayv/St9HPuyotzSXCWhSwZrf79c9IREVtsFeOuuWR
        rqkmyW7IT/dljmPFaQwzUig=
X-Google-Smtp-Source: ABdhPJwvcVZtxzJyxEdwft3v53ohdk4cX8y72OqjFV4urfMNt0nmbImLrr7tI43hc5grHxs0WPfBNA==
X-Received: by 2002:a17:90b:4d09:: with SMTP id mw9mr7184929pjb.100.1633638656190;
        Thu, 07 Oct 2021 13:30:56 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 48/88] megaraid: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:43 -0700
Message-Id: <20211007202923.2174984-49-bvanassche@acm.org>
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
 drivers/scsi/megaraid/megaraid_mbox.c       |  9 ++++-----
 drivers/scsi/megaraid/megaraid_sas_base.c   | 16 ++++++++--------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  6 +++---
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index d20c2e4ee793..705c5027ba91 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1440,7 +1440,6 @@ megaraid_queue_command_lck(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd
 	int		if_busy;
 
 	adapter		= SCP2ADAPTER(scp);
-	scp->scsi_done	= done;
 	scp->result	= 0;
 
 	/*
@@ -2358,7 +2357,7 @@ megaraid_mbox_dpc(unsigned long devp)
 		megaraid_dealloc_scb(adapter, scb);
 
 		// send the scsi packet back to kernel
-		scp->scsi_done(scp);
+		scsi_done(scp);
 	}
 
 	return;
@@ -2416,7 +2415,7 @@ megaraid_abort_handler(struct scsi_cmnd *scp)
 				scb->sno, scb->dev_channel, scb->dev_target));
 
 			scp->result = (DID_ABORT << 16);
-			scp->scsi_done(scp);
+			scsi_done(scp);
 
 			megaraid_dealloc_scb(adapter, scb);
 
@@ -2446,7 +2445,7 @@ megaraid_abort_handler(struct scsi_cmnd *scp)
 				scb->dev_channel, scb->dev_target));
 
 			scp->result = (DID_ABORT << 16);
-			scp->scsi_done(scp);
+			scsi_done(scp);
 
 			megaraid_dealloc_scb(adapter, scb);
 
@@ -2566,7 +2565,7 @@ megaraid_reset_handler(struct scsi_cmnd *scp)
 			}
 
 			scb->scp->result = (DID_RESET << 16);
-			scb->scp->scsi_done(scb->scp);
+			scsi_done(scb->scp);
 
 			megaraid_dealloc_scb(adapter, scb);
 		}
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e4298bf4a482..4ae585a5b1a5 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1794,7 +1794,7 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 
 	if (instance->unload == 1) {
 		scmd->result = DID_NO_CONNECT << 16;
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	}
 
@@ -1809,7 +1809,7 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 			return SCSI_MLQUEUE_HOST_BUSY;
 		} else {
 			scmd->result = DID_NO_CONNECT << 16;
-			scmd->scsi_done(scmd);
+			scsi_done(scmd);
 			return 0;
 		}
 	}
@@ -1818,7 +1818,7 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	if (!mr_device_priv_data ||
 	    (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR)) {
 		scmd->result = DID_NO_CONNECT << 16;
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	}
 
@@ -1826,7 +1826,7 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		ld_tgt_id = MEGASAS_TARGET_ID(scmd->device);
 		if (instance->ld_tgtid_status[ld_tgt_id] == LD_TARGET_ID_DELETED) {
 			scmd->result = DID_NO_CONNECT << 16;
-			scmd->scsi_done(scmd);
+			scsi_done(scmd);
 			return 0;
 		}
 	}
@@ -1857,7 +1857,7 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	return instance->instancet->build_and_issue_cmd(instance, scmd);
 
  out_done:
-	scmd->scsi_done(scmd);
+	scsi_done(scmd);
 	return 0;
 }
 
@@ -2783,7 +2783,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 					reset_index, reset_cmd,
 					reset_cmd->scmd->cmnd[0]);
 
-				reset_cmd->scmd->scsi_done(reset_cmd->scmd);
+				scsi_done(reset_cmd->scmd);
 				megasas_return_cmd(instance, reset_cmd);
 			} else if (reset_cmd->sync_cmd) {
 				dev_notice(&instance->pdev->dev, "%p synch cmds"
@@ -3640,7 +3640,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 			atomic_dec(&instance->fw_outstanding);
 
 			scsi_dma_unmap(cmd->scmd);
-			cmd->scmd->scsi_done(cmd->scmd);
+			scsi_done(cmd->scmd);
 			megasas_return_cmd(instance, cmd);
 
 			break;
@@ -3686,7 +3686,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		atomic_dec(&instance->fw_outstanding);
 
 		scsi_dma_unmap(cmd->scmd);
-		cmd->scmd->scsi_done(cmd->scmd);
+		scsi_done(cmd->scmd);
 		megasas_return_cmd(instance, cmd);
 
 		break;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 109782e3ec44..fc90a0a687b5 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3493,7 +3493,7 @@ megasas_complete_r1_command(struct megasas_instance *instance,
 		megasas_return_cmd_fusion(instance, cmd);
 		scsi_dma_unmap(scmd_local);
 		megasas_sdev_busy_dec(instance, scmd_local);
-		scmd_local->scsi_done(scmd_local);
+		scsi_done(scmd_local);
 	}
 }
 
@@ -3634,7 +3634,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 				megasas_return_cmd_fusion(instance, cmd_fusion);
 				scsi_dma_unmap(scmd_local);
 				megasas_sdev_busy_dec(instance, scmd_local);
-				scmd_local->scsi_done(scmd_local);
+				scsi_done(scmd_local);
 			} else	/* Optimal VD - R1 FP command completion. */
 				megasas_complete_r1_command(instance, cmd_fusion);
 			break;
@@ -5013,7 +5013,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 					atomic_dec(&instance->ldio_outstanding);
 				megasas_return_cmd_fusion(instance, cmd_fusion);
 				scsi_dma_unmap(scmd_local);
-				scmd_local->scsi_done(scmd_local);
+				scsi_done(scmd_local);
 			}
 		}
 
