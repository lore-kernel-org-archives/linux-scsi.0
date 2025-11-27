Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3FC313E2F
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 07:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764227306; cv=none; b=th5fJm2NDkXO+XuoG8xW+Wcmr7e5n57RUgA1VeNVIpk09h2Vev7ah7dE8UW5E5rYAu7XR2mW2+igpR5Jy0rbrqyawxgpjE39ZSPfESeDMACKTslXRL4cc0UHvYxEwm955MNQHMPS0A+lNOfO+ZAiHewilvCYUtqguGmH1oYXV0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764227306; c=relaxed/simple;
	bh=3b6wIYgewbLW+NSlJo3hwLCgNV7d/iwK2UN4TDIMNug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=S6jRA6hCuV0Bgh9J6ttCWTAFlmbJf1rk2dJVWiB9PGNnlmru6SpUSGPAylmxChdVgOXf0RwSu348SFoS9rkEmSIBRJ1XTSjrQ75ZHqLKB1qxmgaXe40C2Satw6Ck4A6t+8oi90qyGECEObvdIImnpPBL9JqGYh2m2/WbkWHIpxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=eA31Ei2N; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="eA31Ei2N"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251127070822epoutp04b485181537e6233497c3a7cc9a6851ec~7y2JPWHBE0149201492epoutp04R
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 07:08:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251127070822epoutp04b485181537e6233497c3a7cc9a6851ec~7y2JPWHBE0149201492epoutp04R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1764227302;
	bh=qi/SRWVOW0xIZ/a8mTLL5M3ulFk+K1NrsEeMRhZKiBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eA31Ei2Nse7jIaVTut2v5ZCY/Bjfxhm6vsovErNfhc9/zL1arwDT7jrecFvq1suio
	 x7IV/Thqk3IST1s+X5fyRxB92wH54F/eRMp+6H1jk7d0VrYRoEKRnYlloH6VLJareo
	 9tGYiTZg1TgASxsJU+qObnNWik6xnzYFtGTcCXds=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20251127070820epcas5p10bae834c83fa96ed68539647c5e482a4~7y2H3uLzv0705007050epcas5p1-;
	Thu, 27 Nov 2025 07:08:20 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.93]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dH6w34FVnz6B9m5; Thu, 27 Nov
	2025 07:08:19 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20251127070721epcas5p43dce5b0a0c4dd7258be71e96ed244359~7y1QeFMvY1500615006epcas5p4I;
	Thu, 27 Nov 2025 07:07:21 +0000 (GMT)
