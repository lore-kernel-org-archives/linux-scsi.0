Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BEA4A0C
	for <linux-scsi@vger.kernel.org>; Sun, 12 Jul 2026 18:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783879365; cv=fail; b=hOW1MuWu8Oz9o7b8wsNjYI9N1VKUpkIroxOWUA5g/HD6Oi32dUtCRVbW63lui63kM3Tt3OHzyM2vZ3DJa96Zz9mGD1QbTm4VZbXt9X1GfSgLu9l03p4a7YMg0DCzdIA9iBJccyfAQNubx9zHZ7G8id0CYpMVVwlbdUoKx27AVlg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783879365; c=relaxed/simple;
	bh=quEmjbFiml9h3iSlD2hve+2WnV6iC/KFKBXbJ5aZtFo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=SVLfqtPAQf1ElrOoq3VmK0viBfR7Q10oSl2rnQ9poP7d9ft+VsZMpG/XQ4vdKbzMEsXsDSkX4GM4srhSM17BYlPM7rqs5zn4Dhv49l2sWomKy5aJ/chW0B7UXky+LNUiJ9jillxWjSLmjzCJfZ4wMgkvm6cLURJ1jXkvWkzklAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V0nGWht8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Xnm4TRBd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V0nGWht8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Xnm4TRBd"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CHxcu23737464;
	Sun, 12 Jul 2026 18:02:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=W9tKxhTsjePNJRKAwG
	YX29na/B5us203m1ubu2xrUC4=; b=V0nGWht8xL2TDYZyFdQ14XFwc5uKJJknTH
	jBefbhH4aIlfFeNICS/Ycd8GdbB6rE7ubAxuyCnkIJ/4wyUByqyikeuVD6ffiFrV
	GARBXLF52MAt2ou7IfCoM+wHhpGCpHr3n6aPBaAlvEbtN2FTPoNHDYEDZfyEaY8z
	bAwkAbInZEKhz8anv95IaIZ4KutF6NY+3jqyqep4bKRdYDgl15rR3ZMnj/OKek+o
	Ks4g2jRgh46d3gKR4lIviUbYnBYBvUny/OylmhaI9CMl5q24EkcB2TTfv3dp5MM0
	SVjLAvOkqZbnu5TfFUE2vbmvsx3Wq/xGGa7l9DbDEBc3IMX4ky6w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbeedh4vd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 18:02:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66CHwaxK032161;
	Sun, 12 Jul 2026 18:02:33 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012010.outbound.protection.outlook.com [40.93.195.10])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9pbr2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 12 Jul 2026 18:02:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aOfjm+XbnOoO5Rx5hlsHOcGzezCX0ngamNRvrExMhieaiN9x7ZSIobikeTMLWTdWk1Cy5013nKgASWybCb+IysFSBqog7A02sxGSlkppxfFUTHsuJniEgtlYd3gmURn3QaUoQEq05vzcqx/TbVGMZ57jeat5xCYnqmzagCeNC58wU82o2iNJojPN85ACCbqtqZFA8tS9bJnlbALaMhmmsWOJ9SiJsE9qcp67MerPHtfTF/z7EZVulUeGXLnbQZXbj2aYUaM7jIzmoj//jcGY7rcF+de5O5XBKK22Kepryqm7n7w+lh6I8zdJNbIPXdYjS3qmZz3HGIF9lMonqrKl4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W9tKxhTsjePNJRKAwGYX29na/B5us203m1ubu2xrUC4=;
 b=cbN7eowk+nGlItvVATVhmmyLspo33J4M72dKFLtGWTFLkE2vrNwuiCp2G96i23kUKrcygdWmuBrlMPgRHAEroKqXiK4jtWMZ2lJJWeKKQmzJzrrXs/7+FgK0kpvOOuzcSt1vC7VTRLcz1qkyE6GXFyxGLyl6kL64Aq1/s0Jb6lzdskIZoMo63wf4zgax/ZZYkHtP7q6r/S5+fawZGnXFsJ2JsYoBigd7Uz08ksK+lEpCdhVUGNtpTI6AWi9pFqKxOAlcRlpwJw28TsVbMLBhreNPtdTdKjGOQM2+KQmUF2YKF5d02dmLVrS+mp8TLyPurqzHRyNNuSxs1UgctNQbeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9tKxhTsjePNJRKAwGYX29na/B5us203m1ubu2xrUC4=;
 b=Xnm4TRBdiDa6f/SyTFvnDmHOObgOhfEAJKeElv+VHrKMzjBvqQo2HbWIEzAa1UvyPM9cQ6TvDXp2YX47oFXPJX95mdX5+NwGqU9x8iGNNEHMgSP65KbTQKmPOfm+Z4M05bRBhZzWb6lk+RyNVcFZf8VAun3rEQlbM1MpD1Xm8O8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB5624.namprd10.prod.outlook.com (2603:10b6:806:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 18:02:29 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.014; Sun, 12 Jul 2026
 18:02:29 +0000
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: krzk@kernel.org, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v10 0/2] scsi: ufs: Add support for static TX
 Equalization settings
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260616113348.1168248-1-can.guo@oss.qualcomm.com> (Can Guo's
	message of "Tue, 16 Jun 2026 04:33:46 -0700")
