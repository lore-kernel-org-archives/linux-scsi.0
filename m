Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C26C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AEF6611ED
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhJTVQm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbhJTVQl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:16:41 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D7EC061749
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:14:26 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id t11so17019447plq.11
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S6DlPNxkV/Vag66qy/kbG/ox5sepfKSY71OUbEMKlnA=;
        b=WmP/shePr3C+EIr0RJkEtyZSk4he37HqZoGAbmRWDSmBZVxERN64cCqjiCfLjjJd+Q
         auwlN/5Xle6a9v5pMHjvxzMZeOoNmpCosFmB8dLa2u34hiPXPV5e5IkauECM+a8qQ3zQ
         zLbXO3b88t+/QD74/VsnA+9CR105n60kBXe/8tgVyoI2dGesfoJnL1gTCetFrF6U0EFU
         Eq0snktdv06F0d1es/e+eUC7SXoPctrf3tkh0MmVAoTY0/2wkKAEEcjpfenuTr5iPPM/
         xp/aN5nooP2IIoPNDAPvysdB9dyET4DHgGwjJGa9LM8t/FWdjvcd4Fhu8x9zp8mWN7lG
         qTGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S6DlPNxkV/Vag66qy/kbG/ox5sepfKSY71OUbEMKlnA=;
        b=hG2ZVm29AyDZyAVte7k2iI8iqn5kSS6gQeNrzxACWLh/SjjiUm/Uo2Ua0yBumHd2UH
         dzAt+SwSWxYShwP8/z8dNchNSLZBFoUisZCHvkSBRVN8+Tcs5Wa3hKHAd/A5mbbTCwsg
         ZKJSw9OElfwpRSr4FJBB6IIC0oEfowPAKp/PBch9gYe1f2CwQPG+ez3T8dgmQZ5xqMin
         VxbciBOZkOFPLkqkT58xYQ4qXeB+THuOrL8kVlJUwv1/mxY0sEBdSlL+C8CniDBguu9c
         uJUGYrE3M8MqpO0qJQlKmFwVJX4yPV01E0PZO21cWjHcoTPoWedEHqbklsDSwrogwedR
         lsRg==
X-Gm-Message-State: AOAM530AtLwNxd5quu4Jp6YhS0Gx4KA5b1n2LZBJ20eTvHCHheuD+5Cw
        q+9ebVXS3EyqY4NgnpYkRM1l651dk1M=
X-Google-Smtp-Source: ABdhPJwu1JJ5z/yUDjyx88DzioULeXNxtiSTfuImliL96sLR3Z/cYmy9xfo/rzeo7mbtm4iPj7+oaw==
X-Received: by 2002:a17:90b:4c88:: with SMTP id my8mr1455036pjb.49.1634764466244;
        Wed, 20 Oct 2021 14:14:26 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id pi9sm3700689pjb.31.2021.10.20.14.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:14:25 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 3/8] lpfc: Correct sysfs reporting of loop support after SFP status change
Date:   Wed, 20 Oct 2021 14:14:12 -0700
Message-Id: <20211020211417.88754-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211020211417.88754-1-jsmart2021@gmail.com>
References: <20211020211417.88754-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Applications determine loop support in part by querying the 'pls'
sysfs node. Reporting of 'pls' (Private Loop Support) is derived from
the descriptor returned by the COMMON_GET_SLI4_PARAMETERS mailbox
command, which is issued during initialization or after a reset.

The value of this field may change if there is a dynamic SFP change.
The driver currently will not pick up the change as there was no reset
scenario.

Rework to commonize the sending of the COMMON_GET_SLI4_PARAMETERS
command. Add the calling of the routine after receipt of an async event
indicating an SFP change.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h |  1 +
 drivers/scsi/lpfc/lpfc_init.c | 50 +++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_sli.c  | 25 +++---------------
 3 files changed, 55 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index c512f4199142..f0bcfeecd161 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -205,6 +205,7 @@ void lpfc_delayed_disc_timeout_handler(struct lpfc_vport *);
 int lpfc_config_port_prep(struct lpfc_hba *);
 void lpfc_update_vport_wwn(struct lpfc_vport *vport);
 int lpfc_config_port_post(struct lpfc_hba *);
