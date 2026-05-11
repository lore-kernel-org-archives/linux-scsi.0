Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127B446AF2E
	for <linux-scsi@vger.kernel.org>; Mon, 11 May 2026 17:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778522017; cv=fail; b=DZ5y6alv9a2v+WN6CF6HObdJqih4zw8fBxcOahsPHMzpbqv1DXHtC82BxFVz0PJH8mUJeU/kXAOurlLe0zNvvvzxL9aRfz1/wpyyzQFw7uFy+1KJRagdMsoJ37upC2/ebLxeQYp60IpfEFhDyzUaM0/Dzx7qgYTYgd3hSvUBXNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778522017; c=relaxed/simple;
	bh=/jks/dofTAGM6rRpIK81vqmpDnjL7x0VBitdZf/b0rs=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=fwl0ZYqpVcbCJgGGq1nF3uWrnEfUKYWJ9mo0Xd96Sr4TJC0kT2UPKcfVQpwhXYRZpE8z+4DASxpj5XrK9PCBgRLizSXt+1+BRsQwkopRqBr2pVybHrRTLP+qVF7SjRUbM5uSvLpQrsBu0sREg793+xyOFM4wbI3iNxskLXi83wc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U2WrtPrU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sVY4sdGz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U2WrtPrU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sVY4sdGz"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64BFtrRY2859339;
	Mon, 11 May 2026 17:53:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=cm6/oyKx8gnaFdiU
	TPTosJIuKRPc9e/tViIG4bYZoPs=; b=U2WrtPrUVZzwZXH8e5qPl5ysbYFLhtfE
	UkB/tqG9IiHcJtJg2sgijVVcbOJOon9ufBNoIce21miakREtCL6eC48pX52lQyNG
	yT1PLSdNnUiieT/TSkYp9tMEcUez7pU4p3QYrU8IRC6DyOI5BgeoxPhDLopJb64i
	M4PcTxPZSEDmpnZBWh/SuVdAnXU06kH0ucr7Q1+icHcHgZInbs0gLHRS9W5Omu+P
	EpfMbzxC0vf95guOyHhcVlnoPGSRdd0HMhUkg06tY+qNXb+yZ81YEPTt67OsjK4A
	/ltwej5bQCUyGJcfRGL7UjIKwgz6WBRLtkkT6yqaPLpx50Fs0tEs7Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e1uu9b70p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 May 2026 17:53:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64BHfLTK033065;
	Mon, 11 May 2026 17:53:24 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011009.outbound.protection.outlook.com [52.101.62.9])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e1uc9aat6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 May 2026 17:53:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f3HWNuMuBNo5rQqSgHNLtr8H9MBkRk5aBP14l052XD0wgau56lc3+GugH6cW5dWna7w2YNrP3FhwvLEBAcizEN4BjCIhMlvD9T5LWV/MmopjztTskyicTtk7QKNDokA5Fg2K/tSTkfxMaw6/oRE/cRuC4W0f0C1bHtMGBKj52XuPaiuczdyt2D6ejKiCeEZ/0nuiOYdWiCp2Cls6D9VXAdb8f2fKMevpyqHoJsXizu8aiQFD+XQwJMtX8US1xvqwNddAHGXphBQ0l3PSGA34GcnbRjZz5Sr0mAFvMSNDIBrkp19DV61kMyBZcyl64hOxdGZy7qfbazsSPf0Vo8d3Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cm6/oyKx8gnaFdiUTPTosJIuKRPc9e/tViIG4bYZoPs=;
 b=f1dLG6viLNoEsG3tnKpC9+4FVBbvMU/SZ9fBIsMwY6+B0slUnwxcOnrZBMS6EVPO+ethCkCzQkq4dfhFFX6XipF+TXkFa6D/pnTDDFqG0WYXAxNB5xPiXduU3GTuBV2b13iGlv0JHvWpS41WqEsiHXprcSPQe5tXPEMPd1VQ7O/WEg/x8G1QBsCxl2elt0iQQf2x156FVkT9OJoVUrfBYSwji/Tkw5fr3Y4QkG9/TEU9E+Ci1lTDPYhEzzY33/k/7GHqbzL4t+R/FDQXfcFlYxyC5n4r0aTP+cGGBSTrSb4iUiVt/b2X45WfFfWVR40v27TIyLi2lgEfy++bnokddw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cm6/oyKx8gnaFdiUTPTosJIuKRPc9e/tViIG4bYZoPs=;
 b=sVY4sdGz1ZQcX3tKL4qWSssVL8lxslEg+7DpYM1wQqZWtZDoe2c5nu8cOgHGW9WzOPqmG+LpIzugmzFo+JFQnVdGzlHy/CeFPapsU8wpMiiXdmJSd1WYa37Do8Dmxy6UGkiB8uqzw/UA3ARP2tVnOZWfBGX+R5lM4FsKDlvda0M=
