Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D374829A30D
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 17:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757957973; cv=none; b=TABVj+k4yDPLSootJB9fQ9+fj1a2rCw7KfSqt2wGsQ8FhRE4uQ9Py58z+mF9Q+l4tD8RZwGOK7MKVfmKbc/x4NkpubHF/PJEVmDtAVU4mmnbF2++GoPF37VIb3PnWq2UAnTH9OFh+T5VK5vPXcjW0Ru9fBdEIV99ydPAqUghzbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757957973; c=relaxed/simple;
	bh=Ltq3ozdiaaar1/n8yyAh6UzPl0OIYaYoCHDLmGyj8xk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cnMPRt4k4+UA6JeQaRXbGlG0w92KoJ/sn1zLZYtGeHsJk/be9g9+0FK6ome4bmaOceq4QQbHItpmxQBliwkdMe1ZoEOVMo/9PEgAG9FMGqiikV6wMyOLu/N6LtyHlNV8ggi0/4cHnV01qM+3D3pElMGtP+QMTntjkAx+UsSTuxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JvECIE5o; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JvECIE5o"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-77eaa808736so11770746d6.2
        for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 10:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757957970; x=1758562770; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ff+Ab/KnZhngiUUnYQztuWDhOlyY94rXve+GfvY8NxQ=;
        b=JvECIE5o53AQLyZgDa4FRNlMUhs1uIAGfRYMjWN1uRvH/tjDN2FDEhqd3YCTzQzD/M
         XEmDCqn4x/Mw7+vWZkJxmOJ3tCcqwJas6zVEYh1OjlmbYV5WawgDVLAnTheZc0bg6efn
         yWAcycmY3V3cDeY6Pk45y+I2gKM1gcSoONJ82lTkPQjBtJSO5amY/3C11iXz6XB2qIYc
         8OWmShRLxZFgr41DNbx5L38h9j0aB7j5g2j8DSAol32oYkC7nOJNKBjveScVcJgBnfb5
         yW4/2gElku6bx+w0Kkvxk832sHlFLActbTWtudnB3mhYpRe2SaA2TfibR9b60eqIXpzv
         iEFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757957970; x=1758562770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ff+Ab/KnZhngiUUnYQztuWDhOlyY94rXve+GfvY8NxQ=;
        b=iqymT9Cn9jET+QbE+sPzLTiLJNn48ZZPUOFO1umIFqJRSuzKzdmop6g6OPZ+Hb5Rk9
         NRGpuAr6jm1xR/HwUGmPnUDEWGyqrCd4V8lpH91O2EeOb7LFzjgVV819wWPHtZHMMhSd
         CuOplE7/1vPliBA1gaOutUkjGoJF4nf/UEmgOnG7iDOYTY+zPsdZndVjBb5heHFzyJsz
         71UzfFJGXri+IQ74/F1kb3UqHu2JjbAqQ1jl1mKqbwKGJWSN2WN4znGn+hBpifm9j9of
         /d0U3fEEhuKGrmuQ4gCfZC4SfEfRCVrWPBhq3wMMKrt6A4PnqMu+HRTs24zi7kypuTUZ
         QXhg==
X-Gm-Message-State: AOJu0Yyv6DUqOIpGwTP2bR5qndIMZ3Jy5b8Szur9xv6KWRR9p/L8YuNG
	NnDpTPSK5HFHLtOm0AOgJYy2Z7KxUB2c0+d96Jpfhy1a2EI3NB55AAfSKomu7A==
X-Gm-Gg: ASbGncvDoCfGci/MsPJEV6bS4krHTlJR5rdXrlDijvGTFwOPw6yxrBOPFbZiRbmwa2w
	Bk7dbex8XZLJC8NYB7hSsjD/NaJMUcGXUn6ii9v3l3mcNrmBNRqRJzrgdzFaiznAAOtT6ST6zMQ
	4Rz1NRQ6s/YHCxJI8P9uL15Wx81sSZr1yMvD2agMZ+/Na0RwUTwvvQ/Y/5GYKQh5IbQfZyXs98q
	xRwUWp7FutKLBGNIquAl5QpoHoIw6Jt4vgH0+oNxqu36pxz8uPDGEs8zuZtn9WVOx2Csv6IUHXR
	OcgaKzFNXo4hHg7GiezTcWRqEd/nmPjdHKV6b8Ut1jfVB5Y1hjFskt3DAoTf/qqjExkscI/Vw0b
	qOqR+E6Sp8hotWKN37vpP3pETLUgzLdOq52hb+O/lDgOoKhIHFnw7Lr+FSNW71ZmdrWWSFWIrdf
	0qp2h6iSg=
