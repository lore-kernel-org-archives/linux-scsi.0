Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C6318634
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 18:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726259; cv=none; b=JQotYr4KYurNADR73o4meCzblMCf0wLglUZL3xQkm4uUPntOcYieXusWKGCt0gsY+G3cA8U0yv3ZChCvHvndCK7Xc+47ogzIv/7GgejoSSjYACKrhPkACUrH4PRLnh0l2LDkabQ7OipVAqiMRJcIQO4fgHKImCI7SXSGIbgDDd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726259; c=relaxed/simple;
	bh=wKJXboA2iya5N1/aC6iVjmzf2TH7p2kWzWVsS1Wa0jE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HyzA5ddF8T1JkCE+6vYvO0L3C3RwO1h8vuI8APMtcCT+uNqdTtS0xQwbgqZmjcpKNBZHGScpg0PVWNsjj8dOPj/SeZRarGiBnt2s9XSB5JtS88GSYrHQ3gg9WC7CVU7SDk3ga3V0K86O5MzF5iAFJ1CWzEXaTZeZaY/bxb/Y/XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RQX62GyW; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RQX62GyW"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-4bda0abc59dso20749e0c.0
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 10:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706726256; x=1707331056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TeYQhzaNVbFhxez+6JqiRLGnFe80ipC8adEz51DpKRM=;
        b=RQX62GyWXQlJqjFnXsrXy5z9SzMePp0JesX6v5UhXZ8LhKwu9L5ApCflXE0ALXhpjV
         /lUM2VrhG8kU6tTFu8OEL9fBaOVdeBOWTsjVpPd4ff+C4ldNJVTKdHrn68pkXmjEF6jL
         989MZzc+TrCv+qMadaY0WpM8sJpgZ4mr0tMdSb8PrSlGHSeyR7exfwFB1z0PVpeDwfdT
         6dI5ppMY2F2jYJTEW4qmGcavK5eyvEkBTRJZemxbU7UTdIdaNJXsrhOkzbn+w+W3Lmeo
         BkqpQcq6rv4DCt/hhblZf6dQUVE9G8H1PiCvWFNl5635/FZAXhFboLlhzplpCDgoyZA8
         WVlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726256; x=1707331056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TeYQhzaNVbFhxez+6JqiRLGnFe80ipC8adEz51DpKRM=;
        b=FnfX1Y9eQRxuPHb4kpNWHe2cJjMhlfNkExBmp1U+QcgLt26wWQ5etMbjIH+4J/NjgT
         167zOY3VFJZLGKHVfvirQy3roX4vFt/Gi04Vs6ls5k5GBzfwUAr/8mHCmzJ2Wj0US6bx
         osN83xSCFPLU4uMnSn5uDp22YTVYbIli38kHuQC9c0WtZE4aHW9UdFsj3l0qLbMMm1NV
         RUeWF+WeNkdoixkIw+Icz0duOAYEU1185QBlNPJy1/DDCSmTtI5eauArq/FJ97eMorfa
         iappNdLEiKhU75EVPglX7ijbMRU80wytos2vml+Nhc4OQtdcPjRQUh+QYF0FwdBS/1/p
         ZxdQ==
X-Gm-Message-State: AOJu0YzTPwT/dhSIQNWun5/mdYTHH+tQOiAYkf6WtQYEi/TN6N4doY62
	aRPlvHKAgwp6S3NiL0OI36u208/Lx/Yv+1JR9de4WxgN8Q831VZv4eNTF9Tm
X-Google-Smtp-Source: AGHT+IHR2i6Nmk6nJ/sqZCQp8d7LKPFWsXcDVogGTTrUJoE4rBU/rCkAaiZm6paBCcHDQs4bOb6/xQ==
X-Received: by 2002:a05:6122:929:b0:4b6:e3fa:7599 with SMTP id j41-20020a056122092900b004b6e3fa7599mr485146vka.0.1706726256397;
        Wed, 31 Jan 2024 10:37:36 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id oq7-20020a056214460700b00684225ef3a0sm5111229qvb.93.2024.01.31.10.37.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jan 2024 10:37:36 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	himanshu.madhani@oracle.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 12/17] lpfc: Change nlp state statistic counters into atomic_t