Message-ID: <yq1mrvwf5n7.fsf@ca-mkp.ca.oracle.com>
References: <20260616113348.1168248-1-can.guo@oss.qualcomm.com>
Date: Sun, 12 Jul 2026 14:02:27 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0295.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::20) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: fb436823-8ff0-4477-db83-08dee03fbd38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	liC/IHQObYibs7Zq95DUi+5NQYIqzI/F/lK9iUP1Euvpiw0MVo3U4ke99vt402ftCXZitzCkdX3yQBgQd8WwMEsgsx9FAHGa9iVHUa584Wb2Ih77IZD7YoMhOhvNFW9I8yRao3x61vZWY+syDcw1wFZ7mCHVfjzlABfYRXJkGC1D1+U/249pkMoEXBaj2qd60tNS2TzFcb3GmMNiUwzxJsSXjhUFC6ZSc2rUl+lBrr/6tgwwJRcD+OViJzgscGHlfYAzZW17ciHc5LNGzS4DM2FiSzR0skPb9Fnf5jqMRqpQGRgj9GEBRYU8nd42J37v0lUypTWJ1ev/eojU1f7K6kallqY2PLdgAv/Umfe/MALV1oLWb3gec1m/ohOUG7HgttXgbpLq/ZaowjjiLv24H2NXIjiQHcJWy3GVQCMKnQLXB+oe6Ul30Fgt/FnSvvjJcgi/3x/ORY0FBH425q5jq3xi7mf4bgwrdPwkmgVly+c0fUbH9I7zUSmfTfytfMAgxnWV1kIW24x3CZsxjaX5Fy04v2rtyMKXxLg2y/JBF+s4GbiuczjPqaAtW6t0+70svN/44SeRJMXIAD5DPgObcYG1maj8BCcyrnPnLyZWf0WMJ+i2lxQnZOQ4C9hb2AYQQs1zyY8R3iDPZB4tGIbQL2mS/YsAKdKuPHBmNjx8Tsk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+lY735A1BanKjCs4zFc3DeJUH+KntDk4pfZPYXyD38t+p5XKypyaqMcv/fyD?=
 =?us-ascii?Q?0ygWz7pmK4guv4mfh3ILL7x1AmV5IhE1xN6G0+SZzfGvAktvHdeudsn1E+lh?=
 =?us-ascii?Q?wVL9QaxAWCJEkdExLnZDOvPpZwVr4zcEcFggJt5w0mrAG4p6j+l7WYXy46mH?=
 =?us-ascii?Q?VOVUxTJgcQr15/1b/KpF6LAyHYk9apMT8DjZzcOhjttCW+QNO1d4/42Fr5Vs?=
 =?us-ascii?Q?mkr2x5+m8sZ9L1yW97KHv6vbBWSHLCv778w0Gltd+s4VzdQi044t/YKkLttm?=
 =?us-ascii?Q?rCTWQZUmXs+MlrlFNb2l9u6r+NFDdsrz8w24Z7QzxQwGRRyImRvQgDArl3+k?=
 =?us-ascii?Q?iusbppHeMIYG0hIFHAAl0zIf+mqIThbeNP8aiQTRcvixQQ1M8qBXcgzxQ+ci?=
 =?us-ascii?Q?3wx7OTZSlQLC0EnWh2X8S3eBJxhweRYNGYW8TSbKb9tyYpLsjh94eEmMY9By?=
 =?us-ascii?Q?lm64wY6TFwWNnkS54GrC1FyjzT5MwTq+RY7zJRBvOKVpXGtu45UluSWM8EPU?=
 =?us-ascii?Q?NZnNtnvonv18hU3JcmGU4fErUPeADbXM7fh3DPqElxbWo3ztDvUC+OMwOmPY?=
 =?us-ascii?Q?lzHYg8uakjXq0Q16EkunXSR7KJ74ulg8XeXmFI1LjcHrBWCl8jQ3DlLUoFQN?=
 =?us-ascii?Q?gKHWdMXME+LRRrisFNl21rhQgPWQ2FD//Cn0VrVMjcFjKRmxGlyjGnX25tOs?=
 =?us-ascii?Q?Cn3I4CIuGkijrhsxrkFXJxFVFdA0Z6VTMIk1fn+UnJuNT+cOnjdWc9TeZSqW?=
 =?us-ascii?Q?Hk+fGP+ycdZdtolstrEuAX46lNuA84yiDu48iC+B76ffZUe6LBDGjdai69P8?=
 =?us-ascii?Q?4oPCEcVTXy4iImNDZnlMrUnX2J6iDmgCgpicXUqS+Po7F8ZB+ajLmxUXAk9A?=
 =?us-ascii?Q?4+//BYtKltuT4ov1N5zXD+K5ED/sNu/LsYT/USdTZiaNwhwNMddU6ptgwxkx?=
 =?us-ascii?Q?pUAjKmHSU/u+A2i6gg3YPVSrSV3pd7gSlOe0jTwH5DJWC93tB74HJCe73EH7?=
 =?us-ascii?Q?dP1/Q5llE+rJwWHehwNm/Jaf6522Ihc7CAjr4Tm3OorkxHujnY0luBaKYmFu?=
 =?us-ascii?Q?aYfAKTV1jouMpv6Wb2s9w8paIibGdh+HPX0l6EAu0NgSYGZEf7e6COie4yMT?=
 =?us-ascii?Q?begrAGpUfP4jMVGHaVkWTPPnOcz5wVW2W/zrpKmN1MawPGXgEz+dZvpFtWTF?=
 =?us-ascii?Q?/ijXS8KUWAJDt0LyYmw8xxF8PrvruOUkJew0/bBYgejW+bBKS6Hpow3wS4yE?=
 =?us-ascii?Q?D2NenGUFvhh+XG/SS8SHZI6jk5i/tmWWU+/7fF2HCVHGbLO9b0bzQSMrwmpv?=
 =?us-ascii?Q?aqo1R69VQlMcBWhHeIQNMuKPwfNc3uKdrFyIfB5uvLIPFMX0wCBfm48BxTph?=
 =?us-ascii?Q?TAMhXAasLqdGy23Of9bK2KE036y/Q9L8GUz6uOYTqWf0fk9IBNTyuSRtZZwZ?=
 =?us-ascii?Q?f+uMnVWPMhTmiSepEaMpND5VQRFnbUaoi3rnx/Moiu/x6RP73CIKV67kHWqO?=
 =?us-ascii?Q?Moa1vBQW8lgp8sXtmJF+3ZZKysOCtuLAc24Z4KCCm7RMSF2IdVk/y4s/LMN6?=
 =?us-ascii?Q?wSOI69E2BjDwj8hxlYpKkxkhKjGxZqTq1Fe5y11b7ryoowTEWOC/3zkvj9+t?=
 =?us-ascii?Q?P50bX9IuRESXDSgqvbCG09A38vZIEdIwu8uToWLSm0PgW85ajAQGiiRhHVCk?=
 =?us-ascii?Q?FeQED20CnSsy3xhL/3qeBYKXa+gac/lCBddeUZC1jRWXpTgyi0O5fNCNQ/0a?=
 =?us-ascii?Q?yKSIcYz95PugyFpFAdVP+iyrli2uzGM=3D?=
