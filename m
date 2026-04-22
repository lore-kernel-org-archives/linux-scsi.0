Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8D6223DFF
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 02:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776823308; cv=fail; b=lbVeHRp8iXvhrzcaTyIsH1dEi+qTnlWVlX0MoAx6galafuHxRohPW70U/sELmbCx9M3CxYYeOqxFPseEgSGmDBl/48sFxLceoWf1QMEAVN5UPj5KLZlrycLYqogIcDZ3fHH9ErobZ3aV82Xj03MkOET7IsYL6MC08Cyr+AodVB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776823308; c=relaxed/simple;
	bh=OegYomLJzZhIUI3RzyAkpYdRxj5B/UDM9FXTqlaK2K8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=rQym2qzORFpEPhJ7M+CV+sAH7P8z8Y7CEAJde5cwMWu/+z1uFT2E6CntxZYgS7vtcssFGxerXBEeMHe/ypH6etpIqDsqFIC7ftybFTCWgtrf23BqIb6As1d9MEZ/Td55ijdhiyaV3vXGMHiS6vYxbuhXArhh0cEqAm8I0JE4Khg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sfGPaIBS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YieDhn/1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sfGPaIBS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YieDhn/1"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LIaji62337294;
	Wed, 22 Apr 2026 02:01:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=D3JmYW7ARE4h4dgygL
	hkLllC7F5S9JzlQQCYddHfuF4=; b=sfGPaIBSE16FKSrrtjcgX3xze967RORVdb
	1A1Ra0Y1X17xRzcaRUGlF+6toXUzJjSh1pPRSYkTMs2T382TQtxq1KzI+1DmuWjG
	F9mMPl2ai1kImXyUyWLOxER4J/ufHTUgcODKGKpbN8W7t8MrioMub4ZWZC3qtL1R
	rorI+kJ87nHiTmQHa+C2tlF8pDhx1x3kpKti+sw3h1Q+k37c43O4mfGrxA6SMtOT
	uVWH6ersJZuiL1CRTxQmogx1UQ/jd/Nq/OYIEeQ9bMDR18NZm8NdUw26HvFV/1Oa
	zIZgXWKwZWzomRttP6abKjGmnj9iAI4NtAaYo4ZiHPT7vvi321bg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dpenmrfr4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 02:01:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63M21H0T026050;
	Wed, 22 Apr 2026 02:01:42 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012012.outbound.protection.outlook.com [40.107.209.12])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dpjjdv8wh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 02:01:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sDBbCz1eQBnZOvin9wRToHBAhg3A/Z6skeuqvyEJ3EDNyxlaq1pPRJB16E6RnyjekXuxr0ftby/0Gs7Y6uaM9rymgrzVYPrpC7hc9hz1nsJF25+0fUvhTc3JchkHABBcjy9+HoMAtDV+suctZNdzybpJn2eeUpW+mk2gnxti2ebsKJmflyan9QHm1Fk4ewVdPr5gT7xNSJL2s8suNAearwAh44wv938PCmDbXarWCk/Q34oYrN26BZQq0+Ws6VQA0zKw6k62ak+NTAtSRYs3WLq4lxSPkBGrWM8BCbojqRitQIQeTzpr3wqzQeN1PrQTglR+hqLuR9Ge7J4ZQ2iEfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D3JmYW7ARE4h4dgygLhkLllC7F5S9JzlQQCYddHfuF4=;
 b=zVDdA4HgzkmwxIkgRN93JIG5JiYB8XToecfqiL5CJ6yzyoCpEm5rsXmTDbCIIePv4W9/C0Fw9GlqdR3tooVLpE8wayRENqE0GQwy9nDfZgjHqktI1lLqakrh1E6igeFmA3wKmahQlRfjH4GaBDE6ZNVv3x4n+B8k/dvorbFC8UrZOkFe3cRjFCw1SxDfnacwdGhNeC1xU66joFgopiwreY5/W138NI2zTpcQF8laNW7yR3P4ihYNVQGLR5DUE+VpOX1tIPT5OhZ/tuo+7XSR8twYWuO6diX3gYBfjtGFzEUfSCSnOSbN6Q/KMblujAB3Ot1H3G5vRiHX60de7AaAEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D3JmYW7ARE4h4dgygLhkLllC7F5S9JzlQQCYddHfuF4=;
 b=YieDhn/1Epefo2feK8nY3ZwHWvmIO9nvu7Pqn8z4RtxU8VDlJE1Oca2pfMFcDgC9FJFadEI9Oo/ieW2yLIAlQVoxt8diIOcf8q0eQtEUyNT5tAqPEh4GS3/cZ15C8M5EaKde3+ClKTZQw1bC51uJr71Ixnssmuh5FRrBOY77OrM=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 LV3PR10MB7817.namprd10.prod.outlook.com (2603:10b6:408:1b8::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.16; Wed, 22 Apr 2026 02:01:38 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee%6]) with mapi id 15.20.9846.016; Wed, 22 Apr 2026
 02:01:38 +0000
