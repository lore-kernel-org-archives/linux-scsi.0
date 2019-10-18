Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E83EDCA9EA9
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA94921925
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:18:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jRccxiu+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502684AbfJRVS4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:18:56 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42948 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502569AbfJRVS4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 17:18:56 -0400
Received: by mail-pf1-f195.google.com with SMTP id q12so4607517pff.9
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 14:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HKef3HxtXxhBLCOgGld2cB9eaIlFnU6PeUXrVClrPdU=;
        b=jRccxiu+wJkxCJaMgTdlRG2kDGAHxocERc1hGHHCNrR9VutOsKwo2kTnTvr8hXOkCC
         AKNrbQXm/sHxhwrKcBrVLe+vWTjmzBDkisxCu4icp6IN+pUv3js5i1oOtZGNTcrYgMKU
         JrM73xHB7RRMIv362A5RzCbOP3XORF8OJKd4zc+KCsjPkWrCnN/iAJIAqFDo/5lLTYRl
         M4o5qDrRNNiWcKXo/AF7S+j8DbB8LQxA2bQ8+AsgodGkkuLIwPLRtiXxQK7Zp6Gye2Ra
         30wewP4ucTrB+DdBaizMsUXfiTIr4vuv7KWQO9IRYx0JjfH209XJhpDybaBDIAYCKhZo
         OY/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HKef3HxtXxhBLCOgGld2cB9eaIlFnU6PeUXrVClrPdU=;
        b=elIHyl1Qnj+3OZ+qZiuAaoNu1KuUf18AYp+lQHwXd2n1+pMCL7ifWlQJURWDtOxPaa
         6OZDTNEUJCbsgKglTQbVOfe+d38T2luvbnzEM+hilL4Uodanfx8HOApKCcPdeoX2mR99
         aU1soBcB1x9RN1oNRHaOCaQ/fmCGQIsnCZErJ1m5q0YTzvLDaWUtq2rhVLJscj+eTInf
         C5xVOta3z6DRfI92W0B/qyUMLtREzGqQTnJ41s9bIC9vg6Nektjwem1679Stj/n7cg5c
         R4jFCyOXRqJUgvXHpbejvyQqr/HCAOP4qY5zRsehj2Ijx8ENxcUHYgOArjBpm/6aEajH
         n2XQ==
X-Gm-Message-State: APjAAAV0hAm3mQeQYPDdT6b3/q0xrjlwXYeTfxfT1v0G5g336eV0d7hM
        OP8aPfi6gvNJ+LyklcQjdekAcNXP
X-Google-Smtp-Source: APXvYqwGqjUi00LBu918Sf8pYR8nQahbEwaQ2rgBl1OmDqXsZsKBfqs3KfOoBj+0td04/prhGh5vGA==
X-Received: by 2002:a63:1351:: with SMTP id 17mr12111127pgt.249.1571433535150;
        Fri, 18 Oct 2019 14:18:55 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm7538878pfo.131.2019.10.18.14.18.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 18 Oct 2019 14:18:54 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 03/16] lpfc: Fix lockdep errors in sli_ringtx_put
Date:   Fri, 18 Oct 2019 14:18:19 -0700
Message-Id: <20191018211832.7917-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191018211832.7917-1-jsmart2021@gmail.com>
References: <20191018211832.7917-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix lockdep error in __lpfc_sli_ringtx_put():
The hbalock is valid for sli3, but not for sli4.
Change lockdep to look at ring lock if sli4.

Also update comment in __lpfc_sli_issue_iocb_s4()
to reflect proper lock. note: lockdep check is
already correct.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 379c37451645..3a6520187ee5 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -9004,7 +9004,8 @@ lpfc_mbox_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
  * @pring: Pointer to driver SLI ring object.
  * @piocb: Pointer to address of newly added command iocb.
  *
- * This function is called with hbalock held to add a command
+ * This function is called with hbalock held for SLI3 ports or
+ * the ring lock held for SLI4 ports to add a command
  * iocb to the txq when SLI layer cannot submit the command iocb
  * to the ring.
  **/
@@ -9012,7 +9013,10 @@ void
 __lpfc_sli_ringtx_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		    struct lpfc_iocbq *piocb)
 {
-	lockdep_assert_held(&phba->hbalock);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		lockdep_assert_held(&pring->ring_lock);
+	else
+		lockdep_assert_held(&phba->hbalock);
 	/* Insert the caller's iocb in the txq tail for later processing. */
 	list_add_tail(&piocb->list, &pring->txq);
 }
@@ -9903,7 +9907,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
  * __lpfc_sli_issue_iocb_s4 is used by other functions in the driver to issue
  * an iocb command to an HBA with SLI-4 interface spec.
  *
- * This function is called with hbalock held. The function will return success
+ * This function is called with ringlock held. The function will return success
  * after it successfully submit the iocb to firmware or after adding to the
  * txq.
  **/
-- 
2.13.7

