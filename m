Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603222C11E9;
	Sat,  7 Mar 2026 22:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772921201; cv=fail; b=g/VhEvBW4kYXbn09BhIpxoGZpx9sAcssZYOMJqVOPPhipIaIJ0m+G9FT6dBZdiykd/8ktrOC9MdDZQHACs5TUNle97/7/J3tZZvB8dzHIoxgk0hy5AZwRWIB7mKX9DRFiV4TtRadptmufZdZseCoF8ImrFnOubHCXjwnFPDpsrc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772921201; c=relaxed/simple;
	bh=QhA59nBoX3Y9b4psbuhq+eveHonFGPU6t1qzKds/3N0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=g7aSlTEhlBtI/+V8IwC4y1XnP/nO6PqlZoQwjH4yQLtP05aBNOeyNOiWnbL/5gPWpQuPQnsrEm7LEKfRJc+lVOerdv2f8CakonVbw7RBU0CKYRVgBbjlhfZcmFxE9vx90B695DuItSKjIkMiDz1LZVuvXXJSdEfDTuQ/IPy3Efo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bQlro5+U; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VDAOXD0F; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bQlro5+U";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VDAOXD0F"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 627LchwD2203003;
	Sat, 7 Mar 2026 22:06:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=usuBQslQi/+lt0lG
	nAn5PghhyUko2A2SCFNmN3FW70w=; b=bQlro5+UHnefmGxdQBWk0IM7TWdRJsmV
	uh06gYnGpQILwg4CE3G1stgFRLsjIvbDhNT3GI7iveN/AV7MqPdcKrcsdAvApsMH
	9uLY+WxU2Z3RS/kJN7Y6nsMRfF/28zC34OzPQlWh2upWOL8CSgzmt39jcUStCqDU
	ZmrO07yYtBUMeMDKDOtisOL51vFivgzOiqKfsdH87Rs/PqAeNvuCicBAyCDF4U9x
	2UTdSHOjkCPmNLbc+VK8ApXPOZSlDS/KmFEGU6lmKc0IwQXU0mm+j5Qg11Ga0H+Q
	yryMJoT2sGkr08S6y9oM1v6RAvJsKzFxperWCXQxFXX2sbTgKQsROg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4crv3qg260-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 22:06:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 627HoxvQ015097;
	Sat, 7 Mar 2026 22:06:37 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013047.outbound.protection.outlook.com [40.93.201.47])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafbkhft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 22:06:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R9oSjuvzssOhqkDFCX0adHmMi0+jXyK2bVMYY4Lk65yZ//zwpUfuW59hMIO9MTh6ZOWum9cJSr3eL7tVQeCbVOSeTg723FCx6LwnRn6cEwEbWshFkCriD6V60YPti7TlbwwwBIO+5ab7Kv+RUK7JyBqrAZKWVe5Fu5HXw4dOT7UyTPtpyyrJ34kFstLQ/AJePBlRUFI3f4EeW6GFyJje/1QZReKyp1F7+EIbHaLJAuWEyua9bkPRR10sTHpKtECLXIJjL08PJwmj7fPpngHGa//+OP4x0i4BHA7/IowNOo5RDeUDOtx4dM6v7YHjb5HtKCBkP0lG2aabXvn3pB//cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=usuBQslQi/+lt0lGnAn5PghhyUko2A2SCFNmN3FW70w=;
 b=M9pKFmzLSFZt8+jKdvaGYgNfpHeKIGSdCX+WoD3P9o5MJJ1pZJxreP9kJPmwVNqKV1uj4bmRwiZO2p+c5cDFxd4KpyLolm3hNyhK+/vLOvdl5acePCNUvNpdUMAL2h+i0JYjSuFazuYqxJi2vKo2rc6NQf8195OJ10QS3JIycpZxhUNBoL5guP/zqGt1W9FgDZ7FqDZe46aPjLoW3vVByjdILnthH3NWFSnU30SRYMuyCshgWf+jAmVdc3gorH3wDJMGG+L68gjTLwDO+uadMt6SAAtBC8ybZkILE/R4KVIas3XrjhnwAAm/SLtwBMRdGQ7oROjEtDvq7pQeO7aHCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=usuBQslQi/+lt0lGnAn5PghhyUko2A2SCFNmN3FW70w=;
 b=VDAOXD0FpYGPz/5SYw0tcgFW4qU0QnYSC/maLdItZQ+FnrzaVqpF7DwUTM052KFA5dRI3xMYOYz41Nb/69aDYYygOYFC3oIbKfwwpaGjC5UX6MF8OyzsFnYZ4Kng9vavnzz1KNy20Xeh32p5WvrS761lusM6Ca4h2OLJObQVVoI=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by CY5PR10MB5914.namprd10.prod.outlook.com
 (2603:10b6:930:2e::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.19; Sat, 7 Mar
 2026 22:06:32 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c%3]) with mapi id 15.20.9678.017; Sat, 7 Mar 2026
 22:06:32 +0000
