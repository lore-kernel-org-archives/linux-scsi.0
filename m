Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0852A5F;
	Fri, 13 Sep 2024 00:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726187164; cv=fail; b=Nh59Q1gB1eesrLQQrzryu9bd9SyWqeLNtIX82xMfLnwF3QT6lEZB6yHeQpvZ97bhqBvV7eCWrW/iLAldZa7gHJr+pZs72hXckgPgqCWAF0F5RTCaapGIegDvQej/27pFzPnYpfU9RTBLlzc32NrVhGfX1GZ/FCKC/g662sB0Ih4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726187164; c=relaxed/simple;
	bh=LNdVKblgEswCV1JF3ppu6UMw9gdfele1ZdVL9q4JdWU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=XOo0ykUg5ZNOg2E0XZIIPHYo4uDTSRMRu1G+TvZbvuldLqRMQHSA+F3jVGq4IldPyQ87KTR8zbGmR56ACPrId1ne5IowryfQGuPlMCwul/ieCP16sutWRfter0d+VIddeVztIUYX9TGhFgBNGIejacJbssdAZxOZAh8cBi01aWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oaMZWWNR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DNX//JVN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oaMZWWNR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DNX//JVN"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBVE8027775;
	Fri, 13 Sep 2024 00:25:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=J8fRcb0V9FA/r/
	dtDkiZUcHew65GQQtgtPOkbtY1Xoc=; b=oaMZWWNRMw9BRLsfhppyOjuHBNa9PA
	ZMVLek9fIDbWxydCJ4Hdq6T+xlLocEReDyldOTv6PPRWE376yOojWLIueLRwXUiY
	lpti2r5ncf6tPFakn8QrPbIMSKHt348zimyJ03JgidF8eYTLodljM5nT0gkU38Mp
	Vgj1y7R4NgSQG5PGQFKVBCVtgsFp91vAny5tXGVHBgSWkr9TJNn13KES6YmD+03y
	15VKHUl725VgOjdX7ZRAgug7WPH/u48OJOAvXr4jElrKDugTO/79igljbZUbEbXe
	uqrL3FapHIh3wbcMf9Fst2UEC1A47lJoZIgZimF6Szy/sd9wKm5VaAJQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gdm2v8qp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:25:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CLssrs032456;
	Fri, 13 Sep 2024 00:25:58 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2040.outbound.protection.outlook.com [104.47.70.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9jac00-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:25:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UYu5Gaa1SL4Wk988Xc3pioTsLGw7531Sz6X9NsBBdcggirz6xg3LHn99+9sXS6Ba4Z7IHCV3pEj3kxOex8M33UIB7jk0DQmchvotoowXsn433jTFQst7rdZb4bHk8X2MgdNBjYuBiCNCClf0egDA885zmCD/Sn+QntN7WDAizCSs0HD3Z6JriOp2uHLyHT5saLNDQ66AiESjygUKO+xdSc1+vZ1XMWcldADsS8Vad3Ue6IaXGNoYWS7m65KS726UoHp77rJ3mb0Ucf2o1WBszeoAEGR5ojsXosmVbfK4uzRZgOafJ2IXbDiBoxNHjbBK0V+S9J7a4XdWw+vbT98POQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J8fRcb0V9FA/r/dtDkiZUcHew65GQQtgtPOkbtY1Xoc=;
 b=IziCSGT1ScLA4ucX/XC4KSJYfsS413G98uznh80954OcEVA7x/k8h88DLPlzmtcmFkMHsBTlCc0TlOqzYqQE8qJdGvZqBYeOFcgiTLFyvH+D0gNNapUMyYtNGNF6YN3W5y4WQxcp4u+qRSJabNNB8dIhZPcd6uFqSNj1LGCBG+UFIeOu5ov24sVnrKBDto3+9iZwoRglOfiKOwf7u5LYsa0vxnefRZxdHIn2Ff8gh2OrQHbbltlSVz3g28mLc8I/vSsWsP7BsUf5p2lZ++OnESF357d2YhxOwH9WzZiis3TYV/OMTMHHgzGd/FaapVACQKWXOyOB3ecaeceAezFL1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J8fRcb0V9FA/r/dtDkiZUcHew65GQQtgtPOkbtY1Xoc=;
 b=DNX//JVNzgNbUqyfxjzNB++son8kQ/kQOKJWkEZhHrbCLViPb1vqqjOm6ebM/pVB1G2IUtoi82vAOmNiQ+LFbND3PcLFhcIBEYOdWWIy0UuqFbkyG4yD/IxzF7fY6QrtLJ2jDrFKDLQaND1yU7u4F3YQzLp1t4GS65LTm35+DME=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.16; Fri, 13 Sep
 2024 00:25:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 00:25:56 +0000
To: Colin Ian King <colin.i.king@gmail.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: zalon: Remove trailing space after \n newline
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240902141202.308632-1-colin.i.king@gmail.com> (Colin Ian
	King's message of "Mon, 2 Sep 2024 15:12:02 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ed5oz9f7.fsf@ca-mkp.ca.oracle.com>
References: <20240902141202.308632-1-colin.i.king@gmail.com>
Date: Thu, 12 Sep 2024 20:25:54 -0400
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0005.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: aa1ca5c3-4224-4922-cbed-08dcd38aa23c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kRdWuKZnhv0qReKlo9AG4NuL7zMNB5xe4Q4U+6WDzTWWUDitGuI5/x3yPcbM?=
 =?us-ascii?Q?2qEZ+lcyswzRNl1Cl3Wllo2tARXGDimFIP0//qkyRS+JShVQY3W2WtWLmsMW?=
 =?us-ascii?Q?HcuJTibxCuMo0NAgjbcD5ow0AFNuZVHwac/CTlfvMphiM+wWPdH9GGmqfpCJ?=
 =?us-ascii?Q?/vwjbv/SFP2XX9cJqEDOegRLsujSkQi6iuvINh5+wiprVb65QlHvWCNs+cb9?=
 =?us-ascii?Q?/vhyQe/y5GWu7M47vFojmDpFJAJ0Iyy2l9iBg/ZEoxcd9aovdhySPTcTk3H8?=
 =?us-ascii?Q?rCB80mph890R3o6zMMdDE06WIXQibidsFb0EHxjvUhfjhTbF8QLlIwRkUiS2?=
 =?us-ascii?Q?T/xJVO0lc9V9XUhRc/MRtLByx9IdUFjay9tHkMyjOdN12CcNvRxA+hKSXmBB?=
 =?us-ascii?Q?s8Qrpy2U1+a4Sjq293CGETt+e/kYe79L19f1UF2fFvhYCaVV8kbBqhyRKSay?=
 =?us-ascii?Q?fS0M3Wra1ngEXMtGSUNbtak/JaNS9jOfmfqTSah1ftcXd0xDZLpSuYPQh0jw?=
 =?us-ascii?Q?9qbUU4sxtOKxhIR1cOMF+bG/YZiIZIS0mwARdnq5DmwpCc17YFO7AiB6gYQ2?=
 =?us-ascii?Q?+3L6DXHX4iPKXsviz0COBMLYFKQ4rcZh8KdPquEzmj5Qr/V2PbGlBKpgC/Ok?=
 =?us-ascii?Q?R8TQE/8oCeI1KYup98IaNcq7Kl7vGnGmMZg4xw7AKenx7/KJGqtCZot6iaPg?=
 =?us-ascii?Q?lp15CozyNeGqamTUT0eQLqi1pMs3LNb1WhkHcgkcp/AfiEGQmLz++ovWtjtt?=
 =?us-ascii?Q?Ujipj4Rrcdofh8+bDtBaQY/3O1YbaJ/EC0xL5zj1tvRgp7rHoDfIXZU59fwB?=
 =?us-ascii?Q?H5GBKqB6IuIYXTbHRtvDgx+P83yMGRszJrm8ccQcegGQPgYNMU8kKzD1x5oi?=
 =?us-ascii?Q?BzEFkRi8f8YK1y93SSaM3/aHpLXo6GshA3m3IGklerpW+gUyGVqDqZADgOH4?=
 =?us-ascii?Q?WuarxrTOa9maWtRBFWYO36IO0oPymySY/BL/1afy9rw2Gqn9K4bY5Uq+FKAW?=
 =?us-ascii?Q?XxZDr1F7Fe3HeQe1+sct3G7uMzJkerxgbJkmp0oF0I8/is+9Ayxor/TVLKQB?=
 =?us-ascii?Q?lss6ha97xDyYBVq1SniVyfOOBGkTcvuyahEOaoNzlROhU8xr9HRfcRRKjZ5s?=
 =?us-ascii?Q?NBFX5K2JLO6dXZLc9PgLSqnCAetfgJ/P9nqCr16X9C/JWnxCQbcNdaUFF+kR?=
 =?us-ascii?Q?PiIoPJGWITiN8o2xd+qG+z+TSky2U4wOIWXTcNrelSspC8jZm/ACqwp0szrl?=
 =?us-ascii?Q?jlgT21MMbU+yadpUo320aG47EJRTqYsOxv9fRe7Z0iY4C5nQnitc++ZFnJGJ?=
 =?us-ascii?Q?OToPrTC2MLYhXeHWOzsMh2jH1NZ1D7sGyNF9EELBm8qwvg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L1MK+bUfe/XnFJiAHw8zy1A3JTh8sWJ2mQY2+9zZO9gWIPDTEu8uyTJ0kEJp?=
 =?us-ascii?Q?Pf9GYgLzkOQ0S07l61PM0tsA0LNyrndc5hslaR2ObfL7T07miDFT7Up0LXn1?=
 =?us-ascii?Q?j+a/AOgOkxtdHa7JTvKF+uJQEOvxYs1hCd8ivwyAfY4Z8qams8oRARlOlvhf?=
 =?us-ascii?Q?lBb4xtfKRVX4IzqYkphELiN1eVILlcU+sqfv5ViRmh228CLhnep/QQELctVK?=
 =?us-ascii?Q?lHBwHH3YI9jpy2Z1zlhJ2fKl2nMcy/w61Gy59nyd9juQBbFckhawJYnJ7yb3?=
 =?us-ascii?Q?W5HjqsCMRIoGbbX4bwLF3Kgnl6kMf/iPWhytIXy3rl+oSbLOzlrx9HOgjgeL?=
 =?us-ascii?Q?vGZFFboRJ0tm4pG21wO3jIlTcmDkFt3Ui3x7A6hMtP7iZaFfhU3iZRB20uyZ?=
 =?us-ascii?Q?PH2igdJKJ+0kuFxaV+GNTJQVNvIG2Cv+wDgz2aeMea/Zjli1FsA945tADL86?=
 =?us-ascii?Q?V0jneNkiJF/bX72D4uxbHXREWf8KZdPGK7qg00y1Tkk+5svjjo74WKxpm474?=
 =?us-ascii?Q?xPkb4DM9yCKMOO2ZLXP0zDYj0VR8lgIAC/sL7Ki3dXZu3Ze7NTzvqjzJpxoD?=
 =?us-ascii?Q?7kZTahtQs3r4Qa8T4OMaJ3zlmJ6cMOlJTXdp6Qed52yE6zGEEgpaxUc7AwSW?=
 =?us-ascii?Q?JxOB2y2iTNd9W6Bgoozc6dSO8Tv0P7a4/wv7siengtmY82L0xIhOu8d0xzIj?=
 =?us-ascii?Q?V/EiqotAQMV87caA6N0g7FfHFLoKjdKFaTubdKxnkGdT2xbHqKQIEgReoCBq?=
 =?us-ascii?Q?u2RYrCktN1gNueNGWt8Lxh1NZcYgl6Nm5uOFCyDdxQZ/UEvVlqAaJp4COSAN?=
 =?us-ascii?Q?mjNzLzowKxKVBxA7AkHVrEMOCBmJJS8/bWq0iMzCfFznQBVi6QVOGdqjYM9O?=
 =?us-ascii?Q?zhogWhF9fca3xoG68sdR05fKmF1BQXIJwprQPai3D1UfQE8N6PptFBOU208Y?=
 =?us-ascii?Q?yzONY5e6AxJdRF3YH9tNHPdzcW6LKcEZczwJ2K37tj0cc02/3Rwv+TCFBGJ/?=
 =?us-ascii?Q?15KWK6/EYTdlYQpe8TBys8JHQA2nGrXHWT+Mtx+9BYLCx8bqId3aha/zl7gE?=
 =?us-ascii?Q?JKG0lb/bbYj4XaIqyZigCKayHAecAwSyVeLJGK8XTh0HxDHmqs/AldLH0LVF?=
 =?us-ascii?Q?xJIjYogKiJRVIgm5CXPhEw5U+3ftZmrT7Fpym1p8Prh03bZckrKwjJQW4h4N?=
 =?us-ascii?Q?ixCPC2ToJ0aC13hv7fyeAjwQ7Jkcn18tRwVD7TXD5VNDZhVqNdNSGqYvSkhE?=
 =?us-ascii?Q?dkXfzGq+JUG4GEvjOvun/JAsr0EepZqKSKD7mc4uyBsop32FVPXwKQEULGn9?=
 =?us-ascii?Q?xK6cnNcCeQPMMuqc9qw53XKid1AVYZmmNdkw1ofd/LyMhFAyZdn1n7PhJsJD?=
 =?us-ascii?Q?jubHi4UJ4KGHVbZRhaVKgwvwCZySI3Vtsupv7MMCGOZ+BlyywvTQA20jCzBf?=
 =?us-ascii?Q?Y4HyZ5S133C+/WGHlisvZZxyO1uFQ4QTMR9gYxhmlqTbhjo3MiKmKV1226Y7?=
 =?us-ascii?Q?XOGmAwCq2BJB36WFQA/rdZ+UQBLkoNgR4CMcdcyu8Safr7yLumuP/WcUELUz?=
 =?us-ascii?Q?rUQFI+X3lKFBUuc31jr9c5itdwI13Gn4bB93LywKSjQX5/reX5Ch4M4u96g0?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ztXq8muvenjB/6/H9RMWugq1SUpLSVJTo4h23piWhc/G6ch7Wu2hMFfQhleDOXPf2PLtqLeOYltTmM6+0uOUdFt7BqT3STEAWm6P/h119ClX5+KsWdLo+rSTBOii2U6DN2U8b4Mjh9RsbDjFgXQBfoSKIcxBYXm7LoOwTHZFD2PayBxiU2fx5Dm3ECE4B4g2q0R4aVrLFVO4TvI6Cy8UyeZIApVsTb9t1IZDE50xECwm0RbWta0AGFeWb9u/Rjp/FPTmcdFghvt1HPvpjVRxQeXLgF/JotY9FQjY06b0GVxJa5pQ4+Os53wwbA7OAUyediC+KkqfEXdTIszisEuQb+edR3IHX68bQTueDCmMjRqx8iza3StyX3l8imWhrfV7Nn+jlVHXxTSr4lR1mRSo9bCb6Gbv/iftW255JyN9h757Sg4MoYUeUmiFu/H8AzIiRE3/sZxG8pblYjnxK4zXPO4Q67Jwv8xiKBDY7szMNV9d1LK325MJl9417ghqoTc4rfdwITBURgm78ePgDVe4ytYJhj6noZ59Nz0CXi6kASSGwPctxXRywGTeJy6Yo6gmtO/J5TFfX7/GsZvw5HbBu3AmCiKNx0fYTm8l+EjydmI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1ca5c3-4224-4922-cbed-08dcd38aa23c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 00:25:56.1596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vdbsFL5borxxFa2NpRXVxDoGIMDUW0wlIJ4MwRL4VWpeAc6rx71+hAuZwcspyE9R0XiF42hepZvKqiBK6ylQMqQqUhNczs0a9EvXUMkJDCg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_10,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=957 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409130001
X-Proofpoint-GUID: Auak1tj8cSLCiumM_jX6Ixh_VwfSmLRt
X-Proofpoint-ORIG-GUID: Auak1tj8cSLCiumM_jX6Ixh_VwfSmLRt


Colin,

> There is a extraneous space after a newline in a dev_printk message,
> remove it. Also fix non-tabbed indentation of the statement.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
