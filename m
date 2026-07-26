Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16E8378D92
	for <linux-scsi@vger.kernel.org>; Sun, 26 Jul 2026 22:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785103869; cv=fail; b=tgDr/UwHe7hr59KfGIh4YTh32WgSxIXepRfZEfOd83NJXVALDZBAFpdAsyzidlCnlva4yXe2dGuIjya/oOOy2eW9fm9oHHeb0DnJ7ftPFCNfJuC5p+m231WEMQgQQLV/aDfl/f/zENfUJ1l5vuJNQzS4X0HV+yfc5aoBbgPvhmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785103869; c=relaxed/simple;
	bh=S58AMO18R3k5SzRPN83sOuwiYCYcb9kQLtO99t/T8M0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=r+1KvFSOv0wlwz87Cb+kn6NMX2ucCN3g064kLHb1xUmPX7cX3ShpF6fOQRXARJwkjxDr7Wz2XDFwc8XlbxFxtRt6VpEMXDWKOG77Ct4899AQRLm2D3FIQ1iwE2tgAeRRkNM9+6WCciBi4gKcVojeTAen9hUHnDoRBxsMaWEgjqY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VCH6R9Gk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rptqH87n; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VCH6R9Gk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rptqH87n"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QKqVXM666039;
	Sun, 26 Jul 2026 22:10:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=EQIQU4iuVb4t6cIKnI
	BdvEtZLr6ZkFfMSMY8Z4VMPAc=; b=VCH6R9GkUe8OBKkP4TXHJ1cLqfGg46Eu+T
	/d0LAwYdyhtHTkhcWY2cRt1vxMjajFNW5lskI2pMiAsWVjgEq71dfpehyjaMHLfC
	Sk5lSHZIDeniEME0iwiECnvV9zYq4VZXThQFQ1HaqXUWN6+FthVZJDCJKaoKYjsP
	44gYS4mCUeNYqroeR7PpmKOODCwCRdKbM1hn82qYW7CzhNiSE4GkkLZuGhmwVoEY
	IrNdRW6pvxuMYNPfVPcHoGmIalZlGBreFNsf9G0tDOG8PTFUzG0MzAnWa+hywAM/
	+SK4jGqoG3SUZNL80N1o9HfBd0WT/C5EnKpv3LP1E3WPSaDcMB0g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3ph1pt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 26 Jul 2026 22:10:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66QM52Kf010760;
	Sun, 26 Jul 2026 22:10:52 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012061.outbound.protection.outlook.com [52.101.43.61])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnheggxva-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 26 Jul 2026 22:10:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jw1Aw4tfpK2Yliv+zk2OdCKmiZGkxdKTa+0/647ZOFdKViW07sEirU3gkWCVPv/HcIcMflyYOTEvrjMWcHOy3tRxEsVB9UmDY/huDmOpdkkA0aJsn5APCscwTrIGhgOW6fLlPG7o5+Ejt1+BoeXRbRi4OoSaMdDFKRaGRh2ia3tn9iBgmk/9tjsRCSvYdcrAiOsPSD+LeXth590aigPVYj0tv0lmw0JO1SoQ/u2b9ye1Yzp8TndYc73/rH8a5J+Hx3JxhxAAMEXXHJCIKy+lrGIFzwDRxAlOWO/g9S3ow7SMYY9yG1tqNvebvBqwp0m1ost+PwAMq3TrQ0A/eKLW/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EQIQU4iuVb4t6cIKnIBdvEtZLr6ZkFfMSMY8Z4VMPAc=;
 b=Zvl9/HKuGnolVRJGsGoJhq7PYA+OQHEiEjpxaKhpTp8JxSgsvfgf5KlNGIsBHpkdYZ3yrOnbZNVLpQFJufCahuSIhv0QL2wde3gpq3MqNjlsG4yjnzLFBgewqsgOC+Qr1zhDHeLchm8v7SYJM12ShkPgSCNjOSMosPGZGMB1VoAxNSeBxDZNpgZviSDLgHDi3r/H1l0PbimzqN58m3obCKuT4hNya5F7cUTFQg0TapglG3j1Tc4fLbYTeph6tgS8sXEpRcjXEKbPLwc60i9sB1X5xgoT5ubm2ToIhGgBvcrV2NA7uCvxLkHG/i1z1TQe9GkKRBoYgclY6L5I+K271w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQIQU4iuVb4t6cIKnIBdvEtZLr6ZkFfMSMY8Z4VMPAc=;
 b=rptqH87n/FO3jCyfXZ5C/WQquK4/btbLtL8NynMg2dywKBO+8c1fiB15Zhd/7XKncENp3nHpqkt0SMtBI1lSzJlmcjtw4v7KLwCl8mbaWg6zZJBGNF7cOE+x3Mtt5sw6afxL9OeBKlb02t6XXiK5XlouHymxEkmxIWQhD20vyyE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SAWPR10MB998087.namprd10.prod.outlook.com (2603:10b6:806:55e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 22:10:49 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 22:10:49 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <m.szyprowski@samsung.com>, <robin.murphy@arm.com>, <hch@lst.de>,
        <linux-scsi@vger.kernel.org>, <iommu@lists.linux.dev>,
        <ionut.nechita@windriver.com>
Subject: Re: [PATCH 0/2] Drop SCSI core dev->dma_mask check
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260629085310.2298552-1-john.g.garry@oracle.com> (John Garry's
	message of "Mon, 29 Jun 2026 08:53:08 +0000")
Message-ID: <yq17bmhz9k3.fsf@ca-mkp.ca.oracle.com>
References: <20260629085310.2298552-1-john.g.garry@oracle.com>
Date: Sun, 26 Jul 2026 18:10:47 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0038.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::11) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SAWPR10MB998087:EE_
X-MS-Office365-Filtering-Correlation-Id: fb592f43-b56c-438d-07b7-08deeb62c00d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|18002099003|22082099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	8wEF4OgJ/eAmnqGeQ0RCcnCKUHGXEZc5PY//cMLcZ9mRrfY/5jKlWkYOKB339h9d5/k/yHDanvkCKx5RoDP8WpGaXRLUQ1MVG1Rf5u6gGMM5IPjjALYcBUv0rD1BAMPQQO50xHFnG+1Vrz91LwW1ZWbmIHUt9BTNYMdKIrQjroi3xeedmAEwyWD/7Pw2LPjri6zrJ6j1Ulm7sdejcXiRQ+j6p+qaRQwHQ7ax3swHBOWUn/OswyjWC8mnaxfbswMRnRbgTwFs8jzZzwmQ7DHIT8zfd3fA5JqbYlTKzIO4qs33n8DI7kXbwHuGiQiH0MfjbigkZe1XaiHWrY9bHkdVwpVnUuICQXGcrB8JcGM4spDKePtJHNInbpA6K8GKOI+unlBEFVQVq9Hc/PHP6i+ZQQiJpnPx72FMFdz9XYlFh4YfevbQkUGUkF4ckwKKfJTv0bzd9pM7Bj/dTWS9S1b5adELyMeeKyN2HHyNxVgR+izSHDV7UDokusRoj0UJQAVoB1MCmjJojMsyj89k01EMd/aS601D9cs4KjRzaQ4xzPpwSCmvdT9zfaaZh3lkcxI5WafabzKlPyiZszImxly85iXt1wvhHpBFMbeofI+z1iHKDdwp3V5KiIOeThG+PbwdjnSQAE8f3stLPOP9GC9JWhlpYMjxDcVmWsiyqhG65Yk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SfF/hYR43lYcUWIzqTIGNgI9H3eHKF7gmqjm6cTemf2kY9t7kCWVeALUwuUZ?=
 =?us-ascii?Q?hKTCN2MfL4gn4eKamZ0MtQ2Px1QhJtmu3WK3PB3PssVc6OZCPWgdw7SEdv9b?=
 =?us-ascii?Q?gMCYV48jbL4Ll+Ne4+FVpOLJcug6aPEuDTEpkDu6qR0zkikS0aQpTPGA120I?=
 =?us-ascii?Q?cReT+/0oqJ584osCcd+/KdPMcve+OyTSxhuLjeQtHWMabtA2P/Lbl0mSzEcs?=
 =?us-ascii?Q?PXcgUKXiv+SU5fhA4QtEc7i8qOHCwi7LybfFHuINGqD7cBBGugbahHRat0Pl?=
 =?us-ascii?Q?0Z6oBbNiY1nUvCnfqtz9hiJ+o6ZcsiTyQVqi7qOkGeiGKh2U7GWneGNohGWE?=
 =?us-ascii?Q?TmlNCe7cRB4lH6ForayIuchLfPk46b1Z1gvU36GvbXZhHJEN+ZkvAqsZD0in?=
 =?us-ascii?Q?5mA/uU1h8EOtKKI4NpXOt+IpCAsu8CCpDQj2CXZBhGLtkJJltKxcNS7nAkUX?=
 =?us-ascii?Q?w8a7Qavc4sp3lbgQ3K7ON2te62ZAquLcTXyArQJsu4AD7blTzgbSNdXfGYW6?=
 =?us-ascii?Q?fSBgSRrU4GPVIegTxue6HMBWw2iiSBdqiIfN3H7IdAoJw2KIC4E/J8YzKb5j?=
 =?us-ascii?Q?EtUG6iXl7N2ujIw1R9fSmMawPAq8rwEpmHYbuGs5xOw7T8MoziUzpueXzipD?=
 =?us-ascii?Q?lRe4uEVvtFLWAnRCtl89Xq9KNqtRVAG6oW1MgIj278xylAGhjFjhLAVroI1w?=
 =?us-ascii?Q?lXUbm7WE0dGoXVs5eAr9XFjvQrG1mkg7njl66t7YKPITorhSFXOYWrLxbnTc?=
 =?us-ascii?Q?Ffc84SYYA3r1ehkHSP5SBoZrcWICxzqxvdpz4Yydn8NJNEYOI27M0rJx2kNS?=
 =?us-ascii?Q?6IH1haSSoHvyiLEt9DUIo4bJ+t83mRUnRMwOVqOtww7F5Y2H6qPDdRAXBTLm?=
 =?us-ascii?Q?7Dq+pO/bbTOYJJ9pg+uWn4kFEIecu4R99GAfDejQdQLhjdC1PXlektFBzkeb?=
 =?us-ascii?Q?07eHsXrP3EG5+3Mbpl00H9B5pJl3tG4f8wDMy/qLCdz6YuIyLhMTsc6S1Owj?=
 =?us-ascii?Q?dg87EpHfaBKK86auV2cePBVgKZtnfDM7Z2BRI5FWzbHRUgA+vt81ZCiD6ldX?=
 =?us-ascii?Q?Qv3Fpy2bN9mkNFp0WTEWuwNdbNaGMN3c7NZz+0qRuntLDaFAhAPFGSJPduPM?=
 =?us-ascii?Q?r2aVaMLNTXR1eHLrNEfN01hSR3pl/dD2lpITeO/D4qb+KYw0AMNBknwYFaoj?=
 =?us-ascii?Q?RYvPkAh7hLe1MnWnqGDuVcKKWJ+jj618vVKiEXu9Lwp4RPTrx59m6omsIizQ?=
 =?us-ascii?Q?US8e1w2xAIkTcWyE4J8PXrMKM3/rJQ1vcJz2Oe/4Ha7SaF8uC6wV6IKbtdUN?=
 =?us-ascii?Q?9MhUSNag6DkRO9LAOyDJDH3TmMjrct0ZlxXacsKmA+RmUzsf+dY/02CbRmcK?=
 =?us-ascii?Q?BWLBatFK8HeLgumU4pwc9CttJCxeeyTdNnJbPn6PRzKQthcq7Kj6pRPYnpuU?=
 =?us-ascii?Q?Ce6L1Tw4BF85ZCCiXVOVR98McalQaoHhQRf04q/L1pmoxnVG6+jGG/Wsn0DJ?=
 =?us-ascii?Q?Je22Gfryi7OGP8EPcRNy+KsSpTwO6wVgi0p8O9H/Vsk1nphMPz/6Xpjjjwhq?=
 =?us-ascii?Q?E4HTTGrkZDt0nMGBbuf9Da+oykEGa1uf8LcH/Of+qX7DQto8U8OQBCEKW3YQ?=
 =?us-ascii?Q?93v86JrX3EZriEV25xr83Fze/goF4FBBIZHEV2HwdDTz3XlMXR1AeCv8hlNX?=
 =?us-ascii?Q?MbR4V86nyFDhDUOez0cBQ3i8ZDC16ADSRIhc60xc3UAd5Kjz5jknQy97ZCGw?=
 =?us-ascii?Q?X9ci/mIsesDx+uCJSQ2k/7dISxQhvZc=3D?=
