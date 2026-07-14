Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005BE1D130E
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783989468; cv=none; b=gP71RcBRCah53Yu4uveD6ZstLnGcSRxaXjQdQ03Bqox2Hz/EswxsiMqm7VZA96LEkYN1F0Axjxd9FZ/PiOYAOd5XRv9oa1NjbpzuJb1zJg8HmmzJTOaWZoOUcWmvPWi5KDvg/fI562bouwW6Upc5c/lmovM0NtdF2WRWF4gbOCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783989468; c=relaxed/simple;
	bh=PJUzeo2IpdjaH5B32f8VaCr16TqpA0we+ANQ2ORephM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pHA0Q0/NedoQ2Npz1DykugkqRxlZvBRAIEZvswOObtZpOlXzekyphvLPc/kHYHfbj6j6RbeT8hyNdEI2rWiUF4VNo6IHdtRCp5DMugPkbr7DrzItFERO/YOTEXef91wxnWsoCg4JsIGK1F1CKyW3OTC+w0wvs1paA2yqKlelzsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LrS3XTKZ; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LrS3XTKZ"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e50a650a0so187532585a.1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 17:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783989466; x=1784594266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1nRs1eSbZJ2SKA2enb2Z60nF5YdLqHVpXFTMzKthiQs=;
        b=LrS3XTKZywTjdAdji1Cqs0mSS7NAvP0EbZt3vwrSzNc+n8YEoTYwdvgSxhmxQwlY9q
         hPzNMCZ2Jz8j1tZpUuMnOgL1Rdh/+8Ljd9fDT8dEZi7lL20BD8G+stHBa+6crtBUzz3P
         d6/4UJQ2EX37/jHeIy4IE66ERTJzN0FdhDScD3DhG3o0Gd8w7d5ufdiTPqOHEauq7zaf
         eI9OPea6lbHLhEtXY9s3cHTdcmI9M/PWv6x+sDRu4ymx0jZT+iKvKmgXz7fz1ToRWg8r
         FqoDKkRYg3CH4ljI/+306Zb39145fZtoqq4hL9QcxHT6yte3fphHra0xKiUC9ngPYlYt
         BwTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783989466; x=1784594266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1nRs1eSbZJ2SKA2enb2Z60nF5YdLqHVpXFTMzKthiQs=;
        b=jHAIySe7bjMkPWD+BMCWwMUaaniWqvEPo9+azEyqWVqpTX3o/AirkUDQ/PYT1JxSJp
         P4yV3GrXrH0CMKbnVXBFjNuen4Ix5JPb5JIkFt41L3Si5QStHpXthOOmqqXzb/ek4+KV
         aJVcfcNDWRJiiigw0smr3A0YXxPYxzKXYtkV/U2RcDP+eAMU2fhK0MUlKiiWQMQYU/Kr
         UNlm/z/C+Df/Q+zplvH66vSOImMhNTR3qv/MNfsO5CADglQ5AwSwBBo3Lc3eXPDVUsCr
         KyI6HZJypVhVh9UCRmWSfmgwyEahyNV6vPO74KMFa1W6tqAZm4nkONZhGWz7caEe352N
         +3sQ==
X-Gm-Message-State: AOJu0YwjFyY2vAsRALPRG9uAnkFZOl0PitaLh8mJSpA1124kfgStO260
	WKB2r8xZYYmnnsUVOb/fvo8LYw7CiVuTrTT3NClIJAF2cF11qSCwbRimqWMUwPU9s+8=
