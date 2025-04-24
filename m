Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F88F42A82;
	Thu, 24 Apr 2025 03:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745465275; cv=fail; b=UE7f2OZMwRHaq/Sk7309I3JUqyxBIJtA2vwnKfO5RgyBfRQQg2wk2AIcqW/stbu+ncYyUki+uBScSaGfn6PW5BrQD73SlNbGB8NiSsVRNwqbCcy3c31gZbPuC98qDXtHM3s3poatdtgFY5E2v7h92FyyRBfEeH7M+a7jE3SLsnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745465275; c=relaxed/simple;
	bh=Dfy9Grirb7o1mMABhsGPa5A6BGBwkDir2wZVbU81Ph4=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=r82q/m0/X8uEwXDfqBCuLsZgfkwrpBpu5FgpCvBl2WY1fsvZKr36G8z6Aa0MRV02rw053iMFS4GxbgrqZDIE8SVwR/X5D8uXQ3t+jDGj9ApL7voiQXb8Ms8u14UhlJAkRStJZ/pl6HmoOb2aUGlaQDLtYxq5s33JBVpege9vlKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DBtXkkHe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=j8n4LeFT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DBtXkkHe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="j8n4LeFT"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53NLML58017711;
	Thu, 24 Apr 2025 03:27:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=Dfy9Grirb7o1mMAB
	hsGPa5A6BGBwkDir2wZVbU81Ph4=; b=DBtXkkHet0f400ljcX6C6teCo61zPCMU
	gKVT0LilF0/vA2tzS/u2Yc25zIyzSfmoRR7fe2qqXBplDy0OHhZy+94milBKjie4
	qiSOSHfo7T5oih2qiGiBpDfwNAeLImYrO2Kuww9AzoVWWzlptXvlZGmPOkzQwcr8
	ZlbyTUNjOWgfa8qLVtRw/T6I0HTgwZxBWnFv+fgnhxLY5Y3RbW8YidY2uxmE2rFi
	DxI23BsLDe2+xVRBtTl5aItszByZ4ok1ObkUtK9WJO2aKx3Ss1Oc50RCrr5eOujy
	+UnFC5fG3LLXEVHl4PznCkW4guQo9Ujmc7+UBhYdF3olljWqxiJ/qg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 466jha2yqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Apr 2025 03:27:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53O0K0Gf028503;
	Thu, 24 Apr 2025 03:27:46 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazlp17012015.outbound.protection.outlook.com [40.93.14.15])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 466jx6yjvb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Apr 2025 03:27:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=feXEqJS0yEcnL1BKOCZmAQ14/msdG3BBtjzXPEhyRb/lFqGIA7/dChvpOnpnIKtL9jaHsj5wVejCL784Mm25Dv8plFI1BNxNGJTRGV/LBvo8kh7LifWWNwB6rQVCWAY65o4noT49NJ3v1ErFA20GIY1QF5DRlaiF9clXU7d9qiSpn9nTJ+6NQwPb0yE5nAZjKZsbsjM9t8LEIRJhm0Q4/UW34cdt9s/Slv+BPUwaTJFQEg68uFtj8k7/F9uBxiuRigC3G/lzOGVnB38+SdQ9cC1MC6itKO8x9hv87VxsegknsmpZz0l0+FTdTIgHIkFi4iEFAxDZ07ttkxFdAba2dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dfy9Grirb7o1mMABhsGPa5A6BGBwkDir2wZVbU81Ph4=;
 b=lgwLqKiyX1r8oRXmqMh3fjW2x6a1pupp6fNRHbQjMs0CV4qRtQEFExYXhKtFm9qbjvZjtOfxXl7Vz5ihxMtsrAZnHsbQwOhsDEXiPsh9qTuB++8Xh15yhxKhQ/iSZxjw5d7v8RQzvGK/5Kb/GIdbjFd/xN7VDHFlX1Cs1dVTgQ+ihXCrrew6Qgr3ghwWaBXpbis40bi9nC6Uby6ZXchmb9k9qH1GvPU4MBtLofKriFakTp7zbrsRAPDQoOp2v9jJtsvmJGjfQ8Xg9V8ROkrOLC2x+hijA6XLv0PTeCUmEfp9SQKzWxATIGrx6jKYTi9WzysghG9C0yZYw2XwThrgIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dfy9Grirb7o1mMABhsGPa5A6BGBwkDir2wZVbU81Ph4=;
 b=j8n4LeFTY06w/vESzm1/4yPKCPkVH4166XQ7LQh721B8prl5trpzvybHX/MLOyvd8+hRmId+83ljfWfXJipm6Z6mi3TADlLpVPZQrQ7TsD8BmtYEaPmlbIqWUJ4ocu/CSiz0J/qCTQedOeMxEHEV6Rkx+DGdh6/gc8vi9yovFGg=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH4PR10MB8172.namprd10.prod.outlook.com (2603:10b6:610:239::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.36; Thu, 24 Apr
 2025 03:27:43 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%5]) with mapi id 15.20.8655.033; Thu, 24 Apr 2025
 03:27:43 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH v2 0/2] target: Remove atomics from main IO path
