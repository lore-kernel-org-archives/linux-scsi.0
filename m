Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6806214C5B5
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 02:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729046063; cv=fail; b=Q8RZBp/hltqYmICgzE+dRF0dRP84qpSyjLY4HDMz1BX8mSsmn24XJpE6uMXm8xv+5IIw5+6d6nfJ0/FwoRuWzPVaKk0RRNS2G2LKSLVs+ikmgT5cpRK6qjvqC92SHt/PeIrirQbulkAiLq/8Dmiby7W3FmEZe7X76qAQThvbFBI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729046063; c=relaxed/simple;
	bh=7k98iJwIOtJNGqW/VnnXVtLX1/aSB8PLcZyfT//lhyo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Hi7iZOo5fJY41zDhfYQwA8vTeRF2lP90x59UbnyvvobBDenGNL2hS/sT2YTrpcL0WdHj0+T/Tq3gmW5BM7zRrQDpVMaMQDKpWJm3pFQcMnDacGIHK7o7y9Ph5Qj0XalUVyDbU6EcP56VM/YqFuqNtdiwDEwIk9rMj4zhiWOyRx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E/FWQcDP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gDxSBz/Q; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E/FWQcDP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gDxSBz/Q"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G2Mj8V010659;
	Wed, 16 Oct 2024 02:34:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=s/dtx8h8cs6yruStF4
	g86KwZ5EJSLVBcyuKy0MUjjxU=; b=E/FWQcDPu6I86kOfFaP+NNx2kB9GU1sr9N
	lIbm2UdS28B3U9h+kBtOBrntjxhg1dBTgzL+476VYZzaCbJREKvfp0avr7Eivnl8
	8gAXCr06he1hnmyLjveJod1FlGQlnY2LC9chau0h3eRi7qmK9NMltl2+HyAZiaHa
	VqNa30vEqsKOtj2Sr+GX+QR3zuAFcTypTbEqu36/5PBAkBiMbl5CM4w1NV3RyT8j
	l/CMyJpB8yGzeJceVpHt5Dfj+XtDkaiSu5UjJNuPC23RM5JbmVyRbMkP1G3n4K60
	ZZWwbIFnCpC4aGlC2i4HMcDoMi/arCdvgnjln3PLd8Sq4cPiry6Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427fhcj8mf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 02:34:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49G10aZr026369;
	Wed, 16 Oct 2024 02:34:07 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj884mb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 02:34:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pxlQk45bUb5fB69pcXma83N+htLdUe1PMRO0R5qh9ygKRWSEVcaOtE+HLkV+lRHZQZhkls2jxPTPnPtwtkum1Cau7GdkPW7I2lM46nnDWpiR5Kde0F/ccScCfjKDPzgl+le8bZZiP+QumDHIPVCdTV4ti0f29uztmjXGdz66YJxqvhFnXZJGqnNrz+Hdnj1DvCOUoLInF7QFzGAYSI1Gz5ighLeJM8QeOSgZzIy/l8HrxW9htAgN77fF7/PsbicocGsUffyiT7tcR8HFuCX/8p2CSxuo3azPRDkysj8T+jZDUp4WVI6SEzsO7MDDFgzj3B+j/rAZvYYd75X8fravVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/dtx8h8cs6yruStF4g86KwZ5EJSLVBcyuKy0MUjjxU=;
 b=iHS26A4XwCRqsfEfkdDl9rHdy0vGuli2zPOOGXYJB8KN/TuFVDTeEnigGHhJUDS6JBv9CeWC2/29fPFw7G56QU3rtJOjP4pj4DE7jQubvL9fr0CGkIP6cKViorzSTYXK2/Ua02kARPs+i2rIbxZUF0HSZPR6MbyTSz3ExGWZUsJF6SFTJSfM9JTJY/BI/hXzYWkmtKFeCpRbMfTJ3IG2Go8P1Uwmx7blpQlIWDexBe96kDL7JnFZPUf9pkEiAWWrn3pVkeK2AUGTe5hmM7v8rz0y8kaWUUjpqChjsOInoy8PFh6zcBpKwL/vSlRIh/ac+1qc4PMGzDrSoqk9Ucuneg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/dtx8h8cs6yruStF4g86KwZ5EJSLVBcyuKy0MUjjxU=;
 b=gDxSBz/Qkxaa1YoS5DNVt+ntSIEjDHWyNnq3W+aR1iUVWtsq7Bvo4K74fRSpxZWLuAYNGDiccguET83Vc2hIlfbpTMMendyzzVgjTjD5uB/MUrG4pSwbj1wGVrGQ3HcVVmec+uF5Z1X2Ct4b5lBik+FcU6FNsHYH32N4ddwoFTY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB7077.namprd10.prod.outlook.com (2603:10b6:510:286::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Wed, 16 Oct
 2024 02:34:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%5]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 02:34:04 +0000
