Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04E2221723
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 01:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762392435; cv=none; b=Y9tQR52nH3zmyiw4KA+nFoaIc3erxSgVnDIlSpPCGF8UiDVt9ixfEtiF+n0oU4hjJ31etvO2U7ZQcyr8EFEeXXzOcJQ8nLilVpJhqgLEI2TrhKRoz3jbLW3tNdt3ZvK3uiTTgRenIaf8Id76IhfxQWiM2wdtpPMJiVWTa99v0P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762392435; c=relaxed/simple;
	bh=2QuG6z1/rX6cN1Zwg4rkkpz8v7h9o+cglIUTpxNjK8o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=idxuaPFkiUDTC5E6KRV1426lL+s9uAGXK3Zp6/UZPyc4LuuMDnYLdLY2/QleFEHdIWrHdM87SGcap+DNzM68XalB/gFIAdbUp7PWWfYIVSBvcLmsTwROA1ZTfOPTZRREBSGyGmwIdVOGHghaHZErOvCyNvujzR9NOQHYY3Khszw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=MNIHNOIH; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MNIHNOIH"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251106012704epoutp03d1f8699b26daa08b2eebc9cd6ed28c88~1RpJ18Ixr2143021430epoutp03C
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 01:27:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251106012704epoutp03d1f8699b26daa08b2eebc9cd6ed28c88~1RpJ18Ixr2143021430epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1762392424;
	bh=FUmPilvOX+860M4bzKodyhpSFYaspyR5h6f6riBEbMg=;
	h=From:To:Cc:Subject:Date:References:From;
	b=MNIHNOIHpskLZuujW24Cac2G6lmCcx8Mf9fF6OD08/7ectiHIe33k/EXxW5Y8g+Ye
	 qO3yjvediTfRzL4JGvREffzYIYdOAiWd3ZBRcj0kRaUPpwHuwVFgX6VojSPxj3nDYp
	 FYdpcnjXoyKiGaXqDucLHR7z7NxiiK31TNsgBNTU=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPS id
	20251106012703epcas1p38bb48af303ebac1b9f1f0cd404085bb3~1RpJGzaUA1524715247epcas1p3J;
	Thu,  6 Nov 2025 01:27:03 +0000 (GMT)
Received: from epcas1p1.samsung.com (unknown [182.195.38.120]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4d24Ky6qBGz6B9m8; Thu,  6 Nov
	2025 01:27:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2~1RpIXZe5L2455324553epcas1p2S;
	Thu,  6 Nov 2025 01:27:02 +0000 (GMT)
Received: from sh043lee-960XFH.. (unknown [10.253.98.183]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251106012702epsmtip23c64dda0ebc1fbc067d751b212d778ba~1RpIS1VKq1062010620epsmtip2G;
	Thu,  6 Nov 2025 01:27:02 +0000 (GMT)
From: Seunghui Lee <sh043.lee@samsung.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	martin.petersen@oracle.com, peter.wang@mediatek.com, beanhuo@micron.com,
	adrian.hunter@intel.com, storage.sec@samsung.com
Cc: Seunghui Lee <sh043.lee@samsung.com>
Subject: [PATCH] UFS: Make TM command timeout configurable from host side
Date: Thu,  6 Nov 2025 10:26:54 +0900
Message-ID: <20251106012654.4094-1-sh043.lee@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>

Currently, UFS driver uses hardcoded TM_CMD_TIMEOUT (100ms) for all
Task Management commands, which may not be optimal for different UFS
devices and use cases.

This patch adds a configurable tm_cmd_timeout field to ufs_hba structure
and uses it instead of the hardcoded constant. The default value remains
TM_CMD_TIMEOUT to maintain backward compatibility.

[   90.372004] [1:  kworker/u16:1:   10] ufshcd-qcom 1d84000.ufshc: ufshcd_abort: Device abort task at tag 9
[   90.372025] [1:  kworker/u16:1:   10] ufshcd-qcom 1d84000.ufshc: UPIU[9] - issue time 80324520 us
[   90.372037] [1:  kworker/u16:1:   10] ufshcd-qcom 1d84000.ufshc: UPIU[9] - complete time 0 us
[   90.372049] [1:  kworker/u16:1:   10] ufshcd-qcom 1d84000.ufshc: UPIU[9] - Transfer Request Descriptor phys@0x28120
[   90.372085] [1:  kworker/u16:1:   10] ufshcd-qcom 1d84000.ufshc: UPIU[9] - Request UPIU phys@0xb400
[   90.372121] [1:  kworker/u16:1:   10] ufshcd-qcom 1d84000.ufshc: UPIU[9] - Response UPIU phys@0xb600
[   90.372180] [1:  kworker/u16:1:   10] ufshcd-qcom 1d84000.ufshc: UPIU[9] - PRDT - 2 entries  phys@0xb800
[   90.372193] [1:  kworker/u16:1:   10] ufshcd-qcom 1d84000.ufshc: ufshcd_abort: skipping abort
[   90.514494] [0:      scsi_eh_0:  209] ufshcd-qcom 1d84000.ufshc: __ufshcd_issue_tm_cmd: task management cmd 0x08 timed-out

Signed-off-by: Seunghui Lee <sh043.lee@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 include/ufs/ufshcd.h      | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9ca27de4767a..6099504ffc35 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7252,7 +7252,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 
 	/* wait until the task management command is completed */
 	err = wait_for_completion_io_timeout(&wait,
-			msecs_to_jiffies(TM_CMD_TIMEOUT));
+			msecs_to_jiffies(hba->tm_cmd_timeout));
 	if (!err) {
 		ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_ERR);
 		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
@@ -10565,6 +10565,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 	hba->dev = dev;
 	hba->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
 	hba->nop_out_timeout = NOP_OUT_TIMEOUT;
+	hba->tm_cmd_timeout = TM_CMD_TIMEOUT;
 	ufshcd_set_sg_entry_size(hba, sizeof(struct ufshcd_sg_entry));
 	INIT_LIST_HEAD(&hba->clk_list_head);
 	spin_lock_init(&hba->outstanding_lock);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 9425cfd9d00e..aed792eb9e16 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -884,6 +884,7 @@ enum ufshcd_mcq_opr {
  * @dev_cmd: ufs device management command information
  * @last_dme_cmd_tstamp: time stamp of the last completed DME command
  * @nop_out_timeout: NOP OUT timeout value
+ * @tm_cmd_timeout: TM CMD timeout value
  * @dev_info: information about the UFS device
  * @auto_bkops_enabled: to track whether bkops is enabled in device
  * @vreg_info: UFS device voltage regulator information
@@ -1042,6 +1043,7 @@ struct ufs_hba {
 	struct ufs_dev_cmd dev_cmd;
 	ktime_t last_dme_cmd_tstamp;
 	int nop_out_timeout;
+	int tm_cmd_timeout;
 
 	/* Keeps information of the UFS device connected to this host */
 	struct ufs_dev_info dev_info;
-- 
2.43.0

