Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C684C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbiDLXhG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbiDLXcx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:53 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB34FC55AE
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:25 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id w7so264092pfu.11
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iN/8odfO2X4RM5MW1f66zHEFrIkUr4Owh9JwFIn1byE=;
        b=SgN+FfDR5y81cktR5XFXGHCjDmosqS6YWZFAtChpaSJgr/EsNy8UqEvGqhkdUa/Zzc
         J4R7kiKHdPaH+V/mzK+jEWs7vDEPjWvEgXkrcsZEab88I6XI494H1sUfGaPRHqqCCpvv
         gt50Fnl2531eQ8BKyM+kSaHzz14+dPRgunukMuU/HcSXS1iM4iZLDjrFXr6QWb71HOkI
         1mu7xnQaN8yYBbvS5TGzKd6zSKYx55aR8BE7PFd+UiF1ybEiUKbycKHhQdnTtVoSadru
         WlFn1JrmIxnVyARq3Y6jIIwBW2vIIoxyGUCb6ado3Ypsbrn8BbQ5HYm7MzF7xTJWJqur
         BrYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iN/8odfO2X4RM5MW1f66zHEFrIkUr4Owh9JwFIn1byE=;
        b=2fVYa4YswKDs3+RNECRFsT6PS8jLZqrqf7uV8BAmTVKCZ8/uOpUn2ESzYkAfCLe7Xc
         EFGSm6JlEzi5ia1vB6aujpyuNdBZlKI/ySO87rSB2jAoylTbaU6wnW88V92exW7PxONi
         EayKCq+canX7jrV45o5fGhCL67HuW3Ajm3eJvBPbOrb8q630dvMPiXgTXVDQhKOAixQM
         MyYklhPWEQ2BOE1uFDUBnwq8lc1NiBOFxryN1Vj9jxmMHE3JYifr8Z2fQPRJnLVnds+2
         2+qcO4EOOtY693VuekSjbsz7xJdriG9evijgowAkPo3bkkM7xG2MoGe5GFHuM0Uf/RlX
         jX2Q==
X-Gm-Message-State: AOAM531qfpHi1d1rqAHK6E5TOeP6n4chjhQige7XEAh1N7MhkGW1PVRn
        fr1HWIYHyzPVxblgKBR6WKoVlgz0PFk=
X-Google-Smtp-Source: ABdhPJzlV4U/srLQ8740//Az3NxUMHd+jS0Tmn2XG4cy1W6sJ4u2UZQ5tZtRKJ1pv7W4ws0ROR2Axw==
X-Received: by 2002:a63:7e48:0:b0:398:5eed:a768 with SMTP id o8-20020a637e48000000b003985eeda768mr32102642pgn.519.1649802025134;
        Tue, 12 Apr 2022 15:20:25 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:24 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 13/26] lpfc: Move MI module parameter check to handle dynamic disable
Date:   Tue, 12 Apr 2022 15:19:55 -0700
Message-Id: <20220412222008.126521-14-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lpfc_refresh_params can be called for an async event handler.

This could potentially override the value initialized by lpfc_cmf_setup

Move module parameter check to lpfc_refresh_params.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 8 +++++++-
 drivers/scsi/lpfc/lpfc_sli.c  | 4 ----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7dfd47dcaad9..ec6da7e27e4b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -686,8 +686,14 @@ lpfc_sli4_refresh_params(struct lpfc_hba *phba)
 		return rc;
 	}
 	mbx_sli4_parameters = &mqe->un.get_sli4_parameters.sli4_parameters;
-	phba->sli4_hba.pc_sli4_params.mi_ver =
+
+	/* Are we forcing MI off via module parameter? */
+	if (phba->cfg_enable_mi)
+		phba->sli4_hba.pc_sli4_params.mi_ver =
 			bf_get(cfg_mi_ver, mbx_sli4_parameters);
+	else
+		phba->sli4_hba.pc_sli4_params.mi_ver = 0;
+
 	phba->sli4_hba.pc_sli4_params.cmf =
 			bf_get(cfg_cmf, mbx_sli4_parameters);
 	phba->sli4_hba.pc_sli4_params.pls =
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index ca7766940b4e..3b9359c1ee1c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7994,10 +7994,6 @@ lpfc_cmf_setup(struct lpfc_hba *phba)
 
 	sli4_params = &phba->sli4_hba.pc_sli4_params;
 
-	/* Are we forcing MI off via module parameter? */
-	if (!phba->cfg_enable_mi)
-		sli4_params->mi_ver = 0;
-
 	/* Always try to enable MI feature if we can */
 	if (sli4_params->mi_ver) {
 		lpfc_set_features(phba, mboxq, LPFC_SET_ENABLE_MI);
-- 
2.26.2