Date: Wed, 31 Jan 2024 10:51:07 -0800
Message-Id: <20240131185112.149731-13-justintee8345@gmail.com>
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

There is no reason to use the shost_lock to synchronize an LLDD statistics
counter.  Convert all the nlp state statistic counters into atomic_t.
Corresponding zeroing, increments, and reads are converted to atomic
versions.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h         | 17 ++++++------
 drivers/scsi/lpfc/lpfc_attr.c    |  3 ++-
 drivers/scsi/lpfc/lpfc_els.c     | 10 ++++---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 46 ++++++++++++++++----------------
 drivers/scsi/lpfc/lpfc_init.c    | 11 +++++++-
 5 files changed, 50 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 04d608ea9106..8f3cac09a381 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -589,14 +589,15 @@ struct lpfc_vport {
 	struct list_head fc_nodes;
 
 	/* Keep counters for the number of entries in each list. */
-	uint16_t fc_plogi_cnt;
-	uint16_t fc_adisc_cnt;
-	uint16_t fc_reglogin_cnt;
-	uint16_t fc_prli_cnt;
-	uint16_t fc_unmap_cnt;
-	uint16_t fc_map_cnt;
-	uint16_t fc_npr_cnt;
-	uint16_t fc_unused_cnt;
+	atomic_t fc_plogi_cnt;
+	atomic_t fc_adisc_cnt;
+	atomic_t fc_reglogin_cnt;
+	atomic_t fc_prli_cnt;
+	atomic_t fc_unmap_cnt;
+	atomic_t fc_map_cnt;
+	atomic_t fc_npr_cnt;
+	atomic_t fc_unused_cnt;
+
 	struct serv_parm fc_sparam;	/* buffer for our service parameters */
 
 	uint32_t fc_myDID;	/* fibre channel S_ID */
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 1f9a529e09ff..142c90eb210f 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1260,7 +1260,8 @@ lpfc_num_discovered_ports_show(struct device *dev,
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 
 	return scnprintf(buf, PAGE_SIZE, "%d\n",
-			vport->fc_map_cnt + vport->fc_unmap_cnt);
+			 atomic_read(&vport->fc_map_cnt) +
+			 atomic_read(&vport->fc_unmap_cnt));
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 1ada8ba6cc2a..e01583e2690b 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1646,7 +1646,8 @@ lpfc_more_plogi(struct lpfc_vport *vport)
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 			 "0232 Continue discovery with %d PLOGIs to go "
 			 "Data: x%x x%x x%x\n",
-			 vport->num_disc_nodes, vport->fc_plogi_cnt,
+			 vport->num_disc_nodes,
+			 atomic_read(&vport->fc_plogi_cnt),
 			 vport->fc_flag, vport->port_state);
 	/* Check to see if there are more PLOGIs to be sent */
 	if (vport->fc_flag & FC_NLP_MORE)
@@ -2692,7 +2693,7 @@ lpfc_rscn_disc(struct lpfc_vport *vport)
 
 	/* RSCN discovery */
 	/* go thru NPR nodes and issue ELS PLOGIs */
-	if (vport->fc_npr_cnt)
+	if (atomic_read(&vport->fc_npr_cnt))
 		if (lpfc_els_disc_plogi(vport))
 			return;
 