To: Yihang Li <liyihang9@huawei.com>
Cc: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
Subject: Re: [PATCH v2 00/13] scsi: hisi_sas: Some fixes for hisi_sas
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241008021822.2617339-1-liyihang9@huawei.com> (Yihang Li's
	message of "Tue, 8 Oct 2024 10:18:09 +0800")
Organization: Oracle Corporation
Message-ID: <yq1bjzkrd2n.fsf@ca-mkp.ca.oracle.com>
References: <20241008021822.2617339-1-liyihang9@huawei.com>
Date: Tue, 15 Oct 2024 22:34:02 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0051.prod.exchangelabs.com
 (2603:10b6:208:25::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB7077:EE_
X-MS-Office365-Filtering-Correlation-Id: 046eec88-5f28-4c58-094a-08dced8b00b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8SLe20LmjmTrXTGUOlyAC8lc1EEZCLH4nxY9Pjx7zAggkrgG7w0b76Q+EliO?=
 =?us-ascii?Q?oCTdXG5FCcApLe+51A0NP3HsEvhHDHmZe2/WcD80VbBGsSW8S8y9vJSqS1CR?=
 =?us-ascii?Q?EisgRQpe0acNusesRVrTHUKtI8DIVsSVmIg7jqM55c0PjYscFi+FYvv2Agus?=
 =?us-ascii?Q?02Aad1s3FwKkEglBkd0PV+XbQVlKdXSoNElzFywoplWqdzUmrbI24y6ceOJH?=
 =?us-ascii?Q?8JS4W32BxpJdYQlMr1N7Our0CgKsEmnkGfqyyv7UY+hj/y1pINZVp9//aELT?=
 =?us-ascii?Q?FhPGyjGavjId+ln9xp4Zyr6IDu8avO3pyaopu1ABhY0WTmKr4Gf1AMiraJOj?=
 =?us-ascii?Q?jNDqeEmIrpp9Iyx3lLPSesb+55GrUkjUlO3vWDgVejZtrEAUUncp719I/l6/?=
 =?us-ascii?Q?R1WpserxhmgsIsC/XYbyFY8KKbjOK3xECYJeFm8bLZUnNCEZjoeWOcPvagFb?=
 =?us-ascii?Q?sQPmWrzOkvdse1246pGObRe8cZCpzhnXlkuI9CSj8lF2S0OOHk8NWx90WgUD?=
 =?us-ascii?Q?mPPQHbJbWH7q/BbBA+IR9/xsQ7aM9G9nl57sjBu1KuktaWSz0W4W5eUkGp+n?=
 =?us-ascii?Q?MpprPPLaa79Xw7d9qLRchFy2G9NPPg9oozI6LA4qV2LxMOclgpP8uUXj2FPE?=
 =?us-ascii?Q?dRgjlZyn7l5fXxm2gYMJzybQq2iyY+6LopGntevgpAMr3ALJotcYYnJUJQZh?=
 =?us-ascii?Q?6v5wi1tUJEMurgGsp+vxHZTVw9fJcZyUYtjnMHojQC2Skw330chHbfFCSJba?=
 =?us-ascii?Q?9zpVHig7V4ddS4/fZIGzFtxgBjglhYZo5WpopYMNw5d2LrqmSfN7PkqAr/on?=
 =?us-ascii?Q?F1qqlKW6Y22QHyKU9UE2ktt525X873UqXN1WcMxKHN1BHUXfV2Afjxub0otF?=
 =?us-ascii?Q?n93VjZzvVGgs/VRQXwEnB3svFfXRvPdpLgJZIaJxc7v3+P9GWhw+VwST7+a5?=
 =?us-ascii?Q?5zYLvUGvFwVqOZGuzHjfw215hoPu9tNGlgRdv9Wz/PyUddQjRH6alG7UdOC5?=
 =?us-ascii?Q?MiNY/OWIfNGIA7fVFhSmETB0rhm5+RpuMHrghkeR5n90Hy0nZx3corH+P4tQ?=
 =?us-ascii?Q?dzuk4o0NNWJki3FXfc7cfEB/JzBec+FVTy2iVYKRgX8vwa5lGNopCsY5IeOm?=
 =?us-ascii?Q?lb8tMVrFLWFb7b7w9h1U5PAjWj1AieOERWFKxPHm9lZMeg0G0WjfE9ss0Iw9?=
 =?us-ascii?Q?IqevK2mNxIbOV2Vv8qZ/+Df+N67RuUhruz+I6hDK27sbd2RdNg3p/tTXd7FD?=
 =?us-ascii?Q?9d44VsOjhYjNN9eo7Orh9guvULiRxTH+3q2ihx2LTA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2SAZCDmDEgDutXKUiA/HuX8akanbg7TXSOOGQHRG5C8xQ8d56uzWgk8moASe?=
 =?us-ascii?Q?mwSCl9cR82WMd+ujKSa69eja4srmaD0MtupDWafad1UZmmLKmovRQFsZrgI2?=
 =?us-ascii?Q?V/2u9VozcPKUZNMS3ZPGanNdpo+irj/5hmD4+aVresMFtZkESItgQ/wlsU1B?=
 =?us-ascii?Q?ahDUh6oBhIXewK115sSbd+fvIpYB2mN+leB7gPdjio0prjCCb7xOXXhBRuNV?=
 =?us-ascii?Q?JDrdbiEMDJSIwaDrdrld37dupp+/PVldt0nLBwwpezbmdb+MPV/+Fht0RbVX?=
 =?us-ascii?Q?mPCJrlYea0oxLBHI085HwioKeO9DycaTBpnN15QiOgJWmEJuKGIvPXFp26UX?=
 =?us-ascii?Q?Ilq44+mBuFSUhQQ6Ee2WKpwoG0f40JZjNkDZAkBqBlVE96OX2Nw6HM6nGGPb?=
 =?us-ascii?Q?/NJWKgj2ZzrWI9mBvlBqYnZFl0114lj49TSY9jalcR+4V9sCKmEEUSZAxkUE?=
 =?us-ascii?Q?G+NHiTX3x3jhSZlAsMZBN7kA4Yfwxj/bXJIXgLHyol2nQdo80vZ1aia/VmmM?=
 =?us-ascii?Q?KhjZgtxapMViPw9OQGATAKj4Yqg89WHUc8n+3a2m3bRYrOGUyatJaEJqOASj?=
 =?us-ascii?Q?jDw57Kupj6GYMQ7WHr4vTPZZfaGL0/vjT7phXBPDTDe29gA9t2GFJdywKMl4?=
 =?us-ascii?Q?Wj+C+T0s6c559eK4ZYwW9QWDQnE7JJRYL1EKTM5ifJPKgMpGGbIsj06cA5ux?=
 =?us-ascii?Q?M53MnYQ+yoGoovNcn4JZhllpwISyEpmgLaetCkcrLIn7XgPQwq1XP5oezIUM?=
 =?us-ascii?Q?JJM8OF9qR2bEcJBK/tl7XtvDajvfspg7MqpS71F5kPIRRKVM8MXTtfN8XPQT?=
 =?us-ascii?Q?n4mTCx0mYGbo91NIMEbkAzmz8lCFpnSzHVpL3P7QghvSETK/f6J1REe8ulaz?=
 =?us-ascii?Q?8NMEpzAP26cpkM4tWd0EdXzLLhjzgZn4X++XpjkDlq6Uo57+7atkyi0GNfMN?=
 =?us-ascii?Q?SJF9xPAxHLXFARzMwxfBjL60RLlDnLvwD7X5XW2EUNa77WgXgFEA8qQgQdpc?=
 =?us-ascii?Q?iZSpZgzKdMTuUXRn4t0kOrGcIxb/TSdLUPY0PgQex7Hwbw2dO5ovdWkBM8jn?=
 =?us-ascii?Q?2BteExF2Qg3G3Mu3EP2dZ/5wPQNGJ5uXYMO67JaDxy7YwXB5IEk3hvZkpJt/?=
 =?us-ascii?Q?wNHQsqgdTvUwKUoqNv1BxojZSHprNjiK4a2Iy6RO7U7zTz3BmVFr0qwEZt/K?=
 =?us-ascii?Q?8xDxhaNDVwuEQMPPheCZpRmONwhr5N2e3ndZZq6dWS6KrAcFN8wa5YQcLTMC?=
 =?us-ascii?Q?gfIQImlj6HuY96m6upiSa9xl0p2JC3r9J9ed8l3eAb01jL4zODNGHIhZ6Ev2?=
 =?us-ascii?Q?Lrs5q3cOZ9mtlDaOLObDSx+i8mSLgXsjZfqf81XF3FXPn+xwkGIptfJxzNnR?=
 =?us-ascii?Q?wJki9Stz6bCnSsUyclA10VyTg2xO9hanTnOCtEFMfbTxnzF6VxL6Jd8YwuoP?=
 =?us-ascii?Q?DJ/mHtw/AoPwA300nDqxdbxp6KUYrxowWtxpc1B5KzEM6oI7u6saHn0KMcmh?=
 =?us-ascii?Q?C0QXFX9E231zzzOzHN9FYBr4oXaTghW46TziO7xQzfybgj0l764G2Kq7Cg/X?=
 =?us-ascii?Q?fLKx/Vy5lS60wIx9d8tr41665D2KdGL+cR4CQd8rn8FfRpw/h3ueXmkRLqSq?=
 =?us-ascii?Q?Rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rZULlOj6eduwv+V+njRv2t2MQok3bdERUaXCaR1aTB+/BqvXkeF0SL3JW3MYyAMW7fejSluS5W5iYBtx02CcaG5YeXJVBmCvDkcL2kH3PWg+5rq5SDgpT5yUJC84qdYdMD6iPfLRhQqrl+fiuIx8MYYEEVFN+YqWYo5KQarkRbiN5rcr+/5G1eppmQscRKsnh2Vjy4pJ0gM30tahmG9od6k/84huQv6cBZH/drNBNtNP/lLJJN5cH79d4Ayi1y6P6D/gB56w9jUGkumu+iKAhO71rgEz2D0+of80vKOtA9FGXNoQGKTyiBge0pTJgiKIL1FjNYfYE8S88A+pbv6T5R3CtM8sn64BirKQT4oyB6XWYeRnZUM6uUKmBMPnZIinm3jsv/yxXmmBpquSn8cPTegZqV0GXcOYYEIsIU0ikM6ueJsTPowD8QLMnAeDCevJM041Ezo6IosMl2eSE37rCUcO6CmN59TlDq+uyJtB+dfU2J/OI1Z4xZ7kLBbp7e/fLhZvmm3p1y7/mAEGZqyUSkKk0T0+QwRawTS/5O5p8SUTjVo0py71xYq4MD9vIt+NPfcNu3r8SI+nUfOkPqI8575i7EBYiP8YO6DHZPt3kfI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 046eec88-5f28-4c58-094a-08dced8b00b3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 02:34:04.8651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dgpf+kHKzixUtRcQdGhxjuvb/pO2pkmDDRVyYbqARilhzkgw9WXpIBn3aye+KzfxCVVzEQzReyZuSbzgK6J2hmbiPIuQ0EqFI1pslDU5Egw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_21,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=910 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410160015
X-Proofpoint-GUID: rgCmiEnynubOa01hFh6ryXDty9ZxuBiR
X-Proofpoint-ORIG-GUID: rgCmiEnynubOa01hFh6ryXDty9ZxuBiR


Yihang,

> This series contains some fixes including:
> - Adjust priority of registering and exiting debugfs for security;
> - Create trigger_dump at the end of the debugfs initialization;
> - Add firmware information check;
> - Enable all PHYs that are not disabled by user during controller reset;
> - Reset PHY again if phyup timeout;
> - Check usage count only when the runtime PM status is RPM_SUSPENDING;
> - Add cond_resched() for no forced preemption model;
> - Default enable interrupt coalescing;
> - Update disk locked timeout to 7 seconds;
> - Add time interval between two H2D FIS following soft reset spec;
> - Update v3 hw STP_LINK_TIMER setting;
> - Create all dump files during debugfs initialization;
> - Add latest_dump for the debugfs dump;

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
