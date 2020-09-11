Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5200EC2D0E0
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 20:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E864C21D79
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 20:02:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PMeyXkkj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbgIKUCH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 16:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgIKUCA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2020 16:02:00 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B98C061757
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2020 13:01:59 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a9so2230505pjg.1
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2020 13:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jYYXSMgbEBiquEkbfhvV5VJwd9+XhX8oh+NLUwmyPJ8=;
        b=PMeyXkkjMhNl5i05nbrES1dKGN3AI/CV7sxTHN2Rpb1+G/0IX2LPBr1BYWFiKSLTgF
         722ylEauaEeaqayrqD5XH4fqD6IMN4o4doYalKaT5HDMIQhs253LBNHe2ef+SAH1YPGR
         mXqAmONQ2/seQYyYtKvhGnySvEo6fGV+6h34s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jYYXSMgbEBiquEkbfhvV5VJwd9+XhX8oh+NLUwmyPJ8=;
        b=B6bRS0dRnfn6JYrVsqW/40s6XDDT021n3eZjkpAX2GW8pN97eTSl9HnnEbp7Hh+4sa
         6UnXE94iKiBuLNoVXHUaV0FhBTgJzv091MfVpC87UEMnxcTTbLo6XV2QCnkonnHvrorm
         uiAJA3c/eYRUDxOeQfHzR9OWFxatg9wM5mxkF+v7NaNuHhicUTOia3dirZqBGWjloXhk
         uqCW5Z+vy560c+pwokOngEj0EJY2NZMgx5cLATBmCSqgWUZUB/xLd9aVQUesBLKxKPBW
         me4why9vgigEYvgvVRBO3HuRDySTyVK0LoL894zp0kV1BAmJ3ayhUCEq4f+h3+DNQzlr
         Lg8A==
X-Gm-Message-State: AOAM530mOG0FlJP6apqWgHGxU/Ifb9iRDh8T/aXjoKoqgl2vbp3dhGAi
        UPZ3yKYl36KcRy6oX0arRZVaCrrPrbFADa3/Atht5uB8osKNRG4K/qKr1dZY7QuEYIIxiMkgePH
        EXb/LuntEfCDI1tcmncStLzXf/lqbu1CZbBaGotHsPhGdEdEzI0lJZ6BTrzCHFw/+cBGtVTcTbR
        PsqU6oTw==
X-Google-Smtp-Source: ABdhPJywlhXz4+cecijANgXxvE+aGa7LVJiWMiUQxpV/HdFumX141HetRkJmcAjeLRMHz+X4oCA7pw==
X-Received: by 2002:a17:902:8d84:b029:d1:9bc8:258c with SMTP id v4-20020a1709028d84b02900d19bc8258cmr4138796plo.18.1599854518387;
        Fri, 11 Sep 2020 13:01:58 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s22sm3331442pfd.90.2020.09.11.13.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 13:01:56 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>, stable@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH] lpfc: Fix initial FLOGI failure due to BBSCN not supported
Date:   Fri, 11 Sep 2020 13:01:47 -0700
Message-Id: <20200911200147.110826-1-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Initial FLOGIs are failing with the following message:
 lpfc 0000:13:00.1: 1:(0):0820 FLOGI Failed (x300). BBCredit Not Supported

In a prior patch, the READ_SPARAM command was re-ordered to post after
CONFIG_LINK as the driver is expected to update the driver's copy of
the service parameters for the FLOGI payload. if the bb-credit recovery
feature is enabled, this is fine. But on adapters were bb-credit recovery
isn't enabled, it would cause the FLOGI to fail.

Fix by restoring the original command order (READ_SPARAM before
CONFIG_LINK), and after issuing CONFIG_LINK, detect bb-credit recovery
support and reissuing READ_SPARAM to obtain the updated service parameters
(effectively adding in the fix command order).

Fixes: 692fc8380ca0 ("scsi: lpfc: Fix broken Credit Recovery after driver load")
CC: <stable@vger.kernel.org> # v5.7+
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 76 ++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 142a02114479..bf06d8549bd3 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -71,6 +71,7 @@ static void lpfc_disc_timeout_handler(struct lpfc_vport *);
 static void lpfc_disc_flush_list(struct lpfc_vport *vport);
 static void lpfc_unregister_fcfi_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 static int lpfc_fcf_inuse(struct lpfc_hba *);
+static void lpfc_mbx_cmpl_read_sparam(struct lpfc_hba *, LPFC_MBOXQ_t *);
 
 void
 lpfc_terminate_rport_io(struct fc_rport *rport)
@@ -1138,11 +1139,13 @@ lpfc_mbx_cmpl_clear_la(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	return;
 }
 
-
 void
 lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport *vport = pmb->vport;
+	LPFC_MBOXQ_t *sparam_mb;
+	struct lpfc_dmabuf *sparam_mp;
+	int rc;
 
 	if (pmb->u.mb.mbxStatus)
 		goto out;
