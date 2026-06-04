Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3EB3093B8
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 18:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780599055; cv=none; b=B6qtHazuK3izayRD6J+y33/Bf46etuT/7gn1z+F6hyXpzeOG6jh9ttvpCdBnq34rYK9mHkG+lSRhgd2AXTQJf+jEBKDG9wmnK7nO69jYrj1J8dEtL20AhLFWxO3FYxoGznZqInngA4nBByv5U5JXNkzkR3DvM4Xt+D+pzIeDK+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780599055; c=relaxed/simple;
	bh=sNuw3Rr24MrADxXmUI/LMhq95QsKPSErx90MhsPKstg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pJAx+mmn89Jf8+6CxVNrLhw1Du7tL54iy5XF28w+heFulxbrKGc67M8Jumc2OfsiRNyk/gVR/HqduDfvm/PJReYRhGFBZ5ISt7uDnx1nB9mK2il1Du90E+2ZLExW+vEaVry9CKdUMpJXMeKqlpx4I2ZuTLTHn/dV+9wqL9APxwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VqPDoN2s; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VqPDoN2s"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-91550dda53cso144205585a.1
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 11:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780599053; x=1781203853; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=90G+/k3ivvkjwlSq1oBsthVu32VZAAkJRSGlmbEOEe0=;
        b=VqPDoN2sq1LlJEM+s4FN01pQqfo2mEp2q3FBpY4ghbqFMH28eaZ17Uk0reko2XYMeE
         /snFFY9geqTYtdUK964O5/Yb5KBeCU888aiELGDWONuaPG99W0u9bhaiXbP0UVntFX29
         /mL+6fzuZgWdAxZz0Q5VCohkVyokZ6khHSez9tKFD1ha35tHoELtNpxDnLCtCvMJ4PcI
         N0bh9q3PCe8CeOtD+1HI+HCqBqw+CDtVXOptW4jcs6/XklzyhZFTPU9jhYYdsnwOkSdV
         wpe5YdazMUx9YltKLee7VQ6NCMbziE7cll09ylgsP7VE0+LiUxNoKW9cFKvo8z/46ohF
         bD3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780599053; x=1781203853;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=90G+/k3ivvkjwlSq1oBsthVu32VZAAkJRSGlmbEOEe0=;
        b=JuxjA1G7RglDRdFu52cMGnBPN6i4FEECzmDLoH3pW35H0MjAxiarNBBS3Lp00uXpbj
         wF5G0RIamznTUle+i9Cn/usiOOObj1yNdKfhunRRqdgg4a6PXpEq/qTlHad5bUYqEiZ9
         yDecaDIqqXC7LxBD6AnLogLOeMbqlaOj+xX8ZMHjagxyLEgx8bmeFSUoxJ//gF37iZKP
         uAHsaYxNOYqVu8XBgvuRbIIRLP084Vf6aHQCrH8OciDU4JbqFi7+3a1BWr1nSVbU8V3F
         8fVyMkV6tmVU86lEgzw84qQWQ+jlr8VIwozDIUS3KHpnaEfbtWuNExMykIL4yev4QRbh
         vA+A==
X-Gm-Message-State: AOJu0Yx+su/mNwhhgyRIXxahXQDVvpKGELvEfFchoCY2XmybqsqC9UOW
	ey8gdt4JuY/77uSI8DyO6/2KSwRYO8++XQX4jPJSc6x2133v5AEnrfFk2wYNIBa7
X-Gm-Gg: Acq92OHI1a+ODQdN2rje0PIa4js8wdUcvFEPkZuxr7Xx9IS65P4prMxjDcOttdhKuoK
	LX3pQEzkGtGiKLufJDaYwJrPBCxQW6QLJ3UrO3ZWeCSG9BGNzx4bOibq64zTVaXvsCmB1GL58sf
	OzpJ4jTyK7SWXCYn+ofF08H0B9dfAEcq0IiWdYNouXeS4gn86bKpu3DBEijrNy/gKKgr5aavBi4
	qGcc/xt0kxVDMnYRyKOJC1iK7vha700LM583/WOuQVFCGt6vBkBNznFpyoHUmm4WayjP8DPbBUB
	W5L3X7FdodzXL1OZ3IgiE0NPKK2LguedY9HWJr34ykoPn0U7v5TuuyrDMxYpBxAKYY/N3aD50oO
	8IyI84vAmPLdWLVjOBw+3eUwprrUyy/cA8IQoXpjA8Jij+D1D5TKd15wq6fhgWiiiU24oBgKr1z
	ToK3CSpbu2MBAG3T09WYYpba8mqCLjicbWhqeJ6jfWQmuyV8A/cxh3xGjYpFiZ5n+1rPYBaPTRk
	xkzfORYEnBI0b4D+0vHwcGm2603Be3USA3gbC2DZMAuy+U8V5JQlg==
X-Received: by 2002:a05:620a:31a3:b0:915:9cd6:2599 with SMTP id af79cd13be357-915a9e143c4mr63337885a.56.1780599053104;
        Thu, 04 Jun 2026 11:50:53 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37cab6sm651208685a.22.2026.06.04.11.50.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jun 2026 11:50:52 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 05/14] lpfc: Add handling for when PLOGI or PRLI is dropped during link failure
Date: Thu,  4 Jun 2026 12:29:28 -0700
Message-Id: <20260604192937.65605-6-justintee8345@gmail.com>
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

