Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21C416DC28
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783989470; cv=none; b=BIN37iESS6XQ+uH4iShGeF9fkbYlgcWntX3VUHCFAcAfUtori39wxQlRYZRmR+08CTg37RrRLsCCuDjFwgDPWMJMrw14SmplNkj5wpLuEbTQc+icoeyG+pli+peYt9fhrCuByxy1vWMa0BhkZoCHt/xOXZk2Zr63+0ZEjznCnNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783989470; c=relaxed/simple;
	bh=AqzCA8hYY2jay3tp40lclpvPFZFbLdB68FiZjjQGn44=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SQpmCdDTPeULhdN3vDKjv772O08yXvDn9iGdhcwLqc/WAiznw0M16IuDVmqU3WlfO1UqxzZba5MYbnc6XpTEOyfqH1Lc0wCGQKgX5uyyu2QTG41/hdt9DCfzD4Hyw9bo7GUpjOqiYG4KaO9U+vnXdxXj+afgHjo3Y/8rA5iDcb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i4Amu5mg; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i4Amu5mg"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e57a753f9so288163185a.2
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 17:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783989467; x=1784594267; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JwpICyqnZpqQaEtPEeQHfJ8mpYWf/vBOB8gEVjp93MM=;
        b=i4Amu5mgySBhreFLRTXKQsyRonxroDi/pp88kSWsB560LvVRrICPzX7WFzLAJKgw0E
         Bn4GZREuViWuMmI6uBmHYe6Ts2Uw8V7XNcGyiSXhrUvH1Usl1n9NgsVhTszQMMjqTsJy
         +7F5/ihVhouVn/gqhzuHXShmoutD/zBwahiAT+zI+6vSK1bzB6KyGg2hvUfZ+TjGhiA5
         0eESGOSgHAM+DrEGOw3cWcTqNgDhH/ySFvDMgx+XXU9yoWAw9VACFdTZL0iGCO7tmIA7
         GAOo9p75Yy+05wU9oHXGJ3Sz5umeoPUEy8JYXzFlhSExocSRKdTqifqhPDLMsxzL5r+A
         x3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783989467; x=1784594267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JwpICyqnZpqQaEtPEeQHfJ8mpYWf/vBOB8gEVjp93MM=;
        b=DOmSzl8BjNGuz7wcqhftmoPKaAGJk9Kf09B+mFOH9sXYDaVAAVJs4Jwq7zDP6TD+B3
         yYzV2OeftNHqxJXblr3JXxm3q7NhU/YjedrH+gLdU0pOIAA+cgBLCOB+j0AEZYa9SQ6t
         DVBVQooDun9e64iXxArPmWurI6/c5IC4tnlb4WmMTdrDvHz+sTEfwxRvuAQuPcVm/kPd
         LABKXHMVVwq6BFXxY+56p2bfFC24XXzpduSv7vKsr5j822gEDJjRtDWFPYfbPcG8a6hW
         1xv9NXC3e96FToMAiB9CXPH+SyOILzfNPQC4vzWsT1SwaQRU1mW5js1BWb5Yt9alZPbN
         XxBw==
X-Gm-Message-State: AOJu0YxEdkx3SQExGeR+D/Haq5OoJm/BVsSR7PJ7ha7X3sBvRLcGjUCg
	MEmv15NNi2FGTaySROfTqugu7CUeQmKNA6cDGeWkCbJoU5wP1CpAGShpEI+By4XezvE=
X-Gm-Gg: AfdE7cnBx9cdp21AYQrv2DCYDmkdv9rPhPxGpPwBxpOgxGhbgNMQOp0Da8uRU4FGPfp
	k80tpOrzyUT0X6IKiW3940mKXgfhly6RPqBCCuQh0UT/hWay2khDeu580o9g51AtheZdcezhv65
	H+gmgx6NX6AmAPOBi7AUWs+eukqf9U7PeSJItD28lofkq+DISaG1lceir9V5ZN4qN/lTTzRuzrQ
	nb3QvmQAu7lRUt3GYhii4jd7EWmamR7cwGXrZrLJ2rOzAIlASkN53zU6uPZsu0kwg9U4iu4mREj
	iaoC1iZWtB8DCqulZag9grLTrZQSPb+2TCrTBwaKrKCvj+uKifejIQ6BJ/Rsrb7dn9bjmWfolof
	BYsQTvGafmBtIFy7e4kYgk6goweEeadRL48ve+2YEaN0hF43Ka7eVACG+h5Y/IUmf1nl19KLqud
	TUhKQo1r2T1PC25KpqdtwlZAexAxiyyxX45DAikABXEFIeRhjp739kXmTkm+H7QOSd8b9K/NvuV
	YjLcYlxMVDVyxHtdG98mAVLrzAQwTub
X-Received: by 2002:a05:620a:31a2:b0:92e:c117:9ea4 with SMTP id af79cd13be357-92ef2e2a3aamr1063317585a.82.1783989467346;
        Mon, 13 Jul 2026 17:37:47 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d6c28bsm1289899185a.46.2026.07.13.17.37.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2026 17:37:47 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v3 05/14] lpfc: Add handling for when PLOGI or PRLI is dropped during link failure
Date: Mon, 13 Jul 2026 18:18:03 -0700
Message-Id: <20260714011812.106753-6-justintee8345@gmail.com>
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
index b756de9986eb..6720fd5ec523 100644
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

