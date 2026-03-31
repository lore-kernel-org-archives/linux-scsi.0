Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567B444E02A
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 20:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774988590; cv=none; b=CBKbAzMETMBBiPPRhpG4vaRCyU8mLguUsNwfPleJ6y7dDYVw2NEE22RTdIYmbrCtN+VukrgMEhgR1tC5vSFwjryHYsnluCVNYvu/xTOUczVgdEkx0A5VghokwjtDsmHRq/GFXcAmEPiC04VEpzt8jR9J9VKbqh4vkx/5K3ycWvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774988590; c=relaxed/simple;
	bh=qkHx+K+D+f28TKMTD0BvCJHVT7hrZ2Kr8W+oTnx/bIM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PMWIqjAflulTTcLslSDquZNR/BxcPSNJKqtDq2B/bVvHticVPaXXg9vjNMO8KrzEOKYEXuE8n4paGsqIOU1veGx6PphEghtKH3E7UERtZwzS96+OpR9wh/YT47yyDLB2Krr06Hp0tmNBW0+WN0gaRjfrKsajGlID6XVAUsLpFxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dnTfh12h; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dnTfh12h"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8a1e1817db6so20120696d6.2
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 13:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774988588; x=1775593388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=02G+vJfuSj0eLaoMsrrJeYTh4CKL6hT1eqbWwqexUcw=;
        b=dnTfh12hARTNSp1ny8+7Ybw33EVgZmeLn3DyXgwQNSvo41GhrTFAb00iCBERQCYDxp
         PHVwW8c5jwIuoGULbvWzft7QXUnRSVomZnrZe7dQ0EJMJkarqMzGDObFARAcIG3au0tY
         olBIsV22WHcKKqYVcdgkc7jsFhJ1OQ0d8pOR0JLwo3jni6i7JRbzDnc7YQEtt4wHSpaz
         pqdqJCiVHFSn4FgNv4dXkqKx+OOeH2wNVy1IGxDEmnDiJmLNEAjBlrbml/xX3CsJ5LDn
         lrb4YIWKUI63OLZV6DHIET8rB/by8E4h9bcVVMNuSqew3fqyG+ELQB00RECx/y30nFXc
         /aMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774988588; x=1775593388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=02G+vJfuSj0eLaoMsrrJeYTh4CKL6hT1eqbWwqexUcw=;
        b=cG3Zvg2AzNnqTfW2DGS4d3MzF+/Ylan7PGMYyRKvIfSgPsgFMA0PNkN1nxROcqhXl7
         Lr8b+bJuB+28K8kH6D+ZfWjz2zuAiA5deZOikYkSx8YJTcnFAjyZGQFmszmoIDPOEe7m
         MiqAnbg5CD5WK3sJZhEb1bvMHSLukYMB+i1mUlcR/35JuY5vctlGU8l6LNlO5RPiVu9Y
         kQkqIknTWNZ031capXL7VD7ArTBOAmR6t2IdnPPeU+YpWwOwDXaJ02JkYCNBatt1imDF
         L188p8eP5ouR68ul1+Mt+C/n5JNY3XYCARMrYvcOU2CthVJU9I8BKrzqdeH2vTVR8nIR
         4kDg==
X-Gm-Message-State: AOJu0YxU4CrBFQGk5DPS6pLZjcxjrV8lCJktx7vxmt+v4c3q3QWX/SRk
	qGwvw6iZUsOWok0hgYJIG5n5LAUBHmsLoRBQGs1ZGQsPUREBh68NS7uH6MlNrA==
X-Gm-Gg: ATEYQzwfbqcXp+Thxp6N4mnzv4BUIDk5bdeCpX3DbuGHTNWH4HLd61jE4w6CxBuKal3
	Dm/duGze2v9MWVcCcufvQjWXNimSm+z+xJ6IQKCOw6qQGy8eQMYn1wYtHjoNv5TaEaER31XqtHp
	lvTFDKXI2BwomRwCkImlKMOF/B0BAB8KtXUpGKmpPSOlw5r3WRXhHaw3AzZPhH8zsVfZqfL7RBL
	YJ3tC8WPaBIqFw/RvO15fIE8yvtYfxlBDZHjcBnyqs+bf4UBGZeQQOCaA6hMjAca8aPvv1uResy
	7yA1vyqnk611+SzyjsGT7TNjgU8NqBIvtPx4fmuf/hk6DfXjMyuLvX8G8xzRL1TZlo0gLe4oU5j
	jnF7wrU4X9UWcEoDnwyW8EGuoSnFDjc1cYIm99JgvDFg9NsNdr0agvz+djYZktH8Fs3m634auv4
	sPOBGY6TRqEAQzjdfGhNuajRJdUqogJgvVxnnsC8KZD+PZQx8LkhBSzJFhj70VQBgJJrpJLAcDN
	/qrZcP2ARse+Re6J6VqTsaw44fsjzNBALSwebj17Nk=
X-Received: by 2002:a05:6214:4a87:b0:89f:fc93:ad6f with SMTP id 6a1803df08f44-8a437613c63mr16260776d6.15.1774988588128;
        Tue, 31 Mar 2026 13:23:08 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89ecf865ccesm96685616d6.39.2026.03.31.13.23.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Mar 2026 13:23:07 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 04/10] lpfc: Add REG_VFI mailbox cmd error handling
