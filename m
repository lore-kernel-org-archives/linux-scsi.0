Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BE917C98
	for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2024 19:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729625575; cv=none; b=oxeigcm+gP8tp9nLyUV46wFMmgLM9guPh6om/kIp6EOu4e4kMSdRga03vxSxLOxP/dkzywH9ZEMBSE57Os9OjzYKqLcKXGRTm8MaZvmmJRDcollYz38ky0gBGQVSU9g5GVx6X0yMApDb8K/9/CcOzouo8iWogmifklJJ03IQTrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729625575; c=relaxed/simple;
	bh=xMYIHmk+T+4ng2pmz1M32HNxLDLj5L71Lfbohd48erM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECHbksYKpZt658tbh/7vKyLuP1xi09SO8b0ILggfb2KJ7zIlOr82KJR7/xT2dd8UDJUaJ3gtk1oTfMqIgQjFVRSOd4e4JsLVTGRRQYyU/ANMDSsHXdO/9bPRhHZajtcgvC+y5WLtvj8KPBQ7RRLwe7J3PL2X+ohimJqc0vXYh2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HhgiAcra; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HhgiAcra"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XY2QF4GNkzlgMVW;
	Tue, 22 Oct 2024 19:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729625565; x=1732217566; bh=uZGjA
	JdKsfUKQn25GH7Spbxci4VJY+9XHaEdlkVlTZE=; b=HhgiAcraro8PeLgmhMhKU
	As9RV8UWe183M4YcoMWdKRkctKwY4Ss1u/5mqnrPh6LtdveA9NPcqqIqAo5aIHPo
	1CJ2s/IrU/cr7fg4evDYwpGz80O6fCLE6H+uHRw/D0wVdASeA6Fu4r5zgceXu3UO
	lteeGtdzpZAOglSBD08O48Jnj5NSMcTuJzGwW/SS7ViFIlZDRt3BVdNPj5+lKHRL
	ZdCoWscQ7HVtwGb8nM7TxbXgq/IhqXoi6uUCdjH3kmBovTbh/M2jDLGh6Wnb1L6B
	Q/Zt72Tp6cgkOmD1KOF5F3OhCcXmq5fprASCkS+kl5bt7a+iM/jRwVgPbgEfZrZZ
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6X4XaEQSoKH4; Tue, 22 Oct 2024 19:32:45 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XY2Q04tl5zlgTWP;
	Tue, 22 Oct 2024 19:32:40 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Eric Biggers <ebiggers@google.com>,
	Minwoo Im <minwoo.im@samsung.com>
Subject: [PATCH v2 5/6] scsi: ufs: core: Simplify ufshcd_err_handling_prepare()
Date: Tue, 22 Oct 2024 12:31:01 -0700
Message-ID: <20241022193130.2733293-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
In-Reply-To: <20241022193130.2733293-1-bvanassche@acm.org>
References: <20241022193130.2733293-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Use blk_mq_quiesce_tagset() instead of ufshcd_scsi_block_requests()
and blk_mq_wait_quiesce_done(). Since this patch removes the last callers
of ufshcd_scsi_block_requests() and ufshcd_scsi_unblock_requests(),
remove these functions.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 19 +++----------------
 include/ufs/ufshcd.h      |  2 --
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2fde1b0a6086..e0dba0e3d5b5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -349,18 +349,6 @@ static void ufshcd_configure_wb(struct ufs_hba *hba)
 		ufshcd_wb_toggle_buf_flush(hba, true);
 }
=20
-static void ufshcd_scsi_unblock_requests(struct ufs_hba *hba)
-{
-	if (atomic_dec_and_test(&hba->scsi_block_reqs_cnt))
-		scsi_unblock_requests(hba->host);
-}
-
-static void ufshcd_scsi_block_requests(struct ufs_hba *hba)
-{
-	if (atomic_inc_return(&hba->scsi_block_reqs_cnt) =3D=3D 1)
-		scsi_block_requests(hba->host);
-}
-
 static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int =
tag,
 				      enum ufs_trace_str_t str_t)
 {
@@ -6376,15 +6364,14 @@ static void ufshcd_err_handling_prepare(struct uf=
s_hba *hba)
 			ufshcd_suspend_clkscaling(hba);
 		ufshcd_clk_scaling_allow(hba, false);
 	}
-	ufshcd_scsi_block_requests(hba);
 	/* Wait for ongoing ufshcd_queuecommand() calls to finish. */
-	blk_mq_wait_quiesce_done(&hba->host->tag_set);
+	blk_mq_quiesce_tagset(&hba->host->tag_set);
 	cancel_work_sync(&hba->eeh_work);
 }
=20
 static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 {
-	ufshcd_scsi_unblock_requests(hba);
+	blk_mq_unquiesce_tagset(&hba->host->tag_set);
 	ufshcd_release(hba);
 	if (ufshcd_is_clkscaling_supported(hba))
 		ufshcd_clk_scaling_suspend(hba, false);
@@ -10557,7 +10544,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
=20
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
-	atomic_set(&hba->scsi_block_reqs_cnt, 0);
+
 	/*
 	 * We are assuming that device wasn't put in sleep/power-down
 	 * state exclusively during the boot stage before kernel.
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a0b325a32aca..36bd91ff3593 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -928,7 +928,6 @@ enum ufshcd_mcq_opr {
  * @wb_mutex: used to serialize devfreq and sysfs write booster toggling
  * @clk_scaling_lock: used to serialize device commands and clock scalin=
g
  * @desc_size: descriptor sizes reported by device
- * @scsi_block_reqs_cnt: reference counting for scsi block requests
  * @bsg_dev: struct device associated with the BSG queue
  * @bsg_queue: BSG queue associated with the UFS controller
  * @rpm_dev_flush_recheck_work: used to suspend from RPM (runtime power
@@ -1089,7 +1088,6 @@ struct ufs_hba {
=20
 	struct mutex wb_mutex;
 	struct rw_semaphore clk_scaling_lock;
-	atomic_t scsi_block_reqs_cnt;
=20
 	struct device		bsg_dev;
 	struct request_queue	*bsg_queue;
