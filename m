Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8707D530;
	Fri, 13 Sep 2024 01:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726192345; cv=fail; b=ouMNHV2C6oHg6MUV5p90Ay6+Nqsq+x1ZypDOt18EDASUQlTWO5pmIzDEIqbcs9DxXWGpfQggi9oRQdPPfHZHPy8CenKJw1LM7TzItS81cXCYV/K6FFB/JhVnFP6H8w7vxVqGTAXofuDsTsHg7XMcKeNJntrwViL1AffwY7jCiJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726192345; c=relaxed/simple;
	bh=Q46lyw83hOV77LD2gvFz5YD/X7c9U+FUFiMxdqkeXFo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=HpmlHwCQ6StgHsb2ZOR+IaZ92Vb46zOAeBk3PWBgpIYXBmXhLM08np4jJDQu4Enc1x4rfeEObX79uQs3OHTa3G6AWMU5BYj4lxahTOitk3IxATDL+VEB6Pkab74NMJdyBzO6j5uAW9e0CbD/6uF0ha8IjS7xHqG/XyTtWXMy3o8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NXn6GYPI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JGBZZFSm; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NXn6GYPI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JGBZZFSm"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBbQr021248;
	Fri, 13 Sep 2024 01:52:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=Gm49uyFExP2qAM
	Rw+MoC9sY2q9t7M0c4mjzbxBD/QiI=; b=NXn6GYPI4zUBEM7hPF54Lw8wplrZt5
	SYiQ56X/UQ/jwWlzG2Mwuown0S9s9X30PZPIRqWJpZrtwqwcgL37msMSzjFitc67
	lbAQhb2q2h49p5+LtE/Cm+A7hgi5m85oqbHXjNQbsy7NtBCxWNLzTbqXwnC83Vwu
	rE0phhfC9P+huIMeK1LWpRNB+cDkUkDToGnHYGnC7+RqSvIyNmBZcN9TBtcJY0ZY
	rbD5IjOhetRin7HWho+GU2nwGLCy9fyNmhzuMwfIY6Sh3JC41leoiQyM/K2alGTy
	AiYbYpOjqlDJrnfj8a2K2L8sJkFKE6qVzXSjyEcvgFCSg6z+yeu3Fbpw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gfctmau4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 01:52:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48D1Mckt000300;
	Fri, 13 Sep 2024 01:52:11 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2049.outbound.protection.outlook.com [104.47.55.49])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9dprk6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 01:52:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XV4dlPyIprReEA/2sVVwNQcAnLICUsBTPeoBSiDcx/33Lxx1mEpV6S/CPEmK5MXbUIM4urodMn/TwqVWrzGc5BacPTw8hX+KrTXOoM89QMCxSmgw98AdsYaU1S2TfIH29xBqS0Au9lWgch1vb4oz4EB9j/OADwKlZNcTWMXOGgoLolqFJOluOLRh3mGK+ImvgDVyND/3jeAMaG5oaPInnZK3r4H0N3fU4OwdGOKkRJDMuQa8ej+v5l43kTOr3vP5uuMFEskAtXMnM3KdF4t95siV+0qTj+mzg5vN5FFZSENAlcHSdyojx71QSXTJp6MAec/SzcgAsxx63Q+ai7lWAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gm49uyFExP2qAMRw+MoC9sY2q9t7M0c4mjzbxBD/QiI=;
 b=zUQCwXsrlqij1zxB0M5Quf0QvBCxExw/Qydb0WsaceqQ/MMpXIOhAlWi4l6AoRSNMn3eBXfqgT111yX7m6Y9DXecRiRLQWb7KURzyWBSqS1UJ+UBvccRngqRCWbXHyY2tHEFvSFrpRY2Q8DSoiI8/IeeVIDGivznQyWRz00qynhMaKJ6dr5c07rKW8EPNGc0Jh+aGsRYEvz9P8YLEEqJ8APveWYxCJlUjfp9IULD0bFLNU2c2IkjQLpMsvCykesDHUNWjQtWhdKpFwqHn/MaVDUt2j1CsmxUV2oCb+6PA6nSvv7W0TOZ71/g/kGG4JMr+s852LQU3zJQjRx+luOrxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gm49uyFExP2qAMRw+MoC9sY2q9t7M0c4mjzbxBD/QiI=;
 b=JGBZZFSmwdKQ/zqB258deDlSFyg92WaG7AR4pgZccf+mTII7BWwGluTv4/1lJAqQcWq1PV5AVUkeU9h6Q8iZLmP+O4HD0yn+wK75ww0Tya8DHAq8IncVRsidvpS+0/JwqtIlpMSTGuU3hXGKHR2NnR5CBj3bInlWlB2cydy1BWo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB7361.namprd10.prod.outlook.com (2603:10b6:8:f8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.14; Fri, 13 Sep
 2024 01:52:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 01:52:06 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, sagi@grimberg.me,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv4 06/10] block: provide helper for nr_integrity_segments
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240912074407.GB8375@lst.de> (Christoph Hellwig's message of
	"Thu, 12 Sep 2024 09:44:07 +0200")