X-Google-Smtp-Source: AGHT+IES41kHD8wpMGGBkKsKS0FL8w+FYvchmw8K30VgDZPxOwDAKMWCXr5Nf6WMhpGOASWGuZcTuw==
X-Received: by 2002:a05:6214:1d07:b0:785:c20b:f602 with SMTP id 6a1803df08f44-785c20bf775mr39726766d6.61.1757957969512;
        Mon, 15 Sep 2025 10:39:29 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-77ef70bcc4esm29710976d6.41.2025.09.15.10.39.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Sep 2025 10:39:29 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 11/14] lpfc: Clean up extraneous phba dentries
Date: Mon, 15 Sep 2025 11:08:08 -0700
Message-Id: <20250915180811.137530-12-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250915180811.137530-1-justintee8345@gmail.com>
References: <20250915180811.137530-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Because debugfs_remove recursively removes debugfs entries, the
lpfc_debugfs_terminate routine is updated to remove only the parent/root
debugfs directories.  As such, there no longer is a need to keep track of
each individual debugfs entry so clean up the unused phba dentries.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Closes: https://lore.kernel.org/linux-fsdevel/20250702212917.GK3406663@ZenIV/
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h         |  38 +--
 drivers/scsi/lpfc/lpfc_debugfs.c | 476 ++++++++-----------------------
 2 files changed, 124 insertions(+), 390 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 588411200b00..f0e7f7ee4760 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -741,12 +741,6 @@ struct lpfc_vport {
 	struct lpfc_vmid_priority_info vmid_priority;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
-	struct dentry *debug_disc_trc;
-	struct dentry *debug_nodelist;
-	struct dentry *debug_nvmestat;
-	struct dentry *debug_scsistat;
-	struct dentry *debug_ioktime;
-	struct dentry *debug_hdwqstat;
 	struct dentry *vport_debugfs_root;
 	struct lpfc_debugfs_trc *disc_trc;
 	atomic_t disc_trc_cnt;
@@ -1339,29 +1333,8 @@ struct lpfc_hba {
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct dentry *hba_debugfs_root;
 	atomic_t debugfs_vport_count;
-	struct dentry *debug_multixri_pools;
-	struct dentry *debug_hbqinfo;
-	struct dentry *debug_dumpHostSlim;
-	struct dentry *debug_dumpHBASlim;
-	struct dentry *debug_InjErrLBA;  /* LBA to inject errors at */
-	struct dentry *debug_InjErrNPortID;  /* NPortID to inject errors at */
-	struct dentry *debug_InjErrWWPN;  /* WWPN to inject errors at */
-	struct dentry *debug_writeGuard; /* inject write guard_tag errors */
-	struct dentry *debug_writeApp;   /* inject write app_tag errors */
-	struct dentry *debug_writeRef;   /* inject write ref_tag errors */
-	struct dentry *debug_readGuard;  /* inject read guard_tag errors */
-	struct dentry *debug_readApp;    /* inject read app_tag errors */
-	struct dentry *debug_readRef;    /* inject read ref_tag errors */
-
-	struct dentry *debug_nvmeio_trc;
+
 	struct lpfc_debugfs_nvmeio_trc *nvmeio_trc;
-	struct dentry *debug_hdwqinfo;
-#ifdef LPFC_HDWQ_LOCK_STAT
-	struct dentry *debug_lockstat;
-#endif
-	struct dentry *debug_cgn_buffer;
-	struct dentry *debug_rx_monitor;
-	struct dentry *debug_ras_log;
 	atomic_t nvmeio_trc_cnt;
 	uint32_t nvmeio_trc_size;
 	uint32_t nvmeio_trc_output_idx;
@@ -1378,19 +1351,10 @@ struct lpfc_hba {
 	sector_t lpfc_injerr_lba;
 #define LPFC_INJERR_LBA_OFF	(sector_t)(-1)
 
-	struct dentry *debug_slow_ring_trc;
 	struct lpfc_debugfs_trc *slow_ring_trc;
 	atomic_t slow_ring_trc_cnt;
 	/* iDiag debugfs sub-directory */
 	struct dentry *idiag_root;
-	struct dentry *idiag_pci_cfg;
-	struct dentry *idiag_bar_acc;
-	struct dentry *idiag_que_info;
-	struct dentry *idiag_que_acc;
-	struct dentry *idiag_drb_acc;
-	struct dentry *idiag_ctl_acc;
-	struct dentry *idiag_mbx_acc;
-	struct dentry *idiag_ext_acc;
 	uint8_t lpfc_idiag_last_eq;
 #endif
 	uint16_t nvmeio_trc_on;
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 691314c68b59..eaedbaff5a78 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -6075,6 +6075,11 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 	if (!lpfc_debugfs_root) {
 		lpfc_debugfs_root = debugfs_create_dir("lpfc", NULL);
 		atomic_set(&lpfc_debugfs_hba_count, 0);
+		if (IS_ERR(lpfc_debugfs_root)) {
+			lpfc_vlog_msg(vport, KERN_WARNING, LOG_INIT,
+				      "0527 Cannot create debugfs lpfc\n");
+			return;
+		}
 	}
 	if (!lpfc_debugfs_start_time)
 		lpfc_debugfs_start_time = jiffies;
@@ -6085,150 +6090,96 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 		pport_setup = true;
 		phba->hba_debugfs_root =
 			debugfs_create_dir(name, lpfc_debugfs_root);
-		atomic_inc(&lpfc_debugfs_hba_count);
 		atomic_set(&phba->debugfs_vport_count, 0);
+		if (IS_ERR(phba->hba_debugfs_root)) {
+			lpfc_vlog_msg(vport, KERN_WARNING, LOG_INIT,
+				      "0528 Cannot create debugfs %s\n", name);
+			return;
+		}
+		atomic_inc(&lpfc_debugfs_hba_count);
 
 		/* Multi-XRI pools */
-		snprintf(name, sizeof(name), "multixripools");
-		phba->debug_multixri_pools =
-			debugfs_create_file(name, S_IFREG | 0644,
-					    phba->hba_debugfs_root,
-					    phba,
-					    &lpfc_debugfs_op_multixripools);
-		if (IS_ERR(phba->debug_multixri_pools)) {
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-					 "0527 Cannot create debugfs multixripools\n");
-			goto debug_failed;
-		}
+		debugfs_create_file("multixripools", 0644,
+				    phba->hba_debugfs_root, phba,
+				    &lpfc_debugfs_op_multixripools);
 
 		/* Congestion Info Buffer */
-		scnprintf(name, sizeof(name), "cgn_buffer");
-		phba->debug_cgn_buffer =
-			debugfs_create_file(name, S_IFREG | 0644,
-					    phba->hba_debugfs_root,
-					    phba, &lpfc_cgn_buffer_op);
-		if (IS_ERR(phba->debug_cgn_buffer)) {
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-					 "6527 Cannot create debugfs "
-					 "cgn_buffer\n");
-			goto debug_failed;
-		}
+		debugfs_create_file("cgn_buffer", 0644, phba->hba_debugfs_root,
+				    phba, &lpfc_cgn_buffer_op);
 
 		/* RX Monitor */
-		scnprintf(name, sizeof(name), "rx_monitor");
-		phba->debug_rx_monitor =
-			debugfs_create_file(name, S_IFREG | 0644,
-					    phba->hba_debugfs_root,
-					    phba, &lpfc_rx_monitor_op);
-		if (IS_ERR(phba->debug_rx_monitor)) {
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-					 "6528 Cannot create debugfs "
-					 "rx_monitor\n");
-			goto debug_failed;
-		}
+		debugfs_create_file("rx_monitor", 0644, phba->hba_debugfs_root,
+				    phba, &lpfc_rx_monitor_op);
 
 		/* RAS log */
