Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2056.outbound.protection.outlook.com [40.107.249.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0602135B4
	for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2025 11:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.249.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743076010; cv=fail; b=dqmd58dxD1c3mgxtDNLRHVE3RmO4ls6o2nb06/YkiQE69JsBrfiaO5zUwYJQIWOWIok/D+VpO22nTo/zf421sf63jtJinAsF4WHZyMKjOHHvxGhU+si3bwWMGvQIGohETfmk+8PVBCz44+wHS3/idGJI5Vr4DpyyKVtcwT4tglY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743076010; c=relaxed/simple;
	bh=Gtt3ClVKHBWLhoYVbzubaTv9IPGJ0mZV/qkeYBxPYR4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g9k2ZpOg4ieIWajqweXvj0xginYw7sRKjxfxMEcRjLqYJsqliHNMrU94Q1cKjMYrf6WJsMuhXwcbVX4/HZCFMDYYhsSir1jUFe4Rbb9LRuhW01KGPxXayrSYaiwA49T5u8mT0J1b1GZwkrU0OTJY2qQNOFgUIuUZCl52Y/FdBVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=in.bosch.com; spf=pass smtp.mailfrom=in.bosch.com; dkim=pass (2048-bit key) header.d=in.bosch.com header.i=@in.bosch.com header.b=AaI2Clzt; arc=fail smtp.client-ip=40.107.249.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=in.bosch.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=in.bosch.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=in.bosch.com header.i=@in.bosch.com header.b="AaI2Clzt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DFmlDtV4ONTibfQrKuz0O2CMnRf6HWGrA7bzD5qbm3/OcXB5DqO/5Z0rpnOp8mOpepoG3hTOT9GSLi+C6gWEVYtx4Cr6unv5h0lcz8l27dD0MOO51N9/sev+T9wt5YonUqvT2Kc/mBB3Lu3qHivh0THAhKlVbrlgSerVnySRckP1wZIGJQj3jr59flKiY8wLFenCACTbqMkH0zb5pz4EpCM2qgywecedcw5HpxyYJfZloPbT9DO6/6hqKfw/kuoy/oF3+rgJCRLpzPa9vkbJoqPqOhoxGoc0xhekG2UsN8OSadLp/fPP8OdUjYPG8hpL4nn9D0ODrgPxrB83ycS1BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kq4A6tvHv2GDT5F4NV5PzF8WB03DZ4B7riEVSfgn/F0=;
 b=aumhDyfQjcu98B6wcTw+2aDd6vXFNiRFC1CbcwQQMFzAT2ZWA+waz4qJKHZV/W9udnf1bf/yLHRgSMJS3KZYXuxfmmrkbFkQGbMU7F0fbl3MC71TAsNdGuHKzu8f3EWAtAiQSAOtpjDSiyxP1tQ6oOK+en/wisBT/Xa2ltif9GytrKSINnKRaYKZnoF23vsRqcVeL4uSqT+DQJXBT8Vl+xqObvmto266II5cK76dBMl1nGtXHxeoHRKlWkeZj9CPvqzu4IJiJdAC99rXwFRWCbpY79N5nw5VYL5CvVpbHjOdwScKnp7S2laIT+VnzQEvVwTnRurS4c4ZDC5djQR1lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 139.15.153.205) smtp.rcpttodomain=samsung.com smtp.mailfrom=in.bosch.com;
 dmarc=pass (p=reject sp=none pct=100) action=none header.from=in.bosch.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=in.bosch.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kq4A6tvHv2GDT5F4NV5PzF8WB03DZ4B7riEVSfgn/F0=;
 b=AaI2Clzt+9PgcU4zsxYzjWJRcUDLGQ7vlu6pcouvPvw8MGsU6FA3JJYUDJM0Mn3QpKugbKjaRtFz7LHXx/QFRr2hp5Fpmz9mndK0SJKSSw7oBAot5Nsst+Up51Kml61wNvHt8j0+wSCYeQymT6C3lpD98r2mjfXifoKnYQYxIySKv2u6NERL1zyZwOknNNwD76lQ3AXsjrxdPu8/Qi+akr8vc9QwwFHlvMiFtvXr2od+imHTF1pyAy4K+kjEofBQTcsBxf92fZUCdawpUKi6thq53epOxmCQLRd55efLnhRDwISaaNPdMCLJWdutB3Mn5B6uOeo/30+huNL/MbuFJw==