@@ -1167,12 +1170,42 @@ lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	}
 
 	/* Start discovery by sending a FLOGI. port_state is identically
-	 * LPFC_FLOGI while waiting for FLOGI cmpl. Check if sending
-	 * the FLOGI is being deferred till after MBX_READ_SPARAM completes.
+	 * LPFC_FLOGI while waiting for FLOGI cmpl.
 	 */
 	if (vport->port_state != LPFC_FLOGI) {
-		if (!(phba->hba_flag & HBA_DEFER_FLOGI))
+		/* Issue MBX_READ_SPARAM to update CSPs before FLOGI if
+		 * bb-credit recovery is in place.
+		 */
+		if (phba->bbcredit_support && phba->cfg_enable_bbcr &&
+		    !(phba->link_flag & LS_LOOPBACK_MODE)) {
+			sparam_mb = mempool_alloc(phba->mbox_mem_pool,
+						  GFP_KERNEL);
+			if (!sparam_mb)
+				goto sparam_out;
+
+			rc = lpfc_read_sparam(phba, sparam_mb, 0);
+			if (rc) {
+				mempool_free(sparam_mb, phba->mbox_mem_pool);
+				goto sparam_out;
+			}
+			sparam_mb->vport = vport;
+			sparam_mb->mbox_cmpl = lpfc_mbx_cmpl_read_sparam;
+			rc = lpfc_sli_issue_mbox(phba, sparam_mb, MBX_NOWAIT);
+			if (rc == MBX_NOT_FINISHED) {
+				sparam_mp = (struct lpfc_dmabuf *)
+						sparam_mb->ctx_buf;
+				lpfc_mbuf_free(phba, sparam_mp->virt,
+					       sparam_mp->phys);
+				kfree(sparam_mp);
+				sparam_mb->ctx_buf = NULL;
+				mempool_free(sparam_mb, phba->mbox_mem_pool);
+				goto sparam_out;
+			}
+
+			phba->hba_flag |= HBA_DEFER_FLOGI;
+		}  else {
 			lpfc_initial_flogi(vport);
+		}
 	} else {
 		if (vport->fc_flag & FC_PT2PT)
 			lpfc_disc_start(vport);
@@ -1184,6 +1217,7 @@ lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			 "0306 CONFIG_LINK mbxStatus error x%x "
 			 "HBA state x%x\n",
 			 pmb->u.mb.mbxStatus, vport->port_state);
+sparam_out:
 	mempool_free(pmb, phba->mbox_mem_pool);
 
 	lpfc_linkdown(phba);
@@ -3239,21 +3273,6 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 	lpfc_linkup(phba);
 	sparam_mbox = NULL;
 
-	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
-		cfglink_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-		if (!cfglink_mbox)
-			goto out;
-		vport->port_state = LPFC_LOCAL_CFG_LINK;
-		lpfc_config_link(phba, cfglink_mbox);
-		cfglink_mbox->vport = vport;
-		cfglink_mbox->mbox_cmpl = lpfc_mbx_cmpl_local_config_link;
-		rc = lpfc_sli_issue_mbox(phba, cfglink_mbox, MBX_NOWAIT);
-		if (rc == MBX_NOT_FINISHED) {
-			mempool_free(cfglink_mbox, phba->mbox_mem_pool);
-			goto out;
-		}
-	}
-
 	sparam_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!sparam_mbox)
 		goto out;
@@ -3274,7 +3293,20 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 		goto out;
 	}
 
-	if (phba->hba_flag & HBA_FCOE_MODE) {
+	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
+		cfglink_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+		if (!cfglink_mbox)
+			goto out;
+		vport->port_state = LPFC_LOCAL_CFG_LINK;
+		lpfc_config_link(phba, cfglink_mbox);
+		cfglink_mbox->vport = vport;
+		cfglink_mbox->mbox_cmpl = lpfc_mbx_cmpl_local_config_link;
+		rc = lpfc_sli_issue_mbox(phba, cfglink_mbox, MBX_NOWAIT);
+		if (rc == MBX_NOT_FINISHED) {
+			mempool_free(cfglink_mbox, phba->mbox_mem_pool);
+			goto out;
+		}
+	} else {
 		vport->port_state = LPFC_VPORT_UNKNOWN;
 		/*
 		 * Add the driver's default FCF record at FCF index 0 now. This
@@ -3331,10 +3363,6 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 		}
 		/* Reset FCF roundrobin bmask for new discovery */
 		lpfc_sli4_clear_fcf_rr_bmask(phba);
-	} else {
-		if (phba->bbcredit_support && phba->cfg_enable_bbcr &&
-		    !(phba->link_flag & LS_LOOPBACK_MODE))
-			phba->hba_flag |= HBA_DEFER_FLOGI;
 	}
 
 	/* Prepare for LINK up registrations */
-- 
2.26.2

