Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A60523185D
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 22:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762467351; cv=none; b=IIsFhWitXw6CWGxIzg4Rr7DOvkFrGECJ18YXfgPMdOUSKQTaGWHPliyVwrBkZnMRvSRHYlgwlIkDiQLn5rWsc8xXEafTc1ZMQ+QjKVamS/TNBHRf/bR2y7uHX9Jw8YZbHUWZbHf5lnC4llW0ndO5w4BjCYz4q+TE4BbdvKVilag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762467351; c=relaxed/simple;
	bh=Cqw5uLw24whIDVDFFQG2Cc1sieYwYFB8it3Xt2Lzy6k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TOkL+fwLCAq2Nr6oQm1kPyTKo+FYXNWwZ79Bv0Hdhx8ehtasfklGlAyGAo3helsqYHdqQogH0wJcaf2T7ZIAZOL5Lul+s+ZYrVzeJvPXOX8krg41QfJgUiUTPoba7Eu8JvCiNplCbrSoHYXwaKZLTm4Cs5wzLWucb79uWjjYGzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bg6BAm/I; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bg6BAm/I"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so141698b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 06 Nov 2025 14:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762467348; x=1763072148; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3tFxGuwU2nati/m2tCqJ5qxiZDa35cxXRDiyEw8qDNg=;
        b=Bg6BAm/ItdtBc2n73tBgXdWrtQL/VA7G/AtxqAhQ/30rRSX3xmAeG41gMh41OnfNFV
         YjhD57fRvxEaEy4cTqy8v29ylp+Xxqr/Gb/p16UoT+e7MVXWzUcG577F+4M0hnW+hxGu
         0GHMx/qWSJsSJEa7q6U/D52ggscvyadwIIyrB7usjoTUUcr91tQN0XkZ6ShaHRT6qqyl
         xOPKEj2QvqRCTUdufkMYV/31Zvx7iEsebCTuP/4CP/baaz2eBjJ3awASkgdxJaKrzNsc
         5dfMVPYQrhB53LD0i6DOY68MoTDy59oKe4Gszrpp50YWCHu153JZID9DsLrmkHDVsBZv
         5SAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762467348; x=1763072148;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3tFxGuwU2nati/m2tCqJ5qxiZDa35cxXRDiyEw8qDNg=;
        b=l2pOLio3GFdFQd6qML3zE76qvcQGepkhEWsLBRmm6YV7eH8hdlnOn2JCT2coicpyZ5
         6vDr13O+NE2tNVfixK/jO9tbIfMd0xQq/v2ds1ucSAs076li0LEJznB9OWlC7xceglNu
         tp9XjqCTLvTXD9IiK3BmxXmavK9vfHpZoKES1GEIY8aEqbqjE9xsb7lAJo1k/+EJSpNL
         c2qAaMg+iaqa77YU4ryLDAbepFEE+K1H3C1ZfEJex/+fvWQCRpyaFrlcDSzwfC9/k/fd
         wTrcNKTIbUvmy8yuPRzeL1VxE3nIuhOwmGCkyXVv26BQLjXvsAi+3M6u37YGQvoCmbhq
         gSRQ==
X-Gm-Message-State: AOJu0YzTK39TaWXSunL7yalGOqGljmJRcYTWZwzksK4QFAauJZKkOzKh
	X+dZFrYyNsW2ZDW+qhVFEsUlkVpfwTE/0qY3uxlGax7c1CD5h6RYuAzCRXN3uDil
X-Gm-Gg: ASbGncsoaVaqkyxg6vm/UT5XzSs96wc0m0pHb16P69f6W6hUdX0/17AcqjV8h4TnNqy
	e7rnb3IgXLWzFbeOvoDM/LaYEWdF8mrwJxl7kDAh+QiR30xqLJiEGOUkhTlOJZMz84szNwwX90g
	T82/SQYKXKgacdx9Xo/UndyUFljzWD4FV+zZZFTLYsp5/XJMSJm2WWg1EeSmuzu2XiEeTWUoHHM
	r67No6o4Vt5yB31jka/bhCutkI87AbT2HwjJi+dzgGJKYqnCxjgzzgmQYO8uQzO3f/O30ome5an
	CqN5pTfq+Rxaqv7JAsJzdhtCdC9Olkru/Z2ztcRtgvd45NjaKn60tC7vzjTD78xlFGPjKXI3sLc
	MzobA9ih8BUyEUxtTbiHxTQ5bP+kXUaxIsVbYpWp5QDp8Em/PrKKxz+du8YNrnggT+xE87Pc9kE
	w++gXaQsfZgrJ26hdLq32kS0AGuvRRbVur/Cr1ptcs+v9gYWOQmNnVhlCs45t7
