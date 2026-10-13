Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062743DB994
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 23:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791849192; cv=none; b=K2vbzOpeYEIj3+8qO80NGCxzQSKPXd+bb5mm3OuU4ksxB3oG9qhTw18tRme8TAfxotksLGL+8k52G2qeXzCMGZQZ9uHP96NqqyJxBXWW1ZUxJLBVS7O2CN7Bb1uv5i6SLlpj/yu0lrE7F7LSRJQ/FNkwl6yUypLgGdOiCnCEzuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791849192; c=relaxed/simple;
	bh=U+DwUE0uurjjDte0NsN6cmtF9j4nWywD15pkrJetPVM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MvzfYhkOsItVJ2N/wx1b0U1JcehLZhhV4JEe5zeUwi2D8ATOBi0lSSEDmN/P3PHSvdW2jThHkG9WzcV28Kye2B23BEYLH6veu51K2BWxO0UbyRqKek8dK3wtM24Gx/hL6b5vuz7f38J2dB6azbhrfSBL7VmpXgo35/V1hm3hfJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cOBHz0ay; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cOBHz0ay"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-3535bf8b3e0so3724634eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 16:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791849190; x=1792453990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WKqTTNOUPJPjcRmMteqhHp/MGik/ghthsy575wyp2OI=;
        b=cOBHz0ay1tmVFK2IgNbsqFBbCrow7MYHIpO8bRo9mje0chayzAp2VE0VvqG8FOHn0t
         6B1EZDxhraqzO3EceRB7lqm9/jQo9OSXG9Hg1/zNJvSr1EN/9tP471uj7u8DB5VY4DFY
         4lleKXWFpWTDtTfnDem6H56pWS3SxmbyX4qLevglGBAwsZyn7JauLm55sL9vHLkgyl2N
         gTOgGTqK1lo1hggRc3Pivl3NLBdcSm8V+XItrBWfYgDR3oslWf6q+Nku62iecnNK/m/a
         bRwvBzbJtbli7mP/o15ZXMBo0PL6tVMyPEJtWxw+rni7kftxK6ZsOq9oyyCzvFTS6whi
         /Yrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791849190; x=1792453990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WKqTTNOUPJPjcRmMteqhHp/MGik/ghthsy575wyp2OI=;
        b=F4BmCPZyyXPxPfpxPzDXonjjQGmtwOqFfaFlgTMV/sYhG0ATWFuO7lecs3KsRzs5YL
         tWEX6KB5y0Ha7aDy/AClA/WJ8FZoSKBf0pjP5yqLor6+l7FI1sMQO32DA1p/zO8b0Iep
         Nz8cOdIlxOKG23qanZvDD81l6EIvYqX3fX2QWoNU7L5912qygOb+BGs/000QLENJBqro
         6uAK9wowFe4msorIOPOQzcyQsaipdTNUAODzZiA+edIaDfr7uKSlDZ+1Nxjn3a4G/6E5
         TgfN7UzYJl6VOYFVfwbb18znGwBXYKSNYWQCUtcFCQXbXyBRjiOnfIoT8RktWUHraWLa
         mxnw==
X-Gm-Message-State: AFq9FYKma+eMvlWJHQWSTDXa7xs2Pgtsfh3csmtirQ38VCXMCd+U3oJU
	HUnOzlhoDR34dwnAiKmFz5WBZsi28GhzlQ8s4fvNSCxgEVqjMgC4rOKuEPKNzZUb
X-Gm-Gg: AYBFou1AQ9Xfy2Smo3Rm8DN57TW/A9xPBqLmmw6lBZxjqaBXPk1lovJQKSXl9z+xn65
	REBX8kSs0k8cSjFS/vVJUl4xqEuCzsH/Ic94JypZN+KZStHYpikD4GyLNcIJTcAgsu7gnvRe2Fs
	14l3rQgydJ1Fovjxa2YGYKiM9m5A5yfs6aCyMGn2HwOZRLEEgXOCLUGaA3FefWTDG+oEqxX9jj1
	KHyHG1zrUSr2mVJgGnXkM9EUNJLOq6D9C0sS9Wh7LCir6zFt/MgYcfKedCh9KiDlEPhEKW7uxKH
	X92otNG2t1plOFsSm/ocNwCZT6smwSzVzEUHUnyHax0PK/MiD+pKWAblInXrYYEM+dIREfGAAKM
	vi6QEWTrPVU+BmzeRR22dEO9eVbfWbSqEL3t4pN2Bplb2FyMJgVQi/Ntpg5ejZAvMWxr0RQNtvl
	PlSKUPFyRiWjaszswf9YLEFTANjy/44sIHrNQqXZCwz05oX9sl/BQOmVsGt5fx3E435eFZhQmOQ
	cWLEXQ4u6Q6qkgp1sH9XMEDO2AZqMkM0cZ/rCLmez8prgXCqoFw7jJtLw==
X-Received: by 2002:a05:7301:4714:b0:359:d728:ea39 with SMTP id 5a478bee46e88-359d728ec5amr7797428eec.25.1791849190024;
        Mon, 12 Oct 2026 16:53:10 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b29c2f861sm15137264eec.11.2026.10.12.16.53.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2026 16:53:09 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: jsmart833426@gmail.com,
	paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v6 4/8] lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error
Date: Mon, 12 Oct 2026 17:16:44 -0700
Message-Id: <20261013001648.62289-5-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20261013001648.62289-1-nkirkland2304@gmail.com>
References: <20261013001648.62289-1-nkirkland2304@gmail.com>
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

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>

---
 drivers/scsi/lpfc/lpfc_els.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 6f6394a0047c..4918d71ebfe4 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -11395,6 +11395,7 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct serv_parm *sp;
 	uint8_t fabric_param_changed;
 	u32 ulp_status, ulp_word4;
+	unsigned long flags;
 
 	ulp_status = get_job_ulpstatus(phba, rspiocb);
 	ulp_word4 = get_job_word4(phba, rspiocb);
@@ -11416,7 +11417,6 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		ulp_status, ulp_word4, vport->fc_prevDID);
 
 	if (ulp_status) {
-
 		if (lpfc_fabric_login_reqd(phba, cmdiocb, rspiocb)) {
 			lpfc_retry_pport_discovery(phba);
 			goto out;
@@ -11427,12 +11427,28 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
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
+		spin_lock_irqsave(&ndlp->lock, flags);
+		if (!(ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) &&
+		    !test_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag) &&
+		    !test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag)) {
+			spin_unlock_irqrestore(&ndlp->lock, flags);
 			lpfc_nlp_put(ndlp);
+		} else {
+			spin_unlock_irqrestore(&ndlp->lock, flags);
+		}
 
 		goto fdisc_failed;
 	}
-- 
2.38.0

