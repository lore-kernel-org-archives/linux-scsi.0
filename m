Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434AEC64E75
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D31E22450
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fQ4LuqoZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgKOT1M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 14:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727876AbgKOT1I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 14:27:08 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAB1C0613CF
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:07 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 131so806902pfb.9
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=uXD0A4RB1f/zcqW+dLYMOF60xigJE4xgFRURHsQQOZg=;
        b=fQ4LuqoZwuDy3vhPuu+cI2sFRSzv4vI337zQlZflx+9lSOApisLW/JuxWk/KUdC0UI
         lhpB3m/isJS1VHDAaPXy7SgE46FbNdMi1LLk/2JZXD6/Iy+qvYwhYx0VPmXSUqcEpRhi
         m+SElA3aod4X8Jxpv0NPzeu152q12URL8AZcs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=uXD0A4RB1f/zcqW+dLYMOF60xigJE4xgFRURHsQQOZg=;
        b=LXtO0T33QQ+orQJ3JWZm3NwxiChN8TBY2eP2KVMYuSs4Nr7R5baj+fgEJpZxMshraQ
         j+QolVuCGxThsUU6UHdJYqoNWnpo+YeXrEwaQR40fh3bUOWHFcdes6R1I2VF80Iubx37
         PsONxAyyVPxnJAdU9WxzFz+AWO9ISqmMvZ3QO9iBsod/W4GzeIelkj7VPcnju+nxVLSF
         FTb1jRIgR4JLW6cqV74VouH1jrYtZnXabrENdybeEzN/f/4DE0ad1su96PcIyRE8lM3i
         ivUh3kWaoXyyVaUDxgUSBhPwJhTYxrdM8XRj4SeI+hfvDz/T6FBm8SVTH5HbEXi/G7qP
         CjtQ==
X-Gm-Message-State: AOAM531bB2Z3GEOkd6FQ1weAQp0x2UGmucFaZC3eWwgsrfogcz4Tl9E/
        6+865RCrRKGO/rHIuAz7HpNSoR8nQiPdJRHnz8213IGiq4Lfq3FXWxSO5/Xh46AwrwL0LED3zkn
        YZfuVsCVuFPOC53XqOqttgx/511cJvT8ryMe0DaiJNltoFg/fMSABKMiUYGV4AeMkPjYXPw5NVw
        IRyGk=
X-Google-Smtp-Source: ABdhPJwe0e3lU9y6P19crvCWLOKeFmIVsty/xkpJNfxPhEc86wEsjuBtoC906C4JpHWg0Bx1heyXyg==
X-Received: by 2002:a62:7c95:0:b029:18c:5002:a1ab with SMTP id x143-20020a627c950000b029018c5002a1abmr10705922pfc.40.1605468426228;
        Sun, 15 Nov 2020 11:27:06 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v126sm15864604pfb.137.2020.11.15.11.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 11:27:05 -0800 (PST)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 09/17] lpfc: Fix NPIV Fabric Node reference counting
Date:   Sun, 15 Nov 2020 11:26:38 -0800
Message-Id: <20201115192646.12977-10-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201115192646.12977-1-james.smart@broadcom.com>
References: <20201115192646.12977-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000466ee005b42a3f68"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000466ee005b42a3f68
Content-Transfer-Encoding: 8bit

While testing initiator-side cable swaps with NPIV, oops occur.
The reference counts for the Fabric nodes on the NPIV vports isn't
balanced, resulting in premature node removal.

The following fixes were made:
- Removed the FC_LBIT check in lpfc_linkup_port. This removed the special
  case for vports that didn't have them clean up just like the physical
  port.
- Removed the unreg_rpi call in lpfc_cleanup_node. In this section, the
  node is being removed in the context of a reference count release
  and a mailbox command can't be issued at this point.
- Remove special case handling in the default mailbox completion handler
  that allowed the skipping of a node reference. Now, reference counting
  always requires the removal of the reference.
- Move the location of the DEVICE_RM event is done during LOGO handling
  as the driver has additional work to do on the ndlp before puts/releases
  can be performed.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c     | 47 +++++++++++++++++---------------
 drivers/scsi/lpfc/lpfc_hbadisc.c | 29 ++++++++------------
 drivers/scsi/lpfc/lpfc_init.c    |  6 ++--
 drivers/scsi/lpfc/lpfc_sli.c     | 10 +++++--
 4 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 6fc42c978730..48095bebd47b 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2835,8 +2835,9 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* LOGO completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0105 LOGO completes to NPort x%x "
-			 "Data: x%x x%x x%x x%x\n",
-			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4],
+			 "refcnt %d nflags x%x Data: x%x x%x x%x x%x\n",
+			 ndlp->nlp_DID, kref_read(&ndlp->kref), ndlp->nlp_flag,
+			 irsp->ulpStatus, irsp->un.ulpWord[4],
 			 irsp->ulpTimeout, vport->num_disc_nodes);
 
 	if (lpfc_els_chk_latt(vport)) {
@@ -2844,17 +2845,6 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		goto out;
 	}
 