X-Exchange-RoutingPolicyChecked:
	einniaJ4kTPHJT8xIC4q2chUjsxtyMPDDCAxLo6sh8tF4Ehj1PyOkdLVghX/YYQR70KMpxlBPdzVl4qRBVIAV8sfG+uYr/Lt9bLcO3YmAlrsk5ejF5FZiuAXj3PT5wcQh35oX0dj8FOzavLm4UWclbwNit5fomYYElqDxd8WDphvakCVkNEIkBmouSAnArD8RHVZaCJPUwk9FjRB6rImYFpRopGfKdl4Duv3+fZJScemUqPlLa5GRWco6QaHZY5m9508I7fw8FHALV6nh9KyrePgazSymm72KFpx93Kqs06JybWL8IueyKw0j5TsA5OWbFY5SNGsTzfAyV+2b70qpA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ueRQuT3V54ZBB3cgqxu6nijkXj0hIgKAQ5SyLoHsIIyUX+qxGEDfIT80V7d/1IrMnxIkDcqnv1JzyIG6bz4Nohi1NDPJYWEdVvgG17ehYgkiBzhmKdF772d2hhpJeSnlFV0Cr4MX4g2KLN5hbAC9X0JBZ2xXey8n9c8etz0b14Srync4Oy+hAus7CD/QuRHmne2/gPKrMq7vnF9/IDY5uJ83SQZDbXIWf4j7xr7yo8rvvRbyCdDh28eVrSODAlvoSTW5SHP5ccAToiOrI0eoS9lJfYWaDnfiprAzEAiB22Ski2FeARaW78r7Oso4mqne9GuPoJoNr5dPIB6p4RAFJRP8oXE/1fIbFNUrVK+GpC8UYEncH62ix41v8bC3+ENMDQKEQRXyRwdhCXvY2EytN3zez4zeKiI0gi4Q1foW+zHojYwdeuxTZRVAaJQHv1VxUQ7WpAZSq/Y5GuQ4dWzpdc2ehnevJfvxD4HWJC0PbONpw7cSNnsKNagRC/Rz9t1Mc46akXSX6C2QLVUIopMXstqKU3zVkijCzO6S1DPdyn3kRa3DyAtc4GYE4LWk98DuLeJ2BK3eLi8XuOG3OJkV7Kj9dvrY4bf1+2o/RsLYZ2A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb592f43-b56c-438d-07b7-08deeb62c00d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 22:10:49.5677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ChGq9IsX+wltaTG9riSJBJuxf1HBEJF5deaNDzQt7MhFZ5wOJz+5J6qh+wyk1W1waIewMzIYa1Afgpq72+dqQjqgPnddFS6Cxp2nMsMBnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR10MB998087
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_06,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607260225
X-Proofpoint-GUID: zAguEXl7-QqXo_EZ7G-js9FXu_ghPpdn
X-Proofpoint-ORIG-GUID: zAguEXl7-QqXo_EZ7G-js9FXu_ghPpdn
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a6685ec cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=8A10pE_Sxmjy0SfMbowA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDIyNSBTYWx0ZWRfX8LrVZudAqK49
 tH8fKhkAg6kK037S9n+ndTxUsmYRrPLzFTQM81s3s4Dg1ug0kNHAfiHY113MuSXmQjJzmiRphge
 NwZX0Fue1MBNUc5Pkzbd6HehUwrXDQorrVCVqiJnIhNHBszt5z8ANzH//KtuiIEKRTf8FZdYNM0
 ShyoRwwN1Pf+/HE92P8CLTz7iONAxtRHDc4/BN+6xwsaraTLscaK7j8x1fWIZd2NJeBhD5tH9ib
 Ax+iAu+Qcl8D+mXpg5Kgev9MFLq9rum7MM5xJ1s2LPfPQQb5WIwIwnUudIgtmDuSd3TMmebxV3U
 HgzVT49CVdLSooFRI0ZA40+TBy9pB6xFrZmPjbm8qR+su9TPHBsy+W6uui0RHcQJ4NLcL433IyA
 n/3IhA2mN0VrOXmDZxPlbrGWd/3JqkpAJ5F1bhYhltWL8dXdsRnp8adRDytGUmwczZILi1HUcG3
 42xWouWMZZajQD9jNBA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDIyNSBTYWx0ZWRfX2U+YUCa6Kyja
 OalTao27SD93OB+jfInvIaRp0kbBLBUCvw6PBZSHgBdVX48rMTPfTQoP6QjWh0tpkoeZc1StGkY
 zo0VfS0AdFr2vPPTnKvqsfxzvdI10v/4y5qnKzhtkBu2pcodIURv


John,

> In commit be8fcd4a8217 ("scsi: sas: Skip opt_sectors when DMA reports no
> real optimization hint"), the check for dev->dma_mask prior to calling
> dma_opt_mapping_size() was dropped.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
