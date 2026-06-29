Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BB43E0C4D
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 08:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782723235; cv=fail; b=pr0Dbr4CGmWyK0G753RZEuP5EMF11ASpJMuzoEjt+r4qyhB7yPy5QKzAafUauC1l+8hikP5+i9YT13C7JB4mmBXpZqKH7udjy29PRO6wgaZY/JVyrNLNCZ8SFyMhJ2BmJISTXMpfb+eRp0oH+aDQw0w+wd/xv0snDIr4cbBG8yA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782723235; c=relaxed/simple;
	bh=VecVvgrKGMh0vCQaWL1zoJt+O3CQWiE8Q/Pw8nVw5HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nkx210sxjtujXzHwDlQBkd6D0yXba6llq8c6ncCJ7Rdkh9+3hSn+N2jH8/Y0HCAexKWnGdQKAMpJSDVfoctT9aWZiIaQKHFqRh8ljlpSxx4y+iqHE0isoVQE8I/XHjz4dAPnEDBEiNhBDYII0oeDznNM140y7o+r1sn9E5ikw84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sZv/ATRE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xUYX/BaF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sZv/ATRE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xUYX/BaF"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T1epGJ759786;
	Mon, 29 Jun 2026 08:53:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JqYKS2vgFvnM26nA4DP5j4X/SPrHJZeAJnny9kDhg3c=; b=
	sZv/ATREDDL5LqPlI/d9mXZpaWTAEE7bX+C+6NebdVQinjXKF8NXeh66PXx6a+0U
	UAjy9sE/cWJ+WX9Hco7LKGbARhCqVDAcZy6Bkx/A5nWOTjxVzfKJZSIHK0F0XPZc
	2ds7T2jNLqXHSfiLoGcfZGsEXWBJoU6gJadrR6Emtexbk9eLx97Z0vmkNw/c2CrZ
	nxXo6Y0zYB+eI8ErnZo93A4xjyeD0595kmKSHWCRAMoJKTge2mx/jUUcQRvrMado
	UehBlZWIphAyYL26mf/AASFz0WqwFhs+cSbv7ItS0quDDYRZYTjLQtzXUie0NpmU
	gJebBS6NUFmKqjEr0+J1gA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26kf9sm3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jun 2026 08:53:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65T8c829015665;
	Mon, 29 Jun 2026 08:53:42 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010033.outbound.protection.outlook.com [52.101.201.33])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f24ycph1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jun 2026 08:53:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UOlcUiL6cu2qH2qD+WQ8XpOSIM7s5mGuxW9JvyPMwhif3ZAMVDRtZsbbWLHJQH7JOBJcGBsurFz4S4IVOlgvYm90y5nzvjivuufSo0FGU2FPBCS3GQnyRulydnvsZS4sfKLqzZSDK0nlf26GQznVbp4SjDCpEDWalJk82/7SWmgQAGFgtOoBdEQxpNCj8E6XscMS/MzhkoamQefdoMmvEONCa3KCzToaAJgyUHmBU/KRwIrKZp1MkteCi//sE/9Iml2t1Ee3bgxdGu3eW4jHuWVg7AaIbhtm0G6Ly52twu8gJsiuEbQumisREPwSpbRB3o8O/TArzBRRaTd0mTjv3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqYKS2vgFvnM26nA4DP5j4X/SPrHJZeAJnny9kDhg3c=;
 b=uITPvcn3g63t9Rnf4XtTO5FviCncevFRgjhB9Bzal/UG5pnFz7RBWrtoTKMtPgx/nTj+s5kdEg0MmMKzImTQb3HDCsTuLe0l+/AxYeuXg1HQ5e11Gd38twI2a3+4q/78lqRHurS23E2EwROqjRzaAWgj34nGaq1dfMm5y350MfFDHSBI1lS2bzM14NV8qf1DXwDUh8D1OO77wfym+jqaifXy6BzpoSd6AOIXrUEg08H8WMTkvzYZb8/Zly2W7Skz0R2Oj8sw+SC7SNNi763xj4TwplwiGS0lkORUGSIi3rSu0Z17158IIW1VjJ7Ns2j4sGDn/SOABp0x6TpsUhQ8Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqYKS2vgFvnM26nA4DP5j4X/SPrHJZeAJnny9kDhg3c=;
 b=xUYX/BaF0Y5WoEAwDjgDy5XO5FE41rOZ9vQcN9Hs2HThOmtVgUXu1fFpCXC/9Fi0s55fwqcZy8sOw7WWJSohFFY52/7an5O3jgFRkESkwr4qpG9hOrNye7JNDXHthP0HaLP20vHL/6zgTXwYwDnrUkicDKjYe3lerkL6AV+or5I=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPF25BED9404.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::794) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 08:53:37 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 08:53:36 +0000
