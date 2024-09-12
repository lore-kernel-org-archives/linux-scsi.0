Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF39318891D
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 23:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726182612; cv=none; b=PRr5agEUcVQPSR2fBaio6EqDEkSRFJ+ov+eQVyYMytGQ9OgtsMkuEE9URime+L8DIPXhvfQz5FjyLmiZmkM+QYUbwO5bvDKT5qA3VCGpwuGlqMwqJ219fp7loSfKcZ8FFYZscGuEkJEwnx+7RWrWyTFEeYFCdfv8t/lnNNaZvdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726182612; c=relaxed/simple;
	bh=nE4k60CmuQyDPVZ3PtNsJ1THBUyCGg7Y2PlYLX8EG7Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gsqcdFYz18JvRRCES6Dy4pwure+Qlei7/e/772sf9xMQcOONtQUgfruk63DiKOVYaeY54zFBgjEVM6alka/MgeLyLSsMTBHe6xvAWbi7e3Ai62PwBggR/0dhmMsmo3RajbHxCwC7s9YnqQCvJGJzNgiJcVMQsRoPTZ/WQLl2Uno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l0IBf+2a; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l0IBf+2a"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6c54a5fbceeso2408106d6.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 16:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726182608; x=1726787408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YeSPXDPCK8PcJNpcvq5gGn4zSb8CWor6gd7+J/tuRIE=;
        b=l0IBf+2a5Ba6UdaX73zLOcbn2+U7vVs35Kp8dIPCt/BJdSkIqyphdkoXLoCM+wMb37
         PxmE3SPco/sdmMECRrF3RogejKiodvJevVq0yXUgjh9RptgB6+ZAuriuEPdZ1K97m+Qb
         3zfeUY1ZcaN6qXMYKAokW7nArCesKIFSadIQTZ2xfoC212LA2IWNSD0HZsdxhbnnLEmE
         jwvkt70fOU5sqD/77BSD5xODtXyzjhCuDRLSzMV633s9pjyRxfztl8x3EmQ6H+9pPTyk
         urfxySz3c2R1+UN+K3o9CwxsEt6OYXuTNidgACpPW+ledCALQf4hVT5/LxWlZtoKwYYc
         spHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726182608; x=1726787408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YeSPXDPCK8PcJNpcvq5gGn4zSb8CWor6gd7+J/tuRIE=;
        b=OZdJrzpAsay/QGrVS7NiiyFSqT2Di8r9OqJSZUe4NeMU6140Awq6JA+QNaHoj9dPtI
         8U6jWrevM+QnJRH9C/jNSNXPbPzSJVEMFX29iktFNszD8tUjbozHQjs6My1nyjgV+IGr
         az3EWFndQMR0WHeSfqYvwg+D7JlJay1MSjafhQvVBNgEcwWTdHQ1Q+z1IMxRwM+7Xx3q
         B4etKaXVyqgwYecDBNI8XMd1X1F5O3UYHxNA+pI5b1IP3FVl0pco02fbI02nhSuu+Uf3
         qIcy6ox5CWW9IBNHjRpQ+cLHsb6hBzwAOqmkFdfvaV0W+Mkk0pBfVIxcmMvhhtpmrr4v
         ehPQ==
X-Gm-Message-State: AOJu0YzENzAH6M88fPwexcdx+eHvViLnBgA+ySdDtJZfnMBjP9C0yULC
	SPZOADDlfIbKI090PFekyeuW/BDo2ExrKUeLf4znDlAOhaLFSRDoouuFjw==
X-Google-Smtp-Source: AGHT+IFwfHdfqWKOKPvLL0nWEmJF5Qxpz7ZTaDiYrECW19DIhT89hKTvj3eR0/ZQEQaA4q8N++Dgkg==
X-Received: by 2002:a05:6214:2f0f:b0:6c5:55bc:2705 with SMTP id 6a1803df08f44-6c57df773a1mr15394756d6.6.1726182608549;
        Thu, 12 Sep 2024 16:10:08 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c534339a88sm59363136d6.50.2024.09.12.16.10.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2024 16:10:08 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 7/8] lpfc: Support loopback tests with VMID enabled
Date: Thu, 12 Sep 2024 16:24:46 -0700
Message-Id: <20240912232447.45607-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240912232447.45607-1-justintee8345@gmail.com>
References: <20240912232447.45607-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The VMID feature adds an extra application services header to each frame.
As such, the loopback test path is updated to accommodate the extra
application header.

Changes include filling in APPID and WQES bit fields for XMIT_SEQUENCE64
commands, a special loopback source APPID for verifying received loopback
data matches what is sent, and increasing ELS WQ size to accommodate the
APPID field in loopback test mode.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c  |  3 +++
 drivers/scsi/lpfc/lpfc_hw.h   | 21 +++++++++++++++++++
 drivers/scsi/lpfc/lpfc_init.c | 11 ++++++++--
 drivers/scsi/lpfc/lpfc_sli.c  | 39 +++++++++++++++++++++++++++++++++--
 4 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 4156419c52c7..8738c1b0e388 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -3208,6 +3208,9 @@ lpfc_bsg_diag_loopback_run(struct bsg_job *job)
 	cmdiocbq->num_bdes = num_bde;
 	cmdiocbq->cmd_flag |= LPFC_IO_LIBDFC;
 	cmdiocbq->cmd_flag |= LPFC_IO_LOOPBACK;
