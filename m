Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17193286D7E
	for <linux-scsi@vger.kernel.org>; Mon,  3 Nov 2025 02:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762138614; cv=fail; b=OYne3WmwYRBWOetc1D7Kq0gj5x7v3kkSMf91fRA+bAQsdtluZG4wEnG7bAsNIMXwME8tzTEyHT+aNkzj/CmgoaN5kDVF959FiyaIbpIVIWc0X8NVFxbcRpQsuBa3RVQgKtUE8RnkCv+if8XnEQjCQPoXErd8ASi9TwyjGY2bKhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762138614; c=relaxed/simple;
	bh=mAqeOc/Wrgg69w0Ice0apWB4xAW/+CFLKabRndPHdzU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=nt4mdRXXQu0mk7otbFInJM253gGoNauTvbhAqy6oHCx+xd7QiwTXlIU55+pSv/fyaKgIB/7JrbaNWuiaLPXKNAEMnxWi/bl8OKkJosGNcE8T8cH9lN/Xmvw+IzOcStLswxwhR/bsr/sQaXlWnAorUTYS6alU7ncJYI0naVyb+P4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=in3pGlhF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OoDHYGYM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="in3pGlhF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OoDHYGYM"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A32sjKJ002256;
	Mon, 3 Nov 2025 02:56:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Kx9D+yyBrnRNV357OF
	NAbivF0oChcMx0XbIohXH01mY=; b=in3pGlhFtKyNIwE1SDxiQDPNJc2sc/TQPC
	naTYS4A1OQQx/S4nXs5nC5dZ18emPJewb9HpPrm06oL2ZYtV3maV0ASdI6kRuGr1
	Ql40olN1Hm2KLeQ7616IW+CCHTBS/loHxHL8s5CeGd84fOV60stK7aorSILXBetw
	WaJcwcV/bXPNNOKgrDwuXkNj8GTWBigCC9PltCzVia8IGB81lRw+IDo+RHAyfEGh
	BNiNPQYqoDSPlkbASthU/BrMD/STQN44fWwraB7gvowy9L9F+u7R6tS+qyguJsxR
	+CGXbmOrfAfitNQoy1JN8Gy60hIE9wnbbIH8IKlS+z/0oXtStgbQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a6m14r013-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 02:56:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A2NoCIg020962;
	Mon, 3 Nov 2025 02:56:46 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010032.outbound.protection.outlook.com [52.101.61.32])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58n7jcds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 02:56:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L8cW8FySNlnK3qEZXTXNA2g5jDx5cNshImQ8w0lUA2YbvgNyaFLNc9ZzGcXmtkLfqNDsKkgGW0JF5W/0cr47gBSedj6DBsKCzUZuOdCIAyqtPLTiY0HGyoGaUNL5uMQ/0cQghfN2KBPdH8snzygb347jKGKpJgNolYwNOQNx8dVWUklaZZZwkJUDSe0zvQ01WYNp/0Q+vjFGTB62psZmLU5PX4MbIScQaeo+7sIETEOTrbjt+KxFwx2+O6CY5Mv/yF+aSNfyrXc67tzChy9YUxisVrx68LHePKiBQRo3diEFQrvP9ti0TKtKbx83bZi95QoexrhBow724IINyEmlxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kx9D+yyBrnRNV357OFNAbivF0oChcMx0XbIohXH01mY=;
 b=nXrd+GjtIcuPwACLAMx4Wkegwbzi7nC9iO3jotg0BKcz0b+DL2DUK9/ob6p0EqkicYLeSqNqJ7XHD/u7JvNGqHztL7U4OBIhjlOj5iHihrBt3O3eMR5Rn/nbvGWAfQ4Kt0ccj3GpLF17HXAFkQ7k91js3wP9jki5KwltOJCj/oPQbr1V2VG8hTOgRxfV4e10hTrxU0DHB89/R2mogabJH67egzfTsU4HLpBk5CBZ3Y7lS5hlJiJqc9Dmqra0er4KWvZQH+0IfccwbGEcBpMuhnxgGbjeJ2fSHlRqRSFA9i7BljOG9Yq5LJCw0TreJF3ZLngcxVoPVkkFoMv/TknWcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kx9D+yyBrnRNV357OFNAbivF0oChcMx0XbIohXH01mY=;
 b=OoDHYGYMOHdv353tSx5AFpoy+d6uOHC8NQVhWn4Mkq8m4I3K5nFVGtdoelZk4ZYp3dVrTrnfn+jytjI3l7r9uc5P2eeIEAJ6vmF+t4+CecY1yX/hqtXjOk8fjSBP9j1I3MIQgMZRukaUvonH+omURXricWbLCkL5Mp849qgY3Co=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO1PR10MB4689.namprd10.prod.outlook.com (2603:10b6:303:98::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Mon, 3 Nov
 2025 02:56:43 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 02:56:42 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: core: Remove unused code from scsi_sysfs.c
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251031220857.2917954-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Fri, 31 Oct 2025 15:08:56 -0700")
Organization: Oracle Corporation
Message-ID: <yq1a513su1t.fsf@ca-mkp.ca.oracle.com>
References: <20251031220857.2917954-1-bvanassche@acm.org>
Date: Sun, 02 Nov 2025 21:56:38 -0500
Content-Type: text/plain
X-ClientProxiedBy: MW4P220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::34) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO1PR10MB4689:EE_
X-MS-Office365-Filtering-Correlation-Id: f5d06199-d83b-4b8d-156e-08de1a849d62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NWOvyYXaYsimzu2g0p64gZOz0I/7iHrqQxhjQVacuXMuolvetodHsbQSci8d?=
 =?us-ascii?Q?8CGXxA+pS1FnZmX3zTKWHg8JOIlFM5j0zOlBJvwcvHZ6ARcYsJyoqTHWnLRB?=
 =?us-ascii?Q?kDhTjfISaCKTdZDIU9GnavmFMOD/63XAHgO7rzAX1is0k92VhZgjoSuuq6OB?=
 =?us-ascii?Q?Ps5YoWYPSXHJlxF3TdTu5A1rPfpM1SE234H8mBXu9JdGwIY0AL27NObHLk8Y?=
 =?us-ascii?Q?U8IwTHXLyIX9GpEKqueLbnt9Zb7uA+xlq5N1TqAWNnyHAb5PPFdZTTZSTroS?=
 =?us-ascii?Q?Ff5JdcH7TA2lgzNkf8D3f9/TVwxpA5tGYvHmLKY4v8VP7gTWvuHfXmoXhJN9?=
 =?us-ascii?Q?AYq2xmIY0pWfGloZIIpiJThVhqWJgN3/ckJ7KT2OLd2GG4VrGi5gM6J0SQ3F?=
 =?us-ascii?Q?I8V8IOOquI/RhRY6wbU4KuKgWwSZ3VBJoOiVR9bruqgNS1vUnrQ0YJXfidxc?=
 =?us-ascii?Q?m+Db0u25ZjENF80ASvHl8df9urKLKrXYKIpHTAGt0aRp/9TTqkaxOi+OEsuu?=
 =?us-ascii?Q?sAqyKiGm99g4//3rDyApcJNaz3fBP49f/mgmSHaDMFepwFBOL3834BL3qzHU?=
 =?us-ascii?Q?gf7HeInr7/NCxUIN6gwhxZkiIEdbGXu7HrOuJj+7UfN9lD4fneuqoQSZHK/Z?=
 =?us-ascii?Q?OwvakViGY9ZZ3Nj1riUROkGqLZYOJrdQYlmU1sw5tj1BzF3NWXh1MzbkB1sQ?=
 =?us-ascii?Q?GHAWZUgksu34iYVlz+nOFs/jKgRBjhqbJ2/gzMxatNBKR/umbLMRyPhkkj82?=
 =?us-ascii?Q?/p9g1/jbWhhRewQG2BgDDPYmtbaz933q3cPIgJV8E8p28rccN0aAIMAoub/+?=
 =?us-ascii?Q?Q2fcVrYNmkSEr0L/GPjjCw3i8UXY8NngA4l74LF7pznjQxW7ewrt9IJcKvX5?=
 =?us-ascii?Q?WEBxLse8veN8qqdGwbHmou3wjnp+s0V7Dp7FpnFJBleIX3DblO8AGrOsLLxn?=
 =?us-ascii?Q?5mOKn6ApG1C46xSW4BTlMtjamOZA1vXoON6jaavnd5IyIxAOZFJQsXr2xxdM?=
 =?us-ascii?Q?2qyfuqmydiNG7W5S6lBSg1DNApnWa7VHPiQ6Vn8oo6RO5jq6NYRcMOoXo5m/?=
 =?us-ascii?Q?eWcAJygzq4iNTXvMyijoDbvZg9eXrbs9XN2hD/5Mg9BS5H+obZjr4MyxOUwd?=
 =?us-ascii?Q?F6F7UUzJJ4sqdyQsQp2DzfXoKKkPTs6VUtYYHWKqnuqWOLRtZsoh/gTeHrr9?=
 =?us-ascii?Q?f5DVObrT7HeA0l8UIz9CRhQEmZCLD3Dm1GBq6zgdU27Su5JP5BWD4j0yVxJM?=
 =?us-ascii?Q?uaQTfxZCcBKUiN2jdx4ok8bvmXu+zhin5tS/i1xUin6m4HduhWK0K03v75Zj?=
 =?us-ascii?Q?WPfSQBwZMp8E9ieEzcKA0uklN7ipR77FBViwBakHytQ90qjKiFR97Ce8hS21?=
 =?us-ascii?Q?iQIHxzo/OmSnA2Cql49k8NlfpmdzrCP3U4f6SeeG6gK1pkGfdhMIS8lAGhx5?=
 =?us-ascii?Q?yFkmfCzf8x5S4gVjqBum/URWtj2nsmqg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mKxOx6o/y04gumQfXIudI1ByFNP8ee7ETTPVqKZ+xZnMDOPCo/po42f3KKWj?=
 =?us-ascii?Q?znfGDowG3snWaxlvXz3JLisqY6vBzMxqQXz/dllOmbHcDXbxmwLU2IT6Qqdk?=
 =?us-ascii?Q?Ap7YlQy1dkWQOcyg9UnNIfmj+L6ZuCIH9exKOP/PhvPZOe3jsZOT32GMt1ok?=
 =?us-ascii?Q?lZUWXvsPjVuPmvG0k6LU5u2iBcDJjsEVM+NEVUkMvfMdEI18c5uLMm9dFMAO?=
 =?us-ascii?Q?9rmVyCxrWIGaLzJh1wt4SFPaIBWL4aHnfCcVgqk/TrS3snjbdT8Ba7dgWfgd?=
 =?us-ascii?Q?aYnXb+FLTfT0whCqaTcmcPXStXi76dRarIBgIHtiwhFtoldiIhkz4WdzGZWE?=
 =?us-ascii?Q?3qPMUJN25qbNW06phoYuKGKiFVYKg+zR5PtLPpU1X8GIeLh1zpUC2T+iJw+P?=
 =?us-ascii?Q?/lKfSdomc4dEjT5wPlSMV6O8U2xOJm8D9N1mpqXtpAINTgcpmW0zkPZEtr3P?=
 =?us-ascii?Q?NAC8fwwOOLd1Qh6pluD6fRujRhViuipkr7w8y+loTHEtG5TZoQ3uDpZw3LAU?=
 =?us-ascii?Q?bEYSb0am5dEUGYxL2RyNBM6XRcGgc0YduTNhCVfIGS9hqAU865KQrZXn8aU6?=
 =?us-ascii?Q?RJ7ldXdE9JhLfvKrv4W4VvisuTdhToT8iMssnC7SjFem+/NvghHOUdRbBU/5?=
 =?us-ascii?Q?ikUdeEXXM4aCjFqU8y7jq86S2UGKhSDpwhC1k98pc/TU8j63/8mKJRuZCiXr?=
 =?us-ascii?Q?6YJY5+E3YGnnf7XxhqpjNrW5nZk/pxqzexHiznqzVHiwJgqYZAMEbJ55iXW/?=
 =?us-ascii?Q?mwV1L1pxZgSynsHyggCN5LfKU3aEfJ1P3X9D9OnvzBdHE0IpYwnTyohmQiUB?=
 =?us-ascii?Q?rxOXfqZilPsY6RQQro2ADHS7TnXxJ1NlrX5U1BPQKV4qXj0o6naCYEvJkr25?=
 =?us-ascii?Q?njaGfn6Oe9aigo3zMBZfwzTE468tJVAEv59Sj6eWt6sadcBfrglhjM3mJVrw?=
 =?us-ascii?Q?9KJswy+Y5bSuLqo5rnmJh8QeX+zlnH14NvGU2oktqsb9oqP/V+26X3vZxilK?=
 =?us-ascii?Q?adrCxm+Yo/B9qNjvZZ/7X6M8eqe6T8dCsq+YV38frBzJraJ+67nkIGrbbz6m?=
 =?us-ascii?Q?cCFrZdoi0Bu8bdj7vXn9XhknpMPTag19gka18L7LCb3jNdAnNBME4kmoEgAm?=
 =?us-ascii?Q?iG2MdSXFzE24eMM4X9oJnJRAEwGfFoNkgwA+c+r7i/VzLYOQUZu1GWgB+f25?=
 =?us-ascii?Q?d+CnrlWn2NMbDOsig5NX3R9kVeBVjNeTJ6uKMVO9LxoSXAJmnrB7//BU88v5?=
 =?us-ascii?Q?A8QC/qH1gcaHOgk4lueltDR5Tq5gim1iDG3c5J8Ee4bxJuDEgYXM7Xp8n8vL?=
 =?us-ascii?Q?qP+bQgPyGlNZ3XyQ4zrs6d4CW7ErVpoJUEcfQ2Nm5AopjwTyfW8gFf/6VK+H?=
 =?us-ascii?Q?VvSgronlBtD7El0R4XNU/A27xnc+deCCcHC17VUx5hdxT6rTTURq2MuUw/Np?=
 =?us-ascii?Q?koyVXQoEhCPhErtDSiql5mAuZHS0qLie7LsDVQ4nMYOTDF7+0T4miWfg/7mY?=
 =?us-ascii?Q?tyc2mB/LNT9n5TdNQuH1zq44tSD1TMUB8d5ozXOV3HBquxM63/jb8NKNvgVn?=
 =?us-ascii?Q?XfVn5YcubJV9jrrNHEXCj5i008GNywI+1u8P7BApC9Mhv9iFf4a0mwYbl/E3?=
 =?us-ascii?Q?LA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	L71jU6++YZ1UzCJX2skTDuW3vOg6wQecp63i9YCfp7zxUAKlyBNfo7GS3w91huSEhEXff25zrFGt5x7rDFE7lo8POZLT7qwFIhx8OKrSUBDaScdLvis/+2xbNKWauRjjbBsloCREFdd2+ry7cUO6Mald5Y7hEf/ZF/9j/iJBEsju/mlywo8Gg4O/7d3QVf0DNysVsdND059budIq3q8F00YsIf+vAWuf4tyHVkcsBczQ9yP2BxWQUvLqDbcw/62xprYdzV9z8DDKCmkmpaJBq3rH2sX0X54pHz/ph7VQcZzmgm/rtt56KBYywwas1m/YaHy+vdWZYzypLzCMeiS6fPqBPrWCt36KdNe8SMKG4dkL0D1cYOm5ey2L5kMSHip1jwRwsAj5qXjafIb8JCHyA8eUFY6GP19xWMDUlft7QM0Aui9MJCDbxsbMKS89yvGsXBPJLxREUFFw9XfxG0Hl5KDBjFrnOF5Z7G7i2MObVElsGwzxfiUEtmpo2w/XqnqqmcRiezoD6k9Fay8pLR/QGmWADbHoOt2wjTkIYQXi5i0EFEUBTF2xV4HRqN68GNAxvyPSNBU08MorDhomj/ioJfqj3YKFSOsk9ueO7FEJZVw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5d06199-d83b-4b8d-156e-08de1a849d62
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 02:56:41.8801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nSN+SAhBXIaG0L45b3RNGzIF1swokQ6QXDmLbFedB+QhWRve5C/ZJLrucMMeEHGZGhSB21VC7cir+O6HNlXl83oouhMQ5NEqaupKjsn1ceE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-02_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=839
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030024
X-Proofpoint-ORIG-GUID: uDLJgM3alGehSk55BQalAeoqYkmGylrd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDAyNSBTYWx0ZWRfX3Xk7DflEUZHe
 laesMyp/TnMXhgOgQ6Ut0vkoMV5Dgpwm6HNQwqP1q0v6EdalOaKr+/+f+Pxu6ZOeOlrvG8PnD/T
 IpaA+Hb8jf4Na4FeAhS3HsOI/yoFeZESS3+7Nd1Yl2EoL6xSBGCcrFZa9GifUewiVcIfFHCWmvL
 29s9omYW0juwNUzfASDGBErrHKr1iAy7BstfE2XXZ7rlyFiZhMndcvEDO7Om4utZoOHh3J+GLkf
 X6FmWHOqCKS7+VSfN1Oj171rDry8nNKKY7sY8hmVLBPp8tTwGn0KYMpAHn7fMjBiB7/RrxlYG/1
 TfP/aKGEGmb9veQchlFjq+zrR5J0D2V1IVG67xSb8qn96YjM6obNQ80TdHQ7XsXI6NaXxmNpqI5
 fh7BUnUmv78i/EqVcIUUNXcXibs2zw==
X-Authority-Analysis: v=2.4 cv=cNftc1eN c=1 sm=1 tr=0 ts=690819ef cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=UnRImqR3Y23lIZfXygAA:9
X-Proofpoint-GUID: uDLJgM3alGehSk55BQalAeoqYkmGylrd


Bart,

> Remove unused code since we do not keep unused code in the Linux
> kernel.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
