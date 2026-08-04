Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011068.outbound.protection.outlook.com [52.101.52.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2214570FC;
	Tue,  4 Aug 2026 15:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785855792; cv=fail; b=iyTHM9VjGNmCF+gpR0hJXn+SMZNe+d3J2jN9dPOP4YNHR3eezuyiiU6rYw9GZznMCCEmry95aMFAcscMqSOtiuDy7i+9ulk+2XFB7T57JhsxEqnmPfgqlD3CvC8UwzF7k3bmfLwmAZZmlXtc8cH1Yg8IKXNh2tdR+kWvcCTeETM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785855792; c=relaxed/simple;
	bh=6zDnNEre5LBgjK+8CqVYDLtb5TnTemOtK9A9yJwPaLA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=r2XtLpa1pes8VTpquJPHKsHfZmfpWxW49sk676cBfon7bGW8TFn1K9bCeSnTklGa7dQnK2U9m9i9PLH3JjbhFiQi19a8mAOkf1Nb+WdoxqxkN5QjmAlSI9DEPwJci1kA2q3fbchmrGNoKntdmL5Gdr4qtjuDZBzX+Ait9zlUUhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=V2avdag+; arc=fail smtp.client-ip=52.101.52.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="V2avdag+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uWQzeDivpJ0sMgQyWuDhe5vnZxd6PAZ2dRTm1B15s7PnfZMjgAVeVKp33Vtm8KWOU6fwjCKg4XyUsxKZ40lSZQnwSYCaPug5TZAiUeueCDtna488fR/NvC+dY0c0IlLk3p/8L3+z9At0tEqEEREl4BqI/SOVrNQ3CDo24NhR5gpsUsTbFLKWyVdzJnpK832Qc6tucKARXysjT5lKLWQHY93C5hZnNfJDo61w2YnqoYMz8sd4F4b6nucqnI2fWZo2wm37ni9ikX+o7KTyyWRNMphc50yjScfOQCbIf+1HG7lkd0oBj9bJnpjIWylSKXYiig2cvZsp+EzpNLOTR2SdSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sfeW3RKAu1XPqGZp/lG53sBx+hQo9+QeWVWYMewi7TU=;
 b=nCWYkbDdg6IxMuVJDshsfV1hKQ/ancAF0ihyBvxM157ueUy44Fj+FmVHigepdKBn9x5IjqSLmEOKhzaJG03gNlx5xVcaY/ed2gWTx7YpJwU6YG+ZeXlP/7rSUqe/1Wv6ZBiIEk6mVjLFBhk3IMU9WicaMpAgbolMbNY/QjM1qrlSp4z5z6lfoceCRvGlnZl7mzAEPpdG8XQeRpxAVwbbeiyUDQdHb+4tRWVC+qn5WabtbLwcsEDZXX5HlmZ3djfqUqyJWVJNSuprPJV+ZgzytjMxNkPSBrttyO5PBjDWf3Ng8fRwPxYJesu6nefDng51yPPKHg51FlTEi79+3CmLpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfeW3RKAu1XPqGZp/lG53sBx+hQo9+QeWVWYMewi7TU=;
 b=V2avdag+XluDt9fVh2JfFhRHJUuffqApk2b0RM5eHbktUztePnjiMbA+7GI92qMOuc1nOvzwP47NO9dOJdqu/y/kv84NKFivSuFW8/XtdvkdZb3geVT9L8KBH5BsWI8doDZ1Eaen0U+nKbwWoXt/h2zeIE9a+GtVdeupAH3WpGs=
Received: from BN9PR03CA0545.namprd03.prod.outlook.com (2603:10b6:408:138::10)
 by DM6PR12MB4482.namprd12.prod.outlook.com (2603:10b6:5:2a8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Tue, 4 Aug
 2026 15:02:52 +0000
Received: from BL02EPF0001A102.namprd05.prod.outlook.com
 (2603:10b6:408:138:cafe::a5) by BN9PR03CA0545.outlook.office365.com
 (2603:10b6:408:138::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.15 via Frontend Transport; Tue, 4
 Aug 2026 15:02:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL02EPF0001A102.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Tue, 4 Aug 2026 15:02:52 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 4 Aug
 2026 10:02:37 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 4 Aug
 2026 08:02:36 -0700
Received: from localhost (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41 via Frontend
 Transport; Tue, 4 Aug 2026 10:02:36 -0500
From: Michal Simek <michal.simek@amd.com>
To: <linux-kernel@vger.kernel.org>, <monstr@monstr.eu>,
	<michal.simek@amd.com>, <git@amd.com>
CC: Ajay Neeli <ajay.neeli@amd.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Sai Krishna Potthuri
	<sai.krishna.potthuri@amd.com>, "moderated list:ARM/ZYNQ ARCHITECTURE"
	<linux-arm-kernel@lists.infradead.org>, "open list:SCSI SUBSYSTEM"
	<linux-scsi@vger.kernel.org>
Subject: [PATCH] firmware: xilinx: ufs: move PHY/SRAM ready polling into the firmware backend
Date: Tue, 4 Aug 2026 17:02:31 +0200
Message-ID: <eaeaaea8ed76069943e0706a0917139ff6569929.1785855749.git.michal.simek@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7943; i=michal.simek@amd.com; h=from:subject:message-id; bh=6zDnNEre5LBgjK+8CqVYDLtb5TnTemOtK9A9yJwPaLA=; b=owGbwMvMwCG2mv3fB7+vgl8ZT6slMWQV/ue0b//ufMNjVqz2MYGSUleROs/pK8uV7tRXPz/ta X5dJfBoRykLgxgHg6yYIst0Jh2HNd+uLRVbHpkPM4eVCWQIAxenAExE8SnDX8EllZcMKj/PXVfv svJt4yHHyFj2N4LnnlTwF+g8Dtj8dy7DX/Gjt54fdlVzUPXZwyK7lteTL/7f13Qu3919kUf/rVo UwgwA
X-Developer-Key: i=michal.simek@amd.com; a=openpgp; fpr=67350C9BF5CCEE9B5364356A377C7F21FE3D1F91
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A102:EE_|DM6PR12MB4482:EE_
X-MS-Office365-Filtering-Correlation-Id: 30e8f6ad-a9d5-47bd-e204-08def23974d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|23010399003|36860700016|11063799006|56012099006|6133799003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	H9MFYQGCJnCXbTiw34Ho0+Ka+RLj+aa0fHP0uj8j0QNe97dOwna8OzjRV11lMZNmwc06yD65w25F3J/aKjCWGTBKJcOw3ZVL/AZ5dqBSaXJQ/xGWlQRYmUOt72MeUvf1TVVxyODIKKoTJ3Q9okOXWZUvhI48hTkG/kR8AMLLstTkXz7Fo7APYJXMN2GP5p62M/th/HqvSIhck7eg/+fUoeVpR11k0xkc4rSR+0n6tzVgdrw45OChsqaMxsHWC/pcoskYd9vtlcShUdACIbdmjzX/N0Fb+tWerSARfa1ksy8p6s1Z2wUtJpodNN/sVqyzjNSDMWtFhC4yteaadtEwYtQV5YqVzZCrxIkHSOMqzVAhqVOprw+37LOLkUjOlS59lUGz0Pd8h7QQW5fOIWOj4tHyf7vxWYEwflnGL3wJFsyydSPJu7sKKivgS57jxyzKpllFlESQS9OvrjMSTyP2DCqnx/K4aK3PG94laErzRZhaHGlMTyNOUFtLK1869q062XhJ/aFHi1uFUmpgiBMjUQ4VQyEAFhKFDNOePcF9RX08jWG/BuQvaxUJtz9EC4fXcTZ/vYyP6FmnEt1dV/FGUA1sR78GR5TcgOWb7fUZrcLfQg93iIPVBFkbc7Tai28EK03620XnDjYNNXoWbuMTrJxt6+Q6hYGoyiFedsPwqSzYn5oSx1By+hkAYpJqxcP5cZh3YSyyaIXgPAQ2V3W9AQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(23010399003)(36860700016)(11063799006)(56012099006)(6133799003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uaxySCm1ABNswAZfbqVaxx56AZC1I1AqENqTusboUsUp2CarqMwj+rM8GohdH6BKZk9/mppr/RrURsamIy+9JG/x07xFHd3crxya+kUNb2LpNlkpIUfClUNi6b+tZ2hXYVbF7LNVxWbphhzGTgFnUai/rChmffEdB8F40aIk9FMFUxZJPQ2HKuad+dTYIVSKEPtQbEIXvPu145oqW0R6ArGeo6nY4phW4RYwceAIstVtZDzdVTULywpPbGNNPJPJRMLkg2bwO9xTzdvyBTc1ebb9tpmqJW5ZHczd3fOq6Jk6dbVYlgQgo5Qq0tps2AFDENinFYsoTnkKvOxqTU56sjnLTbwnVsgCF5uHck30vLH020QfC/qVcgeGxPEsEnbO3f+JVmwF73eRRNw41BKEQqHJdDRraJXSA0aY83rUmnt1ZOF9fAapvEMWJZO3s/c1
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 15:02:52.0242
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e8f6ad-a9d5-47bd-e204-08def23974d9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A102.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4482

The Versal Gen 2 UFS driver polls the firmware for M-PHY TX/RX
configuration readiness and SRAM initialisation completion with two
open-coded do/while loops. Each iteration is a full firmware round-trip
(PM_IOCTL/IOCTL_READ_REG of a protected PMC_IOU_SLCR register), so the
loop can issue up to a million EEMI calls, and it hard-codes the wait
policy inside the controller driver.

Introduce coarse blocking helpers, zynqmp_pm_wait_mphy_tx_rx_config_ready()
and zynqmp_pm_wait_sram_init_done(), that take a caller-supplied timeout
budget and contain the poll loop. The loop is EEMI-specific (legacy
firmware only exposes the per-read status primitive) so it lives in the
firmware driver, keeping the UFS driver backend-agnostic: a future
backend can offload the wait to the platform in a single call without
touching the controller driver again. The existing per-read primitives stay
exported, so the current EEMI interface is unchanged.

The timeout budget remains owned by the UFS driver (the consumer that
knows the hardware) and is passed down, so EEMI and any future backend
stay consistent.

Signed-off-by: Michal Simek <michal.simek@amd.com>
---

 drivers/firmware/xilinx/zynqmp-ufs.c     | 70 ++++++++++++++++++++++--
 drivers/ufs/host/ufs-amd-versal2.c       | 46 ++++------------
 include/linux/firmware/xlnx-zynqmp-ufs.h |  8 +--
 3 files changed, 82 insertions(+), 42 deletions(-)

diff --git a/drivers/firmware/xilinx/zynqmp-ufs.c b/drivers/firmware/xilinx/zynqmp-ufs.c
index 85da8a822f3a..81ccf61a037c 100644
--- a/drivers/firmware/xilinx/zynqmp-ufs.c
+++ b/drivers/firmware/xilinx/zynqmp-ufs.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2025 Advanced Micro Devices, Inc.
  */
 
+#include <linux/delay.h>
 #include <linux/firmware/xlnx-zynqmp.h>
 #include <linux/module.h>
 
@@ -33,7 +34,7 @@
  *
  * Return:	Returns 0 on success or error value on failure.
  */
-int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready)
+static int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready)
 {
 	u32 regval;
 	int ret;
@@ -53,7 +54,6 @@ int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(zynqmp_pm_is_mphy_tx_rx_config_ready);
 
 /**
  * zynqmp_pm_is_sram_init_done - check SRAM initialization
@@ -61,7 +61,7 @@ EXPORT_SYMBOL_GPL(zynqmp_pm_is_mphy_tx_rx_config_ready);
  *
  * Return:	Returns 0 on success or error value on failure.
  */
-int zynqmp_pm_is_sram_init_done(bool *is_done)
+static int zynqmp_pm_is_sram_init_done(bool *is_done)
 {
 	u32 regval;
 	int ret;
@@ -81,7 +81,69 @@ int zynqmp_pm_is_sram_init_done(bool *is_done)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(zynqmp_pm_is_sram_init_done);
+
+/**
+ * zynqmp_pm_wait_mphy_tx_rx_config_ready - wait for M-PHY TX-RX config ready
+ * @timeout_us:	Caller-supplied timeout budget in microseconds
+ *
+ * Poll the M-PHY TX-RX configuration-ready status until it settles or the
+ * timeout elapses. The poll loop is EEMI-specific (legacy firmware only offers
+ * the per-read status primitive), so it lives here in the firmware driver
+ * rather than in the UFS controller driver; an SCMI-based backend can instead
+ * offload the wait to the platform in a single call. The timeout budget is
+ * owned by the caller (UFS driver), keeping the policy with the consumer.
+ *
+ * Return:	Returns 0 once ready, -ETIMEDOUT on timeout, or error value.
+ */
+int zynqmp_pm_wait_mphy_tx_rx_config_ready(u32 timeout_us)
+{
+	bool is_ready;
+	int ret;
+
+	while (timeout_us--) {
+		ret = zynqmp_pm_is_mphy_tx_rx_config_ready(&is_ready);
+		if (ret)
+			return ret;
+
+		if (!is_ready)
+			return 0;
+
+		usleep_range(1, 5);
+	}
+
+	return -ETIMEDOUT;
+}
+EXPORT_SYMBOL_GPL(zynqmp_pm_wait_mphy_tx_rx_config_ready);
+
+/**
+ * zynqmp_pm_wait_sram_init_done - wait for SRAM initialization to complete
+ * @timeout_us:	Caller-supplied timeout budget in microseconds
+ *
+ * Poll the SRAM initialization-done status until it is set or the timeout
+ * elapses. As with the M-PHY wait, the poll loop is EEMI-specific and kept in
+ * the firmware driver so the UFS controller driver stays backend-agnostic.
+ *
+ * Return:	Returns 0 once done, -ETIMEDOUT on timeout, or error value.
+ */
+int zynqmp_pm_wait_sram_init_done(u32 timeout_us)
+{
+	bool is_done;
+	int ret;
+
+	while (timeout_us--) {
+		ret = zynqmp_pm_is_sram_init_done(&is_done);
+		if (ret)
+			return ret;
+
+		if (is_done)
+			return 0;
+
+		usleep_range(1, 5);
+	}
+
+	return -ETIMEDOUT;
+}
+EXPORT_SYMBOL_GPL(zynqmp_pm_wait_sram_init_done);
 
 /**
  * zynqmp_pm_set_sram_bypass - Set SRAM bypass Control
diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index 2154d6286817..dff0c2c95486 100644
--- a/drivers/ufs/host/ufs-amd-versal2.c
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -225,8 +225,6 @@ static int ufs_versal2_setup_phy(struct ufs_hba *hba)
 static int ufs_versal2_phy_init(struct ufs_hba *hba)
 {
 	struct ufs_versal2_host *host = ufshcd_get_variant(hba);
-	u32 time_left;
-	bool is_ready;
 	int ret;
 	static const struct ufshcd_dme_attr_val rmmi_attrs[] = {
 		{ UIC_ARG_MIB(CBREFCLKCTRL2), CBREFREFCLK_GATE_OVR_EN, DME_LOCAL },
@@ -235,23 +233,15 @@ static int ufs_versal2_phy_init(struct ufs_hba *hba)
 		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
 	};
 
-	/* Wait for Tx/Rx config_rdy */
-	time_left = TIMEOUT_MICROSEC;
-	do {
-		time_left--;
-		ret = zynqmp_pm_is_mphy_tx_rx_config_ready(&is_ready);
-		if (ret)
-			return ret;
-
-		if (!is_ready)
-			break;
-
-		usleep_range(1, 5);
-	} while (time_left);
-
-	if (!time_left) {
+	/*
+	 * Wait for Tx/Rx config_rdy. The poll loop lives in the firmware
+	 * backend (EEMI today, SCMI in future) so this driver stays
+	 * backend-agnostic; the timeout budget stays here with the consumer.
+	 */
+	ret = zynqmp_pm_wait_mphy_tx_rx_config_ready(TIMEOUT_MICROSEC);
+	if (ret) {
 		dev_err(hba->dev, "Tx/Rx configuration signal busy.\n");
-		return -ETIMEDOUT;
+		return ret;
 	}
 
 	ret = ufshcd_dwc_dme_set_attrs(hba, rmmi_attrs, ARRAY_SIZE(rmmi_attrs));
@@ -264,23 +254,11 @@ static int ufs_versal2_phy_init(struct ufs_hba *hba)
 		return ret;
 	}
 
-	/* Wait for SRAM init done */
-	time_left = TIMEOUT_MICROSEC;
-	do {
-		time_left--;
-		ret = zynqmp_pm_is_sram_init_done(&is_ready);
-		if (ret)
-			return ret;
-
-		if (is_ready)
-			break;
-
-		usleep_range(1, 5);
-	} while (time_left);
-
-	if (!time_left) {
+	/* Wait for SRAM init done (poll handled by the firmware backend). */
+	ret = zynqmp_pm_wait_sram_init_done(TIMEOUT_MICROSEC);
+	if (ret) {
 		dev_err(hba->dev, "SRAM initialization failed.\n");
-		return -ETIMEDOUT;
+		return ret;
 	}
 
 	ret = ufs_versal2_setup_phy(hba);
diff --git a/include/linux/firmware/xlnx-zynqmp-ufs.h b/include/linux/firmware/xlnx-zynqmp-ufs.h
index d3538dd5822a..00383dd835f2 100644
--- a/include/linux/firmware/xlnx-zynqmp-ufs.h
+++ b/include/linux/firmware/xlnx-zynqmp-ufs.h
@@ -9,17 +9,17 @@
 #define __FIRMWARE_XLNX_ZYNQMP_UFS_H__
 
 #if IS_REACHABLE(CONFIG_ZYNQMP_FIRMWARE)
-int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready);
-int zynqmp_pm_is_sram_init_done(bool *is_done);
+int zynqmp_pm_wait_mphy_tx_rx_config_ready(u32 timeout_us);
+int zynqmp_pm_wait_sram_init_done(u32 timeout_us);
 int zynqmp_pm_set_sram_bypass(void);
 int zynqmp_pm_get_ufs_calibration_values(u32 *val);
 #else
-static inline int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready)
+static inline int zynqmp_pm_wait_mphy_tx_rx_config_ready(u32 timeout_us)
 {
 	return -ENODEV;
 }
 
-static inline int zynqmp_pm_is_sram_init_done(bool *is_done)
+static inline int zynqmp_pm_wait_sram_init_done(u32 timeout_us)
 {
 	return -ENODEV;
 }
---
base-commit: 848acc8ffe1b7cd5f1bf427b93069becfebc2c9d
branch: xnext/ufs

-- 
2.43.0

