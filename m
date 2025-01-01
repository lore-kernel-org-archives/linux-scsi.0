Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ACA1E1A18;
	Wed,  1 Jan 2025 13:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735738175; cv=none; b=Tijc5GFi1ofK+LPFn4j5NjyiNBA/FjP8leRkiRoQa61s/lQJxoZVeL+klskNkGI5xqdNWOb6D9Uf89JAqkZlYD2YibGuQBsYaESyp3qLqZzYrzj5CvIQ2I1NtwcoxBL7QUfXCPsdWeepWUxBLH/TPpggobU59+q28JwF+UllqZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735738175; c=relaxed/simple;
	bh=LxwJ195ZmHF7cCp5pImY4bELG4eR8XJsgUpKUHMagc0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jCXdY3Eo0FXdYNsrizIhPuokMx+OZI1HRfh0WXB3npbz/THaBrPvtkyvUyN8Bqa6bahPxn6zviEW7N1viNgXYWbLrLrLTmmr/Of+GeILglYvSiBkbeJwPuhoE6+WbMMICloCyRagM5+gydmYuzL7wX8z4zZyuEZ+5Tn7yKqUiAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UCU54o5k; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UCU54o5k"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1735738174; x=1767274174;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LxwJ195ZmHF7cCp5pImY4bELG4eR8XJsgUpKUHMagc0=;
  b=UCU54o5ki1PtPYdIpGaL00lut1gfHWDR7LBGo6M3o2e7UiGjqOTZTSAx
   wRjEaGmC34cD0xPdOkTWrY/WNhdrar6hopvzU4jPwPaiaI3VN6cpfTJ3Y
   H12h5N3ZLD75TiHulGCUfwS79rYZS/vze1MbHcR8CazBzZNO1xqQEV0/M
   n0OL1mHrrC5OuVwZXLlxDsvfAuxEiOq7hNNH4nFJR8ryieZWF/VTG9CHU
   T7NBbE/iuCuXPPpz3nUTIyY8eIcgttYT1fejtZGjVhrpeWgfTrSBsv5pN
   bSopA9opmujGFRb/5HeuCoUZJ6aHOB2u6w/JoVlni0xye3fp0Nhp9FHZ6
   g==;
X-CSE-ConnectionGUID: NJKZh04USw+I9DXiCWXRlA==
X-CSE-MsgGUID: F+L8oYy4QBOJxjifg1cxQA==
X-IronPort-AV: E=Sophos;i="6.12,282,1728921600"; 
   d="scan'208";a="35022517"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jan 2025 21:28:25 +0800
IronPort-SDR: 67753432_VWgUoxcMXz4jnjvNwN2DEiwqePAWUf4sROMn5pw/z5MZINc
 dO24AWF3kCd7OHAskP18DEGL8aI/vcKG0QVNtTw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Jan 2025 04:25:22 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Jan 2025 05:28:23 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>,
	Can Guo <quic_cang@quicinc.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH] Revert "scsi: ufs: core: Probe for EXT_IID support"
Date: Wed,  1 Jan 2025 15:25:51 +0200
Message-Id: <20250101132551.52307-1-avri.altman@wdc.com>
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
 drivers/ufs/core/ufshcd.c | 35 -----------------------------------
 include/ufs/ufs.h         |  5 -----
 include/ufs/ufshcd.h      |  2 --
 include/ufs/ufshci.h      |  6 ------
 4 files changed, 48 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3dfaeba5b691..dad5556547cb 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2411,13 +2411,6 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 	else
 		hba->lsdb_sup = true;
 
-	if (!hba->mcq_sup)
-		return 0;
-
-	hba->mcq_capabilities = ufshcd_readl(hba, REG_MCQCAP);
-	hba->ext_iid_sup = FIELD_GET(MASK_EXT_IID_SUPPORT,
-				     hba->mcq_capabilities);
-
 	return 0;
 }
 
@@ -8082,31 +8075,6 @@ static void ufshcd_temp_notif_probe(struct ufs_hba *hba, const u8 *desc_buf)
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
@@ -8302,9 +8270,6 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
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
index 27364c4a6ef9..cfd618fd1915 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -23,7 +23,6 @@ enum {
 /* UFSHCI Registers */
 enum {
 	REG_CONTROLLER_CAPABILITIES		= 0x00,
-	REG_MCQCAP				= 0x04,
 	REG_UFS_VERSION				= 0x08,
 	REG_EXT_CONTROLLER_CAPABILITIES		= 0x0C,
 	REG_CONTROLLER_PID			= 0x10,
@@ -82,11 +81,6 @@ enum {
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

