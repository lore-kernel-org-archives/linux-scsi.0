Received: from mail-oa1-f98.google.com (mail-oa1-f98.google.com [209.85.160.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE5137A4AA
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 09:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773997818; cv=none; b=itKEA5QPpcJ5iIvOdn2oNXyQd6lO5dtrnXVUyHYgovvB2Wnjl2HLokGMKvyP5VykbUJ//wNXvrtZc9lrpVpcIsZpRSbs5jwlt8jAOdNhbCeVEn+MU+564jbg5KQ1tTNms/3oWhHxsJHq8HfHguxxDBM8cW3glAkrhp/lPJo2sYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773997818; c=relaxed/simple;
	bh=5+XoaGHJWYqKc/InKVcIcynfxSj7q6SzbzO5B4D+S2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSiwi+b28BcRanembqpxYJDfTV+hX+LjTJafXgjtjalaEzI1y7jB0XIJLRHYwihgJSUHpSH3u7TYdQPP5nIHSnsmba6n7GopQVM8wStIfGGUp00TNQhJNuCKflbs/6mXuyBa1J9VQ9kA+B6NTj2fTIq3IVOuF5x49N2arrYhSug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=BPtjvRWd; arc=none smtp.client-ip=209.85.160.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BPtjvRWd"
Received: by mail-oa1-f98.google.com with SMTP id 586e51a60fabf-40f1a1f77a6so1343418fac.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 02:10:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773997813; x=1774602613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uk7zF89Fso/HBiINYVh3RKGlheqbEUKWlm8sY78PTMM=;
        b=DUCrXg/fWB1pDV/eBM6L8WAKdPE9tIkCNJlJoQPnD2InA6USRvzun2OFkJdcEt3ZyR
         eGUnqXTq0EDAcOPK16MZEhWY/Xe+1w8teztCYkU7dqaaBWykQZYJxU2uyMQnMG8ItKLY
         f6KZKAnkR6Ky0W+je33WAywvaXp3czfDwYCqNJMerufcawnj7S1RhnZ3V0BMdtemZCSY
         bNz3nuEB31dZQvR+hJLwOgTsLmbAOReuq+xLXoYBeQfuiTojhGRwHuDw1PjulRp3YTdV
         sxiq3D29J9xrvlKD1p0NaFIK6lEVks5ZZbHLacgHex8Hk5dhmK8Qem1AsCnlnbRxo8Kn
         h6rA==
X-Gm-Message-State: AOJu0YwbTZdHKl86f8T0BIyayK/lX9M3hBqawCAZcX5loHW3w8QwPKPL
	jxtK/4KK0dT1KvSAmFpD2bA2y3hiGTJ8aKjJQ73CJBNjZ4NS0Mljob4Uu1Ny3JyRVnzUzs4Iy4I
	9cESjcFJ/t2equhcMyoBUkRrr1UEEHRf1nVSoQHMjNzvLbs+mSFRGWHPL5ITdEya3+pxunhYsKI
	7VkI+AIic82qDm7wZiv2yLk97qU5lPxIdQQ70uNFrvUREJ7UbIVG9bnlfUGhmZ/FkIn4DtB/Kir
	k2Wb2Q6r2oFxW2W
X-Gm-Gg: ATEYQzzsak1wFTdMP7ACqrZ5UKw6tJCTSs6ScJO3mpIavyQu6LFd1v2PoUZLr8AX2XL
	QfN5F6p4aWwNOFc4lVhgjs9yZgLGdLP8ll9dPtXdtx4iflE+hPQRZwPp5sgJIKC1FnUgezRqX4N
	vN6Jg6j6tRNtZ/Al0YJF6mfpJDK7V/7Na+ArHnCBPDddtKkHwT1wdWaxUxONUKpOqihKZCC6pD4
	aDt48mRdRLnkM+qBMUU+RDTvSLV4f0MEWup9azs9GeRJyIZY2hRl28UyALWMxXgZqrOxYNEugtB
	HiUjqah+McadGFrIY22J6VINzgPSc2CvA3uB2hFcosDqh/4Vmz+SmwqSL5XvCOBUclwVgg9WIdj
	E0TRsP+hosL+amZXH4B5x6AceZU/lDMpqiJ6WejqZaAzRw3f55QVEtmAdo0nKwZDo9CI7J+XtGJ
	NkfoxkoUH2W6rtehA9yAv8Ik0wa9w+FbSSUd/mVZEXtJaBOXTQ0FEHGCHwqR0=
X-Received: by 2002:a05:6870:3269:b0:41b:f2ee:bfea with SMTP id 586e51a60fabf-41c112f937emr1531931fac.41.1773997812522;
        Fri, 20 Mar 2026 02:10:12 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-102.dlp.protect.broadcom.com. [144.49.247.102])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-41c14942500sm248300fac.6.2026.03.20.02.10.11
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Mar 2026 02:10:12 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-790afc07667so40758487b3.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 02:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1773997810; x=1774602610; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uk7zF89Fso/HBiINYVh3RKGlheqbEUKWlm8sY78PTMM=;
        b=BPtjvRWdG1UWNhyi2m2eVr039IvrSwKccJqnYLQDyV5UNAwQmMboqDrmRW+5+kTxCL
         jHPoNB07HmeEROsgxMiWhZUjoxXRGGzIE2GjfIy4emjhY8Y82ZyPGDueCqzCbGJf6qVV
         e+GETy2M+G59XFMerl1u29e6fP5kV7gbJxGBA=
X-Received: by 2002:a05:690c:6607:b0:798:730e:f01d with SMTP id 00721157ae682-79a90be77c0mr23570747b3.43.1773997810506;
        Fri, 20 Mar 2026 02:10:10 -0700 (PDT)
X-Received: by 2002:a05:690c:6607:b0:798:730e:f01d with SMTP id 00721157ae682-79a90be77c0mr23570497b3.43.1773997809971;
        Fri, 20 Mar 2026 02:10:09 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a9057b738sm11680357b3.36.2026.03.20.02.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 02:10:09 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 1/3] mpi3mr: Reset controller on invalid I/O completion