+int lpfc_sli4_refresh_params(struct lpfc_hba *phba);
 int lpfc_hba_down_prep(struct lpfc_hba *);
 int lpfc_hba_down_post(struct lpfc_hba *);
 void lpfc_hba_init(struct lpfc_hba *, uint32_t *);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 5e959c4f05c2..744da35b5074 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -662,6 +662,50 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 	return 0;
 }
 
+/**
+ * lpfc_sli4_refresh_params - update driver copy of params.
+ * @phba: Pointer to HBA context object.
+ *
+ * This is called to refresh driver copy of dynamic fields from the
+ * common_get_sli4_parameters descriptor.
+ **/
+int
+lpfc_sli4_refresh_params(struct lpfc_hba *phba)
+{
+	LPFC_MBOXQ_t *mboxq;
+	struct lpfc_mqe *mqe;
+	struct lpfc_sli4_parameters *mbx_sli4_parameters;
+	int length, rc;
+
+	mboxq = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq)
+		return -ENOMEM;
+
+	mqe = &mboxq->u.mqe;
+	/* Read the port's SLI4 Config Parameters */
+	length = (sizeof(struct lpfc_mbx_get_sli4_parameters) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_GET_SLI4_PARAMETERS,
+			 length, LPFC_SLI4_MBX_EMBED);
+
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	if (unlikely(rc)) {
+		mempool_free(mboxq, phba->mbox_mem_pool);
+		return rc;
+	}
+	mbx_sli4_parameters = &mqe->un.get_sli4_parameters.sli4_parameters;
+	phba->sli4_hba.pc_sli4_params.mi_ver =
+			bf_get(cfg_mi_ver, mbx_sli4_parameters);
+	phba->sli4_hba.pc_sli4_params.cmf =
+			bf_get(cfg_cmf, mbx_sli4_parameters);
+	phba->sli4_hba.pc_sli4_params.pls =
+			bf_get(cfg_pvl, mbx_sli4_parameters);
+
+	mempool_free(mboxq, phba->mbox_mem_pool);
+	return rc;
+}
+
 /**
  * lpfc_hba_init_link - Initialize the FC link
  * @phba: pointer to lpfc hba data structure.
@@ -6455,6 +6499,12 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
 					"3194 Unable to retrieve supported "
 					"speeds, rc = 0x%x\n", rc);
 		}
+		rc = lpfc_sli4_refresh_params(phba);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"3174 Unable to update pls support, "
+					"rc x%x\n", rc);
+		}
 		vports = lpfc_create_vport_work_array(phba);
 		if (vports != NULL) {
 			for (i = 0; i <= phba->max_vports && vports[i] != NULL;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 244e7d68428e..f82f809617a0 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7891,36 +7891,19 @@ static int
 lpfc_cmf_setup(struct lpfc_hba *phba)
 {
 	LPFC_MBOXQ_t *mboxq;
-	struct lpfc_mqe *mqe;
 	struct lpfc_dmabuf *mp;
 	struct lpfc_pc_sli4_params *sli4_params;
-	struct lpfc_sli4_parameters *mbx_sli4_parameters;
-	int length;
 	int rc, cmf, mi_ver;
 
+	rc = lpfc_sli4_refresh_params(phba);
+	if (unlikely(rc))
+		return rc;
+
 	mboxq = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mboxq)
 		return -ENOMEM;
-	mqe = &mboxq->u.mqe;
-
-	/* Read the port's SLI4 Config Parameters */
-	length = (sizeof(struct lpfc_mbx_get_sli4_parameters) -
-		  sizeof(struct lpfc_sli4_cfg_mhdr));
-	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
-			 LPFC_MBOX_OPCODE_GET_SLI4_PARAMETERS,
-			 length, LPFC_SLI4_MBX_EMBED);
-
-	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-	if (unlikely(rc)) {
-		mempool_free(mboxq, phba->mbox_mem_pool);
-		return rc;
-	}
 
-	/* Gather info on CMF and MI support */
 	sli4_params = &phba->sli4_hba.pc_sli4_params;
-	mbx_sli4_parameters = &mqe->un.get_sli4_parameters.sli4_parameters;
-	sli4_params->mi_ver = bf_get(cfg_mi_ver, mbx_sli4_parameters);
-	sli4_params->cmf = bf_get(cfg_cmf, mbx_sli4_parameters);
 
 	/* Are we forcing MI off via module parameter? */
 	if (!phba->cfg_enable_mi)
-- 
2.26.2