Received: from AM0PR04CA0099.eurprd04.prod.outlook.com (2603:10a6:208:be::40)
 by AS1PR10MB5214.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:4a8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.43; Thu, 27 Mar
 2025 11:46:44 +0000
Received: from AM4PEPF00027A69.eurprd04.prod.outlook.com
 (2603:10a6:208:be:cafe::99) by AM0PR04CA0099.outlook.office365.com
 (2603:10a6:208:be::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.43 via Frontend Transport; Thu,
 27 Mar 2025 11:46:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 139.15.153.205)
 smtp.mailfrom=in.bosch.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=in.bosch.com;
Received-SPF: Pass (protection.outlook.com: domain of in.bosch.com designates
 139.15.153.205 as permitted sender) receiver=protection.outlook.com;
 client-ip=139.15.153.205; helo=eop.bosch-org.com; pr=C
Received: from eop.bosch-org.com (139.15.153.205) by
 AM4PEPF00027A69.mail.protection.outlook.com (10.167.16.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Thu, 27 Mar 2025 11:46:42 +0000
Received: from FE-EXCAS2000.de.bosch.com (10.139.217.199) by eop.bosch-org.com
 (139.15.153.205) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10; Thu, 27 Mar
 2025 12:46:28 +0100
Received: from COB2-V-0002J.cob.apac.bosch.com (10.139.217.196) by
 FE-EXCAS2000.de.bosch.com (10.139.217.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.43; Thu, 27 Mar 2025 12:46:26 +0100
From: Selvakumar Kalimuthu <selvakumar.kalimuthu@in.bosch.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, "James E.J. Bottomley"
	<jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>,
	Peter Wang <peter.wang@mediatek.com>, Manjunatha Madana
	<quic_c_mamanj@quicinc.com>, Selvakumar Kalimuthu
	<selvakumar.kalimuthu@in.bosch.com>
CC: Antony A <Antony.Ambrose@in.bosch.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH v1 1/1] ufs: core: Export interface for sending raw UPIU commands
Date: Thu, 27 Mar 2025 17:16:04 +0530
Message-ID: <20250327114604.118030-2-selvakumar.kalimuthu@in.bosch.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250327114604.118030-1-selvakumar.kalimuthu@in.bosch.com>
References: <20250327114604.118030-1-selvakumar.kalimuthu@in.bosch.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM4PEPF00027A69:EE_|AS1PR10MB5214:EE_
X-MS-Office365-Filtering-Correlation-Id: 73642d1d-3e42-4f40-4ea4-08dd6d250b46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KJo1FZDo3f+uN37GuLPJqYwdkmgvv4sF5GcozddJrAnblEb5zSrzJfbpAdAW?=
 =?us-ascii?Q?h/GFE31gqlmltDu68Y2PdkwkevwlRNBplAj7sNq2slrtnDYsKAkumX8J6J0x?=
 =?us-ascii?Q?GhvY15V0DYRYqu+EFYsZJTb9ZJErSJsiCpLyUsx03KFwmZwqwAPtFy74Yjp5?=
 =?us-ascii?Q?dD7TVOaXtLFgM5H8erpPbdgz54IACm2RWe6aqZ1esLrX1OckbAw/1QGVfH/O?=
 =?us-ascii?Q?106G9bxx4n6xvQSf0Kw/fZIvH1C/ehYh8auY2AH+pDyA1/cuN+uiB7LP/22/?=
 =?us-ascii?Q?4ns4UepY6JU6cwKUYYobvYcTEVol3PbMDkz9T46hqcRyxY+7mjnmujxYZN8Q?=
 =?us-ascii?Q?hP6u8rKR4O1NvY01MsxtNqLz2QqrakuMXHEe/UkLH4hw905mmxf6epPPI7BD?=
 =?us-ascii?Q?E9BOEszdwEwdQnsXHFcLuxqhCPddYqPgdENv1FhWTRHQGvkHhDaJYQDio6QU?=
 =?us-ascii?Q?HzsO2GG+UWePdOrZ+BtMISSWrk7vndjx0goQRu40oDoHse+yoCqCKTpppnvn?=
 =?us-ascii?Q?468+oxI7hLUQI7EdQx9+TEKJRekQ6AkUID5fvErrWt6PURy85IEJb2fysQP2?=
 =?us-ascii?Q?0CpTRekYfhPpqNZjo2U4pjEAr0qbu7XggjI1bW3MFpT9KAJFLWKslKZSBIvn?=
 =?us-ascii?Q?j+IHJPvIMcvXvNYKTm19Jpg7cKOFdx6q63IgFNEBTDbnFTRCfuF9LgOlYomX?=
 =?us-ascii?Q?ZX+TqRC3RFvv+UfCcGWxBY6LDB0hiHQjp5DNn9OZN4b9s5CKHzdxC9XWTwIt?=
 =?us-ascii?Q?2NyEkMwQWWcQfKPFl247Q01r0ELsO7zcPh179WOls7D0BT3l/EqXhu1roE8v?=
 =?us-ascii?Q?ppY8AITXFpi/YxRRu/4ZPvUNMq37AngXVrCeyCFLWiNxdYHgsAe/nxHpzkVn?=
 =?us-ascii?Q?NtaP5v+iaNGUsSCSUAk+sqn3ndNCV/wU4qsHCbIwGezI66Z3vR83OP925vTm?=
 =?us-ascii?Q?xTATA07NExos5fetiHoypGL3OjcbNikaY9VNq3+H1ii9LqDM8d7IN3Q8j6C6?=
 =?us-ascii?Q?D67Qgg5aqKwaonOM3cSiLzN1vm7DX9Dx/vnsXSy88R/7QXXJ9Nk7eV/WiQ+i?=
 =?us-ascii?Q?3Q1wK8C5lbaLjjFrdwLlPfjGnR8IEo7oP6Zb1nJRWmqjGTI0ZZe0d09qwm8g?=
 =?us-ascii?Q?bLlkfffhUO/3a88TNfOUkFAgkBXWXpnyiC4aOqqzuPO6V7BbsOFQwlmp0ipn?=
 =?us-ascii?Q?jY9iZ1FXduwuFQ/wuVWzm/5V5RyzBPcd1f7G7SvrQkMIDXooiwgMlJBDariw?=
 =?us-ascii?Q?E81OMkwH4VDNzK40C4N710U+L7KfdO80codk7+Mr31X6MPj0/r0lSOhVh2Oj?=
 =?us-ascii?Q?X/upcQ0VJ5Hxx3/yeVintri6D5Rayv+1DzwhhVdvY3eYrSS0/PXlSo40WCUH?=
 =?us-ascii?Q?YVdsvHYTpA4USZYStkvIK7XgiMhYmRsMnjrILGRkLQYg95goKLqIw0RgFpid?=
 =?us-ascii?Q?xroK6XfUG5QcRWm5oaTg/yEDJyTY04gKG2WgyAhRkpim+/LroXgZ7yu/jJJA?=
 =?us-ascii?Q?Ut9h8J6v5nsi9ZA=3D?=
X-Forefront-Antispam-Report:
	CIP:139.15.153.205;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:eop.bosch-org.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: in.bosch.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2025 11:46:42.6227
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73642d1d-3e42-4f40-4ea4-08dd6d250b46
X-MS-Exchange-CrossTenant-Id: 0ae51e19-07c8-4e4b-bb6d-648ee58410f4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=0ae51e19-07c8-4e4b-bb6d-648ee58410f4;Ip=[139.15.153.205];Helo=[eop.bosch-org.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR10MB5214

Expose an interface for external vendor modules to send raw UPIU
commands to the UFS device. This allows vendors can create own
module to issue custom commands and retrieve device-specific
information.

Exporting this symbol enables OEMs to develop vendor modules that
can send raw UPIU commands from their processes, facilitating
access to necessary device information.

Signed-off-by: Selvakumar Kalimuthu <selvakumar.kalimuthu@in.bosch.com>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 78b57e946cdf..226cc90c74b0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7360,6 +7360,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(ufshcd_exec_raw_upiu_cmd);
 
 /**
  * ufshcd_advanced_rpmb_req_handler - handle advanced RPMB request
-- 
2.25.1