From: Mike Christie <michael.christie@oracle.com>
To: d.bogdanov@yadro.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: target: Fix complete_type use
Date: Sat,  7 Mar 2026 16:06:30 -0600
Message-ID: <20260307220630.131008-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P221CA0017.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11c::26) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|CY5PR10MB5914:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bf9b5da-1ec1-4a51-6ef2-08de7c95ca6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	gtYSaY4roX3phLU/9wtFD1tV66nnFTCQWohtPJHDbxcenhQfb6uUhWMEP6EjUdzYyPpoeJ+kOb2CiUBvmX582ATUyPNaZmiu37ghDvYAzkEZxHqlmAwi8I06zG63iLUldYooybcFk3gAiuEDNJn8mna7iBYXbVrre9EKwaJb8H397CtBzIitoaB5a12hzcc3zda4UzDN5zq/SzBxf+OOiWOYi9EJWizp8FTt4EzUtAYuM4dnI5FHYije7Ff5lu+dbmoTGkKaaXss/Q+hfG8Q2v0FEHAo2FXVL7J/jrCfOM5MCmLiRBz74X6yqX3T8Y4aee4IrB3ojF97twtsXxiJMKh6K1rVEFuNzhlu5GdWGU+u+iplExmFZVqysrgFX6aqr+XSqeQWrPY42JV7C2LObhQTUEmW0e6N7OuerGkGA2aSNDgYNTjKbj09uAJRvJ4pQz2BuujAK6xWdAtSkmiQj6LXx36VCy/LQklqvG5cLCx2FRShKRjqREAQ4PPapm2YXEaktBa7labmrmTBmS6aHhHUT/1iIQPoUGDm147698vAQTZUZ+nHx3D58CN8WXBG3pPVbfsLnnvn0asGJW5S10CQrSt2LiF1E2uka+83Pdm9z3khx/H9OiCH8q42NvB3lS7YQt8VroMO6TusUb9CaiDC1LgIE9AfScAjerzWX06ov6hp+wXbAIY8nFfU1Fff/gLrxi39z2cgDm/iFto3WebmLUYloN9VCXfYXDkG71c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EQvU7ZcKx5dQmLmUtVlhz3jfkbrls+D4YAG8IH02xp/iSypwiwZZetH8pcnM?=
 =?us-ascii?Q?96k8DSzR62sUzX3NxFXlabtTg2ZmwKAemo1mnQkHV2nBfutigCZdTTtclBlc?=
 =?us-ascii?Q?gylSsH9fouhFu2gG+Mzr48X3VwdLMBhDgG+9otelZ/RmKW+B7DpxxCQsF8hh?=
 =?us-ascii?Q?pgd3Yq9zHo+V3/jOAlZDilsP832shfnpNj13XZKBaWV77klQuoiNcdpe/9y5?=
 =?us-ascii?Q?vqURdm7Sb4zlr111DIEXHj/+YSNb46AeCCnZNUJsEJK1Grx1RHH0dkmqh4xY?=
 =?us-ascii?Q?ONW3IZv9UyNWVb8Iy+3QdnLQoced9W6gCIdEyD3TDDGINXJoPWP1dTu7ZEdR?=
 =?us-ascii?Q?CCILLAe6qFOZI0xvZSerdxsopAjM8AN3W3kZRA0oQn+aqbH/UWjqctPsIjE1?=
 =?us-ascii?Q?feeHn1NKommrvTvDW61G6CmE4rkEKyrDZQfaCmR34t0zh2DTfY9L4uHUbS7B?=
 =?us-ascii?Q?BuNar73d4MvQev/k71LYxujiJnj6GH38i5ME/7rHVV8PXG/2hKJh7PDMOt++?=
 =?us-ascii?Q?b8yNDKjU8M+UfzvP7QUzJEj1AsxIRwnepTHVzGDZFIrpZLLEnM8pX29Hry9R?=
 =?us-ascii?Q?Jn65dELk1zrNGziimy1ozPerEuyGUqmQ8YjIuT4jrh93A6G+LA2xMs6rZ5Ki?=
 =?us-ascii?Q?GWtNTT02PMky6ztFnbbvEJ4o9miG+gt8U8lHMf/O3B5wh6ufMhSg/+DiSeit?=
 =?us-ascii?Q?P+f3wnSMXBknnbllO8ocWfT3uwr0HeHFjsdEnwxB3hJ5J2FGBYAMfypvXbLT?=
 =?us-ascii?Q?GChINiF4sJOIzv1cC+TY/0GptM1hnO2/FZxY9jmvd9lkLQQTyNCXDv0cIFIE?=
 =?us-ascii?Q?y7CLOHSC+Ui+sMGokk5PWWX6CnrHx6iNG4zQZysG3+iNWH1x/vf58vYC7S7X?=
 =?us-ascii?Q?51omoZIJlpYuD32T9pyXQuqzgD1Os9pali4N0B0D60UqI3MXLm/pnUVQCvM2?=
 =?us-ascii?Q?9kZfJuJ0k/CizA06mI6CzZdAmqvLSa0IoDJ/YCFqFyz8dQA/ii1WLqm8iv+q?=
 =?us-ascii?Q?/xyitG72DUeNwbFQRM7zcNskduwaNly92lDEKInl8+cNQRha5/bQPJhFUA+Y?=
 =?us-ascii?Q?eoKYJDWg9p7Z6HFJTM6iWWjcknkYXCzB6x3p6IS4EqrMVOtLHn7OdhwjRQjr?=
 =?us-ascii?Q?DwPcVt2q76M/Bd43eH5j5X9L04s36GIIQ9OElar4O/0FkNLI9K5fo+sBbhe/?=
 =?us-ascii?Q?ygLfx6MyX1OTeXxLwzT/He67o5DSCH8rYf/kXIcP+QmR7HYEDmx+1oaaJWJP?=
 =?us-ascii?Q?vBE7Cxw9+S0NBNxCBeAHHXjZw/Vfj2qTCbdiVTKZl1AhUl/Y1eEH7ErLWkQl?=
 =?us-ascii?Q?0yLmVSSJQcLsa17DSkuqsp7lFmuZq4B3NtQ9CF5bwnv0RddiaQq4REu/vtNW?=
 =?us-ascii?Q?ulcq7lWTOVEK8AYHaDT16kS0wOEUrnulaBbZpC8C5PP8b+KV5WUVucNv+AE2?=
 =?us-ascii?Q?I/4srl/mixjCSMBMD8TQfeNn/ZRBlIr3f3GSE1ylJQyfRrwasmn2FQjDqKiD?=
 =?us-ascii?Q?72xFlPsRPnK4M8VkcR+XU67uQOKg4MYTg5PQ7jSa62MG3yjg5y2ELRV+tcDE?=
 =?us-ascii?Q?XDxfw8RHGMPlxnO8poNeAhstv1ETvaHjKDkKc3Dvb1QjWqdhANP/v8OLZOoV?=
 =?us-ascii?Q?gsIZSjWDbmIe52Qs925ufOwms+8hkX/lowDayaSiuJnLgsZGQxaEHTVY2uoc?=
 =?us-ascii?Q?/fr+tpHVme5fHUgiWRd5dAqYUkgOV++qFuv2KYpON5cGv/+1uX5adNS3umix?=
 =?us-ascii?Q?Ae1DAjVUlObtypWCw+VTkK0D0/yAMWg=3D?=
