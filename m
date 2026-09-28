Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD704EB84B
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 17:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790618107; cv=none; b=bDDATUhDwjpQQ2XIi4fOXi25pitTlBJBe2nzkeA3pJaCSvUExt8YTM8p3RhzzwKUbelAOY+MK2E0bacfENRQ3p2QlYrrBdqxOQOn38ZvAQ/7BUVBTNeKq5fddpBkKCB9xnm6FKqxeCKmsj0JPdp1TylZexDn2WlEDwQ/QDDHduE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790618107; c=relaxed/simple;
	bh=QT+I2eAdRJd3a3bAQFwuHikgU56qY+H7uSfGPhYeEZI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L0V/ci0GA0W88LaHKhrFjoSXsbI8sNnu4/fenCZP5Jri1lntCu6BCFFrDCMRe/UISb+DEPHYriTjOvqDS5T4oH15rgc1tmNHrJd51KaaRxRuAOvimnp+9aa/EbRme9cqcmtACgvOJjdKRQ9yrL0RFYvoF2eKfAfN9jzBWiwL21A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n87UZ8z1; arc=none smtp.client-ip=74.125.229.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n87UZ8z1"
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-341fe27b718so3272196eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 10:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790618105; x=1791222905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wRbwigWca9Q6I/1tD5McXAHpGmJrrrkoKF62TCQ4OAY=;
        b=n87UZ8z18VcN1HGiUiSLpQ5LkmJFk+8Zl7G3rPyEHsr0m0ZMPIZOXAmmThEN0HLNsH
         ChGFWay2G/0yoREQ06W4HMyRKVSBszsS1OM9ovtlJkaed2mF2T8GkJ15B3UuDuE7lxBA
         TVYjeg74/Oepgi7xYwEivAvv87Gtg+MFVGQcIewe2q9XlFmvNmd3FP2tolt9HnErgtnQ
         e4V0mM52BR7feYpqSwnVRpHdqWzrByAQcOWr4PVEVPbqnJ6xtU7CbzL1Og+5Kc2EayB6
         kL20zmY388V3KNwFnxFUIcA6lg0x672zULHc0fbbTuztoCM5C1fW/XcYBpT67gJDMozT
         6vTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790618105; x=1791222905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wRbwigWca9Q6I/1tD5McXAHpGmJrrrkoKF62TCQ4OAY=;
        b=iNpAnbsEn4b+Wdtsc1hhqzYT63j1oePwwAoT/pcnuXBl4Lac6k6xBQZjvv06mqC9WD
         waYwHmc69CJiRUKzkd7E2d+S9HIl6NgXoU0Jh9m0PcI1aZO0XXRhlzvABFIntmxBtpA3
         Pwn58sX8Ij0qruEw7DRO/0DMOLlNfFXstTQccdhugk0SDcoUFuhgh+SisNb9d9pSYxcZ
         Ix19Dy5xIwrc/ZQxVlPc9+Px9s0hxiuL1TNG13fF5ndv/ArJ2IjTgkrCL2bXqrWMuLy4
         uOJzwER+yMgEM61+8DFOMF4xhGqQmS+DHagBVdHlt/nMcelGsYvRL/MmQs1x/VisG3fN
         ravw==
X-Gm-Message-State: AFq9FYKKCHUPdN4x4yG5ZUouM9cip49z+9bEIEoQgoGmZUWiQYXGI9+g
	u2n6Kchnw9rrWMrp25Sqf297K18oHPlGBaBfmHFsnLWzgWRU0M5etFADwlh9IBXA
X-Gm-Gg: AYBFou2iGEUiUuIXFBm8qV5z+oYFlCOYxY64aMWKsrqMx0X2PoVslf8RYIryhFaX4IF
	IZH2UByiaU6uV86c6T07HQbDIkE9y01Wf1tF9cCZibSOuX55GA3wrVCM1AP8RYh4TbJ7ZLpbHxP
	WAncOvQy4eoVIBZ0OMUj8mi0pvMvGjgKX4o7MZSrQ+hoyuz4vgvSlk203aXTrEDkHhXUwQYr1ve
	m8bY6Wvv1pFPlcG0riMSHtv+S9a4CCXxk7b7Q7Iyw8JjYVB+fLeVh6VYZoaJCAEH3pJC24lxpqi
	E0db8XA7uThdDwATgqfo4u8ARGzFjesYWVmWwZDXrCtszhIeBGUHhyClC5g7e9cGBsmKi+CHVTq
	ZEIQZ+ecL8L+dlCDByaRCdIxvBEbGJagO2ZZaRkLhgkWGBoumEsFRnzfh5YxAl5o+MXBMn//ZRn
	L4Q3HY+ClIPWTkOCBm8M779dPEukRwulAN4R5xKNjzvSBtiiaFwjfgZmCRjO1HyosoF6xh96sgs
	WDafIv0Wc2snmPSOQ8Fp9Zx1fJQDKUrVlE7mcuJ5UgChkUxhlp50HNPhw==
X-Received: by 2002:a05:7301:29b0:b0:343:9eb1:9940 with SMTP id 5a478bee46e88-3439eb1a517mr8396884eec.26.1790618104523;
        Mon, 28 Sep 2026 10:55:04 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-342c9c245a7sm21189418eec.11.2026.09.28.10.55.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2026 10:55:04 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v5 09/10] lpfc: Update correct ndlp refcnt when rejecting an unsolicited PLOGI