To: Daan De Meyer <daan.j.demeyer@gmail.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, Daan De Meyer <daan@amutable.com>
Subject: Re: [PATCH RESEND] scsi: sr: exclude CDC_MRW_W and CDC_RAM from
 writeable check
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260415065110.3496246-2-daan@amutable.com> (Daan De Meyer's
	message of "Wed, 15 Apr 2026 06:51:11 +0000")
Organization: Oracle Corporation
Message-ID: <yq1eck7lq27.fsf@ca-mkp.ca.oracle.com>
References: <20260415065110.3496246-2-daan@amutable.com>
Date: Tue, 21 Apr 2026 22:01:36 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0118.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::6) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|LV3PR10MB7817:EE_
X-MS-Office365-Filtering-Correlation-Id: 2baf20d0-4679-478d-e9ea-08dea0131716
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4romJO5HZzPwV3Y2X+oExXTa1cHk//K1s3WxF4jTTDAqO1H5m25Ybd26g4FNwhj7E0biniPNYIPAXUQ068OloA7Y3XEpZ5aJ6EgYvK268ABOy3DJe/nxrmKNqkGSsJmt5q0w6Nbvz7JDyClBusQpb348wVpqpPBsU1Mav8A74JhY13bI13BPfhMAlSrk36G8Z8OnDAYLbIyhlFVfiT9kXNvUHwoR5Uye00sDglV3VG7sl+OBrxjm7dDZbut2aPViBzzU+MJVDZXvSIR7aGWKcf+tV+Si8weNLrSq6qg0A30+asdgcw2dHMu/puDwzUN4f1wiNqoHDFo8hTBISU6Kjt5sFHsbQv3TQqMZrjHhdWKG/nfGLDXqldv8YIyDIga3ZhTdD4py74/ImlRzv7r0DqYaCzE0XUBYJym1yG05waWCmvCoGsm88OVumD+AtkH7Ocs6lMCxwJj6fMtCUaiRwg6dIK6D433tBNOI35B8eqXNQB8RyTdSexC8HISUJ36SVGuxIqxujgFPm+tIGt/NnRgBdr+ccTFSEZl2hKKKNixQT/o7aX8qfh3Oxh+DjlqUCOeLNTCyWWJHfOetwDiOul9vlslUoXReLx7yEI5vMy0diqpSX/QI9hFM9wkKYWDeH9uHqG5E/H4hCuB+2o16oHwC2ROty5+Qvc6Gbt2n6E8mG+2Eoir5nI2HJa2Rpah5umHMbKwetah7nWl+s75J39T8kbQHb+kMGEhc/gFecfw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3gp59q6CW0Rz7LSaGDe/WfLDpsnKmS58dyd9sY1s0Se/A5kx1lgLcQvVHB6M?=
 =?us-ascii?Q?pUeKu2NHI7peMW6TgtTpKrDkxkVQ380wZY61ZKkX5wmxPm606QWbx132t+Cu?=
 =?us-ascii?Q?GjYYTApOAKlcpkC9nR51fn1ajJ5E/NgVMhbCZZVTi5kFgy1BAPu/RYScmDkL?=
 =?us-ascii?Q?6S3+pYCe8umIU+ixDAKivzEuixLOSctaYCk/2O7RlD10SZK9Snj3eMv8bCoo?=
 =?us-ascii?Q?SfRU7wGwpR2u/bSKV3D94iP1gQblZct6ndP4AS4T/DW46xxY308LvCiSkpGM?=
 =?us-ascii?Q?66vwQsRNiUjU9ecLa4A66tSwTgFGNDJ0nPZmjUuwSa15PMAeWfUElwTaZqYj?=
 =?us-ascii?Q?CoFbeZ1UQWxxAuEZt5ajEWvb54dDEFHaBCwc6cqd06ehp8AZ6ToPuQHk64dM?=
 =?us-ascii?Q?8vV8RFU0ThSdkodcG2VryIeAQmaVr5p4DlX4U5a8MtoraxZndUmM0s6x88mY?=
 =?us-ascii?Q?q7MCLln33DMZUS79fOu0UJxbNheSnfP/e9rQ/aUOMdqJtijQ/ow3aqc7Jc5b?=
 =?us-ascii?Q?hcKJq6CAzLXRdrqkuUNPU4bTzFyCm8CMXPy2zqe+jDA31EpZxBtm0lSCn2Fv?=
 =?us-ascii?Q?efbdtzjfl6D9Hicaq0j4yoCslyi15E1s3Fb8cLysSzDKlb8vOV3n+ghpnb0O?=
 =?us-ascii?Q?kNCRDrn48Yv2Y/UxaBcICegrIuHHtzb3uCfXwTes6dPrw3G84JC1q9ZJjGjT?=
 =?us-ascii?Q?ijzp90njZ5F5k9gx0O11+1DCHSCl8aT+LrnMBYBO2JaaHKLWzmGuX8JB8/bs?=
 =?us-ascii?Q?lF+AVvjSgM3UQUZs3xOguYGUYl8GVJL/xY5rKaO/gRi1s1/YZtEAYfUoNgcC?=
 =?us-ascii?Q?soB8Ub/P+gOW2GG+ra2rGaXdDIOnf3bzhD/05sBPvGjuyoQfBGyjwTqZw8wY?=
 =?us-ascii?Q?ZyLYrvlbOImW6SKH+2xXXNRFZL5a+aoEpDZD50mc86ZwcXHjQV9Zq6fR3pT2?=
 =?us-ascii?Q?AJSj9ojwMTD9oPSUGsF8r9BH2yJOfotznwbbDYvsNV/+/rnZHSjC0cirbQsh?=
 =?us-ascii?Q?kN9PBDsaJcfzlpLc36HV72fae9cQxuL5/dr0iZ4sYJqtwVQrUImIpfSIoowm?=
 =?us-ascii?Q?fW3DbMI0iXRiDVxdWXF+KE8O1LWbFG8dFIQ8toCmdX8y906zgRKCBKwYbc+P?=
 =?us-ascii?Q?a1cRGNWWEHVqLXFsoN4DVUByWKS6IE206YE/nODHedWiy3NzjoSJj5pp/fFb?=
 =?us-ascii?Q?hczP70bTV1CQyjwYHPiTbmd6Qqttasc5F/HXiSb0jJiWOgUyo3yoJofzgspl?=
 =?us-ascii?Q?3MymT3GJtoWKUTt9xYrwKgMVxF2vV9GCc18nOxdfvWDwjoe8zJ/fy1m1Tdd0?=
 =?us-ascii?Q?FzidRWBMjVJX4waDY00So81t04OXKhcu3jeCC9ZOElsAyWjl8cFgWJsEhXjx?=
 =?us-ascii?Q?daGp0q95UvKlDntdkjh2U+ZaV4GZcarAPP9PEzITcwAKYSVdzAlHpnxnzenF?=
 =?us-ascii?Q?yiMj9m2uZA4hW9c6fEcShoDKxplhzgfMGwqa86/kd+8V5KXdxRcZ7JKcENR1?=
 =?us-ascii?Q?K3HI/fB0x5d+Lu04X3d0goFuQtXDgNrd6DgWf2yv+AIJtc5NFGRGewjaADs/?=
 =?us-ascii?Q?yZFRsftxweG/WUWDRSAOEnUftnaB0J12zWVe5AnvBa9vLKKBfM8Q91OzfUym?=
 =?us-ascii?Q?umIUQYJzQGdXnnsoCuCWSqhNeckqT03no1l0gOailGQS3YTnXjKuW9baDSoP?=
 =?us-ascii?Q?5QyRf1GrB4+CxXbnqJangOpCxZYifImUibT/Z6gFumxqm/76s7c9yy/bc/7b?=
 =?us-ascii?Q?SttWL5Tbt0vXhBQ5TLzAQ7xfbzl6eA8=3D?=
