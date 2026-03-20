Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93DB37DEB6
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 09:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773997820; cv=none; b=H7N1A7JrpZAWT8FfBQ/yXuN/0aBDoI+cdwEE/7b6F2r2Kr4qBbEeiSijmWMUtLYBozfYFj0Rj+zz5OJtul0la54lpXzy18L2tU3yOrljBfoM71N6094pVBMAJLFQtVCtZVeQnEV5mbahWSSZ8/+/3yMI26WSPBWWp2FVPQickqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773997820; c=relaxed/simple;
	bh=2GmnE9XhtIthqwTP5NFfh3Zr04utyiwLhDXOW3gekds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwvBxtWqpncuq7k0q5UtCufWgzru1dJkiw3Lbz6EW+g6DHSoYsSnPt/d+o3wTt3AogOLW73UCudBApZgtR7d6jSMiasFJu5BcAp/kofbR62cTnMXUH7bb4THeNfzXarB9wBnWpxyCSa4/r0eaMg+w41Bt9r3f3rz8OoB3Py+VYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=gEqmCY8N; arc=none smtp.client-ip=209.85.215.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gEqmCY8N"
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-c2af7d09533so1262983a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 02:10:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773997816; x=1774602616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=noPd9U90Ee0+tNNxiuCR8gyMYlGkthHEKsTnaT4OFo4=;
        b=ACEZ2I+cOgeqxRua8VNYg0rMdZh7ZfBjKL91urpMOVhaR52K8gqWmxjcyWPNNAL/aH
         ZwZiwwlKLHJYBPTCfilVidx+ZAMBnOJl9gSmPaJelbHRvQOZnbCy/0Pa4Ueth2Xrfm8w
         lPLlaSIqvOWUz81Z+Gpz/9hYgcXySt/qBtcE0BUpJjpFCsNMxRho+/lI/ltYqfzS78tU
         TSqqe9gF2/hnYb/tpF1jEx0VBZ2Qm15bJcJTppxSSATk8WVHSEZq/KZ1Y1gkoYL3N6wx
         LO0Oq5lh2tX6On8vACtqYFPfwfsKWi5G4h5Al80Y1GjPhQ3Qs3ztV7pB/T0rWrZd2zBc
         WlKg==
X-Gm-Message-State: AOJu0YzOAaRV65cpQWIUmfanYZxrSNtoxEebgFKDDawmDxFxYa3fe18x
	0akUW4Iab3Nd21dyBveREZXBOSW3SwU/zQpH8wQwAbyohS80zudGLZLnk2bUtVpQylZ/4Rw2/CD
	/CXLluiW1dWOYvGVoBZJSuBCjt/9TvvU8FEqJ+W46fQDFezokto3m6NPIOVY3ZuWZfr7a6M/dCu
	ilaM0Q4iXfRXwliDhfSClPhqvEImlEDFDfQPCcTt+dBCVYP+RCIdcQ+yA+a25mwCCImui71wyi6
	EjIUt9rND8WLgtg
X-Gm-Gg: ATEYQzzuc0//QQHV9d6X0OtQwIVnSNijbivVohaW2wacyqOtn3rplJ0cgrQXdDCRAL4
	AABHjo9m6TBFi53WCV4CMyW+ti3aIQ9rnmMJKRnpjxVLeClA4M+hKJT6mxwi5RpK/mYPGaFw/KM
	qbIGCKDR63gLrV2izh45REH8TQu9u14+HP2tlMGYHJ/Gz5bx9e9HidiTh+MlVOPhL4C1AvzMJ6i
	S/vfivPnVZ75sEKS9vpMA5XgJJk+6gHA/EMvOgn69tb2Nf4sHt/Jsx9yh1w13jcirvkFWhCgA/f
	05tqsevVFLAe3ikjZakRVcdi6vAk2s+3gGMT0QT4ghuh9i11Kzv2fIVIPTsl/pXmBVSeyfwDjcW
	5gMzxKf4Xz1kgjW2z8JKhn0QIJnU8ltFI7eqtN5bqq+I+HIkQoqEhwSzGpLG6PUJ7wMKVMMkGCw
	SLYx3uq2U15jsXKB+NBr/Joly5UZIUzJdIxpIApqq6gEEQrfq0Zlif25Xl
X-Received: by 2002:a17:903:f86:b0:2ab:3cba:42fa with SMTP id d9443c01a7336-2b0827d522dmr19976535ad.46.1773997815808;
        Fri, 20 Mar 2026 02:10:15 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2b0834ee479sm2059475ad.10.2026.03.20.02.10.15
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Mar 2026 02:10:15 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-798531a0f58so26675547b3.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 02:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1773997814; x=1774602614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=noPd9U90Ee0+tNNxiuCR8gyMYlGkthHEKsTnaT4OFo4=;
        b=gEqmCY8N7LU6OsiFA3Z4c43YQu5dGGwWmKhIclNkZw1ywXXLGHEZVEUpX1rZ71elpg
         Uhm672jo6l5shr7h/xFExFPeKgD0Ss6HuuacZ1s5v/AG+qcSWQjvYzki6nDQHCo0pWPC
         s4KYWHV317U8/UiV7j9orSFss2u/tQJNLS9OY=