-	/* Check to see if link went down during discovery */
-	if (ndlp->nlp_flag & NLP_TARGET_REMOVE) {
-	        /* NLP_EVT_DEVICE_RM should unregister the RPI
-		 * which should abort all outstanding IOs.
-		 */
-		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
-					NLP_EVT_DEVICE_RM);
-		skip_recovery = 1;
-		goto out;
-	}
-
 	/* The LOGO will not be retried on failure.  A LOGO was
 	 * issued to the remote rport and a ACC or RJT or no Answer are
 	 * all acceptable.  Note the failure and move forward with
@@ -2876,6 +2866,19 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* Call state machine. This will unregister the rpi if needed. */
 	lpfc_disc_state_machine(vport, ndlp, cmdiocb, NLP_EVT_CMPL_LOGO);
 
+	/* The driver sets this flag for an NPIV instance that doesn't want to
+	 * log into the remote port.
+	 */
+	if (ndlp->nlp_flag & NLP_TARGET_REMOVE) {
+		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
+					NLP_EVT_DEVICE_RM);
+		lpfc_els_free_iocb(phba, cmdiocb);
+		lpfc_nlp_put(ndlp);
+
+		/* Presume the node was released. */
+		return;
+	}
+
 out:
 	/* Driver is done with the IO.  */
 	lpfc_els_free_iocb(phba, cmdiocb);
@@ -4399,10 +4402,10 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		irsp->ulpStatus, irsp->un.ulpWord[4], ndlp->nlp_DID);
 	/* ACC to LOGO completes to NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "0109 ACC to LOGO completes to NPort x%x "
+			 "0109 ACC to LOGO completes to NPort x%x refcnt %d"
 			 "Data: x%x x%x x%x\n",
-			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
-			 ndlp->nlp_rpi);
+			 ndlp->nlp_DID, kref_read(&ndlp->kref), ndlp->nlp_flag,
+			 ndlp->nlp_state, ndlp->nlp_rpi);
 
 	if (ndlp->nlp_state == NLP_STE_NPR_NODE) {
 		/* NPort Recovery mode or node is just allocated */
