Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E536C43215
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 05:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6107E2070E
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 05:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574399970;
	bh=Snhzch8azwuOYXbCQtEWlQY+Q47JjDAygTaC4J/qZj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=eQcM1MnUVF94WLJCm+DFnZtNqA/wReNczF83VdsgFYFrTe4gwainYMEI5pa5JiCBw
	 uGERjnAsWYuc2e6LpVJDfogDVm4GlWVtrFP4elCVORyz1IODq3Dr6Tz+QqT1nah/Tb
	 WlHoZUg9ewB8oUVhEI8KVd9zkndwBZXh0gHVOICY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfKVFTJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 00:19:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbfKVFTJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Nov 2019 00:19:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 779232070A;
        Fri, 22 Nov 2019 05:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574399948;
        bh=Snhzch8azwuOYXbCQtEWlQY+Q47JjDAygTaC4J/qZj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lNL5ynMeWWkLLA2XAvNUbCgVkS7bB5CiDqv5S2II8Me07T7CWyCSZ7z/LcB80CjwU
         y0fq3CqKnPZbUNmuuwHxBP1aIM4K+tJauEaeajAKAFhZAXSyxfKHG2Z5KYp3kmsE/R
         tTE8s4hI+200LvEX+xC2d8egt1VfXzYphoA/dxBs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 002/219] scsi: lpfc: Fix kernel Oops due to null pring pointers
Date:   Fri, 22 Nov 2019 00:15:26 -0500
Message-Id: <20191122051903.31749-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122051903.31749-1-sashal@kernel.org>
References: <20191122051903.31749-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 5a9eeff57f340238c39c95d8e7e54c96fc722de7 ]

Driver is hitting null pring pointers in lpfc_do_work().

Pointer assignment occurs based on SLI-revision. If recovering after an
error, its possible the sli revision for the port was cleared, making the
lpfc_phba_elsring() not return a ring pointer, thus the null pointer.

Add SLI revision checking to lpfc_phba_elsring() and status checking to all
callers.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc.h      | 6 ++++++
 drivers/scsi/lpfc/lpfc_els.c  | 2 ++
 drivers/scsi/lpfc/lpfc_init.c | 7 ++++++-
 drivers/scsi/lpfc/lpfc_sli.c  | 2 ++
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 43732e8d13473..79c3b2f53828e 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1235,6 +1235,12 @@ lpfc_sli_read_hs(struct lpfc_hba *phba)
 static inline struct lpfc_sli_ring *
 lpfc_phba_elsring(struct lpfc_hba *phba)
 {
+	/* Return NULL if sli_rev has become invalid due to bad fw */
+	if (phba->sli_rev != LPFC_SLI_REV4  &&
+	    phba->sli_rev != LPFC_SLI_REV3  &&
+	    phba->sli_rev != LPFC_SLI_REV2)
+		return NULL;
+
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		if (phba->sli4_hba.els_wq)
 			return phba->sli4_hba.els_wq->pring;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f3c6801c0b312..3651c0fc88197 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1340,6 +1340,8 @@ lpfc_els_abort_flogi(struct lpfc_hba *phba)
 			Fabric_DID);
 
 	pring = lpfc_phba_elsring(phba);
+	if (unlikely(!pring))
+		return -EIO;
 
 	/*
 	 * Check the txcmplq for an iocb that matches the nport the driver is
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 9acb5b44ce4c1..dae0dd8066f04 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1801,7 +1801,12 @@ lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action,
 	lpfc_offline(phba);
 	/* release interrupt for possible resource change */
 	lpfc_sli4_disable_intr(phba);
-	lpfc_sli_brdrestart(phba);
+	rc = lpfc_sli_brdrestart(phba);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"6309 Failed to restart board\n");
+		return rc;
+	}
 	/* request and enable interrupt */
 	intr_mode = lpfc_sli4_enable_intr(phba, phba->intr_mode);
 	if (intr_mode == LPFC_INTR_ERROR) {
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a490e63c94b67..266e7101902ef 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4644,6 +4644,8 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
 	hba_aer_enabled = phba->hba_flag & HBA_AER_ENABLED;
 
 	rc = lpfc_sli4_brdreset(phba);
+	if (rc)
+		return rc;
 
 	spin_lock_irq(&phba->hbalock);
 	phba->pport->stopped = 0;
-- 
2.20.1

