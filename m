Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11012012.outbound.protection.outlook.com [52.101.66.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516441F94A
	for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2025 11:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743076005; cv=fail; b=gA35dwAw/JWP2OKnhQQht56JFiNeWm2/mjkHezhl2rDi3nJHxFySpCMn1Iiej/rz1m4Fd7GTFVKpL8bbx2GkbEGXrgrKbYuWE0l/Sho+5mwJYiLbZIrg3DRqjJqZWhIXrRgFcdKbPR3gSmnrq3ndBQRPG95gxcoRJ+0+iCFIa7M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743076005; c=relaxed/simple;
	bh=3yP6GZTFrWT9hIA/iDlNUOALxXuNcncFwNZyqJmViT0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ygukg1HwbH7JkNK6rcyGJWjZWrJFDcQXjIs7xPNxlGqLtrpL9wLqptjeOBmFwgCmJGe/hA1o8fpzlTPQJsV4Dk2YC59tcHyLvULdE45dUpygJfNFUAZo8ChL7773p6QaHcrEoWU2RG/7L7hs/5/pPiFiIpHqVD+Y4FwL+CvO8Qg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=in.bosch.com; spf=pass smtp.mailfrom=in.bosch.com; dkim=pass (2048-bit key) header.d=in.bosch.com header.i=@in.bosch.com header.b=Q/LDpM9Y; arc=fail smtp.client-ip=52.101.66.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=in.bosch.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=in.bosch.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=in.bosch.com header.i=@in.bosch.com header.b="Q/LDpM9Y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZcUdc2qzGd2WRJlMhsEJSsyrfUL8Mg8R+Rx2TSGVwEp1596I1CGJTGuXRJA0394kf95SDBlWgrs1Jfynn3cyBfs01eLrGE1vnQ4vX6C4s3+eTrvR0VeQChhQkROcjwIHaRE26gZwNaKb/rUnb1HZ8fMzwlNzlOtmzzEqqNdW7+it6k9ffYzA2aZijgp0cBh9lbnXyQt6gnE47txKt1aqtJ3o4ErVOGE31XeoFWiLNL6h4ia0L53//zpu6lEUJ88JWyjkoEC9l6wRZC8+gCBEbgOo26LQy1LY3iBZtILno7qXi9KY/cMwvbXtikllPKnhJk2VWQafWsPYNVyLI4QKog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zCM6NEmfjRyljh34dLPu1ifKHMLLzhXUANRuSUHkkIE=;
 b=rzZr8i4WTrx5HwwBgMlEa2e3zM0tsTq8i0pdMMqpH1/DUhusWHHv4aSqF36h19p77KDiIFA8eF7YnQLZtbAuJN5TPzu6QDvrQrh+znwY1exVUtrD5H1GVRgT5dmM1bayC0vBBk6ig/3tSbUY2eL49qgYnZI2tGFhDieiZ3itWm7KRrPM9p8mL6CAb0HMAnG6oj/2MN0q+/akh5u9j76maKdQ3ocx47mV25wG/a4Aer5DiPBhWWrivoBSExkM/xNdo0N44ID0p4yivtlbVEXJSIlCkIQv3btzFHlWmjYz45HSDF8GmxjV2e6RpnXnvlWdzqRtp+BXheqXYDuaMCHgzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 139.15.153.206) smtp.rcpttodomain=samsung.com smtp.mailfrom=in.bosch.com;
 dmarc=pass (p=reject sp=none pct=100) action=none header.from=in.bosch.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=in.bosch.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCM6NEmfjRyljh34dLPu1ifKHMLLzhXUANRuSUHkkIE=;
 b=Q/LDpM9YcOtgcV9ef+wrwjTwv8aVbLIKh5mGrARAIkEBuHclV4eU8LK6m1ge/HhkDiyrKGQVX0hjDVBUnaOoY3UwruDD233PPDGm0+irXLTXNiQEkdAxQwsGhg4D3AVa+zmbuZjyzi+I/9cZ1RFr32/q0ppRhwh/dNKTSs/tumlcfBapk1GyKtwzgT67KCqmJklpJBoxm/vKuRJU2fDGoriAF/uvEDcq1vqZLmkdLTtLLERo8K4CVTabbFAbeYPwNAMimP/7VF02Eyd5uOT+Quz9ga07uVzE7X0XQA1TqZHZKdLF7RMjdUsiNx4YY9AdlhEmep5/aT2gBn2za64fMg==