Date: Wed, 23 Apr 2025 22:26:31 -0500
Message-ID: <20250424032741.16216-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0017.namprd11.prod.outlook.com
 (2603:10b6:5:190::30) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH4PR10MB8172:EE_
X-MS-Office365-Filtering-Correlation-Id: b2c7d80e-bb1b-4874-9fe4-08dd82dff9a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6jl+46X3ifbFM6He+DEnPzYQjmOZac563ig/LKuS0H1EjtLYflNm7J1iGAeW?=
 =?us-ascii?Q?aIcpsKeY50TFQUX7znE0iADkdD7L9PvqdT4lIRRhKS8jSa1+pWyUxHYJxdIn?=
 =?us-ascii?Q?ddl7tLfpCCZLReXI+w7+7QqegUpyTZ43N8Xtq38tR9krVujEmTWgPM+MFtEJ?=
 =?us-ascii?Q?41b7EKELnWy/Ts1QAlErxH4RTIQSXF7GOuswJIKYiGvrkKvfIDHEj9AVoLhV?=
 =?us-ascii?Q?orbPaFszQZelDAdGtr94Ymryj+QacybsVACrvAFSmnIbrj2EkhM8m5YunOdm?=
 =?us-ascii?Q?5hyE6TuJvOc30FB0wCDhucbeEZIi/NG17mqmudNWiULA6iHdvF26ZvbdkgxM?=
 =?us-ascii?Q?+jbRT3iRL4+dY8E9MSoeaU7c+ZRaHAs35h9+WzKMkzytyiL2PGeFuGKmpRtx?=
 =?us-ascii?Q?smuAv3Ulsf34lTOwKO9mEmxPPBN+OqAGsWUqP1m2o0qlJ3ZKwP8ORoEoZ+WR?=
 =?us-ascii?Q?Kk2CqyQIFDdcOxbij4tIzlualFUaqsjtRR/isR+dVkElGmkZx8j/FVr6319W?=
 =?us-ascii?Q?84A9TOHQh1IgGqVcFKzPuBlCQMwF0irHhV3FHibmY04KpBASigbCxhDZAkI9?=
 =?us-ascii?Q?sheRWzh9C3Ab0gh30akS4ksJW1rVeOgKoWMxg1KJ0gibxYsHYyLpmaX0rD7M?=
 =?us-ascii?Q?5/ZIDM5IUQ5grqLam+CM9gSiSk7RVbXqXdwy11OXdZKBk4nRXNuRAMThf8Rk?=
 =?us-ascii?Q?0EG+zqI9Bk0Ujjg6BlFzgzcYp7sBHyMGruSJGDu816DeFkBhTAOSWFWKfLtN?=
 =?us-ascii?Q?OEv4MsvXeN7p3dvYc/GZ3KBYcVuDt95Yxgigqhh3y6WUFnTTa0FiKm3uJCfp?=
 =?us-ascii?Q?oO3tDuNvBwHQrLrSDev0wpmOA75LbdElF/8u+mxioFxBbkWJZR7IumOMMowg?=
 =?us-ascii?Q?g6vWZMpNSbCwqs3HTv4xmOx26lb9gDpzYILgPS0dzwA/cHrQBx0u8Bc3revY?=
 =?us-ascii?Q?2oVEZUWYGbyYt1s2rOqJ0omBg9uP/dGWNBuZjiFpofzAB6vwQsxsNoZGFUPd?=
 =?us-ascii?Q?b+eL5uMkO1Bj9C5RUC41qskUY8tUObHI1z2Hj0Y+QzQLRuePEXjTcJgi989S?=
 =?us-ascii?Q?8ag3WxzREN/MgVLZn5TRkXoZyxDjrfqiqByfFk5pxttxP2AsaLiDz6uV1IIS?=
 =?us-ascii?Q?wG2AKAKqYi2LTb1N3jJYjMlmv0repdHzqvrf+WVHXO7ipQNmAvdRzPHpB3F7?=
 =?us-ascii?Q?gUbqcfQ0q7gccWvSSA8PtMmAORqN9OxbUs8d+abNc2vqHqBY4QesjKpaKxvo?=
 =?us-ascii?Q?mMovc8aFd+3ylnqRaYqHlzL2cXkbOTAmEFgDAaeuClhuaso1T1IUJsyTgSLh?=
 =?us-ascii?Q?d4+e4f2anxmLe91Ui3GDNe0L1h/H8/o3VqEY66AzsVBnTwDGqAJJQ/NlCCwd?=
 =?us-ascii?Q?Iwpo/zMmANxL4ItVk1XZzd9uBEItY/mvv6qvhsryZy+BnVHQVyPL3J4Su7S4?=
 =?us-ascii?Q?21eREW5+LiI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dlNDWbfOTzPFty0t8R2XBPUHr8DV0tTzhJcjVPkO6bCe+JAfRbjVxFfnrtyr?=
 =?us-ascii?Q?j/XJJZghbCT5AO8ojRss3AJ/vb6uYn9hPvlktVoXaVWEwjamgppjKwCmYDRL?=
 =?us-ascii?Q?xdSH2sFaAdnURAqshnxyh5+i9gPy9jmiStiKwjLO9GkSObXMBrovKhE+qGoT?=
 =?us-ascii?Q?+9puKJb32LRw79X9eCFY/derhIXAfE74c5v/AWSo4UHfbJLcBVzIBuo6XOSZ?=
 =?us-ascii?Q?n/NDCpimuHL5omHBFXqfI2COXjWqqlSncJV+0vRY3gEaMzOjXux5sOnbrgaM?=
 =?us-ascii?Q?qH5EGA4iiTDaeopguMLFXSHur1xUHOQBULMWlF0xfyHHy97CqQ1V7ie38L9J?=
 =?us-ascii?Q?EDw1vYQtes9LU55+QzjrP/97wZiJWVs5kONMTQMVTN29HEamQ6wWwPn+6jZh?=
 =?us-ascii?Q?TJ7OY4L6F3EpZe6jX4QviPO5DPOrJiECEyhGP1k4CyhauFQI8BJv+22gwQsf?=
 =?us-ascii?Q?cjV2M0hML1yrzaR7klUGg9HS4EhnZgZOqx2WV3nlKHGOm4lqcRzMhUJhYgYB?=
 =?us-ascii?Q?tDNeDfaLr45hAItJTOLWkQl/fofOTO3QT3QF3WWQpQgRhei+mEtH5ybwRKpv?=
 =?us-ascii?Q?i00YEdkoIwcMzkQ2hvVB8AajdiqmlF4ZebXl4Iw13y0JBYzMehNFfDYHWVmo?=
 =?us-ascii?Q?DQ25RB8y+GiQg0c5+KQtSWtwb/fUnHm539lY40NsTXdeeOTA2DteCWqexatJ?=
 =?us-ascii?Q?S+bWPxvsR/zPn7Tfoht80nv0gzvCmzhgnjpPNDflKUS5yxy2KAS1JV1NHknn?=
 =?us-ascii?Q?E8xKkk81KfAx2yUC/a1gD0cgt27cITQMuO6Dj9Mdrw92AOik8jIZZ3L6csUh?=
 =?us-ascii?Q?djy1N3ZJ9/qvobjaZW2TB9E7yiAObliJP5VSosIGARLMHFDPnp/yehaNPLTe?=
 =?us-ascii?Q?6FSWzGOuPqAUG/V24EV7M+zYi1p1t8CmO2V/DN39IPbZZ3FhClABIgOZEm5N?=
 =?us-ascii?Q?ZN3wfmI2sAtwJMrz7sWtLo/EjmSKxLgzWi8lcm+TQqB2cIBD2E4z5TZb9eTc?=
 =?us-ascii?Q?6weaOuaPlrTwG/2Nedex5JOrNakX9DBT3+LBw7C2WVGqWJnSELKT1jylyF6w?=
 =?us-ascii?Q?Zr6/eDMaXt+ObhVNzIztaTuYc51XyaNoQxGBxm44xvfz3uEIjylMhN+gzq56?=
 =?us-ascii?Q?hr4b0UafU11Xxzvtt4Bsee5Z+StUSUsMwB9b6MMmX1dNPJ10caNWG//Z1YZ0?=
 =?us-ascii?Q?QI2BATgw4ibF2EH9JJCHoxp/we6gQBy5638CrJKMCC3U9f9if11grz99kHlP?=
 =?us-ascii?Q?1NG0hLrbq+G6b71x5vJYkQ+R+GVXL1fJ/GFH15R6iSZA3Ne3INhjOwh4Fr1Y?=
 =?us-ascii?Q?37LezIYRKd2jXsfy35RCQRpHRob4Bjxd0YqRXrMNgNFmiIf9L9aqUFN4MIt2?=
 =?us-ascii?Q?/LS7RM30SkILAHTI1tyfMAoj8RSZ2VQn1s2y/AYIov6F35lQbqtdrC7KPCol?=
 =?us-ascii?Q?A56NeNU2PfHesztLcO+1LBYFPqIGbImPzeMVabKAf9yaoCve5NK7KHipeP2N?=
 =?us-ascii?Q?Yx62idPFajlfz0up3apoSvf7Ap+++oWeqsJg5D3ZazWltxqzGtcUv6gXvGSy?=
 =?us-ascii?Q?iEmZsoa+9IBFifCRZzO+E8vINfb05bbweL17nlX4BYVbHiAS5RtQ+r1+b/PD?=
 =?us-ascii?Q?5Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	evcj0CzK4jmApJJlBLOFMdxgGPDAfA2I1zJgRW+trCFP8mk/zjkKr2qEu1BHN/4hf6L7wkEUoe+lSfhpV/5CypSN4C7Xp5k5bcmvbkJtSOi/rnCSXT65acq5x696n74+v7momQjn5cfowmBdkUUuN67mlhYXdTII0J/NZoxSSzL7LKxeWFrvm32pdKsrBzLocSyK939eLHI8t7FbpBIhBK+lsm8UTre4n3gjo29mvJdKzVTTjIuNVkqE9ETtYyZk/uATtPmm0RhWfCaoOFCjHxluGBWzbEbzuCrTt74eOF9amyA9WW2FxQMZyyuHsUoMaNmj4E1hf5nL0v1kV7DvB8F7v3gycA2ocP5ZZMsDCKeJQ4I1tHUmtsuNhsZxUlqnD4xIOt8s5un3k2OnNBDlfdzRCSk0vVHHOc0GWVNsXwf95L7W7uB72U9F666yrifIh/sjF4elwbFjWu0W8WNTeCbniKV7jNEgQ33Ar/aqJ8rBLKmFmsnBFME8iZMnhzYsHphaViRj9JGPpLQwCVZBl7fZIajhsBppbDgQHnzdEFMmoDe4ThvMPAEEWSpg+FvzGvwRZwzkN2sc7ES+hCLBkq/U6miORb4WnUqqwLCNiR0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2c7d80e-bb1b-4874-9fe4-08dd82dff9a6
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 03:27:43.5989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l2cUJiJQpYqWB9jwOBpbMzk2F6xNwOGcJDwssalUb1L2kz8mD3t9DzIMC20BEnDvNQEkHSPtuOhdox82CKUjzlERn9fWTJOTPFNzR813cZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8172
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-24_01,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2504240019
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI0MDAxOSBTYWx0ZWRfXwVG9ZWdmfMf4 wSLQoLU6HiozB41Yq67dRivNS1TvWxGdCUV3sWgijnzx/nOl4D3Z20uZcIYECuffVFKAPQWKfGE +QwFm7wUI3kY9forY7ag38Lp+vtqx6yQA967K0rDKRO5GyzVQrSKREFOv2a5x7n+kA0Ckyo/+Fa
 tRPykDZWSrM0ITUq1isy/ZeJMlaQ3sMGq/GI4w8m040y+msLjVnaY1MXDtg2u9hMsf4BnW5r0Ym KfSRFMojlSz+YBD0i5jG6dpeu9rU95L+yFfuJkBJSf1gn5qYSQ3IMeaOCsgbqOwVN6kwmDSxvGC OunLXwQ1v5Evi1f58lhkMLkfn6hKM+h4+EsDaIFIVs7kfHJ7Im/vBNPiPs9BfLP2zornr8tOk// gOD1JUHx
X-Proofpoint-GUID: YTA5NW0IzGc8GRc5qK33r_cF2XOzH4E4
X-Proofpoint-ORIG-GUID: YTA5NW0IzGc8GRc5qK33r_cF2XOzH4E4

The following patches made over Linus's tree remove the atomic use from
the main IO path. There was a handful of atomic_longs used just used
for stats and a couple atomics used for handling ordered commands. These
patches move the stats to per cpu, and moves the ordered tracking to a
per cpu counter.

With the patches 8K IOPS increases by up to 33% when running fio
with numjobs >= 4 and using the vhost-scsi target with virtio-scsi
and virtio num_queues >= 4 (jobs and queues match, and virtqueue_size
and cmd_per_lun are increased to match the total iodepth of all
jobs).

v2:
- Fix variable initialization used to add per cpu values.

