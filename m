Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C6B20969A;
	Fri, 10 Jan 2025 21:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736545181; cv=fail; b=HWxoEfvkP7bShNaLMe5KoqRlL798xLclfqi60LHk1zw2QoVwtvmYV43cAxmWEiwLP2Syc5JS/QMh7Evfks8NConmbP07o+9tQbei6pBY1vQE+uZ5xXSizizAkQoV2UX546SqDoqn3ajpGxu2w14LiC9W2bQebj38L0nIoYAfeZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736545181; c=relaxed/simple;
	bh=grh/OK84doJSZF23yXzPe7WavUNHgOE0O7f1wyo1OA0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=axYZjpFha1Ec7SolAg8FeqqwE0XcvXNZIAYpI4hlB/V7s+eDXWP3evXh+ag+xo8fkqqLg6G/pPZkBMWKzgm1uf5R3LAmCeQFg/hdab+XizOIW4r5sfRA3K8ziAvquVYyw1j9XHcIUk73cepUEL1iguoxvk0MgE0n4yJFxH6iMVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WF26sz5/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U6WHBqJW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WF26sz5/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U6WHBqJW"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBoTZ022213;
	Fri, 10 Jan 2025 21:39:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=2Wx41Ejw/Som/EQ7vK
	oIYMKfbbetiKX4E6jo9tXV85Q=; b=WF26sz5/mCMTbb+cLgUA+02BRnr8x2O34l
	eJhZ96MXMMDBWuOQ72zakcVHnUfxEP3dc/aygKpd0PICfy3b3lf7CiPdLAT/6RN9
	jdvB9ucj043p627RNkBOejUSC9B3FvactIo1LCf218RUDeK7Lap9qJL3gW//jouT
	WFcJ2Gf7lqkVHWnWpkUi/UzdbGzm/kEg8lCtEGC4olNXYa5F4kRdudfIHm+/2yTw
	ldPWEncT0RlJbjkJkSG/dbZW9zL4ZMi2GNrEPuJey7eHp34Xditj68VFuOLJS0my
	YxlX5RKkw9U3e1GpC2onL0cWzzvMSpt5hzYGoSY6OazbtxMcIZ9w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xudcc1q1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:39:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AJeHrD010941;
	Fri, 10 Jan 2025 21:39:22 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xuect3kh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:39:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OSqLpS0hsOyrPbNOT2k+h8WtXEfZxY0dMfykZzUji78kZn/88QYn66PJaqWQGUey7LMWJlq/Go26+s9ocf6W8JdpnWjpWxi8kaqBxnwrdpUrxAjV2inZtYyuSfLdgSRXS8ONw/uww7gmznCZUmqbWDcba1Pq4Bkvlv2ihJc0BAMiQRq0Q3k6koM8SrxoRrhC/5tWPUEgJmnkqEdOvOGwqYLlRYCExu3Kca8/afXDE3loVEFyC3smYKNyCK1tT54mryA4SB5fr8BZo8LMpFGcNZAtfgktjAIlL4o2L95pLjx8nXNJ4Vxj4B6CheqwaleVisSZ7KdZVZa49cvx9i8F6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Wx41Ejw/Som/EQ7vKoIYMKfbbetiKX4E6jo9tXV85Q=;
 b=yZcLFgJBBY3RnEb7U88XEYftm3lv0SzEb0vmhBU4Jqtr6Ee2/eIp1yV8WQpQlHSwmaXf/dxKKNzZupT7Wjr6lcJthWC2oW00n+C2uUwBXbWUWZRt0BufMysTINZIxmRtTEJWmMxNC/qaTWJqUqa9w6wcBys/mNmOZRqHiBE9duB2MFdZ6AeaLDreNNpMC2pFOaqjlTaSjYxdQvLWolZ7HQhUCFRZWbW3UTiZOtKq0Dp5YtY87iWaYFmRUnsG37oxSsrT/iaktUfZV5NR0OjoOGO8qkc/bjcmH8H0FXDSQN1x5FaZYyAgE1Jfzd7/jkSYLOOhyRcxVdrmCpw9+Ccocw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Wx41Ejw/Som/EQ7vKoIYMKfbbetiKX4E6jo9tXV85Q=;
 b=U6WHBqJWSygxhVg2zHg0Odf+eXm1TPlllxXQaQjIvCU5xYhXD8tMme+Ag+vDts75ZXyQ7e54qonHlub8uWT79KAVOhbPuXtlv9g5bKtLpKMj8IYCdxqmIlBhuOrxlWj9Z0suMN9Gs7CBg8/UmewAC3+0HRHAPAXONHjNL1ZkJyM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO1PR10MB4707.namprd10.prod.outlook.com (2603:10b6:303:92::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.13; Fri, 10 Jan
 2025 21:39:20 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8335.012; Fri, 10 Jan 2025
 21:39:20 +0000
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van
 Assche <bvanassche@acm.org>, Can Guo <quic_cang@quicinc.com>,
        Asutosh
 Das <quic_asutoshd@quicinc.com>
Subject: Re: [PATCH v3] Revert "scsi: ufs: core: Probe for EXT_IID support"
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250103080204.63951-1-avri.altman@wdc.com> (Avri Altman's
	message of "Fri, 3 Jan 2025 10:02:04 +0200")
Organization: Oracle Corporation
Message-ID: <yq1zfjy5oxt.fsf@ca-mkp.ca.oracle.com>
References: <20250103080204.63951-1-avri.altman@wdc.com>
Date: Fri, 10 Jan 2025 16:39:18 -0500
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0058.namprd03.prod.outlook.com
 (2603:10b6:208:32d::33) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO1PR10MB4707:EE_
X-MS-Office365-Filtering-Correlation-Id: 62fb58a6-8f08-48e1-96dc-08dd31bf3d8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?H2pUQ40hUR5hfGeFns5wX6E6Rss6H3nW70OQOJKjPGz8iIBC9h2km7ikh0/6?=
 =?us-ascii?Q?NWByhmVBqD7KfI7v4vFGiWlSsAee0G6b7+eeyWAutTp6g9FT9HkKp16GsPjX?=
 =?us-ascii?Q?5Y+6z2wi0S7qOZaotPLMkw/mtlkKKH+nIMeAOBMWlL9+jk5cY04zaU3Fiqme?=
 =?us-ascii?Q?dKj/ggcMMK1K8hh982Hm0KRNe02wWT32gmiGYau6V5ztlUpCD35N5CputmWS?=
 =?us-ascii?Q?921/In79+VgbAolNOUEmhQF96iC6n+Dvs551kojKc2imqiUrd6CRQVoC+GVV?=
 =?us-ascii?Q?/F+cKL8/pfGmNGU8urjhbLp6zIUP/3D0/sZxqPYwLhWgLP6GCIt1DWQIqlTY?=
 =?us-ascii?Q?Xieopk1BE6pWD2aqQbdN3ZQmP1Ti3lWJbK+8Abu87LczX4Vcdc+WkzmYIdzK?=
 =?us-ascii?Q?SMODuTQKbX+BGWeZhH5bqyDVInuO0/NHUCF79Woi0aFQKjQYerN4fVxZ2tfp?=
 =?us-ascii?Q?YSQjBmHVQqc1VtqKKeMIYCiJhO2AYM/5n9qLfceo+WGRHzpVdbBJNGEDdtTX?=
 =?us-ascii?Q?wiSEdAXn3+q+6n0uqfM4hpDMtJS0nw+l0QMAN0jFN9COymaelYsDZb72o7py?=
 =?us-ascii?Q?Vr+jJlNgphYbufIEP6euoq5zVqXMqTE9HLT1x0idqEx1cd6xucqVUDwC9F9K?=
 =?us-ascii?Q?6B5ifB73Saw0eBoBv92F/edQlV5lsMIbgc94g+KQyL5Y7jRb4pwe5WAiSUOs?=
 =?us-ascii?Q?YHt8Ip9PnMcG3qCVYxzElyyD3hEl8i9TS2IXRs9tmxoRg2qquh94+wL/3hhA?=
 =?us-ascii?Q?IhRK9VKhch8srVUDwFfNf9/gyUqSfTOLrzsdiiATufGTX6btiW7Uzt/KgsU/?=
 =?us-ascii?Q?YB9a95xPv5T6rZpDXdoPsbquqLRkDZnWT5JtDuczi78caDNEqU/NVndW6cER?=
 =?us-ascii?Q?D9JUEu34R7J4pylD7rXDg12TGf3cIHkkobPavoWaqpexDiuE4EZZbINCXdOM?=
 =?us-ascii?Q?09ZHjoJgJqjm/hIXJPHJQzhLatJoM0JnFX9yuAYrv092USncjx+ndB+r4wAt?=
 =?us-ascii?Q?+JfjpPXj1ITD7vcA/fKBd62SnYMAjc++EY2blsbEYrkwDBZPEKRWfU7x/nBs?=
 =?us-ascii?Q?9gswCwj7SRwR/BKsVWV7O3jxJ5JzbyS/ni6CyMvLnHWwQV0iSwpu1UZSHSHY?=
 =?us-ascii?Q?XItiV2gBdB30wvk8ZPvKLNWpdFQU6iEonxcPoWCVie3sKWPd4QbotmTLvLq4?=
 =?us-ascii?Q?JQMMilnaRiBC6RsKJxYuolJgTV0q1xW7R7lnkLxEi/qXcN/OHO2juMnzEp2/?=
 =?us-ascii?Q?tC8FzUFdSVv9VeRVwX2ciAW7ki8m7ayJ0xkDFOos4NG28w4oYMQLMHVk2Ruz?=
 =?us-ascii?Q?9IUjSdYuz1W9odalB94GUDbKNXLDnFmys02MFYOOQFx70YrTbDqDGpTTXQey?=
 =?us-ascii?Q?wWnITuvNCCWMnMe6v1mwDgC9I1hY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1BxLE7pec4DkAlZvsZNXiU7Ls36Yaf7VP+5octemlYKyuPcbln/qzfR/zpNX?=
 =?us-ascii?Q?+i0dTTiPWrhdhWtOB+q1NmT4b6YFHb8/haXjiRg6iKPt5VirNY9ffaNm39GQ?=
 =?us-ascii?Q?tBFAMCeD4mnQbhEYzCnTJrwHi6uFrSmYKXzE3p8kbTL0NPiFj25kv4JHEwWJ?=
 =?us-ascii?Q?IrZl3JlbyNSQaG4A7Cw1i3YYaKBKXSZaVPKf7swYJPnMG5Sz1y4E/64ZrYFf?=
 =?us-ascii?Q?XghJz1sAwk/VJi7ThGupSOXI+2df9wzT4XcSMiyVPYySQ/Z8eWf6m9Sq5s8y?=
 =?us-ascii?Q?lc0cMrlKL75gPvxS1x0LmwgLBShNPbpTruIw+yhFeIt4+6frZP1Hgk+N6Z6i?=
 =?us-ascii?Q?xMJ248ayYwUpFvHSqDhoPdMFMx+LZ2zNwMWe4+3XkSZc+KRSWui1UF78sH5z?=
 =?us-ascii?Q?gdW3fGgNLGr3hYAQgEA/cu/Fos1+YdHC/fjxBZmB5k4/ba0ks1VuCi2Xzeki?=
 =?us-ascii?Q?wxj2+V4p8yPprsLaLXYyGlLi1Uz7TMt1WkfefCmhrybR9Y80zBD7suGhASbP?=
 =?us-ascii?Q?2wI5waSxsOdsT8drLzSAf+tlTvd/l49m3ogtHEjWTVlMlp08q2tXnczK0swv?=
 =?us-ascii?Q?ne61J7QMjzYoog/jDcUmCX6tkWg2I+VzPtIr46ktugXHebDKQ9VskdYicK6I?=
 =?us-ascii?Q?TreRH/BtuY4PCTXvauuGe1u8eR73AJ2lOAIwVHLZC//lK9gcn8uv3+ykA0EA?=
 =?us-ascii?Q?PnFxCClrXrgFf0w07cj2ikKqQILr41HU0wPnIZklaknLtxPcztjqKoO1bRzB?=
 =?us-ascii?Q?1eGLMhUKlxSondleFmDiv64cfvhNUPYbNGMgek6BXAaCYIPM6nvXE44j7RP+?=
 =?us-ascii?Q?GQfJ2jDfb1VpYp+LbZ5hv+UlnzsStF7uJno6HKUjvEGCAt9ByzzJlKU7MwVH?=
 =?us-ascii?Q?FH9UKbRFbAt/pjLFc4jXXQvMd9+ZajJJSo/Ttstmfim18pehy1Na0bJHs1Zb?=
 =?us-ascii?Q?XvOiHpW3lMdyxMBNH8tC9eG0GdXC6Y1uEunJL7/HlrK0t8mARV+LSlKJw0HO?=
 =?us-ascii?Q?07dLqL2JCO+V3niRIgRxnKmPk9EEzelsHvW3D6jCpMeZkOeI4DJzMDnv/L38?=
 =?us-ascii?Q?PxtMPlTfhT2FfI9EzeXA9pChFU4gvAegRXiWTGgACkZerDKDKlbmYXdxMVNF?=
 =?us-ascii?Q?jlmRxXAmOKVrC3LXblnl6PTi1DdtjWc5Vm+8yCAo/g7IRgMPaTmTjr591TPA?=
 =?us-ascii?Q?Nc5KsmcX9RSh5qnK1tILd2hU+fEbqNCXBb+xIGk14bCcXf5Z7v0+7h1UL0ur?=
 =?us-ascii?Q?+xRkArUl2aNBcDGkTPQvCp9bsZmStcthMahM34ZnM9ROjkFEoest3og8hnx3?=
 =?us-ascii?Q?0yx0uOqrYyKLgq87Rz0w+GvT7fy+6kFai0HwEiOf7y+VX6+YiZMkZ6b24GpO?=
 =?us-ascii?Q?Ahy3M8qi23zpHWJrjFFLEG1THLXjTL2g37EAhjCY0qmsTAJty1HOBG4QwYfO?=
 =?us-ascii?Q?eWpaNdbycfxoqLSfKrBb7wnwB29sfUs2o2CLa2iculW6+xg0iJAju8SFYhGL?=
 =?us-ascii?Q?X78HyOLZfdWW0WvLoApfE/tYuBdDYQvwcBxHzG3r9rTMI5rHw+ss17JtL+YF?=
 =?us-ascii?Q?L2Bf1fEH5MLEAZxnBqZL18YesUqMxLrJ7yJuZZkm2NcWDhF6UC5GJ5P7lT6C?=
 =?us-ascii?Q?7Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6KkpS6oPChzKzR4XS3B9/m7BoYnXgcYVFVfF5vzZ0rSLQ5TKeK/pNPEQYx8O0wp4pPocudjJSfXXwg4hrUuDaCHxb8qKZzcshuKYGawYCeYGcjKqCF+CGqUNA36Euzo8cp/zm/pCZf2Pxf/ZAmitM2t0JWitvz+hNiZ6S6Nktb9SFpTxdty30pJTPLZzfvwPYzodzpmWs2PPY/9o2LuUArv0ydv33r2iJ/MQ0HKiXR2ZTPJO6TakNn5V2FPA/1weWvP+gpN2ojFhr9xDxCdcmUfqjeEwelNRDE/NLRD6xNQAO7ypBwdukzmRYgtZJTLe9htvH7a7Ybrvm17dmRNg6JCBTx/nHxZ37Z4ePftnU1jspeO53KHwIGaOnCtuQdBWHbSn8qiYBznDKyzOAkJNAMnrETDu5S7nxWJ4iLIi2imZCymmZeLCJSOuuIXPo0PavYhzs/yFxf9iFlajFE884ajA7AjiecU45aN93cQWRqQmaWYkcOfGMxfjrjurBlUKBNBzg0gmrTF2yXKJut7b6FH4p6xqJVon9fZXnJ8MhFdfwiLOwq74xTiFVI70LXWimJbKZ6j6JmrNJFpnsaNzhlak6/i8bk38UtiwZyUehZE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62fb58a6-8f08-48e1-96dc-08dd31bf3d8d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 21:39:19.8764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bkaWktMHXapfghtqlU+3z2t+BG7ddUsgsVINZz+cb74G2rWxqyS6n0lXgavcWqZzhLtcirDy7SM9TlxISuoYTrjvzoZb9hjpzA1sjbU4bKI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4707
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 mlxlogscore=542 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501100167
X-Proofpoint-ORIG-GUID: 3nxMZ5cwcHk_zjUPh3xSNuHF0EXmB-Pi
X-Proofpoint-GUID: 3nxMZ5cwcHk_zjUPh3xSNuHF0EXmB-Pi


Avri,

> This reverts commit 6e1d850acff9477ae4c18a73c19ef52841ac2010.
>
> Although added a while ago, to date no one make use of ext_iid,
> specifically incorporates it in the upiu header.  Therefore, remove it
> as it is currently unused and not serving any purpose.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