@@ -2752,7 +2753,7 @@ lpfc_adisc_done(struct lpfc_vport *vport)
 		if (!(vport->fc_flag & FC_ABORT_DISCOVERY)) {
 			vport->num_disc_nodes = 0;
 			/* go thru NPR list, issue ELS PLOGIs */
-			if (vport->fc_npr_cnt)
+			if (atomic_read(&vport->fc_npr_cnt))
 				lpfc_els_disc_plogi(vport);
 			if (!vport->num_disc_nodes) {
 				spin_lock_irq(shost->host_lock);
@@ -2785,7 +2786,8 @@ lpfc_more_adisc(struct lpfc_vport *vport)
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 			 "0210 Continue discovery with %d ADISCs to go "
 			 "Data: x%x x%x x%x\n",
-			 vport->num_disc_nodes, vport->fc_adisc_cnt,
+			 vport->num_disc_nodes,
+			 atomic_read(&vport->fc_adisc_cnt),
 			 vport->fc_flag, vport->port_state);
 	/* Check to see if there are more ADISCs to be sent */
 	if (vport->fc_flag & FC_NLP_MORE) {
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 35ea67431239..7c4356d87730 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4023,7 +4023,7 @@ lpfc_mbx_cmpl_reg_vpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	spin_unlock_irq(shost->host_lock);
 	vport->num_disc_nodes = 0;
 	/* go thru NPR list and issue ELS PLOGIs */
-	if (vport->fc_npr_cnt)
+	if (atomic_read(&vport->fc_npr_cnt))
 		lpfc_els_disc_plogi(vport);
 
 	if (!vport->num_disc_nodes) {
@@ -4600,40 +4600,35 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
 static void
 lpfc_nlp_counters(struct lpfc_vport *vport, int state, int count)
 {
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-	unsigned long iflags;
-
-	spin_lock_irqsave(shost->host_lock, iflags);
 	switch (state) {
 	case NLP_STE_UNUSED_NODE:
-		vport->fc_unused_cnt += count;
+		atomic_add(count, &vport->fc_unused_cnt);
 		break;
 	case NLP_STE_PLOGI_ISSUE:
-		vport->fc_plogi_cnt += count;
+		atomic_add(count, &vport->fc_plogi_cnt);
 		break;
 	case NLP_STE_ADISC_ISSUE:
-		vport->fc_adisc_cnt += count;
+		atomic_add(count, &vport->fc_adisc_cnt);
 		break;
 	case NLP_STE_REG_LOGIN_ISSUE:
-		vport->fc_reglogin_cnt += count;
+		atomic_add(count, &vport->fc_reglogin_cnt);
 		break;
 	case NLP_STE_PRLI_ISSUE:
-		vport->fc_prli_cnt += count;
+		atomic_add(count, &vport->fc_prli_cnt);
 		break;
 	case NLP_STE_UNMAPPED_NODE:
-		vport->fc_unmap_cnt += count;
+		atomic_add(count, &vport->fc_unmap_cnt);
 		break;
 	case NLP_STE_MAPPED_NODE:
-		vport->fc_map_cnt += count;
+		atomic_add(count, &vport->fc_map_cnt);
 		break;
 	case NLP_STE_NPR_NODE:
-		if (vport->fc_npr_cnt == 0 && count == -1)
-			vport->fc_npr_cnt = 0;
+		if (!atomic_read(&vport->fc_npr_cnt) && count == -1)
+			atomic_set(&vport->fc_npr_cnt, 0);
 		else
-			vport->fc_npr_cnt += count;
+			atomic_add(count, &vport->fc_npr_cnt);
 		break;
 	}
-	spin_unlock_irqrestore(shost->host_lock, iflags);
 }
 
 /* Register a node with backend if not already done */
@@ -5034,8 +5029,9 @@ lpfc_set_disctmo(struct lpfc_vport *vport)
 			 "0247 Start Discovery Timer state x%x "
 			 "Data: x%x x%lx x%x x%x\n",
 			 vport->port_state, tmo,
-			 (unsigned long)&vport->fc_disctmo, vport->fc_plogi_cnt,
-			 vport->fc_adisc_cnt);
+			 (unsigned long)&vport->fc_disctmo,
+			 atomic_read(&vport->fc_plogi_cnt),
+			 atomic_read(&vport->fc_adisc_cnt));
 
 	return;
 }