X-Google-Smtp-Source: AGHT+IF1HcLLQn50Vvt6PFLYmH4MOBhzFQZpd5lo2CClwH72EDVQMk46eBy/ZuwOIH0j0mppKRsSaA==
X-Received: by 2002:a05:6a00:99a:b0:781:4f0b:9c58 with SMTP id d2e1a72fcca58-7b0bd5a9e9cmr1346506b3a.15.1762467348520;
        Thu, 06 Nov 2025 14:15:48 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ccc59de7sm568901b3a.65.2025.11.06.14.15.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Nov 2025 14:15:48 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 06/10] lpfc: Modify kref handling for Fabric Controller ndlps
Date: Thu,  6 Nov 2025 14:46:35 -0800
Message-Id: <20251106224639.139176-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251106224639.139176-1-justintee8345@gmail.com>
References: <20251106224639.139176-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, there is a kref put in the lpfc_cleanup routine that takes care
of outstanding references on fabric controller ndlps in UNUSED state.
While typically there is a state change from UNUSED -> REGLOGIN when the
ndlp successfully logs into the fabric, there may be cases when FLOGI is
unsuccessful and the ndlp will remain in UNUSED state without a registered
rpi, yet the ndlp incorrectly has a kref count of one.

To address this, handling of Fabric Controller ndlps are moved into the
routines: lpfc_issue_els_scr, lpfc_issue_els_rdf, lpfc_cmpl_els_disc_cmd.

In both lpfc_issue_els_scr and lpfc_issue_els_rdf, if there does not exist
a previously created fabric controller ndlp, an ndlp will be created.
Otherwise, we can reuse the pre-existing ndlp object.

In lpfc_cmpl_els_disc_cmd, if the SCR or RDF are not successfully issued,
the initial reference on the ndlp that is not registered with upper layers
will be decremented with a kref_put.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c  | 97 ++++++++++++++++++++++++-----------
 drivers/scsi/lpfc/lpfc_init.c |  6 ---
 2 files changed, 67 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b6ce7e0f8a9b..00cfd4ac4ccd 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3390,11 +3390,21 @@ lpfc_cmpl_els_disc_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_cmpl_els_edc(phba, cmdiocb, rspiocb);
 		return;
 	}
+
 	if (ulp_status) {
 		/* ELS discovery cmd completes with error */
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS | LOG_CGN_MGMT,
 				 "4203 ELS cmd x%x error: x%x x%X\n", cmd,
 				 ulp_status, ulp_word4);
+
+		/* In the case where the ELS cmd completes with an error and
+		 * the node does not have RPI registered, the node is
+		 * outstanding and should put its initial reference.
+		 */
+		if ((cmd == ELS_CMD_SCR || cmd == ELS_CMD_RDF) &&
+		    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD) &&
+		    !test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
+			lpfc_nlp_put(ndlp);
 		goto out;
 	}
 
@@ -3463,6 +3473,7 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint8_t retry)
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	struct lpfc_nodelist *ndlp;
+	bool node_created = false;
 
 	cmdsize = (sizeof(uint32_t) + sizeof(SCR));
 
@@ -3472,21 +3483,21 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint8_t retry)
 		if (!ndlp)
 			return 1;
 		lpfc_enqueue_node(vport, ndlp);
+		node_created = true;
 	}
 
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_SCR);
 	if (!elsiocb)
-		return 1;
+		goto out_node_created;
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		rc = lpfc_reg_fab_ctrl_node(vport, ndlp);
 		if (rc) {
-			lpfc_els_free_iocb(phba, elsiocb);
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
 					 "0937 %s: Failed to reg fc node, rc %d\n",
 					 __func__, rc);
-			return 1;
+			goto out_free_iocb;
 		}
 	}
 	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
@@ -3505,23 +3516,27 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint8_t retry)
 	phba->fc_stat.elsXmitSCR++;
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_disc_cmd;
 	elsiocb->ndlp = lpfc_nlp_get(ndlp);
-	if (!elsiocb->ndlp) {
-		lpfc_els_free_iocb(phba, elsiocb);
-		return 1;
-	}
+	if (!elsiocb->ndlp)
+		goto out_free_iocb;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue SCR:     did:x%x refcnt %d",
 			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
-		lpfc_els_free_iocb(phba, elsiocb);
-		lpfc_nlp_put(ndlp);
-		return 1;
-	}
+	if (rc == IOCB_ERROR)
+		goto out_iocb_error;
 
 	return 0;
