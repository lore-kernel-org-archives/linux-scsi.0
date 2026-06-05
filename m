Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3271C27057D
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 17:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780681507; cv=none; b=Vad1XqGty9NaEGCHBA/LpW+hXKM4hlbTiT196hnUwk3q0zNOEgjYW5XpPbQ1brAx3612RBbsHsDb4yfRK/tsIf0E4jFcQhvYyvDryo9WLcqI9tlcnAnKdOVRVJEuNtb9INnBNOwQ4d5/URxkY9pI9zK43voQWMssY29gkbNp7vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780681507; c=relaxed/simple;
	bh=sNuw3Rr24MrADxXmUI/LMhq95QsKPSErx90MhsPKstg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=snJ8wPsYHwFA1zcar1s+DQNcCv8YiI6Q2agKcQYQM2M4O4sqrYk82AtFGpeR64APGJfl90KH7i37+4Ywt834WBkMHjYGi1NL1Oj8VeFFYwpx+WiaPrl3ZDzLQB1vWMcxMminRUxUAzMhiSljL2+0SfDqSBxPPwZQfXj4ctcaz0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zu+br469; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zu+br469"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5177b9a02bdso32921731cf.1
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2026 10:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780681502; x=1781286302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=90G+/k3ivvkjwlSq1oBsthVu32VZAAkJRSGlmbEOEe0=;
        b=Zu+br469O8FLUULPmWzu1O0UMu8a9K1asimZ2lye67u/et3vs6OCSW/JGALxJ7Ii2x
         oEk3FPYwptdYTmxgmQSmHfGtn7sDtxwZgXvwcQDChTNxJtJEzBAlX11sorW2k5UUG+M5
         ZsYHSkN23OFdXykCMqt0w+VDMkQyOfQova+P7HPr8+a828+7ScrYKaZpOfL7cRG4qooX
         LMmD59+McXWs45HwJepogQdBh6SSAFjUpzy+C45fFVulyfyP79oO2myYWcqD9WnuFmvE
         PiWxp3s9meEZuuvHm2w66KjvenFPlbUTudtfXdDoli5nlgNU6QkfN+fa18XgnyKRvVGz
         x2gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780681502; x=1781286302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=90G+/k3ivvkjwlSq1oBsthVu32VZAAkJRSGlmbEOEe0=;
        b=C18ruxoMIo55cmkgcxr2ipSrcHvTBf/IlWDRZxoopJuuFDqZ12LMvd//W0nBhyThVi
         xnlJurhX8kJeBZXBntJaENn7udTwSw/v2OUCvwHW9rkKMPSmcMMrw0ej/DyTO2fuNc7p
         Ebvufis8IwvFTSwLvxxpCGiGNHOwpyG8ZUYLm9XJaCMMBuwm1AP5KYdPqIOgliUIGs35
         sfrf7b3ZEAI3sz+3MN+L9iLzCmTaSdPbO/pN3/5iqnwVYM7faB60sCbg7KD/ICCC+Uk1
         qoMKN4bflYTGxBK6FN5hYgrpTtDqFo+9EEBAgX0VdR4outg736aRttJBn8AR1Is2n2sc
         DkLw==
X-Gm-Message-State: AOJu0YyaDjbkpRVy2GZBXBvC5i8GawYf9r5YIfE67ztMjGORbaHvi5M8
	bY4DYtAr19oUec09aCI6NYStDubZKIn2AlIbQIOAobYiAX8ebjK8c0bn1NWpFPXu
X-Gm-Gg: Acq92OE1BHCGW9e1iPn6DBdzH6N/kBb0WwEf+MV/sZq3jhayANH3P44gKLxPNzRrfXL
	D8BR6Pcm0K870wCsfZFrN6JZgXgDMo3GMmd9hiuxOU5RawVVIe1otwh+HWgC6UGDfcGwequCb3y
	ZnU/C/2DTfLK6LlourZLt9D//GT4cjlIco8C4gubA95qsZxnm7kkvjNVh2EERZIlt7iRo983K0P
	yNLPe8nYC1FwX84Mpk2mnveCzlENr7vs1HDxfnYuLsnw/wJ8DqqasFGNqlpNtXReyxDEX8zW0mw
	5i84N6EzQYOBE+mC7r18ZOvcgjfs902qCn97WOObzIJcHYUBQ70aSEnGodCUUVgMVDgdFAS4sOb
	fda1Xw0oZy41ae41kGlcUg2vjNNBWEUdF8B85t4D1e9HmaxCapJ1teeZiytXCB8nYClRptMEbdm
	N7Yx9deW/VufqcMLRxQ1+tM2fqMJCi2Ke6399JZXMJYKS5ExhXHbghMY2KS05AKX1NI8N7sz2rC
	bl5ckt6jeBuxNGdRFaDj5nA4O4jdsZz5DIO5X1vMLGB8wSht+J8rw==
