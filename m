Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A252F360
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 00:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706660511; cv=none; b=u1Bjq09ru9Vx3Ah0IHlPn9zfXA1KTdJ2vKQgCZzW84f6Kpq8Gyr5eGtdlnpmo/k9NFoaHo874EiwuCFp1aFEv8YlBbSU5BH7vjLAdmQk7qyE7gHnsQU4PYsWGSCsIYGxuA/sWvypbLeQaCvnpKgkajJRGB5ztBeBbdDrYhu1DQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706660511; c=relaxed/simple;
	bh=kPFJ9k2AcYm+HmrE/tY411auQLJ2ARJXgB5Z7yLlbaA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TVsVARJxRLsRZUQLppqxcW+gZmdm1uJgLhBjFo0s2Rv4nZWvJbA3mJvZhMwpl6PMgKAklpSqE80kkJ1Fcu9Fbet2ywYUIrvGMCZQLfCHKq4VlV/Gevpb+6u60Cq79wZd4jlZ23NF7qmIe7ST7dR/cvAh9bij3GUFc9PHYCFmIWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d57GTajk; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d57GTajk"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-42a9499f0b3so2433011cf.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 16:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706660508; x=1707265308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bOursLVTHiRHXupI4CeVELJqkV1+J9wNgLMv7jgNRfA=;
        b=d57GTajk/2T4VTeoZwPtrMwjaJ5R/QpARxXo62iz4Jo4/4O/T843hdHHWmlIJvBR12
         d7oL0O7LauamMZ9VgE2GdGlFpRFb4cwz+1ChrTlKIcHxXL+rve/X9tWX00SGxkdBsS+/
         +ViES9VZqOznMr0Kn2rx4hJAPlRMaN3jm/d0bZ6rsMey2Byk7hO2X86Xlt6B53+ayfIA
         IQpBizI+w6BiOaMS/HBO4hEAdRBYpIsNVkC9RF+VrOJ9qKXzT+YTMAXCIJq7cLP+DSqe
         qW+BsdG6GsowrzJjMCD2ewD2qs2yxFznZ2UEvs/Ky0K+Q9IihHUvsZkuUZGmRh1GXanw
         Cb3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706660508; x=1707265308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bOursLVTHiRHXupI4CeVELJqkV1+J9wNgLMv7jgNRfA=;
        b=Yt95Q5qB6UEYJHKVBzp+xgh0bplgUH3pHINicOf+pkPMfeZq55RipvuxpkzXWV6Pkj
         XSQunhfLhXyzHl4wXM/Qcrk9PX9y+T3kTJwc2EIXi+ROcosGumWZXb+p+vtS7VyD8+wA
         V6Xrsu8bTpaLhohLUki0obA8DGVTjZ+GrrXN2KZEQegtmfJA2/3T+10XkI3WEncMqQXI
         z7iY7ZHwyKIsWDCXDlJ605U0jVIqYQZFjsF2X0DKsqJoqu/tHS490OdOm/vPcb5ushJn
         6i59PuTRo8zpdW0CB09ixuMgwF1EYTVxrP0WSSGz7NEGHkxRf4nXFtLomDT2oVpcFDW5
         I9Ag==
X-Gm-Message-State: AOJu0Yy7mEH6NceTlP/gWO1+sCnA8OVvHIgSi/457kl/Y6RCAnU4nEYA
	CD2nas4YW2T6nWbV4DZlfKqvXWaWqDRMW/WN2XUyTHg+jLIwRFQ9zaTcsS9Z
X-Google-Smtp-Source: AGHT+IEOa9qlh4IBZUWClVinncaMgVuekXeqnTjLhkHICOgKWjWRsQdygcVwpjCqUlzDFb57+pHMUg==
X-Received: by 2002:a05:6214:2cca:b0:68c:6d75:e875 with SMTP id lf10-20020a0562142cca00b0068c6d75e875mr83610qvb.3.1706660508098;
        Tue, 30 Jan 2024 16:21:48 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id qn19-20020a056214571300b0068c4ecc8886sm2600931qvb.127.2024.01.30.16.21.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jan 2024 16:21:47 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 05/17] lpfc: Allow lpfc_plogi_confirm_nport logic to execute for Fabric nodes