-		snprintf(name, sizeof(name), "ras_log");
-		phba->debug_ras_log =
-			debugfs_create_file(name, 0644,
-					    phba->hba_debugfs_root,
-					    phba, &lpfc_debugfs_ras_log);
-		if (IS_ERR(phba->debug_ras_log)) {
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-					 "6148 Cannot create debugfs"
-					 " ras_log\n");
-			goto debug_failed;
-		}
+		debugfs_create_file("ras_log", 0644, phba->hba_debugfs_root,
+				    phba, &lpfc_debugfs_ras_log);
 
 		/* Setup hbqinfo */
-		snprintf(name, sizeof(name), "hbqinfo");
-		phba->debug_hbqinfo =
-			debugfs_create_file(name, S_IFREG | 0644,
-					    phba->hba_debugfs_root,
-					    phba, &lpfc_debugfs_op_hbqinfo);
+		debugfs_create_file("hbqinfo", 0644, phba->hba_debugfs_root,
+				    phba, &lpfc_debugfs_op_hbqinfo);
 
 #ifdef LPFC_HDWQ_LOCK_STAT
 		/* Setup lockstat */
-		snprintf(name, sizeof(name), "lockstat");
-		phba->debug_lockstat =
-			debugfs_create_file(name, S_IFREG | 0644,
-					    phba->hba_debugfs_root,
-					    phba, &lpfc_debugfs_op_lockstat);
-		if (IS_ERR(phba->debug_lockstat)) {
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-					 "4610 Can't create debugfs lockstat\n");
-			goto debug_failed;
-		}
+		debugfs_create_file("lockstat", 0644, phba->hba_debugfs_root,
+				    phba, &lpfc_debugfs_op_lockstat);
 #endif
