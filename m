Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BDB224AF2
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 18:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772474485; cv=none; b=VtoqpSF6wb8MsK/QUJAOowoYIXm7WgSbxGU68uJvSnEt7Kh/YM7BG7m9++C7PdlqDPD8/Rqnj5w44RYGRORRMvme+mJIkPqu/tOQn34mZvSM8gZ12VwbVDPyj1sMEqYaKcLWDlHjzATl16eTfpTzMoGlGt42C7XRrpYNyG67nZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772474485; c=relaxed/simple;
	bh=0cggH1bynF4+iXfdGe8JMXIJdQKGERBJzTLgI89p7lU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ndkyodnMFffc7e0w6I2CrIhrtuGovXO8wyeSiEHJZGdraKpLFT4CrVJDMR7PUU//bfsSlTpXtPlDjgcFRCw06I3r9mWD/MzAOv8z+xdBmbuQsmSfc0YCrpD3+JbwtrQiEA0dWKHRv76Y0Qemd1+38R9RfmGAoId64zKOHuvqXj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vamshigajjela.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2goFsfzA; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vamshigajjela.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2goFsfzA"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b62da7602a0so2918284a12.2
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2026 10:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772474484; x=1773079284; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dSjmoqLhglZJrlQKlHyvk3auqHcPImjDTH8u5AU4J0Q=;
        b=2goFsfzAoy19oItRGk9r2fS+c5RhYeeCitVytggECsZMKOAjkCTQyZJ0vgYHDK0Hd7
         ilxMP0kLOs+ybO9BfLQ3V0qWFqPq4taH5PvJ0DqWUKaT4ynGjyG6qiXS2YblFxurS49A
         CxGRA52vni+WWvg3j5IAF4NUlvnnNKJkuGbOaay3aH519Vi7lbN20h0TGMp7qwxVt2/2
         2RORZTxG2BArq72n9PNvxNerp/LH1Gx9e9Uw40AJamyCAwiNME2emAr/4yFmQ0btUxuk
         QcGFMFjGGShsKg5OvOTIMDLI89/t8uMmnuCb3AKeqh9p6DR3wwopnC8j3KZKfQVpGjLJ
         K88A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772474484; x=1773079284;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dSjmoqLhglZJrlQKlHyvk3auqHcPImjDTH8u5AU4J0Q=;
        b=kWZlbI03Mvs/5Z1dqqbYT484yFp8F/oirSgkVCehvGuOdJUbv+mOxZsXnFCAEld30q
         kH4qmHNVNi4z6o6lresePIjUkX+6bFZWkvySvhN5+Wahi471tavrno3oCVa7MjgBmc6M
         zmXnLW7jdLiil/5AQJb/kzT1Unli0UnVn8KgoWHtTmIStTv/TLBJO2j04reTKJGkQ9ws
         vYeWqmS4qJsv2xCOym0SRMays7N7Kpev6qGCdphHKvFaO5mYhd9UTzj9uCFzCETc9rrZ
         xNP4H/ONUZyr2CpJ7mZO06ekoGXteE+PggzRQBrNCquWfGykRgpEKpaVaOoXwgFfew8V
         VKWg==
X-Forwarded-Encrypted: i=1; AJvYcCWqgvKvkjNf9ygBQfX3ldmwvKeV/IJMLK7K7RHgH8fUiGTND4cH3ncj7RnpLSDpnvJ9s9ctPWzD0+VF@vger.kernel.org
X-Gm-Message-State: AOJu0YyvaOogZjPq6h8AusuEHMVAM8HXk0oZUUgp/2mVxrQ7g52levQ2
	wcQAHCJXoPJEM7+uWwePmJ9UqmquR2k+YgXls3tEZmPFh/VZSYie2g81o4GwerohwrGmINfT0P3
	Kr/Q7lniSSlOwjRuBp+snmPfVTN9P9x9GTQ==
X-Received: from pgq27.prod.google.com ([2002:a63:105b:0:b0:c6d:df0e:dbb2])
 (user=vamshigajjela job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6f89:b0:38e:9e38:5977 with SMTP id adf61e73a8af0-395c3a475b7mr12642586637.30.1772474483748;
 Mon, 02 Mar 2026 10:01:23 -0800 (PST)
Date: Mon,  2 Mar 2026 23:31:17 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260302180117.2797184-1-vamshigajjela@google.com>
Subject: [PATCH] scsi: ufs: core: Handle MCQ IAG events
From: vamshi gajjela <vamshigajjela@google.com>
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, 
	bvanassche@acm.org, avri.altman@wdc.com, alim.akhtar@samsung.com
Cc: peter.wang@mediatek.com, quic_nguyenb@quicinc.com, adrian.hunter@intel.com, 
	beanhuo@micron.com, arthur.simchaev@sandisk.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, vamshi gajjela <vamshigajjela@google.com>
Content-Type: text/plain; charset="UTF-8"

Add support for handling aggregation-based interrupts when operating
in MCQ mode.

In legacy interrupt mode, an IE.IAGES is triggered when the counter
or timer threshold is reached. To manage this, the handler now resets
the aggregation counter and timer by writing to the MCQIACRy.CTR
register.

Since the register layout of MCQIACRy is identical to the existing
UTRIACR register, this implementation reuses the previously defined
bitfield masks to maintain consistency and reduce code duplication.

Extend ufshcd_handle_mcq_cq_events() with a boolean iag parameter.
If set, the handler resets the MCQ IAG counter and timer.

Define MCQ_IAG_EVENT_STATUS (0x200000) and include it in
UFSHCD_ENABLE_MCQ_INTRS to ensure the interrupt is unmasked during
initialization.

Signed-off-by: vamshi gajjela <vamshigajjela@google.com>
---
 drivers/ufs/core/ufs-mcq.c     | 13 ++++++++++++-
 drivers/ufs/core/ufshcd-priv.h |  2 ++
 drivers/ufs/core/ufshcd.c      | 17 ++++++++++++++---
 include/ufs/ufshci.h           |  2 ++
 4 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 18a95b728633..377a57ce1fec 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -31,7 +31,8 @@
 
 #define UFSHCD_ENABLE_MCQ_INTRS	(UTP_TASK_REQ_COMPL |\
 				 UFSHCD_ERROR_MASK |\
-				 MCQ_CQ_EVENT_STATUS)
+				 MCQ_CQ_EVENT_STATUS |\
+				 MCQ_IAG_EVENT_STATUS)
 
 /* Max mcq register polling time in microseconds */
 #define MCQ_POLL_US 500000
