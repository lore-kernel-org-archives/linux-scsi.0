Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CC732F742
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 23:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761607462; cv=none; b=YrSNQazIJtxpPQuCvp1MLJz4CV44jscpxuprIaKJEKAVYxVW7PwFxBeFQivAZDS7qs4WT9z6utSEnJ3WQXEC5VUe/9uhKhyWyEjbf5wJ33teS0RcKDoZjN/0rxOBNKPclEpE66NYAc90zdp8qW21/u4TBCFH0SbGLTdvDGbuLnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761607462; c=relaxed/simple;
	bh=7gUQL1XAiGDY8FHOOgca6smZXlQ/zYawsIwDknYmGvk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IMraFpVJPIOkSeEntjpEpbFmYyppAq8ZyMRJxErO66kNjbJvM23BATaMjopDF03FRzu+uGxC4Oaf+Hr+oP/87qivvFBYIcT6qRbKyBwhRxHArRyIYuhQjfRcFS9E8QGzsu70M6VP8yOJt46uaSA2kqFezv+B6qODqxqdxLVdUG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RUulW3m6; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RUulW3m6"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-27d3540a43fso54311785ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 16:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761607460; x=1762212260; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2mIGrJY+5f7gYneGGG0UQowS0yColVpQn7ZPXIqxI9I=;
        b=RUulW3m6b5UPWJcLHc+goD7eIpaRL3dCTpj0KaBM0Bx2rKuLbkRbFQBXcD9MxVJA9d
         F4hOZ9Mhlln/bgo5Exyog8riCCa4yDjOEQG3M0uQWFtrISbW4xjeCWtugeMMd59EukOk
         fvFxMaTVzOm2rriePKmyK0/IKR0ODCdgW9H8AMFEoEMHwiEOhwOWB/0BJq+4B1jFpx+/
         uxxMOrb5NFhrA+7UwMlHevgwh9uAXZPM5lEnpT5pQFRg//SFX2xlCdALPEKgUFvq2WRy
         N4SQINg9d4wXdePN38oHmSpXBE0H4JVo2oZoKIrp2UIqiyNZif0Oi3QpIKBU3wSxv7pW
         u3AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761607460; x=1762212260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2mIGrJY+5f7gYneGGG0UQowS0yColVpQn7ZPXIqxI9I=;
        b=jFlVFTM2p+z8x+BJWHCT41YBk0qREXZklC6amUAa9w3egegSR9h/UKC2YhGkU/02/6
         j5+n2kWPue3Yp9lE/lMixeBzSauNfVFp0u8EqYehH23br3j4MU9z60VYosVvX4lHtiGT
         xqAyYN3XeGx/rPiMegdqPVM3t/pSOvCus9PdjGpeDjcKJa7H2PVHoUutIeILXwUXer53
         FM3P+v6Ey9LUu10Wl+vnjI6kPc3d4IWbqCQFpXFKx0LpZmCXnzBghgmKERtYW6SXIEM/
         P7IIYeQlYHfx0/gVGFXnL2jfI7W6ebo/opbtODxTxS6OtE6HwIvf9xEN6QdMphBK7hEX
         hlVQ==
X-Gm-Message-State: AOJu0YyZUrmEX0XE4QtuU6YLee8t+MumAUaRpiEWKSyFipE+uZiLnMPj
	m4vquJAsAw6eE4sSIM03BQjapsozXZOXmBiLSsL2ciaqkQllXJrR4CPZ20bt1w==
X-Gm-Gg: ASbGnctGdadTNo1adBqelOZ41Z+nG7v/EaM89z/k6JRWtiWNrUrii56pjcYv+04wEN8
	JJ4LK14BsYFUj20mTCM5Vcf2M3nXyOlAfZlzIc8t+gdAxaliooOztFGte816KHW4yEg60pVbyWe
	UeY0l+xiwavNO6eeV/U/kDZhblLEy/vsVRuVtpNDzsYa68vYSxRni79jhSwCCL1odDgb6Lklubi
	rs1l/pGoIIOjEZVNlrHPitFW/KFc4b1/nHm4hcymZxogj5MfMjYw8S4f4BTz2kvhm8/Zf5K8Fbu
	rFXX4IOZBF9DpiYYszyVt+m9x99w2a6c926hVl8SNbrDRlfntXk4B1fgcPKA8jXC9touBYn5UUc
	I1BKD9A5UUL7UVWpAxr+oyExnzhDNJP/xlU+oCrYe0Bf0I/z+T6BVqWYzckfpxoqE7hPxqQu+fO
	C7aQeO8ZA3p9s2U5lLGsBBtatw8KNOu0BVhRvD+8K5WywNWwtW8GjLEUv5fYaV2AHVt7yuWo0=
