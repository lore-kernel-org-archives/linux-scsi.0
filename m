Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57981AC891
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 23:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734045290; cv=none; b=gJHb4u80XNoY0xQ/1nvlfZGlZeoTXapdfXR/hrqkNlV1sRHhB+lHQSodc0m9L3gyEnIzng0R995ONfKXDIb499OpazhMx/L11aEkuWB36fl5y2mncE3TY7k27WzNKICikwNgfn+TpQbYdYSRK+EsV8kiVOXVM9G8c0UF7+snuKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734045290; c=relaxed/simple;
	bh=4hyzJKQpvQAQbDN5giMWGtlmH5qqA8yosW6q/7APKnc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=USSsXqLd9jOcluerK3N4DdSeVIR1KC+rzLFXDgJHcK+QPRopaa1HW5uWJRqE8obLa9VQGDdDCXkumokbE6woEj6gUNBjkV8DJoijycHuP/vAKTrK8lJscKMlIG96UklLSyz+l3/jmLAts0JgnNO2ZDgPukKJmkZ98CKSm1H67X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WFKy+ZxM; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WFKy+ZxM"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-21631789fcdso16050965ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 15:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734045288; x=1734650088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vfuylJuOeoTcA+wDByp6VlzCRcB6cmqBvp6ZHarWkEg=;
        b=WFKy+ZxM9EEcSAKeYfsW1nS8Zy0ALHyyKCcAvRqpfD2zYl+nl59FkR1c9HKYQSLmg/
         BVJLsMQlPDm7EH/mltQorkRA9EW1iltB309pPO+MZmhiuDwG2YWbYJ73pdLztA9iXhLF
         iszoL7M1S6wqFAvz6joLeFtWaI5cwjStm06gk65dm8YTHNwUVbZA/aXW6qA9zHPi3d9o
         MxqulxMOLqpvfcY7qJoeImHAa9Q18cM6jGzMl3qzxKWYSgRbF1i7/3wZgDZV88ruRBjz
         RfjtoxbzubJSlR3FW9LAirNlLVEUuEWvvCkM9WmR7o9nklIyJ8kukZaBzZbT3+4ZEQaZ
         fT5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734045288; x=1734650088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vfuylJuOeoTcA+wDByp6VlzCRcB6cmqBvp6ZHarWkEg=;
        b=FjA4uegH0/NhkrFaS2z0AxBKTgV9P5guWv9KxrfKkIuW7A+z6Q9gt9GsuvMUL28kcL
         pbccJsc6ULFtSs7zpn9m3qrMbriqVFai8btoRfdgrDetj2dBPwaZRrYfzrqQh7nxJ+6B
         jfHkkuVTdp3PxDpszgrYLxK7xhEB/MH97FOsyzTLQCfkFdKvSzAPnfkF8DplzxqcSmRw
         pwV34o1VVAvFKw/fyGTUebPucP5Q53+XsaXRPHThu9Y7CBkwpjQPw2iEHbbCfekyP61m
         Iyk6wtmT5enggm8u/s7RgoLxS/IN6OKqlXYe8u15R6LHS0Vh/CD/8TinF1VOHYyK5JIl
         ty4w==
X-Gm-Message-State: AOJu0YzrBAFVw6ZJVTZ6h+xH+cyp8nGwG9v6rrYdukH4hvZ6iJ10xtgO
	0ANtlDNYBqsFkYSSvKjjHgn9xL+iL7+uABKkALil3ugyTs4I0IvfU18pcA==
X-Gm-Gg: ASbGncsH4sGAALiHaOJgdbRC/JiWtJo161JjnSBLkVFSGAK7uRoxuXiUZnu0mEVLnin
	hy7aDjJWFXZE7esaLSBCTXkhPEw4whioNALE8DzZ0JcwCR91SbSAx3PzTZWDfev1P4ljoFIRNP/
	QEqXQ9nV22l7BBRLbY3Sl6N7ps2P5tCy+H7m6od+nVpPebT2Uzs5slmmlpypUq+ZLOYhdED+J3A
	89GdTdv1VMY4PKl/ynsXq+icDKFut9LdWNgpkIT/FlS5eYYCIS2mUTnUfcQRXIHCCWgkzJpgeo+
	RIk4FD+qsNC3x04VHdSG9DilZrPKLWrWjmfBnbZEqA==
