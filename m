Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F483587C8
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 03:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769656833; cv=none; b=iaFQKzuDWCfchVTokOk7jnk3k9zih8hag5ZKCIIOI9F+Ma4ffdFUoAc89bXw4GgcnkOEGlRPGjPdFPfAZW7hRbvPL5su35qU1Q8uQ8fHkv97ZPOIeIbkK1Hs5FgzVtKup4+5xt94vQHSaeKLt06AMRqfCqgDBpglAYTedxHBHxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769656833; c=relaxed/simple;
	bh=3b6wIYgewbLW+NSlJo3hwLCgNV7d/iwK2UN4TDIMNug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=TXWjnjfWIxw31r6bQFDzmdmjcXOW75Mngc0uL9wt8PCF3RHX+l8IpCrmQYtu4AIbqNOC7VarYWAsLUl3we1Wqthj/3+Q/aVi7+wRdVbT3Z/fpMem+bxPdwbScXpCxWkuU2nYs8F6iFhVumrfm6MmfiwkTng6iDd3Y3zoigmeghA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=SJh2ndmI; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SJh2ndmI"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260129032024epoutp0459c9320072a41f1d6c6f2ecc7beed0a4~PFYF2GedH0460404604epoutp04t
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 03:20:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260129032024epoutp0459c9320072a41f1d6c6f2ecc7beed0a4~PFYF2GedH0460404604epoutp04t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769656824;
	bh=qi/SRWVOW0xIZ/a8mTLL5M3ulFk+K1NrsEeMRhZKiBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJh2ndmI1dSqA1eSAKKjODdFHXIlKgPMRHj5o+sXtxghkdnBpWlJ9UwrYoBlPyEnv
	 GkpLHlADSw2dwK3joLiZ6HDy2RnVyxjFtn81eDasUI2JLA88jvrApDWjj+Y2UueXC4
	 QP9L6aLktS9B9GIzSgCxqn/LIUW07HD6Wcq5EvcE=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260129032023epcas5p2ee4435a7037ee12befc694ace1a570d7~PFYFWd6_z2717327173epcas5p2G;
	Thu, 29 Jan 2026 03:20:23 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.95]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4f1ksx73dTz6B9m4; Thu, 29 Jan
	2026 03:20:21 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260129031040epcas5p1446e3f496de82836acdf78a400e6b116~PFPlx-9-l1290312903epcas5p15;
	Thu, 29 Jan 2026 03:10:40 +0000 (GMT)
Received: from testpc12933.samsungds.net (unknown [109.105.129.33]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260129031039epsmtip14f9cbc0f17ada1fa045d80d07f079a2e~PFPksbWuw0450604506epsmtip1N;
	Thu, 29 Jan 2026 03:10:38 +0000 (GMT)
From: "zheng.gong" <zheng.gong@samsung.com>
To: linux-scsi@vger.kernel.org
Cc: avri.altman@wdc.com, bvanassche@acm.org, quic_cang@quicinc.com,
	alim.akhtar@samsung.com, martin.petersen@oracle.com, ebiggers@kernel.org,
	linux-kernel@vger.kernel.org, "zheng.gong" <zheng.gong@samsung.com>
Subject: [PATCH v4 1/3] scsi: ufs: crypto: Add
 ufs_hba_variant_ops::crypto_keyslot_remap
Date: Thu, 29 Jan 2026 11:10:31 +0800
Message-ID: <20260129031033.3428295-2-zheng.gong@samsung.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260129031033.3428295-1-zheng.gong@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260129031040epcas5p1446e3f496de82836acdf78a400e6b116
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-505,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260129031040epcas5p1446e3f496de82836acdf78a400e6b116
References: <20251112031035.GA2832160@google.com>
	<20260129031033.3428295-1-zheng.gong@samsung.com>
	<CGME20260129031040epcas5p1446e3f496de82836acdf78a400e6b116@epcas5p1.samsung.com>

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

