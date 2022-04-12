Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71AD7C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiDLXg3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbiDLXcs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:48 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC7CC5595
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:20 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w7so263977pfu.11
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ML0nkQEMG/3Zrcr3q0ext9dVsZa36UkLWx5nLDTlQQY=;
        b=K4vwnuMf/ujKLHGbm/lOhq1XTIoXtZz7Hypk/cvOTTpgOWYtgGHAlOo6W4eHqS58JA
         6WZeUPnlnG22iashHcmTVmBj/fdNYtJ3VttZ1FESO4ioEDQ8lnHDxH/C22pV/ShB9kzK
         1QsO22ylnh9pBuQoGFfIKToXS7n8v2BCYq9D5ThRSUfx+BqNtyinjPkqTVmRJyl9TYMy
         pUE6aRAGeb6CUJQi+9L46cZFDtcseJq9kr7FLS2E1WHdRAAy0VmQK2j0o0fGul3lYzlu
         J2O6c5P+j8jZXJkFBylMTjpr9dmYz+NxWfFS3rdCRF4h375PX/twUsyIxx50wqeOaYXE
         ep1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ML0nkQEMG/3Zrcr3q0ext9dVsZa36UkLWx5nLDTlQQY=;
        b=dDi6T3V93wjHm7WiNyTj/oSlpmaH0bZzVdxtK9j5Gv334BALsKWymp0r2H18d6WXEs
         FmHpMVpPcR2Qu0JHuQ7C1ferEfanCIlbRr+ufAbqJ4bBOZzV6sEnMzlV7l1TGgpOsT+k
         fH43h4248qZRKrBaUW/svv7lsPZRXBv+goYiBiXdU8u84CUPpac48kkk6hmEKTF3W4ik
         B9lPlVHH55WGIHvpfrrhNLDPhk3T1c49gugo9UaIkAX8R5QFWg2vUpqjoWwepC863eiL
         lMV+2Fky2jxW8OZyKmoGwARy2eag6uLE3vx08+ENOzDO0+O4i/23ZX6fPWMQskIz13ZN
         /6VA==
X-Gm-Message-State: AOAM530tmKA/Ao96vAqOr/4ygy6PAM3T2V/rfD5N4FGsve5jJ9bgTWFH
        iHj5cx01ygA1w6AIVYwGOlh/j7aeO0U=
X-Google-Smtp-Source: ABdhPJy12J96kADoxDHOanOPLIfYb5WtYu4yeo4PGZ3IMtY/6wkVFmeVxzO7l+ApJ0pMC1qdjiY8FA==
X-Received: by 2002:a05:6a02:106:b0:36c:96dd:8c17 with SMTP id bg6-20020a056a02010600b0036c96dd8c17mr33260567pgb.190.1649802019858;
        Tue, 12 Apr 2022 15:20:19 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:19 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 06/26] lpfc: Fix SCSI I/O completion and abort handler deadlock
Date:   Tue, 12 Apr 2022 15:19:48 -0700
Message-Id: <20220412222008.126521-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During stress I/O tests with 500+ vports, hard LOCKUP call traces are
observed.

CPU A:
 native_queued_spin_lock_slowpath+0x192
 _raw_spin_lock_irqsave+0x32
 lpfc_handle_fcp_err+0x4c6
 lpfc_fcp_io_cmd_wqe_cmpl+0x964
 lpfc_sli4_fp_handle_cqe+0x266
 __lpfc_sli4_process_cq+0x105
 __lpfc_sli4_hba_process_cq+0x3c
 lpfc_cq_poll_hdler+0x16
 irq_poll_softirq+0x76
 __softirqentry_text_start+0xe4
 irq_exit+0xf7
 do_IRQ+0x7f

CPU B:
 native_queued_spin_lock_slowpath+0x5b
 _raw_spin_lock+0x1c
 lpfc_abort_handler+0x13e
 scmd_eh_abort_handler+0x85
 process_one_work+0x1a7
 worker_thread+0x30
 kthread+0x112
 ret_from_fork+0x1f

