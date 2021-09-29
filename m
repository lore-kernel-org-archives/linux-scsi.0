Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39347C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F81A60FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347160AbhI2WJP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:15 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:51760 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347101AbhI2WJN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:13 -0400
Received: by mail-pj1-f51.google.com with SMTP id h12so2708788pjj.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ygt+dWaafnpg+6+eXOTR14F/5++7Ta9sVTlI/vHYc08=;
        b=aOxTNRH2yiag5U602Nq90/K8fzQLCn7N3MKgaeTgmn1FSdPnECpSs9QHTTkrhFksZg
         uLylQFhlND+K2NawuMrka7GdmL8WD/SOYseVDGm7SEAO9KjXirTyJhFvOyo2DS5xAxu2
         Ave/Q1QlIRyjxz0gQjFCUbx498VTzp1S/+XanUKp2izYVmbaXQXgoE5uN32aBtXFJpN+
         g5Q+HSzn1pRG2lDEjKGgCmfgeCE5k0reEmKSYdvSzDHAOrynCHK3NJt4UHAh2Nt0dciG
         /JMNK1SbHCdrsvlUYOw0o+gcx9er4rZR8iFYA4koZ/16lstVjEEM/QjMc0KyQaxwbF84
         mKYQ==
X-Gm-Message-State: AOAM530MQHhkKpV6U978yvEjgiEkRB13z/TMbxJTkITGGr3CeTkf+rIr
        fBA1L05M0N9oc+lu/BAnoRs=
X-Google-Smtp-Source: ABdhPJxgNAiu+jRn8V6277ROTbcOV+M5Nb/FhEMFhGaLLLwLr7ki9prda/gV+5Q91St5+d+d0cesYw==
X-Received: by 2002:a17:90a:198b:: with SMTP id 11mr2354543pji.209.1632953251352;
        Wed, 29 Sep 2021 15:07:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 46/84] lpfc: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:22 -0700
Message-Id: <20210929220600.3509089-47-bvanassche@acm.org>
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
 drivers/scsi/lpfc/lpfc_scsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 17e677cf8dcd..b005c6d39e16 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -564,7 +564,7 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 				 * scsi_done upcall.
 				 */
 				if (cmd)
-					cmd->scsi_done(cmd);
+					scsi_done(cmd);
 
 				/*
 				 * We expect there is an abort thread waiting
@@ -4502,7 +4502,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 		goto out;
 
 	/* The sdev is not guaranteed to be valid post scsi_done upcall. */
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 
 	/*
 	 * If there is an abort thread waiting for command completion
@@ -4771,7 +4771,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 #endif
 
 	/* The sdev is not guaranteed to be valid post scsi_done upcall. */
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 
 	/*
 	 * If there is an abort thread waiting for command completion
@@ -5843,7 +5843,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 			     shost);
 
  out_fail_command:
-	cmnd->scsi_done(cmnd);
+	scsi_done(cmnd);
 	return 0;
 }
 