X-Exchange-RoutingPolicyChecked:
	ED+d10GfHbUMwosbbh3xW6ajhVjxOzWM9YFmNyE0WXELCbISxPDi1awjlTbrCLGV1C7QBUgVZLCc/LS+MnSwn2hEKqfhV3CibRofhLAaQES5gYPIVpvIDFJXjc0Oyt8eozJA6xYXsw+7440dM+s9qCiYUMAoarfiQb9o3xJIIzjpOtUJE/h21ytd8oA6Gto6XopPQ+ajsnxo8QtYwAt85ks/olZpSKYS0a4HxDMANmGD6BaV3ReDGwUu6ifx68r3gLTPVkHbTETcj2wNoRPWtoT1hrkH1WRPW1xofSGqapbwBkNqeHriLvb0ja2a4QoGoro9GJacTta/WVlAIc/I0Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KIV+DEf75JGP83Qv03SpwON0WAYJwi4urEAUNJzaXrGkKk0t2tUI62CPp8cI5j1/GqKcoVPzDdD1zsm0l4uZv/47DX/bz1TD3MfLXCLSWOgjOT54vcdc+h63SbEYk2M4ZPZ3lJsghfuVFzBHVMOXnwV5FP9/68Cx89fqARMyJaOxOXaypdQHjNKwAa8X8cS583neF+KsP663C/s9+sK3XRyy+5iCY8sz00TgRWUHtg9adDFu9leyspujMgfsFDz9tohz9dGfmxKxQkBGtYXNwt9caDYZoCjTaE+UffjUX05iKJWAuzO8/VRtPDWDWi+vOVaMBH/wNIRAoM5YhfjHLlOzoYLnEFJco5FEDAWnsmNYci6Oml7Brf10750EiTYD5LdVe2rBHOJrhdUCeJfDaajsq7Z2Gf15eceUOYbGIAIMKrnl8xacRezpF3TY/QjRKxbzrhJllw8LgiR53bc/LTkD948rpMFHDya0XWzHXC2bBLR6ySs32k0Vm3dM34BBBVq70x+TtYU3U84HGovkfsfuQx5Jbpm5IyXwajx0bVVBbkEECGqlfU9Da5TTpS4AxKGMSiuT5s3JKxzshQNqOxJo9Vq84CO+o2LTHGJ9G8o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bf9b5da-1ec1-4a51-6ef2-08de7c95ca6f
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2026 22:06:32.3412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R18v/ae47u5UWvCLgTDLcjKbknBqkN+0zH3/Z4IguyxE/MXn45nO18UHZFpf3M/PpNsVPXxoxHI8zsyGXD+zzTLE37jUNlKRUoIa0hqOs6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5914
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-07_07,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603070210
X-Authority-Analysis: v=2.4 cv=EuDfbCcA c=1 sm=1 tr=0 ts=69aca16f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=-c9VzbpeAAAA:8 a=yPCof4ZbAAAA:8
 a=09gde1Zm39-FkJYWvRAA:9 a=WAq88MDkwfy8HpmZFCM0:22 cc=ntf awl=host:12267
