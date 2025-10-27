Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047C032F744
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 23:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761607461; cv=none; b=nhP8ZdntPfoQBm/Oz0m8putnlugIqxX/boQQb18UTx0fh2g/QPmXm1TpP5quAKV31imdiaLbeEqUOhMN5FMOoaT2FKa3ycoSP6OZdPT/TDTWX33QS3v3LJrVliN61YgL/6iRZi4/XIwOftyXJEof1L6QzIxtyon4/6MjYjT9Bmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761607461; c=relaxed/simple;
	bh=NM5P1x4793T6zZL77FtYBa+0BPlIc0xJhIpxo+h0SF0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EF8cm+HZyhvdPFL1+iPc6s9fIkkfho14WW3iojuCjV4PxBANxpxeFaAXhOj+1GzP7vrxr+gFWxQ6ct8+dlMSzRiRfGz0hggHM+1wXO7L3oFKda3+bNgh0YWYOURkAaU/moozQCLyMQN1kG3AQQ6anWKX1xpf1xjgqpITkP5tHCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FJxVfgHs; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FJxVfgHs"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2947d345949so44906715ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 16:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761607459; x=1762212259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EIY1rUl10htfqqPqYC8CynCMdBwDL/Si6ajTdG8R8Es=;
        b=FJxVfgHsirNorbOGMhspnCLLeqWwbv+nrqfHzO0+iwaVugmN8gK0NMyLO/dHrSstIy
         OLYLbiyHtEbAc7DadQvmfIMuwldvPfN/60dPnuJrurkpySjbzAZSSPfG7ZfKw7xUgZoS
         R+C1ZEazcixneRYKQMNk1YdWbWVqBEMjk4cIZ4zWgdOaBI13yDix8Iu2/9vY73X6PCWs
         u45KAeA8pmzm8es1akFhcrleAVan2FDNmoNwa69g215OED7ANE5m7rUh0gI5mYibUHM9
         E3NpalfGvdYIRtQBS81MC2fk1utMV1ZWo960aNzgF/4B85ufkyttV/nhX5tya4pSRb5m
         C0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761607459; x=1762212259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EIY1rUl10htfqqPqYC8CynCMdBwDL/Si6ajTdG8R8Es=;
        b=vSvqKguS3GaMh7ThxzBqZv6EeAwAOcPrAMxhaPKjvPDax6AyuLQfSuKlorS1tK720w
         CqxXsC+uGjGbAk7+ogZtsrcY+NVeci+TdCg9Tm3w+6zBkI0SIGJF+/P7k3Cyn9I8cK3I
         aWXyWz8ptfo2rp4k9vjgXxtX782Z2bxNptBejGlZ332unghLq956krqULcV+7y1dpbYl
         r04HLCMjNQ83GzTRLoAvLX9cr0+gOa+HnXhXSuUFTnNL7kukH7FcVn9gVikniEKjEd3N
         udJB/aDMYPqrroMu9KDyIb9O76WrQs20NC6jTm/jH3Rqrmivn+IcZfQWoYXNXXNaZgXq
         4aNA==
X-Gm-Message-State: AOJu0YyE5HExzpMuD2C/moaTWvjqnnmg2H/ug0u8s5OZA9jvwkinJJq+
	sc8n2HqvgiOmV8NkOgBe2ZnVw9iBwxGeD6V6VLaXwmEz2YbNG7eF8Ve4zQhhiA==
X-Gm-Gg: ASbGnctbUH0+bSeQfrvVuW/5BX8r2H3ExIts0su/OId2Q6jS5IfHZ5Tx1UZfhKxQOSI
	4YGxxBZ7nXyr6FYUj4tWIqjhxWTB8UNcH826JVr3wqUtwz8Xl5bkvaPL3/Cpxw88t5LIOiM+Xlv
	v4kz8TZ6quU76vlWxR6jiooE8e1vSQ/ZJ8UFlJhtCKt/SZb36vLMsif6E2ZIkXXcefxhU6RH0ct
	4KGtbWRqhE6D8RVemuXRpFRXR2RSXNIZyDk4LwTJ0APXAGn+Biiau5vyhdpeKvF1OXA85/xz6dm
	1SWN2CYjItgVzN/UYbYbOymTdS2GFLxLMLcNcczch410gpyjoiBAfeSXDI3aMTy8PEIHqXbsGSP
	bhyK+z2oBB4H+2eZqEQnSRK4n4+0oPX23APWBepKHdfgnyeLQR6FMcPY3VqkTCX71LYsmNlO0Y2
	AtFuUvH4FfHGPAQMv010/7Y9+YOn2Zl922x12AVQBw7uOROpcfFb29Ji/orVMd3JJco6N3XcU=
X-Google-Smtp-Source: AGHT+IH/MgZ9/naxOMmnhve31WZ3bzsqLi6y/gw/xuJsfX+Wj//a8L+28nTZKWL/BV2jz/NIZoJx5w==
X-Received: by 2002:a17:902:ecc3:b0:272:c95c:866 with SMTP id d9443c01a7336-294cb3adc80mr19465695ad.20.1761607458987;
        Mon, 27 Oct 2025 16:24:18 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498e41159sm93805855ad.91.2025.10.27.16.24.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Oct 2025 16:24:18 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 06/11] lpfc: Modify kref handling for Fabric Controller ndlps
Date: Mon, 27 Oct 2025 16:54:41 -0700
Message-Id: <20251027235446.77200-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251027235446.77200-1-justintee8345@gmail.com>
References: <20251027235446.77200-1-justintee8345@gmail.com>
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

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
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