X-Exchange-RoutingPolicyChecked:
	DVqJK+pnkGmTIrM3G3cSvTGB5l4q7yNvB64YaP9pIPYHlI0ZbX9lxDJRQrCEYpmrkUhYXL8xHUNgBj0eUPM3JpnR/5CYOKfc3AVDBQ4iaYjgvbievAnRSEwrB6l+5yR6debfXInBIyG4QMOC3qaacrp1ZbwdJH/8GXepfXMCXSAfyp+OnMdQUrm9Bah7QzSmCCve16DANMElhwGXmlc5b8OcCFb0GoPmSin69wdDcUz/Khaq29L/RQK/ZUDdpuGo/6TQARaW9T2S/xR3BFf+sAostiOq9VVDEZau1xkqKnJ1ZT3qSIb6KV6OYCfXstebmhYh+ugwaEQnvzOYQDxIIw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lTe/DqIAqB5PmN0+5O3i61I/mEN+CeKrr+hYPW0wRo0f02UweZLe028XHT4P/nV/27ooBgiWpx4bxQeTzMvkO9DmprpoR1pT+FIk8GueudXd2OsmMq/AXcnUlAAsUUo5yGQmXjU7PI6z8jy73EuB9Caf6VYlcy/8nAhmk5qr0sfc/IpzWiTZ6BaUBqRJcOgkGKz5AaAOYOfT4RSyutuQ/t0sU6a7V3SUu2T3oBBE6fGOcM+u4BX5rQX6wpG9VHEtVPAac0V7Eljb8ZhJXWTBnYs7Xnv34dVxwcBuoIKmMOkfPX/4U/3KslP9+FfAcSRv42FNo84R61l+fvVSWnuojkTqKMaujAgo1ZpiUFinEAqzoHnenqUhPVKnz9/1ZFuV0svIlNJxL64rF4u+QgmcSqxTZXNEToQugTIEyc4rWe0Wy8t3UouvK7v+0x98aq6NLp6mI/6a8LfMCitjaGKLr0IbynqHIzTnplawqu5nhgD+IREaLPy97Xq/kCNC2PglZf870ohc5p7aiw2qcVGo58WkkpzE23ibZ8uiFueIuiPgRTe3aHCWJV9svTZV52OLeNhdJC6MGOS1LDRds/ATq4DQbemw284jVczcxpjTN7k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb436823-8ff0-4477-db83-08dee03fbd38
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 18:02:29.6352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aSLazTu2WgBGiGTD2Lcx6fDJyHlgKu8B2fGrAM37LhmD4yKxeRjnutoM6jh21rvo+u+OCDOz+JdUWKhi4E9S6KTWpzBhNe6E+mdB0pbhNB0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5624
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_06,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=761 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0
 spamscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607120193
