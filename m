Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA6B32D450
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 23:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761607455; cv=none; b=i7eLBDEoEiy5jQH7a1mR1PpBhG8THXXZomqW2/P9c45zi7hbqr9U5fkjRxhRgQAeGP9jLID7vcAwiqKjS240PkKu/rZbZrcuspLufKkK6AXoUeU3HU6x6sf+DvfAbjAwgoQQDRRqwjY+2pMe+y1cqg8HN9ypbcAZjAPih610+2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761607455; c=relaxed/simple;
	bh=r6+nqfnCNWIhqivJrmq2IjA2KpAH5rc57wQYVit7yFk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A9eV9xn7XvWWkStm4gzkD2hHe7CcvvT+xxndOsm9YVoKJoQTxjZ1SH6mp0hqy+IOjYY18ESmmsc8KHbXxy63JuG6l6Qx5TOpmYoqF5Afan1pCLHRUj43nnAiB0gk0OzxlNIJq6x9KFUjHbzoLg9D4qjI85Q6aqw+D0GoIhiiQOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AWOT7rTP; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AWOT7rTP"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-32ec291a325so4089800a91.1
        for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 16:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761607453; x=1762212253; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tnd532xb7jT9mLxfkPPIDOtd/xUKiueZEi3aQYrPaw8=;
        b=AWOT7rTPXFLgbM/lvnMdgjeZVDsRto7gEmUsENztqrCFatpoGgoRlT9W07+QGmZAoJ
         f6ZNjdGHTH8/2ALsJ9gKMZU3NpdmvDuC4jCeX3ACvNUcKK0cAKIY8nqudvGeWIzIzmn5
         Q6LLdZZUKAn+E0MnBld9vkyjdcPOUbWEeDcK5eRRY0GSdXzsHm+z5t22L6VDsuBV+adF
         EI3phAjEgMQfBJkIAtYRCte/fvB5N3zfDgilRrTQPtnGcY87X1DcF5X3xoQ1MKdtgGLw
         k+FnIpQmXBPEIu+4f+Ej+PNJo9rogzGKzydEskn/Kee5Bi25AMb3HAAclDY7MqXoHkVZ
         9nVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761607453; x=1762212253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tnd532xb7jT9mLxfkPPIDOtd/xUKiueZEi3aQYrPaw8=;
        b=cb1SFfAMavAkGZegtUaxpyAWJu2tPrRaGwarcN72nEcDnp3xkQos1fxCWFIBJMIBpO
         Jim9LX1DSszNRf1w9Dz6uRJQvlbcl195ILCyrhpWBbjCdX1fNuBObt32XjKJCh/J+b/w
         8RHZWYxn9G8+TQv2IDKDHvH4jNaPOPaZIpqAoTtgsppJvb4nHDdj5xPNv3LCFysg68jT
         o0u4Fs9/OpnydWIHTC71Z0M2spwNcRTZY7NLGky+M8mxVEmmRcZfGA8E+gxaxiMquLDo
         bha8f58+PubLj90dpOz3IbElhZHvkZ//To/iZN53NU+5E1OWqIWGoA4HtRkO47hywNjI
         wuqw==
X-Gm-Message-State: AOJu0YzJeVJo3kL57O3cVeZAvZLmrqCRGM5S347c8hKRNkiJr33/J6gJ
	YLqT8EQf8gbjgW+290bbH+ixMU500Ua9MDsT7mYmV0GwwF2d7I2asUFUtqRnGg==
X-Gm-Gg: ASbGncsgc4sVs00fyJVoVj48X2tVWySH6HFTihDROGZUVdeXTXAxitoPYTdZ8R5UYRL
	Lc85JBAVqPMNZTHXpEAliQoTUPWADbHc0luM/OoCI5Mpa2lAr1YyoQqCsB3JfGb5txsk4ECjioN
	+IlpV+Az4D5y94cjAs/RUwCZH1PXrp6xfUj1Xu3VAIBlc8bX4A5siONnPYeNz6bKFRif3G73UD4
	Rhey5MplH7zY1J8lWhUqjNLyUtM61anRlddMP2aCOnjlJSwO3H3Wjn2rPrQdSdgOSf+Ws1HNRRg
	1oOJQx5pGOGyzGPtsh4qsbiymnsjb22uvEZwKt/UHLA1ljIP8oCBqJVTEqCETDmjSp3TriK/+Gq
	iPeXQXrlnDGHPhu+3whQrhgMWYb7Qf5nImP6ynBxBGQDvD5VdDy2i+xaReGPfevfxOs19vm0LIO
	GYuw5AicPs9r04yimeLYY6UsrbB+1BcW/u8pyFt/Pn4Xa6Js3iMyufpj+NbzbM
X-Google-Smtp-Source: AGHT+IG9pd43bwARGSxE6v61xuU58Pss+ZnkvnrI+YWLOQWfW0MgUy8l550ejN5FG/6F9tW+6WuO2w==
X-Received: by 2002:a17:902:ec8a:b0:27d:339c:4b0 with SMTP id d9443c01a7336-294cb52e4e8mr19916015ad.35.1761607453229;
        Mon, 27 Oct 2025 16:24:13 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498e41159sm93805855ad.91.2025.10.27.16.24.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Oct 2025 16:24:12 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 02/11] lpfc: Revise discovery related function headers and comments