Date: Mon, 28 Sep 2026 11:17:56 -0700
Message-Id: <20260928181757.21959-10-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260928181757.21959-1-nkirkland2304@gmail.com>
References: <20260928181757.21959-1-nkirkland2304@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The domain controller FC_ID can change whenever a fabric switch with
an ISL link is replaced or the admin reconfigures the fabric switch
with active links. In such situations, reference count updates should
be applied to the correct nodelist structure.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c       | 37 ++++++++++++++++++++++--------
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  7 ++++++
 drivers/scsi/lpfc/lpfc_nportdisc.c | 14 +++++++++++
 3 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 1793d9c6d8b8..0ca1659d5d10 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5977,11 +5977,12 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
 	/* Xmit ELS RJT <err> response tag <ulpIoTag> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0129 Xmit ELS RJT x%x response tag x%x "
-			 "xri x%x, did x%x, nlp_flag x%lx, nlp_state x%x, "
-			 "rpi x%x\n",
+			 "xri x%x, ndlp x%px, did x%x, nlp_flag x%lx, "
+			 "nlp_state x%x, rpi x%x ref_cnt %d\n",
 			 rejectError, elsiocb->iotag,
-			 get_job_ulpcontext(phba, elsiocb), ndlp->nlp_DID,
-			 ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
+			 get_job_ulpcontext(phba, elsiocb), ndlp,
+			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
+			 ndlp->nlp_rpi, kref_read(&ndlp->kref));
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
 		"Issue LS_RJT:    did:x%x flg:x%lx err:x%x",
 		ndlp->nlp_DID, ndlp->nlp_flag, rejectError);
@@ -10482,6 +10483,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		      struct lpfc_vport *vport, struct lpfc_iocbq *elsiocb)
 {
 	struct lpfc_nodelist *ndlp;
+	struct lpfc_nodelist *alloc_ndlp = NULL;
 	struct ls_rjt stat;
 	u32 *payload, payload_len;
 	u32 cmd = 0, did = 0, newnode, status = 0;
@@ -10580,7 +10582,9 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			did, vport->port_state, ndlp->nlp_flag);
 
 		phba->fc_stat.elsRcvPLOGI++;
+		alloc_ndlp = ndlp;
 		ndlp = lpfc_plogi_confirm_nport(phba, payload, ndlp);
+
 		if (phba->sli_rev == LPFC_SLI_REV4 &&
 		    test_bit(FC_PT2PT, &phba->pport->fc_flag)) {
 			vport->fc_prevDID = vport->fc_myDID;
@@ -10896,13 +10900,28 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		stat.un.b.lsRjtRsnCodeExp = rjt_exp;
 		lpfc_els_rsp_reject(vport, stat.un.lsRjtError, elsiocb, ndlp,
 				    NULL);
-		/* Remove the reference from above for new nodes. */
-		if (newnode)
-			lpfc_disc_state_machine(vport, ndlp, NULL,
-					NLP_EVT_DEVICE_RM);
+
+		/* Remove the safety reference from routine start. */
+		if (newnode) {
+			/* alloc_ndlp is assigned for an unsolicited PLOGI from
+			 * the ndlp allocated by this routine. The routine
+			 * lpfc_plogi_confirm_nport may have swapped the initial
+			 * ndlp to an existing ndlp. In that case, alloc_ndlp
+			 * is the pre-swap ndlp that needs a DEVICE_RM because
+			 * it is the newnode. For all other paths to lsrjt
+			 * (non-PLOGI ELS) that were rejected by the early
+			 * port_state check, alloc_ndlp is NULL and ndlp is
+			 * still the originally allocated node.
+			 */
+			lpfc_disc_state_machine(vport,
+						alloc_ndlp ? alloc_ndlp : ndlp,
+						NULL, NLP_EVT_DEVICE_RM);
+		}
 	}
 
-	/* Release the reference on this elsiocb, not the ndlp. */
+	/* This elsiocb is not the IOCB issued for a response. Remove
+	 * the safety reference allocated earlier.
+	 */
 	lpfc_nlp_put(elsiocb->ndlp);
 	elsiocb->ndlp = NULL;
 
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 83e29eed14fa..6665c3e5b62d 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4978,6 +4978,13 @@ lpfc_drop_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	 */
 	if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 		return;
+
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE | LOG_ELS | LOG_DISCOVERY,
+			"3421 Mark ndlp x%px Dropped. DID x%06x, nflags x%lx "
+			"xflags x%x ref_cnt %d\n",
+			 ndlp, ndlp->nlp_DID, ndlp->nlp_flag,
+			 ndlp->fc4_xpt_flags, kref_read(&ndlp->kref));
+
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNUSED_NODE);
 	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
 		lpfc_cleanup_vports_rrqs(vport, ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index f917a5bcfd02..ffec352c8ab2 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -2878,6 +2878,20 @@ lpfc_device_rm_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		set_bit(NLP_NODEV_REMOVE, &ndlp->nlp_flag);
 		return ndlp->nlp_state;
 	}
+
+	/* It is an error to drop a node while either of its transport
+	 * registrations have not completed.
+	 */
+	if (ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) {
+		lpfc_printf_vlog(vport, KERN_WARNING,
+				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
+				 "3423 Not dropping ndlp x%px, DID x%x xflags x%x "
+				 "with dev_loss pending. ref_cnt %d\n",
+				 ndlp, ndlp->nlp_DID, ndlp->fc4_xpt_flags,
+				 kref_read(&ndlp->kref));
+		return ndlp->nlp_state;
+	}
+
 	lpfc_drop_node(vport, ndlp);
 	return NLP_STE_FREED_NODE;
 }
-- 
2.38.0

