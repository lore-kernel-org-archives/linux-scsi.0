Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8284E2BEFF3
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2025 18:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750098748; cv=fail; b=p9mCFZARDDZmgbNoi7J5Abts1gduie/tL4kMlLNrI7AmZ+ZS7P2b0iqB2K2ooP20Ou+YXJOcDGklC8NOCaZ7fo8r8tLDGM8q+31btbsOXC8/VniIAKY8Lg0EMXodvfXp3wTdruc7TPv5ejpH5eaiL+FCPyUjtvuKvxyN50icWQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750098748; c=relaxed/simple;
	bh=sqVGzdiPnnpzg8A9A/skztlmUtfgohUsPyK4vn97pNE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=semedMKmzsh1E271ZJluweu/cBwr4gt3F5PeQDToGz2B5fdW5HG/1k+i9o82YibT/JQ4IpzI0UoQ7Hmxarzt6UADA29UE4Iogw5xvSsr9O84cTp1i0vdm2w2QetJPPx4XnP1j1gB9OGTHOgue5FDU3l0JE9tezLVbKpINChP2tk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PktUsrCO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=i7swfZfR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PktUsrCO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="i7swfZfR"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55GHuWPY025016;
	Mon, 16 Jun 2025 18:32:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2xuXg0VBUY7VBFOyqu
	E4cuYjtEddJAJMCBFATrjU9zg=; b=PktUsrCO38E2Z0nw+yr8Y3v7JVOLWvv3P6
	xSsjoXRMtt2CQEBUNcAf1an+e4cFKrcLwrG72mlx3Pw7WDXvqdnJoRhyt0PgLcPu
	M6d2L0reCMgoxP+56AsfI+rG/sAzrBpdYfAmD/LUXE4FDVqI7iufV8oBiA630AGw
	RfwYfBFmc9pbg/J+IifcURE11iTyUWNa1ggCkzD4S/8DdC0eYo6j5ZyOAnSrAtUM
	pdRQps5bE9dlPZ/BOhluwveaV1Nsi509vczbR2VGMXnPcUPBTk5ZULDirnI96SiZ
	1gfymfL2FSV2YzbrfazKF7P6x4AhxQfm6YhL2oZdr0qsdu+Q7xLQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4790yd3fjg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 18:32:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55GHLVN3035184;
	Mon, 16 Jun 2025 18:32:23 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2056.outbound.protection.outlook.com [40.107.236.56])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yh81q69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 18:32:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GFSZqdCHJZKXSZPEkeHtg8hCNck/rUa9AUAFPauBS/5Xi3epoU9b5PsJctzWAD4dsXy54LgQOwrJOSSLyHcFnlG1XbJNTq9VJTfQqkPswfQuDzpX7Bcw9ij2ME/PXjfzxiCmqGOVluPprMLVj+n9AW79G48jCxXEaK7aF//DCOtRp/zC7uqkQQYMFlMVUoTnZ7hl5uQbloFr05jtUd2mJYR7Y6MHlpzvzgtChZE6zHXe2hKhkxUV47Esi1b+ZqVZI4KjmsbiC3k6PorS/qPbmmPrJBzWB6gYeXmIvyYJ80ydt7eGvDTjA7cRH2Q9sMOgxtTLnybHXDCwdwx0Hu4vXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2xuXg0VBUY7VBFOyquE4cuYjtEddJAJMCBFATrjU9zg=;
 b=kdcrLOST6rYPG3XCH/Gvy9ul6aH5bLszeurlOMASmvpvZLoA38SJWZ+ogniePs/wrAftRCteCMaM0aiAOVqcXWh6ki5Ijb9br8+vPHgIMjeCU4ohUWJ0zawXDGoZHSxHlcHsyA9Z9HGoge2OghFHtI23Jneo4ijnpKCHscCMtfsHXhoQIRdh5HTb6l8drC7Il67LhSAV3ZPJOAG8NkYnKfH7gy+KvssfXz+zHErgbbBm0rr03SH6jc5YZYJO7wt8FybxUJTz7OBewBXwxcbdrTGDGE4fAYpONchAnwPy41/Ri3nKRbcXpwNnEC5KhKnboBU6APZ6KCxqiOvf9TuFFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xuXg0VBUY7VBFOyquE4cuYjtEddJAJMCBFATrjU9zg=;
 b=i7swfZfRF0xR2OIhjBhBZmWBLT2u2v5DXvFiOQXgr4ViI5JeWnIp/bO9Ur2hY1mXB92/YbmT+aMiFiIxY0CYCNJx8Ov6t/U5G+RBMs4K31+ONZa5SZuhiaiO2Y616gJOnN1xRXCy1bjWrUkyFRjrDbV1PgJAyLq40HzRby/Wbfo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA3PR10MB6969.namprd10.prod.outlook.com (2603:10b6:806:316::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.26; Mon, 16 Jun
 2025 18:32:19 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8835.027; Mon, 16 Jun 2025
 18:32:19 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] scsi: Remember if a device is an ATA device
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250611093421.2901633-1-dlemoal@kernel.org> (Damien Le Moal's
	message of "Wed, 11 Jun 2025 18:34:21 +0900")
