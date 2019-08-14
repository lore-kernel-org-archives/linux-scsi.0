Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 880F8C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D0112086C
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VAPJurub"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbfHNX5m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:42 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34983 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729297AbfHNX5l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:41 -0400
Received: by mail-pf1-f194.google.com with SMTP id d85so349418pfd.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DC0gCVap1786iX8271+jNEdBUlOCVraRxsZoutRztCE=;
        b=VAPJurubWzyPNXjZP1rvJmscdlQe7c0ZxS3MWrlOY1n6PAqY5fKcmscD9PlrXqD/Lh
         acIhpbkEOmyJLqSUIg1Dq3H/mJHcTA5d5rKJGlrSA2vFhT+qWspGjgOK1f9wueD8tNh+
         W34dGMbY/96/Okbk8RTpe1Zt6++4QPB8ljDygexisG+3zLooBv/Ks6ir7i9tF64ZYe4F
         WvyBnqouVjDxAoZH3n5LmoVDl0a+zKeRH+utRVOQZfjdlh/OLlfZ6w4l95fG72ef51en
         WB0hPdouoNsAFm2OPaUjJCMUFwxcj+qXhJ3WoVGmi8uNsOr8S6eGV92rjQe7H1+zpdEO
         lmAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DC0gCVap1786iX8271+jNEdBUlOCVraRxsZoutRztCE=;
        b=ISkuks5MOVXdg/DUIWoMKqep/k/kcR5+l1kFCh9wFrJM61mlq+Ry9w1h65dGcVkeQt
         72sFHNG49reN4aLt63q03MDq51XE3wJ7QMOUgquX+IC7KV1KEpilTSAcBJFvF8005H/I
         ma9QYNwuH0t+XISX1xN99g4qTQ5a2SkaZhhDdBMckLdlVxtuCt0eo3IpOoEFp68jsD4G
         O+vFxEvXlVlSMLgPH9EUbfq7krLM3dBwGafKtE+KZyuJ0Cel608GA8n1rxml3Zz/q8oF
         VPuSVjk+ZKpdRcnetPpjtk2Qu1viWgKMBZORXbBoNbKHSADva79ueX7gKAeUzWB++WoO
         +NTA==
X-Gm-Message-State: APjAAAXq3Qqs4VvzAzppCk4Z0pC4S06Cpkl7VHRzh99rVFm7tuOT9DYe
        Ly0roNydk2hKpQe6yOFC/ApR39s7
X-Google-Smtp-Source: APXvYqxM9rJK4tmqOOfOTjcCsCSVQOHtWKM6DMLmJRQOPJuuCtAt3t/hZGo/vVNxuEaffqr20KQE6g==
X-Received: by 2002:aa7:91d3:: with SMTP id z19mr2555043pfa.135.1565827060031;
        Wed, 14 Aug 2019 16:57:40 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:39 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 23/42] lpfc: Fix crash due to port reset racing vs adapter error handling
Date:   Wed, 14 Aug 2019 16:56:53 -0700
Message-Id: <20190814235712.4487-24-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the adapter encounters a condition which causes the adapter
to fail (driver must detect the failure) simultaneously to a
request to the driver to reset the adapter (such as a host_reset),
the reset path will be racing with the asynchronously-detect
adapter failure path.  In the failing situation, one path has
started to tear down the adapter data structures (io_wq's) while
the other path has initiated a repeat of the teardown and is in
the lpfc_sli_flush_xxx_rings path and attempting to access the
just-freed data structures.

Fix by the following:
- In cases where an adapter failure is detected, rather than
  explicitly calling offline_eratt() to start the teardown,
  change the adapter state and let the later calls of posted
  work to the slowpath thread invoke the adapter recovery.
  In essence, this means all requests to reset are serialized
  on the slowpath thread.
- Clean up the routine that restarts the adapter. If there is a
  failure from brdreset, don't immediately error and leave
  things in a partial state. Instead, ensure the adapter state
  is set and finish the teardown of structures before returning.
- if in the scsi host reset handler and the board fails to
  reset and restart (which can be due to parallel reset/recovery
  paths), instead of hard failing and explicitly calling
  offline_eratt() (which gets into the redundant path), just
  fail out and let the asynchronous path resolve the adapter
  state.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c |  7 +++----
 drivers/scsi/lpfc/lpfc_scsi.c | 16 +++++++++-------
 drivers/scsi/lpfc/lpfc_sli.c  |  6 ++++--
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 84a77faed114..c580d512a3db 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1926,7 +1926,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"7624 Firmware not ready: Failing UE recovery,"
 				" waited %dSec", i);
-		lpfc_sli4_offline_eratt(phba);
+		phba->link_state = LPFC_HBA_ERROR;
 		break;
 
 	case LPFC_SLI_INTF_IF_TYPE_2:
@@ -2000,9 +2000,8 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
 		}
 		/* fall through for not able to recover */
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"3152 Unrecoverable error, bring the port "
-				"offline\n");
-		lpfc_sli4_offline_eratt(phba);
+				"3152 Unrecoverable error\n");
+		phba->link_state = LPFC_HBA_ERROR;
 		break;
 	case LPFC_SLI_INTF_IF_TYPE_1:
 	default:
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index f9df800e7067..720a98266986 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5295,18 +5295,20 @@ lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
 	lpfc_offline(phba);
 	rc = lpfc_sli_brdrestart(phba);
 	if (rc)
-		ret = FAILED;
+		goto error;
+
 	rc = lpfc_online(phba);
 	if (rc)
-		ret = FAILED;
+		goto error;
+
 	lpfc_unblock_mgmt_io(phba);
 
-	if (ret == FAILED) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-				 "3323 Failed host reset, bring it offline\n");
-		lpfc_sli4_offline_eratt(phba);
-	}
 	return ret;
+error:
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+			 "3323 Failed host reset\n");
+	lpfc_unblock_mgmt_io(phba);
+	return FAILED;
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 058c092bda73..ca6988ae8924 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4509,7 +4509,7 @@ lpfc_sli_brdreset(struct lpfc_hba *phba)
  * checking during resets the device. The caller is not required to hold
  * any locks.
  *
- * This function returns 0 always.
+ * This function returns 0 on success else returns negative error code.
  **/
 int
 lpfc_sli4_brdreset(struct lpfc_hba *phba)
@@ -4667,7 +4667,7 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
 
 	rc = lpfc_sli4_brdreset(phba);
 	if (rc)
-		return rc;
+		goto error;
 
 	spin_lock_irq(&phba->hbalock);
 	phba->pport->stopped = 0;
@@ -4682,6 +4682,8 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
 	if (hba_aer_enabled)
 		pci_disable_pcie_error_reporting(phba->pcidev);
 
+error:
+	phba->link_state = LPFC_HBA_ERROR;
 	lpfc_hba_down_post(phba);
 	lpfc_sli4_queue_destroy(phba);
 
-- 
2.13.7