X-Exchange-RoutingPolicyChecked:
	Aohk46Fy2Tz9tZOfQTHLIihNbxYNwQAWmuJhI+MkPt5dZzyitedIQo9PxS8JsMcpFRJ3BI7EZYOF1aAiglj8sL7Gng1ETVhkoejkZqEGUYtZ+Z8VZmgzbwA5wddBVJkfvZHVGi2TlEVHZK6lobADPYkL2awuHM6adV6FHVWt/zjigqzzcTJT53n4lGoHpRplQFqc2sbj9Ixq/23Ni7YMhVfkPA+o644SUE0ufrC2wN4FReAI+L6izZt4+6ZGbDgkG2t5p2UT2dZyt3T6E6Ik4BLNXkAVbusj64YkjQClG4pkfyAp8Tvoq4Bnfymp+Ihp4MELUAxs57De3CfORIHKAw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	T4m+3AKsA8yQvbXbUuH64yPa32X7GQhnSRT7CEpw1prcwfRL7cTNZQIxXkFGSuTAbaVv5dCu3fjZo3Pu2C3A6krqMYvngl9KIIy3QdEWfPUfZIe4xw4evxqIH6RvvG/IJ4DVumXIlT3H5NDOJ0UjP1+/E3rmMcqSCDp+fDWlkTZAv7LN5CvjVRvukiu9qw1M/+LPWC2zTbvnWMJK+vh1A2wziqOAS1rfz5yszJZZU7CUm1X/OLBxAhYboGrqOyxgNcUyHD1W1HUEmGg58i96A0hK6hggNyJYIH1159ZfTGX8Qh1jDtsLZy6pgj0iIygGwQhHi+w9SJP9+2011AT8yCMNbcCpuClUwJ74oxg4J4sNiXDwUQQY1P0gdGlb7l2tBtjjXZPmIniOB9+ZoQl2atAkAqZoYTIuH/lSKFCE8xcFqj/+FU2H3VG+V6AEL8mW531uihvlMdDsKaONPnwNf6Z7wy94o2uAbY+TofqR9agKiCR52fccvv1f52c/nda+eS6IEjAF+vJkVEjUe6Zpyxs/AxxIlKfQF3BPNS0GvwcRmMvtTL4E1tDLF4vHamriMVJBdzzbgvKMPHGF101SYPCzGlg8PmxHozclUapj1h0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2baf20d0-4679-478d-e9ea-08dea0131716
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 02:01:38.7793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HAQDFwagsSD+tkWuwz/nrMaUiQ3ti0xyYuUnFTRZbIUdWZpfOfEyYnzunxzL6FMCBzTrYD4gMviyfXqbkcjOuxTE1qiXXu3eYOQdpXkNUEU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7817
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604220018
X-Proofpoint-GUID: Xxp9QDYFRT1C9MtSWVAJmFwQUYZGYytw
X-Authority-Analysis: v=2.4 cv=Z6/c2nRA c=1 sm=1 tr=0 ts=69e82c07 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=biE-WIAjXW3GsBHrfSkA:9
X-Proofpoint-ORIG-GUID: Xxp9QDYFRT1C9MtSWVAJmFwQUYZGYytw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDAxOCBTYWx0ZWRfX/pcHV9ImUrUT
 UNbCe9u/pYIHND+qyuhIrcIxw7jnQotMxfZH0wKyuT613yHTiHV6IAt8ESKdakpEJ9cHq/e8IEP
 vrSVS2SFHnZo2qiDgHHB8sISp8F1z33cvDr750rEX0+rPEJ2+G56X5fNs5wQjgcSm9yUjaosYki
 NLL40CRsdbWMDu0lcKfoo1rj3mTjHkj2A6IjHTulmT6kmzSAKcKlBNlqAnz3dzyl5vTkQGJ5o/7
 jhpi8Dn57nPIDG9nS7Rcw4xvs1gvgbTE5TYN9HEH3gFC4QpogkkTv1abJP0vOaSLU3lCD7vFuqb
 bb2lyjIfUkMrgZvA7Ru2e3R1hmB2niyzH5DYjt6zc7gFXBpyYDSxWOf5+wm6f62PNqxzWJ629R5
 zqp0Vpr9lNBpgOiJqE04mhw4qnljAHT5NGP//LXn63ce5kHXLTPK1KXn8a0OYw2FUjQItMyDSKh
 b//KXLL+Ewpnuc5rRbQ==


Daan,

> The writeable check in get_capabilities() includes CDC_MRW_W and
> CDC_RAM in its bitmask, but these capabilities are not determined from
> the MODE SENSE capabilities page. They require the SCSI GET
> CONFIGURATION command, which is only issued later by
> cdrom_open_write() at device open time.

Reviewing this involved quite a bit of digging through ancient specs...

I don't particularly like how that decision process is split between
sr.c and cdrom.c.

My preference would be to defer setting the device writable state until
after GET CONFIGURATION has been called in cdrom.c.

-- 
Martin K. Petersen
