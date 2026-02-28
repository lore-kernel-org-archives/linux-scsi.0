Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953FC175A76
	for <linux-scsi@vger.kernel.org>; Sat, 28 Feb 2026 22:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772317868; cv=fail; b=RYiKIIuRjmrNahv9ReguFKrsJL3l8DoqsklKYXAdUayh5JUf60i6l3gVY4zOtO9CFeY0dA3ybNNwbDhpIKaZWnigz+Q/lOse/+ayet5zxD8Fg6Z62jwzyBehOG6pkrtvrxS99jbyzQun1hlS1n7UPEfUvfGys2KxEJPDtBbh1Ps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772317868; c=relaxed/simple;
	bh=xDjokAJSbf0rF1yKS4GaQ15QjXmX9oZp3xi/pdgEBiU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=X4dG7tU/0OiPrsCcvDeskJx+0Btk5rKR2q71KAXUTgz5hR8lIvkM4R9dwSt4ol5O/1iu2mJe9iKWZ/b/UEt5qFWZbFwgkb4NNXlTd1leAfGQ+Bs1pDghuvAiBAdavGUAHcPnkv8qxgJ7abV7cBj3U8+xuNlvvWfLObCCeKrwrZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JQv8FFsW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XcCrQ6ZK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JQv8FFsW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XcCrQ6ZK"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61SLQeGs2145580;
	Sat, 28 Feb 2026 22:30:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XQ7rfkHT/CxpXTla3i
	VneUHzwz2NRFfIb8EvcWLpK2s=; b=JQv8FFsW3h2jHRTuPV/mqF2HqwKR7uX/Fk
	pMPIlTv+f9lRYob9lpGiuepnwpAyN4Uv/pST0igMYc9IVu5jNZWvqFf0ykRby+ZN
	21QvxXenVCjw5/uzlTmLaru6dYQWh7oaI1CHngcHHvuhdZYh8nxkAt23kABRmIXR
	dYeYHzhSCuUkhs/4z9PC5nVLggzsKP9CrwZLRdmj+RKJs0R4Y52wpOsRY5SQ46sb
	L9GcA7vBDoI/BNvmOMGsp8GEgAF30whn4qE4ndGsY1Y3CPNyvt3ljJv1ukw7oxsf
	kpCTx7o8bQNbvnz4Oa3kAHboT8sngIbNh4S3uXov3mOIxBVRsuEg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cksmdgm1e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Feb 2026 22:30:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61SM5k7p026778;
	Sat, 28 Feb 2026 22:30:55 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013013.outbound.protection.outlook.com [40.107.201.13])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt7bmp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Feb 2026 22:30:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P9oO0HqheTgVIny7tANQ14eETR2ZF7mS3CtIjMB00cee3sMYBWkGUJDh4n8lgSUxXIO8G0voYrFtBzVfRBa4yuNXxc5TJp8R22PHLc5O0v9W4Quz2Aol7wo08G41LrZQD2Sjsp0NRdtZ4TdkaSozbdBJrcPRqmrWD10IZK2sNWKaJEvnsGsf3ASycMUXUl0T7oI4iQcbYDT/nOpUc7P1dvNU1GN+CKs2i+NGrXeKqh2Hx1lVXwU5iL3MXegMPt3Mmm68JRxU+Nv3DVSUbJPusmZ0Q2EdYYhdIwAVaCQx0R3et6cxjhMs5upxtWEUxyT7Wr3rmBjXtK/i7tkv1bxN0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XQ7rfkHT/CxpXTla3iVneUHzwz2NRFfIb8EvcWLpK2s=;
 b=s+q6LaSyHhP4p3NaAOwQ6mzGtpasrdHx2QjPgLit4OeBCf69y8Gjo8z+259+8iPj2VpaV6aV9A+xPMkv5m9dDJQSabBMMXYZw0Dmkt37pVh885a7gF29XVIBNuPwZMVWPs73I2Qz88gUhB+qK5yOUoPNTd90/3JY3cvM1mNxc/AH5KokvDokRnYP4xcDH35GfFE65jkPl/GibQAHYHqqBnH3XqheWCVvMdq9YNEnJgemms2Ar4CkUPOtGw9LoFh7XBWTRhSdZ5GDGu0BHbYVMvXLio2nFxnNvtsJUo7HbrAqLmyM/MXlPDrwNIafQrAbfyN9cCFhGIZD/MjENQweUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQ7rfkHT/CxpXTla3iVneUHzwz2NRFfIb8EvcWLpK2s=;
 b=XcCrQ6ZKqOlvUT28AtIp0uMem+NsjzvU7OP13BwLHsdR8Qv8KYZlLto7JMk27TtQLh+tHil5XXS0toZV4eN5jvrJ/+/m4Y1gQ33wap19kBVvTM5DdiS7jFYbAyYI7f495ZUATbokJYnUoTvzS3HNfHVaDaFr4FO5ck2PbD3eFp4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB4944.namprd10.prod.outlook.com (2603:10b6:5:38d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Sat, 28 Feb
 2026 22:30:53 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9654.015; Sat, 28 Feb 2026
 22:30:53 +0000
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        Paul
 Ely <paul.ely@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: eliminate kernel-doc warnings in lpfc.h
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260224234954.3606638-1-rdunlap@infradead.org> (Randy Dunlap's
	message of "Tue, 24 Feb 2026 15:49:54 -0800")
Organization: Oracle Corporation
Message-ID: <yq1y0kc33hp.fsf@ca-mkp.ca.oracle.com>
References: <20260224234954.3606638-1-rdunlap@infradead.org>
Date: Sat, 28 Feb 2026 17:30:51 -0500
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0093.namprd03.prod.outlook.com
 (2603:10b6:610:cd::8) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB4944:EE_
X-MS-Office365-Filtering-Correlation-Id: 0570c0f6-bd51-4ff3-a4a1-08de7719082f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	Nh3TviBUjKrl7OE7XFEjcmEz3VFo6xBP3HvfSPIJpTJJF/7sXSaWf9O0cUcMWiOOkqaa0fT+LKIp+iAJhENQiLMZePoWrP2UwyUijdTJUDz9BFP28Zo92CIQE9aA2HclepAmgsSNd261Iwb3nkRarKuBr5JpHOd9B/afP97uDeN3SZB0I2OcMqy1omV8Muk3qlRs9O21k378TI9//et/KXIM3haf8K1qhJjYrzPuW8pKmpwFugxjI7vXUFqkqF4ye10rMuL74ub57UyWS23ZcHFfe0IRsyx80rF3+CytbFnEnGipNMbXKgU5YgmM6FkdzSrPmRsDc8fAArt6eKyIpfidQUXnyGkt9SKvUoatD8bnet1YNecbvN2T9paC3KnZvPEP7vjsbD5bJ1hr+vQbYdfpHbH7hLCvzXs/2lMG46ReCvaxzcUCW1rkQagAqn9j2ImTjpg7wvlf4KCuNtZpBHR/WJ34PrexGcPt76IbvufhizTgaCWS5A0DDYWiVPsS4NqEnHSznt+gCzdLtGjsT0A6U1eLFTMMr65FWvmOyL5tECVm5lGicPinj7Tb3yY0JWY8EGQDnFKStpt1D/xz0JR5KIhPCIpKP5xCr8h5fz562ycTEsNCouiPJ/cPqQzm5Wpyfc07+DWIRw+j3EBzL7UWvksJBc0dIiPDdo82zeoSyskjcbueh17ygeDHzZxuJj+2JAleN6z+f3sRpvN+QWqsNCCJtOHDzPHeA83J7rs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W2FLWWlXs3tjfXal1772t9WeHuA7c2bOHlZVzDcC0Gtfj2usMMiM7xbUHhfO?=
 =?us-ascii?Q?9BV4sONgYA6OjmP+aCq6t34nLR4O+gl28Xe1Z0+1rajGZRuM3t+Doohtajx6?=
 =?us-ascii?Q?mp2N7RdLnY0CLMH5zsgaWCNhBGhvR+clOFBn2Kva3o0NMCSU99Kj4DpQoQIR?=
 =?us-ascii?Q?EZrdk3FtI+AS31dU8OtJH260jssJswGSScfpCrbpyjrqr6pw/+ijAuUeXFOo?=
 =?us-ascii?Q?pBmi8ISuAxOIPcaHpd7mmT8R+EzBcZhrYZeiPGt18LUN7jCwj74fCMVmoRtV?=
 =?us-ascii?Q?lc+64uozWIcp6WirGm7lwiu/Z0t5vwWW3jRLrYyb07iVO0UNp3weBzdRMDbp?=
 =?us-ascii?Q?avTjTGYjyKBRkFY9x1+LzN91qmdZCP6SFa+UBYHhbk+els3utPggpgh98L2h?=
 =?us-ascii?Q?YIyvM8Tmq3SDt44H0lfbR8HXcqGQfHd8Ny/gjzjS25cydixIcFqiS/+bSYuj?=
 =?us-ascii?Q?2jBtrvwbQf69QD1zCGEIzXBjqKvPGrfUeLUJzBnicOPPnbXLaMCdM4FpgUaa?=
 =?us-ascii?Q?TTi/+mXnbmvpQHZJ6GK5K+O6cSRbtx2BaC+WUeTcDbeTuM0wc7MyS5cfReK4?=
 =?us-ascii?Q?vYMrufV3CNUf2//wQiyTKbQ74eGMiQwPeaTchiWvgjPSuEP3dvuVB8t63kbx?=
 =?us-ascii?Q?sRMxNpw8Yp8AKbW1ON6EO/xufOrUPxULNX+YwwNnJN0SOipMxNG2+Ec6D7z5?=
 =?us-ascii?Q?tVqjIn70jP1ycsllksWdbWDxzD1ksX8WqTvH5q4z4zQqMEX0KSNjJlREkKCg?=
 =?us-ascii?Q?rOn+kQifxmS57QWqfAYfAxpWJ8X6Niz0ff53I+Fd+yhPBOq6vJgc2aMkxlJU?=
 =?us-ascii?Q?QemobR/js5hpKuWaxWpcxJp5tohelAxmi2k8fMo1FCOn+SIqaTvwF4KOkw8N?=
 =?us-ascii?Q?ZATvjrgbiEdvTbKYOTn3mKNhQA5pu4omyKk3f/UgwGx4iSgIL4CWqTzHHjbJ?=
 =?us-ascii?Q?qN4nFM+Yn0PNBzeW1Un0mzs3rQEHwt/vQ35JxlaztCj519M0b0EaaZDj6BuF?=
 =?us-ascii?Q?YKODKKJF4i+KSIUWEer0Am0QShsiv/Lx/lkW4XhrO1SHNH8TInZlxtLxuNGQ?=
 =?us-ascii?Q?EcuK2pzhikTye4/3XEP27lZIbrWhNH2qtnciBMSWBrzSHC/Sg+y3SZF/Ae5Q?=
 =?us-ascii?Q?1yncVLSNLdBrfaM1dSGK813tWA9M/6c36kUjmQV0n0doBmha75tZF8GweO5/?=
 =?us-ascii?Q?FMGOH54BRZfmlXHv+zYgt07MwZfCzmlTTVlyM1AtIpj+41KW2hWuWdTHU/uJ?=
 =?us-ascii?Q?a1r3YTvIZQhHtwl/Br9GaZz/+pjosuSSLUdR+w3J63d6XV9ilBWz+E0gH6Xd?=
 =?us-ascii?Q?aeOQEy0PnGP+ZwhFHezHFo+RnBfY7O7ywMj63jB+dGUHBRyN0sG3mRwKOCWd?=
 =?us-ascii?Q?wAGiRfBHm/1k25u9h3IKIPw0t5LbVyTMwYnOpchXmKKlBuB2VAsWQZTf09LL?=
 =?us-ascii?Q?3BwDDcMRU3xwjfz3vUpdllS9GyB/9tvtTAgLhXyHaO/nEiEpwGai/0sVYM+O?=
 =?us-ascii?Q?WYzZdjv49R+W2vqRoeENHuUovSRpFT3uBuWJ/RBEXV2fGa3FlMiKfstYJoO2?=
 =?us-ascii?Q?fF9Yrd4Z7gZQdIcG8/2koeWIbKqmtBAf+Ubv6JSBYRs796koICXU+cUtSQto?=
 =?us-ascii?Q?SuNfTWjEAgvr7x/Ax/o65vk/7DpGRRxpijCi2FMlP8MtcCUVIu7c4iwZw/mF?=
 =?us-ascii?Q?Po4uXTjgLDu4JEax7BG7f2j3/dUML+daSGEXLhXTch0ZNDiDXQTnzZrJ26VW?=
 =?us-ascii?Q?sxkG3vvGmbBHq9U02YjrR7HU5dKL2/Y=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MXxXgmdyPPAvBUlTlWi8AMsKbY3d8M7SS2a+0Uwjg6xZ9BMmyvzZM1AkTh6RmeJc3M5HYimkjK2DG6o0nNdOd4Lo0zGsF4otvR1p5nJAUbsrLQ3GxTAZNOcPUujP3KYFZT7rqKQvgpLYvl/C1eWfKpQTgrG8cgmoC/2WUuE+DEBNxDwsh+3Uj1kSuQvndDSTRzQJPMdNVt+/KMHuzqAXuw1+cHpjl0QIAMkDIh2hxYMJ6ZwbrBklEzN2uTW2t3NAlNwd26NPfnMzYVx3VLoZclmZPj06kjpalJIZC5Gp4eKnKrAUMBYl/bv9DjmUlc5PExBuVDVJBwnBr7lzDRfdjN143CkxbUYg9KlJ6gHaASHAjClT6SjGGa/HPXFBmgMaOUd+pl5maBk8hvCBIy7+LSfsKlGoBjgfRq2NtoNiCCDslvGTjwHp/VsCFuTFD9HUEGDoaSaWM44qHfRMbA2pchgcG+7fWyb3HDXqgWu2Rtx8oaPY5UqxvR5JzML0FWc6dgx7jWsdfbPfnxclrmZnscCXyZwrxROHlonJSb+6Dt33em8ZwtEBWocqb4X6sn1tRLIDqEj4rhi76YJRQ2tr2raQNJsNWABsITV99E9Lrus=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0570c0f6-bd51-4ff3-a4a1-08de7719082f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2026 22:30:52.9786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MXJ9z0bGl2fxpyruHpHNPZGgcUxL0QsyQpWwqoiDeo/F9IgNnTgwKZcZE+826wwvFWblL1p8o34om0MmldNiEWsRIzf8ywSf72KnKdI9V+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4944
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=773 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602280210
X-Authority-Analysis: v=2.4 cv=a7k9NESF c=1 sm=1 tr=0 ts=69a36ca0 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=IaMn-9pjn3_zo1N6EaQA:9 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: gFJ5DNdhkhEStN3vbhv3HhfevQeM8BmX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI4MDIxMCBTYWx0ZWRfX7thZ+FIM3VnQ
 CQugaOfZ0b6HbqI9Bkoq5JN20EqM2cwGkuAiqszNcKhItgEPASYKLhDO+nmUc+8GR2kt9uplOA3
 H5JxVVaJCCckUZKbkzXCkZGFdWnwoJmoaM+8ktLz2X44H+pF96vpgyywjO3lxkfLOWRQBKXE6NP
 NnMG1sxk4dj4EM7J+ixNZDV7u2/3uEewNjwjoaJQ18abwtuyYMjY5Icz+fooCzXoIIKaXLG1V/U
 dNjFjizdFSUirpU3jgJNvL2/wdT1sCTcXaT404mYmzJ3dDomJt8LYkARIiK9Yo5vQjwl9r5kQL/
 Z14K05gItYGVqOU75Bx12dqu4XG9ANZrDlaB9wRvHD1gKqbz4HvZSom48+tGAWdplK3vnsGNh6+
 RM0FT6ll9gTc4AMrQQVyaIR2Us4xRNfVqEEoSOUKPT5QqbWcPiuOou1en1GmkiFo9/3iJMsTw3/
 yaESL5YS2/aUI2qjbFw==
X-Proofpoint-ORIG-GUID: gFJ5DNdhkhEStN3vbhv3HhfevQeM8BmX


Randy,

> Avoid all kernel-doc warnings in lpfc.h:
> - use the correct function parameter name
> - add a '*' to a kernel-doc line
> - repair the function Returns: comments

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
