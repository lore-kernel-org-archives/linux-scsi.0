Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB630C63798
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9606A22450
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="arYMWNk2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgKOT1E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 14:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbgKOT1D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 14:27:03 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532C0C0613D1
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:03 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id h16so6694745pgb.7
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=581mWpYSkbjRsvY7z6U1NZtOwUZaeecnEd+VwP+iQlM=;
        b=arYMWNk2QTpujml5OKNM9BNYQudfJYn/AmgiuVxeiS3UeISwXi0eOGhWVi/wBtJ6S1
         41AOgxGTTX2HDSh/ILEwGuxd+RkorvY9IUaCYOMabkfQwPI+aT08ZQc9RrN3FCUsCj+o
         wuDGsb438HKLyPRJ8i5AK+x61zhG4kF9OGXEI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=581mWpYSkbjRsvY7z6U1NZtOwUZaeecnEd+VwP+iQlM=;
        b=Ypmb+cZAEQ0TW5UHbJktj/I4dlx1OlLPDJFG4L49lBS6EYvpQg1kCm5fQZXnsmL6S5
         FIcccKw3C/Mx5ESOYDrd3Y0HcEIJ2JBWsUh1sSGrM9R4RafCsPLzIdzTAvxrXTgB3KKL
         gvDtDTTV2989s/DPIEieWxY9kGdLuPKt6OaKBrary1XdfwuJV5g9nBxWlWKlN746EQPw
         sQkJKcDuh6buEYZwYwPx+pbY3hXXejXNXjezZb5/1A7aeKgj77vAF/K4BAaS3bWXWbmk
         d68kXOv2aehmFPkSvZw7ovtl5yipRG5L5S4BspgaLJ7yOLWYjrJIEpo7ohg5g2s/gqcV
         N6/A==
X-Gm-Message-State: AOAM532zHeuhlSE90hqol23kc3+iBiBfy8rqs926EIZ3Tyss0mFmn/D8
        wwA4APzSYte5rQXAbwSeLdMqtwpgKOgXzj0s3sLSRjQS8kkIDnHZu5oRaj2Dt710x5aBs1pZlwB
        9m4+d7bK7ulqXsQoYjR7+f+W2crlXQGG+fTwFhcRQLqI1ula67aH9JpifkQy9SQQD+JawMo/D1v
        MYmyU=
X-Google-Smtp-Source: ABdhPJyBadtPZv8UIPpH7xXkjtXKHLIwfi9uB8Y4X9NKHIY8hioeF/daPwFia/67/0gPB/d2xJu2LA==
X-Received: by 2002:a17:90a:a08f:: with SMTP id r15mr12329707pjp.118.1605468421931;
        Sun, 15 Nov 2020 11:27:01 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v126sm15864604pfb.137.2020.11.15.11.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 11:27:01 -0800 (PST)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 06/17] lpfc: Remove ndlp when a PLOGI/ADISC/PRLI/REG_RPI ultimately fails
Date:   Sun, 15 Nov 2020 11:26:35 -0800
Message-Id: <20201115192646.12977-7-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201115192646.12977-1-james.smart@broadcom.com>
References: <20201115192646.12977-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000008f7d605b42a3fad"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000008f7d605b42a3fad
Content-Transfer-Encoding: 8bit

When a PLOGI/ADISC/PRLI/REG_RPI fails, the node remains in the nodelist
in that state.  Although the driver now frees a node when the ref count
goes to zero, in this case the ref cnt doesn't reach zero because there
isn't a mechanism to release the final reference.  Discovery just stops.

Fix by calling the node discovery state machine DEVICE_RM event whenever
one of these commands fail. This will remove the final reference count
and trigger node release.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c     | 66 +++++++++++++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 39 +++++++++++--------
 2 files changed, 85 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 565ab29abf3c..225215a04313 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1988,12 +1988,25 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 "2753 PLOGI failure DID:%06X Status:x%x/x%x\n",
 				 ndlp->nlp_DID, irsp->ulpStatus,
 				 irsp->un.ulpWord[4]);
