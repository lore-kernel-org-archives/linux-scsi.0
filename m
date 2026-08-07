Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778643F6C30
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 14:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113701; cv=fail; b=Jf8OWGsTVZbWI86JoQGqxeFAS1AFA+vWVmjjX0/5I7hK+Cik1RBCOwSHnUboHYBjt3VEkYoh/ti4x2WLh0Wngo2uIlYog5LtviFPMNWQNNc+8BHmKaXz3Xf08gNKzzDLOsnQ46Qe+pTF1+tTaeegSPEsumX9HfgpLYB4yNn/dIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113701; c=relaxed/simple;
	bh=YLS53gAWRxG0Uj6vQxLs+1XH5XDLgLkvFEtRN/dMm+0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Ek7e+G4K2kzxqKXoAwEpEyFOdTAaX8d1gzoAMsH412fXt3KjExrDLvVb9z4/FxA6hGpY3RFitiFb7UgkEdBRS7duOFWn1Ja9A1cABtMnSxBevSJylO8i5hziFpv2Whl339HbXGYalPsOanLkUuLdFp2yMtxin3XbwMpuMpx612Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nvikkw6g; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LnZAe6Lx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nvikkw6g";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LnZAe6Lx"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 677D4EbS1396846;
	Fri, 7 Aug 2026 14:41:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=PRgcV1EpQmURwZZ1Z0
	52gzt4/GxqfsDFK+mw5D7bLho=; b=nvikkw6gZz15m5I9XLtdjWqNmfVbzZetS0
	xIyZ/HkAizBXdUN5R96KSKRJjAc3WKwol4FxJj12LJ+39CI+XGwIaov30QFibkKj
	uBxOnjNb1aglsDfkMFtLofav1bS/ncoes0MbhM2dQZI84niUzC+L4s4f8mHg7a6S
	kFotEDZGhGi7jBjkN8nP0EQM0Xdd7kTjmddytCZItZNaMDEqVYCbbtfSYmC4pXsW
	x2MVJXnQK4wzADzwyXYezBwHcO2uOpiXofdRV/VYAMB4/zGGY/1IgBlKtfD/IhuP
	zPchqKI0d2UUxClgxrEHXMwAclQlnuKtfFohU3CYaV4EdaPJSx1Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs7qag5n6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Aug 2026 14:41:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 677EetAS026210;
	Fri, 7 Aug 2026 14:41:14 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011050.outbound.protection.outlook.com [52.101.62.50])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78x0y91-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 07 Aug 2026 14:41:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I/2qpIsGx2GJLMfkcrNYD0vnrFN7ezAKxkDk/ItA540rrXoicYF+LMJux8Zcpw+1YoaKKYaSr+u5sm/OSMbJUmCuGF+Eo0FV87l/w4HhibpqzR4cEvI7B6DfT0zKGToTLOT1M7UKlCOAD5cYcLMm2ytEnWCeLHNnWy4+Oh3+DQQ+cfnxUBBX4gAmH5IQoFXmNC9dBBC8w3liixSA1ZFfHd4bgY4TWE6Ae44hHFq7qMaXwB4ymM4L20Erlkrcq3oY1ixwJPfj9KaP7D+INqnpu0cmymFxBIChwePeXlChDF+SbRH2O28pn+akBYWrgOl8qSiyeR8N+QmmYAtVkX6Blg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRgcV1EpQmURwZZ1Z052gzt4/GxqfsDFK+mw5D7bLho=;
 b=G86YHXrVNK0VjH+CjK+HppNU90PNpPXkNuLxiaD8kcnuUFj/m9E23UrNiYS8n+3b9T4lEd7z6YRJTUps4vLdSuTdjF3qfvZJoGsYj6tx5i+Jy/sn3t2V3dXxARJ1htUq+IIhdn0gw0x460EaY8IWASDlY9vVAjDSH+XZsCJBuR2Lz+r6Fwmid1K+2pUMdwitx05mSzv1/TO0DKbo1k2AyhMqSsZlT3+Gp2RVx9T8/NylhzqcRZpj+49HkbsC+5dLelgOmkDL5ELUJ0TdlWoZaEfdkJ9F13UOVaZXKhT5TZr0QFkDv/r0fUMSzdWOyeKG79iZpVGVjv6vzg7ilR1QdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PRgcV1EpQmURwZZ1Z052gzt4/GxqfsDFK+mw5D7bLho=;
 b=LnZAe6Lx5TipKNHdyToO6OzuTlq6YOsxtxfR32vMTC4D2Z9x6lfxCl8Grn3BVoF/JOE6pOHRjPnmWoP1McOYk6KJRTCdkXjUVqB4kxtw1gH2BlofhrifcqgZ+ERoNxSmJmSGu4wFiW23lz0ERRTeOJCPDE9eDIsY1U+4hW6mteg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB6332.namprd10.prod.outlook.com (2603:10b6:806:270::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 14:40:54 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0292.019; Fri, 7 Aug 2026
 14:40:53 +0000
To: Nilesh Javali <njavali@marvell.com>
Cc: <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-FC-Storage-Upstream@marvell.com>, <agurumurthy@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: Re: [PATCH 00/33] scsi: qla2xxx: Bug fixes and hardening
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260730155838.2119230-1-njavali@marvell.com> (Nilesh Javali's
	message of "Thu, 30 Jul 2026 21:28:05 +0530")
Message-ID: <yq1fr0q3sh1.fsf@ca-mkp.ca.oracle.com>
References: <20260730155838.2119230-1-njavali@marvell.com>
Date: Fri, 07 Aug 2026 10:40:52 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0033.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB6332:EE_
X-MS-Office365-Filtering-Correlation-Id: eb31db49-c0a4-4b93-33c2-08def491e248
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|56012099006|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
 07gOqmymH2b4WnHPcJIlEnGb2B7e32FTEQNpGCcXbZz0lMTibk2q4ymbhU//HZiKF3HA0sZGsxASzCOz2neUu6YxoY5N2ek8NXIFFqQIpvBiBa/GmQxvX/6R7DGvk24EbtqTDAseYZBTY9j3FXU25XLqNCsbIcaISzxdMQu+kDhxi2rvea57+SL5tetZA2jFf9y2FeUpbh+g8SvHo52JItTmwQhqs7n4zUwGhnKKCc3bUJgn3IpPNCWdX2Cto5dLNRgsFUZ0JNfOt2TEMs5oVAlkVavUtQ4ROEu01HCHc0/O3k7rgPc32vQXIjaYY7/Lb0kLiH90IkAKYAflgeBjpFSZgxOxv2KbdTE2pZn2MDA0SLKIS/F2rA1kyvFSx6KuCHrufssqFaTo7KBOMXRkdtV0kGKL5tG9UMDVPZkWTSl23bZA0wZXXYyQtWCjCo95BeLQEI1HG6m14tISE/wqdnNHrpYRIf+/0JMklct1/+035rQKgLH9iec5o4Zs9Yksln+gYs2dCaXTUPfsHFzxCTnLKJBSY0lvEjzpwHfkPdjJOXucaevTAlXo/G4NJD+Py5/u0tFkKJ0thKOz7t6byJiNVFlrsOkXZsRkfuLtniX6Yac3SBMr3chaj8Gs5QLa/xo/9TRNO17pz8+n+qBrI6uT8/XY5RM2eOiPqubzGVc=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(56012099006)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?Yet0UMhbOLCVqhjFNnG3mS5RlA6OY8TlBNSQUC5GLIesHZzFhaJwyxGwWxbr?=
 =?us-ascii?Q?2fDEXcRSA1zVF+aZSCV/c9Zzi30OGqBj4PLr2sbbyzz4qGEFpTIzCQ56K9zr?=
 =?us-ascii?Q?bS41r8fY6wZXlD8aIG0Y3VV6Chlru8HH6tvElr4AaKahxwan6gNIUICeRTws?=
 =?us-ascii?Q?foSwP6AVEFR1b1hH7k9Yb8IkKhKvbHURB/jHaO+V0wJk6ucQR6Agkr1lDQBt?=
 =?us-ascii?Q?hi0yJ0kMalq6TLY/FIXzrXO5nIfouqtaj0w4Ht5V38wjMAqXL3qCpv8fy2e/?=
 =?us-ascii?Q?ub/eQ1X3YaglncTcMFIJLioW+CMXb77LD9J1rC3yKdg+c6G5tpwowWT24Vbw?=
 =?us-ascii?Q?gQOptvo56XME4RTEvprLuZ8FtQbZZJ2fTMPOwPH3LgU7CJlZMhBA6RgIKqea?=
 =?us-ascii?Q?YYR4GV6yko499oHDVh8t2vuTboMCWujGbvHBeXVIzS+0iYiDYqCXYDgTzLEZ?=
 =?us-ascii?Q?JKpVHDnys7xt8frXCLTloZxO2hqaBp4Y8Yn2xrhASjS3y6R95XZ4xxbpntAP?=
 =?us-ascii?Q?vZMDUi6jImmdBgLoYd4aKGmqWBSJDT7N3Gti9pZncSKf0Kp8Qn6EETXKwIYE?=
 =?us-ascii?Q?Q23ZlCMIvmgQQ789LpIBMshy5wYqbEGlnCMd3fmBm5WTGQ4CUoPCLVh2o8Ao?=
 =?us-ascii?Q?MCQRO14pN1OtZpvXP2CPwNhiVEmXq8YQrHVDmiHT3H20raMYwQJxzhviP6wJ?=
 =?us-ascii?Q?6mkxb/3kvko3IFVusedl8NdpCRLqO/iPTeCShvA8We+vnoUXeXMR7AUnT/oC?=
 =?us-ascii?Q?l9Q/ArYDYzVRm20ggh3BdeTh9L3Exj2nX1XL1qeGbULkadPBQNgpzGuAOUtU?=
 =?us-ascii?Q?9TcI35dj29fYIxmAXxNjJ3gO3szQt/oXplB3OShT5++kAYecCcXGqbPcasqV?=
 =?us-ascii?Q?b9ClmherbMiqq9D/RkhOQIugwjRwTze4ZoyvzSbnBIknPhb96vSDodY1R+pW?=
 =?us-ascii?Q?/8QHw7Ytgt5spvG2pONSX4fc3aorUw4dKjepbRoO+ycZwM5mGaoSHsEX1zcW?=
 =?us-ascii?Q?lcoOqfr6TSP52qDCjuYHZ0PwVusdDyj28/klLPvH9WXQSEpN/djGL9pvi4/U?=
 =?us-ascii?Q?ZR/ktPfKcsczeX2QnwloalHz9ObzW2Rm6gEcf413Cezlwm8oOmycp3pPf32B?=
 =?us-ascii?Q?28SDod7oODch3RJXEmNfWbdSgFcO7xogRXLD10sfrSM4S9pobKaTj+DgnyNK?=
 =?us-ascii?Q?lCmKJhCQBGIT4YB2TUoQyQc/S6xHQYQ+W3O51Rk2gyoybSAxxoxwy3+VDyuA?=
 =?us-ascii?Q?Sv0cfqxL6KfrLNRGBjVMlJVIZcJS4r+dsihrUCE8IqT9zpU43bMAyq+C50IS?=
 =?us-ascii?Q?C8gKbBX6tZxdhL67vRVYqUG0xeDBt51cplODC0O3i0dLOsXMUN6QIUWPD6O0?=
 =?us-ascii?Q?y5vy7RsgG890g6CgVLU7fdbiU/E1rpKbPHBnb6qr85+Dd/2ecFYHrKQ5k/he?=
 =?us-ascii?Q?G1HoQkVpIsL0Tkbw/xt8YA8R21yMXbetr02OLelXP5SVwO5V3ZJ9LdEUTjoM?=
 =?us-ascii?Q?Dzj13puEyTd1bilegwN8vnpw9O68ldAlj/81q/TyQ7lqDdEnC2Ko12TyXifz?=
 =?us-ascii?Q?4eYYNaMcyMWQ280cjns929uWYXxeG9/SiAmVuiGPAaOlgb6MrPGSdkR3vDIm?=
 =?us-ascii?Q?F6a0GybykfUd4nEaM1N24cqagSadOmWOQFUyP+I54LDxcwh/QVy7u7feEeE+?=
 =?us-ascii?Q?+HRe7TUy6qDgZseaZYFpJF4aseRuzjBcBDYZveytUCvO2NDIOfs0F2xUd2U8?=
 =?us-ascii?Q?q/6tZcyTyOOsyERobOSVYSRcKix0yxg=3D?=
X-Exchange-RoutingPolicyChecked:
	h2exjwMAZDs9JTGv0/f7AQqt1FgHIN2GS3QYUpsM90oyUiSs0xDGneibYSep1QlcNZzvdmqEJ0xUe6pzYOy3wonNaIairPe+TYyqrwXhmirnKzVGo+s+TnnyVcvD0oHJsbv4dbM7YY4leh5pEFTNdQsVJljDtMQQPiGN8wyjCWualX//kLEWUgopn89i5iObbccMOAOA1Y6Q9bVOzdTGTOyv0dAU67X7NFAy95iWHYHswGZ/qD5MFmG05P8oTN88+MkLjBdkNNMOnPh2ut3VbhOgGb7x7ZwBuY+s2F224Ovn6pkjyVyXaK6OKPFrT2aBbk9Axv3hQNmCed/14o7g1g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xxG2EmSebYrDk7XbhN9n9wQXwXN2H0NE5J5rt7GQZh3bJ512V9gMf04NvhSMpoQJNN24z0XpV+4AJe7OhwB4z2Fr0q8i2+MEL46IH+1VGehUBAz5qWCwfZK1Y7sgwHC/fKdm3w9636yBfncHHMxCaGLgCtIkqNGP5DsTEx6ZzXRBjsRzStWs74x/HVyj1BoQ4ePUPkcZv8QUbLhJG0soQbUEpl2VeDhvJh1+9LbGLRlxC1WRz6MBVusMskIPbpXxR2LAH6OZMF97h353AchvdzCQajisLO2Wlv9UZvTYEREJ4XtD3Y+oc0uhC2zCpUAlbcxIUsICvPbTdXqfhhE7yctUFtP6B4rwTI4AvD3lJEA8GHuyHKO0FqsGiMAxCH+mzO4HguOQnOEgjQju9ijPmn0Y1g90nsdK/Yrq8yRhIzi5yAFa3qVRXTlytdWPUeNkgXUsdUBTmJ7kmGDWOnjH1UVJUKJGGy9X4CamZrDQHzK59r9jaVAr5Fm8mY1q9iAFbpoUdrb0v4H0uf671bGY2vmERYfpROUegEWkqgsB4vmK4xpvj+eHVPGAUaUNbJZA0zT0w0jyYxSz1w3jHjuh93zDZEhXisJtNCqR/VQu6WQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb31db49-c0a4-4b93-33c2-08def491e248
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 14:40:53.8772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8KykPLbRvXzxrOhvFzTx7kqHURLHQHQWXghesxkcxFD6hNUNtpeYgaKs4wqwWs6zoZijt95jwaXu5nFA34YQd3sumAYGsRrO96ek6675gi8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6332
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_02,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=653
 mlxscore=0 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608070115
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDExNSBTYWx0ZWRfXzmO7Yp3eKZpR
 s3epIT2h7q/QZbl3J0aVkRqA0pPok5JVzFX1JLN+fJt7GbCSZeWQCAreVeTcoSxxnqGtA8VXcNP
 YK+MZmejQ2cOaDsRQyZwtJK3F6qw3dNSwQbm8t+x15GH+SICoY46vrpCYaV84LXNCrQEse890LZ
 MG3hhe3ViWJ1PtwfimSnrGqtS4+4ZVngflmNDNzncmtin/2qOchjPiqnlAbsX3ixoq0cN9rlFQP
 9rEZWvZ1WZT8ddHYG+OxQcI1zH5NzO9mUiYaI/i8SkDrGnzRF8LmXuZRZ4uPf0nV8WIFUWC/APT
 t91mfQdBQPXNuaX0QECc+37VNFs6U9Hz7gnE3VQuJkMGIEPIB+PYaDkLVxAJ5wjE0DuuqOf0eW1
 eFE9v1VmG9HNmDkVpXtKjGf8DeQaLpIr5L89B75qj6Nt5TbZr8Rv9ybG0WiPU01mnL5EmcopTvb
 Skv2ykIY8NgVsC8GdVWP2Wsxgk/BhC/vMSFdESes=
X-Proofpoint-GUID: wWxFNGRQw52GmDfEYcvCyOAyEOyJOpSa
X-Authority-Analysis: v=2.4 cv=frDsol4f c=1 sm=1 tr=0 ts=6a75ee8b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Sv0fKeRqtYgA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=aVLt75UyfqpH5wJXYPQA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12101
X-Proofpoint-ORIG-GUID: wWxFNGRQw52GmDfEYcvCyOAyEOyJOpSa
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDExNSBTYWx0ZWRfX+r66t6C4Ap3L
 9qfpPBgbTnp0WC/PbuswzqGO4czUQJ0FObr8qKjpTpcG7D9KTjhrLz9ISC4uAUbfc7vCNeKM5Ry
 qwNLWiD1iCvYuq5Yrg4POkCLHJwtfjA7B2Yefbu6pxL7+SE0WQjO


Nilesh,

> This series collects bug fixes, hardening, and small cleanups for the
> qla2xxx driver that are independent of the QLA29xx adapter enablement.
> Most were uncovered by static analysis and fuzzing of the driver's
> interrupt, mailbox, NVMe, and BSG paths; 30 of the 33 patches carry a
> Fixes: tag and are marked for stable.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