Received: from testpc12933.samsungds.net (unknown [109.105.129.33]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251127070719epsmtip282d6fa319b5b24bd60d349f56868565e~7y1PWjGVp2030420304epsmtip2D;
	Thu, 27 Nov 2025 07:07:19 +0000 (GMT)
From: "zheng.gong" <zheng.gong@samsung.com>
To: linux-scsi@vger.kernel.org
Cc: avri.altman@wdc.com, bvanassche@acm.org, quic_cang@quicinc.com,
	alim.akhtar@samsung.com, martin.petersen@oracle.com, ebiggers@kernel.org,
	linux-kernel@vger.kernel.org, "zheng.gong" <zheng.gong@samsung.com>
Subject: [PATCH v2 1/2] scsi: ufs: crypto: Add
 ufs_hba_variant_ops::crypto_keyslot_remap
Date: Thu, 27 Nov 2025 15:06:58 +0800
Message-ID: <20251127070704.2935390-2-zheng.gong@samsung.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251127070704.2935390-1-zheng.gong@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251127070721epcas5p43dce5b0a0c4dd7258be71e96ed244359
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-505,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251127070721epcas5p43dce5b0a0c4dd7258be71e96ed244359
References: <20251112031035.GA2832160@google.com>
	<20251127070704.2935390-1-zheng.gong@samsung.com>
	<CGME20251127070721epcas5p43dce5b0a0c4dd7258be71e96ed244359@epcas5p4.samsung.com>

Add a new variant operation crypto_keyslot_remap to allow platform-specific
remapping of crypto keyslot indices before sending requests to the UFS
controller. This is required on platforms that partition the UFS crypto
engine's keyslots among multiple domains (e.g.virtual machines),
where each domain has a keyslot offset.

To support this, pass the UFS HBA pointer to ufshcd_prepare_lrbp_crypto(),
so the callback can access platform context.

This functionality is used on Samsung ExynosAuto UFS platforms, where
keyslot allocation is per-VM and a runtime offset is applied based on
the VM ID.

Signed-off-by: zheng.gong <zheng.gong@samsung.com>
---
 drivers/ufs/core/ufshcd-crypto.h | 10 ++++++++--
 drivers/ufs/core/ufshcd.c        |  9 +++++----
 include/ufs/ufshcd.h             |  6 ++++++
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-crypto.h b/drivers/ufs/core/ufshcd-crypto.h
index 89bb97c14c15..6dcba6817590 100644
--- a/drivers/ufs/core/ufshcd-crypto.h
+++ b/drivers/ufs/core/ufshcd-crypto.h
@@ -13,7 +13,8 @@
 
 #ifdef CONFIG_SCSI_UFS_CRYPTO
 
-static inline void ufshcd_prepare_lrbp_crypto(struct request *rq,
+static inline void ufshcd_prepare_lrbp_crypto(struct ufs_hba *hba,
+					      struct request *rq,
 					      struct ufshcd_lrb *lrbp)
 {
 	if (!rq || !rq->crypt_keyslot) {
@@ -22,6 +23,10 @@ static inline void ufshcd_prepare_lrbp_crypto(struct request *rq,
 	}
 
 	lrbp->crypto_key_slot = blk_crypto_keyslot_index(rq->crypt_keyslot);
+
+	if (hba && hba->vops && hba->vops->crypto_keyslot_remap)
+		return hba->vops->crypto_keyslot_remap(hba, lrbp);
+
 	lrbp->data_unit_num = rq->crypt_ctx->bc_dun[0];
 }
 
@@ -74,7 +79,8 @@ void ufshcd_crypto_register(struct ufs_hba *hba, struct request_queue *q);
 
 #else /* CONFIG_SCSI_UFS_CRYPTO */
 
-static inline void ufshcd_prepare_lrbp_crypto(struct request *rq,
+static inline void ufshcd_prepare_lrbp_crypto(struct ufs_hba *hba,
+					      struct request *rq,
 					      struct ufshcd_lrb *lrbp) { }
 
 static inline void
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8339fec975b9..7417c6bec81a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2902,20 +2902,21 @@ static void ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
 }
 
-static void __ufshcd_setup_cmd(struct ufshcd_lrb *lrbp, struct scsi_cmnd *cmd, u8 lun, int tag)
+static void __ufshcd_setup_cmd(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
+				  struct scsi_cmnd *cmd, u8 lun, int tag)
 {
 	memset(lrbp->ucd_req_ptr, 0, sizeof(*lrbp->ucd_req_ptr));
 
 	lrbp->cmd = cmd;
 	lrbp->task_tag = tag;
 	lrbp->lun = lun;
-	ufshcd_prepare_lrbp_crypto(cmd ? scsi_cmd_to_rq(cmd) : NULL, lrbp);
+	ufshcd_prepare_lrbp_crypto(hba, cmd ? scsi_cmd_to_rq(cmd) : NULL, lrbp);
 }
 
 static void ufshcd_setup_scsi_cmd(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 				  struct scsi_cmnd *cmd, u8 lun, int tag)
 {
-	__ufshcd_setup_cmd(lrbp, cmd, lun, tag);
+	__ufshcd_setup_cmd(hba, lrbp, cmd, lun, tag);
 	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba);
 	lrbp->req_abort_skip = false;
 
@@ -3083,7 +3084,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 static void ufshcd_setup_dev_cmd(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 			     enum dev_cmd_type cmd_type, u8 lun, int tag)
 {
-	__ufshcd_setup_cmd(lrbp, NULL, lun, tag);
+	__ufshcd_setup_cmd(hba, lrbp, NULL, lun, tag);
 	lrbp->intr_cmd = true; /* No interrupt aggregation */
 	hba->dev_cmd.type = cmd_type;
 }
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 9425cfd9d00e..86b7bcc1da33 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -336,6 +336,10 @@ struct ufs_pwr_mode_info {
  * @config_esi: called to config Event Specific Interrupt
  * @config_scsi_dev: called to configure SCSI device parameters
  * @freq_to_gear_speed: called to map clock frequency to the max supported gear speed
+ * @crypto_keyslot_remap: called to adjust the keyslot index before sending
+ *	a request to the UFS controller. This allows the platform to apply a
+ *	hardware-specific keyslot offset or other mapping logic to determine
+ *	the correct keyslot for inline encryption.
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -385,6 +389,8 @@ struct ufs_hba_variant_ops {
 	int	(*config_esi)(struct ufs_hba *hba);
 	void	(*config_scsi_dev)(struct scsi_device *sdev);
 	u32	(*freq_to_gear_speed)(struct ufs_hba *hba, unsigned long freq);
+	void	(*crypto_keyslot_remap)(struct ufs_hba *hba,
+						struct ufshcd_lrb *lrbp);
 };
 
 /* clock gating state  */
-- 
2.50.1