-		/* Do not call DSM for lpfc_els_abort'ed ELS cmds. Just execute
-		 * the final node put to free it to the pool.
+
+		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
+		if (lpfc_error_lost_link(irsp))
+			goto check_plogi;
+		else
+			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
+						NLP_EVT_CMPL_PLOGI);
+
+		/* As long as this node is not registered with the scsi or nvme
+		 * transport, it is no longer an active node.  Otherwise
+		 * devloss handles the final cleanup.
 		 */
-		if (!lpfc_error_lost_link(irsp))
+		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
+			spin_lock_irq(&ndlp->lock);
+			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+			spin_unlock_irq(&ndlp->lock);
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_DEVICE_RM);
+		}
 	} else {
 		/* Good status, call state machine */
 		prsp = list_entry(((struct lpfc_dmabuf *)
@@ -2004,6 +2017,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					NLP_EVT_CMPL_PLOGI);
 	}
 
+ check_plogi:
 	if (disc && vport->num_disc_nodes) {
 		/* Check to see if there are more PLOGIs to be sent */
 		lpfc_more_plogi(vport);
@@ -2243,6 +2257,20 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		else
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_PRLI);
+
+		/* As long as this node is not registered with the scsi
+		 * or nvme transport and no other PRLIs are outstanding,
+		 * it is no longer an active node.  Otherwise devloss
+		 * handles the final cleanup.
+		 */
+		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) &&
+		    !ndlp->fc4_prli_sent) {
+			spin_lock_irq(&ndlp->lock);
+			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+			spin_unlock_irq(&ndlp->lock);
+			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
+						NLP_EVT_DEVICE_RM);
+		}
 	} else {
 		/* Good status, call state machine.  However, if another
 		 * PRLI is outstanding, don't call the state machine
@@ -2655,14 +2683,29 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 ndlp->nlp_DID, irsp->ulpStatus,
 				 irsp->un.ulpWord[4]);
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (!lpfc_error_lost_link(irsp))
+		if (lpfc_error_lost_link(irsp))
+			goto check_adisc;
+		else
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_ADISC);
+
+		/* As long as this node is not registered with the scsi or nvme
+		 * transport, it is no longer an active node. Otherwise
+		 * devloss handles the final cleanup.
+		 */
+		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
+			spin_lock_irq(&ndlp->lock);
+			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+			spin_unlock_irq(&ndlp->lock);
+			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
+						NLP_EVT_DEVICE_RM);
+		}
 	} else
 		/* Good status, call state machine */
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_CMPL_ADISC);
 
+ check_adisc:
 	/* Check to see if there are more ADISCs to be sent */
 	if (disc && vport->num_disc_nodes)
 		lpfc_more_adisc(vport);
@@ -2879,8 +2922,21 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 irsp->un.ulpWord[4], irsp->ulpTimeout,
 				 vport->num_disc_nodes);
 		lpfc_disc_start(vport);
+		return;
+	}
+
+	/* Cleanup path for failed REG_RPI handling. If REG_RPI fails, the
+	 * driver sends a LOGO to the rport to cleanup.  For fabric and
+	 * initiator ports cleanup the node as long as it the node is not
+	 * register with the transport.
+	 */
+	if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
+		spin_lock_irq(&ndlp->lock);
+		ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+		spin_unlock_irq(&ndlp->lock);
+		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
+					NLP_EVT_DEVICE_RM);
 	}
-	return;
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 8f3106aadfc7..ac05d188f816 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -204,10 +204,13 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 
 	spin_lock_irqsave(&ndlp->lock, iflags);
 	ndlp->nlp_flag |= NLP_IN_DEV_LOSS;
+	ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+
 	/*
-	 * The backend does not expect any more calls assoicated with this
-	 * rport, Remove the association between rport and ndlp
+	 * The backend does not expect any more calls associated with this
+	 * rport. Remove the association between rport and ndlp.
 	 */
+	ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
 	((struct lpfc_rport_data *)rport->dd_data)->pnode = NULL;
 	ndlp->rport = NULL;
 	spin_unlock_irqrestore(&ndlp->lock, iflags);