Date: Tue, 30 Jan 2024 16:35:37 -0800
Message-Id: <20240131003549.147784-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131003549.147784-1-justintee8345@gmail.com>
References: <20240131003549.147784-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the early return NLP_FABRIC check in lpfc_plogi_confirm_nport
because it is possible for switch domain controllers to change WWPN.

As a result, allow lpfc_plogi_confirm_nport to detect that a new ndlp
should be initialized in such cases.  The old ndlp object will be cleaned
up when dev_loss_tmo callbk executes.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 49 +++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 4d723200690a..a17c66e31637 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1696,18 +1696,13 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	struct serv_parm *sp;
 	uint8_t  name[sizeof(struct lpfc_name)];
 	uint32_t keepDID = 0, keep_nlp_flag = 0;
+	int rc;
 	uint32_t keep_new_nlp_flag = 0;
 	uint16_t keep_nlp_state;
 	u32 keep_nlp_fc4_type = 0;
 	struct lpfc_nvme_rport *keep_nrport = NULL;
 	unsigned long *active_rrqs_xri_bitmap = NULL;
 
-	/* Fabric nodes can have the same WWPN so we don't bother searching
-	 * by WWPN.  Just return the ndlp that was given to us.
-	 */
-	if (ndlp->nlp_type & NLP_FABRIC)
-		return ndlp;
-
 	sp = (struct serv_parm *) ((uint8_t *) prsp + sizeof(uint32_t));
 	memset(name, 0, sizeof(struct lpfc_name));
 
@@ -1717,15 +1712,9 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 	new_ndlp = lpfc_findnode_wwpn(vport, &sp->portName);
 
 	/* return immediately if the WWPN matches ndlp */
-	if (!new_ndlp || (new_ndlp == ndlp))
+	if (new_ndlp == ndlp)
 		return ndlp;
 
-	/*
-	 * Unregister from backend if not done yet. Could have been skipped
-	 * due to ADISC
-	 */
-	lpfc_nlp_unreg_node(vport, new_ndlp);
-
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		active_rrqs_xri_bitmap = mempool_alloc(phba->active_rrq_pool,
 						       GFP_KERNEL);
@@ -1742,11 +1731,37 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 			 (new_ndlp ? new_ndlp->nlp_flag : 0),
 			 (new_ndlp ? new_ndlp->nlp_fc4_type : 0));
 
-	keepDID = new_ndlp->nlp_DID;
+	if (!new_ndlp) {
+		rc = memcmp(&ndlp->nlp_portname, name,
+			    sizeof(struct lpfc_name));
+		if (!rc) {
+			if (active_rrqs_xri_bitmap)
+				mempool_free(active_rrqs_xri_bitmap,
+					     phba->active_rrq_pool);
+			return ndlp;
+		}
+		new_ndlp = lpfc_nlp_init(vport, ndlp->nlp_DID);
+		if (!new_ndlp) {
+			if (active_rrqs_xri_bitmap)
+				mempool_free(active_rrqs_xri_bitmap,
+					     phba->active_rrq_pool);
+			return ndlp;
+		}
+	} else {
+		if (phba->sli_rev == LPFC_SLI_REV4 &&
+		    active_rrqs_xri_bitmap)
+			memcpy(active_rrqs_xri_bitmap,
+			       new_ndlp->active_rrqs_xri_bitmap,
+			       phba->cfg_rrq_xri_bitmap_sz);
 
-	if (phba->sli_rev == LPFC_SLI_REV4 && active_rrqs_xri_bitmap)
-		memcpy(active_rrqs_xri_bitmap, new_ndlp->active_rrqs_xri_bitmap,
-		       phba->cfg_rrq_xri_bitmap_sz);
+		/*
+		 * Unregister from backend if not done yet. Could have been
+		 * skipped due to ADISC
+		 */
+		lpfc_nlp_unreg_node(vport, new_ndlp);
+	}
+
+	keepDID = new_ndlp->nlp_DID;
 
 	/* At this point in this routine, we know new_ndlp will be
 	 * returned. however, any previous GID_FTs that were done
-- 
2.38.0

