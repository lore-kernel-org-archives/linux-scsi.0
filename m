Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B44289E0B
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 17:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757957974; cv=none; b=uslZTt3IaBHrGP0d44zngbzk1QD90r9tGvdi8dgK4OXEHJzRAtQx+fzEClrW0OFmUxjALYGAn3dZXCwE/aoxcNS+pHr2zWxy3zt/qZvUHP9+XnudpwtngZrlS+7ofpRhZuDDCuzGMldV1+PLUlSnmVRJ5ZdM4IHR5CSIPvgZU6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757957974; c=relaxed/simple;
	bh=Ra8yqsjs9oWIfZWnfAfahqMKoWDXI/JR+p4qERVk1Ug=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DQkmMNhBVRTClSoM32xK248JbdBdH/aU4/5C44PAm85YC8UGz3jik3TVXV0xoRSyNARTBzbIdFr7bx/wKmdm8kX+aNRMcJ9maL1+QBU9AoCNciSV62hvZyep6KRTp0yRs/996OGcBUj8D92/S35suVriy1DfPKTeAqza1VAbEYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fvf4GHhK; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fvf4GHhK"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-765936cbdfeso41819876d6.0
        for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 10:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757957972; x=1758562772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RrHnGsxa2Fgxb/zsZ42xl6vwu7SnDgb8bc/AjLcxHFI=;
        b=fvf4GHhKVFfAlBGJpXm8PRjAyfRSEWUuEeh5uFLnUiv8bpLDelOL8GOmLEabipJirq
         t8a7zpnl29R/KJl1/ZEBd1e4bdFUkImBufh9BqOiubFNsGfYFl6ROR35P4wNoAKbosub
         KKkWUxO9AzUD5Wpax2Z66J+f0yJvYPHDteHHVPZmeLvu46FOKCxIXmY8G8BFwYwViV09
         C213WJ9obT6M7uN6zTqs3DrVM/ckOwPCt937Km/w0egPLEDYrHyYLWK/sPe3Ann0egA0
         2wMulOubbl0hns1HOFMnrg83RpA/CSiUv7XMtdHZyFs/3Tql3p1hcfiuUJCo97zGB2Hn
         cyRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757957972; x=1758562772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RrHnGsxa2Fgxb/zsZ42xl6vwu7SnDgb8bc/AjLcxHFI=;
        b=pqQ0OCyWJcw3PEBkKuwZMAozaidyJfglN8R6wFF3itK7FEXHltqXpflST4hFgdRXjg
         jAJW6OwZKAx/ZtjVKAnGtLp1wUY/+Z8VXEy3fwmIdxANHHjrmDf1q4zcAgDWrWpRP+Zz
         IO+El5mWHmR/xQfEzfIiA0+FyNyKnBJaUqY9iHHT+FqL5v2X5q8AadSQ8pETM50fasNZ
         StHFNyrrehTAtf+F7BpWlDyKGWir19KStyGnoCtuQTiLUXretXYUQd1DSGaVaE/l1kMa
         qSh2TH77eTxKH4Dqr6FBAzlnc/akG/Tf4XOT0tK6/+aIYHdMdCMkInA80RCbX6WNsM6+
         Sxxw==
X-Gm-Message-State: AOJu0YzC23WizAMDAkkkYTwHD5czv9dINO+6ntjffmpuM267xOg+5Osq
	Glw9G15eFX4Bu55mtRfdyDGyNxRS4jszt9aLYy4DUgj/oUL7X+IxS4ed0v0hKg==
X-Gm-Gg: ASbGncsVYSrz542ut4p6zsoCcwd4t1mWifzEKj2TtiZYVPy2h93X9ran3NUxKmW2RTM
	AhvjSL6EEcimswWQMY1z9pdpXJMPD0LtGbXDIO7mHokMFcbMrFLvSU1muXBFrgwveuLHFb16TjK
	ZfcddUqKg5MRv5IhO7sjtBNpnofJWKu+z66vOA7pXGpckx8LqWgFqrGZ1q5KqBTIPCSxmJnXujI
	b77PhR7ffJwU3Fzvu+wpC2VEuJ1Kby3BiaS0GnVOow+tyGejIDmT4hOaOj5g5ZbmP+PlMyO2Xlt
	XzF+P9yWL9JRFGlLneEP1UHb8USmgbZ0Qq+kVZNLSMe/2H7sOmJ/+jVmuttX5FP+UDWbVd0n2Oj
	6EZAUFBNL7LOH1k3BeHHS3BBRdnlgHZqFgcKDQcCGHIAkX6g6CRBTN4D/blGBtFo8hV4lgwECAt
	TTHwgmmKqY08OXsLRtLg==