@@ -248,7 +251,6 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 	int warn_on = 0;
 	int fcf_inuse = 0;
 	unsigned long iflags;
-	u32 fc4_xpt_flags;
 
 	vport = ndlp->vport;
 	shost = lpfc_shost_from_vport(vport);
@@ -267,10 +269,11 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 			      ndlp->nlp_DID, ndlp->nlp_type, ndlp->nlp_sid);
 
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
-			 "3182 %s x%06x, nflag x%x xflags x%x\n",
+			 "3182 %s x%06x, nflag x%x xflags x%x refcnt %d\n",
 			 __func__, ndlp->nlp_DID, ndlp->nlp_flag,
-			 ndlp->fc4_xpt_flags);
+			 ndlp->fc4_xpt_flags, kref_read(&ndlp->kref));
 
+	/* If the driver is recovering the rport, ignore devloss. */
 	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 				 "0284 Devloss timeout Ignored on "
@@ -282,8 +285,11 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 		return fcf_inuse;
 	}
 
-	if (ndlp->nlp_type & NLP_FABRIC)
+	/* Fabric nodes are done. */
+	if (ndlp->nlp_type & NLP_FABRIC) {
+		lpfc_nlp_put(ndlp);
 		return fcf_inuse;
+	}
 
 	if (ndlp->nlp_sid != NLP_NO_SID) {
 		warn_on = 1;
@@ -311,12 +317,7 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 				 ndlp->nlp_state, ndlp->nlp_rpi);
 	}
 
-	/* Should be final reference removal triggering a node free. */
-	spin_lock_irqsave(shost->host_lock, iflags);
-	fc4_xpt_flags = ndlp->fc4_xpt_flags;
-	spin_unlock_irqrestore(shost->host_lock, iflags);
-
-	if (!(fc4_xpt_flags & (NVME_XPT_REGD | SCSI_XPT_REGD)))
+	if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
 		lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);
 
 	return fcf_inuse;
@@ -3587,7 +3588,7 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	pmb->ctx_buf = NULL;
 	pmb->ctx_ndlp = NULL;
 
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI,
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_SLI | LOG_NODE | LOG_DISCOVERY,
 			 "0002 rpi:%x DID:%x flg:%x %d x%px\n",
 			 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag,
 			 kref_read(&ndlp->kref),
@@ -4079,8 +4080,16 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		kfree(mp);
 		mempool_free(pmb, phba->mbox_mem_pool);
 
-		/* If no other thread is using the ndlp, free it */
-		lpfc_nlp_not_used(ndlp);
+		/* If the node is not registered with the scsi or nvme
+		 * transport, remove the fabric node.  The failed reg_login
+		 * is terminal.
+		 */
+		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD))) {
+			spin_lock_irq(&ndlp->lock);
+			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+			spin_unlock_irq(&ndlp->lock);
+			lpfc_nlp_not_used(ndlp);
+		}
 
 		if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
 			/*
-- 
2.26.2


--00000000000008f7d605b42a3fad
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
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgtiomDoYKiGQlFQU9
t+RctgB8G8n2Ukbi5Xg5g3bGu1EwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTE1MTkyNzAyWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAC4JsQrwsHI4Iq98wm23wdsrOviTzrHvII8z
ROK4I/H+qnvqgmhSV6Ded/JGL3+tw5htYgbx9XWOXnLEzRVMumV2rgsOjuCTU0JdkvNXkYEB16EF
nDcBcq4qJ2koWpvVT2Xz0WIhp5dOvTjXd4HdQa2MjS1UEHly+7d/h0IdBSzRfOM4tuiUw6c+nPUN
E8JQne9vwJyu1eQ2jAyeOhE7XZ1ceQC9ZPxOLDGfgZOOky19RLd2fKBpnHzb/wYOoWkitmdg93i3
twX8v3hBhva+CSE03DmhdI5v66TRRsTU209aN+TdX1ySEfmM0icFCmigR/0HCbgmtEqmRsstW/QC
SDQ=
--00000000000008f7d605b42a3fad--