Received: from AS8P250CA0014.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:330::19)
 by DB9PR10MB5528.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:30b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Thu, 27 Mar
 2025 11:46:35 +0000
Received: from AMS0EPF000001AE.eurprd05.prod.outlook.com
 (2603:10a6:20b:330:cafe::7e) by AS8P250CA0014.outlook.office365.com
 (2603:10a6:20b:330::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.42 via Frontend Transport; Thu,
 27 Mar 2025 11:46:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 139.15.153.206)
 smtp.mailfrom=in.bosch.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=in.bosch.com;
Received-SPF: Pass (protection.outlook.com: domain of in.bosch.com designates
 139.15.153.206 as permitted sender) receiver=protection.outlook.com;
 client-ip=139.15.153.206; helo=eop.bosch-org.com; pr=C
Received: from eop.bosch-org.com (139.15.153.206) by
 AMS0EPF000001AE.mail.protection.outlook.com (10.167.16.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Thu, 27 Mar 2025 11:46:34 +0000
Received: from FE-EXCAS2000.de.bosch.com (10.139.217.199) by eop.bosch-org.com
 (139.15.153.206) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10; Thu, 27 Mar
 2025 12:46:22 +0100
Received: from COB2-V-0002J.cob.apac.bosch.com (10.139.217.196) by
 FE-EXCAS2000.de.bosch.com (10.139.217.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.43; Thu, 27 Mar 2025 12:46:21 +0100
From: Selvakumar Kalimuthu <selvakumar.kalimuthu@in.bosch.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, "James E.J. Bottomley"
	<jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>,
	Peter Wang <peter.wang@mediatek.com>, Manjunatha Madana
	<quic_c_mamanj@quicinc.com>, Selvakumar Kalimuthu
	<selvakumar.kalimuthu@in.bosch.com>
CC: Antony A <Antony.Ambrose@in.bosch.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH v1 0/1] *** export interface for custom UPIU transfer ***
Date: Thu, 27 Mar 2025 17:16:03 +0530
Message-ID: <20250327114604.118030-1-selvakumar.kalimuthu@in.bosch.com>
X-Mailer: git-send-email 2.25.1
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
X-MS-TrafficTypeDiagnostic: AMS0EPF000001AE:EE_|DB9PR10MB5528:EE_
X-MS-Office365-Filtering-Correlation-Id: e0314323-08a4-4139-ad8e-08dd6d250660
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x2C+KT0FBHTDKRef+3dJ3Oa7VG36F3ldKDgL6Nra9CAsVUGgolQC60QwQlcx?=
 =?us-ascii?Q?DSbIg8ihPS7fB2q2CYE4kzWCANVPHMWBhlD8Y3vRoikng9IiEv+uF8JyJ8+o?=
 =?us-ascii?Q?k+jRDVH6oC1wUgIruMDVZivXhedtH/dzFHsy7Omzb9gq1C+pTWqLHjPTqsAH?=
 =?us-ascii?Q?iwenAQFtWqmhOwN6e7y9uWIoccSJrITRVk3WRc1SN4do74DGNVgSD/xBTLR3?=
 =?us-ascii?Q?wLClIpDFKJABBJk7VTG5nS7DluHV4TPBAkBph/ohqRQaF93psJrwUvO6648N?=
 =?us-ascii?Q?cIbv1LoWKCU5p6hI7QF5WHEjWtM1FnqgfaHqTBeCmtpZksGlT80zIcPAWyRD?=
 =?us-ascii?Q?G3CuHxcOCFB5HR/9OsZs7AljMa98UZmTssZuiL/zOJ65rBfjtc+7WZpc1gIg?=
 =?us-ascii?Q?7vAUYbQvzg+VyPklnPS0Qw27wvseMV/Lqn16fUuduiyl+AFL2H3Q/U0EsGeo?=
 =?us-ascii?Q?q3OvDlPw/wJTVwdq6lvpdpGch16SJxHTSBqScHYX1DKWSHk/EIZqHTmTzZ4M?=
 =?us-ascii?Q?/tCBfDz70AOSxyXq7nhCLCYagw85d6mUYwUbAsjsfs22uyBU9zkKfJCtzyJ/?=
 =?us-ascii?Q?aOpT86/77j8dfdBSM6xjTcH19850Xz8HUgSvP1rvgUNwRqHyr+/PoKS0r8dI?=
 =?us-ascii?Q?fglP2oy0bPGcT6CDG2PP2bfx4Dx6RzLoVZs/Ll/tbIspuK9mawEYGLvsRNme?=
 =?us-ascii?Q?QsmmrnyJCyBGnRs6N7NDZUtRkeO1SXHNBhcO8YqQN16owwFq69hgmvBCpZ7L?=
 =?us-ascii?Q?QB9QkVD1V6UrFgFaeWDfLCcDUJ82kSSTjCDWMc4sfoUevHhvXI02aybxqPQi?=
 =?us-ascii?Q?+LqCGFhEBVOP9HF5UKoKgHhRq/7bo8I77DS69VZCBty+KnHIReLyf/Nu1vwg?=
 =?us-ascii?Q?jOQ1ZtDDvSg3VQBYFuTqApT9BubF5JO9JpyCzhmJejcD62Ff93vjAf/8L5Q1?=
 =?us-ascii?Q?WXI1J4QrQqX08KYz4pFljV5i517XAbQ0+/OkfsuLNu6wisitk9EbdSyV7KjO?=
 =?us-ascii?Q?X/ZNkn1N0y79C/4was4uGaLnbHVvavjVeRDoevXbeKznHbwht7y+3B0y5up1?=
 =?us-ascii?Q?WaAzdlcoiknaTqrKAKsFrU7k+vuAJJ0FFV5UwhNU8qklLj439D1yc1B/4Nct?=
 =?us-ascii?Q?k17vdThX7I5kUsVKbupmxUcoEnYdWVJelDh5C1Tbv6NsIXUKm1lmg19rDOIC?=
 =?us-ascii?Q?HYrVAuTrwSzVpO4TnhKL7dDwo+Mn+nVmEKcYwuoT867qeZdkzR7NyN12kRwA?=
 =?us-ascii?Q?TsfXk42pMRKY6+3ejkTwHoen59o2R3wDMKY0ZOS0IiwCQzrjsG0XB3mTZ2w4?=
 =?us-ascii?Q?z63MOmMq0zDVynGDi8EWkcagX2ld0sklusc15oLZCCZP28VDky7s+Vhm0Egw?=
 =?us-ascii?Q?gU8z7k5PqX1aq3zSCTOxNEkx+c7yHA7sXSgGjqayE/We5gMPsygdOYj9HCDj?=
 =?us-ascii?Q?Jbd57XMv7pWNw7k+yb87j+ua3Ig3ohuMaRpZ/oBO6c4lBiyAEkFXcmu75Ry5?=
 =?us-ascii?Q?f98wFjjKNbe7qjY=3D?=
X-Forefront-Antispam-Report:
	CIP:139.15.153.206;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:eop.bosch-org.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: in.bosch.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2025 11:46:34.4070
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0314323-08a4-4139-ad8e-08dd6d250660
X-MS-Exchange-CrossTenant-Id: 0ae51e19-07c8-4e4b-bb6d-648ee58410f4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=0ae51e19-07c8-4e4b-bb6d-648ee58410f4;Ip=[139.15.153.206];Helo=[eop.bosch-org.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AE.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR10MB5528

Exporting the API ufshcd_exec_raw_upiu_cmd from ufs driver helps
OEM's/vendors to send their customized UPIU with the different
vendor specific transmission code.

Selvakumar Kalimuthu (1):
  ufs: core: Export interface for sending raw UPIU commands

 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

-- 
2.25.1