X-Google-Smtp-Source: AGHT+IFLxWfyukLL+aOYg0fpdQc7ckKmE9MJlItFvgeMHa3VqKfrygoL8Px2GbGOxfHnSbpRFBCQFA==
X-Received: by 2002:a17:903:22c9:b0:215:44fe:163d with SMTP id d9443c01a7336-218941e8d3emr3009545ad.17.1734045287853;
        Thu, 12 Dec 2024 15:14:47 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216325f51d6sm92727875ad.197.2024.12.12.15.14.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2024 15:14:47 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 04/10] lpfc: Modify handling of ADISC based on ndlp state and RPI registration
Date: Thu, 12 Dec 2024 15:33:03 -0800
Message-Id: <20241212233309.71356-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20241212233309.71356-1-justintee8345@gmail.com>
References: <20241212233309.71356-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In lpfc_check_adisc, remove the requirement that the ndlp object must have
been RPI registered.  Whether or not the ndlp is RPI registered is
unrelated to verifying that the received ADISC is intended for that ndlp
rport object.

After ADISC receipt, there's no need to put the ndlp state into NPR.  Let
the cmpl routines from the actions taken earlier in ADISC handling set the
proper ndlp state.

Also, refactor when a RESUME_RPI mailbox command should be sent.  It should
only be sent if the RPI registered flag is set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 43 +++++++++++++++++-------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 71c76d90e8e7..5aa21c683ac6 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -64,9 +64,6 @@ static int
 lpfc_check_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		 struct lpfc_name *nn, struct lpfc_name *pn)
 {
-	/* First, we MUST have a RPI registered */
-	if (!test_bit(NLP_RPI_REGISTERED, &ndlp->nlp_flag))
-		return 0;
 
 	/* Compare the ADISC rsp WWNN / WWPN matches our internal node
 	 * table entry for that node.
@@ -735,6 +732,7 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	ADISC *ap;
 	uint32_t *lp;
 	uint32_t cmd;
+	int rc;
 
 	pcmd = cmdiocb->cmd_dmabuf;
 	lp = (uint32_t *) pcmd->virt;
@@ -759,21 +757,29 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		 * resume the RPI before the ACC goes out.
 		 */
 		if (vport->phba->sli_rev == LPFC_SLI_REV4) {
-			elsiocb = kmalloc(sizeof(struct lpfc_iocbq),
-				GFP_KERNEL);
-			if (elsiocb) {
-				/* Save info from cmd IOCB used in rsp */
-				memcpy((uint8_t *)elsiocb, (uint8_t *)cmdiocb,
-					sizeof(struct lpfc_iocbq));
-
-				/* Save the ELS cmd */
-				elsiocb->drvrTimeout = cmd;
-
-				if (lpfc_sli4_resume_rpi(ndlp,
-						lpfc_mbx_cmpl_resume_rpi,
-						elsiocb))
-					kfree(elsiocb);
-				goto out;
+			/* Don't resume an unregistered RPI - unnecessary
+			 * mailbox. Just send the ACC when the RPI is not
+			 * registered.
+			 */
+			if (test_bit(NLP_RPI_REGISTERED, &ndlp->nlp_flag)) {
+				elsiocb = kmalloc(sizeof(*elsiocb), GFP_KERNEL);
+				if (elsiocb) {
+					/* Save info from cmd IOCB used in
+					 * rsp
+					 */
+					memcpy(elsiocb, cmdiocb,
+					       sizeof(*elsiocb));
+
+					elsiocb->drvrTimeout = cmd;
+
+					rc = lpfc_sli4_resume_rpi(ndlp,
+								  lpfc_mbx_cmpl_resume_rpi,
+								  elsiocb);
+					if (rc)
+						kfree(elsiocb);
+
+					goto out;
+				}
 			}
 		}
 
@@ -815,7 +821,6 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	set_bit(NLP_DELAY_TMO, &ndlp->nlp_flag);
 	ndlp->nlp_last_elscmd = ELS_CMD_PLOGI;
 	ndlp->nlp_prev_state = ndlp->nlp_state;
-	lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 	return 0;
 }
 
-- 
2.38.0