-
-		/* Setup dumpHBASlim */
 		if (phba->sli_rev < LPFC_SLI_REV4) {
-			snprintf(name, sizeof(name), "dumpHBASlim");
-			phba->debug_dumpHBASlim =
-				debugfs_create_file(name,
-					S_IFREG|S_IRUGO|S_IWUSR,
-					phba->hba_debugfs_root,
-					phba, &lpfc_debugfs_op_dumpHBASlim);
-		} else
-			phba->debug_dumpHBASlim = NULL;
+			/* Setup dumpHBASlim */
+			debugfs_create_file("dumpHBASlim", 0644,
+					    phba->hba_debugfs_root, phba,
+					    &lpfc_debugfs_op_dumpHBASlim);
+		}
 
-		/* Setup dumpHostSlim */
 		if (phba->sli_rev < LPFC_SLI_REV4) {
-			snprintf(name, sizeof(name), "dumpHostSlim");
-			phba->debug_dumpHostSlim =
-				debugfs_create_file(name,
-					S_IFREG|S_IRUGO|S_IWUSR,
-					phba->hba_debugfs_root,
-					phba, &lpfc_debugfs_op_dumpHostSlim);
-		} else
-			phba->debug_dumpHostSlim = NULL;
+			/* Setup dumpHostSlim */
+			debugfs_create_file("dumpHostSlim", 0644,
+					    phba->hba_debugfs_root, phba,
+					    &lpfc_debugfs_op_dumpHostSlim);
+		}
 
 		/* Setup DIF Error Injections */
-		phba->debug_InjErrLBA =
-			debugfs_create_file_aux_num("InjErrLBA", 0644,
-			phba->hba_debugfs_root,
-			phba, InjErrLBA, &lpfc_debugfs_op_dif_err);
+		debugfs_create_file_aux_num("InjErrLBA", 0644,
+					    phba->hba_debugfs_root, phba,
+					    InjErrLBA,
+					    &lpfc_debugfs_op_dif_err);
 		phba->lpfc_injerr_lba = LPFC_INJERR_LBA_OFF;
 