From: John Garry <john.g.garry@oracle.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        m.szyprowski@samsung.com, robin.murphy@arm.com, hch@lst.de
Cc: linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
        ionut.nechita@windriver.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 2/2] scsi: core: Drop dev->dma_mask check in evaluating max_sectors
Date: Mon, 29 Jun 2026 08:53:10 +0000
Message-ID: <20260629085310.2298552-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260629085310.2298552-1-john.g.garry@oracle.com>
References: <20260629085310.2298552-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P221CA0043.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:346::23) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPF25BED9404:EE_
X-MS-Office365-Filtering-Correlation-Id: 528df7ca-201a-4763-d007-08ded5bbe85c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	E62H5PD6GoBJl8RM2tKt0N338EW82pSH+4bhK+7qCOAMCn6S2br8Webrj2mXNmpQV8Mp5zR0tElT49I6gCd/AE/2eTsm0/XeRVH3egkSEgAHIejHgU94kjW46cUAazuUoiUdgFTfZMO7qPtZsLaJKIOhPS1IgEQAysFDkzQhU75cDdu+50khuRj+XXW3sNI93DQRMcqcScRBZCcAdAcb7tlndv3OzxyhHThcZCwpFTYDXG6953bcXc/ovEMcnDPMU7pcMl/H+2GBlXGLKzQAk54CWT15y83kkfD57W2GGga1wiR8s3WpguIpTl4vn3IIR1Tiw650j1Ckxs1eIAMCTj9R4ECr3//NRv/TLJBHypYaSdi2zwpZYHtFaVzXEYg0Yqm+ch5uYToWZEjsKkLpjM0pvQVDWH7BiMkR0ppZnfUt2vYnApgOFWKCuxXzipvqD1Uo6fyKwb9MA0KiCGBnplcVAvvMFdQHxkpeiIaSCuoTz/gHCtXRiTqYyRdh2AzujYO5ktUi8xx0M4Jwk7W9nQ3fxwPCmNPS6flacl4sEaEBhHQyo1Vm/X9vjKU1rpbWXF4xxvvuGwaRXJJuxpfsbqE+wLYJp68kmIcjoA6sjYs2QwX7ruX9qIBhB3BPojHY9Fn2fRsnga15HkstwJVx7psHcyIZ0KzoYPrAm4+gDIw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?spguVdPl3bpkTirjy5xnx5RgQUYgB2ptoJUfIkUX6dpq2EXgi8nhYBn9zf2H?=
 =?us-ascii?Q?9Lu0QT/jphTI5iJzsiJNdwJP3hiMqNYOgAQQJJrr0Vwyautbox7ms+jls/7f?=
 =?us-ascii?Q?xD60cTUPCGD0Vhyme08CsgfT4WnmwUCYz0m849GPcSpcFRiKTX5hi9thH3f5?=
 =?us-ascii?Q?Gb/Ihthx0XSiutqHsTQopzyuIfgN1WCnZH4NuRIJz8MCGsczgctPhxkDNENq?=
 =?us-ascii?Q?nxnCMlhx3pWsqvIxdLUxO69pp8EyRfTNGZGcGMbdSxZL7/k0k5msA0b5iAan?=
 =?us-ascii?Q?gI+D9RDnNMdsEm/GTLVKPncS1q9KpVF79LC0Rh/fBh6QDckjuvqKAoMIBFYU?=
 =?us-ascii?Q?aMCUQ8d4PG95MrW2G4w4MYKgICAjoTmApY5O6Gl9PMh+/n5MxDoLGynj+Oqz?=
 =?us-ascii?Q?dg+7trusjSqGAfP3Meku9rraFoPmAf7sBRaPdPUnvACUwHoEYj6g+Ytk4gop?=
 =?us-ascii?Q?SaQSE68XDRHMKN5bIMPsus+g59iD2WJBZUS0Cgml/hDeeo6Adj8UyhTp+fyr?=
 =?us-ascii?Q?TllGSkIFF9mZLdqqA/tXJPaSYyfUFyo8e9sWiWl3swi/sMTnNJmF5irO1OBJ?=
 =?us-ascii?Q?XKtQMIOtSmE7NWZKerh9QanjoIyIpcnux52G3iYf2nUuCBNU1GyDk5nHi8G7?=
 =?us-ascii?Q?1kLqNnQj/uI20MyyW0MA1GtPlvTGoxIW7mkncTv6WNeosfjoye67c8oQe0Q4?=
 =?us-ascii?Q?f8dmqR65QQj3m91J4fbGsKDIEBqlg8wX3hl5L4Y0WeHIIm+1Z2DWLDETwfeS?=
 =?us-ascii?Q?ZxUSLFJ5PNSm+rkJuVtGgaLycEkfF/2oKf0gV27DhVHprgV43Ar+MwACKtTb?=
 =?us-ascii?Q?khSWbMXnFxbOK+JMvD9lmyIDmsDyK/SJgLT8popAJqoS5KCjzBlZpmKZsN5O?=
 =?us-ascii?Q?fLYRZPqEkp71PMpkV5ck7BpoYfZGo0jfnIIsmM4n0gyRqgSFuFpyJzPGvww1?=
 =?us-ascii?Q?FYzO0ElCONe/IiShgWUKjwiDIdRUy7dg+omYTJ8vi6cyrtV2VR31fiXvrJOw?=
 =?us-ascii?Q?zmofgNBul9+o8FPBnmV6XdrY7gQLrPoWJdrq6jCUpOk8PmN0vHesIhX4VqP7?=
 =?us-ascii?Q?fnBiRhwMX02S4gHe+Er9lcDNpI1KJc1a+qFt/jBUU++hptzhcMNnuCeJMK6k?=
 =?us-ascii?Q?sid4otuviSrWzNwq6cB2AYfar2zktN2nabMBwjndhuRT9kpOGeasKackfTYX?=
 =?us-ascii?Q?qRadqvtyuE1rL0c5k0MPRHF2BOZgcS/oqliFefj1uUAGceaHMvfOhdeCBU/P?=
 =?us-ascii?Q?6QJxrymokWU1fu4f5h3VzwaBVKIHjwWSbsg58wc2JkPJu4/1ZRL6sQ/BgZql?=
 =?us-ascii?Q?B1NZPvJ/0Qfd+hpvNXLDGGpI7A8tWEWzo6n5BWCqGuyd5pstOaGqfxHRGhfq?=
 =?us-ascii?Q?jixDvzEXlIVWtT4PAwxt7gzQrZzhAbdiNG5x4GTI1FOpTR3i5mSDhfOHzJHP?=
 =?us-ascii?Q?zVq/OGo+Ghg0p/FyRH+NPP9BlyM4LIrrMZUk9Zxt4JidB5U7KI2oiO3gGcOb?=
 =?us-ascii?Q?Uq8JlGimSLh+4SpW9lDRasA33O5MEvN6Zl5TK/IpvMzVWHcj1HBVgBKiikai?=
 =?us-ascii?Q?ihTWB/LKqJie2Wc0BSko2dLLZT2ENOc0NndUxRHeSzlKBYxqbjO9RCGDG3QS?=
 =?us-ascii?Q?iusOqxXfjh0srcm+XUbtPMa7Wm8ZPt7rVJcURaqJHr8U5r2qduXwNcPkTXJE?=
 =?us-ascii?Q?UwDk2RVZsCAlVGq1CTrGX4chllSSlMTP7HG07oInGZXzUCcU1Agav0+ipXFe?=
 =?us-ascii?Q?Q8+CzyiLPg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	b7Ag2mhMt29dWEEZ11mQKxVBdhTPqQJP9VnGqeuADnmaxJ3hd6HUaDU7rY4ikXlHAMuwZURYcf+GID5DZRg68m5fJE4GWhl6JVZX20JqcUGcb9ZuDvqWrmMXi8Kz4MbpiT5YndyrQF1kn6+pGUvdoINO1Y7YOwb9UjZ+kw2sWCX7LM1CNGLqX9nx4ElYaH+9pkPy6fh2TgxR3FUc4mH+96i/UzDt2ieTV+tn5lM4Bs1+3j9QRBUIPw2b4hyA0TV1lDUdFcQi7BUb9sfeeoi3F0htxQiewFSxDswN3Mf+NbY5rxoh5TFm0S3xSoyM8tUCxqLVVutBL0BlsMhTYFn+hw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	g9/aydM5UcL2R5RxVYfFu4PihozKaNbYCl756IXYhzXjftXAgBfJfML3DR+2O5sE8Xrcx/NRXNOMgJgYNlZpItATDws12e/pTnAVetBYm75wgXNSlZWeOBq9v0INnWQJh910QVX70zYgEGylnFwizKz8/lonr2CJF2rQ+zaKVhVVqPofr8umLZw+vTGE0yqSvBWXfl8VD2ITH/3IcVkQF2XqTsCr3F2/LhsW/QhSimKW2UfcmRaJxmue+/dR+Kff9hJ58HROdjRmKwcBb7wPOP+WcXiN4SLvvZO9Jxmyu5OF0Y1vI+krpbpcGVgpaHmCStFgOa7hZ/rtp3QVLoyNSy2gLXD1hudgybQU5IyI/UIynAvAHJDAop0uHWnC/ui9Et8/162ygVBG2ZFuuoqaW2wuQr7xomc0emlugeeZn4ZviIgrImw2Cx89QAX7iQy6sAAO+Tp8TuoBjora1rb7p5X61/mj+4rjos7eUEk/oaXcRk01uKAtSHXlwBd5ghQ+4+qbCsflHJgsWs+xIIvIOJT2AvCc1eBabxOMr62OjGfPrXCgPCucFtOdFoVJ896Nn8fneWcHDueUZLT58YkxiDCb6WjiKz4JV61QLdWlqhs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 528df7ca-201a-4763-d007-08ded5bbe85c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 08:53:36.8235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bw/9rdA0ionNOaMNbYkh5kULHqqdPi1REVXmO4pANMKTING0AaIQ/N7TeJ9ClpZBXJ+BRM8JXsxoTY/qFwJCfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF25BED9404
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2606290068
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA3MCBTYWx0ZWRfX1qmeciR3pmek
 kyKEyoqlFAc3DVYDuXpduY26z9hIgtxiyj91J+UvalFexufusp7wR1jjkcoA27xikQdj+lg2PCQ
 Vg4PBIO6j53t+G/G1ax9hyA4oYst3rL+W41QXoChA7wSjCMMRk+b