@@ -272,6 +273,16 @@ void ufshcd_mcq_write_cqis(struct ufs_hba *hba, u32 val, int i)
 }
 EXPORT_SYMBOL_GPL(ufshcd_mcq_write_cqis);
 
+u32 ufshcd_mcq_read_mcqiacr(struct ufs_hba *hba, int i)
+{
+	return readl(mcq_opr_base(hba, OPR_CQIS, i) + REG_MCQIACR);
+}
+
+void ufshcd_mcq_write_mcqiacr(struct ufs_hba *hba, u32 val, int i)
+{
+	writel(val, mcq_opr_base(hba, OPR_CQIS, i) + REG_MCQIACR);
+}
+
 /*
  * Current MCQ specification doesn't provide a Task Tag or its equivalent in
  * the Completion Queue Entry. Find the Task Tag using an indirect method.
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 37c32071e754..6d3d14e883b8 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -76,6 +76,8 @@ void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
 bool ufshcd_cmd_inflight(struct scsi_cmnd *cmd);
 int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag);
 int ufshcd_mcq_abort(struct scsi_cmnd *cmd);
+u32 ufshcd_mcq_read_mcqiacr(struct ufs_hba *hba, int i);
+void ufshcd_mcq_write_mcqiacr(struct ufs_hba *hba, u32 val, int i);
 int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
 void ufshcd_release_scsi_cmd(struct ufs_hba *hba, struct scsi_cmnd *cmd);
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 847b55789bb8..a22e1a51cb6f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7084,16 +7084,17 @@ static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 /**
  * ufshcd_handle_mcq_cq_events - handle MCQ completion queue events
  * @hba: per adapter instance
+ * @iag: true, to reset MCQ IAG counter and timer of the CQ
  *
  * Return: IRQ_HANDLED if interrupt is handled.
  */
-static irqreturn_t ufshcd_handle_mcq_cq_events(struct ufs_hba *hba)
+static irqreturn_t ufshcd_handle_mcq_cq_events(struct ufs_hba *hba, bool iag)
 {
 	struct ufs_hw_queue *hwq;
 	unsigned long outstanding_cqs;
 	unsigned int nr_queues;
 	int i, ret;
-	u32 events;
+	u32 events, reg;
 
 	ret = ufshcd_vops_get_outstanding_cqs(hba, &outstanding_cqs);
 	if (ret)
@@ -7108,6 +7109,13 @@ static irqreturn_t ufshcd_handle_mcq_cq_events(struct ufs_hba *hba)
 		if (events)
 			ufshcd_mcq_write_cqis(hba, events, i);
 
+		/* Clear MCQ IAG counter and timer of the CQ */
+		if (iag) {
+			reg = ufshcd_mcq_read_mcqiacr(hba, i);
+			reg |= INT_AGGR_COUNTER_AND_TIMER_RESET;
+			ufshcd_mcq_write_mcqiacr(hba, reg, i);
+		}
+
 		if (events & UFSHCD_MCQ_CQIS_TAIL_ENT_PUSH_STS)
 			ufshcd_mcq_poll_cqe_lock(hba, hwq);
 	}
@@ -7141,7 +7149,10 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 		retval |= ufshcd_transfer_req_compl(hba);
 
 	if (intr_status & MCQ_CQ_EVENT_STATUS)
-		retval |= ufshcd_handle_mcq_cq_events(hba);
+		retval |= ufshcd_handle_mcq_cq_events(hba, false);
+
+	if (intr_status & MCQ_IAG_EVENT_STATUS)
+		retval |= ufshcd_handle_mcq_cq_events(hba, true);
 
 	return retval;
 }
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 806fdaf52bd9..43e87078538a 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -115,6 +115,7 @@ enum {
 enum {
 	REG_CQIS		= 0x0,
 	REG_CQIE		= 0x4,
+	REG_MCQIACR		= 0x8,
 };
 
 enum {
@@ -188,6 +189,7 @@ static inline u32 ufshci_version(u32 major, u32 minor)
 #define SYSTEM_BUS_FATAL_ERROR			0x20000
 #define CRYPTO_ENGINE_FATAL_ERROR		0x40000
 #define MCQ_CQ_EVENT_STATUS			0x100000
+#define MCQ_IAG_EVENT_STATUS			0x200000
 
 #define UFSHCD_UIC_HIBERN8_MASK	(UIC_HIBERNATE_ENTER |\
 				UIC_HIBERNATE_EXIT)
-- 
2.53.0.473.g4a7958ca14-goog