Organization: Oracle Corporation
Message-ID: <yq134bz1qsq.fsf@ca-mkp.ca.oracle.com>
References: <20250611093421.2901633-1-dlemoal@kernel.org>
Date: Mon, 16 Jun 2025 14:32:16 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0048.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::36) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA3PR10MB6969:EE_
X-MS-Office365-Filtering-Correlation-Id: 12d6c1b7-0560-458a-2646-08ddad042089
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YdVfFdh7WiObS5MbQTGFmq14NsSIT56tWxkBAl5uro60RJzqD3yfm/luwIcg?=
 =?us-ascii?Q?h0fyp9Fu3IdONb4UJ08U03lGXUN7NtANeQD5KLlyqlbuVYlo5HbEb2MJRxyi?=
 =?us-ascii?Q?b1henyBYagUlaJmYTkquVjS73NUvVFgBJhWrSxo9WRYvXukhDzso46G2v67Q?=
 =?us-ascii?Q?ijApjsfyN+2LEfquXC/YM22a6pUicUdGlwdOTHlRDQ7Af8t0OTjiACNvWrAK?=
 =?us-ascii?Q?NC6gY8PNotHS1obDzcNBQKj1a1l6wJfMLhnHyOA1NyLwRBNxx6B5nws5yl9/?=
 =?us-ascii?Q?Dvo58K6n8D9aoFxTr+KgyCDKUbc1dhwek7BoPgVzwtJCWquVA225xXKF5r9C?=
 =?us-ascii?Q?Hi9qMmM8fz6f6Vt5unOKTD7WHcXu3Qk+J0Kd11+m3Hsu/PB1yVtc8avCUhne?=
 =?us-ascii?Q?I8mY+SH/f/jm5bCjrQ1Z3/e+tiCLBMtbYJxVLvQLfPzU74PpBajnR5pvdKhq?=
 =?us-ascii?Q?XhqOAak0H6Df3TucQ7+5Rc31OgyifEKTpmQtB1hWpe/4K75fKg0Xex618oSM?=
 =?us-ascii?Q?XzD4IpFIpuPoSTkr2yZlx/YOJdRT/J+HgOqG9n1FBnLC4HmqQ/RfLuAi1n8I?=
 =?us-ascii?Q?Z+Y6LMMgflKceuVsCVyZHY/nDwO7EyRh5/Qqky11tStPwCO3bHSO+vhGihzh?=
 =?us-ascii?Q?+wSxVQQYnEgbWZ1+frxyy14xtO1PvR7EQ5HIpxUXKtok+JoYx+wLcukavIG/?=
 =?us-ascii?Q?v01/nlhRcAGxZ+K/3Ve+ByQDhIwUvrBPe7oK03vwEdlockQTA7up6RBBuvJV?=
 =?us-ascii?Q?E5vR6BbMe2jYk6M5UGSGdEJ4wePjONnx40700PP2KbmQsSAABYeRXI87M2Jp?=
 =?us-ascii?Q?y2tt/ktMME3ZORAiS4vKvIrmW1YYq9rgorEZo2bp+zWnELU9Gd0nYd/VHSO3?=
 =?us-ascii?Q?aSJsJ+rEYfhjhomda4wTX7jfyyvqlNm/0n1YXCD5Lg93Lbr3AooeCRv4A8FN?=
 =?us-ascii?Q?h1PVeSJuo0S36IauVKYIUH/WRyqzXJ4CNE/Sp0MZVl9RW502gSRpXexq2KUy?=
 =?us-ascii?Q?UwEbmBJpf7MQ/ibvm25xiScdQ/7vizKPgAEX484FMw2k58ZRSQ2l+TMcC4SU?=
 =?us-ascii?Q?ulkGYUxOfmLiJOE0xGXZN6bg8BqIYD1Dl0jSAwZib7gKAtlXeTXaMCMW8LjP?=
 =?us-ascii?Q?N//p0LqpsM+hOhJglzZ9J9Ct4DeK31ansMxYJ/l/E8hscJigBZLgoSekR9x1?=
 =?us-ascii?Q?9dilLXahAys3uwkNGIiW4K3wuafcQ57twezlJKJZJEN2kCepoWXNZNFiVbZI?=
 =?us-ascii?Q?dMkgxBkJa3hARDm5wr7mABjb8FlTRaguxTVPMdkziB/hBLec7sOrocuKXPSH?=
 =?us-ascii?Q?pL+SHbMvwV1k2nKzqtmdpsJTBPnMQYWbYEKe2ZBv8ElBtgLoO2Pf5JqePLBW?=
 =?us-ascii?Q?YMgnPNxtZHaGrd/dbHzZNpFToimFce1be3h7mad3cWi1I0T7x+hwFr53g19U?=
 =?us-ascii?Q?gZPhLt6C5fc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sVOsQRbAd70oBpVpXVfKKGuT4gRzX3wdmrSp9P4516s24pDJSgY89ZrLU/e3?=
 =?us-ascii?Q?fJznBtcG9r1ftJalNHmd1xC70ek+b8Xt4B1l/hEiVIGpK4iU/2VzmsJyTkJB?=
 =?us-ascii?Q?oyaH4crn/Jf1JB5/+y4a0ptTFezwSBzQ9ygutdWw4U1MnKvIRJS9lzdmckpA?=
 =?us-ascii?Q?ZQlkG/UvD0GFUI7tBctesMo7ot/fS2oBgHj6GDyKUxS1rwlfhuhmuxPQc2cX?=
 =?us-ascii?Q?NUHuk8TC1ikwcUqT2N8LlRsUAzrJKEYULtVm/+HwkuLam9EazJPrSytbBWba?=
 =?us-ascii?Q?WzSZB06sPbN9sfHHNfXcNrhXZ4Sj3zElWcuj0Qnp758/oxo7PJtqv9ibOnsZ?=
 =?us-ascii?Q?BX9tbVDSO4b/NePGTfDaJIWQoUZWT1u+bXzF3UNChmhWNBMfHK8JtaJBbwEM?=
 =?us-ascii?Q?2WfdefYxu37DQEEV4vW/DQ3AruzvGRzflqnIFbUCo2ZK9C2lhze1FoXWzqwq?=
 =?us-ascii?Q?q9SYa8CqB+1JpsVzRh7NhPd8qXA6xKTqVqW+mPqji7heOPUYUS0lgsxb2K7c?=
 =?us-ascii?Q?oqRGI+6ulcssyh2ngXPWp5H7yuPqnO2655dWTzWj2AuusqZwSHJFqpvXJhFE?=
 =?us-ascii?Q?ouHvXVElxDhLaZE8G0W7fmx2NzC8ikaw8m54chf8DIs0wqjT49g0X9dD3Xvv?=
 =?us-ascii?Q?EcYNLTn/U1kBonuKWO62LcFkZsxzksRZYi+d2YOoKUcdDv+xd7KZPBUslLCQ?=
 =?us-ascii?Q?O6gqrEh5yWkqaCF6qE/gyS0Q0Z+wvpECSuV3oNm3rrklntONkix3c+L84hhD?=
 =?us-ascii?Q?gNnsijQIfPFBXIgDSNvTSNUJtMSA4R32QKBc1RG3dmrgg2ebGYsKPTkxytwl?=
 =?us-ascii?Q?7ytar2dgTNai9a2p/jOokpl9ecnUjoIWC0D+cvFsleaXnKaBa7gR9yiVTXDG?=
 =?us-ascii?Q?drn9uhBs2n1x0cM6tGm9+ZQ4WVHN9K9YG9zF3CIQwZy/scvXpI40E67iCT3x?=
 =?us-ascii?Q?K2nHj2Bbr7YQHjnHopUztDMn+2vh6yJ9biKdcgLwKWO0SWfRLEAn5EdFi+B8?=
 =?us-ascii?Q?/ipK4J5XJADDkN5RUPagJ72e/BekGrJKpqSxH2mDqIEjw0Epe/yBfY8ayU9s?=
 =?us-ascii?Q?WyQc3dtHEV2JcYiK2PF1JV4/E/PT4YjCGZVqjioAKKZY6h3jCEsM0o6rkeIT?=
 =?us-ascii?Q?vYkMda6pmSArn5pmWZ6/XEqhNxbtRmX5T7AhBQ0qd6HFfFoXrF61QPeu48ip?=
 =?us-ascii?Q?alRPTFhJ5AGtFn0tdokv7ZXg31zvqk2IvT6O7rctKRAXc7KnOzFwCzi9NGN8?=
 =?us-ascii?Q?/bm0fW5NBmSgr5L3rIaQ/EfcH/qW6s7tsyqbo6stKq3dENVZymfISy/B7Kei?=
 =?us-ascii?Q?UHyQirFNj3xme7vkHvMgb2Qs/d+sopnjRTl325QuffVIwnQ1mdsFwt8/WJ1a?=
 =?us-ascii?Q?VF7GStYlpyEU30ASMKHlWdMBYT7TI2CrFNw5RXA/V3srLrwfvL+vLmaPx8xY?=
 =?us-ascii?Q?/7c1qEb1slXnEkPBTKN6I+oaArCP4UdkATiLFdxODCvBxfCOo7XbT1f4JXAz?=
 =?us-ascii?Q?Pz2S0zs8710ceLKt0SZ1TJ9Xs0eflTPlV1W+EzZdmekOm+T+QmtyX4cYWUPc?=
 =?us-ascii?Q?lIdQGdY8aJdE8uAL8vcBkenuDMR/TfrUNdH7IEq+HTNpNhADZJ4tgbltBwkD?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WhiR9TvuaS7l1DOQUWtDhpYQjokaIEtLL1JUMic+j/w8BPz3fhcZOpzUDZuSwhaesD9x+F+jagexxmGlmBxfEnYA1ZyFDFrErgCbZ7UZSxyG2FsgcgGaAi8RPeKLVDg/n0MZEyJWLsnZxZi54YQFOYmK5RnmRMQOocB4esPaZeEdndTo/y79MSgEVopsnZEmYIKD2vliWTKzrzUEw4PeGh+y6IsgUgntN5SEd/cvcX2hBB8COrjiOfolUQVrYU9wembc6i2EryWbBPKO4uuXlgZOqh4vzODei8bn8sgxHNXxXeKuawuovSPqYu9MxPewWwwSNMg7VpF2zALYRAx3oZMvcYzaNps0PuHgNwLJMXk9AhjSrsfhcdM7WhlOBxPh49Dxv+SvshhWH0ALmcqmQO0WpK18DvWZEfNBlgK8UFyqQDGSkaJdM+8bCs5rJ4gubRP/ePIk6ato+YsR7vSzHsCEDdCtDMyXNagos8xwX48O9y61RPI9y5ww/c+iUQje59UslnL9gB1FIqEOGF44P4uWSyiOwy+pTVTGqxxK8x33fvCN6N2KDicCSbHBKOxKKlchnYwL8kr/kSMgF7FHOWJSrA/SqKHWdAp4VqXTPPg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12d6c1b7-0560-458a-2646-08ddad042089
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 18:32:19.7040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9R3Ho6kGXK7e4E+lsgWClzXCISHZL3uMNnidldIxSYfAFlCF60boxjm5nK0YhYxTC6XOPfzzFXJAl5msPoKnv5FKnaq2grHpekcMn8KQMow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6969
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-16_09,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=937 spamscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506160124
X-Proofpoint-GUID: JkuIOGCkz-FCfi9Z9Z9s4EN044tGDbaf
X-Proofpoint-ORIG-GUID: JkuIOGCkz-FCfi9Z9Z9s4EN044tGDbaf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDEyNCBTYWx0ZWRfX9rGVxN4SoJf/ grfrGlFjYZt+R4sUt+3qIT/OG6sFvBowbHe74X0/pwBrk3JtHGzqzNx0xLwgZ1tEXSuuuWj29ew kziEuG7u7XB26m1X8h86R6EVcsKYnhVVHGBdLFJ49JT4BDS3Th+AtEeNmqyDbfD4iDqA973u1PI
 QANbWWLcOsPHG7DDYSmKQFSXoayHfQ0BOeW4kDeYaWUzYgmq/0+N6GxcWFCtWv87XyDEqJbVo8L 84cLQtn5b7wqrkNisQHT1FrT54BJQXehsQknhvP/OVtLDJsDLvxGNDPYB4KChwWraAS8tpfyl7c mneOnwQVILtcXSs9Gl9ReW8BZoM/eNg4jysY0zPNJyHA7sifCVFNmRriTHydaBn69pc8WVm4KXc
 aHt+BZ/5DTCaYuYKZrnUIYv18JKOXoZX/dziMk3eGtjDTlFxzlhChMQifnBEZT09H9/ZNJ9X
X-Authority-Analysis: v=2.4 cv=XZGJzJ55 c=1 sm=1 tr=0 ts=68506337 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9


Damien,

> Simplify these different methods by adding the is_ata field to struct
> scsi_device to remember that a SCSI device is in fact an ATA one based
> on the device vendor name test. This filed can also allow low level
> SCSI host adapter drivers to take special actions for ATA devices
> (e.g. to better handle ATA NCQ errors).

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
