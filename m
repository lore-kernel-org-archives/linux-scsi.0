Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02FC3B2A1
	for <linux-scsi@vger.kernel.org>; Sun, 10 Mar 2024 22:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710108657; cv=fail; b=djbguSMhB/0SPCe4tDhLyLyfw+hJzfVJoAgaaqBEucxyda/SHeCBw4kchyZeVuJo+EMAcAqRYNkmqgytgqRxc+1hSdHO/ZO+xGkja34cyTIfPEX6+vp7Nt9zP5Zt2fDwDInzx5dK1HLg2f7zD3c23TPBJs9Jf7zwT/baZEF2Naw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710108657; c=relaxed/simple;
	bh=PIXk7b3WZkggK01O+Ao8RNRBiGVcoZ2xX40IWhDXTo8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=dh3pYS2uMGPk7GPBqf1eIH5QyY7AQW66JHYRcI6iG3/nNWJW0pCWTOT5xRQpAvxpbSUoYikS+B0yw01vv5BDAF7iEwLYMryXvPkRYHU4URJMQQLDI5qaW401BzuqXOoo9HGyVusLp36Im1xe2d8cEwrYKk6GBBAnidGA2V1D5dI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ljG/E8U9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=i2xS3713; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ljG/E8U9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="i2xS3713"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42AKHYBH032018;
	Sun, 10 Mar 2024 22:10:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=GoBDsdcfWgXdf7sFHVOzPu+SQcyjyyTEYnakR1oCtc4=;
 b=ljG/E8U9evVCfAvQArJZdEP0ZUJiJtyoNjyh19oux+gF0NFuIur8weBUTJHuGLeP+V3T
 BHHWW5VFBLeWE7+m6W3tnjY4qlA4c3PDYBLx1yU+tbJ3A+0oy8FwwHqmOvRWdcKD3uyK
 sN/wueWxKGzA7C6Vmm2bN3/QfP9rsVwyRessXOpqeyVN8IeRXpQvJQBjpepViTgW2KD8
 jsRVeWaLIGoNCWee9Be6ke929pIt7EE2/XMF/87QXoyeZAcPtqYpHTSvA2quE/pVoV1u
 4kccF0DR7M5kUG56ZnK7loRGv3vSsjIInMsCWzX8Hv9TSXhPpSmpej93S3cNPtbnjiS1 Kw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrfcu9rv6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 10 Mar 2024 22:10:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42AKerSH006068;
	Sun, 10 Mar 2024 22:10:40 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wre750q7w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 10 Mar 2024 22:10:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZ3CtbuXgxVZ0PFel4Qywixtx15iqVg6lU1ZVVq8pp/RzOUKx0VrBMeXyxsiHmhUcMeNVH4GxhlmEOK5nV74QmHPfrwEKRzQqnBUWGMWSCKPzjKKat0YakWvi903Zkw01yCi1BYlFDyvhyYoEM4YcYoZrDr7lZUlP5TXqJFA0OBRDzvDnFq3NHRwcGjcjjVo8cfzUNI6rVRGKyzjJxnfPYQ71XSDxln03if6/Tae4Km37N0Ao4M+X07CpOZkDINC2rXj6taDF2JJGke/yrvejZ3zTORKx8ry7DFqZI78umezJRvSpU4z1Oe1kNKsH8q7H0jCkiYZKs/8z0bXWbzUHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GoBDsdcfWgXdf7sFHVOzPu+SQcyjyyTEYnakR1oCtc4=;
 b=is9wXEHIGK4FyUVlr6zq3P9X/14lI6TxGIG8QZkdYFsQKSY/+ZJQtmCz5RZg/HMNWj8W30b3coRvRgDTDlHyJnBEcAzlJ/5eq9MEIXH17W8gZbehCYHp5rQ7eBlIK3CH4A7i/Cq6h/GaSiGjsPDcUnYGUcMmRyDe795cMsQc/aAhpOr/z+naoWiT+79Z78ZASfiW5XRCewon4z/9IPL6X3k3fQYwERm3YKAk+CYaaShXdmlOYMh0E4Gebt4lsSJB3/rzm0rS7gvrZlVcNcaBrBZAU6tmEPoGGBUjw6W0U+oJ+iywWzjdV7QoquAMnVlvnZbczn7h8yBaj+tdCN2v5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GoBDsdcfWgXdf7sFHVOzPu+SQcyjyyTEYnakR1oCtc4=;
 b=i2xS3713j5PDn5IU/p94evKUxCKoopZS68HGaO8hK6bt5/kFc6I/A5U+VOIOKRSzszoqXV4OKpK1QiNTat/KM/KhHnRtEm5Rxmryr/hiIP5GeLayChAGpzvGYOSx0oX3BE1CbneiYjl1h9u+UU117MpFXIFnPoe0pnh9nrmRltw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB4849.namprd10.prod.outlook.com (2603:10b6:208:321::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35; Sun, 10 Mar
 2024 22:10:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59%4]) with mapi id 15.20.7362.031; Sun, 10 Mar 2024
 22:10:38 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>, <chu.stanley@gmail.com>