X-Received: by 2002:a05:622a:98d:b0:516:ef49:f6f5 with SMTP id d75a77b69052e-51795c5306emr68480491cf.39.1780681501665;
        Fri, 05 Jun 2026 10:45:01 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51789407da8sm53376171cf.19.2026.06.05.10.45.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jun 2026 10:45:01 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 05/14] lpfc: Add handling for when PLOGI or PRLI is dropped during link failure
Date: Fri,  5 Jun 2026 11:23:27 -0700
Message-Id: <20260605182336.134919-6-justintee8345@gmail.com>
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

PLOGI and PRLI typically complete via the lpfc_cmpl_els_plogi and
lpfc_cmpl_els_prli handler respectively, but when the link drops they
complete via the lpfc_cmpl_els_link_down handler.  When this occurs, normal
cleanup completion actions are missed and we may fail to recover the login
session due to ndlp logistical mixups.  Fix by clearing the NLP_PLOGI_SND
or NLP_PRLI_SND flag and decrement the outstanding prli_sent counters in
the lpfc_cmpl_els_link_down handler.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 896d69a0a655..c67f8581f584 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1230,6 +1230,8 @@ lpfc_cmpl_els_link_down(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	uint32_t *pcmd;
 	uint32_t cmd;
 	u32 ulp_status, ulp_word4;
+	struct lpfc_vport *vport = cmdiocb->vport;
+	struct lpfc_nodelist *ndlp = cmdiocb->ndlp;
 
 	pcmd = (uint32_t *)cmdiocb->cmd_dmabuf->virt;
 	cmd = *pcmd;
@@ -1237,17 +1239,40 @@ lpfc_cmpl_els_link_down(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	ulp_status = get_job_ulpstatus(phba, rspiocb);
 	ulp_word4 = get_job_word4(phba, rspiocb);
 
-	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"6445 ELS completes after LINK_DOWN: "
-			" Status %x/%x cmd x%x flg x%x iotag x%x\n",
-			ulp_status, ulp_word4, cmd,
-			cmdiocb->cmd_flag, cmdiocb->iotag);
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+			 "6445 ELS completes after LINK_DOWN: "
+			 "Status %x/%x cmd x%x data: x%x x%x x%x x%px x%px\n",
+			 ulp_status, ulp_word4, cmd,
+			 cmdiocb->cmd_flag, cmdiocb->iotag,
+			 ndlp->nlp_state, vport, ndlp);
+
+	if (cmd == ELS_CMD_PLOGI) {
+		/* A PLOGI ELS IO needs to clear the PLOGI_SND flag to
+		 * acknowledge the ELS completion and allow recovery. Otherwise
+		 * a subsequent PLOGI gets rejected as a duplicate.
+		 */
+		clear_bit(NLP_PLOGI_SND, &ndlp->nlp_flag);
+	} else if (cmd == ELS_CMD_PRLI || cmd == ELS_CMD_NVMEPRLI) {
+		/* A PRLI ELS IO needs to decrement the fc4_prli_sent count
+		 * added by the lpfc_issue_els_prli function.  A nonzero count
+		 * stops transport registrations.
+		 */
+		clear_bit(NLP_PRLI_SND, &ndlp->nlp_flag);
+		spin_lock_irq(&ndlp->lock);
+		vport->fc_prli_sent--;
+		ndlp->fc4_prli_sent--;
+		spin_unlock_irq(&ndlp->lock);
+	}
 
 	if (cmdiocb->cmd_flag & LPFC_IO_FABRIC) {
 		cmdiocb->cmd_flag &= ~LPFC_IO_FABRIC;
 		atomic_dec(&phba->fabric_iocb_count);
 	}
+
 	lpfc_els_free_iocb(phba, cmdiocb);
+
+	/* lpfc took a reference in the issue.  Release it now. */
+	lpfc_nlp_put(ndlp);
 }
 
 /**
-- 
2.38.0

