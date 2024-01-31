Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BB123B1
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 18:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726268; cv=none; b=TBDzxcIskrlzC+NdNDTQN+0upXOqgyBCJLRBvJYY5wiWU0kwor1W2Ii0bI3qMT4cBUf+6L1H1r2IVjXhx5HQaP0Dub+YQHc2tdzcKVDB/39i6rWa9T47gTtDfrVC1ncz1LxPu/HCbXW3a+rG05w3f5HnB37Vet/VEZN8Gq5S6zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726268; c=relaxed/simple;
	bh=kPFJ9k2AcYm+HmrE/tY411auQLJ2ARJXgB5Z7yLlbaA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tAGbgn+0jYHOHC+nAOESB1iVnkGs1LKTAGwtWdG+FwRKR0es7W2f0Pl7n48Ru2toQbLPjWXGQV0urJPbl5mbwFm8774bKJcwoQbgO7PC/4EEHJHsSJ52R+RjODigIQw0w5CV/vvDu9BQltu9W3ksTSa5HgJCg3DLuIcKrpwF2Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AxWWvVfQ; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AxWWvVfQ"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6e1242f8500so6767a34.0
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 10:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706726265; x=1707331065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bOursLVTHiRHXupI4CeVELJqkV1+J9wNgLMv7jgNRfA=;
        b=AxWWvVfQK22OB+5HQLVBDLOrWgoW6bEJWhAzIxpvSQGGqtc5pE/Bd6NKFeUVHJilSD
         JcZuE4XphmsR36u1ORCbzhgDItkUBjizsqGW01/mVsMh99KIU+BMtcMx29UB6TwEw/u8
         wZ0b4JpYDAaFXxbTH29rV9HKQUw/xsZ53NtvrzSCc9ohYuYdAogbvAt+6tC4v+2znOPB
         M6+0a4Ishs3cgoAf4ofWcwemQkT2pVsiIjL8e3L+szJjRmTuzicU0iCtU1cCA2qeVRPO
         +LyjqDGXrS+y35kzl01QYaZn5u0cwmdceaMOMMicI2XyX4z1KlpQyoC1vfIX1QCVHn9r
         n7iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726265; x=1707331065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bOursLVTHiRHXupI4CeVELJqkV1+J9wNgLMv7jgNRfA=;
        b=HwbHgjnXJmHYxhQrROwS01CjpNu2WK/1d2qEZgbyyyLByqXdMWI74jUT0dowZMBqSs
         ojkslBJ2r22eRbie8Nqkk3MMBKy8JW6X21GGt53qmK1mTDhgQAYUPwx/rO9UXDZ5GNq4
         Jugz9Jp7QOqITp1FjqORabnEuxrOvDjcFpDtM8ew4J+lqqjDjp1skYjoW0CVGRB7nKvY
         QZ8qPyGS4V5qHI98QRhxSAFRsIkIdlO8zp/9ad7UAy7/Rgz/Yrv0E2fvKl2Vjk+dZqGM
         93DyETReVfu+8d/BesKHciJrFKpUPVFOU2x1Hw82Zfo/acsaBOahQTsCtZKnjmuz/gfP
         qzHQ==
X-Gm-Message-State: AOJu0YzDcT7c9jKX3ReFTQ8rJaIl6Ju+Qtx2iOux3kl82lVjzv8EF4Qp
	7m0M2jONlCf0vzyrBD4fQKU+dY+sYqUFZ1Mm76Y6kBKl7hGYRzNJy9jbo196
X-Google-Smtp-Source: AGHT+IEZ/7ajOTgc1ln5+gKfTMPCVBWt0PaOEXyAwXGffhYWdBCXcSxEJiES8m92Uz1w1yvQMMKcMg==
X-Received: by 2002:ad4:5ae3:0:b0:68c:6afe:aa31 with SMTP id c3-20020ad45ae3000000b0068c6afeaa31mr2707852qvh.1.1706726245152;
        Wed, 31 Jan 2024 10:37:25 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id oq7-20020a056214460700b00684225ef3a0sm5111229qvb.93.2024.01.31.10.37.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jan 2024 10:37:24 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	himanshu.madhani@oracle.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 05/17] lpfc: Allow lpfc_plogi_confirm_nport logic to execute for Fabric nodes
Date: Wed, 31 Jan 2024 10:51:00 -0800
Message-Id: <20240131185112.149731-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131185112.149731-1-justintee8345@gmail.com>
References: <20240131185112.149731-1-justintee8345@gmail.com>
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