@@ -8650,9 +8653,9 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	/* ELS command <elsCmd> received from NPORT <did> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0112 ELS command x%x received from NPORT x%x "
-			 "Data: x%x x%x x%x x%x\n",
-			cmd, did, vport->port_state, vport->fc_flag,
-			vport->fc_myDID, vport->fc_prevDID);
+			 "refcnt %d Data: x%x x%x x%x x%x\n",
+			 cmd, did, kref_read(&ndlp->kref), vport->port_state,
+			 vport->fc_flag, vport->fc_myDID, vport->fc_prevDID);
 
 	/* reject till our FLOGI completes or PLOGI assigned DID via PT2PT */
 	if ((vport->port_state < LPFC_FABRIC_CFG_LINK) &&
@@ -9144,9 +9147,9 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *phba, struct lpfc_vport *vport)
 	spin_lock_irq(shost->host_lock);
 	if (vport->fc_flag & FC_DISC_DELAYED) {
 		spin_unlock_irq(shost->host_lock);
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"3334 Delay fc port discovery for %d seconds\n",
-				phba->fc_ratov);
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+				 "3334 Delay fc port discovery for %d secs\n",
+				 phba->fc_ratov);
 		mod_timer(&vport->delayed_disc_tmo,
 			jiffies + msecs_to_jiffies(1000 * phba->fc_ratov));
 		return;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f3cf988733c2..4c5a0ffec86f 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4810,8 +4810,14 @@ lpfc_set_unreg_login_mbx_cmpl(struct lpfc_hba *phba, struct lpfc_vport *vport,
 {
 	unsigned long iflags;
 
+	/* Driver always gets a reference on the mailbox job
+	 * in support of async jobs.
+	 */
+	mbox->ctx_ndlp = lpfc_nlp_get(ndlp);
+	if (!mbox->ctx_ndlp)
+		return;
+
 	if (ndlp->nlp_flag & NLP_ISSUE_LOGO) {
-		mbox->ctx_ndlp = ndlp;
 		mbox->mbox_cmpl = lpfc_nlp_logo_unreg;
 
 	} else if (phba->sli_rev == LPFC_SLI_REV4 &&
@@ -4819,7 +4825,6 @@ lpfc_set_unreg_login_mbx_cmpl(struct lpfc_hba *phba, struct lpfc_vport *vport,
 		    (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) >=
 				      LPFC_SLI_INTF_IF_TYPE_2) &&
 		    (kref_read(&ndlp->kref) > 0)) {
-		mbox->ctx_ndlp = lpfc_nlp_get(ndlp);
 		mbox->mbox_cmpl = lpfc_sli4_unreg_rpi_cmpl_clr;
 	} else {
 		if (vport->load_flag & FC_UNLOADING) {
@@ -4828,9 +4833,7 @@ lpfc_set_unreg_login_mbx_cmpl(struct lpfc_hba *phba, struct lpfc_vport *vport,
 				ndlp->nlp_flag |= NLP_RELEASE_RPI;
 				spin_unlock_irqrestore(&ndlp->lock, iflags);
 			}
-			lpfc_nlp_get(ndlp);
 		}
-		mbox->ctx_ndlp = ndlp;
 		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 	}
 }
@@ -4888,6 +4891,11 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			lpfc_unreg_login(phba, vport->vpi, rpi, mbox);
 			mbox->vport = vport;
 			lpfc_set_unreg_login_mbx_cmpl(phba, vport, ndlp, mbox);
+			if (!mbox->ctx_ndlp) {
+				mempool_free(mbox, phba->mbox_mem_pool);
+				return 1;
+			}
+
 			if (mbox->mbox_cmpl == lpfc_sli4_unreg_rpi_cmpl_clr)
 				/*
 				 * accept PLOGIs after unreg_rpi_cmpl
@@ -5057,7 +5065,6 @@ lpfc_cleanup_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	struct lpfc_hba  *phba = vport->phba;
 	LPFC_MBOXQ_t *mb, *nextmb;
 	struct lpfc_dmabuf *mp;
-	unsigned long iflags;
 
 	/* Cleanup node for NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
@@ -5125,18 +5132,6 @@ lpfc_cleanup_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	lpfc_cleanup_vports_rrqs(vport, ndlp);
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		ndlp->nlp_flag |= NLP_RELEASE_RPI;
-	if (!lpfc_unreg_rpi(vport, ndlp)) {
-		/* Clean up unregistered and non freed rpis */
-		if ((ndlp->nlp_flag & NLP_RELEASE_RPI) &&
-		    !(ndlp->nlp_rpi == LPFC_RPI_ALLOC_ERROR)) {
-			lpfc_sli4_free_rpi(vport->phba,
-					   ndlp->nlp_rpi);
-			spin_lock_irqsave(&ndlp->lock, iflags);
-			ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
-			ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
-			spin_unlock_irqrestore(&ndlp->lock, iflags);
-		}
-	}
 	return 0;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f0cbf98e7caa..86d9ab4bcebb 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2851,10 +2851,8 @@ lpfc_cleanup(struct lpfc_vport *vport)
 			continue;
 		}
 
-		/* take care of nodes in unused state before the state
-		 * machine taking action.
-		 */
-		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
+		if (ndlp->nlp_DID == Fabric_Cntl_DID &&
+		    ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
 			lpfc_nlp_put(ndlp);
 			continue;
 		}
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 4f537a07bac6..116a6822c201 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2541,8 +2541,12 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			} else {
 				__lpfc_sli_rpi_release(vport, ndlp);
 			}
-			if (vport->load_flag & FC_UNLOADING)
-				lpfc_nlp_put(ndlp);
+
+			/* The unreg_login mailbox is complete and had a
+			 * reference that has to be released.  The PLOGI
+			 * got its own ref.
+			 */
+			lpfc_nlp_put(ndlp);
 			pmb->ctx_ndlp = NULL;
 		}
 	}
@@ -2566,7 +2570,7 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
  *
  * This function is the unreg rpi mailbox completion handler. It
  * frees the memory resources associated with the completed mailbox
- * command. An additional refrenece is put on the ndlp to prevent
+ * command. An additional reference is put on the ndlp to prevent
  * lpfc_nlp_release from freeing the rpi bit in the bitmask before
  * the unreg mailbox command completes, this routine puts the
  * reference back.
-- 
2.26.2


--000000000000466ee005b42a3f68
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgRpfmySR9Vtd8rnnX
tpimlF3KOu5Yhfls4AKE4vys66IwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTE1MTkyNzA2WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAIHnqy4kQQDEALh42FryfzoND0HwLoD1pr6P
xAPjZX1TRlQP4QNsMCNLlh2STErhico8LUc1AujoDVbfYO/BxJv37fZpK8BFx9q68f1LImYO7dWG
+Sll2p+kMfjpCO2Utpiz5hgTD8h648SsXV6PIM/z1wJLjhhMlq6es2p0xR0Ky5PpiVi9SkG+ryh6
l7vKSvmLi+/zyVO4kRbosIZ5etnQlAFm3ayguMwG2qwDH4RZPjKjNUoHBzFbb1yumbzDDorqf5GM
sC1e1SvAemEaXDhun2z1GyAIczwbXNMe9gBgxLThMSdDnNYmfWorWPzyEnBMLLWEsT501mnH5Bxd
hEo=
--000000000000466ee005b42a3f68--
