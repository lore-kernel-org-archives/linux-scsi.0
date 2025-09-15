Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2978128C864
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 17:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757957959; cv=none; b=YrSMboC/Tfku5mL1Lz38c3TGgTwxfd0Z4r0oV5wgv7oTu0fyFrXaZlIRcg66wCFhurYleCrMkTODT0aEXipU/tpGVAXlQsde+uPIoDzWMcnMQBJ5aiL6OYHIsrD/PszK2R0bJMETg3tbnagvyc4g80E9bPGhIXBa/u5CdmLw1Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757957959; c=relaxed/simple;
	bh=Tuetr4dxMKg3WMWJ/alvGtwf25JOwfNX63ZdRc8c+ag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rfYlW5RZV250hMFmh85ly6NW/o81L61ym2YsWH50mxookeG893ZlwoIdk2W7SRmdj5/ZtRUsbsNPjESPBSVpqx4P7ilvKyCrWsvIWjBXX3IV7Devrs99s9xnkuY82gcNhGgAo4JkPtz1qrzrdIJiRqnRUO9QpV0lXlXu1P8fZd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZwaBvTFt; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZwaBvTFt"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-78393b448a1so11047556d6.3
        for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 10:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757957957; x=1758562757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ftqNjvVq0e86jxls07hJfufWxJrHyT0QLleITiRmxBo=;
        b=ZwaBvTFtvkLcZOlT6SmQcmOHM2t1fPHyA79s68Q7MfypLsJA0Qn//W/8ChWl7VyK30
         JBd3VgqG18tzILnpf/vUSDvHS/huSMusebE2acr+3hbDpBwDaqucfbrWggd88s8QORNc
         QFPYwgWo/X9oo1XsDr40VDkIv2K3x31ufc3qemrmrFDgHFCTRmBhJ+OQ8arA4NsDryNr
         3KahnPLL9V+rClAWEjXYS/ZMfPUsJ5a/O0QsyYC5sF76SedjoHOTQRG63xJAe898vkHI
         qcW16dErlPwkRnpvEfYqaUAPwhIO11E+UL3YmC/Rh/ev1MWTLhQGwMPaXo13GqYi4HSZ
         7wtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757957957; x=1758562757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ftqNjvVq0e86jxls07hJfufWxJrHyT0QLleITiRmxBo=;
        b=sKB+XUV1fMkFE6bUNu0zfoXa14Ub5kz98KiYBxs+2giPsRpa/BQFmD0QxtmFtTjQ0t
         wo3fIvrBLOmN0NkgZshXBvGp2NILzblpb6G0vgYo0nAzmb/+uyy3iSMbWyBoTXzV5omP
         UHxGBnfBrQ0kvButpF3EUaKRwR97v4KZ0T/sBQEawWk5EhJnjQYuBfXhHEN5rdv/SAkz
         7dVrsbEU8m/oRFMv6WaXUmFe46E3TuFgDOyH8SNbWyapVkzt1ZKAU1/NU+Z/2ofVULJI
         DZFvNChOGzZsl/QB5MM+Y/MFC9O45EfV9XmUgOUD+pEOBHNPr975AmSuOqzi0DsXQfIJ
         Xywg==
X-Gm-Message-State: AOJu0Yw0m2OHMHXxDG+oEn0XOAUFlGDrxYNUuUHtexn8aAUUYVKFxdrM
	8XReh3a0ipHRRFY1nn/v7Bp1dhw9un7N5E/yrjXWwt8tO7j6V0udNv5qushiuQ==
X-Gm-Gg: ASbGncvw0KNBVbzen2PvvHAF2rgs4fp20tFRMa4eNWBeLrNQL7zNlJX2JSqvKsHDSn8
	Gqx7K5giM0PYtxe/FJ+tgU4N2fzlI19N84QE1t8tpOYxAqblRfheDCIDywCpROmeDtd+3OdAa98
	5iL2zgmU6YY0Kg/r2c2BocJTxjh5Lfu+YdxXN+QptgbOPO4yVVp0ogkINPHR+7KFxRCad6PlhcX
	3Ums1pG8mzPWInNbw70mgdD2qz0/HzQ4EwZ1iJfu3Q3NcOEGbhsUWTPiZb4pN5wYWSgMMUmnAQY
	zmzEcjbzhLIRGwI2icmb9rAs1Vzs7SYa1+DZnK3e+iDMeyrQEYnPsn9x17afF1AzUD1rbYES5K9
	JxxN8X8ndRg4sK6puBO+KkCVFt8MNn2EapFNxoWLoUAL9F1iP1ajeQsjN/xSliLPBpZ2A5afuXJ
	T6WdMcRxk=
X-Google-Smtp-Source: AGHT+IE8ymk9mMcwbulH4VHWWbsGQfhPbySAi4gTIeowjy1ov7iSGG+8uxyQ6JgC8mZ/OQ1l7fbu3A==
X-Received: by 2002:a05:6214:21e4:b0:755:33b:93c3 with SMTP id 6a1803df08f44-767bd944e83mr157146646d6.20.1757957956686;
        Mon, 15 Sep 2025 10:39:16 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-77ef70bcc4esm29710976d6.41.2025.09.15.10.39.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Sep 2025 10:39:16 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 04/14] lpfc: Remove ndlp kref decrement clause for F_Port_Ctrl in lpfc_cleanup
Date: Mon, 15 Sep 2025 11:08:01 -0700
Message-Id: <20250915180811.137530-5-justintee8345@gmail.com>
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

In lpfc_cleanup, there is an extraneous nlp_put for NPIV ports on the
F_Port_Ctrl ndlp object.  In cases when an ABTS is issued, the outstanding
kref is needed for when a second XRI_ABORTED CQE is received.  The final
kref for the ndlp is designed to be decremented in
lpfc_sli4_els_xri_aborted instead.  Also, add a new log message to allow
for future diagnostics when debugging related issues.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c  | 6 +++++-
 drivers/scsi/lpfc/lpfc_init.c | 7 -------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 432761fb49de..38b8c30d33b8 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -12008,7 +12008,11 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hba *phba,
 			sglq_entry->state = SGL_FREED;
 			spin_unlock_irqrestore(&phba->sli4_hba.sgl_list_lock,
 					       iflag);
-
+			lpfc_printf_log(phba, KERN_INFO, LOG_ELS | LOG_SLI |
+					LOG_DISCOVERY | LOG_NODE,
+					"0732 ELS XRI ABORT on Node: ndlp=x%px "
+					"xri=x%x\n",
+					ndlp, xri);
 			if (ndlp) {
 				lpfc_set_rrq_active(phba, ndlp,
 					sglq_entry->sli4_lxritag,
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ad8a85c65bfd..0ca7429d86b8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3057,13 +3057,6 @@ lpfc_cleanup(struct lpfc_vport *vport)
 		lpfc_vmid_vport_cleanup(vport);
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		if (vport->port_type != LPFC_PHYSICAL_PORT &&
-		    ndlp->nlp_DID == Fabric_DID) {
-			/* Just free up ndlp with Fabric_DID for vports */
-			lpfc_nlp_put(ndlp);
-			continue;
-		}
-
 		if (ndlp->nlp_DID == Fabric_Cntl_DID &&
 		    ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
 			lpfc_nlp_put(ndlp);
-- 
2.38.0

