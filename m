Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D097C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24776611B0
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhIJXd2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 19:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234854AbhIJXdW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 19:33:22 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BB9C061756
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:10 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id j16so3259202pfc.2
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TB6O2EeP1WftlXbEahfA7Ed8vQ5inRUvqVbgSRnWOvI=;
        b=VfyvuaXOzyshUFbqny33HO/SMj0KJbP5bC66BzQb57U4m4pE0W0Nv0NU+GlCC3aIti
         HzNJft5hiy3/DhsC+qF5wteKrrgrPgU+lEZOJLeX3mYRdj0a90gY3BZokTZPzli/7QM7
         Q2NVcakRy/+5h7QWarI8N4lBZUOkstDg8rMhlKYfYCXqphhVhZMAl7lpawTc+poWhPyU
         JNj3c3teyB5A4AU9N7ylSYJ1iCNdXDKsnkjzmMdbfKiLXY8QDI9E64NSFklMLsDdXobK
         Cjt+mLkbEi8EHOo1s7YViC7m/UvXaWnNY4HTBZmLBEf62QRN61dyyaP62clMLveK8n93
         mAmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TB6O2EeP1WftlXbEahfA7Ed8vQ5inRUvqVbgSRnWOvI=;
        b=RHRsgBJjDVxxc9BIlgk09rz4/ON1IX+pa3uxzCZuP3tG8FBGqj6WXCaMkMdC3jkzi+
         UopD5x5z5PmXRwk7u3zOO2tDfsHFIRWuSU+FGzsCFuNWkFWdaxzuDfeKQ4JI3K8IrL0d
         BzkeBkWRBfr9DfvZgUGh5+AJOhUYweOd3kC4iY32DYuQpz88csnArb3kJUMmlBv8hMMC
         rsYC4W0cAxZU1IhFIvPxkpuaUw/0ZXFuKELnWDjXi7uh0aHygNMAU3STQcbGMvLt1oAA
         6L3YKN5isO5NbizHQfta/XtIuaaQm9kDYyWNNG1n4edSp0d4Jv+yxDcuP4VBlm35Yi2L
         vpkw==
X-Gm-Message-State: AOAM530SClK4d8hgdSFzB6F5VSGHXZKTJKea8G5maeAJi3E7yMCk/a37
        DWVKuie/ClI0wgyHKG7RXFKlRlh7UrA2IWCx
X-Google-Smtp-Source: ABdhPJwjzQj+bYG2hDCSIyiqdH9DtYP/b+XYm0thRf++XXG3S0hN3Oa86yEC/xCEmYyBKc3BryoK4w==
X-Received: by 2002:a63:da0a:: with SMTP id c10mr151954pgh.255.1631316730380;
        Fri, 10 Sep 2021 16:32:10 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o15sm11325pfk.143.2021.09.10.16.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 16:32:10 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 04/14] lpfc: Fix hang on unload due to stuck fport node
Date:   Fri, 10 Sep 2021 16:31:49 -0700
Message-Id: <20210910233159.115896-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210910233159.115896-1-jsmart2021@gmail.com>
References: <20210910233159.115896-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A test scenario encountered an unload hang while an FLOGI ELS was in
flight when a link down condition occurred.  The driver fails unload
as it never releases the fport node.

For most nodes, when the link drops, devloss tmo is started and the
timeout will cause the final node release. For the Fport, as it has
not yet registered with the SCSI transport, there is no devloss timer
to be started, so there is no final release.  Additionally, the link
down sequence causes ABORTS to be issued for pending ELS's. The
completions from the ABORTS perform the release of node references.
However, as the adapter is being reset to be unloaded, those
completions will never occur.

Fix by the following:
- In the els cleanup, recognize when unloading and place the els's
  on a different list that immediately cleansup/completes the els's.
  It's recognized that this condition primarily affects only the
  fport, with other ports having normal clean up logic that handles
  things.
- Resolve the devloss issue by, when cleaning up nodes on after link
  down, recognizing when the fabric node does not have a completed
  state (its state is UNUSED) and removing a reference so the node
  can delete after the els reference is released.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c     | 14 ++++++++++++++
 drivers/scsi/lpfc/lpfc_hbadisc.c | 14 +++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 262101e172ad..6c9cb87ef174 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -11386,6 +11386,7 @@ lpfc_sli4_vport_delete_els_xri_aborted(struct lpfc_vport *vport)
 {
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_sglq *sglq_entry = NULL, *sglq_next = NULL;
+	struct lpfc_nodelist *ndlp = NULL;
 	unsigned long iflag = 0;
 
 	spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock, iflag);
@@ -11393,7 +11394,20 @@ lpfc_sli4_vport_delete_els_xri_aborted(struct lpfc_vport *vport)
 			&phba->sli4_hba.lpfc_abts_els_sgl_list, list) {
 		if (sglq_entry->ndlp && sglq_entry->ndlp->vport == vport) {
 			lpfc_nlp_put(sglq_entry->ndlp);
+			ndlp = sglq_entry->ndlp;
 			sglq_entry->ndlp = NULL;
+
+			/* If the xri on the abts_els_sgl list is for the Fport
+			 * node and the vport is unloading, the xri aborted wcqe
+			 * likely isn't coming back.  Just release the sgl.
+			 */
+			if ((vport->load_flag & FC_UNLOADING) &&
+			    ndlp->nlp_DID == Fabric_DID) {
+				list_del(&sglq_entry->list);
+				sglq_entry->state = SGL_FREED;
+				list_add_tail(&sglq_entry->list,
+					&phba->sli4_hba.lpfc_els_sgl_list);
+			}
 		}
 	}
 	spin_unlock_irqrestore(&phba->sli4_hba.sgl_list_lock, iflag);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 6f2e07c30f98..4ff93aef3295 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -966,8 +966,20 @@ lpfc_cleanup_rpis(struct lpfc_vport *vport, int remove)
 	struct lpfc_nodelist *ndlp, *next_ndlp;
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
+		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
+			/* It's possible the FLOGI to the fabric node never
+			 * successfully completed and never registered with the
+			 * transport.  In this case there is no way to clean up
+			 * the node.
+			 */
+			if (ndlp->nlp_DID == Fabric_DID) {
+				if (ndlp->nlp_prev_state ==
+				    NLP_STE_UNUSED_NODE &&
+				    !ndlp->fc4_xpt_flags)
+					lpfc_nlp_put(ndlp);
+			}
 			continue;
+		}
 
 		if ((phba->sli3_options & LPFC_SLI3_VPORT_TEARDOWN) ||
 		    ((vport->port_type == LPFC_NPIV_PORT) &&
-- 
2.26.2