X-Google-Smtp-Source: AGHT+IGJR9DdRiboebYLi4fUErcgaHSvWAMctHyH4ArUPs5WqzM5saYr3EdpKOoYcRI4tsvI9SbZMQ==
X-Received: by 2002:a05:6214:2428:b0:715:94ad:6add with SMTP id 6a1803df08f44-767c3772553mr208094626d6.47.1757957971936;
        Mon, 15 Sep 2025 10:39:31 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-77ef70bcc4esm29710976d6.41.2025.09.15.10.39.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Sep 2025 10:39:31 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 12/14] lpfc: Convert debugfs directory counts from atomic to unsigned int
Date: Mon, 15 Sep 2025 11:08:09 -0700
Message-Id: <20250915180811.137530-13-justintee8345@gmail.com>
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

Atomicity is not necessary for debugfs directory accounting because vport
deletion and creation is already serialized.  Creation has always been
serialized through sysfs.  Deletion is serialized via walking the
lpfc_create_vport_work_array and calling fc_vport_terminate one-by-one for
each NPIV port.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Closes: https://lore.kernel.org/linux-fsdevel/20250702212917.GK3406663@ZenIV/
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h         |  2 +-
 drivers/scsi/lpfc/lpfc_debugfs.c | 18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index f0e7f7ee4760..8d9870764a8e 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1332,7 +1332,7 @@ struct lpfc_hba {
 	unsigned long last_ramp_down_time;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct dentry *hba_debugfs_root;
-	atomic_t debugfs_vport_count;
+	unsigned int debugfs_vport_count;
 
 	struct lpfc_debugfs_nvmeio_trc *nvmeio_trc;
 	atomic_t nvmeio_trc_cnt;
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index eaedbaff5a78..92b5b2dbe847 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -5752,7 +5752,7 @@ static const struct file_operations lpfc_debugfs_op_slow_ring_trc = {
 };
 
 static struct dentry *lpfc_debugfs_root = NULL;
-static atomic_t lpfc_debugfs_hba_count;
+static unsigned int lpfc_debugfs_hba_count;
 
 /*
  * File operations for the iDiag debugfs
@@ -6074,7 +6074,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 	/* Setup lpfc root directory */
 	if (!lpfc_debugfs_root) {
 		lpfc_debugfs_root = debugfs_create_dir("lpfc", NULL);
-		atomic_set(&lpfc_debugfs_hba_count, 0);
+		lpfc_debugfs_hba_count = 0;
 		if (IS_ERR(lpfc_debugfs_root)) {
 			lpfc_vlog_msg(vport, KERN_WARNING, LOG_INIT,
 				      "0527 Cannot create debugfs lpfc\n");
@@ -6090,13 +6090,13 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 		pport_setup = true;
 		phba->hba_debugfs_root =
 			debugfs_create_dir(name, lpfc_debugfs_root);
-		atomic_set(&phba->debugfs_vport_count, 0);
+		phba->debugfs_vport_count = 0;
 		if (IS_ERR(phba->hba_debugfs_root)) {
 			lpfc_vlog_msg(vport, KERN_WARNING, LOG_INIT,
 				      "0528 Cannot create debugfs %s\n", name);
 			return;
 		}
-		atomic_inc(&lpfc_debugfs_hba_count);
+		lpfc_debugfs_hba_count++;
 
 		/* Multi-XRI pools */
 		debugfs_create_file("multixripools", 0644,
@@ -6268,7 +6268,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				      "0529 Cannot create debugfs %s\n", name);
 			return;
 		}
-		atomic_inc(&phba->debugfs_vport_count);
+		phba->debugfs_vport_count++;
 	}
 
 	if (lpfc_debugfs_max_disc_trc) {
@@ -6402,10 +6402,10 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 	if (vport->vport_debugfs_root) {
 		debugfs_remove(vport->vport_debugfs_root); /* vportX */
 		vport->vport_debugfs_root = NULL;
-		atomic_dec(&phba->debugfs_vport_count);
+		phba->debugfs_vport_count--;
 	}
 
-	if (atomic_read(&phba->debugfs_vport_count) == 0) {
+	if (!phba->debugfs_vport_count) {
 		kfree(phba->slow_ring_trc);
 		phba->slow_ring_trc = NULL;
 
@@ -6415,10 +6415,10 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 		if (phba->hba_debugfs_root) {
 			debugfs_remove(phba->hba_debugfs_root); /* fnX */
 			phba->hba_debugfs_root = NULL;
-			atomic_dec(&lpfc_debugfs_hba_count);
+			lpfc_debugfs_hba_count--;
 		}
 
-		if (atomic_read(&lpfc_debugfs_hba_count) == 0) {
+		if (!lpfc_debugfs_hba_count) {
 			debugfs_remove(lpfc_debugfs_root); /* lpfc */
 			lpfc_debugfs_root = NULL;
 		}
-- 
2.38.0

