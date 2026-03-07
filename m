Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B1A1531C1
	for <linux-scsi@vger.kernel.org>; Sat,  7 Mar 2026 16:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772899672; cv=fail; b=d4lLxiWb9sfvb8nFppbmeYMzUvA91/TBvV1NRXTpSkCxGX+r0Mlv4JSrR36vXNobqdDat1Ej6DGuf6lrazm1kxQ+TqBNjnwi3rh9O6bApUHfcRn1yrgj8nudSrBqflAL4YuTn5KEgiaJRFf4T3MksAOV1uB7XLZy3ITvTWLDxz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772899672; c=relaxed/simple;
	bh=VcKViI602pDkaWULVvTydtJJHa3pBv4oOAaKQCvJ48U=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Yp1G9YEGllvUpGrakEqV2aDZftdNwibNEUFVEwzAP+rG9gmvWBWS0LPgWSyelGKSlqDTQCCUWERNyPg1XO+hWyOGfdsRhiPdh4mHxAMfKp5lpsb70QlOMVbZVE/OYmfGaRPxUuon93kIunoRU+3Pq285IR+fat/QIvZ6rPQIqj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pnY4Qrmf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=M4Df4w2f; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pnY4Qrmf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="M4Df4w2f"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 627G4EGc1948677;
	Sat, 7 Mar 2026 16:07:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+QUa/mrDR2jm4grzGp
	AkOiTL11mQ8hjefj3OGOZ9m+s=; b=pnY4QrmfkTIAfTrgBeUkIoSdpCyTBOuehb
	ohuHzmdDRJ7Af/NdaBWI8NctpVUZfgDO49OaRiEp58cqvtu5tIfoeJUtrocJ6UMM
	dkADtSJa7qdQm7RnlM3cqhmn/P+XFJMDSnFOKh4EVbjz/JTQu1RYfVL9wYSd32Us
	Q4wifvRl8oNOk2xQRkS6bsVUtng61PWRj6JW/x05sKNf11xkWWYJwkh64vKJkXh+
	YYq+9WjP/k4OkT1hH0YZbO0h9BVFKXGr4wOukcsc6+YE7lsGcU/XKLAbcC52O2Ls
	m3Ma/mwQlSUOxxsLfYG3Y2UQv+5Q7NcN4+Is6nafdqjeHC5sKf3Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4crq7br01e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 16:07:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 627BTubO022714;
	Sat, 7 Mar 2026 16:07:26 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011035.outbound.protection.outlook.com [52.101.57.35])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4craf762dm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 16:07:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LV4QTUnt8ppVLfK/gqJp1jnTNeUOI7vAFuikldd1xjCcNCelb+6xGKKtUlYD2gXV4gNLPnmWYPx1G+LUvrfHKQtBDbLq0nQ+McsY/LSbxsi7fSRHYaslwnTbRRwvcm2ub33BXJosPZ0fNKc6zDaLO5iB+cXT+05RU/qzPxXb4J+8jXVsqPEQFCRDjgm52fynZ5zSaKONKqzGKqXzVNjDpbA6u8L+sHGUKLM+SnvvLh4TOQm0mZykAQgH5SIvh3Zxt9Nd/GvC2BoBAd2WPEE6KDh+FOkpFJQXuuguOCFr16u7CSJAjpbjU1VJ3XBXEY6hfuFDfa0560I4uyYd4GNKzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+QUa/mrDR2jm4grzGpAkOiTL11mQ8hjefj3OGOZ9m+s=;
 b=gTiNww+YPs6qBrao/T3gXL6UgXI8vWtnrDyy4L1bH3yjmkZYoAsiYUtH1ToejIlUNzUWIZwyKxBXaU2iH+I1yqxI9U5wc2ETM2P2XrPy1+ja+K7qp/Kkh2BNBiktVVrhpJkjwliUNGfvMcx+wa6UFeDONlZ9fTqV9dVIAbtcS4YSxEk26JSmhjbBhgyUBi1qLQdA5g1wUBipo4tDPw1as3EkiDF8DZLiG4WYzXGGvFSjpxMlvzZOC8j1yg89Ako9UWf/kV3LQONPpyUEkNx8/bUTRfbMPi3QFDW4Ss2F0vCw3Zk5wNs/SahQ4wJOgMLrLuuyXFYLOn+yJT8roCoqHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+QUa/mrDR2jm4grzGpAkOiTL11mQ8hjefj3OGOZ9m+s=;
 b=M4Df4w2fXYtiF723rzOInR/mtTCPgXa7CrypqkzXsvwk3ZTaQRcq7x9KRR4hif1syCdPrj0KoKOhnq6aRXS4uECVjMlUe5HBipisrGlNvJWzaoYfGSaaHPlrDlv25FEm75kkGCN/ubWS2Bzl8dStp5vmaVpYeWGbDjyWcNQawCQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB7046.namprd10.prod.outlook.com (2603:10b6:806:346::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.20; Sat, 7 Mar
 2026 16:07:23 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9678.017; Sat, 7 Mar 2026
 16:07:23 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@sandisk.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <wsd_upstream@mediatek.com>,
        <linux-mediatek@lists.infradead.org>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
        <eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>,
        <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: Re: [PATCH v2] ufs: core: Avoid IRQ thread wakeup during active UIC
 command
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260306054419.3816557-1-peter.wang@mediatek.com> (peter wang's
	message of "Fri, 6 Mar 2026 13:43:02 +0800")
Organization: Oracle Corporation
Message-ID: <yq1ldg3wrmc.fsf@ca-mkp.ca.oracle.com>
References: <20260306054419.3816557-1-peter.wang@mediatek.com>
Date: Sat, 07 Mar 2026 11:07:21 -0500
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0014.namprd10.prod.outlook.com
 (2603:10b6:610:4c::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB7046:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d4479d7-4e76-4d42-5fdd-08de7c639e3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	//THClt++1yDRZTQmXzRtlntcZp9AgEaiX9uqXTDcrZyDP3yp5PFnxp2Tt0ExpjqjuWWCCpMY3Dsh6OGL+YMcF8bqsIzM8Oq2q+4MF79X4NTBrQs50zZ8z8apFQsJvO4JMnzAEqXI97OnU00OjxI2q/E04aY51h0V/z5dWW7LzGvTdNrALz1tLjgyGHjiuPe0jLm/4whfHO6T2980A7TbCWltwtsBCE1i4JT0rlMETINsvTsA/JVmx3QConA0JVdL6AbVy9VBCZjXRJsnL1taSWIqPnVSxmi08hebmU39y79Z8v2TtFi5wff7IrHX0O0IJoyiaTGNbwsgda8cWToeHMKMToSQ6y3SsrlsFsPKDo9PxN1GN5G8PlbgUiAYpZD0cBdCZGi3NV1GRJrpseY4mBEOWtSsO6aaCM0JGtJozfUDMZah3m5pmVYRJdvUS0C0iaHFR8LlktRM5kKzLDXvnfdKGISHibN1os8TRKJdE8VbC5PqgD67FSRJtj0bg52cUazQa2NEEKgXKLluM1c5eSWkLJ8/6frXsmr3JlxgCwdPahadspe/Z0nXH09fpwfAd2z8ZHuuxwTld45eORzzskPWASttdS32fjP0aQBUSCSpaZKX5w6S5HDPdADdH2A1usMvFMH62a4RhbLLBHEmWYWOSFBQTLsIQtC21k5U3wFYbaDR8Cbaul2UuZgwFA784lWai/anqC2qtfeMo68Yk7s0VUnQv7uen2bcNHaR0I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MvvDCaXX1zZlfs2lcbVqvsOkBk3H756qYigXaafCGWzUcIA5Eg58Py0rce6G?=
 =?us-ascii?Q?d/Ebo18+uK4hAcHrdw+XCM94KwfXo9x3unjep186R3UPSGf8+TH/+LBg7vK2?=
 =?us-ascii?Q?dn6PEhXnItpx59Fmf8ien3Uzy407YvA+fuQttaY4wI2SC9MEzP9T/QME3H+I?=
 =?us-ascii?Q?YMGJ+cu/27k+M3aoFsPRxmGPrdBQ8qGyc5CitLIzCs+L1LEjqoEYJKYleeIW?=
 =?us-ascii?Q?OrD6KiOV6ofOaOjMSmYeASmChc7cEV8qjSPy8/6z5+RFQNtLJ9XDR7kjVj4B?=
 =?us-ascii?Q?4L3qnEsjBstEj5x5ZHOQQ3xJjxS1B1aAk73BCLdaCmETkSnlpKWcyfoChrla?=
 =?us-ascii?Q?KLges4FRcCwMMlIxyyryJudd30fUYRGTa+sKU1p5d8eBS3jOO9QzvrfnM9iM?=
 =?us-ascii?Q?pEEU+mr5YJlHeqRcnsJcvDVkyQIPKuXRW5XJ2sJAT41ZYk02ZC6hAAkLp+nw?=
 =?us-ascii?Q?+KaUQFkaT1GNhIt0kvUwwHkHTLIMBTrQDAPbNApINdnKDJs1Lxsv2F47c/h8?=
 =?us-ascii?Q?qJZQNOEheO1duZtZE98kUBHMW+HzpSsAAZeEp9lgQxuBuvftmIb1mcVmBJI0?=
 =?us-ascii?Q?/qlFBL7O46GGlxIzLK9vDu4eTmlCOywkwmE+LHURT3I3E+VE5BOiSMl3bwkK?=
 =?us-ascii?Q?wcSBLWfIobHvtPOdyBKVPI5osB76xnnMEJGyGtGZv1+haijE/oBCmr8YdBQW?=
 =?us-ascii?Q?qeYYH0rGG/eGEj/LjpVOLpjao+UttKSf3TzK9/41JTVzNlmI3y7cLHjItoF5?=
 =?us-ascii?Q?xl4Nx+bSr2bV6cX4tXlqJAYkyo7rBrrgUCGtGp0t1rbJqv/c+1LXkWFNOJsZ?=
 =?us-ascii?Q?5w/XgOPiVFv5oU4l4cRNBNXsu5rd2v9Uid91oVjhPuOlyryvhjYEjneWeXWN?=
 =?us-ascii?Q?dndKA5J0t+jJzIEzBAhdskWLBD2E3+riOcfQ3/nxP0uvz0yow6m41eABwri+?=
 =?us-ascii?Q?2TTM+3XyI9gLpz5CUxdD+yp8/tvlx36fkUhUgknWiy7r2Za22tw58QISi0Am?=
 =?us-ascii?Q?EMSH+G4wEiN9dV4z9tY8osHToOkf3iLW3TONEOKfaj2OiM6HJA9Bkr6Cgh3/?=
 =?us-ascii?Q?Xo9ZAnlcsoNJZxHjQrsL9bSmPvJP2CD/KA6vBw0rshzIyT9+9ezWvGta7Fnp?=
 =?us-ascii?Q?DXAca5JjJHvNTmG/jt7gsyRqo31SB+rVBSbc4kTi1zzJuG2WhkB4SgYKxXXM?=
 =?us-ascii?Q?O6xlRAcODi8dF6LAmqndyi0lLdTK8eVtzNNAkNSnkoQ4nGASlGjo4UiZuzpR?=
 =?us-ascii?Q?ZEfeyuTbayllnHsX4AGra/WouzRnLSknDCHKba3VSqdoKd3sC94XwxQLaEdA?=
 =?us-ascii?Q?MgPpnWoglWns/sW4L4Qw5d6RoL6waDnKMhhUEXn5dH41n2a4hSIkt9sgRAYR?=
 =?us-ascii?Q?8I6QlSrnuDy5ryBih14AuStHz6TaT/+ZqkoSw3VKjMZEpCZmAzCOsVSiejAC?=
 =?us-ascii?Q?gvhQw/txu7FBhEwv2DQ22hE4kvPgDBXsZQu0iCTcJTFhAdAQeTyHRjAlLGjx?=
 =?us-ascii?Q?0l2FqN2LFQJPKCOSj347FA/Q9SV6meb8LDAA80I9fzMF9U9J+FbiUz+X1Qbr?=
 =?us-ascii?Q?QX2qJxeKy7Rg+PF7bF+ZXPS6ZFpueaykeVP57KAm49gTJZ1KMaa6Q0x0PjsT?=
 =?us-ascii?Q?recrarxFBRrXASL0yHcYURplLUJPIcPQG3Sc6nQ2NsPPSS2kdLzqp64jvbCB?=
 =?us-ascii?Q?Kb/ruHNXCxvp6cw0IJwI4eROOLArb7FGOAC4/AF0y50LPsZceDz8c6wDaN3O?=
 =?us-ascii?Q?sH0GivN2J9ndzTqkjDxMuC+hx5zL0gs=3D?=
X-Exchange-RoutingPolicyChecked:
	RSh2RuauRkNVvYJZ5vzaNY7lmWI9hjFowiBgpfDiVN7Y+fqnxVxLa3Fvi4ARufkm8bltU6ZbxKDxkxSPgzRWadpfVHsVZQlTKewiIzFNF2Eb179Cvl1PaVX2omxYr4hugVteDtMSzUqEKmpVqu+uX2hodP0E06s4rF3XUFjBzNDSdTL2YsOxTpPR5bfWGfQ1M4b8H6NJYgOj6OnlDXzOAq/pCV6ZUmGmQ+YewLclFBjJsIjI5+rm9FGn5qHjJIr3YQOtCjJdELE+UThq5jBYQads63GSf609NhSAA5AFphFOQV2un5e+/kDgaYPZrPw7Z9bnT2boGRjNyodHIYG91A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bzf37dcrSPbWaSZc9MT1Bc28TIoc8Kgy22B1afIb7mgEdFf3g7S/nw6YLjumlAVeApuQi6uuBWGAniNJWYdCGLwmCPBr1bBc4L7PA5DRDZP9utx0QP2JzusSBW2dB+YLutPC3OopcxLD1k28WBrkalXraeLZqTH1rcLQ/gv3IDhv9lp9SfMZf+6Mx0FnUzS3uUFFJilltFLP5oVfvc0jUAsffUAUPn0Gn7sytYSjiy+a6YUuNui1rpGaepHFHo9C9dpyq14Pm4/bkkBgB65XyWs5M8mxKw56x0cZHSrcbJiz3EboCNs43FTEMSPakP+7QC0f3LG1u/VpN4fvp83hr0PPVbS764Sdx2fLm2vHcEjInnsLBbpkbB00ABNxNxduQuApJCQm2A7TQfuSbgisCrdKUTTOSxJz3edzfN+5Ee/iOGMPTnQFkyAytGYmFR1WYs+XC1CVW/wXGLn1nosV+zQNA7kBpFOj1CbW4R2/Juvb3PvYWx352L0XihccXZtrUPlGxU6ToW43VhlfqR68BdT9oFSnRLnh2A6F4tDJjdytPouHyAs5WiulAnEavfMkbcvcnVbzdjgzZfdzqj6FlcTU/ua/8rDWkl3rFySSO08=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d4479d7-4e76-4d42-5fdd-08de7c639e3b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2026 16:07:23.2554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: av8kDE2eicqOApux8H5loPuomjgMDegZElyJbFSZcxf4A3ZY0oOtQ3S60bC0HGvsFVeIPjcwjWMKlmhG45mhZLYkZMRXHj7YH/LNF94GWvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7046
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-07_05,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603070152
X-Proofpoint-GUID: Zb11p8DXHax__lh7NwRxA01oF-wDjJK4
X-Authority-Analysis: v=2.4 cv=Br6QAIX5 c=1 sm=1 tr=0 ts=69ac4d3f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=D07J6oBoTCO661I0RI0A:9
X-Proofpoint-ORIG-GUID: Zb11p8DXHax__lh7NwRxA01oF-wDjJK4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA3MDE1MiBTYWx0ZWRfX+ZefyMCj5SCv
 DGVEdkHil62glvzu0VQ/gYExLdaVxJ0Rark26ZAnnK64WmIuylKC15wHFxo4yPLhnUIrs5/5hVf
 N03ToyDTuQ/pwv2AylvO4Oto8cIGYNy9cexO3Wqwip9EGEYHwtCYDiiXguIfKo71Rv5xMn31ZhF
 Z4v66OLusJrstUu6xtHAA5064k9hausgLrWXVeRgxQ8UyKgH+bzUBlaIpXRWQdN8HG0qmHqED7o
 VBBOTcqlQKhISFMfynBKDpwQ+FgFcobE+kYzDFlYiezzSlN3Povbq074CXktTEqWnqdl7QIfy/W
 fmZK8wLpiSVZeb42mKcAhWG0vH3DnK99lf2CvbvKwhNUs4jmj1dZdfJAhMQDKPs+vWuCuvc1hdN
 KW79sQiEQyQ2TgjOb4qBKaPzaUDywdnHpSNguZaUycwu/q8S1oX6atz5Hz+3cjOwouVfsy9eoF7
 L+9Jcc+ZnXaA1OM0QDA==


Peter,

> Only return IRQ_WAKE_THREAD when MCQ and ESI are not enabled and no
> UIC command is active. The default UIC command timeout is 500ms, Using
> threaded IRQs during an active UIC command increases the risk of
> timeout due to possible preemption by other system IRQs.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
