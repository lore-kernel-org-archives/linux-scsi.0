Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021137.outbound.protection.outlook.com [52.101.95.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF774471D02;
	Thu, 10 Sep 2026 16:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.95.137
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789058613; cv=fail; b=f0A+vwpOBuPy/9SY87xfrxIwT3akwl/Z7rA8ri2dlITSWhLRue202YYBZ3Xv31v0uq2SucILDjDXgUgH+3tuDu/sOHOg4DR4HfFQBKERqIdHZQarRcJGrqTFwHRhUbWlDjtpHtPDda9Hflm1as6lAaB1stfj4Mf6kUTIfjXb0IM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789058613; c=relaxed/simple;
	bh=LnkPUs8Vz8p22GDgf9p4OU1PLE1tJcz8BCu0Dteq+Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KVrJ4esB2cX0SjsRQt4c4btFWvxiUPiBYGHTBJAVrPBnShv9jsMxWwXv/Kdge9umzZN/eLKVurlJV9sXMnk3NeV3oBrdkstDDU7yvwJ2k9zi/QiV03SN3I5UD8c6I7Ggnx9xOur6DycZR5dzfENcrTaAYzfHWXDbIpgvPIcUl3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.95.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a/dSqjY/9jCUnwX49wqzzqncq/ueSPx4ewZt6Qkb3KWYWei683nyvW+R9tzkSGsynT0poVbIR4R2YSshP/eOVqhy5fjDk8v6om65SaCLdm1OHkP/v6K+ps4p/zXwdk0yx8RIIr0lnWwRx+iNh0TvSYyacP9VJdxClP3jHnvM1qGSRNiLwgiRfy1dgTS3uwMdRPlM+o/ibtOx1FrjTqnJVHoig7NlC8AJqJIW7EygGwd2lRaorRs/KaEfemscTT56/bp0BrH8sEDb3VJ71a5gAJAaTC/wwczQVOT9Rp+9m//g1cKgckwJ0kkG4H9+eLzFMP8RoDDSZxP79Yf+SXBxJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=bJ+B5Mzhzc/vkAtQlWYHFZ7lwRLodwb5bHEtIZ2braA=;
 b=O90E8oCe3TCQTKtIEnGdgU8J7HfiVJnD1ytR62/AhKvnRdVV6tBuicGjxweQ6m0tO7iZRI+Hw+/ZpGmnxAzZvn68g6LH/4CwAGTuCnrbRMrAKiryVseop6qeCNquVCXsEeH5QV6sSjimMjPEDjuhUmPQvUPc9ZAZGo+BH8RSu9k0b/XfgL+Elvk96fyNlBZbS6KGgKkyCXfNZ/87w7pFpPsHtqFh/Hwak0vcJdU/t9iuMCos7WcbEcAb+OrY9JJ3CNjZETWK43UYiBbrYNux1nT0HmYobCpFJxAW9KrVE7byeNRUpfBb+eMgYUa4724IbnAZAzVEPEPrsow0J6uyEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:183::5)
 by CWLP123MB4179.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:be::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 16:43:24 +0000
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230]) by CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230%4]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 16:43:24 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: axboe@kernel.dk,
	tglx@kernel.org,
	aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	frederic@kernel.org,
	bigeasy@linutronix.de
Cc: atomlin@atomlin.com,
	ionut.nechita@windriver.com,
	corbet@lwn.net,
	vincent.guittot@linaro.org,
	mingo@redhat.com,
	peterz@infradead.org,
	radu@rendec.net,
	akpm@linux-foundation.org,
	steve@abita.co,
	sean@ashe.io,
	chjohnst@gmail.com,
	neelx@suse.com,
	mproche@gmail.com,
	nick.lange@gmail.com,
	marco.crivellari@suse.com,
	rishil1999@outlook.com,
	linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v16 9/9] docs: add managed_irq_strict flag to isolcpus