Diagram of lockup:

CPUA                            CPUB
----                            ----
lpfc_cmd->buf_lock
                            phba->hbalock
                            lpfc_cmd->buf_lock
phba->hbalock

Fix by reordering the taking of the lpfc_cmd->buf_lock and phba->hbalock
in lpfc_abort_handler routine so that it tries to take the
lpfc_cmd->buf_lock first before phba->hbalock.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index ae340850d94f..c3daf7a3e123 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5865,25 +5865,25 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	if (!lpfc_cmd)
 		return ret;
 
-	spin_lock_irqsave(&phba->hbalock, flags);
+	/* Guard against IO completion being called at same time */
+	spin_lock_irqsave(&lpfc_cmd->buf_lock, flags);
+
+	spin_lock(&phba->hbalock);
 	/* driver queued commands are in process of being flushed */
 	if (phba->hba_flag & HBA_IOQ_FLUSH) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			"3168 SCSI Layer abort requested I/O has been "
 			"flushed by LLD.\n");
 		ret = FAILED;
-		goto out_unlock;
+		goto out_unlock_hba;
 	}
 
-	/* Guard against IO completion being called at same time */
-	spin_lock(&lpfc_cmd->buf_lock);
-
 	if (!lpfc_cmd->pCmd) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "2873 SCSI Layer I/O Abort Request IO CMPL Status "
 			 "x%x ID %d LUN %llu\n",
 			 SUCCESS, cmnd->device->id, cmnd->device->lun);
-		goto out_unlock_buf;
+		goto out_unlock_hba;
 	}
 
 	iocb = &lpfc_cmd->cur_iocbq;
@@ -5891,7 +5891,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 		pring_s4 = phba->sli4_hba.hdwq[iocb->hba_wqidx].io_wq->pring;
 		if (!pring_s4) {
 			ret = FAILED;
-			goto out_unlock_buf;
+			goto out_unlock_hba;
 		}
 		spin_lock(&pring_s4->ring_lock);
 	}
@@ -5924,8 +5924,8 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 			 "3389 SCSI Layer I/O Abort Request is pending\n");
 		if (phba->sli_rev == LPFC_SLI_REV4)
 			spin_unlock(&pring_s4->ring_lock);
-		spin_unlock(&lpfc_cmd->buf_lock);
-		spin_unlock_irqrestore(&phba->hbalock, flags);
+		spin_unlock(&phba->hbalock);
+		spin_unlock_irqrestore(&lpfc_cmd->buf_lock, flags);
 		goto wait_for_cmpl;
 	}
 
@@ -5946,15 +5946,13 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	if (ret_val != IOCB_SUCCESS) {
 		/* Indicate the IO is not being aborted by the driver. */
 		lpfc_cmd->waitq = NULL;
-		spin_unlock(&lpfc_cmd->buf_lock);
-		spin_unlock_irqrestore(&phba->hbalock, flags);
 		ret = FAILED;
-		goto out;
+		goto out_unlock_hba;
 	}
 
 	/* no longer need the lock after this point */
-	spin_unlock(&lpfc_cmd->buf_lock);
-	spin_unlock_irqrestore(&phba->hbalock, flags);
+	spin_unlock(&phba->hbalock);
+	spin_unlock_irqrestore(&lpfc_cmd->buf_lock, flags);
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 		lpfc_sli_handle_fast_ring_event(phba,
@@ -5989,10 +5987,9 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 out_unlock_ring:
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_unlock(&pring_s4->ring_lock);
-out_unlock_buf:
-	spin_unlock(&lpfc_cmd->buf_lock);
-out_unlock:
-	spin_unlock_irqrestore(&phba->hbalock, flags);
+out_unlock_hba:
+	spin_unlock(&phba->hbalock);
+	spin_unlock_irqrestore(&lpfc_cmd->buf_lock, flags);
 out:
 	lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "0749 SCSI Layer I/O Abort Request Status x%x ID %d "
-- 
2.26.2

