Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286923AE6E6
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 14:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785941971; cv=fail; b=WvhSBJuTcsFPo52Hrg3wSkg/KWyzWpnK0bi2vlVzBVK7x03nc8S+JfbENoD6IlZryG7zNrAluHbZwYX5AQPVYBb50AgxZS8OBvXJpewfQnbrMeATYqHjn3G88GzgRlghjyJRIwC1xjdKP4/8hw4FQax15hAv4ZGfR+sEpXxsGgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785941971; c=relaxed/simple;
	bh=4+WJbFVUt9/GiduhSre95AgDdxnfOI61U6u3y/shVkU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=LMD/YbTC+PhiC7RHsnZvcpwZ1ipVoFPsTNBs6wAHSbaC1TCVqlfUZ02xJdZTZi1zDKrdUrSws16WUWqiMbXoJlRFuiLzwxvOgkwr4G7AowdvbgsSnrCZgmXXQdQWOi/KP4Ic6FmQTvZ4QJhadVE7/cVILC54KLRG+NpV4Rkkqco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fKAvNfaX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=D3ti9lJs; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fKAvNfaX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="D3ti9lJs"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675EOcDM3916081;
	Wed, 5 Aug 2026 14:59:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=CpvX54nezB/wXFLO
	OKfUmRVSUEYtzhNj/ypvvyPg7gI=; b=fKAvNfaXqrIWBcx9wvqMJgCD2YQ9aa8h
	2GpWQH0Z9sycZ9Q3hJB9IxlY4SnHRd0F8BMupqQeCCTjLrKGOTVW6b6BQFoJnckw
	hQLpLOemDtzxvhlpFseqr1G+bprBwnJfnUFm7+OfpvlBwLlqyTPGdsQAZ7yZgOBU
	/H5qNJIUIRGef0m6KYgvF7RhlAXKOXrG4ygOBneS4mQpPJDIUR5CSAhmBMaKO4sc
	s+dbGPd+HKc9wOJt1zjySUDs/1kiOKEICqtDvjDoZudWmX3RccEqahz4cAvQX9Za
	b5WhQlLZYCynF7t0DkiZ8KuU1TWREBcGCl7vblg+heeuatEY54cyXA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs7cy905r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Aug 2026 14:59:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 675Eta0g014597;
	Wed, 5 Aug 2026 14:59:19 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012048.outbound.protection.outlook.com [52.101.43.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78umxxp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 05 Aug 2026 14:59:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fYg81DuWOUEVht+AHb5qtULd1iuWFfKnMxzBbI57HGb0KoQO2p1N/xpJg8EOo4YL14Lp76QxzOYCwaZKBGyc230C48/A0V/bPbKeF/XQnGHpac+vgwtg0Ut0CEOooO8AF7eVuLBP4EvJtuPAq2I06LtO64ugOtmem70Qyg3eTfO80Rzpr16wKVupJFlBpJbytizKHWKTRpzU4ngYp/x6C5ioMd5uR6qWwgPW2vyveonWzzHfsARq9HaR5WCFlWhrMW2BJDOPZtE1O1t9Ohy8yYOzkcoZlZU/i64Vzq2wlnGX5vQ6fBdSSeMkScV/MAOn5eXxbzrSjPIxhsxy1siwNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CpvX54nezB/wXFLOOKfUmRVSUEYtzhNj/ypvvyPg7gI=;
 b=HTjxu1wxa3Tf9p4lqc4hVbdof/w3dximKaalOtkQOFMMmqxOPtvlg402ZJ18PNymvHIUG4PWgf1gnpfL5P0YZowMGiNVtrSaGht5ID03Sg3i53vNo9KQJNSs6MI560oMqUT0Tfj/UoNMWLogooVmBaTi1S5wjUA1u6zAEBLJNcPx6Uxyc/eWi6PV8JZuJphE2NOJrnjDGUtX0gAqM8GQBguPLAJD7HhwhLHPaY2lv7bybMBPHWtGk/kEGNr9jPQ8wr6OmvPTwml8m15BBGbL25+JkveLNqZ4UMZGbtDYIPNw1BI+GksCuhLqLoFOGTTC9X4dma7Wrxzmd6Lhh2AMGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CpvX54nezB/wXFLOOKfUmRVSUEYtzhNj/ypvvyPg7gI=;
 b=D3ti9lJss+Zl/zRJH2kfje4v8fvMck0FPL5esI3lHEEARoRmMgox0ZxQ0ckkfo7juUZ1oUY7RSdTqPtt+yh1FEGaF3Ivdu1EIDZlyOj44H2RUcT+G8sLC0z6Jbmwn7fDMoCUkBr+uss/MX6V70fOr8ObSGoTmnFDS5boVuEGoPA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN0PR10MB5911.namprd10.prod.outlook.com (2603:10b6:208:3cd::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.17; Wed, 5 Aug 2026 14:59:14 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.016; Wed, 5 Aug 2026
 14:59:14 +0000
From: John Garry <john.g.garry@oracle.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, hare@suse.com, bvanassche@acm.org,
        John Garry <john.garry@linux.dev>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2] scsi: alua: Use access state macros
Date: Wed,  5 Aug 2026 14:59:06 +0000
Message-ID: <20260805145906.2825553-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:a03:254::28) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN0PR10MB5911:EE_
X-MS-Office365-Filtering-Correlation-Id: 58513d88-2b2d-4d13-7115-08def3021d7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|56012099006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bYo2hvu0zhqn+UpkeGiJJmkV6Qf7Hkr/dOB2s9w8tViQE8cCZPx1NSh385S9asVQAWzimfILyCwiQSOyaAlxKGUa0jH4PD7bEuEqwlLkwW8WhIR/w0iRwzHd26TPdgFPdnGptV9D+X9iWeMlrProEqbE59Cf1QAq7c5RqofRE4TaHfQG+5GJ8A2zjFZq/qAqD2Ayke88tuovJ51bdy6TjiTXHhp2ViND18Uu4jKQXyCvh69S4/HHbisX0vzjkEv2G6KZnrzk/2eP1WwY9Qf6EOZctaDJTyxjI4zKwPXdcffrwG+IhFT5FrdnuHZaqryL0G1p6jIHRtNEIrKHkJksRDf563wr/m0zoMsTyZsKJE/ZyAbFrUxKvve+Pyrtu3dMajkq5CWUihZ0h9tY9HDrFFtkOQbhoD6ibjTDBa52SKv4vbCb/fdyGa74tmHoFKXkEWsoOiXF372iOgeyv9ZXh7lH4A7DhGIOnHTVOxPrh3kcBxtkksYTgeC0fLhEjx045U8oOXzw8sIs8kyBFKocqnAgzXvavU2WTx5P291vBPRi/ZTKw1ZWuCpiOLSm9xMaf7oBCcuukWcyiwlnvZWd+w7JqFAQGLUyEGFwNz88ncoJ3Tmae2czX3B/2kWHz0MymA7SywxH0FAs28IlsH5is2ujbASPhpjtu6WPyQJR7xo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(56012099006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LqabD0bE8eKqYIQ0oGCZnLuPXwY+Sy8CDRzncZbHJQup0sskMJTSLlphrIna?=
 =?us-ascii?Q?5/axQCEb9s16JRXMThT0VTxCt15rXqsAmuINvjo/D7D6CibvMd+NDpCk9K2i?=
 =?us-ascii?Q?cOeWckGWsyOxie9jRaGr0e15SJc/KkjyOXGboIssSKJZNBQWehcz4WL6kHNr?=
 =?us-ascii?Q?PasYaOXHEgWDqNJzooUPzXoPzUZM7vKH0lH30c8XuNBsxxQVHAa8EO2AGI1m?=
 =?us-ascii?Q?FaI5GJnpif1GIrRqkBRyHSFxgmOrdjnZbfnpn1kbfbRCBkXzWpwJ45qe+Yod?=
 =?us-ascii?Q?SuHZxaQTgKPn5s/89P9AUmoq8dp69NvdgYGFQjU+hmhEYHGF5Y2+EgdajWKS?=
 =?us-ascii?Q?w18ZM9oGsfoI1XW5fn1caGUrRPQd2U4m3SGRzrxrGYnRygpJiYzNRvKgM5Fg?=
 =?us-ascii?Q?5W+PKyHOJ7IdO+hfbwEwm44XCQAud5Qw+SvpaTqlSOAckHSaWjYDNx4dIojG?=
 =?us-ascii?Q?6oSsk/Z1B++96XT13HOqZyKjOQRZ9yr0WUMl4KPf2u2Yj5EgrZzavCuIQXkg?=
 =?us-ascii?Q?GooldJz7+B5V63yy5Gih4bFkvfzKLfJSus5xTTHwFTGqWqQtGDaKrOGw0xdR?=
 =?us-ascii?Q?VWxGeNRg/BNE/4I6cd4ecWeqFwiJq3VvCFZSNmsu4hIueKf91XLbXZMN7jMV?=
 =?us-ascii?Q?SnNR1PzJOmz7x58w4lXq42hzwBygwI9Vs7eG7M4y9JjyDorQF+Xc+V855DRx?=
 =?us-ascii?Q?pPRWqyO/NMWbwHkSRlzzVm70rPRNUOvsFm8B4X5TvLOtSTHTeHNVc7WCJ3wI?=
 =?us-ascii?Q?lE5NGv/RkJUgHsHJJwn3b2KD2G8b1PHcBWsxb0ZqsnuYGy/6ScCBOXut8MIt?=
 =?us-ascii?Q?/qzMVOlpBOUL6rSt4+lWsUaJYjtpHXBIjK9Gm+LXqiEzzUWD9vhKl7uIgvRr?=
 =?us-ascii?Q?fJ3hqsrzIGYUwiA9OwBSHP+ml4DQVFAgyBcM1ci1rtZeoFE/IRwLgc2Hrp74?=
 =?us-ascii?Q?M71vRgMs3EOn2hu4kCZ1PMBk5TlMK0WtDhTb8IhGAaaazB3V85WHDfMrBEZi?=
 =?us-ascii?Q?YwYuxFriU3kunPR0M23ZgDCpm9ZcpVcMAbRLLm4mmlk9XiU63ol5TdE6380N?=
 =?us-ascii?Q?MzCeB07GIbAB2GN9CimYlt+B0UnQYbMmol3621zwUyK+mKuGv51LM7NPU733?=
 =?us-ascii?Q?pVx8T83BtcgTdZf+WRcgvS+Y0TGZBORhJLIPj/MJbmlDkTGTZnMCqVy5FsME?=
 =?us-ascii?Q?zOh3OUARoL3YYqnU5clyL9qhyDZ47UWTctqreBXrHghARczNK9kmY5XU8S7Z?=
 =?us-ascii?Q?vBCFeeAAjwsHfHfDCmZKPexSZJQZoUUIwHWqMhbrah87oIz0j+xsot8L/6Qm?=
 =?us-ascii?Q?FQUPF2l9099Ee1avxnMIjftvVs5M1FWdk/gne8CgAHi1PKqb18JL+CgbG/S0?=
 =?us-ascii?Q?xKSqyk80lSEQOD+nOLxDiokZNnlVG+LIGPhj0Rt9OQEjIgBPC5x5T8F8qV7C?=
 =?us-ascii?Q?p1ZoH/BxW5mIKw33R6NeXaWPS6HYhvYyS5VCiRkPrMg22xRtMXPWt/puCe2y?=
 =?us-ascii?Q?07Mv4Q2m9Cus7JGMFB/+zYnjSgb+finz5ATQB3P3v7lCxaOe4F+hjHTPKBtN?=
 =?us-ascii?Q?mDftYiwoyDpChmR2A26bE4KygR9yc28qeSon4FRfoVe2oRU096sDqq9ZsHc3?=
 =?us-ascii?Q?j8/s2D9yzUjS5zcSy+UYBW7h+MhyCs7Bfvz1zh2qS9VWup5uL9pm9pethHmf?=
 =?us-ascii?Q?e1lnYmTbZ2I4fNASaF/Vhs6wZXntUpgojXdoe8BYRK9LKGoPEgGwfhibO+ih?=
 =?us-ascii?Q?XUfu3qJjabwGtz7R0QPKwgB6BE7VVw4=3D?=
X-Exchange-RoutingPolicyChecked:
	D90Dhny9HMyBOEe0QqsiC8N9BTAg5UpgKUP/1FIErD/gz7bcycROk93lgq1bh5ApXIg85Gvtrf5T5NPRR9zvfvffLpOTz/fZflK8drcWuEbWd3If6pJecBhZdvKIA5kUpu+kI22JgGriN8wnNqGUOvZ3c2VJphJaZKNApdfAxvWlqSIPbd/+6ofzt5/OYYa5ZelspZT9EO8LKy+enpTXJSeJ3rKeoMnYEZRtbUkqkKMSxruJodiea245o9YpUcbGRwvix3yRp+t280HqFfc/MPf5dSThyBeUtQ97qjqgFz8O6Ozo79Esq4IPkcDFmsmeF6rTpLrzfJ0Ev5oa5ZaBjA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K9hp8SpMZvSUkRiABOttuAnFbqlXDuoZs25GCiuE26mTYjlRBOxY+sjTdeQlLge2QsWq1JKaiUEm4Z8lsi82ekOd0gB4tC3eraRenOnNmv8V4Xx45Lxhr8I6fWn5RUa5geo/q8DhC23MJ0AndYwbI4ZDkTLO4PSRoswSQI1Q4Y2FQ4lyJIQpQeoCRMUns1TLJuia8t64cpzz77XkCjSKZ6OsslPLxC9zWmhkNQE0mXUmhDcz4qnw8FsZBNwvzAJF7xzB673VN9TG5enEBI1nVCXufeJ27zTEeiUgnioSn1Eo26L0fgooQpeU2x9PU4qS6rA+/pBvJG0akeeMgnPFXfyKN1EOJJwolEjm3tBb/htdjEafT25QgWAO3/ijANh88FSJh3gDffFUHBqH83XOnHk8EOteV6Fpog7/WDuYETQH8O4THe/N/dXJHJfkiZ/uI1tds+4XrcmhoO8RKkVM4A0vvZQaKlmqkPToJyk7xo/oGOOlOQynlwn3+xvt99bt1J7B6nj4jSPqjtI3DfN8f3Xjk4ltnWGsa5mZy0QMWZICh96m92+l4nPKkKqyk4fQuQMMBk4E5jCTWLnF+hg6I1Idfq/m7+tsspQRWRp8TK8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58513d88-2b2d-4d13-7115-08def3021d7d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 14:59:14.5186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AWZAD+1GNJJ2dybNNKm9w9o0ZOPepg/sQWpQQHXB93+JPO25JZVj7nwzpaCCWrBySqoQqLBjjnHLvCUQTCAieg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5911
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_04,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608050121
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDEyMSBTYWx0ZWRfX3hVul7jdqBoT
 SKy7HqUkWA0rDOo/oPqJFYm76VFLewiVAqG/PqnOyyMnuvy7GsR9bPVahYPaL8oo3UzFy2Gba1T
 A3aEtkGJC1lFCi0YoZ17w1aX3PCFWvkM90/Nrt0+cI+1+e21/j6/
X-Proofpoint-ORIG-GUID: zMYQKSBK6D_SD85_N8x6HHjKup6r5tIs
X-Proofpoint-GUID: zMYQKSBK6D_SD85_N8x6HHjKup6r5tIs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDEyMSBTYWx0ZWRfX55epiLjcK9gR
 8ioS+n1vmhEZKKLIXbfDSQiRbTC8od+1SIhPUy3VXHJREsk6hJqTS8tMLOPNkT/fV3SYVXpyIMq
 0U58fccKFk/Q8zWePpKBBmtN+7O4HDrhue+bJtzvtMAmV9UEde49QYeRJLlcKsmR4BVNlNqOjBs
 sueYuSIJBWzr0NF/2kfurJd7goIbBDJBNjjBWPThfo5/oZRx+Xu3xZmvpveZDs2skU8k6qdyb/z
 owmVqNWYUpoaAsp3L0d2Mh/UIOYMFq6RLRky/hrG+NghCBkzva6x4FNr8Vec30qKNEFD+UilOSN
 oLcMWU9/1YiDR1Lg9+ZsnCWw7VCEoWBv83E82lJfFXyXs3+N0lTALCPnfRPk4ppr900b2vP9PI4
 sFwqawrtXAfdns5zBoiDMeaYcMnQxrbj9cVb2aqIWckvn4PF2wtZDifoUclS27xdIrAJSP692U7
 VdoK+Mmu5fp7hNMN/sfle7vB8EsN+X1TqIIuskls=
X-Authority-Analysis: v=2.4 cv=TsPWQjXh c=1 sm=1 tr=0 ts=6a734fc8 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Sv0fKeRqtYgA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=76AzQ1Vfu18iZ0nqP9AA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12101

From: John Garry <john.garry@linux.dev>

Use the SCSI access state macros in alua_rtpg(), which is better than
hardcoding.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
Differences to v1:
- use FIELD_GET() (Bart)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 80ab0ff921d43..d81ec47a71402 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2007-2010 Hannes Reinecke, SUSE Linux Products GmbH.
  * All rights reserved.
  */
+#include <linux/bitfield.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/module.h>
@@ -693,8 +694,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 				    !(tmp_pg->flags & ALUA_PG_RUNNING)) {
 					struct alua_dh_data *h;
 
-					tmp_pg->state = desc[0] & 0x0f;
-					tmp_pg->pref = desc[0] >> 7;
+					tmp_pg->state = FIELD_GET(SCSI_ACCESS_STATE_MASK, desc[0]);
+					tmp_pg->pref = FIELD_GET(SCSI_ACCESS_STATE_PREFERRED, desc[0]);
 					rcu_read_lock();
 					list_for_each_entry_rcu(h,
 						&tmp_pg->dh_list, node) {
-- 
2.43.7

