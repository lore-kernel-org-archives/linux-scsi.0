Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B551157A5C;
	Wed,  1 Jan 2025 13:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735739118; cv=none; b=SdsnMpfputa0gMj42x5ANKxNyUvJsj+Ss4qD/xtnJnGOr37nPrBwzZ08nZgDkhKzfgnWPFx2GROMtIIXvuRV+biMFaxJrFReKOerd/eveXkLEFSBFAVvFolBeOhsezsMR6dhMgcsHU56i/aYPnrfCaU6vHjwDpPAYWQCsa4EC90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735739118; c=relaxed/simple;
	bh=jh1RjnqXX7XvMOxypOqZqXND+h4qbC6V8O8MPTV0Nag=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZM3AFnzv+QYX4zMvV8hVWZTdLsuY0L9JJGX8NXfn5LBs1Yfq55gzZ4f3T3BiVg95FXp3NSdFDfLm+FCO9TIMD0d/AG0sxHXWnOxmPosfZ61auY9VxBkgV22mZvzd4vS8/m+fTJsJzD22IigcPbbu/W+m51zSYSWJjkr+LnBOTE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=onjPs/YV; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="onjPs/YV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1735739116; x=1767275116;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jh1RjnqXX7XvMOxypOqZqXND+h4qbC6V8O8MPTV0Nag=;
  b=onjPs/YVZp+K94kJSXRuNRkKp5sOW8u9zR6NBzFmDhPWHli5btVtnhXj
   kz5LVeIFOHVKedgFJmv6Te73hFpJESAaNCO2S6O0FOEcBYaYiD1FlK0aU
   14h1LCvbT6T7e3E0PTdcRtdclFvl2Xpys8y6CEVs/P2GSh25WApfNMKT5
   zJeMaUtoOhxKafEvoYp+f6Qi9082ObeCH+FNLsz0+8j6ce/or0pgy2B8y
   Lq9hWH2hmLTOWGOfixz66qpvbaRHsFNEy5sllOHXiYYttN6+5z/8SPFQ9
   5Id1Lzi25KAIaJyoMiWUxDzr/FIX73PcRAYodt+sWpFLy4cm3BAwNCqOk
   A==;
X-CSE-ConnectionGUID: vuT3ExnsR1yjenPkC+0Jvw==
X-CSE-MsgGUID: hK6++Rb6S+W5l7qIvNclhQ==
X-IronPort-AV: E=Sophos;i="6.12,282,1728921600"; 
   d="scan'208";a="36177427"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jan 2025 21:44:06 +0800
IronPort-SDR: 6775392a_GTy+nW8L4HXWMkohVZUtJGzVeSn2IEfV7nruvkXJWLZHdeu
 HZP6InMbQn2AwfhH+yMHFABfaykVRUSwiOeZvXw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Jan 2025 04:46:34 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Jan 2025 05:44:05 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>,
	Can Guo <quic_cang@quicinc.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH v2] Revert "scsi: ufs: core: Probe for EXT_IID support"
Date: Wed,  1 Jan 2025 15:41:40 +0200
Message-Id: <20250101134140.57580-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 6e1d850acff9477ae4c18a73c19ef52841ac2010.

Although added a while ago, to date no one make use of ext_iid,
specifically incorporates it in the upiu header.  Therefore, remove it
as it is just a dead code.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Cc: Can Guo <quic_cang@quicinc.com>
Cc: Asutosh Das <quic_asutoshd@quicinc.com>

---
Changes compared to v1:
 - Fix typo
---
 drivers/ufs/core/ufshcd.c | 33 ---------------------------------
 include/ufs/ufs.h         |  5 -----
 include/ufs/ufshcd.h      |  2 --
 include/ufs/ufshci.h      |  7 +------
 4 files changed, 1 insertion(+), 46 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3dfaeba5b691..7d672bd52b84 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2411,12 +2411,7 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 	else
 		hba->lsdb_sup = true;
 
-	if (!hba->mcq_sup)
-		return 0;
-
 	hba->mcq_capabilities = ufshcd_readl(hba, REG_MCQCAP);
-	hba->ext_iid_sup = FIELD_GET(MASK_EXT_IID_SUPPORT,
-				     hba->mcq_capabilities);
 
 	return 0;
 }
@@ -8082,31 +8077,6 @@ static void ufshcd_temp_notif_probe(struct ufs_hba *hba, const u8 *desc_buf)
 	}
 }
 
