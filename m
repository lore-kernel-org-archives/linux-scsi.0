Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF350C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:47:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EE7F64E42
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhBKXrF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhBKXqa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:46:30 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DD9C061356
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:45:02 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id j5so5047659pgb.11
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+m/bcVxdbXKOoyNhZDx07E3SkoTRAPy1E89UFuN/IDg=;
        b=FdDvOVUOwSZshIMK3G+iLliEaY9ZX9dhzlGB5FZ8RZ9VBNIqISlGJPWaqrwhUak55K
         /LCpqVXF6l2RyDRX+goZvi63hgwpxEoJ9ar5MMMGK+zl01IfjA9I7ejns97JcOUVU2We
         BsMVcsQGgPwP6SGFYGf/IGC2kt3h7kPr5NOoXdCGRsJwfI5XJF18PGLVpI2cKC4BalGW
         32/On+yBUJklDq7BGMXQn+HaqA1d2OnCvmKZDJVUSundeFI5YB/8F7I8SV2zrKQPRYzV
         SJ1JlmqJe5qymUGqxumYtO0kR05atyEaO9sugWcGUkIGxpHDWYjGULcm252rmuZz6oa+
         d90Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+m/bcVxdbXKOoyNhZDx07E3SkoTRAPy1E89UFuN/IDg=;
        b=MYLWGWZtgOFlGRkF7PhqXMYBG+wW7subEB7KnyLwz94x34dAWoELaZc7fQhi8ta9bp
         DP56UiMV6d8GGWlRk/mcta/Bab/BCs7VL9acI6HUaACFaIFJ3Mj/yFsXOWOhpD/jeHhc
         rBJd03zPHrcsn4Tykv/N8vBjoy/LzJwvuFVtiD0LmX0LxBpqiulIn3nenHEz5wNF3Vsn
         I4+P3S8T0TOspjLUqZxYS9idADwRIQV12NG/8lNCnAxOoY1qS28t+GfwWLh78L7gw9VF
         O94Bkf6l6QqTRvgwEyLy2Q0YZiQ4QpmaczLtSFMTDLU/mTsuudhlJa+RmTxGqUR5Y2St
         axbg==
X-Gm-Message-State: AOAM532yH6E2rmUondHeLUNc159QHI8C8a/MsIl/PORyP2ly1iL56T/x
        +Z57NbJtQ4Q4LAefKsksNpYzv9Vc+Q4=
X-Google-Smtp-Source: ABdhPJzJX/YWnYXUQt22Tu8LjITHkY40k+W2gKhU4qcWm4gjWy8FSolGEh/3qr2fs3wSAe7k0RqtaQ==
X-Received: by 2002:a62:aa06:0:b029:1d9:6738:26b3 with SMTP id e6-20020a62aa060000b02901d9673826b3mr474456pff.75.1613087102038;
        Thu, 11 Feb 2021 15:45:02 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:45:01 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 16/22] lpfc: Fix pt2pt state transition causing rmmod hang
Date:   Thu, 11 Feb 2021 15:44:37 -0800
Message-Id: <20210211234443.3107-17-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
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

