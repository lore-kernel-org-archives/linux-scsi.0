Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5D81F1306;
	Sat, 25 Oct 2025 16:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408836; cv=none; b=mnkZ0SXdj69bD1a3YthcaHa5BlbM81h+yWubCPKGHt97Rg52olSDYw82dzlxChitciWDEkZaSTSyRLQNqZLguAIMsa4cJBUhpQRNba+NJpJMVdfls6FbsEvLg50HRtIsJRtsWmFW64rHqInRgB4w+o3B0Ozr2gXyS9NXQo5Jw0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408836; c=relaxed/simple;
	bh=zVtHnfPXG4ioxX+DlgXGFZiXd2qgpVY5VuTt9jhmCqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HcOpiB0urtiQuHfK+tH7ekraGX/IodfXARwUEKxWev/IJ0VblGC1Q3ee5PEN1m+M53pxp+kFRrgVc0NIgKHpgf4dbYS3/JbpN2zy3LuYKtRlNZFKwMbib6Uw5QOcSbarFnUoRdw9vfUMEBve6x5qvXoh2n5mHfs8JstIZWD8FNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YbOwP7Qw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YbOwP7Qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A725C4CEFB;
	Sat, 25 Oct 2025 16:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408836;
	bh=zVtHnfPXG4ioxX+DlgXGFZiXd2qgpVY5VuTt9jhmCqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbOwP7QwePA8fGDUTJWGSWAG7qbQ1Iym1GQkBEuSZcjDOtyFwXLLTprPB2z13gMJM
	 nBnlmHniVN1aJvGMFeRh3UT8qbkgKCxsx8ada608Nz+5iLP7wSWFCBAssFvR5TljkR
	 YYvyVCNrGcYYRXe+rT0a/9DjZfyTzKXpZ1iPYDPviIDbnHBboyH4eSAHWKLBWoLHs8
	 AbnFTd6zcAq0ZacrZ1Zx8nfxPdF9tPVIh55xCyWResVNxGyTdPIRz4gaa5+iBQ1CWz
	 bLnvj2TjO8emxcKsclWYcJAyZl59wZ2qCb+Ib5qEFPt7nxe8eXz3UJ0E7/IF4OdWqb
	 y0nmfRe2pT/Cg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	mani@kernel.org,
	alim.akhtar@samsung.com,
	chenyuan0y@gmail.com,
	ping.gao@samsung.com,
	alok.a.tiwari@oracle.com,
	alexandre.f.demers@gmail.com,
	avri.altman@sandisk.com,
	beanhuo@micron.com,
	adrian.hunter@intel.com,
	quic_cang@quicinc.com,
	quic_nitirawa@quicinc.com,
	neil.armstrong@linaro.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17] scsi: ufs: core: Change MCQ interrupt enable flow
Date: Sat, 25 Oct 2025 11:55:23 -0400
Message-ID: <20251025160905.3857885-92-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 253757797973c54ea967f8fd8f40d16e4a78e6d4 ]

Move the MCQ interrupt enable process to
ufshcd_mcq_make_queues_operational() to ensure that interrupts are set
correctly when making queues operational, similar to
ufshcd_make_hba_operational(). This change addresses the issue where
ufshcd_mcq_make_queues_operational() was not fully operational due to
missing interrupt enablement.

This change only affects host drivers that call
ufshcd_mcq_make_queues_operational(), i.e. ufs-mediatek.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- `ufs-mediatek` is the only host driver that calls
  `ufshcd_mcq_make_queues_operational()` directly
  (`drivers/ufs/host/ufs-mediatek.c:1654`). Without this patch, that
  path never enables the MCQ-specific interrupt bits, so after MCQ
  reconfiguration the controller cannot receive queue completion
  interrupts and I/O stalls.
- The fix moves the interrupt enable step into
  `ufshcd_mcq_make_queues_operational()` itself (`drivers/ufs/core/ufs-
  mcq.c:355`), so every caller—both the core flow and the MediaTek
  vops—now enables `UFSHCD_ENABLE_MCQ_INTRS`, while still honoring
  `UFSHCD_QUIRK_MCQ_BROKEN_INTR`.