-static void ufshcd_ext_iid_probe(struct ufs_hba *hba, u8 *desc_buf)
-{
-	struct ufs_dev_info *dev_info = &hba->dev_info;
-	u32 ext_ufs_feature;
-	u32 ext_iid_en = 0;
-	int err;
-
-	/* Only UFS-4.0 and above may support EXT_IID */
-	if (dev_info->wspecversion < 0x400)
-		goto out;
-
-	ext_ufs_feature = get_unaligned_be32(desc_buf +
-				     DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
-	if (!(ext_ufs_feature & UFS_DEV_EXT_IID_SUP))
-		goto out;
-
-	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
-				      QUERY_ATTR_IDN_EXT_IID_EN, 0, 0, &ext_iid_en);
-	if (err)
-		dev_err(hba->dev, "failed reading bEXTIIDEn. err = %d\n", err);
-
-out:
-	dev_info->b_ext_iid_en = ext_iid_en;
-}
-
 static void ufshcd_set_rtt(struct ufs_hba *hba)
 {
 	struct ufs_dev_info *dev_info = &hba->dev_info;
@@ -8302,9 +8272,6 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	ufs_init_rtc(hba, desc_buf);
 
-	if (hba->ext_iid_sup)
-		ufshcd_ext_iid_probe(hba, desc_buf);
-
 	/*
 	 * ufshcd_read_string_desc returns size of the string
 	 * reset the error value
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index e594abe5d05f..89672ad8c3bb 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -180,7 +180,6 @@ enum attr_idn {
 	QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE       = 0x1D,
 	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    = 0x1E,
 	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        = 0x1F,
-	QUERY_ATTR_IDN_EXT_IID_EN		= 0x2A,
 	QUERY_ATTR_IDN_TIMESTAMP		= 0x30
 };
 
@@ -391,7 +390,6 @@ enum {
 	UFS_DEV_EXT_TEMP_NOTIF		= BIT(6),
 	UFS_DEV_HPB_SUPPORT		= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
-	UFS_DEV_EXT_IID_SUP		= BIT(16),
 };
 #define UFS_DEV_HPB_SUPPORT_VERSION		0x310
 
@@ -585,9 +583,6 @@ struct ufs_dev_info {
 
 	bool    b_advanced_rpmb_en;
 
-	/* UFS EXT_IID Enable */
-	bool	b_ext_iid_en;
-
 	/* UFS RTC */
 	enum ufs_rtc_time rtc_type;
 	time64_t rtc_time_baseline;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index ce7667b020e2..a2f7d565a79b 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -955,7 +955,6 @@ enum ufshcd_mcq_opr {
  * @nr_queues: number of Queues of different queue types
  * @complete_put: whether or not to call ufshcd_rpm_put() from inside
  *	ufshcd_resume_complete()
- * @ext_iid_sup: is EXT_IID is supported by UFSHC
  * @mcq_sup: is mcq supported by UFSHC
  * @mcq_enabled: is mcq ready to accept requests
  * @res: array of resource info of MCQ registers
@@ -1121,7 +1120,6 @@ struct ufs_hba {
 	unsigned int nr_hw_queues;
 	unsigned int nr_queues[HCTX_MAX_TYPES];
 	bool complete_put;
-	bool ext_iid_sup;
 	bool scsi_host_added;
 	bool mcq_sup;
 	bool lsdb_sup;
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 27364c4a6ef9..155f0801e907 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -23,7 +23,7 @@ enum {
 /* UFSHCI Registers */
 enum {
 	REG_CONTROLLER_CAPABILITIES		= 0x00,
-	REG_MCQCAP				= 0x04,
+	REG_MCQCAP                              = 0x04,
 	REG_UFS_VERSION				= 0x08,
 	REG_EXT_CONTROLLER_CAPABILITIES		= 0x0C,
 	REG_CONTROLLER_PID			= 0x10,
@@ -82,11 +82,6 @@ enum {
 	MASK_MCQ_SUPPORT			= 0x40000000,
 };
 
-/* MCQ capability mask */
-enum {
-	MASK_EXT_IID_SUPPORT = 0x00000400,
-};
-
 enum {
 	REG_SQATTR		= 0x0,
 	REG_SQLBA		= 0x4,
-- 
2.25.1