Date: Thu, 10 Sep 2026 12:42:37 -0400
Message-ID: <20260910164237.500196-10-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910164237.500196-1-atomlin@atomlin.com>
References: <20260910164237.500196-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0034.namprd18.prod.outlook.com
 (2603:10b6:610:55::14) To CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:183::5)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB6607:EE_|CWLP123MB4179:EE_
X-MS-Office365-Filtering-Correlation-Id: bbccfb6f-2bc5-4f53-0d8b-08df0f5aa1bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|10067099003|56012099006|6133799003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	bEiayBMSZcRnZdrYpwyzx2GHAJAQqoHUImcvEnBALidvD8bNDv1p3/gukcX4VB/5EbKdYuDG4/Ku9ntogIzExHaK7loxuvTii5jRYkQ+8ujtdE5pynttehLoWnsz2HLDPAhHG5av9oUgnxq2m7IqqkkjsCKP54sqdljKDz7T2pSF+2vCRhOuLhkNVNKkIjMnOEqpRKxefif3B988rrKjQczsSt9Hu9nzFNT5L/xsOR3geXT4KQHUPVJXD0K3K+OKCNRVKrLmaw9dhYCr3EYQebxQLZMn3dSkUIb3R1AjmRMjI9loLhAkXJcp3amsqgeNxJuVypcDkx6a5mMK6rISmzMuIlVpmj4Sl2Gd3U6pxDqZCQREAy+RiE0h2895uKopwCvdwfjbpWUPvzVh1Ne1UX1t7p6O9N8RZN1F8XO3OfQOmmpRWflwkRa2gIj4LravffJFo8BrAVfYiNjgoiUgkNAjnLvzFghkjvfPSbu94jQoQLw1UvmgGgLPXdlRuvUEfsm4vchg8jPWRwR8KxiNpqu+xUlsUjXuY1Eb+LOR92Ia9k3PVZbUFv4KEzca+SKkMikXd2vbm14PkYSkYRdtseZlsZleD+9n+no1M/TetIdhofgFhRMmy3zGqSXoKGAfTRD7EcD8o0q7xy0rKe4+fwGWw9T3KQYF7uPnN69DJdU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(10067099003)(56012099006)(6133799003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GRlCz6+aM+1vSgP+rFsuahenb7DLqDKFHNKRA6h5SM1elnF5j9a1YTQt9Ayb?=
 =?us-ascii?Q?x5Iv0K66rr+iwy4yiZCeL4ODV+286Z3rwA5AVG6Mg3CPMAbEqU1aI7DWVCch?=
 =?us-ascii?Q?iHjQ999i4lTjIPnO+ecSq9dx9Jr2rWIHCPskyuTZrdCEYZj95GmlrzfIJYbd?=
 =?us-ascii?Q?Y4SViMv47V3n3OuXb2KMfpEFn9cvst51j1NHNth/ICK5QOri3rztaPR5GPy+?=
 =?us-ascii?Q?WGoOE/u7GwAsG7AMkEH45TQ/f8fPKVaehlr5AIuiMt0atZbBCxeYh0+Gc0sb?=
 =?us-ascii?Q?PHkAzWcy6Q3WFWd/PQnHJ8Y5A/gV+iPD2OZ5mey2/qy2juLASRdbpwFpBxo1?=
 =?us-ascii?Q?jFOA5UNBWkRl/dCEwIA0nMOJiAB3hsnTXkdjMGhIlLNB7cfQubm562jZfcob?=
 =?us-ascii?Q?NM7M/cfsJ/yzkduOLtlrtpvjro6Y0e0O6m1JP1GwQMqc0pXwkwL9lNJ1S0hV?=
 =?us-ascii?Q?gu2XEzliPKTlQfhz0KLO8Ni4dIkxHog27N7DFBVdKIdEeu6CYL/VPQy1pRHS?=
 =?us-ascii?Q?2fE4VoA73eq6s3VY7OXxX19hydxNUHiJ54EEGTYQn0bKKepXUh7vHCs3Us/I?=
 =?us-ascii?Q?RnBxJvEkTKNx+YMTEwcpxaDl0zIxj7HAkyMXsX2ygCAoiAwHGZMa5DA6fwt6?=
 =?us-ascii?Q?muX2tQ/3E0ovWQpH+qDfvEQfvTRYyh4RfegNlP3HG0uhQRUE4XXKGB5rsJ6i?=
 =?us-ascii?Q?lYXoiMl53QjeP9Ra0Yu2AdPlZa5TfQAX2Y49k4N3rEpMYi9By32gKlv7ms7+?=
 =?us-ascii?Q?W9Jx9bHHer8gOnwYZT2Bsv1shlw/0qEzxBOTw/8djh9MyRyu5wAXjYlM5cPl?=
 =?us-ascii?Q?dxRPQv1ScARm9yvytGNG8F+vPAAW0DlLeMCnq239agdYpaIfYAfQNu+6CRKg?=
 =?us-ascii?Q?LSC91Qe+OKSzbKoWIKYUB/zW+5YWsIC6bgp9PFUNdbVrCIEE6GVQ2NCNgWJA?=
 =?us-ascii?Q?SSkUcGcKsR8Yd1thpgwU4KQ+f9EabGbWgCFfUHYtgBLqwSzPjOCRCzhYgm5j?=
 =?us-ascii?Q?Iq9EpCvolAWM9x79VLde8ayWPDvoSmSen7tgFbUlUV4FyXAvGWjNns9vGFvT?=
 =?us-ascii?Q?G6vPZ8FXJgXwbK3PXKrjMOGtxSrPLT/m9gwY0zVVixNLUCy7TEW9mKQPzSRl?=
 =?us-ascii?Q?qlAbolIukX3M2KvqamGG2KXbJAN3oBfsIq5heOt3Y/3vuLTg+24+UaN/84Ai?=
 =?us-ascii?Q?usRnBGCcFDU39MjPbxPJTuwzpUUq0ef/3iAnxZ5sYLAf8jRN6IctePBntv4v?=
 =?us-ascii?Q?zEeM5puLeddrZ4E3l6bYXEId9pHuYzFIFoRyRwxukGCvNOGITYxSBtU+W1E9?=
 =?us-ascii?Q?j0YyxHTF4H1OdAkUSz54bqgWqXkTVgKILSs4L+wLZeF/NdK9qN2OK09gzEOH?=
 =?us-ascii?Q?y9kixhIsGJB9QqQdl9O0gEvP/E3nOrX5S1VHloP3CiozqBfqGCIEw1gqH4KP?=
 =?us-ascii?Q?fUOy3ciqn7kqxw7BatMcyI8W/iNYFCYotq4XIFx8qbwBCF/yWlNNTm9yQc1I?=
 =?us-ascii?Q?GzmOE3tjjdqPNyTZVbZz5wpSrc/avsaUFGFSTxTyhJsYWsIsCY/OJlJaz+rM?=
 =?us-ascii?Q?a1vuGL5yYHHaUBBOll617iEn2erggrLfSMIxMtZb3xa2GHAdqoHzbBnrsraa?=
 =?us-ascii?Q?dk8k6x+rCVMCBz1nsW2JZsX+qJkQsSqhPgk4xq/HiSFH6uTDDrr3A/jCVif8?=
 =?us-ascii?Q?ZAg3eioc06ZLgpf3WQ+ipW7yBx2n5Co7cyT5Dszh2Do+l0oRoNSIr+3EleQ9?=
 =?us-ascii?Q?a+jadWwDww=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbccfb6f-2bc5-4f53-0d8b-08df0f5aa1bb
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 16:43:24.6534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xGssOx2eql90NgivJLi4uzLhcoElFZFsk0c2DIF4mM81v13EZ508K4Cf/lz/9Pt7lNeQWwuOwOXAnCXLVcDTBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB4179

From: Daniel Wagner <wagi@kernel.org>

The managed_irq_strict flag informs multiqueue device drivers where to
place hardware queues and managed interrupt vectors. Document this new
flag in the isolcpus command-line argument description, describe its
relationship and precedence with respect to the legacy managed_irq flag,
and document HK_TYPE_MANAGED_IRQ_STRICT in the core housekeeping guide.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Co-developed-by: Aaron Tomlin <atomlin@atomlin.com>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 .../admin-guide/kernel-parameters.txt         | 37 ++++++++++++++++++-
 Documentation/core-api/housekeeping.rst       |  6 ++-
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 68647ff4bdd2..eb608e5139a6 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2822,7 +2822,6 @@ Kernel parameters
 			  "number of CPUs in system - 1".
 
 			managed_irq
-
 			  Isolate from being targeted by managed interrupts
 			  which have an interrupt mask containing isolated
 			  CPUs. The affinity of managed interrupts is
@@ -2845,6 +2844,42 @@ Kernel parameters
 			  housekeeping CPUs has no influence on those
 			  queues.
 
+			managed_irq_strict
+			  Strictly restrict multiqueue hardware queue
+			  allocation and managed interrupt affinity to
+			  housekeeping CPUs. Unlike the best-effort
+			  managed_irq flag, this option guarantees that
+			  managed interrupts and multiqueue block device
+			  queues are never created for or mapped to isolated
+			  CPUs.
+
+			  In the block layer (blk-mq), device queue allocation
+			  and CPU-to-queue mappings are restricted to
+			  housekeeping CPUs. For devices using managed
+			  interrupts, hardware completion interrupts are routed
+			  exclusively to housekeeping cores, shielding isolated
+			  CPUs from I/O interruptions even if they initiated the
+			  request.
+
+			  If both managed_irq and managed_irq_strict are
+			  specified, managed_irq_strict takes precedence.
+
+			  Note: Using managed_irq_strict restricts the number
+			  of allocated hardware queues to match the number of
+			  housekeeping CPUs for single-set drivers. This
+			  prevents MSI-X vector exhaustion and forces isolated
+			  CPUs to share submission queues.
+
+			  Note: Offlining housekeeping CPUs which serve
+			  isolated CPUs will fail. The isolated CPUs must
+			  be offlined before offlining the housekeeping
+			  CPUs.
+
+			  Note: When I/O is submitted by an application on
+			  an isolated CPU, the hardware completion
+			  interrupt is handled entirely by a housekeeping
+			  CPU.
+
 			The format of <cpu-list> is described above.
 
 	iucv=		[HW,NET]
diff --git a/Documentation/core-api/housekeeping.rst b/Documentation/core-api/housekeeping.rst
index ccb0a88b9cb3..6d08c71e6c0e 100644
--- a/Documentation/core-api/housekeeping.rst
+++ b/Documentation/core-api/housekeeping.rst
@@ -23,7 +23,7 @@ CPU. It is simply a CPU that can execute housekeeping work. There must
 always be at least one online housekeeping CPU at any time. The CPUs that
 are not	isolated are automatically assigned as housekeeping.
 
-Housekeeping is currently divided in four features described
+Housekeeping is currently divided in five features described
 by the ``enum hk_type type``:
 
 1.	HK_TYPE_DOMAIN matches the work moved away by scheduler domain
@@ -44,6 +44,10 @@ by the ``enum hk_type type``:
 	to HK_TYPE_DOMAIN except it ignores the isolation performed by
 	cpusets.
 
+5.	HK_TYPE_MANAGED_IRQ_STRICT matches the multiqueue block devices and
+	managed IRQs strictly restricted to housekeeping CPUs through
+	``isolcpus=managed_irq_strict``.
+
 
 Housekeeping cpumasks
 =================================
-- 
2.55.0