- To make that call possible from `ufs-mcq.c`, the patch simply exports
  `ufshcd_enable_intr()` and its prototype
  (`drivers/ufs/core/ufshcd.c:336`, `include/ufs/ufshcd.h:1310`). This
  does not alter behavior for existing callers; it just exposes the
  already-used helper.
- The change is small, self-contained, and limited to MCQ bring-up. It
  fixes a real functional regression introduced when MCQ support landed
  for MediaTek platforms, with no architectural churn and minimal
  regression risk.

 drivers/ufs/core/ufs-mcq.c | 11 +++++++++++
 drivers/ufs/core/ufshcd.c  | 12 +-----------
 include/ufs/ufshcd.h       |  1 +
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index cc88aaa106da3..c9bdd4140fd04 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -29,6 +29,10 @@
 #define MCQ_ENTRY_SIZE_IN_DWORD	8
 #define CQE_UCD_BA GENMASK_ULL(63, 7)
 
+#define UFSHCD_ENABLE_MCQ_INTRS	(UTP_TASK_REQ_COMPL |\
+				 UFSHCD_ERROR_MASK |\
+				 MCQ_CQ_EVENT_STATUS)
+
 /* Max mcq register polling time in microseconds */
 #define MCQ_POLL_US 500000
 
@@ -355,9 +359,16 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_poll_cqe_lock);
 void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba)
 {
 	struct ufs_hw_queue *hwq;
+	u32 intrs;
 	u16 qsize;
 	int i;
 
+	/* Enable required interrupts */
+	intrs = UFSHCD_ENABLE_MCQ_INTRS;
+	if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_INTR)
+		intrs &= ~MCQ_CQ_EVENT_STATUS;
+	ufshcd_enable_intr(hba, intrs);
+
 	for (i = 0; i < hba->nr_hw_queues; i++) {
 		hwq = &hba->uhq[i];
 		hwq->id = i;
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1907c0f6eda0e..85d5e3938891a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -45,11 +45,6 @@
 				 UTP_TASK_REQ_COMPL |\
 				 UFSHCD_ERROR_MASK)
 
-#define UFSHCD_ENABLE_MCQ_INTRS	(UTP_TASK_REQ_COMPL |\
-				 UFSHCD_ERROR_MASK |\
-				 MCQ_CQ_EVENT_STATUS)
-
-
 /* UIC command timeout, unit: ms */
 enum {
 	UIC_CMD_TIMEOUT_DEFAULT	= 500,
@@ -372,7 +367,7 @@ EXPORT_SYMBOL_GPL(ufshcd_disable_irq);
  * @hba: per adapter instance
  * @intrs: interrupt bits
  */
-static void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
+void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
 {
 	u32 old_val = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 	u32 new_val = old_val | intrs;
@@ -8925,16 +8920,11 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
 static void ufshcd_config_mcq(struct ufs_hba *hba)
 {
 	int ret;
-	u32 intrs;
 
 	ret = ufshcd_mcq_vops_config_esi(hba);
 	hba->mcq_esi_enabled = !ret;
 	dev_info(hba->dev, "ESI %sconfigured\n", ret ? "is not " : "");
 
-	intrs = UFSHCD_ENABLE_MCQ_INTRS;
-	if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_INTR)
-		intrs &= ~MCQ_CQ_EVENT_STATUS;
-	ufshcd_enable_intr(hba, intrs);
 	ufshcd_mcq_make_queues_operational(hba);
 	ufshcd_mcq_config_mac(hba, hba->nutrs);
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a4eb5bde46e88..a060fa71b2b1b 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1321,6 +1321,7 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32 reg)
 
 void ufshcd_enable_irq(struct ufs_hba *hba);
 void ufshcd_disable_irq(struct ufs_hba *hba);
+void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs);
 int ufshcd_alloc_host(struct device *, struct ufs_hba **);
 int ufshcd_hba_enable(struct ufs_hba *hba);
 int ufshcd_init(struct ufs_hba *, void __iomem *, unsigned int);
-- 
2.51.0