X-Received: by 2002:a05:690c:e3c2:b0:798:6944:a033 with SMTP id 00721157ae682-79a90c25c64mr21710307b3.55.1773997814333;
        Fri, 20 Mar 2026 02:10:14 -0700 (PDT)
X-Received: by 2002:a05:690c:e3c2:b0:798:6944:a033 with SMTP id 00721157ae682-79a90c25c64mr21710047b3.55.1773997813684;
        Fri, 20 Mar 2026 02:10:13 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a9057b738sm11680357b3.36.2026.03.20.02.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 02:10:12 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 2/3] mpi3mr: Add queue-full tracking for operational request queues
Date: Fri, 20 Mar 2026 14:33:25 +0530
Message-ID: <20260320090326.47544-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320090326.47544-1-ranjan.kumar@broadcom.com>
References: <20260320090326.47544-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Track queue-full conditions on operational request queues in the driver.
Record the last host tag returned to the SCSI mid-layer
and count I/Os affected by queue-full conditions.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    | 12 ++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 16 ++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index da141c185eef..631a48f7425d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -429,6 +429,14 @@ struct segments {
  * @q_segments: Segment descriptor pointer
  * @q_segment_list: Segment list base virtual address
  * @q_segment_list_dma: Segment list base DMA address
+ * @last_full_host_tag: Hosttag of last IO returned to SML
+ *			due to queue full
+ * @qfull_io_count: Number of IOs returned back to SML
+ *			due to queue full
+ * @qfull_instances: Total queue full occurrences.One occurrence
+ *			starts with queue full detection and ends
+ *			with queue full breaks.
+ *
  */
 struct op_req_qinfo {
 	u16 ci;
@@ -442,6 +450,10 @@ struct op_req_qinfo {
 	struct segments *q_segments;
 	void *q_segment_list;
 	dma_addr_t q_segment_list_dma;
+	u16 last_full_host_tag;
+	u64 qfull_io_count;
+	u32 qfull_instances;
+
 };
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 58360666fb78..da0d475db01e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2362,6 +2362,9 @@ static int mpi3mr_create_op_req_q(struct mpi3mr_ioc *mrioc, u16 idx,
 	op_req_q->ci = 0;
 	op_req_q->pi = 0;
 	op_req_q->reply_qid = reply_qid;
+	op_req_q->last_full_host_tag =  MPI3MR_HOSTTAG_INVALID;
+	op_req_q->qfull_io_count =  0;
+	op_req_q->qfull_instances =  0;
 	spin_lock_init(&op_req_q->q_lock);
 
 	if (!op_req_q->q_segments) {
@@ -2549,6 +2552,8 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
 	u16 req_sz = mrioc->facts.op_req_sz;
 	struct segments *segments = op_req_q->q_segments;
 	struct op_reply_qinfo *op_reply_q = NULL;
+	struct mpi3_scsi_io_request *scsiio_req =
+		(struct mpi3_scsi_io_request *)req;
 
 	reply_qidx = op_req_q->reply_qid - 1;
 	op_reply_q = mrioc->op_reply_qinfo + reply_qidx;
@@ -2566,11 +2571,21 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
 		mpi3mr_process_op_reply_q(mrioc, mrioc->intr_info[midx].op_reply_q);
 
 		if (mpi3mr_check_req_qfull(op_req_q)) {
+
+			if (op_req_q->last_full_host_tag ==
+			    MPI3MR_HOSTTAG_INVALID)
+				op_req_q->qfull_instances++;
+
+			op_req_q->last_full_host_tag = scsiio_req->host_tag;
+			op_req_q->qfull_io_count++;
 			retval = -EAGAIN;
 			goto out;
 		}
 	}
 
+	if (op_req_q->last_full_host_tag != MPI3MR_HOSTTAG_INVALID)
+		op_req_q->last_full_host_tag = MPI3MR_HOSTTAG_INVALID;
+
 	if (mrioc->reset_in_progress) {
 		ioc_err(mrioc, "OpReqQ submit reset in progress\n");
 		retval = -EAGAIN;
@@ -4829,6 +4844,7 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 			mrioc->req_qinfo[i].qid = 0;
 			mrioc->req_qinfo[i].reply_qid = 0;
 			spin_lock_init(&mrioc->req_qinfo[i].q_lock);
+			mrioc->req_qinfo[i].last_full_host_tag = 0;
 			mpi3mr_memset_op_req_q_buffers(mrioc, i);
 		}
 	}
-- 
2.47.3