-		phba->debug_InjErrNPortID =
-			debugfs_create_file_aux_num("InjErrNPortID", 0644,
-			phba->hba_debugfs_root,
-			phba, InjErrNPortID, &lpfc_debugfs_op_dif_err);
-
-		phba->debug_InjErrWWPN =
-			debugfs_create_file_aux_num("InjErrWWPN", 0644,
-			phba->hba_debugfs_root,
-			phba, InjErrWWPN, &lpfc_debugfs_op_dif_err);
-
-		phba->debug_writeGuard =
-			debugfs_create_file_aux_num("writeGuardInjErr", 0644,
-			phba->hba_debugfs_root,
-			phba, writeGuard, &lpfc_debugfs_op_dif_err);
-
-		phba->debug_writeApp =
-			debugfs_create_file_aux_num("writeAppInjErr", 0644,
-			phba->hba_debugfs_root,
-			phba, writeApp, &lpfc_debugfs_op_dif_err);
-
-		phba->debug_writeRef =
-			debugfs_create_file_aux_num("writeRefInjErr", 0644,
-			phba->hba_debugfs_root,
-			phba, writeRef, &lpfc_debugfs_op_dif_err);
-
-		phba->debug_readGuard =
-			debugfs_create_file_aux_num("readGuardInjErr", 0644,
-			phba->hba_debugfs_root,
-			phba, readGuard, &lpfc_debugfs_op_dif_err);
-
-		phba->debug_readApp =
-			debugfs_create_file_aux_num("readAppInjErr", 0644,
-			phba->hba_debugfs_root,
-			phba, readApp, &lpfc_debugfs_op_dif_err);
-
-		phba->debug_readRef =
-			debugfs_create_file_aux_num("readRefInjErr", 0644,
-			phba->hba_debugfs_root,
-			phba, readRef, &lpfc_debugfs_op_dif_err);
+		debugfs_create_file_aux_num("InjErrNPortID", 0644,
+					    phba->hba_debugfs_root, phba,
+					    InjErrNPortID,
+					    &lpfc_debugfs_op_dif_err);
+
+		debugfs_create_file_aux_num("InjErrWWPN", 0644,
+					    phba->hba_debugfs_root, phba,
+					    InjErrWWPN,
+					    &lpfc_debugfs_op_dif_err);
+
+		debugfs_create_file_aux_num("writeGuardInjErr", 0644,
+					    phba->hba_debugfs_root, phba,
+					    writeGuard,
+					    &lpfc_debugfs_op_dif_err);
+
+		debugfs_create_file_aux_num("writeAppInjErr", 0644,
+					    phba->hba_debugfs_root, phba,
+					    writeApp, &lpfc_debugfs_op_dif_err);
+
+		debugfs_create_file_aux_num("writeRefInjErr", 0644,
+					    phba->hba_debugfs_root, phba,
+					    writeRef, &lpfc_debugfs_op_dif_err);
+
+		debugfs_create_file_aux_num("readGuardInjErr", 0644,
+					    phba->hba_debugfs_root, phba,
+					    readGuard,
+					    &lpfc_debugfs_op_dif_err);
+
+		debugfs_create_file_aux_num("readAppInjErr", 0644,
+					    phba->hba_debugfs_root, phba,
+					    readApp, &lpfc_debugfs_op_dif_err);
+
+		debugfs_create_file_aux_num("readRefInjErr", 0644,
+					    phba->hba_debugfs_root, phba,
+					    readRef, &lpfc_debugfs_op_dif_err);
 
 		/* Setup slow ring trace */
 		if (lpfc_debugfs_max_slow_ring_trc) {
@@ -6248,11 +6199,9 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			}
 		}
 
-		snprintf(name, sizeof(name), "slow_ring_trace");
-		phba->debug_slow_ring_trc =
-			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
-				 phba->hba_debugfs_root,
-				 phba, &lpfc_debugfs_op_slow_ring_trc);
+		debugfs_create_file("slow_ring_trace", 0644,
+				    phba->hba_debugfs_root, phba,
+				    &lpfc_debugfs_op_slow_ring_trc);
 		if (!phba->slow_ring_trc) {
 			phba->slow_ring_trc = kcalloc(
 				lpfc_debugfs_max_slow_ring_trc,
@@ -6262,16 +6211,13 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 						 "0416 Cannot create debugfs "
 						 "slow_ring buffer\n");
-				goto debug_failed;
+				goto out;
 			}
 			atomic_set(&phba->slow_ring_trc_cnt, 0);
 		}
 
-		snprintf(name, sizeof(name), "nvmeio_trc");
-		phba->debug_nvmeio_trc =
-			debugfs_create_file(name, 0644,
-					    phba->hba_debugfs_root,
-					    phba, &lpfc_debugfs_op_nvmeio_trc);
+		debugfs_create_file("nvmeio_trc", 0644, phba->hba_debugfs_root,
+				    phba, &lpfc_debugfs_op_nvmeio_trc);
 
 		atomic_set(&phba->nvmeio_trc_cnt, 0);
 		if (lpfc_debugfs_max_nvmeio_trc) {
@@ -6317,6 +6263,11 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 	if (!vport->vport_debugfs_root) {
 		vport->vport_debugfs_root =
 			debugfs_create_dir(name, phba->hba_debugfs_root);
+		if (IS_ERR(vport->vport_debugfs_root)) {
+			lpfc_vlog_msg(vport, KERN_WARNING, LOG_INIT,
+				      "0529 Cannot create debugfs %s\n", name);
+			return;
+		}
 		atomic_inc(&phba->debugfs_vport_count);
 	}
 
@@ -6344,54 +6295,27 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 				 "0418 Cannot create debugfs disc trace "
 				 "buffer\n");
-		goto debug_failed;
+		goto out;
 	}
 	atomic_set(&vport->disc_trc_cnt, 0);
 
