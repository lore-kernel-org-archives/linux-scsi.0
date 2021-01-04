Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75387C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FCAF20784
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbhADSDd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbhADSDd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 13:03:33 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40159C061793
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:02:53 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id x126so16854639pfc.7
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 10:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JgjUe5w4slwLjxbuMZGbJaaBWik0mmAnLfFJ73jPLKI=;
        b=Hf+X7Nr9bKhK8bXjQciq9LGe5Rrtku/uYBeJJNCj+6oSo/hEaRwbx1JIlIE3RceAbK
         HXut/eLE0mPm84yPUPsHlYemQnSnZhWdwkL6/eMP5QqVLr9ZJA7uJ/QlARUfuNmDowkN
         y6Oyp8swhydxNWaQuR2RjJ7EgKAVdsIzmkrGfx//JpPYGW6DAUdnYEc382epBaHKL770
         kXNUsJmXkfc1iF9NuRCWpMqSr52AFW7bV7BGhtqwHk+CK5uWm0dmBkZkuCxcc9t7BGxK
         mY3Ia8EV0tn2WosR/LRDQ76RU5Ahbzwuy7AHL62Rm73qnqV/t4iiuU5fu+w3VQ+rW2dN
         fIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JgjUe5w4slwLjxbuMZGbJaaBWik0mmAnLfFJ73jPLKI=;
        b=cRY+EuB9OEEaf40IQrTDuaiaEHCtNNwUiJrhRrFDgNpBh7lJ1jTLoxOY4wag42he0j
         ltirWrDQchM62xQ3ad5H9yy+Xinf/o1VpdePYRodwqRTygn2LO48Zb7Ion+CA4dqRE5U
         5RFKb0SrB3y9UHC3CgSafr6PrvS3Zs/EAFs0XjEZH+OUBlw4ZZBjyIAR8FSLtbrNsE6E
         r7ZefzSevH5Bj/0k4/5hsNEHcrjVzIL+vWucd2TaBy3HAZSYqnxg39IVotGoOydwfl++
         eZjujnYYIIF6f0pz8TD0BX6GFuvdF5gR+hb+IJxRC9x8iHvYaL2OVUa1frXhRGJBHQmP
         jA7Q==
X-Gm-Message-State: AOAM531PdgbH0O8Ij2i513lE9u6MY51PVi4KbFmlcOvElmA3WE10cbFA
        QIuJxzjdEaLoX5pOalbI/k1jPZaXSBw=
X-Google-Smtp-Source: ABdhPJwWbdsbvoI1Mc1I5xI+pgXKLh9uVZUJzeugI7kpLlv3oQE+kuFK8e1wSmGuv6z6hyCbD+8s5A==
X-Received: by 2002:a63:4517:: with SMTP id s23mr54955390pga.267.1609783372673;
        Mon, 04 Jan 2021 10:02:52 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q23sm57570885pfg.18.2021.01.04.10.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 10:02:52 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 01/15] lpfc: Fix PLOGI S_ID of 0 on pt2pt config
Date:   Mon,  4 Jan 2021 10:02:26 -0800
Message-Id: <20210104180240.46824-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104180240.46824-1-jsmart2021@gmail.com>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Under some pt2pt situations, the other end of the link may issue a LOGO
after successfully completing PLOGI and assigning addresses to the port.
Thus the driver may attempt a new PLOGI to re-create the login, but the
LOGO handling cleared the address back to 0. Once this happens, the other
end, which may be address 0, gets all confused and this cannot be
resolved without an administrative action to bounce the link.

Fix by assuming that address assignment only occurs on the 1st PLOGI
after link up, and regardless of login state, the address assignment
sticks.  The FC standards aren't particularly clear in this situation
(it only describes initial PLOGI), but there is nothing that contradicts
this and behaviors on the devices tested appears to conform to the
understanding.

Thus, don't reset the port address to 0 as part of LOGO handling. Port
addresses will only reset on link down.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 31 +++++--------------------------
 1 file changed, 5 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 96c087b8b474..e099caa04535 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2815,7 +2815,6 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
 	struct lpfc_vport *vport = ndlp->vport;
 	IOCB_t *irsp;
-	struct lpfcMboxq *mbox;
 	unsigned long flags;
 	uint32_t skip_recovery = 0;
 
@@ -2884,31 +2883,11 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	lpfc_els_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
 
-	/* If we are in pt2pt mode, we could rcv new S_ID on PLOGI */
-	if ((vport->fc_flag & FC_PT2PT) &&
-		!(vport->fc_flag & FC_PT2PT_PLOGI)) {
-		phba->pport->fc_myDID = 0;
-
-		if ((vport->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
-		    (vport->cfg_enable_fc4_type == LPFC_ENABLE_NVME)) {
-			if (phba->nvmet_support)
-				lpfc_nvmet_update_targetport(phba);
-			else
-				lpfc_nvme_update_localport(phba->pport);
-		}
-
-		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-		if (mbox) {
-			lpfc_config_link(phba, mbox);
-			mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-			mbox->vport = vport;
-			if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT) ==
-				MBX_NOT_FINISHED) {
-				mempool_free(mbox, phba->mbox_mem_pool);
-				skip_recovery = 1;
-			}
-		}
-	}
+	/* At this point, the LOGO processing is complete. NOTE: For a
+	 * pt2pt topology, we are assuming the NPortID will only change
+	 * on link up processing. For a LOGO / PLOGI initiated by the
+	 * Initiator, we are assuming the NPortID is not going to change.
+	 */
 
 	/*
 	 * If the node is a target, the handling attempts to recover the port.
-- 
2.26.2

