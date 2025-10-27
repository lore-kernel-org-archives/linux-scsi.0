Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9D432E73D
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 23:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761607454; cv=none; b=kxn4/yZlFFs5gYwLumMP/WBR4bXFgmvMdABKfv4SIj3vyx6kqlRiMoHwx/SgKBpaAuqNSLMnZCJzUzoAxFtRtpyM4zmqHBhh9SFMbioq8bS3kzcoj5OoW0jTY/I6sN92zIHeAPHmiTuKIk4AEjmPR/NjOGS+cJBTDJYClpfj4q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761607454; c=relaxed/simple;
	bh=KXVJbo41goHfvwhGfVEk+C2zaQVURcmGyX9I45jUgVI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B94GWF+cKckvupRyt2GodMkMo/VBm0rdXJTEJDFaQuPhgO231tv9pAzz1BaXlfpNeio6E4pcE8fssLnnzNe/OKd8IXpb19mlXxGeDXvEbgiF2gyTC7LnA+d1LXtItahV+Kj8yLU5tGkZrrjVNKITCNoevs+2WuSY6ORk44i+IA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OCmaglWD; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OCmaglWD"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-27ee41e0798so75293965ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 16:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761607452; x=1762212252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uh7baQSZtdXTRl0comSTmI35q2gikLPsNz3l41MUlXs=;
        b=OCmaglWD9LfDgvKlbq1V1IMt2Qz6MVndcrQ8HW2SkNOLuMEOwoSCG4hH9dZAe51rXc
         KnHtOfgb4YgCpsC6p70B1j9Ic8Sp4R83HWH5J8SGrRtsvLSrEXEbD5ZAs/iUmXzQ5r1q
         x4Pk2pykNic1yinUjr7q/z13W59QOHhPZfJlpJ6U4AvnZR6CcIi6RqbtlXQDAhzxgiTO
         bQg6jAe5YeMWRMuBduxyo0ltQ022esC2i2B5GRJ83RxwGRYziCLpc0mGtTTUtpt3DsSt
         i9sFaoT02liG815LZUsGw+mui4EIuDoEHoid6/Gw03Zd4UK0gxEJUVqhW5CHGWjqHykr
         a/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761607452; x=1762212252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uh7baQSZtdXTRl0comSTmI35q2gikLPsNz3l41MUlXs=;
        b=EUpvoNxpcLVDFBnSRNVfE0G0RIOTeG3dM3sNBKOSlRNFdVssSHjnZUdu5rMbKd73N8
         VigIFx4j+6U8dEWsgjuG5LZog/oJPPFKaLZdGb92gYRAzj6HdXR51C3a1Euemm38ZeNa
         a0ONKWncVZz7W74LoPec9bqpM/ncMhQtUhYdcq4OKutuVFBEEKEOCF/GqM0fsdWbgyf+
         ZJCRrLdXzzbCce8HNoAWPedpuI1W66aBE2CMeqM4EfSc8sLBnrQz/my61NOrZKnP1qIt
         cvZ6vGe6ywtdGkX9rF6Oa2X5e2VFHtIszuooTmB+wYvei7DvMtbhx0jIfag+ez/sbzgU
         6+7Q==
X-Gm-Message-State: AOJu0Yxxv1R1lI8uFyuATeAzjLPJP88uk5/8nmD7EDL7soTKfASfropd
	ou5qxAqak2xdYvUoYmvMUXMDt/Qa1CC7DzPC2RPc8uwBfoapztHcJHqU8iRwmg==
X-Gm-Gg: ASbGnct7MsGFdjjPAV0kDI3D8xllEbhupTv4IUK5GsM8S8PmF6PoTotbSlRG8mcJ6vP
	/PZ5DlAxLaoCHpZFEkcjcM9uv/mYL6TEM94bu/su1E4FI6GxHeWXSW0Vtvt1gv0q7IHxORpjy6q
	TOlIcLvwS6NbhH0RmIgNt8kKKk4+uvenTEy3mPrgU1ji7ZVKi55GtQNQi5uKj9+rzDp6k2bZy9H
	GOgWF/4rv9uF6L1m13QB1rJhy8bS3d1rEO8GXffr+nHsoiEQ/1wttND1i+PfQCwTRZZJjLMNwCH
	+LFTZBsPA4Xt5ooRg4l0PlxxrGhe3sA9hiezfWaAKLhUQp+HHBsYO9jSH8i8Zv6YXEx+ruceSMr
	nSsq+WqG3+JLPT5fut9IrG8P8iMo2mLM5kFA4fIwtGXgRDc44GannNXy6ZWCMborARVFwR4xdMo
	fl0EpuQTTPnTn8aOPqsRIGbiAcp0sobIRL8+Wz5RM3nZjbWhV2oeoM+mPXaEwe
X-Google-Smtp-Source: AGHT+IFq2gLIIxb2TtPXeKNnhhQse7dBHw799Io8cbslA5vBnogBA7YY/CdW/efb2RoZVA595Q36Zg==
X-Received: by 2002:a17:902:da85:b0:282:eea8:764d with SMTP id d9443c01a7336-294cb525816mr17347005ad.35.1761607451809;
        Mon, 27 Oct 2025 16:24:11 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498e41159sm93805855ad.91.2025.10.27.16.24.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Oct 2025 16:24:11 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 01/11] lpfc: Update various NPIV diagnostic log messaging
Date: Mon, 27 Oct 2025 16:54:36 -0700
Message-Id: <20251027235446.77200-2-justintee8345@gmail.com>
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

Update PRLI status log message to automatically warn when CQE status is
non-zero.

When issuing an RSCN, log ndlp's kref count to the debugfs trace buffer.

Add the NPIV virtual port index to the FDMI registration log message with
the fabric.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c  | 6 +++---
 drivers/scsi/lpfc/lpfc_init.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b71db7d7d747..f7c6758557c8 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2367,7 +2367,7 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			mode = KERN_INFO;
 
 		/* Warn PRLI status */
-		lpfc_printf_vlog(vport, mode, LOG_ELS,
+		lpfc_vlog_msg(vport, mode, LOG_ELS,
 				 "2754 PRLI DID:%06X Status:x%x/x%x, "
 				 "data: x%x x%x x%lx\n",
 				 ndlp->nlp_DID, ulp_status,
@@ -3597,8 +3597,8 @@ lpfc_issue_els_rscn(struct lpfc_vport *vport, uint8_t retry)
 	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
-			      "Issue RSCN:       did:x%x",
-			      ndlp->nlp_DID, 0, 0);
+			      "Issue RSCN:   did:x%x refcnt %d",
+			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f206267d9ecd..34386b7c0b48 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -9082,9 +9082,9 @@ lpfc_setup_fdmi_mask(struct lpfc_vport *vport)
 			vport->fdmi_port_mask = LPFC_FDMI2_PORT_ATTR;
 	}
 
-	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
-			"6077 Setup FDMI mask: hba x%x port x%x\n",
-			vport->fdmi_hba_mask, vport->fdmi_port_mask);
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+			 "6077 Setup FDMI mask: hba x%x port x%x\n",
+			 vport->fdmi_hba_mask, vport->fdmi_port_mask);
 }
 
 /**
-- 
2.38.0