-	snprintf(name, sizeof(name), "discovery_trace");
-	vport->debug_disc_trc =
-		debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
-				 vport->vport_debugfs_root,
-				 vport, &lpfc_debugfs_op_disc_trc);
-	snprintf(name, sizeof(name), "nodelist");
-	vport->debug_nodelist =
-		debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
-				 vport->vport_debugfs_root,
-				 vport, &lpfc_debugfs_op_nodelist);
-
-	snprintf(name, sizeof(name), "nvmestat");
-	vport->debug_nvmestat =
-		debugfs_create_file(name, 0644,
-				    vport->vport_debugfs_root,
-				    vport, &lpfc_debugfs_op_nvmestat);
-
-	snprintf(name, sizeof(name), "scsistat");
-	vport->debug_scsistat =
-		debugfs_create_file(name, 0644,
-				    vport->vport_debugfs_root,
-				    vport, &lpfc_debugfs_op_scsistat);
-	if (IS_ERR(vport->debug_scsistat)) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-				 "4611 Cannot create debugfs scsistat\n");
-		goto debug_failed;
-	}
+	debugfs_create_file("discovery_trace", 0644, vport->vport_debugfs_root,
+			    vport, &lpfc_debugfs_op_disc_trc);
 
-	snprintf(name, sizeof(name), "ioktime");
-	vport->debug_ioktime =
-		debugfs_create_file(name, 0644,
-				    vport->vport_debugfs_root,
-				    vport, &lpfc_debugfs_op_ioktime);
-	if (IS_ERR(vport->debug_ioktime)) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-				 "0815 Cannot create debugfs ioktime\n");
-		goto debug_failed;
-	}
+	debugfs_create_file("nodelist", 0644, vport->vport_debugfs_root, vport,
+			    &lpfc_debugfs_op_nodelist);
+
+	debugfs_create_file("nvmestat", 0644, vport->vport_debugfs_root, vport,
+			    &lpfc_debugfs_op_nvmestat);
 
-	snprintf(name, sizeof(name), "hdwqstat");
-	vport->debug_hdwqstat =
-		debugfs_create_file(name, 0644,
-				    vport->vport_debugfs_root,
-				    vport, &lpfc_debugfs_op_hdwqstat);
+	debugfs_create_file("scsistat", 0644, vport->vport_debugfs_root, vport,
+			    &lpfc_debugfs_op_scsistat);
+
+	debugfs_create_file("ioktime", 0644, vport->vport_debugfs_root, vport,
+			    &lpfc_debugfs_op_ioktime);
+
+	debugfs_create_file("hdwqstat", 0644, vport->vport_debugfs_root, vport,
+			    &lpfc_debugfs_op_hdwqstat);
 
 	/*
 	 * The following section is for additional directories/files for the
@@ -6399,93 +6323,58 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 	 */
 
 	if (!pport_setup)
-		goto debug_failed;
+		return;
 
 	/*
 	 * iDiag debugfs root entry points for SLI4 device only
 	 */
 	if (phba->sli_rev < LPFC_SLI_REV4)
-		goto debug_failed;
+		return;
 
-	snprintf(name, sizeof(name), "iDiag");
 	if (!phba->idiag_root) {
 		phba->idiag_root =
-			debugfs_create_dir(name, phba->hba_debugfs_root);
+			debugfs_create_dir("iDiag", phba->hba_debugfs_root);
 		/* Initialize iDiag data structure */
 		memset(&idiag, 0, sizeof(idiag));
 	}
 
 	/* iDiag read PCI config space */
-	snprintf(name, sizeof(name), "pciCfg");
-	if (!phba->idiag_pci_cfg) {
-		phba->idiag_pci_cfg =
-			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
-				phba->idiag_root, phba, &lpfc_idiag_op_pciCfg);
-		idiag.offset.last_rd = 0;
-	}
+	debugfs_create_file("pciCfg", 0644, phba->idiag_root, phba,
+			    &lpfc_idiag_op_pciCfg);
+	idiag.offset.last_rd = 0;
 
 	/* iDiag PCI BAR access */
-	snprintf(name, sizeof(name), "barAcc");
-	if (!phba->idiag_bar_acc) {
-		phba->idiag_bar_acc =
-			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
-				phba->idiag_root, phba, &lpfc_idiag_op_barAcc);
-		idiag.offset.last_rd = 0;
-	}
+	debugfs_create_file("barAcc", 0644, phba->idiag_root, phba,
+			    &lpfc_idiag_op_barAcc);
+	idiag.offset.last_rd = 0;
 
 	/* iDiag get PCI function queue information */
