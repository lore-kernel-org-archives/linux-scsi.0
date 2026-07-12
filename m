Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F3F233923
	for <linux-scsi@vger.kernel.org>; Sun, 12 Jul 2026 21:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783891883; cv=fail; b=iie1IkeBMPVRd1IIb8yYqNpn42FQrNa2o0nSYfKeOrKOsZ+Re9ovv3hicnESTWlr20EsKq/z8xUhUpQ7jfmmG6RwPsC5gSaLBVjhEBIt4MmACXjSKh9LzL/8s80jlzo1wofw0pHKFufepQmyzyO1+LG7zoEq343VMKXU1yO4k9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783891883; c=relaxed/simple;
	bh=lwvdiS8DpfPgZUQWcP7QzTXtDQPwT1/S8sN8VdrhyZY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=TFQjvfh8PqGpu4NIso0lvQygY1+nkDptm/cyHEgevtzjqov3PAV7yqeJiqhK2kuLqYcDvmI04G1n+bMqZG5ikoaIjTwNVZb8ebYaXgC0u2+IdfAHj8yloRj54OiqTHBGqXvxz2GHCIyER0eakl4YGFPAXr186F7bDH1F5z5mT8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cVkwR/1V; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oTkUbAbS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cVkwR/1V";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oTkUbAbS"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CKRXkn3998489;
	Sun, 12 Jul 2026 21:31:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Za50haF4mhpEmW0UUV
	n+7nyK3s1GNq1NGCofBljqiAY=; b=cVkwR/1V7ZJf67mem7SlaRrGKulzdPcX9w
	0WZWS5AYCZm5+7yXw0ETzCwxrq/x7/uYyTB7BTeHEejFxdjTAvQeG0aCh5mNc5J5
	izXZTnQ1aP8fjI5AS/lDVIcbWbuH4BUk0Oj6D+9O1jXfJJLOiR2ejt12xGLDdtVM
	kdX3p5LWgCmkS4HG7PYvU57oxHG5+Z3evfgAVbr6DLm/Qq94rBR6zFH0DT1R7rtm
	TnDP9/QtWvsG2RcAncDvuBwehQEQENBgwBMmEVHdZU76W1v7xUCUc0bW0F6gsebn
	OF7Zk5d/jsqrA/0gBCOB1a1Qai47m3Siy1mxkIhXfGR3oDQr9FyQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbef0s7ws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 21:31:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66CLSYwG017853;
	Sun, 12 Jul 2026 21:31:11 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010041.outbound.protection.outlook.com [52.101.46.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9pdtx3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 21:31:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y09MBzL64gxmh7DATR6+nVZTBYlZ58eGsdrWzi8lHQJuM5UE8X+ME+TT/21Nag87Yg567cOB3CHb+sjAkyuhnUxHEk+V+6NwLofJZyQyV6O8lp2C+ZnVlt058x68vu4z5X/j6/C3/KVoIckpW9h2h0ycNFle+XFBHzrEbvPJA7uoDjgTZ6lvAGsJuKaJnM0X1TaefWjvbQso51NVFrqhomujxwOuBhJbDO3/T5e5dqpvi1sUvwkvMbTJU+T07nKvvrodwr9pcZtUvUIsYDWJEyY5I6xCEptRnamc6MClBbGIyQMScYswmKJvweo4aNRBiox0SC9QzM8W/A+MO+5ndg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Za50haF4mhpEmW0UUVn+7nyK3s1GNq1NGCofBljqiAY=;
 b=eSbZdbuYoczNrFFOC0zyHDwjaaAYJiCwleofWskdHRfi4jhNr4xD2ufvt7SUHpg+I4st27URMlmxwg3lWRT65Gn9H6+ZgYaRUEySYcc/DE/moQwrp5lyLMGgw7IxaIq3SXeVlpD+lY1qQ+4oG21pay8fii9zYzDlyEnPE9J3JqednkQhpjVHSFdJRJz3DL59rX1jb4a6FZWDqIGYJ7ZkX2MNc9pkSeIeCO26fYUqjwHzoYyQGCNOoydeezCdvSDOGX9HlipZtJeoDOBEJwMC1qeFV1tJcJHSkVyOxIcOBOGNzd+8SxJnrPEHvllEQba5rWb9ZyR6Fef29Y7f1P0R/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Za50haF4mhpEmW0UUVn+7nyK3s1GNq1NGCofBljqiAY=;
 b=oTkUbAbScrkIDigKlHy62mmZv/gQ51dIQPhT5bLJuDc7G4+5c8AyMS/SmY0SBYhufHCyd6h395Fx6FSywMBJtR53hzoatXKnT+IwujJajZkCVnLyY2FBqIiL3DABkTBbadagYQ1rb8yeGixJswI9F23zlr42/QGHN7wtUOgptGE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB6202.namprd10.prod.outlook.com (2603:10b6:510:1f2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Sun, 12 Jul
 2026 21:31:08 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.014; Sun, 12 Jul 2026
 21:31:08 +0000
To: Brian Bunker <brian@purestorage.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, hare@suse.de, bvanassche@acm.org,
        krishna.kant@purestorage.com
Subject: Re: [PATCH v5 0/5] scsi: Refresh INQUIRY data and reprobe on rescan
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260618233508.97960-1-brian@purestorage.com> (Brian Bunker's
	message of "Thu, 18 Jun 2026 16:34:59 -0700")
Message-ID: <yq1o6gbdhf5.fsf@ca-mkp.ca.oracle.com>
References: <20260618233508.97960-1-brian@purestorage.com>
Date: Sun, 12 Jul 2026 17:31:06 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0290.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::26) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB6202:EE_
X-MS-Office365-Filtering-Correlation-Id: 572a5b81-6869-4f71-0e60-08dee05ce2be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|3613699012|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	sw7sAPlDQjsM8Q2Ofef87qZC78fn4ged94Qn/gvAjODl+IB5KzGX6AqiS9JbAv/+xaHVOpWc9V2m0oo0+erriBzM2lTnKwv0p8bnVKn1wufBaUbJaTrA71GxE/OQ4ZIpT07s5VrzfqQ85/edMYkfIxBwEpbN18w4+AzQkyNgRtywmT3PvQ1ilTGrkrA80dyGWy6mjzYC47LegQyVPyLpiV4qCGck6KmVqlkFHMXUveVoVsH1tEiN18qyyXuJJ0SpWVuPEdtNna7p8+lRPlCC2ihzLiaO0o0t+BvSBbomX6jn5zN700uE1yF3STgrho9qzpVK1gnKUG4b3B4q1g+TtTv479a+BmsvVGWwJA5GLgnz8CNor1H9b9V99tm+ndfteriXx8+WSoM5q4Nj5L8LwQR+oHnlYf9n+jdd9Ok1pP2pWWWpj09SCvO20498VoNgaVWZJte69OxBO5fWKbh85ucL1Is4ZuvrgMWleGkVtcJSDPzrdMMhMgr90RUlWtXoNBuUepnuyFb5fnzh5f3OawLB3ixOToerc/R6Z5wBQd3P7LorFltuz6aJ6K1OHw5NiDzezFvkaDrHzeEzjCWwY2DDTP4AkZXUajwDJAKbRdAC9GY4qOK++uxGmb1WHn+eO935sveuDNjueDcvY6DmrbSnvbEoAsda3prpfwDOSRfbsvwIfNOP8UNnAeg2WDeWAs5kwXX8FSjXQVn1nvbFNxnNoAKeBpMoSiRpruvD0iM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(3613699012)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KmWGccw4lT3F880xqwKV3/VnUZ+AR+4aOr9BZPqd4rXe+HkFcen7cDTUXuuE?=
 =?us-ascii?Q?yLvpW2yqe/eebIsKqnEee5GD+cdxihj/+qcmrzPkrjPIgsa1NvAETZL84Tkw?=
 =?us-ascii?Q?W3+fexFH8zsLD6lHE0S7FkxMAvDFy3GzzKYPd8LRl5N8xtYnbCiOrcychWK9?=
 =?us-ascii?Q?rRqpOQTr64kiDMes9w0YGjeBV4uBtPgQ5sp/PFjWgF1Ema3pYQIXT/rHOGsl?=
 =?us-ascii?Q?jox5pxuJ08RREamXtxSNL48EyunKYBhuQQJ1jmGX26dGscNlnxTDvQC92Uhz?=
 =?us-ascii?Q?+/wXMVxZ3txg+/EeNaGZ2wYSRtk16KF1x+dqz2VE1d4f9KzONLZxrPUCLOcG?=
 =?us-ascii?Q?4+vXzyyw3xo4kk3VitZMi9C1shBgkMhnHKngBk19QMq0fbdf5NxCawtOPjFy?=
 =?us-ascii?Q?hjL6HohvE/7Ck5V/7hM0BxiMePDTeaDTB8V9VsAy2S6dNESjIWzbq37Y7EUy?=
 =?us-ascii?Q?BD4wZ3ogjAOty8CeyTgYW/ZWpVjqYdktr4SJM7q7wsYHPLSV8BiayceFKyJE?=
 =?us-ascii?Q?h/cg0mzezPJGgWKb4YptWS6nuF62AjmVT/YaGnODNPUv6HrfH48/LPJ+xryt?=
 =?us-ascii?Q?xkJtDRgMGJMI/tnKAo5j9xEGayGXk08UlZBPUIlTbryWokY8nC9r++uuD1/h?=
 =?us-ascii?Q?GSz4HOA2KDCR7hChxXdlY7vivFNUae2QwjF/zh8QcqWLi8a10xHtXECd+MKA?=
 =?us-ascii?Q?jKVIwurz7O/V1zMRw/wujRlk4Oe+j8wwSOEFPRyfdEJWv2gycpab8mQgUu3W?=
 =?us-ascii?Q?aVNdze+sL1nJt01r24dLHK0dGOfvRCBaU+uA3tbOnatiiKGTxAMpytwbPMBz?=
 =?us-ascii?Q?3+EqFflZK2P0zwXIRN+x7VEG3kvP2ldSFYVju0Q9vMrvgcyGYFpYjNbClLDF?=
 =?us-ascii?Q?aRs3+Fu5smwioKt01vpfMDH1sLUbewVnbnQFFteo4DUMD+CfFrYkEUg5iOis?=
 =?us-ascii?Q?bjuFSDlkzj7tZMRZv8+ZxvSwhKNH6RcCmgyw2tfAI5/sSkoTJJmapypEllJ6?=
 =?us-ascii?Q?yVeV7A6J8FK9x3miNh5KoJrAootSqSG8bvgGFCOCO4Y8YVTQAKeZJvJWcr7R?=
 =?us-ascii?Q?WgfBahLsX49gRv/YPnT4SxyaP/NblM9yvd7kfWtRLs+2xyYkBRPDxpToY2+j?=
 =?us-ascii?Q?AxOugeEzvDPgis6tis1S4lAMjezOq+FRfVBpgUQe/rPvK2YmmayFFGlckpUY?=
 =?us-ascii?Q?LTfPK/Uno+jlVTOtOKnXaEC1Z0RS1CsN7I5G55WIWkH0gXjh/dSMCiPrP291?=
 =?us-ascii?Q?LuOFUjzx0sVvdL9tvR5QPcIEU/ANNBMxNfY4tYHTuaRtYBBoiW/w/gHm/iIV?=
 =?us-ascii?Q?ubv2ZtDHcEpwIVK1GyTOJbbhHZnxx9MCa7FuV3zp09cyzLfj6BW9QNbeCJAB?=
 =?us-ascii?Q?OvDtYK+EYh9Ie5J8PEEVzXS/jNkzXcqP2j7bZnOBZGSegf+Cpr/0/fc6tV0Q?=
 =?us-ascii?Q?3BJhu9MjgMsuhkuT6koKMRPdnLr3UFOc+tkQZRrF+XzMErMcjC5LyWXFSxRd?=
 =?us-ascii?Q?a9rNFY/Xd6ORaXwDuZE36rS4oMKHKs7xsf1uVbwBWuXTh+0b5r9q9Lk5SNmj?=
 =?us-ascii?Q?+dzo04cSl5lp+ZmS2GTywCcARYXsiiNQEH0r3nstyK6P9woj+vmbfk/2bf1i?=
 =?us-ascii?Q?sMNuqURqfH20kSCiLGO24F2F81pKrG9Cvmcub3tGPG6PvEPspNotypEtOQBS?=
 =?us-ascii?Q?+7K1Uo28qfQV0FB7fAuDVHbhWwqRM8Q8ca9LZDTZyzKMLfXjJseM2pK5dIaR?=
 =?us-ascii?Q?S7ZqeUk5yS41svt67fMYuqA2ErtVdL4=3D?=
X-Exchange-RoutingPolicyChecked:
	pvd1N7Zfb4H0tTAhT9BTwff5hpDl6fgBlxXff8AITYtwlEiTIkn0mt+KtMXa605VMbUOuudMtE+G7md8dzBl+4E33CcWwhoHDzhjJwpESkx1tUkdyZK0xVNMGzreFbqksthQPATUJgcwgzMGpoCOQKrAV6QAboMlwlfcCAPNztcnn7+nmmapTTZJcYkymhEMzKRH4Yl242Ua85kaCUqd6CY9mcfAxH8T10eDZHpNXvysE460dCV25U1vWI4ckGy8EO0mpUCqyZmBx8ruZFnr3s7zo/qIRdLzcsnXgcMu/9Jf9zqOusa6n3Op84VZuJY3gsgIK7nJRwTNx5g9vbG0bQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eaWLWoD4sEMznI8UD4WRKtatrplvI9EB9BEKVDTK+z6M80BordiGU4nzufBZRatFH1R7y0ZXGvqFXDamv741M5qSOghJnx/gBlgMormNB7MT41Jf3Ne/n5Gz7SxJRKutEN116M011H7FoRYVbA8nDnfHNzU725qZFawYGKPfxIADxNubxFkiOjEJbRmuA4pcid+Rn8L6RLu4y7Tz/R5abW9eunBf5VnlHxIrSrwqnMcT2+poZD2B1Kl6nC7q2E6OjOcTezW3+Zd/ykbsjxjYoQc5SpHNA4yg/FCc50kChUcXf/RbZ3dn3ldZ7Bv25OZrYixJQXRK3Llw+JgXr8DO/9QIXHQZzurEmDJ0XUgmkX16ov7CCsv3K635XZAg6R0sOEZ1zuGqz/czqYVMTupB0SNE7jb/xfVKlDKRMzwLpE834aET8O8M3hrHgvLLnw0xFKSzNTyArG/WHQijDNs5LQZgB17GwwejrZGw0V5T9f9mRk8dnA8DS2gv1VjEBqn2o8LV9IAx6JtL9McGnJwJJTNZ87A8t3YJLJeOdQniO0xpYI8geq0xs8aLHicBO5i5qRYVK1MICnmjNIW71kW+inr8viaVSOGsISTVncRE5MU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 572a5b81-6869-4f71-0e60-08dee05ce2be
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 21:31:08.0106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XCDarZtBYKCYjEOFD3tRym/jwwPvnWEjM7/PgrfHMOmgJP/Y3Vplg9mNd6Bn2gQkpHpUsv9X3GtCKuWye63bBugj6wNKBkU8vFlmNlqNRe4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6202
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_07,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=821 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0
 spamscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607120232
X-Proofpoint-GUID: x9nTYlkpvlToxQyGhY7KgYE9_dPKF5Te
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEyMDIzMiBTYWx0ZWRfXy+OyC9FxEdkI
 GhCboybpvaxDguKAaTb+2eIJohNDVu7lHWgDoxADjB4GsUPeu9NFjDkC8yvYyAwFClCfpwSgeH6
 HpfswnL1OEQK8t0/35ji7nkoKwtpBTChSmJ/DiAiR1SyD+A8bnQN
X-Authority-Analysis: v=2.4 cv=KJZqylFo c=1 sm=1 tr=0 ts=6a5407a0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=U75qAp1fu8h16lXNoiEA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13633
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEyMDIzMiBTYWx0ZWRfX7+Dp/bVMv2zp
 vpxd9uTLvU6ppA7AaEibLb5IlYXCuITNxQZiEdXn3icucKsbFBtxsV+sOZEFSqQK8wwGIqOTdn/
 bZlUJVbm6kv8tvJ6yy/kJx0jdhf8ViAsL5kc9jzFD16jk/5B9v5aj0zF+zGhemQD19/EuYWImki
 Ea8o4kGLZsMIaH/DsMEIjq9fBt3mx+V7QKIeK9LG6mUiD9nnSU1pPqydiG6L/GfdKR9fWDEA4Uv
 qP7PB+wfNIxy3kFPyNscerG7H7/rPn+zVQxbme77ncBpQeQSQSUM7LA38koVFaQRRWu//CU1IdD
 qp7zEZG3vtxmJ201SbRyilJGrIXeg4Rz8H6MiGXfiohdfZKqM4l0lhu/RyMfLMv5tz02XkHHCvz
 xu19r6Uxxf0LIr4kTXrfm128oi7vnMNnPQ808KF7Em6TWj6IYhkadGarfh+r9N/BfWC3U+6QzGZ
 vxOn1l4MsIAiTeaZOb4/3ZXkSwLGQxLROuE1KTC4=
X-Proofpoint-ORIG-GUID: x9nTYlkpvlToxQyGhY7KgYE9_dPKF5Te


Brian,

> This series teaches the SCSI rescan path to refetch standard INQUIRY
> data and reprobe the device when the peripheral qualifier or device
> type has changed. The motivating case is an ALUA target that
> transitions through the "unavailable" state and afterwards reports a
> different peripheral qualifier; today the kernel keeps the stale
> INQUIRY data and the device's sysfs attributes diverge from what the
> target reports.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