Date: Fri, 20 Mar 2026 14:33:24 +0530
Message-ID: <20260320090326.47544-2-ranjan.kumar@broadcom.com>
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

Operational replies without a valid scsi_cmnd indicate an invalid
I/O completion and a potentially inconsistent controller state.
Track this condition and allow the watchdog to trigger a soft
reset to safely recover.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  3 +++
 drivers/scsi/mpi3mr/mpi3mr_fw.c |  7 +++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 11 +++++++++--
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 6e962092577d..da141c185eef 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -323,6 +323,7 @@ enum mpi3mr_reset_reason {
 	MPI3MR_RESET_FROM_CFG_REQ_TIMEOUT = 29,
 	MPI3MR_RESET_FROM_SAS_TRANSPORT_TIMEOUT = 30,
 	MPI3MR_RESET_FROM_TRIGGER = 31,
+	MPI3MR_RESET_FROM_INVALID_COMPLETION = 32,
 };
 
 #define MPI3MR_RESET_REASON_OSTYPE_LINUX	1
@@ -1183,6 +1184,7 @@ struct scmd_priv {
  * @num_tb_segs: Number of Segments in Trace buffer
  * @trace_buf_pool: DMA pool for Segmented trace buffer segments
  * @trace_buf: Trace buffer segments memory descriptor
+ * @invalid_io_comp: Invalid IO completion
  */
 struct mpi3mr_ioc {
 	struct list_head list;
@@ -1394,6 +1396,7 @@ struct mpi3mr_ioc {
 	u32 num_tb_segs;
 	struct dma_pool *trace_buf_pool;
 	struct segments *trace_buf;
+	u8 invalid_io_comp;
 
 };
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 04d4a2aea7d7..58360666fb78 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -996,6 +996,7 @@ static const struct {
 	{ MPI3MR_RESET_FROM_FIRMWARE, "firmware asynchronous reset" },
 	{ MPI3MR_RESET_FROM_CFG_REQ_TIMEOUT, "configuration request timeout"},
 	{ MPI3MR_RESET_FROM_SAS_TRANSPORT_TIMEOUT, "timeout of a SAS transport layer request" },
+	{ MPI3MR_RESET_FROM_INVALID_COMPLETION, "invalid cmd completion" },
 };
 
 /**
@@ -2880,6 +2881,11 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 		return;
 	}
 
+	if (mrioc->invalid_io_comp) {
+		mpi3mr_soft_reset_handler(mrioc, MPI3MR_RESET_FROM_INVALID_COMPLETION, 1);
+		return;
+	}
+
 	if (atomic_read(&mrioc->admin_pend_isr)) {
 		ioc_err(mrioc, "Unprocessed admin ISR instance found\n"
 				"flush admin replies\n");
@@ -5647,6 +5653,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	ssleep(MPI3MR_RESET_TOPOLOGY_SETTLE_TIME);
 
 out:
+	mrioc->invalid_io_comp = 0;
 	if (!retval) {
 		mrioc->diagsave_timeout = 0;
 		mrioc->reset_in_progress = 0;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 8e5abf620718..59d43f768ae6 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3462,8 +3462,15 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 	}
 	scmd = mpi3mr_scmd_from_host_tag(mrioc, host_tag, qidx);
 	if (!scmd) {
-		panic("%s: Cannot Identify scmd for host_tag 0x%x\n",
-		    mrioc->name, host_tag);
+		ioc_err(mrioc, "Cannot Identify scmd for host_tag 0x%x", host_tag);
+		ioc_err(mrioc,
+		    "reply_desc_type(%d) host_tag(%d(0x%04x)): qid(%d): command issued to\n"
+		    "handle(0x%04x) returned with ioc_status(0x%04x), log_info(0x%08x),\n"
+		    "scsi_state(0x%02x), scsi_status(0x%02x), xfer_count(%d), resp_data(0x%08x)\n",
+		    reply_desc_type, host_tag, host_tag, qidx+1, dev_handle, ioc_status,
+		    ioc_loginfo, scsi_state, scsi_status,  xfer_count,
+		    resp_data);
+		mrioc->invalid_io_comp = 1;
 		goto out;
 	}
 	priv = scsi_cmd_priv(scmd);
-- 
2.47.3