-	snprintf(name, sizeof(name), "queInfo");
-	if (!phba->idiag_que_info) {
-		phba->idiag_que_info =
-			debugfs_create_file(name, S_IFREG|S_IRUGO,
-			phba->idiag_root, phba, &lpfc_idiag_op_queInfo);
-	}
+	debugfs_create_file("queInfo", 0444, phba->idiag_root, phba,
+			    &lpfc_idiag_op_queInfo);
 
 	/* iDiag access PCI function queue */
-	snprintf(name, sizeof(name), "queAcc");
-	if (!phba->idiag_que_acc) {
-		phba->idiag_que_acc =
-			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
-				phba->idiag_root, phba, &lpfc_idiag_op_queAcc);
-	}
+	debugfs_create_file("queAcc", 0644, phba->idiag_root, phba,
+			    &lpfc_idiag_op_queAcc);
 
 	/* iDiag access PCI function doorbell registers */
-	snprintf(name, sizeof(name), "drbAcc");
-	if (!phba->idiag_drb_acc) {
-		phba->idiag_drb_acc =
-			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
-				phba->idiag_root, phba, &lpfc_idiag_op_drbAcc);
-	}
+	debugfs_create_file("drbAcc", 0644, phba->idiag_root, phba,
+			    &lpfc_idiag_op_drbAcc);
 
 	/* iDiag access PCI function control registers */
-	snprintf(name, sizeof(name), "ctlAcc");
-	if (!phba->idiag_ctl_acc) {
-		phba->idiag_ctl_acc =
-			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
-				phba->idiag_root, phba, &lpfc_idiag_op_ctlAcc);
-	}
+	debugfs_create_file("ctlAcc", 0644, phba->idiag_root, phba,
+			    &lpfc_idiag_op_ctlAcc);
 
 	/* iDiag access mbox commands */
-	snprintf(name, sizeof(name), "mbxAcc");
-	if (!phba->idiag_mbx_acc) {
-		phba->idiag_mbx_acc =
-			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
-				phba->idiag_root, phba, &lpfc_idiag_op_mbxAcc);
-	}
+	debugfs_create_file("mbxAcc", 0644, phba->idiag_root, phba,
+			    &lpfc_idiag_op_mbxAcc);
 
 	/* iDiag extents access commands */
 	if (phba->sli4_hba.extents_in_use) {
-		snprintf(name, sizeof(name), "extAcc");
-		if (!phba->idiag_ext_acc) {
-			phba->idiag_ext_acc =
-				debugfs_create_file(name,
-						    S_IFREG|S_IRUGO|S_IWUSR,
-						    phba->idiag_root, phba,
-						    &lpfc_idiag_op_extAcc);
-		}
+		debugfs_create_file("extAcc", 0644, phba->idiag_root, phba,
+				    &lpfc_idiag_op_extAcc);
 	}
-
-debug_failed:
+out:
+	/* alloc'ed items are kfree'd in lpfc_debugfs_terminate */
 	return;
 #endif
 }
@@ -6510,24 +6399,6 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 	kfree(vport->disc_trc);
 	vport->disc_trc = NULL;
 