X-Proofpoint-ORIG-GUID: uaGTjuDnr6-40pyzgQZLIW3wgoNm6O5u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA3MDIxMCBTYWx0ZWRfX0KiiiUoCTlNE
 i+EyXYIRfHGvRuVfjcuD6RnAbRRe9FvNu9byciVsloJfbfzQFi+jFh175je/I2EeiXWwaTlt7Ua
 Toi4m6Ja20Bb5K4lp+/biFV5u8/i7NJOJ5MI+lRBIGF5WOHJJHSAmAs+kb2fs7crDQDnEhtAK/U
 L9bTb01b5/sYppvXJQSH/WfF+vkr38wzUluwSTe7IEet6kDNCd12ru5M0G7gaRsdfuzdOH+Zwlw
 h5s+svEZ2j0bGj1SdwqUywXjEerwIhuoA8O9gwbsMDvLle+7mHq5TKoClIC9y/7l2R/kWwphYMw
 IMT7tyQsWsGqhGQUQjdeXM3QaTzKnsiEMc9SlC/FCa7/aUptqDfX09Ue5TFJKtl4i6M0SKPSOjq
 DZu1DXZLWD5zlUrO/S6+XAsfElCbLLcCYarVk11owzJt3WF7O4y75S9pM5Lwg/x6GU48UiQPmfw
 h5ola9kVetgWiZW5XvkXLtgF+aLs/aZjmEfW7tKA=
X-Proofpoint-GUID: uaGTjuDnr6-40pyzgQZLIW3wgoNm6O5u

There were two copy and paste type of errors where I swapped
complete with submit names. This patch uses the correct variables
and definitions.

This problem was found by Dmitry Bogdanov and this patch builds
on top of his patch to fix a second instance that was found.

Fixes: 06933066d88a3 ("scsi: target: Add support for completing commands from backend context")
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
[Fixed second instance]
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_device.c    | 2 +-
 drivers/target/target_core_transport.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index fbc8ab65372e..9db2201aa553 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -813,7 +813,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 				DA_UNMAP_ZEROES_DATA_DEFAULT;
 	dev->dev_attrib.max_write_same_len = DA_MAX_WRITE_SAME_LEN;
 	dev->dev_attrib.submit_type = TARGET_FABRIC_DEFAULT_SUBMIT;
-	dev->dev_attrib.submit_type = TARGET_FABRIC_DEFAULT_COMPL;
+	dev->dev_attrib.complete_type = TARGET_FABRIC_DEFAULT_COMPL;
 
 	/* Skip allocating lun_stats since we can't export them. */
 	xcopy_lun = &dev->xcopy_lun;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 34249fb80c67..4e8d779dda5e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -917,7 +917,7 @@ static void target_complete(struct se_cmd *cmd, int success)
 	da = &cmd->se_dev->dev_attrib;
 	if (da->complete_type == TARGET_FABRIC_DEFAULT_COMPL)
 		compl_type = wwn->wwn_tf->tf_ops->default_compl_type;
-	else if (da->complete_type == TARGET_DIRECT_SUBMIT &&
+	else if (da->complete_type == TARGET_DIRECT_COMPL &&
 		 wwn->wwn_tf->tf_ops->direct_compl_supp)
 		compl_type = TARGET_DIRECT_COMPL;
 	else
-- 
2.43.0