X-Proofpoint-ORIG-GUID: f3NiaErYPU4GK2eOu1X8k06dXEQLlChF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA3MCBTYWx0ZWRfX3Y9iPUy10RyI
 +BPN5UxxZX66XPdJQQstClddUw+9wmDeLylIzU2XLSlCYUqV99CzlkY1qT1ygsm/7vqe7n/unrU
 /rMTsUNvHJhdCb5ViruWlr7RNdG9TaL2gEetCOx7bVWYqDOviVjSZlLGjC7YfRcUk9qC36Fwels
 IL8Elun3EbRS6m9pbjxhShK0xD5ZIMLVTO5JFsHvZ76hnw9jWFpXkdWleEFASuUyO1vDeMsNgwc
 Dbr3LhVyWgX3V1ld7LjFZB2ilWiN8aRZesY7XUvjXjDhi7H5gZJpUkyh+2QY86tlbrwAVbiqobT
 88OIc81YvHJvWFR37JoPz8ZEzXvuswwblXgd67m8PZBXPMhsqjU7ox3s1oytiR1oOmGd8sZCa2x
 spuvjBRRGqIOMOhuWJSfyCCJ13OWjKbGIytK83W+FenSG3TeHDYPL2oMRStZV/SU9ah0Jof22WE
 TRoGra72zIY/OsFbh3Q==
X-Proofpoint-GUID: f3NiaErYPU4GK2eOu1X8k06dXEQLlChF
X-Authority-Analysis: v=2.4 cv=YOavDxGx c=1 sm=1 tr=0 ts=6a423296 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=xvxZ4KM5oqG4xSrkfu8A:9

When evaluating shost->max_sectors, we currently check dma_dev->dma_mask
is non-NULL, as dma_max_mapping_size(dma_dev) could previously not handle
unset dma_dev->dma_mask - this is no longer the case.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/hosts.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index e047747d4ecf8..d512080268afe 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -252,10 +252,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 
 	shost->dma_dev = dma_dev;
 
-	if (dma_dev->dma_mask) {
-		shost->max_sectors = min_t(unsigned int, shost->max_sectors,
-				dma_max_mapping_size(dma_dev) >> SECTOR_SHIFT);
-	}
+	shost->max_sectors = min_not_zero(shost->max_sectors,
+			dma_max_mapping_size(dma_dev) >> SECTOR_SHIFT);
 
 	error = scsi_mq_setup_tags(shost);
 	if (error)
-- 
2.43.7

