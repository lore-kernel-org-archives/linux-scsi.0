Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7324ACCA480
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 17:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239027AbiFCRrL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 13:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345341AbiFCRqj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 13:46:39 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171406373
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jun 2022 10:43:40 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id y187so7748239pgd.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jun 2022 10:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0Gcdftwb8mE00o6wiVyVM1abvHyHYZu+SCMr0IEKeM8=;
        b=qhvvqiFgLaylWsXnyBrDeZRbd4kGykXzQdXt6rz39zsa2snkbloA5ALBrgzPSg25MP
         dVkFmZP4ExnPu4PgaRwkQAQbznmiZHqi5vdi1zkEK/5mtv5lRUvK4AlvJqoT4eJhYyPX
         t4VGV7CmT2XSyL2eGLOy3RLiMU05ZhxnRKsmsnLDzYYurmxLJlG6Lf0KOEK6a8hhQRRV
         9eiNbZkc7+XQpkmhL+smCeO1gBMF2CgvUPKw78N9B/NkaXbGTJDleMJp5T0apklRG3HB
         IfgDWHDTeJeTTgdDERXEodTkmg3Z1hGBOyoL2UT/CMhazisUeiMLKuTPu1KhFSKj+c4P
         tspg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Gcdftwb8mE00o6wiVyVM1abvHyHYZu+SCMr0IEKeM8=;
        b=4W6JCG6mQu7gOKwpY80IDiFHkLXf7si+WfrXFVwt/62cbWdOIFXTis7pnY7CglWEDg
         MW7obnY3WFxIRm0RzsIhp9F6/GJCtPdtGGliD5yyk6IVuot5yqtnoApGpVbPDAmh8MQK
         MngYtBNszOT8KBuI8HnWN2P6+JJ2htv8DbjdI8zeM4TRdzrItzUWcgNVLCEb/HZFwBt3
         ke1QvDFoT9hpscmLSa54zTKRP2l/UObz3ryxOCLxNgMBBsCoDePQtCLtD5KULmLvUpH3
         7IDFsTZMdqUarSCV+/XptoooIHylvztZXINPO0WgRO6NlfkkcJfMcBuID5J5DnniJcof
         Z5fg==
X-Gm-Message-State: AOAM531C4mrwI2dkWNuXc5hS5Y+mNCz/zvRBPeABxOvdbW3i3o/jmUsl
        2ZJ/Nx0HF09TeZojoFhCK91RCnQnP8E=
X-Google-Smtp-Source: ABdhPJyrhFhDMunq85iwWKQt+SuMMOA+RlqNMg3tJd7w0t/LxJtlQbI22VMQIKMSosZAHDHQ4SL+ng==
X-Received: by 2002:a63:87:0:b0:3fd:5248:9780 with SMTP id 129-20020a630087000000b003fd52489780mr204174pga.159.1654278219463;
        Fri, 03 Jun 2022 10:43:39 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902710d00b0015e8d4eb1d2sm5705047pll.28.2022.06.03.10.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 10:43:39 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 5/9] lpfc: Resolve null ptr dereference after an ELS LOGO is aborted
Date:   Fri,  3 Jun 2022 10:43:25 -0700
Message-Id: <20220603174329.63777-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220603174329.63777-1-jsmart2021@gmail.com>
References: <20220603174329.63777-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A use-after-free crash can occur after an ELS LOGO is aborted.

Specifically, a nodelist structure is freed and then
ndlp->vport->cfg_log_verbose is dereferenced in lpfc_nlp_get when the
discovery state machine is mistakenly called a second time with
NLP_EVT_DEVICE_RM argument.

Rework lpfc_cmpl_els_logo to prevent the duplicate calls to release a
nodelist structure.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 51c505d15410..57e189f62e42 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2998,10 +2998,7 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 ndlp->nlp_DID, ulp_status,
 				 ulp_word4);
 
-		/* Call NLP_EVT_DEVICE_RM if link is down or LOGO is aborted */
 		if (lpfc_error_lost_link(ulp_status, ulp_word4)) {
-			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
-						NLP_EVT_DEVICE_RM);
 			skip_recovery = 1;
 			goto out;
 		}
@@ -3021,18 +3018,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		spin_unlock_irq(&ndlp->lock);
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_DEVICE_RM);
-		lpfc_els_free_iocb(phba, cmdiocb);
-		lpfc_nlp_put(ndlp);
-
-		/* Presume the node was released. */
-		return;
+		goto out_rsrc_free;
 	}
 
 out:
-	/* Driver is done with the IO.  */
-	lpfc_els_free_iocb(phba, cmdiocb);
-	lpfc_nlp_put(ndlp);
-
 	/* At this point, the LOGO processing is complete. NOTE: For a
 	 * pt2pt topology, we are assuming the NPortID will only change
 	 * on link up processing. For a LOGO / PLOGI initiated by the
@@ -3059,6 +3048,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 ndlp->nlp_DID, ulp_status,
 				 ulp_word4, tmo,
 				 vport->num_disc_nodes);
+
+		lpfc_els_free_iocb(phba, cmdiocb);
+		lpfc_nlp_put(ndlp);
+
 		lpfc_disc_start(vport);
 		return;
 	}
@@ -3075,6 +3068,10 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_DEVICE_RM);
 	}
+out_rsrc_free:
+	/* Driver is done with the I/O. */
+	lpfc_els_free_iocb(phba, cmdiocb);
+	lpfc_nlp_put(ndlp);
 }
 
 /**
-- 
2.26.2

