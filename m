Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A4B3A962D
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 19:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773169398; cv=none; b=Gomxj9ru6hW6JeeJnJJAb9qAG7oljVdILw/Nvk9114XZbdCSEmd6wOJwFOu/9FgthXjfw3QHaygtVAYzDl73YVhdw3/ud5QVi4lvfTUzHDKxUQ6InqyA2UHODTsAm4QE42z85Fsr7h46DCzBQtqmK+t8HoWUYkambX6G9noHNgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773169398; c=relaxed/simple;
	bh=xaNc7lt6Yn6fLZTNTlpCZ6yeGuA1W6XGBEcXcDK7bV0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kP9g8+LIPLLw3Hyl1kWmZ/80l3KPTLCA4FdYgRe0rNZkdGGyL3ss/hOk6MCrYRB9s/lbbEg7rW8yTqtrVwf6wtIYnMAIMgkDaCffl/n2dPvy/fCerQ5ZDc0Iv2msXW++D6BHyN9v8/F/oEA0NVLvnZPFRzn/6xA6bDuSDA5PM6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vamshigajjela.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A2OTSq4F; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vamshigajjela.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A2OTSq4F"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae47b3adacso92160225ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 12:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773169395; x=1773774195; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Art6J6+gULfTzCDjpLQc7twXR+SSEmZJHs6QkuOum5g=;
        b=A2OTSq4Fg7ILcQy0euxJkWmZDFlim/tRyWGoht/27cXD01nq108M3gz7qNCY1qYmqY
         qKp1EGLtFFZrF1fbAO3M+v6Qqf5lAJW6/uxtw5B8TWzyXPjI15/l0xqgIL1yeujgeNZe
         A88eneSxHs/ySx/tak08LOjYokcb51KdLhyfXHibxLMz+cXNGADzVy09wqqTuh8nFmxE
         jcUSv763m1TX+52fdPl9pZVobA8wGsnUuvlKcIaz8syDXvqmwUzszbsSZAgHWNuYF5JG
         Kf2Mn4tts+ECSrDuWe78aj0+zgEwJZX/mVHO7zi6e2JqcgJYA3biEC0xDw9O9ibLMgsS
         71CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773169395; x=1773774195;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Art6J6+gULfTzCDjpLQc7twXR+SSEmZJHs6QkuOum5g=;
        b=ZzoCtulJBhdM6cZaLzSO4blkI+HzoBLCCRaGmMavKpoXvkcq/nRWkVLHHvDDMhrqKB
         H8E8YooKtxTELEuoPttm3mxs322WjBqL+9wrvw+k9WBvyMsj1i8WUCWTn5bqT6RIbRv2
         Or4A2eB6Gg9p6FWQqLAUoCR2wdG6LbgJWJdM8T34pfpndeqoWsncq/nFhxb3bqy/nnap
         2Ss6/3CtCpayVcR3btmVXBn9w5y/1V94qO3qcyesyZ+v6QVapGhkIyxisUbjh5WF7hQ+
         T4tPZseERWaunI3uDodHpIJwclAe4YT4+zlrPo43i1x4URCp09sE/eptsZMl9vxNn0bi
         zeEA==
X-Forwarded-Encrypted: i=1; AJvYcCWkJ/PU8DAF8ERjlbgt1NQB+PpN/Go1rtJO20scWS1k6D/22HYpBx9rLimMMwaAhXckEaxjzofRPLxk@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3JUpX41GVmgBok9YDJ0lByGl6T47yqE6sq96EwoFGLsv63DUe
	Qb2iqlOz2Rs8xbMgccyzy1uQks/c7Zeupw06xx37LOeJuYtj4XNuzxHhrvFXQ38IRVtK0IrVKYv
	ozbLPV8Luc7A0W8D8I5SGHYF571HYh8ESfA==
X-Received: from plbkr14.prod.google.com ([2002:a17:903:80e:b0:2ab:2731:21b2])
 (user=vamshigajjela job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:46cc:b0:2ae:7f75:22e9 with SMTP id d9443c01a7336-2ae82417801mr170284235ad.1.1773169395125;
 Tue, 10 Mar 2026 12:03:15 -0700 (PDT)
Date: Wed, 11 Mar 2026 00:33:08 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260310190308.2474956-1-vamshigajjela@google.com>
Subject: [PATCH v2] scsi: ufs: core: Handle MCQ IAG events
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
v2: Rename argument to reset_iag

 drivers/ufs/core/ufs-mcq.c     | 13 ++++++++++++-
 drivers/ufs/core/ufshcd-priv.h |  2 ++
 drivers/ufs/core/ufshcd.c      | 16 +++++++++++++---
 include/ufs/ufshci.h           |  2 ++
 4 files changed, 29 insertions(+), 4 deletions(-)

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
index 847b55789bb8..eb7e8e2ae906 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7084,16 +7084,17 @@ static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 /**
  * ufshcd_handle_mcq_cq_events - handle MCQ completion queue events
  * @hba: per adapter instance
+ * @reset_iag: true, to reset MCQ IAG counter and timer of the CQ
  *
  * Return: IRQ_HANDLED if interrupt is handled.
  */
-static irqreturn_t ufshcd_handle_mcq_cq_events(struct ufs_hba *hba)
+static irqreturn_t ufshcd_handle_mcq_cq_events(struct ufs_hba *hba, bool reset_iag)
 {
 	struct ufs_hw_queue *hwq;
 	unsigned long outstanding_cqs;
 	unsigned int nr_queues;
 	int i, ret;
-	u32 events;
+	u32 events, reg;
 
 	ret = ufshcd_vops_get_outstanding_cqs(hba, &outstanding_cqs);
 	if (ret)
@@ -7108,6 +7109,12 @@ static irqreturn_t ufshcd_handle_mcq_cq_events(struct ufs_hba *hba)
 		if (events)
 			ufshcd_mcq_write_cqis(hba, events, i);
 
+		if (reset_iag) {
+			reg = ufshcd_mcq_read_mcqiacr(hba, i);
+			reg |= INT_AGGR_COUNTER_AND_TIMER_RESET;
+			ufshcd_mcq_write_mcqiacr(hba, reg, i);
+		}
+
 		if (events & UFSHCD_MCQ_CQIS_TAIL_ENT_PUSH_STS)
 			ufshcd_mcq_poll_cqe_lock(hba, hwq);
 	}
@@ -7141,7 +7148,10 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
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