@@ -5070,7 +5066,8 @@ lpfc_can_disctmo(struct lpfc_vport *vport)
 			 "0248 Cancel Discovery Timer state x%x "
 			 "Data: x%x x%x x%x\n",
 			 vport->port_state, vport->fc_flag,
-			 vport->fc_plogi_cnt, vport->fc_adisc_cnt);
+			 atomic_read(&vport->fc_plogi_cnt),
+			 atomic_read(&vport->fc_adisc_cnt));
 	return 0;
 }
 
@@ -5951,8 +5948,10 @@ lpfc_disc_start(struct lpfc_vport *vport)
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 			 "0202 Start Discovery port state x%x "
 			 "flg x%x Data: x%x x%x x%x\n",
-			 vport->port_state, vport->fc_flag, vport->fc_plogi_cnt,
-			 vport->fc_adisc_cnt, vport->fc_npr_cnt);
+			 vport->port_state, vport->fc_flag,
+			 atomic_read(&vport->fc_plogi_cnt),
+			 atomic_read(&vport->fc_adisc_cnt),
+			 atomic_read(&vport->fc_npr_cnt));
 
 	/* First do ADISCs - if any */
 	num_sent = lpfc_els_disc_adisc(vport);
@@ -5981,7 +5980,7 @@ lpfc_disc_start(struct lpfc_vport *vport)
 		if (!(vport->fc_flag & FC_ABORT_DISCOVERY)) {
 			vport->num_disc_nodes = 0;
 			/* go thru NPR nodes and issue ELS PLOGIs */
-			if (vport->fc_npr_cnt)
+			if (atomic_read(&vport->fc_npr_cnt))
 				lpfc_els_disc_plogi(vport);
 
 			if (!vport->num_disc_nodes) {
@@ -6077,7 +6076,8 @@ lpfc_disc_flush_list(struct lpfc_vport *vport)
 	struct lpfc_nodelist *ndlp, *next_ndlp;
 	struct lpfc_hba *phba = vport->phba;
 
-	if (vport->fc_plogi_cnt || vport->fc_adisc_cnt) {
+	if (atomic_read(&vport->fc_plogi_cnt) ||
+	    atomic_read(&vport->fc_adisc_cnt)) {
 		list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes,
 					 nlp_listp) {
 			if (ndlp->nlp_state == NLP_STE_PLOGI_ISSUE ||
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 8e84ba0f7721..1285a7bbdced 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4770,6 +4770,14 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	vport->load_flag |= FC_LOADING;
 	vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
 	vport->fc_rscn_flush = 0;
+	atomic_set(&vport->fc_plogi_cnt, 0);
+	atomic_set(&vport->fc_adisc_cnt, 0);
+	atomic_set(&vport->fc_reglogin_cnt, 0);
+	atomic_set(&vport->fc_prli_cnt, 0);
+	atomic_set(&vport->fc_unmap_cnt, 0);
+	atomic_set(&vport->fc_map_cnt, 0);
+	atomic_set(&vport->fc_npr_cnt, 0);
+	atomic_set(&vport->fc_unused_cnt, 0);
 	lpfc_get_vport_cfgparam(vport);
 
 	/* Adjust value in vport */
@@ -4946,7 +4954,8 @@ int lpfc_scan_finished(struct Scsi_Host *shost, unsigned long time)
 		goto finished;
 	if (vport->num_disc_nodes || vport->fc_prli_sent)
 		goto finished;
-	if (vport->fc_map_cnt == 0 && time < msecs_to_jiffies(2 * 1000))
+	if (!atomic_read(&vport->fc_map_cnt) &&
+	    time < msecs_to_jiffies(2 * 1000))
 		goto finished;
 	if ((phba->sli.sli_flag & LPFC_SLI_MBOX_ACTIVE) != 0)
 		goto finished;
-- 
2.38.0