-	debugfs_remove(vport->debug_disc_trc); /* discovery_trace */
-	vport->debug_disc_trc = NULL;
-
-	debugfs_remove(vport->debug_nodelist); /* nodelist */
-	vport->debug_nodelist = NULL;
-
-	debugfs_remove(vport->debug_nvmestat); /* nvmestat */
-	vport->debug_nvmestat = NULL;
-
-	debugfs_remove(vport->debug_scsistat); /* scsistat */
-	vport->debug_scsistat = NULL;
-
-	debugfs_remove(vport->debug_ioktime); /* ioktime */
-	vport->debug_ioktime = NULL;
-
-	debugfs_remove(vport->debug_hdwqstat); /* hdwqstat */
-	vport->debug_hdwqstat = NULL;
-
 	if (vport->vport_debugfs_root) {
 		debugfs_remove(vport->vport_debugfs_root); /* vportX */
 		vport->vport_debugfs_root = NULL;
@@ -6535,113 +6406,12 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 	}
 
 	if (atomic_read(&phba->debugfs_vport_count) == 0) {
-
-		debugfs_remove(phba->debug_multixri_pools); /* multixripools*/
-		phba->debug_multixri_pools = NULL;
-
-		debugfs_remove(phba->debug_hbqinfo); /* hbqinfo */
-		phba->debug_hbqinfo = NULL;
-
-		debugfs_remove(phba->debug_cgn_buffer);
-		phba->debug_cgn_buffer = NULL;
-
-		debugfs_remove(phba->debug_rx_monitor);
-		phba->debug_rx_monitor = NULL;
-
-		debugfs_remove(phba->debug_ras_log);
-		phba->debug_ras_log = NULL;
-
-#ifdef LPFC_HDWQ_LOCK_STAT
-		debugfs_remove(phba->debug_lockstat); /* lockstat */
-		phba->debug_lockstat = NULL;
-#endif
-		debugfs_remove(phba->debug_dumpHBASlim); /* HBASlim */
-		phba->debug_dumpHBASlim = NULL;
-
-		debugfs_remove(phba->debug_dumpHostSlim); /* HostSlim */
-		phba->debug_dumpHostSlim = NULL;
-
-		debugfs_remove(phba->debug_InjErrLBA); /* InjErrLBA */
-		phba->debug_InjErrLBA = NULL;
-
-		debugfs_remove(phba->debug_InjErrNPortID);
-		phba->debug_InjErrNPortID = NULL;
-
-		debugfs_remove(phba->debug_InjErrWWPN); /* InjErrWWPN */
-		phba->debug_InjErrWWPN = NULL;
-
-		debugfs_remove(phba->debug_writeGuard); /* writeGuard */
-		phba->debug_writeGuard = NULL;
-
-		debugfs_remove(phba->debug_writeApp); /* writeApp */
-		phba->debug_writeApp = NULL;
-
-		debugfs_remove(phba->debug_writeRef); /* writeRef */
-		phba->debug_writeRef = NULL;
-
-		debugfs_remove(phba->debug_readGuard); /* readGuard */
-		phba->debug_readGuard = NULL;
-
-		debugfs_remove(phba->debug_readApp); /* readApp */
-		phba->debug_readApp = NULL;
-
-		debugfs_remove(phba->debug_readRef); /* readRef */
-		phba->debug_readRef = NULL;
-
 		kfree(phba->slow_ring_trc);
 		phba->slow_ring_trc = NULL;
 
-		/* slow_ring_trace */
-		debugfs_remove(phba->debug_slow_ring_trc);
-		phba->debug_slow_ring_trc = NULL;
-
-		debugfs_remove(phba->debug_nvmeio_trc);
-		phba->debug_nvmeio_trc = NULL;
-
 		kfree(phba->nvmeio_trc);
 		phba->nvmeio_trc = NULL;
 
-		/*
-		 * iDiag release
-		 */
-		if (phba->sli_rev == LPFC_SLI_REV4) {
-			/* iDiag extAcc */
-			debugfs_remove(phba->idiag_ext_acc);
-			phba->idiag_ext_acc = NULL;
-
-			/* iDiag mbxAcc */
-			debugfs_remove(phba->idiag_mbx_acc);
-			phba->idiag_mbx_acc = NULL;
-
-			/* iDiag ctlAcc */
-			debugfs_remove(phba->idiag_ctl_acc);
-			phba->idiag_ctl_acc = NULL;
-
-			/* iDiag drbAcc */
-			debugfs_remove(phba->idiag_drb_acc);
-			phba->idiag_drb_acc = NULL;
-
-			/* iDiag queAcc */
-			debugfs_remove(phba->idiag_que_acc);
-			phba->idiag_que_acc = NULL;
-
-			/* iDiag queInfo */
-			debugfs_remove(phba->idiag_que_info);
-			phba->idiag_que_info = NULL;
-
-			/* iDiag barAcc */
-			debugfs_remove(phba->idiag_bar_acc);
-			phba->idiag_bar_acc = NULL;
-
-			/* iDiag pciCfg */
-			debugfs_remove(phba->idiag_pci_cfg);
-			phba->idiag_pci_cfg = NULL;
-
-			/* Finally remove the iDiag debugfs root */
-			debugfs_remove(phba->idiag_root);
-			phba->idiag_root = NULL;
-		}
-
 		if (phba->hba_debugfs_root) {
 			debugfs_remove(phba->hba_debugfs_root); /* fnX */
 			phba->hba_debugfs_root = NULL;
-- 
2.38.0