+	if (phba->cfg_vmid_app_header)
+		cmdiocbq->cmd_flag |= LPFC_IO_VMID;
+
 	cmdiocbq->vport = phba->pport;
 	cmdiocbq->cmd_cmpl = NULL;
 	cmdiocbq->bpl_dmabuf = txbmp;
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 2108b4cb7815..d5c15742f7f2 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -561,6 +561,27 @@ struct fc_vft_header {
 
 #include <uapi/scsi/fc/fc_els.h>
 
+/*
+ * Application Header
+ */
+struct fc_app_header {
+	uint32_t dst_app_id;
+	uint32_t src_app_id;
+#define LOOPBACK_SRC_APPID	0x4321
+	uint32_t word2;
+	uint32_t word3;
+};
+
+/*
+ * dfctl optional header definition
+ */
+enum lpfc_fc_dfctl {
+	LPFC_FC_NO_DEVICE_HEADER,
+	LPFC_FC_16B_DEVICE_HEADER,
+	LPFC_FC_32B_DEVICE_HEADER,
+	LPFC_FC_64B_DEVICE_HEADER,
+};
+
 /*
  *  Extended Link Service LS_COMMAND codes (Payload Word 0)
  */
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0c1404dc5f3b..48a3dfdd51d3 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -10451,6 +10451,7 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 	struct lpfc_vector_map_info *cpup;
 	struct lpfc_vector_map_info *eqcpup;
 	struct lpfc_eq_intr_info *eqi;
+	u32 wqesize;
 
 	/*
 	 * Create HBA Record arrays.
@@ -10670,9 +10671,15 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 	 * Create ELS Work Queues
 	 */
 
-	/* Create slow-path ELS Work Queue */
+	/*
+	 * Create slow-path ELS Work Queue.
+	 * Increase the ELS WQ size when WQEs contain an embedded cdb
+	 */
+	wqesize = (phba->fcp_embed_io) ?
+			LPFC_WQE128_SIZE : phba->sli4_hba.wq_esize;
+
 	qdesc = lpfc_sli4_queue_alloc(phba, LPFC_DEFAULT_PAGE_SIZE,
-				      phba->sli4_hba.wq_esize,
+				      wqesize,
 				      phba->sli4_hba.wq_ecount, cpu);
 	if (!qdesc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index bb5fd3322273..a44afb84cd3d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11093,9 +11093,17 @@ __lpfc_sli_prep_xmit_seq64_s4(struct lpfc_iocbq *cmdiocbq,
 	/* Word 9 */
 	bf_set(wqe_rcvoxid, &wqe->xmit_sequence.wqe_com, ox_id);
 
-	/* Word 12 */
-	if (cmdiocbq->cmd_flag & (LPFC_IO_LIBDFC | LPFC_IO_LOOPBACK))
+	if (cmdiocbq->cmd_flag & (LPFC_IO_LIBDFC | LPFC_IO_LOOPBACK)) {
+		/* Word 10 */
+		if (cmdiocbq->cmd_flag & LPFC_IO_VMID) {
+			bf_set(wqe_appid, &wqe->xmit_sequence.wqe_com, 1);
+			bf_set(wqe_wqes, &wqe->xmit_sequence.wqe_com, 1);
+			wqe->words[31] = LOOPBACK_SRC_APPID;
+		}
+
+		/* Word 12 */
 		wqe->xmit_sequence.xmit_len = full_size;
+	}
 	else
 		wqe->xmit_sequence.xmit_len =
 			wqe->xmit_sequence.bde.tus.f.bdeSize;
@@ -18434,6 +18442,7 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 {
 	/*  make rctl_names static to save stack space */
 	struct fc_vft_header *fc_vft_hdr;
+	struct fc_app_header *fc_app_hdr;
 	uint32_t *header = (uint32_t *) fc_hdr;
 
 #define FC_RCTL_MDS_DIAGS	0xF4
@@ -18489,6 +18498,32 @@ lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
 		goto drop;
 	}
 
+	if (unlikely(phba->link_flag == LS_LOOPBACK_MODE &&
+				phba->cfg_vmid_app_header)) {
+		/* Application header is 16B device header */
+		if (fc_hdr->fh_df_ctl & LPFC_FC_16B_DEVICE_HEADER) {
+			fc_app_hdr = (struct fc_app_header *) (fc_hdr + 1);
+			if (be32_to_cpu(fc_app_hdr->src_app_id) !=
+					LOOPBACK_SRC_APPID) {
+				lpfc_printf_log(phba, KERN_WARNING,
+						LOG_ELS | LOG_LIBDFC,
+						"1932 Loopback src app id "
+						"not matched, app_id:x%x\n",
+						be32_to_cpu(fc_app_hdr->src_app_id));
+
+				goto drop;
+			}
+		} else {
+			lpfc_printf_log(phba, KERN_WARNING,
+					LOG_ELS | LOG_LIBDFC,
+					"1933 Loopback df_ctl bit not set, "
+					"df_ctl:x%x\n",
+					fc_hdr->fh_df_ctl);
+
+			goto drop;
+		}
+	}
+
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
 			"2538 Received frame rctl:x%x, type:x%x, "
 			"frame Data:%08x %08x %08x %08x %08x %08x %08x\n",
-- 
2.38.0

