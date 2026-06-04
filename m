Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15F939D6F6
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 18:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780599053; cv=none; b=HkG7W9dx+8I+Ho08I2o3jKpk+RgJJJ4V7chhqcA6dodPNYp6TV4sZndnGpaJ3cx2TAPBhFAp6UMhtpDynBd8m6ZbErlWTbRRPjPYPu4ZG6Tkh7JHXy4bBUz9/Zbi4L/Ek8zWlUuYkQvLHk4J8ilM077BxBoiKt/m2b1JtV16d8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780599053; c=relaxed/simple;
	bh=5YwSlHjzPku5jClGrO5YdrDfDaBGQQ9SOib3DM+4KxU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yn619oPRtgTqqRqMVUOZdYJSLKPzEiz4JW2KHmnolYx878pGmu9NshNsglReX7Dr1Bp+KDh0xjgfe2bNCNxFsXIjlT5x8dMV5Dz3mr8G9xlZMsAP5J+dxjSY6YUHus0ANiXItTrTaNxQe6g0ipWdRbhWOvqDUO6MEWZhY7yHNAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q24+BrJ7; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q24+BrJ7"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-9154ca1aa1dso295076485a.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 11:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780599052; x=1781203852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7AQZWzaCaXXwVZTmQKqoWa0gLJ7DsAx7kXaPYcVACMg=;
        b=q24+BrJ7MA6kG/k4tO5q3GYRdZevYdKahrwCH/dEWywjWSe5g8iEcC7+GihUtgllrX
         fj+YDhuN/7DhGYuHPPx4OksjJ9A1psaO7+QmAhgrpa1jn/krgPuZ6aS5bO3au7t2otQk
         U/XUl/z20FsvROolxOz0VeakDKapgRtL4wF0sUTyf4HBKT5af29BvN0yNOD/UGwyHYit
         Fsjybsu08FcBlAXOLpQIWBFaBcmgpsnHzE7+zJ9CQb9ijyrSd77xf9rkyPd5v5heuu9w
         EPG0ThXP0qbzE+rWrOZ7yrSXMcTTgX3XHHqlbSzFRNkYjRjiuaH31P5JOrKxe5eirIQW
         lxUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780599052; x=1781203852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7AQZWzaCaXXwVZTmQKqoWa0gLJ7DsAx7kXaPYcVACMg=;
        b=Hr/mpyBZkVEJQHdzUCbpA9A/A7sLSH//reRruGlv2Rn+2IUuw43I4C4lAYmeBamY3S
         x6rDnjm9iCuzPycddiahyp7/75HtO0WwTSEmBd+23H3wzC9iJkoeYvRE3cMa6upYZJO6
         KNglHNx0517/41/j5VjCM8sHfbPS4ExIwymIdR3MtH0Ph+7YXasWzTKVqdHi0EMfL9hB
         6D4UnB3ddy3BC9dkAPWgpBWDJ+JUHqg3C6CJWJj6WJHw0VuuxYcEYgbaT6yeHfB2b9lj
         97X8B58nP3d1xL1IQnCBdI05yLAT7imR6pwfsyD6K31dzNLdvCUROK4lwRMo0uBoaR9l
         CpVg==
X-Gm-Message-State: AOJu0YyaRZ1dipQ/hrMXOjS/abTHUCI2K9PW6dZkW/dte1RBx4mwKjYj
	EQcP4qIFjnuGsfwBSw2oTPez5ouC1g3WLm1sznZccmdvbOuCIeoHWJ4CN18FLmm9
X-Gm-Gg: Acq92OH66Z/o7PRlmAJi8LwgJqR6sLz1JH5jG5sdbYJOQHA9mtfanHaqBuSDU6XoOrJ
	9LOg6tBvGrths6zqrcT5pjK1gHRaCgVCs+ODVHZcc0kjYCFGujyZO1iPVEAiVR/hEODgGHdRlHi
	a8n0gqLeyj4/DRJbC36iT5mhCwPDIPzP+O5t/ZCck5SdeoR5XZBZy2DY2AHYWJlOaM3HVzN8jfJ
	cVWcKnHKruqtKUXZQs0ZoR6H5dReUI01jlTW0hFqP9PapSHcObXTDb57a7qTd0fmDU5fT4aleNC
	58Lz70QMIpDpLdBqsEYz2W4sI+Cv/7Jlcxn5fj/A2A19EKtiV4fQ5FfhgPsNr8nqysbtNn3MH12
	SfVi6Bh/NlCKJwh1r331XMJ8kNw37rE4JEwLCzdhBVCqozULo0eGHEIEe9lkv67YWBglPi6tDGI
	CTadRofK3IVYqR28IUYyotzx3ixuUiyXROlh1TJ+grDWhZC0IOv+TCxV61mAO1Kfyuho2neSyTU
	b7jZ4ReMM6W6RXaDKWkhrUJywFDoHjfrRzq9Z22h3wxKrBhUtYWoQ==
X-Received: by 2002:a05:620a:2728:b0:915:4ca0:1199 with SMTP id af79cd13be357-9159aec007fmr695276285a.13.1780599051695;
        Thu, 04 Jun 2026 11:50:51 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37cab6sm651208685a.22.2026.06.04.11.50.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jun 2026 11:50:51 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 04/14] lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error
Date: Thu,  4 Jun 2026 12:29:27 -0700
Message-Id: <20260604192937.65605-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260604192937.65605-1-justintee8345@gmail.com>
References: <20260604192937.65605-1-justintee8345@gmail.com>
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
index 4e3fe89283e4..896d69a0a655 100644
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