+
+out_iocb_error:
+	lpfc_nlp_put(ndlp);
+out_free_iocb:
+	lpfc_els_free_iocb(phba, elsiocb);
+out_node_created:
+	if (node_created)
+		lpfc_nlp_put(ndlp);
+	return 1;
 }
 
 /**
@@ -3734,7 +3749,12 @@ lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
  *
  * Return code
  *   0 - Successfully issued rdf command
- *   1 - Failed to issue rdf command
+ *   < 0 - Failed to issue rdf command
+ *   -EACCES - RDF not required for NPIV_PORT
+ *   -ENODEV - No fabric controller device available
+ *   -ENOMEM - No available memory
+ *   -EIO - The mailbox failed to complete successfully.
+ *
  **/
 int
 lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
@@ -3745,25 +3765,30 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 	struct lpfc_nodelist *ndlp;
 	uint16_t cmdsize;
 	int rc;
+	bool node_created = false;
+	int err;
 
 	cmdsize = sizeof(*prdf);
 
+	/* RDF ELS is not required on an NPIV VN_Port. */
+	if (vport->port_type == LPFC_NPIV_PORT)
+		return -EACCES;
+
 	ndlp = lpfc_findnode_did(vport, Fabric_Cntl_DID);
 	if (!ndlp) {
 		ndlp = lpfc_nlp_init(vport, Fabric_Cntl_DID);
 		if (!ndlp)
 			return -ENODEV;
 		lpfc_enqueue_node(vport, ndlp);
+		node_created = true;
 	}
 
-	/* RDF ELS is not required on an NPIV VN_Port. */
-	if (vport->port_type == LPFC_NPIV_PORT)
-		return -EACCES;
-
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_RDF);
-	if (!elsiocb)
-		return -ENOMEM;
+	if (!elsiocb) {
+		err = -ENOMEM;
+		goto out_node_created;
+	}
 
 	/* Configure the payload for the supported FPIN events. */
 	prdf = (struct lpfc_els_rdf_req *)elsiocb->cmd_dmabuf->virt;
@@ -3789,8 +3814,8 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_disc_cmd;
 	elsiocb->ndlp = lpfc_nlp_get(ndlp);
 	if (!elsiocb->ndlp) {
-		lpfc_els_free_iocb(phba, elsiocb);
-		return -EIO;
+		err = -EIO;
+		goto out_free_iocb;
 	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
@@ -3799,11 +3824,19 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
-		lpfc_els_free_iocb(phba, elsiocb);
-		lpfc_nlp_put(ndlp);
-		return -EIO;
+		err = -EIO;
+		goto out_iocb_error;
 	}
 	return 0;
+
+out_iocb_error:
+	lpfc_nlp_put(ndlp);
+out_free_iocb:
+	lpfc_els_free_iocb(phba, elsiocb);
+out_node_created:
+	if (node_created)
+		lpfc_nlp_put(ndlp);
+	return err;
 }
 
  /**
@@ -3824,19 +3857,23 @@ static int
 lpfc_els_rcv_rdf(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		 struct lpfc_nodelist *ndlp)
 {
+	int rc;
+
+	rc = lpfc_els_rsp_acc(vport, ELS_CMD_RDF, cmdiocb, ndlp, NULL);
 	/* Send LS_ACC */
-	if (lpfc_els_rsp_acc(vport, ELS_CMD_RDF, cmdiocb, ndlp, NULL)) {
+	if (rc) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS | LOG_CGN_MGMT,
-				 "1623 Failed to RDF_ACC from x%x for x%x\n",
-				 ndlp->nlp_DID, vport->fc_myDID);
+				 "1623 Failed to RDF_ACC from x%x for x%x Data: %d\n",
+				 ndlp->nlp_DID, vport->fc_myDID, rc);
 		return -EIO;
 	}
 
+	rc = lpfc_issue_els_rdf(vport, 0);
 	/* Issue new RDF for reregistering */
-	if (lpfc_issue_els_rdf(vport, 0)) {
+	if (rc) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS | LOG_CGN_MGMT,
-				 "2623 Failed to re register RDF for x%x\n",
-				 vport->fc_myDID);
+				 "2623 Failed to re register RDF for x%x Data: %d\n",
+				 vport->fc_myDID, rc);
 		return -EIO;
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 34386b7c0b48..a9c6dbe3b465 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3057,12 +3057,6 @@ lpfc_cleanup(struct lpfc_vport *vport)
 		lpfc_vmid_vport_cleanup(vport);
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		if (ndlp->nlp_DID == Fabric_Cntl_DID &&
-		    ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
-			lpfc_nlp_put(ndlp);
-			continue;
-		}
-
 		/* Fabric Ports not in UNMAPPED state are cleaned up in the
 		 * DEVICE_RM event.
 		 */
-- 
2.38.0

