Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBB5197A7D
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 02:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778810767; cv=fail; b=Lury2o9Z4dbpUMxeogPiChpaen4BdRGud0hd2ByFu97MvMP9OahdOEeE5NM3UCtIvmZF00KszhmDkDyW4Wv7nLt7nOjRnulBfhGS4/xZobs8Z1SYP6oNezyD3Qap9gEbQ8X9I62Fnch9vCT2sj3V1aG/zY4hkRvjqFRviwM9i/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778810767; c=relaxed/simple;
	bh=oONjqKegKZuMGVnN96C+l1ecyJRoyMDgs7FHcaGuTEo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=uGENFFoVbIWkwcxKDJGfYmiDnEikzZ+KXytAL95/I/0tyxSnPE1EBq6SOTyG1tYM6iDyk8XeW9XazTAJ2/SN8cG3KxReKo0roJz4NRr1xACmKuv4QQrI2+jr7pWjtgEEz98kMeJh0m3USk8uqMU1/C8ZrCulZTtjPF3sHCAH5Fc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BNDxpeb+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lKVIE9lf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BNDxpeb+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lKVIE9lf"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F0V0ot3371289;
	Fri, 15 May 2026 02:06:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=eXKyLeCc4VOqPOYvpB
	b+RLIpRJzRBFZ6Pr2i90x+G7s=; b=BNDxpeb+ms+3uEbuRj8wcdmtgsxxmFCx0q
	Lp8OMr7Qkk1dQfpOlGzrgGvhnOvrCTlDvb/lHyzQ7xDrVPMpQtlJCHc//FMRm2zm
	BhMypIBG5lslGG+LQsSzrq8AKAJXL30Ua1kdhcwu0bQS1RD7BT7GLQIc/mNMbZih
	Wv8Z27MK/ekFz9ogtP6N5/uCwJlp/R2SVt5PCpOVvLj3Vm6Rna45T50M7HPVTrHL
	4eh38etg/fLaH2or0MmTLNmsMtEnibMSDEykD2kCGxXFIs8jmy69Fvx+V438g2CF
	+TD7EokGoTuob+05TJm6xyVTofmn/m1vuKtgYINhOrXxBo/GksfA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e5m1rgdwr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 02:06:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64F24ql3014412;
	Fri, 15 May 2026 02:06:03 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012056.outbound.protection.outlook.com [52.101.48.56])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e5kvx4ws8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 02:06:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ln3ZjDc9wvXn3kXxpSsoIn1lF/CljNVD4dOmVeEQ+/9bLbn9AVPsd7UcrtJGq0pECEEDnmHzUAQmmXllSm3fuUCO04gpvj5uSVrlNDbOplJwtAxt0zi7Wg1jaeTl5bnZhrobqqOE+pR4kd9OXtWAr+NkLrQvRemBPJYG5TtLi04SjwBtYJxXISi5Sggz1YcRUHtJVNDHaQGvnJCuWUuisSwBkkEUO0RExdZ169EAgb5z5D8bIvL0g3eM+ZcGZbIJ68NNr6ngy0MMc4VUJ+SZGkZ5ZmUe9sffv3mwHFmB7VW+ykKrbSpOLW6evrHlfs/+F4tMdzfp9+VgZL6YYjFgFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eXKyLeCc4VOqPOYvpBb+RLIpRJzRBFZ6Pr2i90x+G7s=;
 b=crHoIONwy6woG7bqWGAQkSK5Gxnv7fOewIgF9zWECTBMTY3Q8izwQvauANc3jMUuJCAL4bm2VObYR5sESiodonikLEEQHINw/D7Hv5hT76bx5BCFB0PNaS+HsTCXGaSp08bx5lnkTfbwWPfbVxZ7KyKVVChcyBOP13/AabYNASHxrxGSjc2S6mcl1SEX0oqtdn5OF3NbMElprb1K9b+TT++nnW5cHJeZipfk9SaU21clpIl0jzyFonDdVp9lBIi8JEUcBMbntJs3kQWcLo1HAxoa9wL4ZasMreA+0rOAHCjHMySyHIa6QDiupaQWDSRfes7DtknnC4//4NhddYtSLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eXKyLeCc4VOqPOYvpBb+RLIpRJzRBFZ6Pr2i90x+G7s=;
 b=lKVIE9lfO/EXD6S2UeM+kEXZ/0weP6P1bL3LwRNjBkQMj86zuCC2Ef4hVmEg8X1hMMS4rQ+kb+mJILRr0JGxwtWz4TpSQdkJvOq9axabDDwYK0Qp49/3gkV9uD17ByPdlEi4HvUQ+cv0nD1GD2zWCg2IW70dbT72zHNq0NP/TF4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN0PR10MB5960.namprd10.prod.outlook.com (2603:10b6:208:3cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Fri, 15 May
 2026 02:05:59 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9913.009; Fri, 15 May 2026
 02:05:59 +0000
To: =?utf-8?Q?Uwe_Kleine-K=C3=B6nig_=28The_Capable_Hub=29?=
 <u.kleine-koenig@baylibre.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: mvsas: Don't emit __LINE__ in debug messages
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260427174545.2014499-2-u.kleine-koenig@baylibre.com> ("Uwe
	=?utf-8?Q?Kleine-K=C3=B6nig?= (The Capable Hub)"'s message of "Mon, 27 Apr
 2026
	19:45:46 +0200")
Organization: Oracle Corporation
Message-ID: <yq1jyt55sw2.fsf@ca-mkp.ca.oracle.com>
References: <20260427174545.2014499-2-u.kleine-koenig@baylibre.com>
Date: Thu, 14 May 2026 22:05:58 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0039.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN0PR10MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: acd7fb0a-f69a-47c4-fe6a-08deb2268242
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	89QDGzA1/Nx6ZO68DDJ1JXmvguIZvogBRxNlla8p7GTlVO7FczztRmeaY3Oo/qLd/WIxWIM6IALSNYHWeOPu4jHsA71t2f7SOzRLhN/Tq1RpdjmLxoDLi3aLI3I4JJCPeoS6AT3Ycld4W0tGHA9IeV9ntBOfnLbyv0Bp/BOXm9A/h+tJPTRnkLSpCbvjV9+ddPBsuuhokIk9ZuaiADFgrk2Ngl9OyezsITnGqAG9+RMNScbjW4NLj7Afs9Yk9DJUnTDEvHTjj9sCwZK0pDBaTe1czrG6YCn1kt37usGIreCzymWUWvVjliYn+CQZ5XGo+rOT9zX93o5rX7PovM38MKuPiEd7kSikjOTwLVTVzKa+URQLYzC0HSI8GK5s1coDp9V1uNiGLmJZtSPauaT+q2F8DC6S73hM66or2+wtXLgC3iW62R4qs2M24+EWmbxbhUSqURHkgTfXAgRkC3k+2Ig6FaFic760bDZLFQ38pAiY4HckyisUwfH5D80WIosXBL6XZ9sS1laM/Xnsv1b2yl4yeOVsnxt8nkpaqZPZXTq1vYXNGFQDLfGKCpDQPlb9zrWBGgPkJ4Dps+AatIkJIrWQm4A3E2KYLfIidv3zFKOpJP/082TERf7zYld/Fngwn5qZFEQ92DPFIp23Lr1cYcBhHhScbZIBRwoOBmIORet3EconXc14OQmbjxgYgkH4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?57iHrfVw01e7sT1G/Uz1e9guvhiYXSyTpexS5qBKQFXPZ01Lt29JS65sHoAB?=
 =?us-ascii?Q?IP3SAto8vJkxjplCzTmUny3vgngD9JD1vPmvtnvr3ZHOZ7CL/4Sr5FVeAfHB?=
 =?us-ascii?Q?y3G+OuQGUyH4HA3N7OvCvLTdQ5H91sZME0w0/LMcUGsBij53gr2UtbanO0vU?=
 =?us-ascii?Q?kHqj9iZML8wO3yo4gllzzSHP+4ulnOmps1aPHBs6qpilWiuc1SqV4AObp+eo?=
 =?us-ascii?Q?C+gr4oQWBVVRKObZ1XY64jCc1wyH/crhFHnRsUAW3c5XCl5teUA65sDuVJV6?=
 =?us-ascii?Q?zq2k3INGby+VdjBR94Rr94kf6U2jyGNx82VAJugk+w5RQRPjhg423F9B3vm3?=
 =?us-ascii?Q?GcXspxQ4sGqQfDT/t1cWdvF+dvtBmdxGUyyMhlds4ob3uU6VEXIg450kxLoM?=
 =?us-ascii?Q?tQoFNquZ8nnLYmPnHwftjakMd6B5lX/a/xrCx2Xt8CsXC8soRXP13QmMbeWH?=
 =?us-ascii?Q?6A4+PSBBoKnwNmyd780JSTCE/P6UkpqT+Zjk0SVIWsimR2zt8ENah36eQxWy?=
 =?us-ascii?Q?4WxwEBcYznjiqkfgTKY4l+81Mt7cBozCWO6i4F6Mh0SyMNG6kV8mSbmR4bmO?=
 =?us-ascii?Q?p4n1hceW3B5o62yM1vYjLp8AjSdo1Du/AKmWXtRevIKft/w7B/HBzeXieRfE?=
 =?us-ascii?Q?rq94QsmxuzD0m34GVT8dNn7Ju+2bi+JDMh4qpxy4uFQJh+0ZMhIYq9rj+nUY?=
 =?us-ascii?Q?dFqE53W7wcb/XzBkO3TeMm7v8cG8kM3eyVICXv3xU6WY9gXCraVq8uB3fS0y?=
 =?us-ascii?Q?oWThe68+CiI7fJjSXcQNE8/YE4NVsMB568y9RX3N2MZI766FdTuvGZ8aaQNo?=
 =?us-ascii?Q?lR0tGaZjJdXZ6SVXkm+oR9Y8R3ePgNio6doM7oet92n28haep/1qIeqfxQQZ?=
 =?us-ascii?Q?zrNqoNJjUEVZraspFyf84Pl3Bpw9ZtnNTtQuq8L121FwI0jP+IM7NLRrQdB/?=
 =?us-ascii?Q?ETuPv0VC3fezcE8H+T57H7iaGTl0E8LTTAUcV7fgDIvQkv00Sq874WJu4o1S?=
 =?us-ascii?Q?QPdG/z7TgJooP4xVqiEUKWWNTAZqyRw6uxgwldMpLXOpbSuPs2jFnXK/S+yV?=
 =?us-ascii?Q?vDIpAAa8jnmePV/1a6HTx4GjPkfzL5Ky5eJ50ggJwUvZSxALgoD5VFAZYhsL?=
 =?us-ascii?Q?TuKDOu9TautPtNSX8JjD4fd3eX+aVx61V3XArEzmel2/qR54ZLBhuz08VnFF?=
 =?us-ascii?Q?Bfvtp8U4zFYv96TWRLlvNkKTil+VJRQOFH47+2/8sPC+fzSX4tADCetNB6ae?=
 =?us-ascii?Q?0nufIdxG5pnaShGsndPwl0JdiXuGNA4ol+5W8ONX4z//O6sl9t6IekFhUhFN?=
 =?us-ascii?Q?CsuIHpD7h1RzbyuryGJpC5wz4hTZmjGkLiCGumm420BA4xFuw3TlonI0vSLU?=
 =?us-ascii?Q?hAZKRqPFusomSH6vcg+4sg2t6nvKp3rwFNNC/n9i7NVMX9SUsaoyA0efryEM?=
 =?us-ascii?Q?xK8IMOqiXStqUkWrNa9q6IK8VkITLidKh13zRr/ObN3EpHEIA7OGYSvMfHFm?=
 =?us-ascii?Q?PKnbNjP3WI/ZUZkpZP8LAUjOx1zNAZR7jJavP2v2pr6bXlVxacUQN7NsGhB1?=
 =?us-ascii?Q?8BLf64hhFjeb4UenbygewvWoLnoYPvgL0leWCoKyJ+D9NszRikbsUO10MYlK?=
 =?us-ascii?Q?MVZerN52NRTvVjy0KDm+pqg1BiUxMtGxJsRLcEpTqqjo4GaTVN+0ms83lRwj?=
 =?us-ascii?Q?nAhi8P3DvFoiyG13hiPY0dOsh09wOkbt9bV+FDI5LA7sy0DzxJOHNOAfYB4B?=
 =?us-ascii?Q?HWRkVkaNCyNQwjh1GSllO+F232TrBcQ=3D?=
X-Exchange-RoutingPolicyChecked:
	GLoUb7x8Ik8LrrYrD6SIoDb+VAHI62J90tC8TNJokJXYsrJX0BtFxsIoR/Kc4teIwTfP2Ps14KJC72j+CxviDu2C6NlhT2i5n50eZX2+BFt8m157rhgEfBM5WWHPWkgLJsT7qeAtX+r8dTtUUD6mTr+9lD5BCwbeBCktmbiY7x/9bwn1WYHSWwbKQCWUiOYsM4rALHEr2GZ9QTJ1EWg2k3m77LdakJknhMG7vY78j7srWiUSmPjcQyJLKqqbGP0QNIJR5E09KYPYVKkutxWcU6+mf2y++0gzByLkzYrig3zl4kx9kznDrLdm+PlxsI1mWDlg78/EkBAePo4GgXJLzw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+IhINDmezT3txDtT15oq44nFSviadwCZvvik1gAd4EwW+pafrKUyAxWf2s6h00lM3/tXtL+2++UmIEkYtJUgbBcnrHre9zj00glnC0NTCtC/ps1kS03lE3B1ba3I1SQxnLOSpkjRCWLfvbPjy2KA6Itg/GxUPvOqB4PWPIvfK13Bqr4BdB9L57fDHVk82Gi5cNIldDc191RmXvBedewznzTGyPDCe8l33Dm+JbuhnmEPKr6miZApESs/c77A7dxWsNTHecZEGjhY+0ERt4sB/HEvyYoU8ZS5J3GXbVBH7RucMWCrMsAweZxHosmFq6LNyHSJzhMO53xl0PJc/SJgSYeBEvHaeoEHQn4y27SQ3lJw8CXgbQMiLRxESDfr1FbRP3e9q6Q1e+wQ9iKaEhseKgITX73nQeYYx8Q1Wn/N3Nm+usiKxIjVYzzYY4l5+YQBa5J4GBeNqqF9OrhvDoI1QpHf4gq+4XJtyAWDlecCIj63U5wY6RrCALrsCjbNzCmFhVuJR0exLsPU4NdNcCm2Ok3oVc3FTfRpFDliEmYcKmJ97PXEUJbsV4UOP8May6XYVQ+kwONykX3UJlrUTU/mwYQDjo5MX8nmE7YYoCTibYA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acd7fb0a-f69a-47c4-fe6a-08deb2268242
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 02:05:59.8105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /MmNwdUhrPElwomj3tEV4P0vE5ug41GBN641v6m8kE8sf2DRGTuCZRcpLy2ShDDd5amBXzN/KK4QIaa8gKQXUTFvZ2SxCKK/neq2RpHALLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5960
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_06,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=556 phishscore=0 bulkscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605150018
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDAxOCBTYWx0ZWRfX6LJ3F6T+4fjl
 Y+urSDy6QP0kLWvhbqRwzR/cmi2vnsIWuK6902Xb+yBpS/iswwk7wvCJHKpwjhH8/KK76iXTQpR
 wMpraN5yMpkkhbQ01ArRlJZJt2/FKo37VbGZO8l1i6KztTr6nZW/nUE28j5ZxEMTx2b7ARra2Qs
 Ao+dPF3wSLvG/VeA2OR2apiXhJgDcd8oOFpBI3Mz3om3uJCQMbYWzdY5DRdVFDsU4j1QCFzt+t9
 M7KFq43DPGQxV1VnXeVTsIA8/RQTWWdzNwioI57doIGcZDuC6LNLwkSQKSVRqoG2vQ8FrvLZ5cl
 G5t/1ebmKgm/6P//ZJ/hQE3oTWzgl24I1cwa2sFSaZfBwABFI7D51M2Q4XhUnhBVfKxo/WA/J6w
 pCjDnMf7Mm1wNXGmmRQDTOeke8a2jQtqkqcSe94UAIZNEQxWsAXLu/9z9B6NbOwbJ6TzOBbfWgw
 RE3fjHHIEaDqvBYDhPQ==
X-Authority-Analysis: v=2.4 cv=cfDiaHDM c=1 sm=1 tr=0 ts=6a067f8c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=Qd_XJmDTjCV-o7kNHBYA:9 a=zgiPjhLxNE0A:10
X-Proofpoint-ORIG-GUID: WUd847lbZKTw6-FxD6EfKKtC9-BukhJx
X-Proofpoint-GUID: WUd847lbZKTw6-FxD6EfKKtC9-BukhJx


Uwe,

> __LINE__ changes quite easily for cleanup commits. So when checking if a
> cleanup patch introduces changes to the resulting binary each usage of
> __LINE__ is source of annoyance.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