X-Authority-Analysis: v=2.4 cv=d+bFDxjE c=1 sm=1 tr=0 ts=6a53d6ba b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=aVLt75UyfqpH5wJXYPQA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13633
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEyMDE5MyBTYWx0ZWRfX3p3Zf1KgeahG
 zpZyIK0o986iWK4C+CDkzUhSQmyhcK8UDW/W3XqNQereOeIG/bCjx1UeKDqB0sBP7YWzJrLlOpz
 cJeWE/KtdN2kCMHAoK1j9h1uIopuzfxFUGoy5rYZyWogh26kCOWMZC70DrW3TP2SY4jndG7oioI
 XYG7rGxNXoPaR7/yrWmkcYnb23eNXxhzM9STaacuroJVvyLiLkqAYhcdjNAjZxEnQJjnpmT/27v
 K43OrpEVzgJ5ck/kzblFw6zDmggZuo8apTDFwZKwjnJTnOdqgA1EMOHFcuIsqkCznJRS2XYpZuu
 YEOcz6MYfLr0l2/+H0Dl8E/NBFHCMypcilp9p0S2590siYK5kjUuSZwr5Ys/r58BzDrveWec4nj
 ENoKBeIHK1CyJLDTO3IbQKuMJ4SeAvYlAyOxEKnnajx7YpEXT3YkQI3Ty+kxOMZIkpIV6LNAdoe
 8A7oXXPsIGD3wTHgVPRVIPYeDjM2qFKncU2bNnp4=
X-Proofpoint-GUID: 5ws3j_Kmh-l8H9X_38nnVDIo4yrQKtSJ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEyMDE5MyBTYWx0ZWRfX0XJ6c6W64YAp
 aDdYiRo81MFBZV5JoFRQ8+Niw5xuqNLL+2phCbP/8RTTKMNGQaHlT5+FsItmvbVJJVnOjJnX+Mv
 d7KQ1AYfHn+Z/HvlqzacdiwF54gxSm83/vsyOU5OcDxMKsG+XG6I
X-Proofpoint-ORIG-GUID: 5ws3j_Kmh-l8H9X_38nnVDIo4yrQKtSJ


Can,

> This series adds support for board-specific static TX Equalization
> settings provided through Device Tree.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