Date: Mon, 27 Oct 2025 16:54:37 -0700
Message-Id: <20251027235446.77200-3-justintee8345@gmail.com>
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

Correcting discovery related function headers, return status information,
and comment descriptions.  There are no functional changes.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 17 ++++++++---------
 drivers/scsi/lpfc/lpfc_sli.c |  9 +++++----
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f7c6758557c8..5456d2ab2d36 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3024,6 +3024,7 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			      ndlp->nlp_DID, ulp_status,
 			      ulp_word4);
 
+		/* Call NLP_EVT_DEVICE_RM if link is down or LOGO is aborted */
 		if (lpfc_error_lost_link(vport, ulp_status, ulp_word4))
 			skip_recovery = 1;
 	}
@@ -3306,7 +3307,8 @@ lpfc_reg_fab_ctrl_node(struct lpfc_vport *vport, struct lpfc_nodelist *fc_ndlp)
  *
  * This routine is a generic completion callback function for Discovery ELS cmd.
  * Currently used by the ELS command issuing routines for the ELS State Change
- * Request (SCR), lpfc_issue_els_scr() and the ELS RDF, lpfc_issue_els_rdf().
+ * Request (SCR), lpfc_issue_els_scr(), Exchange Diagnostic Capabilities (EDC),
+ * lpfc_issue_els_edc()  and the ELS RDF, lpfc_issue_els_rdf().
  * These commands will be retried once only for ELS timeout errors.
  **/
 static void
@@ -3705,10 +3707,7 @@ lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 		lpfc_nlp_put(ndlp);
 		return 1;
 	}
-	/* This will cause the callback-function lpfc_cmpl_els_cmd to
-	 * trigger the release of the node.
-	 */
-	/* Don't release reference count as RDF is likely outstanding */
+
 	return 0;
 }
 
@@ -4299,7 +4298,7 @@ lpfc_issue_els_edc(struct lpfc_vport *vport, uint8_t retry)
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		/* The additional lpfc_nlp_put will cause the following
-		 * lpfc_els_free_iocb routine to trigger the rlease of
+		 * lpfc_els_free_iocb routine to trigger the release of
 		 * the node.
 		 */
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -5127,7 +5126,7 @@ lpfc_els_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *elsiocb)
 {
 	struct lpfc_dmabuf *buf_ptr, *buf_ptr1;
 
-	/* The I/O iocb is complete.  Clear the node and first dmbuf */
+	/* The I/O iocb is complete.  Clear the node and first dmabuf */
 	elsiocb->ndlp = NULL;
 
 	/* cmd_dmabuf = cmd,  cmd_dmabuf->next = rsp, bpl_dmabuf = bpl */
@@ -8734,7 +8733,7 @@ lpfc_els_rcv_rls(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
  *
- * This routine processes Read Timout Value (RTV) IOCB received as an
+ * This routine processes Read Timeout Value (RTV) IOCB received as an
  * ELS unsolicited event. It first checks the remote port state. If the
  * remote port is not in NLP_STE_UNMAPPED_NODE state or NLP_STE_MAPPED_NODE
  * state, it invokes the lpfc_els_rsl_reject() routine to send the reject
@@ -10843,7 +10842,7 @@ lpfc_els_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	lpfc_els_unsol_buffer(phba, pring, vport, elsiocb);
 	/*
 	 * The different unsolicited event handlers would tell us
-	 * if they are done with "mp" by setting cmd_dmabuf to NULL.
+	 * if they are done with "mp" by setting cmd_dmabuf/bpl_dmabuf to NULL.
 	 */
 	if (elsiocb->cmd_dmabuf) {
 		lpfc_in_buf_free(phba, elsiocb->cmd_dmabuf);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7ea7c4245c69..41eb558dd139 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -19858,13 +19858,15 @@ lpfc_sli4_remove_rpis(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli4_resume_rpi - Remove the rpi bitmask region
+ * lpfc_sli4_resume_rpi - Resume traffic relative to an RPI
  * @ndlp: pointer to lpfc nodelist data structure.
  * @cmpl: completion call-back.
  * @iocbq: data to load as mbox ctx_u information
  *
- * This routine is invoked to remove the memory region that
- * provided rpi via a bitmask.
+ * Return codes
+ *	0 - successful
+ *	-ENOMEM - No available memory
+ *	-EIO - The mailbox failed to complete successfully.
  **/
 int
 lpfc_sli4_resume_rpi(struct lpfc_nodelist *ndlp,
@@ -19894,7 +19896,6 @@ lpfc_sli4_resume_rpi(struct lpfc_nodelist *ndlp,
 		return -EIO;
 	}
 
-	/* Post all rpi memory regions to the port. */
 	lpfc_resume_rpi(mboxq, ndlp);
 	if (cmpl) {
 		mboxq->mbox_cmpl = cmpl;
-- 
2.38.0