Received: from PH3PPF8C8C3D129.namprd10.prod.outlook.com
 (2603:10b6:518:1::7b6) by LV8PR10MB7967.namprd10.prod.outlook.com
 (2603:10b6:408:206::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Mon, 11 May
 2026 17:53:19 +0000
Received: from PH3PPF8C8C3D129.namprd10.prod.outlook.com
 ([fe80::6b83:fd:b694:9db3]) by PH3PPF8C8C3D129.namprd10.prod.outlook.com
 ([fe80::6b83:fd:b694:9db3%8]) with mapi id 15.20.9891.021; Mon, 11 May 2026
 17:53:19 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, error27@gmail.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: Fix return code handling in sd_spinup_disk
Date: Mon, 11 May 2026 12:53:17 -0500
Message-ID: <20260511175317.114007-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::28) To PH3PPF8C8C3D129.namprd10.prod.outlook.com
 (2603:10b6:518:1::7b6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF8C8C3D129:EE_|LV8PR10MB7967:EE_
X-MS-Office365-Filtering-Correlation-Id: 936524ec-b6f8-4970-1668-08deaf862f65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	XVrXqQgTvf3BrTmuwsNXM43pmwEpYWI/CdvXdgUdFuuH6BLm/q3prHCulVCE0pBsqt5U7dLcnM4x2N7arxNDXtOFAVIIjhIEGAa3rLWehIjrl/2khMLEeW3k884ZO6TEh9yxJEw3Sf+8G6US6Ow/njCGR3Ps2DtB3Rh6gZhdZLKWHX65Ew5XIDiv+yOhDTBCEeYQg1sRo9ynzvim7NJLlV4u971WBTbSmKK005WVA0HIG9gkziNafnDP7O1iqRstbmP7AdvP8qMgMPvxWu9zwEFZUjNVT1FISfxe0R7KTRZaZ2hm7Oy53r0BAx0q7ugKiK7E+Ek6YdeOMtINJoy2nEPWmNP67vQfHpLdlT1q+9fqMmnyvTQR6RRh9DVMagMv9AEIVh2u1ubxwGZiookNAsXves/aTj028/HkUCs67XFShWsmiSykYeJHHDCVRkDdkR5VSBRhiRSjIueO01dG9M1L6ebpxlHsm+6R9LvLxiA9qgwsucrncDCWMV5vXZGjAv5NaXLek3gMqWuO/2YwufkXd7CFKR6hHLOX2yJbm7+2zf/IgTUtQxyym3QD0g094wI41f4241HQgWXcG5B8eySuHTACKZlJy8fXHCnoCxozFe2uKbkDpspPZkMIzcVDV/9EUyvLYzVC+TZF98byQ6iLAtg0DCrn1nGVCV179VSAQOOHs6r+6JhQN/o20bW/DInfWA0dR7KML4mcGWzYeA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF8C8C3D129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jy6Sz+oFuLsT0+vmY4lq7STPrdqF2T+lzb6H3GdpDlitDrWhmKUbge64wwra?=
 =?us-ascii?Q?g2Z4rrb+WrT435wivaDEWwvi5IApJWCSLM3W1GnuvqpG3JcclPuyo7aYKwcx?=
 =?us-ascii?Q?rFQOGZrlYjjhCQmGDNuj0Tzm9vY6SAfYR5YMmct1Q2deJ6K876svhzmQ8Qnz?=
 =?us-ascii?Q?po6DdK4Z7hydXpnu7cj8hNCCYgMZy6um4G1zdWWdp3CB1dwjb9to3pnIH4Mf?=
 =?us-ascii?Q?Sajw2L9ck74SWbAf6G2SOA4I//s3nbCevo3OxyTOa9nPs3BehygK5DXO1gn9?=
 =?us-ascii?Q?bwXx9kAOR3cie6FmFbjt5bNWQt+XLWHw2h6dzyB0h3QsaC1YDlDhQF8VUDXn?=
 =?us-ascii?Q?Cu2FhW6dwCJs85KNBoyITsiIXAozhhidLzvagN/jg0YSFvOQrdAKAWhy+6jm?=
 =?us-ascii?Q?s9kRYTeyTq4we3MgRKhfB79rJaLXrUUWqCsJwyhOYllvL28yPfc9Y51nijFe?=
 =?us-ascii?Q?EnNH0Zme+iBltNX9hcKc4eR/dFTU0wWTyNwkTjCqWlz9SN6p/ogz3vSvTWqB?=
 =?us-ascii?Q?iS221Od7X81G6I/9A3U8fYU6cwQe8BLVzpZbHQc2mBE1Yvp99z2beatJchpO?=
 =?us-ascii?Q?iOBuvehgCtnawMpV12fB/TlHPC68VVZ3idBZesOQyqFeM+Ho6o0cjS8eIuSg?=
 =?us-ascii?Q?WeJNZCZ5s/V0Sh57oEZtzA8hZdQ3+oEgcq4Aw73CA8v8kVEdqYWQzFKvkkV2?=
 =?us-ascii?Q?gnUp4XWH84yusbZrVVhuLnBTYr5FtfNtpsJ5Ykk4rrMlsePmH/Wh/K4JJl64?=
 =?us-ascii?Q?WSoYY6BmfWfJkkZF2F4hiHTxyMdoGLTydNwFwXN7VtkZVRStiU6kh1S8Qsmj?=
 =?us-ascii?Q?NxRr2Ry9XxWKsEF63VEx57wrK3Etpz7PwV+hQzIZPfAowJsz/NEvo4G+OVcB?=
 =?us-ascii?Q?k6q+gF1pUChOnvB4kMIeJPptjJ+9pEPNK9XZD3VsSwc4ghc16vfz95Y5IoUO?=
 =?us-ascii?Q?5ajwew+FGK2XdAE1gX0Do5vHS4HUur1ounJklBZzrdselpervnTPaQh0gs3q?=
 =?us-ascii?Q?BI6MuxBx1VR8XJebYfC8r1XWYBf76DqsyqWai7P7q+YuE6kLDTcit2C/PPL3?=
 =?us-ascii?Q?g2BRMZUz7f5JRKqLZBg6QnA9siE/yvhW7pjyL2wbttUM9KIEax2QYKJO6TuX?=
 =?us-ascii?Q?RXO1Uhib+jX2ToyXyypmpTUNwa2hsa8ySRutjRi5YUDsIXGPTdoC9Ef0Y6hy?=
 =?us-ascii?Q?pyKy29sqypcaWRJQ0S21U+w8PntphkgHSOxjYDc+xXNhzXaisjkdutiwczjg?=
 =?us-ascii?Q?4SW5fL368eWUijo2lqTBGR6+1/dRUxsuZBsUJqpbKCn88xGAvLLgY2nb3JLx?=
 =?us-ascii?Q?l0qhacNmlkf0aLsZhpou6EzrbhhlO2BOHMOzY+apkELULPy826w/9UnWo09N?=
 =?us-ascii?Q?1KxbRx0+ss4hFWcSnczO49R/GY9Y5U/rmNiAobb7/UcJQkhHEtRPCbHF51xK?=
 =?us-ascii?Q?v32NiaIYXZO1fvrhKj/inRxn8gYhvEhyC43kLqZe9zQMZ66BWmktuuPTbHLz?=
 =?us-ascii?Q?X5ncDCc4QohkdGZRMNEJrFxLOXWl8u99DacpyPz6FUq8SeKa1mJvE+cRKHSY?=
 =?us-ascii?Q?Anur3oCFLUH/ROYDEY3B1TPsOiNFXoBafYDUQYS0mnt5rW6CM1CjVcFxD2ET?=
 =?us-ascii?Q?PmoH8iVL+qncbFjX9Nt+V+09f/4zeCWIaz7eqdaBjyd0LpQlrpQCIDgUUBWB?=
 =?us-ascii?Q?i4rhJrCWLopldwMWS8uoUz+P0TpiYqoDQjSCA+WDo5kDhspqY5kdwrVtK9dj?=
 =?us-ascii?Q?tNXTocMEAIO5wbx/omKMMUZgpOsBoNQ=3D?=
X-Exchange-RoutingPolicyChecked:
	k2EFEJKIfhoqj5TtMzTG/kzFIny5C15zB+FArz7rs/uc6Jj0Tp4bhYLn7yb14jjWLxIV2c9CJBYEd1QX/UDwiBaj0O3PwOUz8n91wMO0bITNXv0VYgB53C6HXXa/KuqYGk35cTDcZK4I4aGacGul2CxgHVrqV6Uxz3jzEepattpCoeS/+VCX1w6/+mWka6ZXsXNV5DE0BtpnXZip+gpU3jV+vk17DuUJGb6Xr7AEvkBZ6fYXUcrZp8Hy8fCt+UNM03Mpp1KF1vPAuqfgAK1jyjXaUQG0wkxDV1LefANjw3+aC4XTkA4E1HaEh1F0zI0ZSv/NOF5u6Ytqd8h7d+eYiQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CcDulUK1aaNBNmgLinD5yvTsVLfnwGZf9giqq3ZdgyzKXekQv4YInmt8loXjejZsQRNkbfdmlGIP9zoogo4VshKL7nOzpLopHodfGGtW40zoNgZUakZkyonIO5ltH+/HDcWLI7+i5sdQ5dWBMu27YkiKDa0bDQLCRcAE4auJ2kaW/DruGa1E/aXHlXyoBxi8X4M8J67LbfIxgpefHTl1ADpGI8mW7dy4Q7SwW0v9h9EXkLIkcokaai9aMha4CEvfI5h87GBlMsw3hccNbl6o0lCcWWV8Fc80JcuDdOU8IsRQJljXWmlRuxdj0Q+QrYPoVLDJkhxAbpD7esY5hIqRlwOpvYeWfJdMcND1ScmdxsVYdbmhxm+7yORe1HPbPXfIgSLz6XxhMj44BbCur7FztK6oh9HokgoQqqRrxG/Jx0hTtXEjCO/lr8PSvoJdkNlREQ4192nQGjJqz8r4EEXHpDEF0aV4o+Y+6Gsu2QMsaoOTXKby3gobejyJVeOYnoWxPPE3uXNvYMmHH0/g/URR2WeEe0st8pglQY3HlYvEywvlmA0bYSAfSLWKf7ii5oADZbkISchey2PTCeIIbiSYxcEozqUoTI1gROGrrJqJMps=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 936524ec-b6f8-4970-1668-08deaf862f65
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF8C8C3D129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2026 17:53:19.0876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C9KRQkl52yFMC/ij2ivNYFdZ2CgeODAakbURvTlQ1FhQ/6sAAa8m0Jbn6D6VJ43Ngl8getQSDiYR2AXLJd5ItCcksZwOZVG4dX/MMJp3kVo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7967
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2605110189
X-Proofpoint-ORIG-GUID: M5o3A_jeDvrigJMv2uyMK0NMM0mDddUc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTExMDE5MCBTYWx0ZWRfXzFSW/GDPP/uw
 DMuvvSkFZptozFd9Oy+/zYMDZLBdrHDKzIsjTumkYha2eB8269UCGmIbVT6rYlyuAZrm4/9/Zyt
 Kz+7bsTepq0PDljkrUY/IXn26sP3Sb00pz+ug4TwjL14/FLhuGvUW7CGIehcO+Kgo36Jmjz6XDc
 OPX88QfrmpRCWyJi9W9Tn1ZCYpfzA13+UewiuB9VkyRv3HhqOZmELQsyEaTr4w1957R0puwMDxf
 gw1q1cGitGcYNwWu/afOfbRxmReGxkk/22C3PiwTT0T7wnzdiderdK1TkAQSrG1CkrDNJPF03E9
 Nr6j0b05dJ/WctkuZPtPrGk65Rw3sZRIvcas7yNylJO56O5XPAi1dxI353gK8QjxP7vrdgylko1
 jycut3NKvNEMDpNuF5pZM4XAHYRk/ldUGr2avmzvy7qyG0112AJqZzPH3yTTYAq0l3u+GhGG3Ok
 29C8W3fdVpjl5e33uGA==
X-Authority-Analysis: v=2.4 cv=SuGgLvO0 c=1 sm=1 tr=0 ts=6a021795 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8
 a=ljU5ZsDoGDN7kQXEa0wA:9
X-Proofpoint-GUID: M5o3A_jeDvrigJMv2uyMK0NMM0mDddUc

As found by smatch-ci scsi_execute_cmd can return negative or positve
values so we should use a int instead of unsigned int.

Fixes: b4d0c33a32c3 ("scsi: sd: Fix sshdr use in sd_spinup_disk")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/linux-scsi/agFbI7E6JQwd3wGW@stanley.mountain/T/#u
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index adc3fa55ca2c..599e75f33334 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2476,8 +2476,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 {
 	static const u8 cmd[10] = { TEST_UNIT_READY };
 	unsigned long spintime_expire = 0;
-	int spintime, sense_valid = 0;
-	unsigned int the_result;
+	int the_result, spintime, sense_valid = 0;
 	struct scsi_sense_hdr sshdr;
 	struct scsi_failure failure_defs[] = {
 		/* Do not retry Medium Not Present */
-- 
2.43.0