Organization: Oracle Corporation
Message-ID: <yq134m4uxqz.fsf@ca-mkp.ca.oracle.com>
References: <20240911201240.3982856-1-kbusch@meta.com>
	<20240911201240.3982856-7-kbusch@meta.com>
	<20240912074407.GB8375@lst.de>
Date: Thu, 12 Sep 2024 21:52:04 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0061.namprd02.prod.outlook.com
 (2603:10b6:a03:54::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS0PR10MB7361:EE_
X-MS-Office365-Filtering-Correlation-Id: 62d6106f-8462-40c5-5d7e-08dcd396ac28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4b3Upkma9rdPZ4zOKB9LRS23NiDVwYTHTOci2LxHHKuTOdYjCCms/A0fy2on?=
 =?us-ascii?Q?2Zxoq4cl8BXKkYLutPENshAeBqX+3BHvM8N2D7JeJMnyoL5IUUI2GLtxc3yj?=
 =?us-ascii?Q?kLDWTZej1nRsVfIjRnd7Nm3I2YUH8DJjPBKDDBAVnSsx0VH4Pt4fw91/Lv26?=
 =?us-ascii?Q?cocMpK/e7XjIuwrkSH8LhqBATfBEBRlNHPc1GKsASsdsy6uiN2/ar1G/3ReV?=
 =?us-ascii?Q?iqxpArmHv9GC7a1diwJsACgxH3hUYXMgpxZiHvlFiVMWbHmzqCj0S8OnGuTn?=
 =?us-ascii?Q?N7yPo/TL4o/gALuaBDHBUcXW1Jx101+rqD8wJC0azaO8RCNLJmD5SY+FQ4h7?=
 =?us-ascii?Q?XWmMrmff7ndQZvCLyogMGSqO2Zvi0cm+hoJK3cIh/WL32EVRqWOA5nVgQuk8?=
 =?us-ascii?Q?qvA+CWrrmaf2KN8Aab+NE8Vbks9cfjUQY3xB+YdCOjGacSjIcHoHXVw9/CFN?=
 =?us-ascii?Q?JIB8prJEP8ugU7VU+7PKMz8c8kaZ69mwQBxTYtaz3jrS90pY+og/bia/YkXz?=
 =?us-ascii?Q?CDtASqJEXd+inE7WjW5fTzGT0oCS4USrXXMG49jkOlqU0AtPUFW6+HMkNR/j?=
 =?us-ascii?Q?u9Ek8QV7i233KAvm2NNsyv7hMCeCgw3GKOYw7NMTQoL8/V9xKvZjJpsEuzLd?=
 =?us-ascii?Q?93IHr2jmpXuwn6AhobCxnwvzgE3b+onJYKSqQbpFms7TXDemVzE8o2XHPn5w?=
 =?us-ascii?Q?qewBQH4Qn37O/EZjkYDeApVRKHeQoQG12PFciSNNJZPe1EBCGCsud88v2i+/?=
 =?us-ascii?Q?4jzlAjGVwY4r8wwvZgpRzEBG8i1uZNZt4GVaAGZfmja5Dr0x173R9t4T8gUx?=
 =?us-ascii?Q?V+N+DBGav5254k2f4DzYJKBU+HTPMvWka9651r2JcxWditpDpR13X8UrVb0r?=
 =?us-ascii?Q?lv6cRM3TcASjylxOF5OCT0eZrmJc1oWpLBheMGPzuA24MEF5IKSwMKdUtzV4?=
 =?us-ascii?Q?MEGFPe+kM8rIjoXakSTGMCCJR3R1dZxTfFRgJwaKqD3YAoS1Xm0IkePAQpXU?=
 =?us-ascii?Q?j6YLRd/8RjA9VNiTvmG272d3AizrgudwLUGwxg5ExC81Skbfn7e4TqlYpcCn?=
 =?us-ascii?Q?RMwmWynllnuqgmAudnz+ULfUeuzMkfiLaAAiUcJbUR/+Ad20vykvTT05FabJ?=
 =?us-ascii?Q?Ih/JJVLZBJ0f/XZCSIpF6lK5XjLGRqD4TWkpy6aRhn004mD9HM/iVKccyIWE?=
 =?us-ascii?Q?gqgykI3P6/S/5BUlCeDSeKpelSKRfa4/X6c/m6HP1ncxgpCz8wpGxU/ulUYB?=
 =?us-ascii?Q?8wW/JdQMg/ACp9affNCSOfOwe9uiPlFu+DHsaqRLL4rWZRNM1Vql+1/Zf92p?=
 =?us-ascii?Q?hPXe71LmIc11+52KgcpsupoRf7KRlGV1TV0+/m8b2Fz9Ow=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k7A0GSDY2WibCPCJWfTqL1U4sp9SYzoLZ5vdu6F69gc9+zPDGcFeTG1eesDS?=
 =?us-ascii?Q?fu5sozT1TH1LE9MTBE52Gjy4np3EVsVvwwMRo5oT7glBUKdnoCs2dOQBKRE3?=
 =?us-ascii?Q?X3PGnUuV3GeMxXispgg30DjNKTyi/qtHgQFxpGxY3GYlmKoSOOutKm4RSa4Y?=
 =?us-ascii?Q?ILwDB73dC/2/ZnwesbN8dC8fQJKeKDt/eWkBbShvrFzT61Hl3qVFIetEhEyl?=
 =?us-ascii?Q?0xBztuRJ0r7d0dd/CUFSb1DJCkQauAhbBPDW8uzqm8ID6xAWevp+F5zIffdG?=
 =?us-ascii?Q?6joGUTYsf6H5FLHO1EhK7Avgx4BJyhHOWnZr5BbfV7ZaFTt/1te/6TccAXnn?=
 =?us-ascii?Q?04UR9lmQPqCOpUfsExGUbFmY0w435/T4WdtHzvCKuZGPXUKUoY5+hBh6CIfD?=
 =?us-ascii?Q?xgxi1cH+R25pl8k/O9Lumlx12tSN7INuj3jl/2mPynBtaQSxtBsFD4AQtCD/?=
 =?us-ascii?Q?eWLcGbEOhTCnBikQjl3xe8+/sEoj/6KO4ZOZKhUqTxJvjOZE7hyBQ/xlS2dE?=
 =?us-ascii?Q?td0ya1g4r1eumXTddeBVGf5BLjeKq8kZo3fslGvpJKLGy5qmxVYYBnUcJA3F?=
 =?us-ascii?Q?7eyVwGkpNS9006tqIYgEoBfulSDY9RGQileDZPIzbwIKU2+Z2qJ83M00hyiC?=
 =?us-ascii?Q?Zfhv+gYga7DXJ82N6kZwYyd8qXer4Gwcuh82C8CeW+phDZXiBar6Ek+TsYf5?=
 =?us-ascii?Q?UxzDm9Ditez9WwY6oHUVbDqa6V/mldr0MD0G6B8FnDRVQCBItdxR+YzCRAYx?=
 =?us-ascii?Q?HWCyjmgPfTr79BGCnxvZq74I6P06OxgoxioAuuCqf5qRWepDjDunSaVZc52I?=
 =?us-ascii?Q?2iyeIPESlcG257awFnDD+xG3M3/0EnN2pnbkrET3FPN/qcw/HljMJb7A323j?=
 =?us-ascii?Q?yYKp3LQoMu48mnyHeFvss87b7XAehJtZFyibNr4/Adl6Olr10uD5Uax5fJrB?=
 =?us-ascii?Q?tfmULrffK91nuqMMIWasmQbIqaVhe93tms11s6BCgIK61wCD0+gThu/bYKQq?=
 =?us-ascii?Q?OSw09R8KYO9Dmr5CsuTF9wSFF6KarHcWkGJx33/dMDpMtA/oGLoCcBm87YG+?=
 =?us-ascii?Q?nHjjeqh9Q0ph3f/abyZKO3JJ3BNesCPYyvUMxsPaP6N28Mfa47xc9/1+q1Eg?=
 =?us-ascii?Q?iD5I47pLUIpg8AZeoUwBUIW1QnS7OjWCrA5zUlmvRcMHmk5NSiqGunq2SOgN?=
 =?us-ascii?Q?lXialdl0bBvYOf8e8SPcEsm4rxGkT5rB6y0X8n7oRwsRBoJTJVr/Iw6zbutt?=
 =?us-ascii?Q?BtUkJcy1ukXsPCbt1tTrdrsx9CDbrOXuhmzp47sTxaeKfFeE/dnvWs79T3az?=
 =?us-ascii?Q?e/K3AjVGKwdENfFgOrSLAN5XJIhLtoNaOjvLzNZBst6EdrOQvuAILsmQ4vkI?=
 =?us-ascii?Q?BXNsJ1jPdzgciJptoxiLoDPDTVVZkgEIoA5dbIYVLzsToVTERSEt4L/qKpRi?=
 =?us-ascii?Q?7iR0IqSpvLK92aa9kWofOCvBsxXSvB/ZaYaKqOGtxhxRXPNyBBqqOqUiqDqi?=
 =?us-ascii?Q?ghxFFQqW4v1Kqd30fImJ0cDrrreRJmxcwSV71bZ0jBpf49IHyhJi9sRdyit1?=
 =?us-ascii?Q?/ykIiK3hIC961T+rcAT3cP48nhb8pkikZJWozgYge6oJOInCk9UdJ1STZwoJ?=
 =?us-ascii?Q?Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uCk+35UCk5nAq3W2YSo/KfeViJuPa28gYCTIxPIDXqgYzjxWgcI4bfxQoRTHSaHMbo1Q3x/+C9YyzqhrcCJZZcRMYIkNU0TRK9FnubTcIA37BeDKezW73IhK/690HA4U9Zc/YR2dZ67T2DuMuJh8i5v4hdQinSsL6zPx9h4TIfLGfU3ob3YdJAqw24wFMdRhF2x2xY2wqI9Wv6fwtOX+0ZsFWzRR//zinMhwpPWMt/+vVhvWnM3O4UTP6YmzY6t+4soSI2FL0V3V3zlDA4wCIw1W+4ZLD/4MXIKr9njhe5OE5EpYFFmug/5ZjS6mfGVsXPR4XKA8gfBWBtnLJejw4z6+g0IwLtOxK7OKzZoEMcWfsSzJHDSO/Kgi/TejMDoL6erJTV99rIXCcq4dqNATgaT2bDpk2ledneC0HAuwPC1XZ5G+hLlDFickxbruWpvYzAkhpV+++CGsG5yqTANcBzlU4D90wkKlxR3/4T/3NGHHY801uIxN4vX6N6eTeRFVuEFtebaVfIPkenR+G+Hq7IQ36obELectnE95YrauO9mmLohs4SQsaNv91nMVuRHa9Xc9/+BpplvnjbzS756tossUkZfqkLCw5gXs2Kw2jBc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62d6106f-8462-40c5-5d7e-08dcd396ac28
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 01:52:06.8053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z+ojOHfMr+k9KiERmCOlkuZkrbCjzoGufBzEqhnMVNlWfHYLMGfOw5Ku8tkLVCFUuSdSdKMbI9WuAck5y6/95aR8yXn2CUDkxMMmjLz4UeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7361
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_11,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=895 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409130012
X-Proofpoint-GUID: DyLb7Tkq2tUPL8CzQRi0m36U3ttv_LGj
X-Proofpoint-ORIG-GUID: DyLb7Tkq2tUPL8CzQRi0m36U3ttv_LGj


Christoph,

> Now that the field is unconditional the helper seems a bit pointless.

Yeah, maybe. I'm OK either way.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
