Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A861C2D
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 00:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706660524; cv=none; b=fM3LH/WensNFFcfeIc0k15m5z+lSzG2hslxH5sYKizQm06YdIWOhiN8JLJiM4akFmdJLKm9Kh6VdFomdFQSTpes62ZXpHomygd198wW/KLmJK/leYwJViUI92n8678gjvsT0yeopgKrANPd1wKTOKQjBOqrFFnQF1H96V4eMcNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706660524; c=relaxed/simple;
	bh=wKJXboA2iya5N1/aC6iVjmzf2TH7p2kWzWVsS1Wa0jE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ifIQ0Vsye5y77h8kS23InabC27UDDVMIDMj1TcX8H1E1jqKWKVcybIy5B556pXp/VuE8A4pYvkmVdK+dVIizlT9c+O3UY74K0+aBStRN8SJiJV5IRcxfz93QLKJLGJHXfGKPj3cCYIxGOKx74xAK6i9/omeFh/s19ut1rT5v77o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bqXZh39q; arc=none smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bqXZh39q"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-46b3a129522so184662137.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 16:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706660522; x=1707265322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TeYQhzaNVbFhxez+6JqiRLGnFe80ipC8adEz51DpKRM=;
        b=bqXZh39qlP91H7qxXQ1M8H3sB+H33BYo+BCp+qIA4Ci2Eu+AsW/1Y2ZwfW2/dQompw
         ObWkYlajUi7Bvuuz2xVSEhzHUJ7/RGbT47yvv28OiPNF89wmR3XAIP92751YSKHuKbx4
         8TQ6IYNG9Dq/4nGtXL+4aCO3dkUgxrVJE+cIVEiBMcJ2eEL5uqRDkwhM6SQ/ntQmGItr
         rQUa1w6+lA9c/j9TB+S/r2IOTu3y2F8087MKIG8+SUplEBHwEH+Updm54E9E0MU06FFx
         7SWCTodLQkkvOKEZQGHpdnuFwZx8Gm+2zbgGIr7kG87FYSXspcUfvO4+zy57jlqhC+oe
         Pu/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706660522; x=1707265322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TeYQhzaNVbFhxez+6JqiRLGnFe80ipC8adEz51DpKRM=;
        b=PuNsRTFojjcSmptqJ37bxCF7KW3wtuHbGX6tOpgGMDbcLI1ZUqKRtC9zN+hPnvgQX9
         Pwr5hzgdPUBVdyjGGmCtuuiWVweCCG0sY5NRXVgb2VSXhIy3PeRvlntV2ObDDL0yT31+
         tum0NVt234vBSGGy5gCXKRJ8FjxPRqhcVmi8aVRChcFma23NXgek9bsgXmBv1lUo8N3M
         KFleRrQxqzzfyEsqLBRz0vqchjIMlVG3Pc1joilJHYDQyUADEmvUbEZ4j8b2znoa2AKb
         woL6d6T/ekdoy6xQf8Tv3LoOMdOtVtDc3u9SMQphLOtmTBM5BZOaIHBjVnDALHSjmnsJ
         HUPg==
X-Gm-Message-State: AOJu0YzSnCq6R72cKYEiavkFgdHoD84weQQWum+wawsIHlSz/qQhsl3r
	PoqhAczTnMHx4V9aCPnCldPVfD12IfJXihKN2GqK4x5ki5V7QLiqfgbkb6C7
X-Google-Smtp-Source: AGHT+IEw4sONpIZDL/q1Nmcg67R5Xw2SJJUDm2dEjFExsd+So7KNK1cYLIR0Co9fkqYm5q1yFjSteA==
X-Received: by 2002:a05:6102:2328:b0:46b:1f7d:4c80 with SMTP id b8-20020a056102232800b0046b1f7d4c80mr13562vsa.1.1706660521718;
        Tue, 30 Jan 2024 16:22:01 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id qn19-20020a056214571300b0068c4ecc8886sm2600931qvb.127.2024.01.30.16.22.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jan 2024 16:22:01 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 12/17] lpfc: Change nlp state statistic counters into atomic_t
Date: Tue, 30 Jan 2024 16:35:44 -0800
Message-Id: <20240131003549.147784-13-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131003549.147784-1-justintee8345@gmail.com>
References: <20240131003549.147784-1-justintee8345@gmail.com>
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