X-Gm-Gg: AfdE7cnFpEh10A/aQrIgVOCMHDDTOmhrr6noRemxowXmYBA2oNFmiFCcy6S+F9aKHT2
	b/MxRq6d2DJrLNeoBOsUoukaKsqSNNlV3XPsqa7Y+zvApSOBFFqOB7pij41xpfEoNV/bimQo/QG
	O/FAa0elyPN71NjvJdUiYFLvtHvpfCC9jm6Q9FxdR9lk0hHB5NOSTLZlGuY2Zm0RhEJzU0i82ik
	/WzRwOTWXZ8wIcuqPgGzpACVU3kH2c71McMDA7yANyQYiNA06EvlaFJIK0MFkNCMqM90KAMt2kL
	woYb7foDHFqMcBa0uzrpJoa3s3IBCPOfzEXES2Oj3EQ5Y42k3aVRFqafKulEQgBpZHIYLGJ+8fp
	74K6fKFT7m/5I650xmXMfyOmqwGG5TF5yKq6APD5LCmBYU0VNtwbZ2nHi6AWNhxi8HwWHBXb64a
	GPIzL+AY5B66SLP4cH08PlZlH1J/+FNJuB7uxAZIzcaQ9wtRMrg2HnZbph9dcUPW3IV5uEw0vF8
	4yRPM0pAq3RrREn7pAjGBWUsIkgJ3Sc
X-Received: by 2002:a05:620a:2793:b0:92e:7467:fea0 with SMTP id af79cd13be357-93086a57eb8mr33604285a.34.1783989465884;
        Mon, 13 Jul 2026 17:37:45 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d6c28bsm1289899185a.46.2026.07.13.17.37.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2026 17:37:45 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v3 04/14] lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error
Date: Mon, 13 Jul 2026 18:18:02 -0700
Message-Id: <20260714011812.106753-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260714011812.106753-1-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current initial kref count drop logic for an ndlp that fails FDISC
assumes that the ndlp has never registered with transport layer and thus
the lpfc_dev_loss_tmo_callbk never called.  However, a failed FDISC can
occur after a successful transport layer registration too.  So,
lpfc_dev_loss_tmo_callbk can occur and there is a potential use-after-free
on the ndlp.

Check ndlp->fc4_xpt_flags if previously registered with an upper layer
transport and check ndlp->nlp_flags if there is a LPFC_EVT_DEV_LOSS work
pending.  If not previously registered nor LPFC_EVT_DEV_LOSS work pending,
then set the NLP_DROPPED flag as before and decrement the initial kref on
FDISC error.  However, if ndlp has been previously registered, then let the
pre-existing logic for each transport's respective dev_loss_tmo_callbk
perform the initial kref decrement.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 52fc5058976d..b756de9986eb 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -11416,7 +11416,6 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		ulp_status, ulp_word4, vport->fc_prevDID);
 
 	if (ulp_status) {
-
 		if (lpfc_fabric_login_reqd(phba, cmdiocb, rspiocb)) {
 			lpfc_retry_pport_discovery(phba);
 			goto out;
@@ -11427,11 +11426,22 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			goto out;
 		/* Warn FDISC status */
 		lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
-			      "0126 FDISC cmpl status: x%x/x%x)\n",
-			      ulp_status, ulp_word4);
+			      "0126 FDISC cmpl status: (x%x/x%x) ndlp x%px "
+			      "Data: x%lx x%x x%x x%x x%x x%x x%x x%x x%x\n",
+			      ulp_status, ulp_word4, ndlp, ndlp->nlp_flag,
+			      ndlp->nlp_DID, ndlp->nlp_last_elscmd,
+			      ndlp->nlp_type, ndlp->nlp_rpi, ndlp->nlp_state,
+			      ndlp->nlp_prev_state, ndlp->fc4_xpt_flags,
+			      kref_read(&ndlp->kref));
 
-		/* drop initial reference */
-		if (!test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
+		/* If have not previously registered with transport layer and no
+		 * LPFC_EVT_DEV_LOSS work pending, then drop initial reference.
+		 * Otherwise, let the dev_loss_tmo_callbk drop the initial
+		 * reference.
+		 */
+		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) &&
+		    !test_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag) &&
+		    !test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
 			lpfc_nlp_put(ndlp);
 
 		goto fdisc_failed;
-- 
2.38.0

