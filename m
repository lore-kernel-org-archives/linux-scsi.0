Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A38919AD8D
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 23:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738280718; cv=none; b=ZlvLNJOMJZov+Sj3GM5cgAU1kj9H8H2ICznKoVnXavS+iFEcXuINu1knipsq+YnUbkMfB20fGiCztBks2fjeCo5GPwVqKvwh4SwqswopiMMoC1Qrcf35MzZB1rudGnG9NgbsSSKS1RxJugPpsNibrB8ixVEM1PRa5WRoep7oaHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738280718; c=relaxed/simple;
	bh=fOpY1RyKPOpU9bl/uu7VVDfubHWwXiR+L2bbwycAntI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HqS0dgvApw4bPpDd+COwJZ6/AldC8NB0VNd9msYLGi+/srpaqeyYlac3Ih+hA447ob+JIwyB3MpUYoSsMyr1w6gJOdqsvXVutWdxNz0+Lw3lGP6EjRCROU5yWAczyvvnqNcDRKa08zPHPut/AMCeZ6NjfbbAc94IGKar7khBs+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OZN09Lqj; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OZN09Lqj"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-5fc0b7a4e87so1117181eaf.1
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 15:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738280713; x=1738885513; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sGU7ct1w6opxL2vLFHhESbptIn91LoS6CTsXFujPMho=;
        b=OZN09Lqjz1i5vvtu2xbWIZpOBItdGBwrGaysZiJCrITTRf1XAKpgrnXLZqMHO+6t1l
         X1dztZ/S6MwZwjbhIVP4ZZLpXGun91EAsGmTV3O7Vt22uaz1sKkIpWnJvcOK9FPz3mAU
         wEnqZh9p/m9YHQ2YxLPq7xGdEo0LwoRavCaAOSfU1bCfmLUnPsqpKQ3PItHJ9wusR4V+
         atP7WtQNV4rNLXrBEyIdhE5J8xaKWRwKQQmneu1ZD1hv++qwn2AitXu/v9SxTZ96DPLU
         AGuMm8qerX9WB9TuPEuctz2KGPAzuK+/lTSTrExHAO87Yc7FhLvEObL6X1P//imuNLNQ
         73Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738280713; x=1738885513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sGU7ct1w6opxL2vLFHhESbptIn91LoS6CTsXFujPMho=;
        b=Ut4DEn28WMKBUfx2ImdXhRIca84y7DdYNk7h8mE8MJFksn5nbWOFAd/wafGRwBsOUa
         dzwVYmYlonY7r7cxxFT45M+eAJJd/njnqYhXlYYOlq1YFPv7vqW9L5ncE4rQ6tK7wb/H
         O1YUxcFQovAdoaHTuX7wUA6KsMuebAD57blHNEnZ7bmmnSICsuzQvqIknzixNWAuMMDM
         SWgpiLcnEZIG4zGSQLrI5xMFDUfo7R+O4eJpoazBsJv5m79gFSoIyZflmItgRdiyFwPb
         /Xd0+a579Fy8DlUR9tWgzkMze7fDRy80h6ZpglIt2mlukMoCuItN7XO870utNua93Nc3
         cz/w==
X-Gm-Message-State: AOJu0YwtOI1PlPPY7k+4QsleYMjcrULsXFZ+jMDyrMiuVgkjiG3K3500
	kcORv1x3FbvhGRh7Wi41rJ/tlpKXohKTmnXcnozpkCDBd8Eps6hmkPSTNw==
X-Gm-Gg: ASbGncvQEDh3u6GdpG6qz4vK4y/BXwSlz9XkTGL5Q+9IUeO+2gD74msP3whkl6AyW5/
	NZxa7rlAPDA6Qom0o/OZlw3cNAK2IPWXy3EthgyOygDzOxrW8g4HrFqC+j/ZM9oO5OMEyCKMMsU
	Vh8xtL+Sf6HRFEIRz6zdtwhQMDu7AhqCzRLcOBjVklNAizDj2snvytq8pCUAmTJg7Y3y6izsE7J
	URIBM0BFtDb2oagd/tz2f3sO/k5JltbQVDSfKzljtS+6RiUjs3BYrMsY5mTi+xAzsb7oxLo70bG
	dDZu80VnEsO7156b9a42XSXzbx8LEODCRGh6bGBOiM5pVYXN8co9oJ4BZR5KFnKtAr7KOUjW81N
	4
X-Google-Smtp-Source: AGHT+IF0IHBWIVqjvdMc2taQiO5NeNJfgemSpSm6ZGF0eT8k34pMV4b4Is2v3d2lOWh//d2y/zHfGA==
X-Received: by 2002:a4a:db4f:0:b0:5fc:ff5:60a9 with SMTP id 006d021491bc7-5fc0ff561ffmr2769792eaf.5.1738280713368;
        Thu, 30 Jan 2025 15:45:13 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5fc105d8a22sm517609eaf.37.2025.01.30.15.45.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jan 2025 15:45:12 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 3/6] lpfc: Ignore ndlp rport mismatch in dev_loss_tmo callbk
Date: Thu, 30 Jan 2025 16:05:21 -0800
Message-Id: <20250131000524.163662-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250131000524.163662-1-justintee8345@gmail.com>
References: <20250131000524.163662-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With repeated port swaps between separate fabrics, there can be multiple
registrations for fabric well known address 0xfffffe.  This can cause ndlp
reference confusion due to the usage of a single ndlp ptr that stores the
rport object in fc_rport struct private storage during transport
registration.  Subsequent registrations update the ndlp->rport field with
the newer rport, so when transport layer triggers dev_loss_tmo for the
earlier registered rport the ndlp->rport private storage is referencing the
newer rport instead of the older rport in dev_loss_tmo callbk.

Because the older ndlp->rport object is already cleaned up elsewhere in
driver code during the time of fabric swap, check that the rport provided
in dev_loss_tmo callbk actually matches the rport stored in the LLDD's
ndlp->rport field.  Otherwise, skip dev_loss_tmo work on a stale rport.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 36e66df36a18..2dfcf1db5395 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -228,10 +228,16 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE)
 		return;
 
-	/* check for recovered fabric node */
-	if (ndlp->nlp_state == NLP_STE_UNMAPPED_NODE &&
-	    ndlp->nlp_DID == Fabric_DID)
+	/* Ignore callback for a mismatched (stale) rport */
+	if (ndlp->rport != rport) {
+		lpfc_vlog_msg(vport, KERN_WARNING, LOG_NODE,
+			      "6788 fc rport mismatch: d_id x%06x ndlp x%px "
+			      "fc rport x%px node rport x%px state x%x "
+			      "refcnt %u\n",
+			      ndlp->nlp_DID, ndlp, rport, ndlp->rport,
+			      ndlp->nlp_state, kref_read(&ndlp->kref));
 		return;
+	}
 
 	if (rport->port_name != wwn_to_u64(ndlp->nlp_portname.u.wwn))
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-- 
2.38.0