Date: Tue, 31 Mar 2026 13:59:22 -0700
Message-Id: <20260331205928.119833-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260331205928.119833-1-justintee8345@gmail.com>
References: <20260331205928.119833-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit

If lpfc_issue_reg_vfi() returns an error in lpfc_rcv_plogi(), then
execution of lpfc_rcv_plogi() continues and lpfc_reg_rpi() is called, which
allocates an mbuf.  When this REG_RPI mailbox is issued, it inevitably
fails because the VFI is not registered.  However, the REG_RPI failure does
not free the mbuf that was allocated in lpfc_reg_rpi() because there is no
check for mbox error status in lpfc_defer_plogi_acc().

Fix by adding a check in lpfc_rcv_plogi() if lpfc_reg_vfi() fails, then
exit early.  Also, add mailbox status check in lpfc_defer_plogi_acc to
enter the REG_RPI mbox_cmpl functions and free the allocated mbuf.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 38 ++++++++++++++++--------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 5e431928de0b..9c449055a55e 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -316,8 +316,7 @@ lpfc_defer_plogi_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *login_mbox)
 	struct lpfc_iocbq *save_iocb;
 	struct lpfc_nodelist *ndlp;
 	MAILBOX_t *mb = &login_mbox->u.mb;
-
-	int rc;
+	int rc = 0;
 
 	ndlp = login_mbox->ctx_ndlp;
 	save_iocb = login_mbox->ctx_u.save_iocb;
@@ -346,7 +345,7 @@ lpfc_defer_plogi_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *login_mbox)
 	 * completes.  This ensures, in Pt2Pt, that the PLOGI LS_ACC is sent
 	 * before the PRLI.
 	 */
-	if (!test_bit(FC_PT2PT, &ndlp->vport->fc_flag)) {
+	if (!test_bit(FC_PT2PT, &ndlp->vport->fc_flag) || mb->mbxStatus || rc) {
 		/* Now process the REG_RPI cmpl */
 		lpfc_mbx_cmpl_reg_login(phba, login_mbox);
 		clear_bit(NLP_ACC_REGLOGIN, &ndlp->nlp_flag);
@@ -525,13 +524,13 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		/* Issue CONFIG_LINK for SLI3 or REG_VFI for SLI4,
 		 * to account for updated TOV's / parameters
 		 */
-		if (phba->sli_rev == LPFC_SLI_REV4)
-			lpfc_issue_reg_vfi(vport);
-		else {
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			rc = lpfc_issue_reg_vfi(vport);
+		} else {
 			link_mbox = mempool_alloc(phba->mbox_mem_pool,
 						  GFP_KERNEL);
 			if (!link_mbox)
-				goto out;
+				goto rsp_rjt;
 			lpfc_config_link(phba, link_mbox);
 			link_mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 			link_mbox->vport = vport;
@@ -544,11 +543,13 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			rc = lpfc_sli_issue_mbox(phba, link_mbox, MBX_NOWAIT);
 			if (rc == MBX_NOT_FINISHED) {
 				mempool_free(link_mbox, phba->mbox_mem_pool);
-				goto out;
+				goto rsp_rjt;
 			}
 		}
 
 		lpfc_can_disctmo(vport);
+		if (rc)
+			goto rsp_rjt;
 	}
 
 	clear_bit(NLP_SUPPRESS_RSP, &ndlp->nlp_flag);
@@ -562,11 +563,11 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	login_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!login_mbox)
-		goto out;
+		goto rsp_rjt;
 
 	save_iocb = kzalloc_obj(*save_iocb);
 	if (!save_iocb)
-		goto out;
+		goto free_login_mbox;
 
 	/* Save info from cmd IOCB to be used in rsp after all mbox completes */
 	memcpy((uint8_t *)save_iocb, (uint8_t *)cmdiocb,
@@ -586,7 +587,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	rc = lpfc_reg_rpi(phba, vport->vpi, remote_did,
 			    (uint8_t *)sp, login_mbox, ndlp->nlp_rpi);
 	if (rc)
-		goto out;
+		goto free_save_iocb;
 
 	login_mbox->mbox_cmpl = lpfc_mbx_cmpl_reg_login;
 	login_mbox->vport = vport;
@@ -659,7 +660,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	login_mbox->mbox_cmpl = lpfc_defer_plogi_acc;
 	login_mbox->ctx_ndlp = lpfc_nlp_get(ndlp);
 	if (!login_mbox->ctx_ndlp)
-		goto out;
+		goto free_save_iocb;
 
 	login_mbox->ctx_u.save_iocb = save_iocb; /* For PLOGI ACC */
 
@@ -670,16 +671,17 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	rc = lpfc_sli_issue_mbox(phba, login_mbox, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED) {
 		lpfc_nlp_put(ndlp);
-		goto out;
+		goto free_save_iocb;
 	}
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_REG_LOGIN_ISSUE);
 
 	return 1;
-out:
-	kfree(save_iocb);
-	if (login_mbox)
-		mempool_free(login_mbox, phba->mbox_mem_pool);
 
+free_save_iocb:
+	kfree(save_iocb);
+free_login_mbox:
+	mempool_free(login_mbox, phba->mbox_mem_pool);
+rsp_rjt:
 	stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
 	stat.un.b.lsRjtRsnCodeExp = LSEXP_OUT_OF_RESOURCE;
 	lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb, ndlp, NULL);
-- 
2.38.0

