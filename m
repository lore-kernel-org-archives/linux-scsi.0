Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4FAFC4332B
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79E3E6508D
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238444AbhCAR2B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237964AbhCARV2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:21:28 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FDEC061224
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:38 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id s23so12341320pji.1
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+m/bcVxdbXKOoyNhZDx07E3SkoTRAPy1E89UFuN/IDg=;
        b=vE8dW/FE8rdZN03g4dIUQt+gzLKMInaH6QaKwTNDmXhM30p2eCF9FWypaHmjoPchhR
         T2MqBlyjt8q9/E70LR6voQECs1wbawT2jgnWFR+2qaZLtyAuMVFqqajVPczR7J7Bc6MT
         zpIZmGaYWsPJPUjXmQsAILeu7fSAdiGp/NP/2M/UE+D8/7Y/9PhbAfbS2QQMUH5ZtD4/
         fegXPjLh7wWmjOo5kwj5vVKdvFVerO2wXH1UK9p9hr5Brtsm+yz0kQ7EUTvYnJkZoKm1
         ZhRNuOWb4l5BB56NmozEqHukHVsBb/4bwXFnZ0gPVOANvZZ7jz82pgdPJijK2ZPGPic4
         ms8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+m/bcVxdbXKOoyNhZDx07E3SkoTRAPy1E89UFuN/IDg=;
        b=BJagxPm1kcaWjUjqhb1OUXiwuLhQI/uY75k8/YkJ7b7Q2yyCt7IWTSIM+zR6pOXGfC
         +zArJUOaKLPyWtXbrxXdK15o+5YoPrSCes576i56/XoBgKHodR6QTiFW3ArmhZA+9IEn
         1r6bHceJBOUmqi3bxA2HCo4gPxXiIoKMMkaqOvWdG1gesoEq1iA/siY6kgBvtb2/mQzE
         KnzM5bqOGjfGqTe0JmizoPmP8m9bOrKdIN5aP+ozHpLa5mQiD7cLpy6qdu9lGtWyrBEs
         6BI1b1gkOdsDlij3Q0YOoqUxs/jIgirx7DUHQUAAiRR2oQtwYmYmixg6obSzwYCPdW+d
         JyGg==
X-Gm-Message-State: AOAM530L1M942Gzdu+xSvsOoVIv/46UlEWgZTmpIIs8gsDm1cehoJJ5q
        k1ldouxQAZLfxsXMCmYfgP0+kVIgaHU=
X-Google-Smtp-Source: ABdhPJzwbKU2cJSNymvzXUD0EJxt48Lx8b6tv1Ta+icA6NG9M/+AwvHwbEeqoA1DYd2rgAXjEEVHKg==
X-Received: by 2002:a17:90a:ce03:: with SMTP id f3mr18620527pju.195.1614619118176;
        Mon, 01 Mar 2021 09:18:38 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:37 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 16/22] lpfc: Fix pt2pt state transition causing rmmod hang
Date:   Mon,  1 Mar 2021 09:18:15 -0800
Message-Id: <20210301171821.3427-17-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On a setup with a dual port HBA and both ports direct connected, an rmmod
hangs momentarily when we log an Illegal State Transition. Once it resumes,
a nodelist not empty logic is hit, which forces rmmod to cleanup and exit.
We're missing a state transition case in the discovery engine.

Fix by adding a case for a DEVICE_RM event while in the unmapped state to
avoid illegal state transition log message.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 090a4232bfa8..e178ffb4e4eb 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -2485,6 +2485,16 @@ lpfc_rcv_prlo_unmap_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	return ndlp->nlp_state;
 }
 
+static uint32_t
+lpfc_device_rm_unmap_node(struct lpfc_vport *vport,
+			  struct lpfc_nodelist *ndlp,
+			  void *arg,
+			  uint32_t evt)
+{
+	lpfc_drop_node(vport, ndlp);
+	return NLP_STE_FREED_NODE;
+}
+
 static uint32_t
 lpfc_device_recov_unmap_node(struct lpfc_vport *vport,
 			     struct lpfc_nodelist *ndlp,
@@ -2978,7 +2988,7 @@ static uint32_t (*lpfc_disc_action[NLP_STE_MAX_STATE * NLP_EVT_MAX_EVENT])
 	lpfc_disc_illegal,		/* CMPL_LOGO       */
 	lpfc_disc_illegal,		/* CMPL_ADISC      */
 	lpfc_disc_illegal,		/* CMPL_REG_LOGIN  */
-	lpfc_disc_illegal,		/* DEVICE_RM       */
+	lpfc_device_rm_unmap_node,	/* DEVICE_RM       */
 	lpfc_device_recov_unmap_node,	/* DEVICE_RECOVERY */
 
 	lpfc_rcv_plogi_mapped_node,	/* RCV_PLOGI   MAPPED_NODE    */
-- 
2.26.2