X-Google-Smtp-Source: AGHT+IE5qGaeX6Mw3xGp+oKI7rAsnivSS69y7/AEal0S9Fo4PwugtbsM7iVVFCqctrJDXIUjd8iGag==
X-Received: by 2002:a17:902:cecb:b0:26d:72f8:8d0a with SMTP id d9443c01a7336-294cb368bd0mr17099025ad.12.1761607460329;
        Mon, 27 Oct 2025 16:24:20 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498e41159sm93805855ad.91.2025.10.27.16.24.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Oct 2025 16:24:19 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 07/11] lpfc: Fix reusing an ndlp that is marked NLP_DROPPED during FLOGI
Date: Mon, 27 Oct 2025 16:54:42 -0700
Message-Id: <20251027235446.77200-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251027235446.77200-1-justintee8345@gmail.com>
References: <20251027235446.77200-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's possible for an unstable link to repeatedly bounce allowing a FLOGI
retry, but then bounce again forcing an abort of the FLOGI.  Ensure that
the initial reference count on the FLOGI ndlp is restored in this faulty
link scenario.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c     | 36 +++++++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_hbadisc.c |  4 +++-
 2 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 00cfd4ac4ccd..0045c1e29619 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -934,10 +934,15 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* Check to see if link went down during discovery */
 	if (lpfc_els_chk_latt(vport)) {
 		/* One additional decrement on node reference count to
-		 * trigger the release of the node
+		 * trigger the release of the node.  Make sure the ndlp
+		 * is marked NLP_DROPPED.
 		 */
-		if (!(ndlp->fc4_xpt_flags & SCSI_XPT_REGD))
+		if (!test_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag) &&
+		    !test_bit(NLP_DROPPED, &ndlp->nlp_flag) &&
+		    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD)) {
+			set_bit(NLP_DROPPED, &ndlp->nlp_flag);
 			lpfc_nlp_put(ndlp);
+		}
 		goto out;
 	}
 
@@ -995,9 +1000,10 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					IOERR_LOOP_OPEN_FAILURE)))
 			lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
 				      "2858 FLOGI Status:x%x/x%x TMO"
-				      ":x%x Data x%lx x%x\n",
+				      ":x%x Data x%lx x%x x%lx x%x\n",
 				      ulp_status, ulp_word4, tmo,
-				      phba->hba_flag, phba->fcf.fcf_flag);
+				      phba->hba_flag, phba->fcf.fcf_flag,
+				      ndlp->nlp_flag, ndlp->fc4_xpt_flags);
 
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
@@ -1015,14 +1021,17 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		 * reference to trigger node release.
 		 */
 		if (!test_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag) &&
-		    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD))
+		    !test_bit(NLP_DROPPED, &ndlp->nlp_flag) &&
+		    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD)) {
+			set_bit(NLP_DROPPED, &ndlp->nlp_flag);
 			lpfc_nlp_put(ndlp);
+		}
 
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
 				 "0150 FLOGI Status:x%x/x%x "
-				 "xri x%x TMO:x%x refcnt %d\n",
+				 "xri x%x iotag x%x TMO:x%x refcnt %d\n",
 				 ulp_status, ulp_word4, cmdiocb->sli4_xritag,
-				 tmo, kref_read(&ndlp->kref));
+				 cmdiocb->iotag, tmo, kref_read(&ndlp->kref));
 
 		/* If this is not a loop open failure, bail out */
 		if (!(ulp_status == IOSTAT_LOCAL_REJECT &&
@@ -1279,6 +1288,19 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	uint32_t tmo, did;
 	int rc;
 
+	/* It's possible for lpfc to reissue a FLOGI on an ndlp that is marked
+	 * NLP_DROPPED.  This happens when the FLOGI completed with the XB bit
+	 * set causing lpfc to reference the ndlp until the XRI_ABORTED CQE is
+	 * issued. The time window for the XRI_ABORTED CQE can be as much as
+	 * 2*2*RA_TOV allowing for ndlp reuse of this type when the link is
+	 * cycling quickly.  When true, restore the initial reference and remove
+	 * the NLP_DROPPED flag as lpfc is retrying.
+	 */
+	if (test_and_clear_bit(NLP_DROPPED, &ndlp->nlp_flag)) {
+		if (!lpfc_nlp_get(ndlp))
+			return 1;
+	}
+
 	cmdsize = (sizeof(uint32_t) + sizeof(struct serv_parm));
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_FLOGI);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 43d246c5c049..717ae56c8e4b 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -424,6 +424,7 @@ lpfc_check_nlp_post_devloss(struct lpfc_vport *vport,
 			    struct lpfc_nodelist *ndlp)
 {
 	if (test_and_clear_bit(NLP_IN_RECOV_POST_DEV_LOSS, &ndlp->save_flags)) {
+		clear_bit(NLP_DROPPED, &ndlp->nlp_flag);
 		lpfc_nlp_get(ndlp);
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY | LOG_NODE,
 				 "8438 Devloss timeout reversed on DID x%x "
@@ -566,7 +567,8 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 			return fcf_inuse;
 		}
 
-		lpfc_nlp_put(ndlp);
+		if (!test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
+			lpfc_nlp_put(ndlp);
 		return fcf_inuse;
 	}
 
-- 
2.38.0