Subject: Re: [PATCH v3] ufs: core: add config_scsi_dev vops comment
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240301034610.24928-1-peter.wang@mediatek.com> (peter wang's
	message of "Fri, 1 Mar 2024 11:46:10 +0800")
Organization: Oracle Corporation
Message-ID: <yq11q8heo17.fsf@ca-mkp.ca.oracle.com>
References: <20240301034610.24928-1-peter.wang@mediatek.com>
Date: Sun, 10 Mar 2024 18:10:35 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BLAPR10MB4849:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e55e2d8-30b8-4a03-6424-08dc414eea8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	XWfPTXDrKyaB7HAgOoK7j63C8I/JDTxkp/sLTuq6kZQG8HeIM7YXIXzawYPBUCqnKXBJ/wzSIKIzp98utNZizgil7Nz7mC8Htk8Yvm92OSWVxvnhtFAc5sgrMZvoxE0QA+sTo2hILrMalKUcJVqvv6lSZkwbaCefS3EV9JAamZ95CtfFWOVR4lx7hw9mbTNXSJxILR3USEm2CqYQiORbme+NF0mj9f3TdUFx0WLMAEodhafUUMsCkRaqFEdd0sp1TZwNIDepoQ/pZ5tkx8EBfnslZMUqF+ZUJAlDH9VIE8wUa+SpO/tFid6ln5iKmtW8iJerFxVjzYdA+VOE9rJ8/liPYOZJadRLe47ejeF4XGXF9HXHYxUngWtDrFTke9y9v0eUOwzEelGBTh16Qp3P9OVlvKrUfI+rLdyS1gxzrODVyb2I6mmDggLwJaCNPT789cH4GE2uOMqmLuwBCawiiCEpxDl0g8W6X7g0L88ddgMGCnRrvdZ/zwPXC8s9bo5tQFOuibx5NX2zo00lKVSCrM6dB9cdx1O6Gby5jJSngdJugjwHAu+CLn9oCFPp6b7mQXaXSP2EykxZVFDvd+L34EaT5tVS9awDHTIbvgsNCksgAsTybjStoMevi189StbNLzgYqjpNAvmv4sdUVY/lznkxrc0vLNZdmMGUkr63yq0=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?ENHT1WTHk2MMPeE3sFRIWkYk+WrgRcHF/IK8YGicq3byUPTWJD03eue/Lkx3?=
 =?us-ascii?Q?fhbMsyW8XFLc2wMYN4u71R6gPxw6EI3Wc2UafBLQnFJi9qv4BAk5oYdzC4DX?=
 =?us-ascii?Q?RXm/T0llDNMAUfqeJZFCdJG9Dk12T76LdbfO46bebyHhBjADnB1yu8l0Lwf6?=
 =?us-ascii?Q?3BUbBGSbb3GB3QAJbqIOzkaddMh1MXuDN6mUgHU+2WPddzRC51CikWWVFeJa?=
 =?us-ascii?Q?N3fRYZNxOir1Dwzc9zBe7S4NuyQqOpAWFGhjuomaP4Zpq6Fh+QCW1TvJ0u2p?=
 =?us-ascii?Q?LH2wkavsZEgljRluJ+MGDGQGTDOZ+dhMqWjCALTPUWIts6OOhdnhtLiNCWsW?=
 =?us-ascii?Q?N+ebDswUoe0zWbXD50VOYqqf6HDeg8acuisIjfC+fRYHu14j3oT3oRuSzqsi?=
 =?us-ascii?Q?eB9ZX8uI/O4wiHONNxv7RNGEER8F6CgStow8qnjmOG3h1kvds/1stzGCwgwH?=
 =?us-ascii?Q?kESF2ET3l0GjwyxUFC5M69SNBKcfSuvFa9NWSSHZJg1a5qtFcmkOL/9Yd15f?=
 =?us-ascii?Q?JL6Z5PBknqlD42TzqYKsqq/e0CYAFkJdJvPUc/PsPeBYk0i/+N7zSl9dxJJm?=
 =?us-ascii?Q?M0hrs/7nTVPFWTot9zypLAoPOmjx9BOYTfi/+HAiafCvmh+yW7I8WtrIS0ct?=
 =?us-ascii?Q?Yx88aIJKZWbDIoiSIF/LiMq86KP/RAgOHHU1eL+EzEgnDYVdnXqvI1UxD3gg?=
 =?us-ascii?Q?TR+9rVciz0DpF9lMdLC0oyuKL7FlW+P9mpXIS+gjbOWdSDeoM8qymjrdoAJ4?=
 =?us-ascii?Q?iHE0JPhRvfUR7lQW/ntR5EKIkAVHZRPYQ4le+Yh/F4mLdvJI6PqqDRTziHFm?=
 =?us-ascii?Q?61r/Rlo2FMntJ2FHlESlsqy8dshFX7eBILMFQm/u+M+65G7z3vfkiNEMjerr?=
 =?us-ascii?Q?Hl0RgPvRh46xgVYSQPDPRTOQFYKjmSf/tG/ENM8vsgQt00XPgfBb9HDNkSak?=
 =?us-ascii?Q?H6ov/onLmmNQRLT/5vpowZ+PsJxr1Ku/0Zvj7i8WRYCkZKOKYJxb7wmqqNPp?=
 =?us-ascii?Q?E62EMTVn39OO2z6zHfCT6N50WYOvlDtZyM0h2za+B1pCLIee/LtWrKEas6h5?=
 =?us-ascii?Q?b9b7Ezpng3b1MDRYmW6wrHh22Y/XbEonNyXsiBHbmrBFOlaPpZvLDtb9KasR?=
 =?us-ascii?Q?ddSJTDvfwIv2Tjt8ED12ZLEPk0mLxN08ThMh1/SO+SlrJsc2CVnH27InC/V4?=
 =?us-ascii?Q?AOiycPt5l+22w3Drb0YOTHP0+mxw6MgHH3B9rpi4EXSf2oWL/ok035/gs/5j?=
 =?us-ascii?Q?vCFzfeY2cflbAv9QFyz+qwdgi8rlNHLNDbdGZ8uqprGSIrhYzNepB4wCw552?=
 =?us-ascii?Q?glIbqw3QiGp/wpwurpyGilcRCbJYt+CHWxw7VZEqxDDe2MkBLFiEO0XN0RkR?=
 =?us-ascii?Q?7CWhRregbn4As9iP/dp/3ZjLBUoRT6WDN9o7kasciT5pWKSAxYU7sSIGKYh/?=
 =?us-ascii?Q?iyiBgn/iB+Q29MnAhdwdQGMKUWnr0GvBl+Mqnt2HAt/J0W7mx1G0kpfdbuvN?=
 =?us-ascii?Q?GHwqKSqb+ZqIFD10YyHO8eFzxuT31AoAnsSJUWiw3KHIfqIcynPRAUaiCC7u?=
 =?us-ascii?Q?6AgQF8gyinVWW096bqNI4eex1hklHOxygp5n44/lF9NtOoFIhdn8I85XXSAW?=
 =?us-ascii?Q?eQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	aeduvW6umO7KulG/ahpeSBwQCf7mytgSmsMNrBULLcYadoDfQyEXuScKoCeTQMmgqGx4M06dwfZKzlJmFz9LMfrkZazIjGsgtmY/XejbdGGJURG/Yrle5/IKA8kNQZ5DA7J7UQ9dO1d/u0Ja3srts0l6OranmuDoHNJLBhx9B6iUeUk/OXlWH/WT8WYJ3yBCrLRQEmCwB6dDhMdsbS9if6jvQwmGy/RCkZl5qiXcAosFLPdXXpZx8VCyrW8rGWTsf0i0p5iOLAzNkoAoM6DZlral831WK/WkR7fV9omBaRBYQn56qB4//5DD/ptvcjHKk1OeBUqo+iYP5IhmeScGRGwZw1vfvb44DPSptmoXCWLSlZljLTE5eUAbnxrKbfNUXR/8Me8qQctWP0MkwHT+KlIOUbtJY8OhY9DNTM8ZiSEYyGCzW5HOEIRpxMCyTt2JO+oIQVGyZRemF5sOX5qVuLnu93+sUFtQuKv6oY9UJJeRzY3IBUBO+1mJsZui9dZAIwrEsY0RwMGsbnsWwkOeu8luTeAr/VzE2nycNRBACLk3Dt7pgUQQdZBoWRgfRQDz1NLqX84ek/EY+WTMP9MM430RH8b0/GARWgwf62O5Elw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e55e2d8-30b8-4a03-6424-08dc414eea8e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2024 22:10:37.9808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ik0/xTj6yctSatKW0xyVGcVNhjnt9atcd6gwJyO42i2so0T5zrtGd9abrM4OvG9NVxv0m4Xdu81JlGtXjgNNpkdLxhXimqiE43ejU35I3Xg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-10_14,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403100180
X-Proofpoint-ORIG-GUID: wnAukirz_XFzBboGRb66pwrpIVMkTEw4
X-Proofpoint-GUID: wnAukirz_XFzBboGRb66pwrpIVMkTEw4


> Add config_scsi_dev vops comment.

Applied to 6.9/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
