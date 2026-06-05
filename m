Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB223655CF
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 17:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780681511; cv=none; b=Aa14QVeCHUHtl4FChMn9RVTV0RLMXoz2E0kcSDBwDUQ6CNZPqDu20ekTpAalZeWI4t5dNMnGYa6IULWkEWQouARcfuoKGCdLb+oXQ0i+Tibz3LphQrr8uK9mJ/vHnL9LmUTAxiNlIj7bEd+dwnqC5nSi4Wu0lXRgO4ypvCsdu+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780681511; c=relaxed/simple;
	bh=5YwSlHjzPku5jClGrO5YdrDfDaBGQQ9SOib3DM+4KxU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZHPZPVXDlA93vP5fTYIROcHzh96m1zKJDSbAVMpMdV3/r2WUxSE6hjmcKdp3KKB7t30W4EbMkSzN1UDywFUFWhEPHHBDp7jbm+l0ZocxhoaqVw/JDK5xn/vGvfAKHrOoiie8gkpevgt+x8dUwbl4B2kU3cOIC+DwHK6kjEz9oaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HzT8ibYT; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HzT8ibYT"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5177945a22eso14858731cf.1
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2026 10:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780681500; x=1781286300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7AQZWzaCaXXwVZTmQKqoWa0gLJ7DsAx7kXaPYcVACMg=;
        b=HzT8ibYTSN+Wm1zTRkh20oz3B287C9YKBXLpUqF7h0AxOblAjM9Ze5f53gYuqg+x6c
         F8OKyFR1twVJu3z0qWuw3c+FTxRsMHn3nhxSJ94ttaSzP62ezV5Olin2gUB587xkahMX
         csnTHylmH4PdWXaFv6zJpZ69OXNG0ty/zdfLdLY1MqwK+CfBrIvUyxR2aomohx1uILZY
         aI0e7rfwYfdZ+HQYMXNclq4IEJG8uONTWFRIgeKv2+lMjKS2S7WTCU3Gm2HCwK3JSRJV
         mK/fBbOIeC/RFqUPFZbXHv2YS3YWSH+DhgDEnNQG/lqSj9PJ2YB0mPJUmw83SC2OcJfy
         Unpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780681500; x=1781286300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7AQZWzaCaXXwVZTmQKqoWa0gLJ7DsAx7kXaPYcVACMg=;
        b=fCB84Txxi+1/eLb7di9qfTW87LgDknRbxg+7qlsBGSIFWC43bXZwjRudNdREOIMhi8
         ei5BveCsWZhcUlPCuKqvIJSf9RVupazf9os9mi0ni8VZdahbm5Em/32lSokF4ksVuhi/
         7vuU7LmCYVs+WJYI6UAonhg5XqsDiLSJuFkvJT4MQxPgxYOejSUFoPedG1Y8Rlaw1zMs
         PF9pJLg2suZi+btB/NJGKYXPZzmDFBndEA89+E46ZOwP88OAB1n3+4JRFVO1tWn8sYj9
         IKoC8n131HgmScXljueQGNOsLaG4TYqnFH7EfgmbIe4kxcmezAfciEn6hN3jeOWf+PiI
         3+5g==
X-Gm-Message-State: AOJu0Yw2iIwTGXYKHkG2bOlrrHYtuR/WP8g92Pz+zmxdmq4llFCOnXp7
	8EH1WA/lXydz1kMyGbmseMHm2AjPQrSXlGWbLjN3klAAusfDzVzDqnQtjlMoeZfR
X-Gm-Gg: Acq92OG/e7BjThbgnEqh4YUxuGRgWACe2ZNTIS+IJ9fKpRbxhWCMmPpOacsr2OBFBbn
	z0aGYFb4MQrrxD24aeUhxK/PlmcL9KJd7ytlpCBziXsm0nN9OS+apP0HbFK/bnCjmPZHeRNeSIO
	M/R8w0yG78Zf+8w4IGpvRIjj5u44T/n++O7y041ZV7iB7zhqPuEvbi8rJT+qkPx6NUypAzcZjNk
	A4448SjIIzW1uu2zNPppqZbi3xNJGTRGDGXe5Oyyw5FqVgbp6OrBmjyDjFxcCxloktNtqbct+eo
	VDIBLqMc6DmBUL1J00eOcOLmIoYvOjNma1r/0e9MRljCrRLOBnRE79o1QO8sEIttMi1aQM5OI6X
	CYXcDDXbzWNujMAUqKaEOwdcZVDxgHExlA7GRjdipu8Kuzpm35BeasJHMcrHW1u4L/NPFn9Ktun
	u6/+fuWkOrFsRT4pCrrWQQy4xWl+q9ChnGqqYAjdJK67KgsTx9f3gZnti+Yqk7BWvrxzFT5fh/2
	QAs8yvsSacXJ1UFpyUtfrkbPWjdnrx3422yy+nA/Rh3vIFycLP2Fw==
X-Received: by 2002:a05:622a:99b:b0:50f:c2f8:4081 with SMTP id d75a77b69052e-51795c5b470mr66516821cf.53.1780681500137;
        Fri, 05 Jun 2026 10:45:00 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51789407da8sm53376171cf.19.2026.06.05.10.44.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jun 2026 10:44:59 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 04/14] lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error
Date: Fri,  5 Jun 2026 11:23:26 -0700
Message-Id: <20260605182336.134919-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260605182336.134919-1-justintee8345@gmail.com>
References: <20260605182336.134919-1-justintee8345@gmail.com>
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

