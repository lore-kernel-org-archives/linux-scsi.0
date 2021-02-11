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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2AA5C4332D
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96B1164E5B
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhBKXpt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhBKXpf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:45:35 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC48C061788
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:54 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d13so4210700plg.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jZnDFDhmZxAbNsPTBNmg8t5ZrDV3N7RQhi/1GZYlyRI=;
        b=o0Z8Lvg3ytLa8DNvzq5sZezI3IeBKLLD9oJM+VFWpWZJz51QcmSLYsAZb8BGaXQGpp
         f/6vUSZWaE6JNaM7FZhE6+0OQX8S2CYvHvOCjm5JXdlo7kCnTKm8//qYbL9pBYDlPUjb
         AEiuB1Z9bTMfi6ezvhcwoh3zzyyzqdw47Q+Gd03LNtchk6oFv+bmGH948UTACvE8miUf
         BvXpok52ufCBiZqTKcGJO51OAP/NMv29KlNDpVotw1hTjZis+oFPURXVDboFsPnxNEiv
         Y95Oq1IsBjaIKTgrkoVOPAc80tkuIXKHfqE5nF812Luf0Ba3igPV/QMNInYar4uUZ+Nr
         S3zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jZnDFDhmZxAbNsPTBNmg8t5ZrDV3N7RQhi/1GZYlyRI=;
        b=FGX/UOOc4X/bzobS3fPbYfdqOMANJI2lTS2yjC+rZFZaH7ce7SAiJRJ+UKSYXUz8iD
         LI5ry48XAG3rNJvikf1Yj8cOSI+YXdAOc/L7COc6Z8umDa8txJIyY0FKi8dfH4IfTy0u
         5+vuTDRU58nK/c3IRM4TNgiiwNLzwZi7Oz3Pu4sNoU/jLCCjjV+cC6Q628KoRFIzP5ZF
         cit1+Ge8IPAArGiIQgMo7zJI5bdlMKQle4XNbGpMGNcauEtFJ+AloYQv1dUm6+YrzMcD
         /Bzs1yHs/O69Vfhf/3gNMI3SAl/3xgt9+w/+uxfdmSVn5eW7s2zozP3nmWkUoEBsl2//
         pSgg==
X-Gm-Message-State: AOAM532IqBoHL96fMdZrsgQx28xBKonWODkLYolFD3FMMgrkqgrKnlyh
        jpD19IxtFjYQQV+yp+p54qhInUfp0zI=
X-Google-Smtp-Source: ABdhPJzbVrYC9ad6IfvMeTkHGyiHNkuIrEgBch79MCn5incEkDxxOq5mWiR/sQgMPusI8cY+O3NuYA==
X-Received: by 2002:a17:902:c989:b029:e2:a0b3:1356 with SMTP id g9-20020a170902c989b02900e2a0b31356mr416128plc.51.1613087094147;
        Thu, 11 Feb 2021 15:44:54 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:44:53 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 05/22] lpfc: Fix FLOGI failure due to accessing a freed node
Date:   Thu, 11 Feb 2021 15:44:26 -0800
Message-Id: <20210211234443.3107-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After an initial successful FLOGI into the switch, if a subsequent FLOGI
fails the driver crashed accessing a node struct. On FLOGI error, the
flogi completion logic triggers the final dereference on the node
structure without checking if it is registered with a backend. The
devloss logic is triggered after node is freed leading to the access
of freed node.

Fix by adjusting the error path to not take the final dereferece if there
is an outstanding transport registration. Let the transport devloss call
remove the final reference.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 4687830e06da..780b4c1e98eb 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1182,7 +1182,8 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	phba->fcf.fcf_flag &= ~FCF_DISCOVERY;
 	spin_unlock_irq(&phba->hbalock);
 
-	lpfc_nlp_put(ndlp);
+	if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)))
+		lpfc_nlp_put(ndlp);
 	if (!lpfc_error_lost_link(irsp)) {
 		/* FLOGI failed, so just use loop map to make discovery list */
 		lpfc_disc_list_loopmap(vport);
-- 
2.26.2

